import AVFoundation
import UIKit

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

        var errorDescription: String? {
            switch self {
            case .failedToExtractFrame: return "프레임 추출에 실패했습니다."
            case .failedToWriteImage: return "이미지 저장에 실패했습니다."
            case .exportFailed(let msg): return "비디오 내보내기 실패: \(msg)"
            case .cancelled: return "변환이 취소되었습니다."
            }
        }
    }

    private static let assetIdentifierKey = "17"
    private static let assetIdentifierSpace = "mdta"
    private static let quickTimeMetadataKeyContentIdentifier = "com.apple.quicktime.content.identifier"
    private static let quickTimeMetadataKeyStillImageTime = "com.apple.quicktime.still-image-time"

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

        let videoReaderOutput = AVAssetReaderTrackOutput(
            track: sourceVideoTrack,
            outputSettings: [
                kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
            ]
        )
        videoReaderOutput.alwaysCopiesSampleData = false
        reader.add(videoReaderOutput)

        let naturalSize = try await sourceVideoTrack.load(.naturalSize)
        let transform = try await sourceVideoTrack.load(.preferredTransform)
        let nominalFrameRate = try await sourceVideoTrack.load(.nominalFrameRate)

        let videoWriterInput = AVAssetWriterInput(
            mediaType: .video,
            outputSettings: [
                AVVideoCodecKey: AVVideoCodecType.h264,
                AVVideoWidthKey: naturalSize.width,
                AVVideoHeightKey: naturalSize.height,
                AVVideoCompressionPropertiesKey: [
                    AVVideoAverageBitRateKey: 6_000_000,
                    AVVideoProfileLevelKey: AVVideoProfileLevelH264HighAutoLevel
                ]
            ]
        )
        videoWriterInput.transform = transform
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

        // Still image time metadata track
        let metadataInput = makeStillImageTimeMetadataInput()
        writer.add(metadataInput)

        // Metadata adaptor MUST be created before writer.startWriting()
        let metadataAdapter = AVAssetWriterInputMetadataAdaptor(
            assetWriterInput: metadataInput
        )

        // Start reading/writing
        reader.startReading()
        writer.startWriting()
        writer.startSession(atSourceTime: timeRange.start)

        // Write still image time metadata at the correct offset
        let stillImageTimeCMTime = CMTime(
            seconds: startTime + stillImageTimeOffset,
            preferredTimescale: 600
        )

        let stillImageTimeMetadataItem = makeStillImageTimeMetadataForAdaptor()
        let metadataGroup = AVTimedMetadataGroup(
            items: [stillImageTimeMetadataItem],
            timeRange: CMTimeRange(
                start: stillImageTimeCMTime,
                duration: CMTime(value: 1, timescale: 600)
            )
        )

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
                            videoWriterInput.append(sampleBuffer)
                            framesWritten += 1
                            let p = min(framesWritten / max(totalFrames, 1), 1.0)
                            DispatchQueue.main.async { progress(p * 0.8) }

                            if !didWriteMetadata && metadataInput.isReadyForMoreMediaData {
                                metadataAdapter.append(metadataGroup)
                                didWriteMetadata = true
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
                    metadataAdapter.append(metadataGroup)
                }
                metadataInput.markAsFinished()

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

    private static func makeStillImageTimeMetadataInput() -> AVAssetWriterInput {
        let spec: [String: Any] = [
            kCMMetadataFormatDescriptionMetadataSpecificationKey_Identifier as String:
                "\(assetIdentifierSpace)/\(quickTimeMetadataKeyStillImageTime)",
            kCMMetadataFormatDescriptionMetadataSpecificationKey_DataType as String:
                kCMMetadataBaseDataType_SInt8 as String
        ]

        var formatDesc: CMFormatDescription?
        CMMetadataFormatDescriptionCreateWithMetadataSpecifications(
            allocator: kCFAllocatorDefault,
            metadataType: kCMMetadataFormatType_Boxed,
            metadataSpecifications: [spec] as CFArray,
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

    private static func makeStillImageTimeMetadataForAdaptor() -> AVMetadataItem {
        let item = AVMutableMetadataItem()
        item.key = quickTimeMetadataKeyStillImageTime as NSString
        item.keySpace = AVMetadataKeySpace(rawValue: assetIdentifierSpace)
        item.value = 0 as NSNumber
        item.dataType = kCMMetadataBaseDataType_SInt8 as String
        return item
    }
}
