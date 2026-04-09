# Live Photo Minimum Requirements

이 문서는 Video to Live Photo 변환 기능 구현 및 검증 시 따라야 하는 최소 조건을 정리한다.

## 필수 구성

- 파일 쌍: 정지 이미지(HEIC/JPEG) 1개와 동영상(MOV) 1개를 한 쌍으로 구성해야 한다.
- 동일한 Asset Identifier: 두 파일 메타데이터에 동일한 UUID 문자열이 포함되어야 한다.
- 저장 방식: `PHAssetCreationRequest`에 `.photo`, `.pairedVideo` 리소스를 함께 추가해야 한다.

## 이미지 조건

- 포맷: HEIC 또는 JPEG
- 메타데이터: `kCGImagePropertyMakerAppleDictionary`의 key `"17"`에 Asset Identifier를 기록해야 한다.

## 비디오 조건

- 컨테이너: MOV
- 코덱: H.264 또는 HEVC
- 메타데이터: QuickTime 메타데이터 `com.apple.quicktime.content.identifier`에 동일한 Asset Identifier를 기록해야 한다.
- Still Image Time 마커: MOV에 `com.apple.quicktime.still-image-time` 메타데이터 트랙이 있어야 하며, 정지 프레임 시점을 지정해야 한다.
- 길이: 약 1~3초 권장, Apple 기본 동작에 가깝게는 1.5초 전후가 일반적이다.
- 오디오 트랙: 선택 사항이며 없어도 된다.

## 권장 조건

- 해상도 일치: 스틸 이미지와 비디오의 해상도 및 종횡비는 동일하게 맞추는 것을 권장한다.

## 구현 메모

- 이미지와 비디오의 Asset Identifier가 다르면 Live Photo로 정상 조합되지 않는다.
- Still Image Time 마커가 없으면 시스템이 Live Photo로 인식하지 못할 수 있다.
