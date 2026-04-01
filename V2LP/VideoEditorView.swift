import SwiftUI
import AVFoundation
import AVKit
import PhotosUI

struct VideoEditorView: View {
    let videoURL: URL
    let onDismiss: () -> Void

    @State private var player: AVPlayer?
    @State private var videoDuration: Double = 0
    @State private var startTime: Double = 0
    @State private var clipDuration: Double = 3.0
    @State private var keyFrameOffset: Double = 0.0
    @State private var isConverting = false
    @State private var conversionProgress: Double = 0
    @State private var showResult = false
    @State private var resultMessage = ""
    @State private var isSuccess = false
    @State private var thumbnails: [UIImage] = []

    private let maxClipDuration: Double = 3.0

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Video Preview
                if let player {
                    VideoPlayer(player: player)
                        .frame(maxHeight: UIScreen.main.bounds.height * 0.4)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding()
                } else {
                    ProgressView()
                        .frame(height: UIScreen.main.bounds.height * 0.4)
                }

                VStack(spacing: 20) {
                    // Thumbnail strip
                    if !thumbnails.isEmpty {
                        ThumbnailStripView(
                            thumbnails: thumbnails,
                            startTime: $startTime,
                            clipDuration: $clipDuration,
                            totalDuration: videoDuration,
                            maxClipDuration: maxClipDuration
                        )
                        .frame(height: 60)
                        .padding(.horizontal)
                    }

                    // Start time slider
                    VStack(alignment: .leading, spacing: 4) {
                        Text("시작 지점: \(formattedTime(startTime))")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Slider(
                            value: $startTime,
                            in: 0...max(videoDuration - clipDuration, 0.1),
                            step: 0.1
                        )
                        .onChange(of: startTime) {
                            seekToStart()
                        }
                    }
                    .padding(.horizontal)

                    // Clip duration slider
                    VStack(alignment: .leading, spacing: 4) {
                        Text("길이: \(String(format: "%.1f", clipDuration))초 (최대 \(String(format: "%.0f", maxClipDuration))초)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Slider(
                            value: $clipDuration,
                            in: 1...max(min(maxClipDuration, videoDuration - startTime), 1),
                            step: 0.1
                        )
                    }
                    .padding(.horizontal)

                    // Key frame position
                    VStack(alignment: .leading, spacing: 4) {
                        Text("대표 사진 위치: \(String(format: "%.1f", keyFrameOffset))초")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Slider(
                            value: $keyFrameOffset,
                            in: 0...max(clipDuration - 0.1, 0.1),
                            step: 0.1
                        )
                        .onChange(of: keyFrameOffset) {
                            seekToKeyFrame()
                        }
                    }
                    .padding(.horizontal)
                }

                Spacer()

                // Convert Button
                Button {
                    Task { await convertToLivePhoto() }
                } label: {
                    if isConverting {
                        VStack(spacing: 8) {
                            ProgressView(value: conversionProgress)
                                .progressViewStyle(.linear)
                            Text("변환 중... \(Int(conversionProgress * 100))%")
                                .font(.subheadline)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.gray.opacity(0.2))
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                    } else {
                        Label("라이브 포토로 변환 및 저장", systemImage: "livephoto")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.blue)
                            .foregroundStyle(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                }
                .disabled(isConverting)
                .padding(.horizontal, 32)
                .padding(.bottom, 32)
            }
            .navigationTitle("편집")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("취소") {
                        cleanup()
                        onDismiss()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        previewClip()
                    } label: {
                        Image(systemName: "play.fill")
                    }
                }
            }
            .alert(resultMessage, isPresented: $showResult) {
                if isSuccess {
                    Button("확인") {
                        cleanup()
                        onDismiss()
                    }
                } else {
                    Button("확인", role: .cancel) {}
                }
            }
            .task {
                await loadVideo()
            }
        }
    }

    // MARK: - Video Loading

    private func loadVideo() async {
        let asset = AVURLAsset(url: videoURL)
        do {
            let duration = try await asset.load(.duration)
            videoDuration = duration.seconds
            clipDuration = min(maxClipDuration, videoDuration)
            player = AVPlayer(url: videoURL)

            await generateThumbnails(asset: asset)
        } catch {
            videoDuration = 3
            player = AVPlayer(url: videoURL)
        }
    }

    private func generateThumbnails(asset: AVURLAsset) async {
        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.maximumSize = CGSize(width: 100, height: 100)

        let count = 10
        let interval = videoDuration / Double(count)
        var images: [UIImage] = []

        for i in 0..<count {
            let time = CMTime(seconds: Double(i) * interval, preferredTimescale: 600)
            if let (cgImage, _) = try? await generator.image(at: time) {
                images.append(UIImage(cgImage: cgImage))
            }
        }

        thumbnails = images
    }

    // MARK: - Playback Controls

    private func seekToStart() {
        player?.seek(
            to: CMTime(seconds: startTime, preferredTimescale: 600),
            toleranceBefore: .zero,
            toleranceAfter: .zero
        )
    }

    private func seekToKeyFrame() {
        player?.seek(
            to: CMTime(seconds: startTime + keyFrameOffset, preferredTimescale: 600),
            toleranceBefore: .zero,
            toleranceAfter: .zero
        )
    }

    private func previewClip() {
        let start = CMTime(seconds: startTime, preferredTimescale: 600)
        player?.seek(to: start, toleranceBefore: .zero, toleranceAfter: .zero)
        player?.play()

        // Stop after clip duration
        DispatchQueue.main.asyncAfter(deadline: .now() + clipDuration) {
            player?.pause()
        }
    }

    // MARK: - Conversion

    private func convertToLivePhoto() async {
        isConverting = true
        conversionProgress = 0

        do {
            let result = try await LivePhotoConverter.convert(
                videoURL: videoURL,
                startTime: startTime,
                duration: clipDuration,
                keyFrameTime: keyFrameOffset,
                progress: { p in
                    DispatchQueue.main.async {
                        conversionProgress = p
                    }
                }
            )

            try await LivePhotoSaver.save(
                imageURL: result.imageURL,
                videoURL: result.videoURL
            )

            LivePhotoSaver.cleanup(
                imageURL: result.imageURL,
                videoURL: result.videoURL
            )

            isSuccess = true
            resultMessage = "라이브 포토가 사진 앨범에 저장되었습니다!"
        } catch {
            isSuccess = false
            resultMessage = "오류: \(error.localizedDescription)"
        }

        isConverting = false
        showResult = true
    }

    private func cleanup() {
        player?.pause()
        player = nil
        try? FileManager.default.removeItem(at: videoURL)
    }

    private func formattedTime(_ seconds: Double) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        let frac = Int((seconds - Double(Int(seconds))) * 10)
        return String(format: "%d:%02d.%d", mins, secs, frac)
    }
}

// MARK: - Thumbnail Strip

struct ThumbnailStripView: View {
    let thumbnails: [UIImage]
    @Binding var startTime: Double
    @Binding var clipDuration: Double
    let totalDuration: Double
    let maxClipDuration: Double

    var body: some View {
        GeometryReader { geo in
            let totalWidth = geo.size.width
            let clipStartFraction = startTime / max(totalDuration, 1)
            let clipFraction = clipDuration / max(totalDuration, 1)
            let selectionX = clipStartFraction * totalWidth
            let selectionWidth = clipFraction * totalWidth

            ZStack(alignment: .leading) {
                // Thumbnails
                HStack(spacing: 0) {
                    ForEach(thumbnails.indices, id: \.self) { i in
                        Image(uiImage: thumbnails[i])
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(
                                width: totalWidth / CGFloat(thumbnails.count),
                                height: geo.size.height
                            )
                            .clipped()
                    }
                }

                // Dim overlay outside selection
                Rectangle()
                    .fill(.black.opacity(0.5))
                    .mask {
                        Rectangle()
                            .overlay {
                                Rectangle()
                                    .frame(width: selectionWidth)
                                    .offset(x: selectionX)
                                    .blendMode(.destinationOut)
                            }
                            .compositingGroup()
                    }

                // Selection border
                RoundedRectangle(cornerRadius: 4)
                    .stroke(.yellow, lineWidth: 2)
                    .frame(width: selectionWidth, height: geo.size.height)
                    .offset(x: selectionX)
            }
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}
