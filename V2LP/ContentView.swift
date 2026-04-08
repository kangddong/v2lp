import SwiftUI
import PhotosUI

private struct PickedVideo: Identifiable {
    let id = UUID()
    let url: URL
}

struct ContentView: View {
    var body: some View {
        TabView {
            ConverterView()
                .tabItem {
                    Label("변환", systemImage: "livephoto")
                }

            DemoView()
                .tabItem {
                    Label("분석", systemImage: "doc.text.magnifyingglass")
                }
        }
    }
}

struct ConverterView: View {
    @State private var pickedVideo: PickedVideo?
    @State private var showVideoPicker = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()

                Image(systemName: "livephoto")
                    .font(.system(size: 80))
                    .foregroundStyle(.blue)

                Text("Video → Live Photo")
                    .font(.largeTitle.bold())

                Text("비디오를 선택하면\n라이브 포토로 변환할 수 있습니다")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                Spacer()

                Button {
                    showVideoPicker = true
                } label: {
                    Label("비디오 선택", systemImage: "video.badge.plus")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal, 32)
                .padding(.bottom, 48)
            }
            .navigationTitle("V2LP")
            .sheet(isPresented: $showVideoPicker) {
                VideoPickerView { url in
                    showVideoPicker = false
                    pickedVideo = PickedVideo(url: url)
                }
            }
            .fullScreenCover(item: $pickedVideo) { item in
                VideoEditorView(videoURL: item.url) {
                    pickedVideo = nil
                }
            }
        }
    }
}
