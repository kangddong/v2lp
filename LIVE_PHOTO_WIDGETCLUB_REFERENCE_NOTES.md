# WidgetClub 참고 메모

이 문서는 WidgetClub의 Live Photo 저장 흐름을 참고해, 우리 Video to Live Photo 앱에 적용할 수 있는 제품/기술 힌트를 정리한다.

조사 기준일: 2026-04-09

참고한 외부 페이지:
- 저장 페이지: https://widget-club.com/ko/livephotos/save/19a35acd234944549c4e
- iOS 17 Live 배경화면 설정 가이드: https://widget-club.com/help/ios17_live_wallpaper_set
- iOS Live 배경화면 FAQ: https://widget-club.com/ko/help/ios17_live_wallpaper_faq
- App Store: https://apps.apple.com/us/app/widgetclub-%EC%9C%84%EC%A0%AF-%EB%B0%B0%EA%B2%BD%ED%99%94%EB%A9%B4-%EC%95%84%EC%9D%B4%EC%BD%98-%ED%85%8C%EB%A7%88-%EA%BE%B8%EB%AF%B8%EA%B8%B0/id1580284904?l=ko

참고한 내부 문서:
- [Live Photo minimum requirements](LIVE_PHOTO_MINIMUM_REQUIREMENTS.md)
- [Working downloaded Live Photo report](LIVE_PHOTO_REPORT_WORKING_DOWNLOADED.md)
- [Working captured Live Photo report](LIVE_PHOTO_REPORT_WORKING_CAPTURED.md)
- [Not working app build 1 Live Photo report](LIVE_PHOTO_REPORT_NOT_WORKING_APP_BUILD_1.md)
- [Live Photo 배경화면 활성화 시도 로그](LIVE_PHOTO_WALLPAPER_HYPOTHESES.md)

## 제품 관점에서 얻은 힌트

### 1. 웹은 유입, 앱은 실행으로 역할을 분리한다

- WidgetClub의 저장 페이지는 웹에서 공유 링크를 열게 하지만, 실제 저장/적용 단계는 앱 설치와 앱 복귀 흐름을 전제로 설계되어 있다.
- 즉, "웹에서 찾고 공유한다"와 "앱에서 저장하고 적용한다"를 분리한 구조다.
- 우리 앱도 추후 공유 링크나 웹 랜딩을 도입한다면 이 구조를 참고할 수 있다.

### 2. 변환 실패를 제품 기능으로 흡수한다

- WidgetClub은 단순히 하나의 Live Photo 파일만 내려주지 않고, 설정 가이드와 FAQ를 함께 제공한다.
- 특히 작동하지 않을 때를 대비해 다른 형식 다운로드, 다시 생성, 더 느리게 생성 같은 우회 옵션을 노출한다.
- 이는 Live Photo 호환성 문제를 엔진 내부 문제로만 보지 않고, 사용자에게 선택 가능한 출력 프로필로 풀고 있다는 뜻이다.

### 3. 잠금화면 크롭 문제를 별도 출력 포맷으로 완화한다

- FAQ에는 회색 프레임이 포함된 다른 형식 다운로드가 언급된다.
- 이는 잠금화면 줌/크롭이나 화면 비율 차이로 인해 피사체가 잘리는 문제를 막기 위해 패딩된 대체 버전을 제공하는 것으로 해석된다.
- 우리 앱도 기본 출력 외에 "호환성 모드" 또는 "패딩 모드"를 제공할 근거가 된다.

## 기술 관점에서 얻은 힌트

### 1. 현재 문제는 메타데이터의 양보다 출력 프로필 불일치 가능성이 더 크다

- 최소 요구사항 기준으로 보면 Live Photo 페어링의 핵심은 동일한 Asset Identifier, photo + pairedVideo 저장, 그리고 MOV의 still-image-time 마커다.
- 우리 실패 샘플은 이 최소 조건을 상당 부분 만족하고도 배경화면 설정이 되지 않는다.
- 따라서 "메타데이터를 더 많이 넣으면 해결된다"보다, 작동 샘플과의 출력 프로필 차이를 먼저 줄이는 편이 타당하다.

### 2. 방향과 크기 정합성이 가장 유력한 차이점이다

- 우리 실패 샘플:
  - 사진 `478x848`
  - 비디오 `naturalSize = 848x478`
- 작동한 다운로드 샘플:
  - 사진 `1080x1920`
  - 비디오 `naturalSize = 1080x1920`
- 즉, 실패 샘플은 사진은 세로인데 비디오는 가로로 기록되어 있다.
- 배경화면용 Live Photo에서는 사진과 비디오의 방향, 해상도, 종횡비가 더 엄격하게 맞아야 할 가능성이 높다.

### 3. 비디오 길이는 짧은 프로필이 더 안전해 보인다

- 우리 실패 샘플 길이: 약 `3.03s`
- 작동한 다운로드 샘플 길이: 약 `1.05s`
- 최소 요구사항 문서도 `1~3초 권장`, Apple 기본 동작에 가깝게는 `1.5초 전후`를 언급한다.
- WidgetClub이 "느리게 다시 생성"을 별도 옵션으로 둔 점까지 고려하면, 기본 출력은 짧고 안정적인 길이에 맞추는 것이 유리하다.

### 4. 오디오 유무는 핵심 원인으로 보이지 않는다

- 작동한 다운로드 샘플은 오디오 트랙 없이도 배경화면 설정이 가능하다.
- 따라서 오디오 제거 자체는 문제의 본질이 아닐 가능성이 높다.

### 5. `live-photo-info`의 반복 기록은 단독 원인으로 보기 어렵다

- 우리 실패 샘플도 `live-photo-info` 값이 반복된다.
- 작동한 다운로드 샘플도 프레임별 `live-photo-info`가 반복적으로 기록된다.
- 따라서 이 값의 "반복 여부"만으로 성공/실패가 갈린다고 보긴 어렵다.

## 우리 앱에 바로 적용할 만한 액션

### A. 내보내기 프로필을 하나가 아니라 여러 개로 나눈다

- 기본 모드: 가장 보수적인 호환성 중심
- 패딩 모드: 화면 가장자리에 여백을 추가한 버전
- 느린 모드: 움직임이 빠른 영상을 더 안정적으로 보이게 하는 버전

### B. 기본 프로필을 더 보수적으로 조정한다

- 비디오 `naturalSize`를 사진 방향과 반드시 일치시킨다.
- 사진과 비디오의 종횡비, orientation, 해상도를 최대한 동일하게 맞춘다.
- 비디오 길이를 우선 `1.0~1.5초` 범위로 맞춘다.
- 오디오는 선택 사항으로 두되, 호환성 판단의 핵심 변수로 취급하지 않는다.

### C. 저장 전 validator를 강화한다

- 동일한 Asset Identifier 확인
- still-image-time 존재 확인
- 사진/비디오 방향 일치 확인
- 사진/비디오 해상도 및 종횡비 일치 확인
- 길이 범위 확인

### D. "실패 우회 UX"를 제품에 반영한다

- "기본으로 저장"
- "호환성 모드로 다시 만들기"
- "패딩 추가 버전 만들기"
- "더 짧게 다시 만들기"
- "느리게 다시 만들기"

## 현재 판단의 한계

- WidgetClub의 웹/앱 흐름과 도움말만으로는 그들이 실제 MOV 메타데이터를 어떻게 생성하는지까지 확정할 수 없다.
- 따라서 이 문서는 "참고 가능한 제품 전략과 우선순위"를 정리한 것이며, 메타데이터 구현의 정답 문서로 쓰면 안 된다.
- 메타데이터 수준의 확정 비교는 실제로 WidgetClub이 만든 Live Photo 샘플을 확보해 같은 리포트 포맷으로 덤프한 뒤 판단해야 한다.

## 추천 다음 단계

1. 현재 변환 파이프라인에서 비디오 orientation과 `naturalSize`가 사진과 어떻게 어긋나는지 코드 레벨로 확인한다.
2. 기본 출력 길이를 `1.0~1.5초`로 줄인 실험 빌드를 만든다.
3. 패딩된 대체 출력 프로필을 추가한다.
4. WidgetClub 또는 다른 작동 샘플을 확보해 현재 리포트 포맷으로 비교 덤프한다.
