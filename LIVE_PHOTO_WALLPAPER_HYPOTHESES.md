# Live Photo 배경화면 활성화 — 시도한 가설 로그

목표: 변환된 Live Photo가 사진앱에서 재생될 뿐 아니라, **배경화면 설정 화면에서 Live Photo 토글이 ON으로 활성화**되어야 함.

현재 상태: 사진앱 재생 ✅ / 배경화면 토글 ❌ (회색, 탭해도 켜지지 않음).

같은 가설을 또 시도하지 않기 위한 기록.

---

## ❌ 시도했지만 효과 없었던 가설들

### H1. JPEG + MOV의 ContentIdentifier(UUID) 페어링이 부정확하다
- 시도: 이미지 `kCGImagePropertyMakerAppleDictionary` key 17, MOV top-level `com.apple.quicktime.content.identifier`에 같은 UUID 기입.
- 결과: 사진앱에 Live Photo로 인식되어 재생까지는 됨. 배경화면 토글은 여전히 OFF.
- 결론: **필요 조건이지만 충분하지 않음.**

### H2. `still-image-time` 값이 0이라서 배경화면이 거부한다
- 시도: AVTimedMetadataGroup의 still-image-time payload를 `0` → `-1` (SInt8)로 변경.
- 결과: 사진앱 재생이 더 자연스러워졌지만 배경화면 토글은 여전히 OFF.
- 결론: 값은 -1이 맞지만 이것 단독으로는 부족.

### H3. mebx still-image-time 트랙만 있으면 충분하다
- 시도: AVAssetWriterInputMetadataAdaptor + AVTimedMetadataGroup으로 still-image-time만 1개 샘플 기록.
- 결과: 배경화면 토글 OFF.
- 결론: still-image-time 트랙 단독으로는 불충분.

### H4. `live-photo-info` mebx 트랙(per-frame)을 추가하면 된다
- 시도:
  - IMG_1977.MOV(작동하는 iPhone 캡처본)에서 SetupData(390B)와 per-frame 샘플 payload(136B)를 raw bytes로 추출.
  - `CMMetadataFormatDescriptionCreateWithMetadataSpecifications` + `kCMMetadataFormatDescriptionMetadataSpecificationKey_SetupData`로 포맷 디스크립션 생성.
  - 각 비디오 프레임마다 `live-photo-info` 박스 샘플 1개를 raw `CMSampleBuffer`로 어펜드.
- 결과: 트랙은 정상 생성되고 크래시 없음. **배경화면 토글 여전히 OFF.**
- 결론: live-photo-info 트랙 자체는 형식상 들어가지만, 이것만으로 활성화되지 않음.

### H5. `still-image-time` 트랙에 `live-photo-still-image-transform`(perspective-transform-float64) + `reference-dimensions`(dimensions-float32) 박스를 같이 넣으면 된다
- 시도:
  - IMG_1977.MOV의 still-image-time 트랙은 105B 샘플에 3개 박스(still-image-time SInt8 + transform 9×Float64 BE 단위행렬 + dimensions 2×Float32 BE)가 concat되어 있음을 확인.
  - AVMetadataItem 경로로는 perspective-transform-float64 base data type을 받지 못해 (`NSInvalidArgumentException`) 실패.
  - raw `CMBlockBufferCreateWithMemoryBlock` + `CMSampleBufferCreateReady`로 3-box payload를 직접 빌드해 어펜드하도록 변경.
- 결과: 크래시 없이 저장. **배경화면 토글 여전히 OFF.**
- 결론: 박스 구조 자체는 맞춰졌지만 활성화 조건은 아님.

### H6. Codex가 임시로 넣었던 NaN(`0000c07f`) Float 페이로드 때문이다
- 시도: 해당 변경 폐기 후 IMG_1977 추출 바이트로 교체.
- 결과: 배경화면 토글 OFF (변하지 않음).
- 결론: NaN은 잘못이긴 했지만 핵심 원인은 아님.

---

## 🟡 이미 확인된 사실 (재검증 불필요)

- 다운로드된 Live Photo(자동차 렌더, 포켓몬 캐릭터 등 iPhone 캡처가 **아님**)도 배경화면 토글이 켜진다 → **iPhone hardware 검증이 아니라 파일 형식 검증**임이 확실.
- `PHAssetCreationRequest`에 `.photo` + `.pairedVideo`로 추가하는 저장 경로는 정상(사진앱 재생되는 시점에서 검증됨).
- IMG_1977.MOV에는 metadata track이 3개:
  1. video-orientation
  2. live-photo-info (SetupData 390B + per-frame samples 136B)
  3. still-image-time (transform + reference-dimensions 포함, 105B 단일 샘플)
- 우리 출력은 위 3개 중 (2),(3)을 형식상 동일하게 만들었음에도 토글 미활성화.
- 작동하는 다운로드 샘플은 오디오 없이도 배경화면 설정이 된다.
- 작동하는 다운로드 샘플은 상위 `mdta`가 거의 `content.identifier`만 있어도 배경화면 설정이 된다.
- 우리 실패 샘플은 사진 `478x848`, 비디오 `naturalSize = 848x478`로 방향과 가로세로 축이 어긋나 있다.
- 작동하는 다운로드 샘플은 사진 `1080x1920`, 비디오 `naturalSize = 1080x1920`으로 방향과 해상도 축이 일치한다.

---

## 🟢 아직 시도하지 않은 가설 (재정렬된 우선순위)

### N1. **사진과 비디오의 방향/orientation/naturalSize 불일치가 핵심 원인이다**
- 현재 가장 강한 가설.
- 실패 샘플은 사진이 세로(`478x848`)인데 비디오는 가로 `naturalSize(848x478)`로 저장된다.
- 작동하는 다운로드 샘플은 사진/비디오가 모두 세로 `1080x1920`으로 정합적이다.
- 이미 `live-photo-info`, `still-image-time`, transform/reference-dimensions까지 맞췄는데도 실패했으므로, 이제는 메타데이터 양보다 출력 프로필 정합성 쪽을 먼저 의심하는 편이 맞다.
- **다음 액션:** 비디오 export 단계에서 트랙 transform에 의존하지 말고, 파일 자체 `naturalSize`가 사진 방향과 같게 나오도록 렌더링/인코딩 경로를 점검한다.

### N2. **길이 프로필이 배경화면용으로 덜 안전하다**
- 실패 샘플 길이: 약 `3.03s`
- 작동 다운로드 샘플 길이: 약 `1.05s`
- 직접 촬영 샘플도 `3.04s`로 길지만, 이 샘플은 촬영 원본이고 orientation 전용 트랙, 풍부한 상위 메타데이터, 카메라 출력 프로필을 함께 가진다.
- 즉, 우리처럼 최소 메타데이터 + 비카메라 출력인 경우에는 길이를 더 짧고 보수적으로 잡아야 할 수 있다.
- WidgetClub 참고 메모도 기본 출력은 `1.0~1.5초` 쪽이 안전하다는 쪽으로 해석된다.
- **다음 액션:** orientation 정합성을 맞춘 뒤, 길이를 `1.0~1.5초`로 줄인 실험본을 바로 비교한다.

### N3. **사진/비디오 해상도와 종횡비 정합성이 부족하다**
- 최소 요구사항 문서에도 해상도와 종횡비 일치를 권장 조건으로 적어둔 상태다.
- 실패 샘플은 단순히 해상도 차이만이 아니라 축 자체가 뒤집혀 있어서, 시스템이 배경화면용으로는 덜 신뢰할 가능성이 있다.
- WidgetClub 메모의 "패딩 모드" 아이디어도 결국 배경화면용 출력 프로필을 따로 관리하자는 뜻에 가깝다.
- **다음 액션:** 기본 출력에서 사진과 비디오를 동일 캔버스 기준으로 렌더링하고, 필요하면 별도 패딩 모드를 실험한다.

### N4. **이미지(JPEG/HEIC) 쪽 EXIF/MakerApple 누락 필드**
- 이 가설은 여전히 유효하지만 우선순위는 내려간다.
- 이유: 작동하는 다운로드 샘플은 HEIC이지만 MakerApple에서 확인되는 핵심값은 사실상 `17(ContentIdentifier)`뿐이고, 그 상태로도 배경화면 설정이 된다.
- 즉, JPEG/HEIC 쪽 필드가 더 풍부하면 좋을 수는 있어도, 현 시점 증거만으로는 1순위 원인으로 보기 어렵다.
- 후보: key 8(HDR headroom?), key 14(orientation?), `kCGImagePropertyTIFFMake/Model/Software`, `kCGImagePropertyExifSubsec*` 등.
- HEIC인 경우 보조 이미지(depth/aux)가 있는지도 확인 필요.
- **다음 액션:** 작동하는 Live Photo의 JPEG/HEIC를 받아서 `CGImageSourceCopyPropertiesAtIndex`로 전체 metadata dict 덤프 후 비교.

### N5. **MOV top-level mdta 누락 필드**
- 후보 키:
  - `com.apple.quicktime.full-frame-rate-playback-intent`
  - `com.apple.quicktime.live-photo.vitality-score`
  - `com.apple.quicktime.live-photo.vitality-scoring-version`
  - `com.apple.quicktime.live-photo.auto`
  - `com.apple.quicktime.make` / `.model` / `.software`
  - `com.apple.quicktime.creationdate`
- 하지만 우선순위는 낮다.
- 이유: 작동하는 다운로드 샘플은 상위 `mdta`가 거의 `content.identifier`만 있어도 배경화면 설정이 된다.
- 즉, 이 필드들은 "직접 촬영본다운 풍부함"을 설명할 수는 있어도, 현재 실패의 핵심 원인이라고 보기엔 근거가 약하다.
- **다음 액션:** orientation/길이 실험 후에도 실패하면 IMG_1977.MOV의 top-level mdta를 전부 덤프하고 우리 출력본과 diff.

### N6. **video track의 `colr`/`pasp`/`fiel` 또는 HEVC vs H.264**
- iPhone Live Photo는 보통 HEVC. 우리는 H.264로 인코딩 중일 가능성.
- 하지만 이 역시 단독 원인으로 단정하기 어렵다.
- 이유: 직접 촬영본은 H.264(`avc1`)인데도 작동한다. 다운로드본은 HEVC(`hvc1`)라서 "코덱 자체"보다 "전체 출력 프로필" 영향이 더 커 보인다.
- **다음 액션:** orientation/길이 정합성부터 맞춘 뒤, 필요하면 HEVC 프로필도 별도 실험한다.

### N7. **mebx 트랙의 `tref` (track reference)**
- still-image-time이 video track을 reference하는 `tref` atom이 있을 수 있음.
- AVAssetWriter API로는 직접 제어 불가 → 후처리로 mp4 트리 수정 필요.
- **우선순위 낮음**. 지금 단계에서 바로 파고들 이유는 약하다.

### N8. **moov 박스 내 `meta` (top-level mdta keys/ilst) 순서/형식**
- AVAssetWriter가 만든 mdta와 iPhone 캡처본의 mdta 바이너리 구조 차이.
- **우선순위 낮음.**

---

## WidgetClub 참고 메모 반영 결론

- 현재 가장 설득력 있는 부족점 가설은 "메타데이터가 부족해서"가 아니라 "배경화면용 출력 프로필이 덜 보수적이라서"다.
- 특히 방향, 해상도 축, 종횡비, 길이 같은 출력 정합성을 먼저 맞춰야 한다.
- WidgetClub이 보여준 제품 방향도, 실패를 메타데이터 한 방으로 해결하려 하기보다 여러 출력 프로필로 흡수하는 쪽에 가깝다.

## 코드 레벨 검증 결과

- `V2LP/LivePhotoConverter.swift`에서 실패 리포트와 직접 연결되는 원인을 확인했다.
- 기존 구현은 `sourceVideoTrack.naturalSize`를 그대로 `AVAssetWriterInput`의 `AVVideoWidthKey/AVVideoHeightKey`에 사용하고, 방향 보정은 `videoWriterInput.transform = preferredTransform`에만 의존하고 있었다.
- 이 방식이면 세로 원본도 결과 파일의 `naturalSize`는 가로 축(`848x478`)으로 남을 수 있다.
- 동시에 still-image metadata의 `reference-dimensions`도 같은 `naturalSize`를 사용하고 있었으므로, 사진 쪽 세로 크기와 더 어긋날 수 있었다.
- 즉, 실패 샘플의 "사진은 세로 / 비디오는 가로 naturalSize" 현상은 추측이 아니라 기존 코드 경로로 실제 발생 가능한 상태였다.
- 수정 방향:
  - `AVAssetReaderVideoCompositionOutput`로 `preferredTransform`를 실제 픽셀 버퍼에 반영
  - writer 출력 크기를 orientation이 반영된 `orientedSize`로 고정
  - still-image reference dimensions도 `orientedSize` 기준으로 기록
- 이 수정으로 최소한 "파일 자체 naturalSize가 사진 방향과 어긋난다"는 1순위 가설은 코드 레벨에서 해소했다.

---

## 📋 다음 디버깅 절차

1. 현재 변환 파이프라인에서 비디오 `naturalSize`와 preferred transform이 왜 사진 방향과 어긋나는지 코드 레벨로 확인한다.
2. 비디오 파일 자체가 세로 `naturalSize`로 저장되도록 렌더링/인코딩 경로를 수정한 실험본을 만든다.
3. 같은 수정본에서 길이를 `1.0~1.5초`로 줄인 버전도 함께 비교한다.
4. 그 다음에도 실패하면 이미지 전체 metadata, MOV top-level `mdta` diff를 진행한다.
5. 마지막 순서로 `tref`, `moov/meta` 바이너리 구조 같은 저수준 원인을 본다.
