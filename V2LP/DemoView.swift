import SwiftUI
import PhotosUI
import Photos
import AVFoundation
import CoreMedia
import UniformTypeIdentifiers

struct DemoView: View {
    @State private var isPicking = false
    @State private var isAnalyzing = false
    @State private var report: String = "Live Photo를 선택하면 메타데이터를 분석합니다."
    @State private var copied = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                ScrollView {
                    Text(report)
                        .font(.system(.caption2, design: .monospaced))
                        .textSelection(.enabled)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(12)
                }
                .background(Color(.secondarySystemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .padding(.horizontal)

                HStack(spacing: 12) {
                    Button {
                        isPicking = true
                    } label: {
                        Label("Live Photo 선택", systemImage: "livephoto")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.blue)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(isAnalyzing)

                    Button {
                        UIPasteboard.general.string = report
                        copied = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                            copied = false
                        }
                    } label: {
                        Image(systemName: copied ? "checkmark" : "doc.on.doc")
                            .font(.title3)
                            .frame(width: 48, height: 48)
                            .background(.gray.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)

                if isAnalyzing {
                    ProgressView().padding(.bottom)
                }
            }
            .navigationTitle("Live Photo 분석")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $isPicking) {
                LivePhotoPickerView { livePhoto in
                    Task { await analyze(livePhoto: livePhoto) }
                }
            }
        }
    }

    // MARK: - Analysis

    @MainActor
    private func analyze(livePhoto: PHLivePhoto) async {
        isAnalyzing = true
        defer { isAnalyzing = false }

        var lines: [String] = []
        lines.append("========== Live Photo Report ==========")
        lines.append("Date: \(Date())")
        lines.append("")

        let resources = PHAssetResource.assetResources(for: livePhoto)
        lines.append("Resources: \(resources.count)")
        for (i, r) in resources.enumerated() {
            lines.append("  [\(i)] type=\(r.type.rawValue) uti=\(r.uniformTypeIdentifier) name=\(r.originalFilename)")
        }
        lines.append("")

        let tempDir = FileManager.default.temporaryDirectory

        for (i, resource) in resources.enumerated() {
            lines.append("---------- Resource [\(i)]: \(typeName(resource.type)) ----------")
            lines.append("UTI: \(resource.uniformTypeIdentifier)")
            lines.append("Original Filename: \(resource.originalFilename)")

            let ext: String
            if resource.uniformTypeIdentifier.contains("movie") ||
                resource.uniformTypeIdentifier.contains("quicktime") ||
                resource.uniformTypeIdentifier.contains("mpeg") {
                ext = "mov"
            } else if resource.uniformTypeIdentifier.contains("heic") {
                ext = "heic"
            } else {
                ext = "bin"
            }

            let url = tempDir.appendingPathComponent("\(UUID().uuidString).\(ext)")

            do {
                try await writeResource(resource, to: url)

                let attrs = try FileManager.default.attributesOfItem(atPath: url.path)
                let size = (attrs[.size] as? Int64) ?? 0
                lines.append("Size: \(size) bytes")

                if ext == "mov" {
                    lines.append(contentsOf: await analyzeVideo(url: url))
                } else {
                    lines.append(contentsOf: analyzeImage(url: url))
                }

                try? FileManager.default.removeItem(at: url)
            } catch {
                lines.append("Error writing/reading resource: \(error.localizedDescription)")
            }
            lines.append("")
        }

        report = lines.joined(separator: "\n")
    }

    private func typeName(_ type: PHAssetResourceType) -> String {
        switch type {
        case .photo: return "photo"
        case .video: return "video"
        case .audio: return "audio"
        case .alternatePhoto: return "alternatePhoto"
        case .fullSizePhoto: return "fullSizePhoto"
        case .fullSizeVideo: return "fullSizeVideo"
        case .adjustmentData: return "adjustmentData"
        case .adjustmentBasePhoto: return "adjustmentBasePhoto"
        case .pairedVideo: return "pairedVideo"
        case .fullSizePairedVideo: return "fullSizePairedVideo"
        case .adjustmentBasePairedVideo: return "adjustmentBasePairedVideo"
        case .adjustmentBaseVideo: return "adjustmentBaseVideo"
        @unknown default: return "unknown(\(type.rawValue))"
        }
    }

    private func writeResource(_ resource: PHAssetResource, to url: URL) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            let options = PHAssetResourceRequestOptions()
            options.isNetworkAccessAllowed = true
            PHAssetResourceManager.default().writeData(
                for: resource,
                toFile: url,
                options: options
            ) { error in
                if let error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume()
                }
            }
        }
    }

    // MARK: - Image Analysis

    private func analyzeImage(url: URL) -> [String] {
        var lines: [String] = []
        guard let source = CGImageSourceCreateWithURL(url as CFURL, nil) else {
            return ["(cannot open image source)"]
        }
        lines.append("Image Count: \(CGImageSourceGetCount(source))")
        if let type = CGImageSourceGetType(source) {
            lines.append("Source Type: \(type as String)")
        }
        guard let props = CGImageSourceCopyPropertiesAtIndex(source, 0, nil) as? [String: Any] else {
            return lines + ["(no properties)"]
        }
        lines.append("-- Properties --")
        lines.append(contentsOf: dictToLines(props, indent: "  "))
        return lines
    }

    private func dictToLines(_ dict: [String: Any], indent: String) -> [String] {
        var lines: [String] = []
        for (key, value) in dict.sorted(by: { $0.key < $1.key }) {
            if let sub = value as? [String: Any] {
                lines.append("\(indent)\(key):")
                lines.append(contentsOf: dictToLines(sub, indent: indent + "  "))
            } else if let arr = value as? [Any] {
                lines.append("\(indent)\(key): <array \(arr.count)>")
            } else if let data = value as? Data {
                lines.append("\(indent)\(key): <data \(data.count) bytes>")
            } else {
                lines.append("\(indent)\(key): \(value)")
            }
        }
        return lines
    }

    // MARK: - Video Analysis

    private func analyzeVideo(url: URL) async -> [String] {
        var lines: [String] = []
        let asset = AVURLAsset(url: url)

        do {
            let duration = try await asset.load(.duration)
            lines.append("Duration: \(String(format: "%.4f", CMTimeGetSeconds(duration)))s  (value=\(duration.value), timescale=\(duration.timescale))")
        } catch {
            lines.append("Duration: error - \(error.localizedDescription)")
        }

        // Common metadata
        do {
            let common = try await asset.load(.commonMetadata)
            lines.append("-- Common Metadata (\(common.count)) --")
            for item in common {
                lines.append("  commonKey=\(item.commonKey?.rawValue ?? "?") value=\(describeValue(item))")
            }
        } catch {
            lines.append("Common metadata error: \(error.localizedDescription)")
        }

        // Format-specific metadata
        do {
            let formats = try await asset.load(.availableMetadataFormats)
            lines.append("-- Metadata Formats: \(formats.map { $0.rawValue }) --")
            for format in formats {
                lines.append("-- Format: \(format.rawValue) --")
                do {
                    let items = try await asset.loadMetadata(for: format)
                    for item in items {
                        let key = (item.key as? String) ?? String(describing: item.key as Any)
                        let keySpace = item.keySpace?.rawValue ?? "?"
                        let id = item.identifier?.rawValue ?? "?"
                        lines.append("  [\(keySpace) / \(key)] id=\(id)")
                        lines.append("    value=\(describeValue(item)) dataType=\(item.dataType ?? "?")")
                    }
                } catch {
                    lines.append("  load format error: \(error.localizedDescription)")
                }
            }
        } catch {
            lines.append("Metadata formats error: \(error.localizedDescription)")
        }

        // Tracks
        do {
            let tracks = try await asset.load(.tracks)
            lines.append("-- Tracks (\(tracks.count)) --")
            for track in tracks {
                let mediaType = track.mediaType.rawValue
                var trackLines: [String] = []
                trackLines.append("  Track id=\(track.trackID) type=\(mediaType)")
                if let timeRange = try? await track.load(.timeRange) {
                    trackLines.append("    timeRange: start=\(CMTimeGetSeconds(timeRange.start))s dur=\(CMTimeGetSeconds(timeRange.duration))s")
                }
                if let nts = try? await track.load(.naturalTimeScale) {
                    trackLines.append("    naturalTimeScale: \(nts)")
                }
                if let frameRate = try? await track.load(.nominalFrameRate) {
                    trackLines.append("    nominalFrameRate: \(frameRate)")
                }
                if let naturalSize = try? await track.load(.naturalSize) {
                    trackLines.append("    naturalSize: \(naturalSize)")
                }
                if let formatDescs = try? await track.load(.formatDescriptions) as? [CMFormatDescription] {
                    for fmt in formatDescs {
                        let type = CMFormatDescriptionGetMediaType(fmt)
                        let subType = CMFormatDescriptionGetMediaSubType(fmt)
                        trackLines.append("    format: type=\(fourCC(type)) subType=\(fourCC(subType))")

                        if let extensions = CMFormatDescriptionGetExtensions(fmt) as? [String: Any] {
                            for (k, v) in extensions.sorted(by: { $0.key < $1.key }) {
                                trackLines.append("      ext[\(k)]:")
                                let text = String(describing: v)
                                for line in text.split(separator: "\n", omittingEmptySubsequences: false) {
                                    trackLines.append("        \(line)")
                                }
                            }
                        }
                    }
                }
                lines.append(contentsOf: trackLines)

                // If metadata track, read samples
                if track.mediaType == .metadata {
                    lines.append(contentsOf: await readMetadataSamples(asset: asset, track: track))
                }
            }
        } catch {
            lines.append("Tracks error: \(error.localizedDescription)")
        }

        return lines
    }

    private func readMetadataSamples(asset: AVAsset, track: AVAssetTrack) async -> [String] {
        var lines: [String] = ["    -- Metadata Track Samples --"]
        do {
            let reader = try AVAssetReader(asset: asset)
            let output = AVAssetReaderTrackOutput(track: track, outputSettings: nil)
            guard reader.canAdd(output) else {
                lines.append("    (cannot add reader output)")
                return lines
            }
            reader.add(output)
            reader.startReading()

            var idx = 0
            while let sampleBuffer = output.copyNextSampleBuffer() {
                let pts = CMSampleBufferGetPresentationTimeStamp(sampleBuffer)
                let dur = CMSampleBufferGetDuration(sampleBuffer)
                lines.append("    [sample \(idx)] pts=\(CMTimeGetSeconds(pts))s dur=\(CMTimeGetSeconds(dur))s")

                // Extract metadata items from the sample buffer
                let group = AVTimedMetadataGroup(sampleBuffer: sampleBuffer)
                if let items = group?.items, !items.isEmpty {
                    for item in items {
                        let key = (item.key as? String) ?? String(describing: item.key as Any)
                        let keySpace = item.keySpace?.rawValue ?? "?"
                        let id = item.identifier?.rawValue ?? "?"
                        let dt = item.dataType ?? "?"
                        lines.append("      item key=\(key) space=\(keySpace) id=\(id) dt=\(dt) value=\(describeValue(item))")
                    }
                } else if let formatDesc = CMSampleBufferGetFormatDescription(sampleBuffer) {
                    // Fallback: try reading raw data block
                    if let dataBuffer = CMSampleBufferGetDataBuffer(sampleBuffer) {
                        let length = CMBlockBufferGetDataLength(dataBuffer)
                        var bytes = [UInt8](repeating: 0, count: min(length, 128))
                        CMBlockBufferCopyDataBytes(dataBuffer, atOffset: 0, dataLength: bytes.count, destination: &bytes)
                        let hex = bytes.map { String(format: "%02x", $0) }.joined()
                        lines.append("      rawData (\(length)B): \(hex)")
                    }
                    _ = formatDesc
                }

                idx += 1
                if idx > 80 { // allow more samples for per-frame tracks
                    lines.append("    (truncated at 80)")
                    break
                }
            }
            if reader.status == .failed, let err = reader.error {
                lines.append("    reader error: \(err.localizedDescription)")
            }
        } catch {
            lines.append("    reader init error: \(error.localizedDescription)")
        }
        return lines
    }

    private func describeValue(_ item: AVMetadataItem) -> String {
        if let s = item.stringValue { return "\"\(s)\"" }
        if let n = item.numberValue { return "\(n)" }
        if let d = item.dateValue { return "\(d)" }
        if let data = item.dataValue { return "<data \(data.count)B: \(data.prefix(32).map { String(format: "%02x", $0) }.joined())>" }
        return "?"
    }

    private func fourCC(_ code: FourCharCode) -> String {
        let bytes: [UInt8] = [
            UInt8((code >> 24) & 0xFF),
            UInt8((code >> 16) & 0xFF),
            UInt8((code >> 8) & 0xFF),
            UInt8(code & 0xFF)
        ]
        if let s = String(bytes: bytes, encoding: .ascii),
           s.unicodeScalars.allSatisfy({ $0.isASCII && $0.value >= 32 && $0.value < 127 }) {
            return "'\(s)'"
        }
        return "\(code)"
    }
}

// MARK: - Live Photo Picker

struct LivePhotoPickerView: UIViewControllerRepresentable {
    let onPick: (PHLivePhoto) -> Void

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .livePhotos
        config.selectionLimit = 1
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onPick: onPick)
    }

    final class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let onPick: (PHLivePhoto) -> Void

        init(onPick: @escaping (PHLivePhoto) -> Void) {
            self.onPick = onPick
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            guard let result = results.first else { return }
            let onPick = self.onPick
            result.itemProvider.loadObject(ofClass: PHLivePhoto.self) { object, _ in
                guard let livePhoto = object as? PHLivePhoto else { return }
                DispatchQueue.main.async {
                    onPick(livePhoto)
                }
            }
        }
    }
}
