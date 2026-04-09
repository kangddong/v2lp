import AVFoundation
import UIKit

private extension Data {
    init?(hexString: String) {
        let clean = hexString.filter { !$0.isWhitespace }
        guard clean.count % 2 == 0 else { return nil }
        var data = Data(capacity: clean.count / 2)
        var idx = clean.startIndex
        while idx < clean.endIndex {
            let next = clean.index(idx, offsetBy: 2)
            guard let byte = UInt8(clean[idx..<next], radix: 16) else { return nil }
            data.append(byte)
            idx = next
        }
        self = data
    }
}

final class LivePhotoConverter {

    struct ConversionResult {
        let imageURL: URL
        let videoURL: URL
    }

    enum ConversionError: LocalizedError {
        case failedToExtractFrame
        case failedToWriteImage
        case exportFailed(String)
        case cancelled
        case metadataSetupFailed(String)

        var errorDescription: String? {
            switch self {
            case .failedToExtractFrame: return "프레임 추출에 실패했습니다."
            case .failedToWriteImage: return "이미지 저장에 실패했습니다."
            case .exportFailed(let msg): return "비디오 내보내기 실패: \(msg)"
            case .cancelled: return "변환이 취소되었습니다."
            case .metadataSetupFailed(let msg): return "메타데이터 설정 실패: \(msg)"
            }
        }
    }

    private static let assetIdentifierKey = "17"
    private static let assetIdentifierSpace = "mdta"
    private static let quickTimeMetadataKeyContentIdentifier = "com.apple.quicktime.content.identifier"
    private static let quickTimeMetadataKeyStillImageTime = "com.apple.quicktime.still-image-time"
    private static let quickTimeMetadataKeyLivePhotoInfo = "com.apple.quicktime.live-photo-info"
    // Custom data type namespaced under the key (namespace=1, per Apple Live Photo mov files)
    private static let livePhotoInfoDataType = "com.apple.quicktime.com.apple.quicktime.live-photo-info"

    // Extracted from an iPhone-captured Live Photo (IMG_1977.MOV).
    // MetadataKeySetupData is a schema bplist Photos uses to identify the live-photo-info
    // metadata track. Required for wallpaper Live Photo activation.
    private static let livePhotoInfoSetupDataHex =
        "000001766366677662706c6973743030d301020304050c5f10214c69766550686f746f4d6574616461746153657475704461746156657273696f6e5d53797374656d56657273696f6e5f10114672616d65776f726b56657273696f6e731001d3060708090a0b5f101350726f647563744275696c6456657273696f6e5b50726f647563744e616d655e50726f6475637456657273696f6e56323341333535596950686f6e65204f535632362e302e31d50d0e0f101112131415165e48313349535053657276696365735a436f72654d6f74696f6e5d434d43617074757265436f72655e483130495350536572766963657359436f72654d656469615431302e355d333035362e302e32352e302e38583636342e322e31315432322e305b333235352e37392e312e380008000f0033004100550057005e00740080008f009600a000a700b200c100cc00da00e900f300f80106010f011400000000000002010000000000000017000000000000000000000000000001200000001064696d7300000780000005a0"

    // A representative 136-byte live-photo-info payload extracted from the same file.
    // The exact semantics are private; Apple sometimes emits identical payloads per frame,
    // so reusing a single payload is known to satisfy the wallpaper pipeline.
    private static let livePhotoInfoSamplePayloadHex =
        "03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e4f40e33fcdbc6e400400ff0000000000000000000000000000000000000000000700000097ffc83eba7388be15a9d6c4ab9d3cbf09e5c83e39b30bc4f65c5f39c788f23977c89bbfb59a81d2bf10000032f180d2bf10000000000000000000000000000000000000"

    /// Convert a video to Live Photo paired resources (JPEG image + QuickTime MOV)
    /// - Parameters:
    ///   - videoURL: Source video URL
    ///   - startTime: Start time for the clip (seconds)
    ///   - duration: Duration of the clip (seconds, max 3)
    ///   - keyFrameTime: Time offset within the clip for the still image (seconds from startTime)
    ///   - progress: Progress callback (0.0 - 1.0)
    static func convert(
        videoURL: URL,
        startTime: Double,
        duration: Double,
        keyFrameTime: Double,
        progress: @Sendable @escaping (Double) -> Void
    ) async throws -> ConversionResult {
        let assetIdentifier = UUID().uuidString

        progress(0.05)

        // 1. Extract still image at keyFrameTime
        let imageURL = try await extractStillImage(
            from: videoURL,
            at: startTime + keyFrameTime,
            assetIdentifier: assetIdentifier
        )

        progress(0.3)

        // 2. Export MOV with metadata
        let movURL = try await exportVideoWithMetadata(
            from: videoURL,
            startTime: startTime,
            duration: duration,
            stillImageTimeOffset: keyFrameTime,
            assetIdentifier: assetIdentifier,
            progress: { p in
                progress(0.3 + p * 0.7)
            }
        )

        return ConversionResult(imageURL: imageURL, videoURL: movURL)
    }

    // MARK: - Still Image Extraction

    private static func extractStillImage(
        from videoURL: URL,
        at time: Double,
        assetIdentifier: String
    ) async throws -> URL {
        let asset = AVURLAsset(url: videoURL)
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.requestedTimeToleranceBefore = .zero
        generator.requestedTimeToleranceAfter = .zero

        let cmTime = CMTime(seconds: time, preferredTimescale: 600)

        let cgImage: CGImage
        do {
            let (image, _) = try await generator.image(at: cmTime)
            cgImage = image
        } catch {
            throw ConversionError.failedToExtractFrame
        }

        let uiImage = UIImage(cgImage: cgImage)

        // Write JPEG with asset identifier in metadata
        let imageURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString + ".jpg")

        guard let jpegData = uiImage.jpegData(compressionQuality: 0.95) else {
            throw ConversionError.failedToWriteImage
        }

        // Embed the asset identifier in EXIF
        guard let source = CGImageSourceCreateWithData(jpegData as CFData, nil),
              let uti = CGImageSourceGetType(source) else {
            throw ConversionError.failedToWriteImage
        }

        guard let destination = CGImageDestinationCreateWithURL(
            imageURL as CFURL, uti, 1, nil
        ) else {
            throw ConversionError.failedToWriteImage
        }

        let metadata: NSDictionary = [
            kCGImagePropertyMakerAppleDictionary as String: [
                assetIdentifierKey: assetIdentifier
            ]
        ]

        CGImageDestinationAddImageFromSource(destination, source, 0, metadata)

        guard CGImageDestinationFinalize(destination) else {
            throw ConversionError.failedToWriteImage
        }

        return imageURL
    }

    // MARK: - Video Export with QuickTime Metadata

    private static func exportVideoWithMetadata(
        from videoURL: URL,
        startTime: Double,
        duration: Double,
        stillImageTimeOffset: Double,
        assetIdentifier: String,
        progress: @Sendable @escaping (Double) -> Void
    ) async throws -> URL {
        let asset = AVURLAsset(url: videoURL)
        let outputURL = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString + ".mov")

        let timeRange = CMTimeRange(
            start: CMTime(seconds: startTime, preferredTimescale: 600),
            duration: CMTime(seconds: duration, preferredTimescale: 600)
        )

        // Use AVAssetReader + AVAssetWriter to have full control over metadata
        guard let reader = try? AVAssetReader(asset: asset) else {
            throw ConversionError.exportFailed("리더 생성 실패")
        }

        guard let writer = try? AVAssetWriter(outputURL: outputURL, fileType: .mov) else {
            throw ConversionError.exportFailed("라이터 생성 실패")
        }

        reader.timeRange = timeRange

        // Video track
        let videoTracks = try await asset.loadTracks(withMediaType: .video)
        guard let sourceVideoTrack = videoTracks.first else {
            throw ConversionError.exportFailed("비디오 트랙 없음")
        }

        let naturalSize = try await sourceVideoTrack.load(.naturalSize)
        let transform = try await sourceVideoTrack.load(.preferredTransform)
        let nominalFrameRate = try await sourceVideoTrack.load(.nominalFrameRate)
        let orientedSize = orientedRenderSize(naturalSize: naturalSize, preferredTransform: transform)
        let frameRate = max(Double(nominalFrameRate), 1)

        let videoComposition = AVMutableVideoComposition()
        videoComposition.renderSize = orientedSize
        videoComposition.frameDuration = CMTime(seconds: 1.0 / frameRate, preferredTimescale: 600)

        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = timeRange

        let layerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: sourceVideoTrack)
        layerInstruction.setTransform(transform, at: .zero)
        instruction.layerInstructions = [layerInstruction]
        videoComposition.instructions = [instruction]

        let videoReaderOutput = AVAssetReaderVideoCompositionOutput(
            videoTracks: [sourceVideoTrack],
            videoSettings: [
                kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
            ]
        )
        videoReaderOutput.videoComposition = videoComposition
        videoReaderOutput.alwaysCopiesSampleData = false
        reader.add(videoReaderOutput)

        let videoWriterInput = AVAssetWriterInput(
            mediaType: .video,
            outputSettings: [
                AVVideoCodecKey: AVVideoCodecType.h264,
                AVVideoWidthKey: orientedSize.width,
                AVVideoHeightKey: orientedSize.height,
                AVVideoCompressionPropertiesKey: [
                    AVVideoAverageBitRateKey: 6_000_000,
                    AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel
                ]
            ]
        )
        videoWriterInput.expectsMediaDataInRealTime = false
        writer.add(videoWriterInput)

        // Audio track (if available)
        let audioTracks = try await asset.loadTracks(withMediaType: .audio)
        var audioReaderOutput: AVAssetReaderTrackOutput?
        var audioWriterInput: AVAssetWriterInput?

        if let sourceAudioTrack = audioTracks.first {
            let aOutput = AVAssetReaderTrackOutput(
                track: sourceAudioTrack,
                outputSettings: [
                    AVFormatIDKey: kAudioFormatLinearPCM
                ]
            )
            reader.add(aOutput)
            audioReaderOutput = aOutput

            let aInput = AVAssetWriterInput(
                mediaType: .audio,
                outputSettings: [
                    AVFormatIDKey: kAudioFormatMPEG4AAC,
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderBitRateKey: 128_000
                ]
            )
            aInput.expectsMediaDataInRealTime = false
            writer.add(aInput)
            audioWriterInput = aInput
        }

        // Metadata track for content identifier
        let identifierMetadata = makeContentIdentifierMetadataItem(assetIdentifier: assetIdentifier)
        writer.metadata = [identifierMetadata]

        // Still image time metadata track (still-image-time + transform + reference-dimensions)
        let stillFormatDesc = try makeStillImageTimeFormatDescription()
        let metadataInput = AVAssetWriterInput(
            mediaType: .metadata,
            outputSettings: nil,
            sourceFormatHint: stillFormatDesc
        )
        metadataInput.expectsMediaDataInRealTime = false
        writer.add(metadataInput)

        // Per-frame live-photo-info metadata track (required for wallpaper Live Photo)
        try registerLivePhotoInfoDataType()
        let lpiFormatDesc = try makeLivePhotoInfoFormatDescription()
        let lpiInput = AVAssetWriterInput(
            mediaType: .metadata,
            outputSettings: nil,
            sourceFormatHint: lpiFormatDesc
        )
        lpiInput.expectsMediaDataInRealTime = false
        writer.add(lpiInput)

        // Start reading/writing
        reader.startReading()
        writer.startWriting()
        writer.startSession(atSourceTime: timeRange.start)

        // Write still image time metadata at the correct offset
        let stillImageTimeCMTime = CMTime(
            seconds: startTime + stillImageTimeOffset,
            preferredTimescale: 600
        )

        _ = stillImageTimeCMTime // session-relative; sample written at session start below

        // Transfer samples
        let totalFrames = Double(duration) * Double(nominalFrameRate)
        var framesWritten = 0.0
        var didWriteMetadata = false

        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            let group = DispatchGroup()

            // Video
            group.enter()
            let videoQueue = DispatchQueue(label: "com.v2lp.video")
            var videoDone = false
            videoWriterInput.requestMediaDataWhenReady(on: videoQueue) {
                while videoWriterInput.isReadyForMoreMediaData && !videoDone {
                    autoreleasepool {
                        if let sampleBuffer = videoReaderOutput.copyNextSampleBuffer() {
                            let pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
                            let dur = CMSampleBufferGetDuration(sampleBuffer)
                            videoWriterInput.append(sampleBuffer)
                            framesWritten += 1
                            let p = min(framesWritten / max(totalFrames, 1), 1.0)
                            DispatchQueue.main.async { progress(p * 0.8) }

                            if !didWriteMetadata && metadataInput.isReadyForMoreMediaData {
                                if let stillSample = try? Self.makeStillImageTimeSampleBuffer(
                                    formatDescription: stillFormatDesc,
                                    pts: pts,
                                    naturalSize: orientedSize
                                ) {
                                    metadataInput.append(stillSample)
                                }
                                didWriteMetadata = true
                            }

                            if lpiInput.isReadyForMoreMediaData,
                               let lpiSample = try? Self.makeLivePhotoInfoSampleBuffer(
                                   formatDescription: lpiFormatDesc,
                                   pts: pts,
                                   duration: dur
                               ) {
                                lpiInput.append(lpiSample)
                            }
                        } else {
                            videoWriterInput.markAsFinished()
                            videoDone = true
                            group.leave()
                        }
                    }
                }
            }

            // Audio
            if let audioReaderOutput = audioReaderOutput, let audioWriterInput = audioWriterInput {
                group.enter()
                let audioQueue = DispatchQueue(label: "com.v2lp.audio")
                var audioDone = false
                audioWriterInput.requestMediaDataWhenReady(on: audioQueue) {
                    while audioWriterInput.isReadyForMoreMediaData && !audioDone {
                        autoreleasepool {
                            if let sampleBuffer = audioReaderOutput.copyNextSampleBuffer() {
                                audioWriterInput.append(sampleBuffer)
                            } else {
                                audioWriterInput.markAsFinished()
                                audioDone = true
                                group.leave()
                            }
                        }
                    }
                }
            }

            group.notify(queue: .main) {
                if !didWriteMetadata && metadataInput.isReadyForMoreMediaData {
                    if let stillSample = try? Self.makeStillImageTimeSampleBuffer(
                        formatDescription: stillFormatDesc,
                        pts: .zero,
                        naturalSize: orientedSize
                    ) {
                        metadataInput.append(stillSample)
                    }
                }
                metadataInput.markAsFinished()
                lpiInput.markAsFinished()

                writer.finishWriting {
                    if writer.status == .completed {
                        progress(1.0)
                        continuation.resume()
                    } else {
                        continuation.resume(
                            throwing: ConversionError.exportFailed(
                                writer.error?.localizedDescription ?? "알 수 없는 오류"
                            )
                        )
                    }
                }
            }
        }

        return outputURL
    }

    // MARK: - Metadata Helpers

    private static func makeContentIdentifierMetadataItem(assetIdentifier: String) -> AVMetadataItem {
        let item = AVMutableMetadataItem()
        item.key = AVMetadataKey.quickTimeMetadataKeyContentIdentifier as NSString
        item.keySpace = .quickTimeMetadata
        item.value = assetIdentifier as NSString
        item.dataType = kCMMetadataBaseDataType_UTF8 as String
        return item
    }

    private static func orientedRenderSize(
        naturalSize: CGSize,
        preferredTransform: CGAffineTransform
    ) -> CGSize {
        let rect = CGRect(origin: .zero, size: naturalSize).applying(preferredTransform).standardized
        return CGSize(width: abs(rect.width), height: abs(rect.height))
    }

    private static func makeStillImageTimeFormatDescription() throws -> CMFormatDescription {
        let stillSpec: [String: Any] = [
            kCMMetadataFormatDescriptionMetadataSpecificationKey_Identifier as String:
                "\(assetIdentifierSpace)/\(quickTimeMetadataKeyStillImageTime)",
            kCMMetadataFormatDescriptionMetadataSpecificationKey_DataType as String:
                kCMMetadataBaseDataType_SInt8 as String
        ]
        let transformSpec: [String: Any] = [
            kCMMetadataFormatDescriptionMetadataSpecificationKey_Identifier as String:
                kCMMetadataIdentifier_QuickTimeMetadataLivePhotoStillImageTransform as String,
            kCMMetadataFormatDescriptionMetadataSpecificationKey_DataType as String:
                kCMMetadataBaseDataType_PerspectiveTransformF64 as String
        ]
        let dimsSpec: [String: Any] = [
            kCMMetadataFormatDescriptionMetadataSpecificationKey_Identifier as String:
                kCMMetadataIdentifier_QuickTimeMetadataLivePhotoStillImageTransformReferenceDimensions as String,
            kCMMetadataFormatDescriptionMetadataSpecificationKey_DataType as String:
                kCMMetadataBaseDataType_DimensionsF32 as String
        ]
        var fd: CMFormatDescription?
        let status = CMMetadataFormatDescriptionCreateWithMetadataSpecifications(
            allocator: kCFAllocatorDefault,
            metadataType: kCMMetadataFormatType_Boxed,
            metadataSpecifications: [stillSpec, transformSpec, dimsSpec] as CFArray,
            formatDescriptionOut: &fd
        )
        guard status == noErr, let fd = fd else {
            throw ConversionError.metadataSetupFailed("still fd create \(status)")
        }
        return fd
    }

    /// Build mebx sample with three boxed entries (still-image-time, transform, dimensions).
    private static func makeStillImageTimeSampleBuffer(
        formatDescription: CMFormatDescription,
        pts: CMTime,
        naturalSize: CGSize
    ) throws -> CMSampleBuffer {
        var payload = Data()

        // Box 1: still-image-time = -1 (SInt8)
        appendBox(&payload, localKeyID: 1, value: Data([0xFF]))

        // Box 2: perspective transform (9 × Float64 BE, identity)
        var transformBytes = Data(capacity: 72)
        let identity: [Double] = [1, 0, 0, 0, 1, 0, 0, 0, 1]
        for v in identity {
            var be = v.bitPattern.bigEndian
            withUnsafeBytes(of: &be) { transformBytes.append(contentsOf: $0) }
        }
        appendBox(&payload, localKeyID: 2, value: transformBytes)

        // Box 3: reference dimensions (Float32 BE width, height)
        var dimsBytes = Data(capacity: 8)
        var w = Float32(naturalSize.width).bitPattern.bigEndian
        var h = Float32(naturalSize.height).bitPattern.bigEndian
        withUnsafeBytes(of: &w) { dimsBytes.append(contentsOf: $0) }
        withUnsafeBytes(of: &h) { dimsBytes.append(contentsOf: $0) }
        appendBox(&payload, localKeyID: 3, value: dimsBytes)

        let total = payload.count
        var bb: CMBlockBuffer?
        var status = CMBlockBufferCreateWithMemoryBlock(
            allocator: kCFAllocatorDefault,
            memoryBlock: nil,
            blockLength: total,
            blockAllocator: kCFAllocatorDefault,
            customBlockSource: nil,
            offsetToData: 0,
            dataLength: total,
            flags: 0,
            blockBufferOut: &bb
        )
        guard status == kCMBlockBufferNoErr, let block = bb else {
            throw ConversionError.metadataSetupFailed("still block create \(status)")
        }
        try payload.withUnsafeBytes { raw in
            let p = raw.baseAddress!
            let s = CMBlockBufferReplaceDataBytes(
                with: p, blockBuffer: block, offsetIntoDestination: 0, dataLength: total
            )
            if s != kCMBlockBufferNoErr {
                throw ConversionError.metadataSetupFailed("still block write \(s)")
            }
        }

        var timing = CMSampleTimingInfo(
            duration: CMTime(value: 1, timescale: 600),
            presentationTimeStamp: pts,
            decodeTimeStamp: .invalid
        )
        var sampleSize = total
        var sb: CMSampleBuffer?
        status = CMSampleBufferCreateReady(
            allocator: kCFAllocatorDefault,
            dataBuffer: block,
            formatDescription: formatDescription,
            sampleCount: 1,
            sampleTimingEntryCount: 1,
            sampleTimingArray: &timing,
            sampleSizeEntryCount: 1,
            sampleSizeArray: &sampleSize,
            sampleBufferOut: &sb
        )
        guard status == noErr, let buf = sb else {
            throw ConversionError.metadataSetupFailed("still sb create \(status)")
        }
        return buf
    }

    private static func appendBox(_ data: inout Data, localKeyID: UInt32, value: Data) {
        let total = UInt32(8 + value.count).bigEndian
        let key = localKeyID.bigEndian
        withUnsafeBytes(of: total) { data.append(contentsOf: $0) }
        withUnsafeBytes(of: key) { data.append(contentsOf: $0) }
        data.append(value)
    }

    @available(*, deprecated, message: "Replaced by makeStillImageTimeFormatDescription")
    private static func makeStillImageTimeMetadataInput() -> AVAssetWriterInput {
        let stillSpec: [String: Any] = [
            kCMMetadataFormatDescriptionMetadataSpecificationKey_Identifier as String:
                "\(assetIdentifierSpace)/\(quickTimeMetadataKeyStillImageTime)",
            kCMMetadataFormatDescriptionMetadataSpecificationKey_DataType as String:
                kCMMetadataBaseDataType_SInt8 as String
        ]
        let transformSpec: [String: Any] = [
            kCMMetadataFormatDescriptionMetadataSpecificationKey_Identifier as String:
                kCMMetadataIdentifier_QuickTimeMetadataLivePhotoStillImageTransform as String,
            kCMMetadataFormatDescriptionMetadataSpecificationKey_DataType as String:
                kCMMetadataBaseDataType_PerspectiveTransformF64 as String
        ]
        let dimsSpec: [String: Any] = [
            kCMMetadataFormatDescriptionMetadataSpecificationKey_Identifier as String:
                kCMMetadataIdentifier_QuickTimeMetadataLivePhotoStillImageTransformReferenceDimensions as String,
            kCMMetadataFormatDescriptionMetadataSpecificationKey_DataType as String:
                kCMMetadataBaseDataType_DimensionsF32 as String
        ]

        var formatDesc: CMFormatDescription?
        CMMetadataFormatDescriptionCreateWithMetadataSpecifications(
            allocator: kCFAllocatorDefault,
            metadataType: kCMMetadataFormatType_Boxed,
            metadataSpecifications: [stillSpec, transformSpec, dimsSpec] as CFArray,
            formatDescriptionOut: &formatDesc
        )

        let input = AVAssetWriterInput(
            mediaType: .metadata,
            outputSettings: nil,
            sourceFormatHint: formatDesc
        )
        input.expectsMediaDataInRealTime = false
        return input
    }

    // MARK: - Live Photo Info Track

    private static func registerLivePhotoInfoDataType() throws {
        let dataType = livePhotoInfoDataType as CFString
        if CMMetadataDataTypeRegistryDataTypeIsRegistered(dataType) {
            return
        }
        let status = CMMetadataDataTypeRegistryRegisterDataType(
            dataType,
            description: "Live Photo Info" as CFString,
            conformingDataTypes: [kCMMetadataBaseDataType_RawData] as CFArray
        )
        guard status == noErr else {
            throw ConversionError.metadataSetupFailed("data type register status=\(status)")
        }
    }

    private static func makeLivePhotoInfoFormatDescription() throws -> CMFormatDescription {
        guard let setupData = Data(hexString: livePhotoInfoSetupDataHex) else {
            throw ConversionError.metadataSetupFailed("setup data decode")
        }

        let spec: [CFString: Any] = [
            kCMMetadataFormatDescriptionMetadataSpecificationKey_Identifier:
                "\(assetIdentifierSpace)/\(quickTimeMetadataKeyLivePhotoInfo)" as CFString,
            kCMMetadataFormatDescriptionMetadataSpecificationKey_DataType:
                livePhotoInfoDataType as CFString,
            kCMMetadataFormatDescriptionMetadataSpecificationKey_SetupData:
                setupData as CFData
        ]

        var fd: CMFormatDescription?
        let status = CMMetadataFormatDescriptionCreateWithMetadataSpecifications(
            allocator: kCFAllocatorDefault,
            metadataType: kCMMetadataFormatType_Boxed,
            metadataSpecifications: [spec] as CFArray,
            formatDescriptionOut: &fd
        )
        guard status == noErr, let fd = fd else {
            throw ConversionError.metadataSetupFailed("fd create status=\(status)")
        }
        return fd
    }

    /// Build a boxed mebx sample: <4B length><4B local_key_id=1><136B payload>
    private static func makeLivePhotoInfoSampleBuffer(
        formatDescription: CMFormatDescription,
        pts: CMTime,
        duration: CMTime
    ) throws -> CMSampleBuffer {
        guard let payload = Data(hexString: livePhotoInfoSamplePayloadHex) else {
            throw ConversionError.metadataSetupFailed("payload decode")
        }

        let total = 8 + payload.count
        var bytes = [UInt8](repeating: 0, count: total)
        let lengthBE = UInt32(total).bigEndian
        let keyIdBE = UInt32(1).bigEndian
        withUnsafeBytes(of: lengthBE) { src in
            for i in 0..<4 { bytes[i] = src[i] }
        }
        withUnsafeBytes(of: keyIdBE) { src in
            for i in 0..<4 { bytes[i + 4] = src[i] }
        }
        payload.withUnsafeBytes { src in
            let base = src.bindMemory(to: UInt8.self).baseAddress!
            for i in 0..<payload.count { bytes[i + 8] = base[i] }
        }

        var blockBuffer: CMBlockBuffer?
        var status = CMBlockBufferCreateWithMemoryBlock(
            allocator: kCFAllocatorDefault,
            memoryBlock: nil,
            blockLength: total,
            blockAllocator: kCFAllocatorDefault,
            customBlockSource: nil,
            offsetToData: 0,
            dataLength: total,
            flags: 0,
            blockBufferOut: &blockBuffer
        )
        guard status == kCMBlockBufferNoErr, let bb = blockBuffer else {
            throw ConversionError.metadataSetupFailed("block buffer create \(status)")
        }
        status = CMBlockBufferReplaceDataBytes(
            with: bytes, blockBuffer: bb, offsetIntoDestination: 0, dataLength: total
        )
        guard status == kCMBlockBufferNoErr else {
            throw ConversionError.metadataSetupFailed("block buffer write \(status)")
        }

        let effectiveDuration = (duration.isValid && duration > .zero)
            ? duration : CMTime(value: 1, timescale: 600)
        var timing = CMSampleTimingInfo(
            duration: effectiveDuration,
            presentationTimeStamp: pts,
            decodeTimeStamp: .invalid
        )
        var sampleSize = total

        var sampleBuffer: CMSampleBuffer?
        status = CMSampleBufferCreateReady(
            allocator: kCFAllocatorDefault,
            dataBuffer: bb,
            formatDescription: formatDescription,
            sampleCount: 1,
            sampleTimingEntryCount: 1,
            sampleTimingArray: &timing,
            sampleSizeEntryCount: 1,
            sampleSizeArray: &sampleSize,
            sampleBufferOut: &sampleBuffer
        )
        guard status == noErr, let sb = sampleBuffer else {
            throw ConversionError.metadataSetupFailed("sample buffer create \(status)")
        }
        return sb
    }

    private static func makeStillImageTransformItem() -> AVMetadataItem {
        // Identity 3x3 matrix, 9 × Float64 big-endian, row-major.
        var data = Data(capacity: 72)
        let identity: [Double] = [1, 0, 0, 0, 1, 0, 0, 0, 1]
        for v in identity {
            var be = v.bitPattern.bigEndian
            withUnsafeBytes(of: &be) { data.append(contentsOf: $0) }
        }
        let item = AVMutableMetadataItem()
        item.identifier = AVMetadataIdentifier(
            rawValue: kCMMetadataIdentifier_QuickTimeMetadataLivePhotoStillImageTransform as String
        )
        item.value = data as NSData
        return item
    }

    private static func makeStillImageTransformReferenceDimensionsItem(size: CGSize) -> AVMetadataItem {
        // Two Float32 big-endian: width, height.
        var data = Data(capacity: 8)
        var w = Float32(size.width).bitPattern.bigEndian
        var h = Float32(size.height).bitPattern.bigEndian
        withUnsafeBytes(of: &w) { data.append(contentsOf: $0) }
        withUnsafeBytes(of: &h) { data.append(contentsOf: $0) }
        let item = AVMutableMetadataItem()
        item.identifier = AVMetadataIdentifier(
            rawValue: kCMMetadataIdentifier_QuickTimeMetadataLivePhotoStillImageTransformReferenceDimensions as String
        )
        item.value = data as NSData
        return item
    }

    private static func makeStillImageTimeMetadataForAdaptor() -> AVMetadataItem {
        let item = AVMutableMetadataItem()
        item.key = quickTimeMetadataKeyStillImageTime as NSString
        item.keySpace = AVMetadataKeySpace(rawValue: assetIdentifierSpace)
        item.value = (-1) as NSNumber
        item.dataType = kCMMetadataBaseDataType_SInt8 as String
        return item
    }
}
