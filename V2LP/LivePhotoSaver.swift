import Photos
import PhotosUI

final class LivePhotoSaver {

    enum SaveError: LocalizedError {
        case permissionDenied
        case saveFailed(String)

        var errorDescription: String? {
            switch self {
            case .permissionDenied: return "사진 접근 권한이 없습니다."
            case .saveFailed(let msg): return "저장 실패: \(msg)"
            }
        }
    }

    static func requestPermission() async -> Bool {
        let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
        return status == .authorized || status == .limited
    }

    /// Save paired JPEG + MOV as a Live Photo to the user's Photo Library
    static func save(imageURL: URL, videoURL: URL) async throws {
        let authorized = await requestPermission()
        guard authorized else {
            throw SaveError.permissionDenied
        }

        try await PHPhotoLibrary.shared().performChanges {
            let request = PHAssetCreationRequest.forAsset()

            let imageOptions = PHAssetResourceCreationOptions()
            imageOptions.shouldMoveFile = false
            request.addResource(with: .photo, fileURL: imageURL, options: imageOptions)

            let videoOptions = PHAssetResourceCreationOptions()
            videoOptions.shouldMoveFile = false
            request.addResource(with: .pairedVideo, fileURL: videoURL, options: videoOptions)
        }
    }

    /// Clean up temporary files
    static func cleanup(imageURL: URL, videoURL: URL) {
        try? FileManager.default.removeItem(at: imageURL)
        try? FileManager.default.removeItem(at: videoURL)
    }
}
