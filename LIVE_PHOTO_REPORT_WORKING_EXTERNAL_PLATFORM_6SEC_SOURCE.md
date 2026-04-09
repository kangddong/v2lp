# Working External Platform Live Photo Report

이 문서는 같은 원본 6초 영상 소스에서 외부 플랫폼이 생성했고, 배경화면 설정이 가능한 것으로 확인된 Live Photo 샘플의 구조를 기록한다.

## 샘플 요약

- 라벨: `6초영상-외부플랫폼`
- 원본 특성: 같은 6초 영상 소스 기반
- 사진 리소스: `public.heic`
- 비디오 리소스: `com.apple.quicktime-movie`
- 공통 Asset Identifier: `8095F8D9-8827-4AD6-A155-B6DFE1CD7B65`

## 빠른 관찰

- 사진은 `2652x5760` HEIC, 비디오는 `884x1920` HEVC(`hvc1`)다.
- 비디오 길이는 정확히 `1.0s`다.
- 상위 `mdta`는 `content.identifier`만 있다.
- 트랙은 총 3개이며 `vide`, `meta(live-photo-info)`, `meta(still-image-time + transform)` 구성이다.
- `live-photo-info` 트랙의 `MetadataKeySetupData` 길이는 `361B`다.
- `still-image-time` 트랙에는 `reference-dimensions`는 없고, `still-image-time`과 `live-photo-still-image-transform`만 있다.

## 원본 리포트

```text
========== Live Photo Report ==========
Date: 2026-04-09 13:06:16 +0000

Resources: 2
  [0] type=1 uti=public.heic name=IMG_1986.heic
  [1] type=9 uti=com.apple.quicktime-movie name=IMG_1986.mov

---------- Resource [0]: photo ----------
UTI: public.heic
Original Filename: IMG_1986.heic
Size: 295503 bytes
Image Count: 1
Source Type: public.heic
-- Properties --
  ColorModel: RGB
  Depth: 8
  Headroom: 1
  Orientation: 1
  PixelHeight: 5760
  PixelWidth: 2652
  PrimaryImage: 1
  ProfileName: sRGB IEC61966-2.1
  {Exif}:
    ExifVersion: <array 3>
  {MakerApple}:
    17: 8095F8D9-8827-4AD6-A155-B6DFE1CD7B65
  {TIFF}:
    Orientation: 1
    TileLength: 512
    TileWidth: 512

---------- Resource [1]: pairedVideo ----------
UTI: com.apple.quicktime-movie
Original Filename: IMG_1986.mov
Size: 2161609 bytes
Duration: 1.0000s  (value=600, timescale=600)
-- Common Metadata (1) --
  commonKey=identifier value="8095F8D9-8827-4AD6-A155-B6DFE1CD7B65"
-- Metadata Formats: ["com.apple.quicktime.mdta"] --
-- Format: com.apple.quicktime.mdta --
  [mdta / com.apple.quicktime.content.identifier] id=mdta/com.apple.quicktime.content.identifier
    value="8095F8D9-8827-4AD6-A155-B6DFE1CD7B65" dataType=com.apple.metadata.datatype.UTF-8
-- Tracks (3) --
  Track id=1 type=vide
    timeRange: start=0.0s dur=1.0s
    naturalTimeScale: 600
    nominalFrameRate: 60.0
    naturalSize: (884.0, 1920.0)
    format: type='vide' subType='hvc1'
      ext[BitsPerComponent]:
        8
      ext[CVCleanAperture]:
        {
            Height = 1920;
            HorizontalOffset = 0;
            VerticalOffset = 0;
            Width = 885;
        }
      ext[CVFieldCount]:
        1
      ext[CVImageBufferChromaLocationBottomField]:
        Left
      ext[CVImageBufferChromaLocationTopField]:
        Left
      ext[CVImageBufferColorPrimaries]:
        ITU_R_709_2
      ext[CVImageBufferTransferFunction]:
        ITU_R_709_2
      ext[CVImageBufferYCbCrMatrix]:
        ITU_R_709_2
      ext[Depth]:
        24
      ext[FormatName]:
        'hvc1'
      ext[FullRangeVideo]:
        0
      ext[RevisionLevel]:
        0
      ext[SampleDescriptionExtensionAtoms]:
        {
            hvcC = {length = 105, bytes = 0x01016000 0000b000 00000000 7bf000fc ... 074401c0 2cbc14c9 };
        }
      ext[SpatialQuality]:
        0
      ext[TemporalQuality]:
        0
      ext[VerbatimSampleDescription]:
        {length = 281, bytes = 0x00000119 68766331 00000000 00000001 ... 00000001 00000000 }
      ext[Version]:
        0
  Track id=2 type=meta
    timeRange: start=0.0s dur=1.0s
    naturalTimeScale: 60000
    nominalFrameRate: 60.0
    naturalSize: (0.0, 0.0)
    format: type='meta' subType='mebx'
      ext[MetadataKeyTable]:
        {
            1 =     {
                MetadataKeyConformingDataTypes =         (
                                {
                        MetadataKeyDataType = {length = 4, bytes = 0x00000000};
                        MetadataKeyDataTypeNameSpace = 0;
                    }
                );
                MetadataKeyDataType = {length = 55, bytes = 0x636f6d2e 6170706c 652e7175 69636b74 ... 6f746f2d 696e666f };
                MetadataKeyDataTypeNameSpace = 1;
                MetadataKeyLocalID = 1;
                MetadataKeyNamespace = 1835299937;
                MetadataKeySetupData = {length = 361, bytes = 0x00000159 63666776 62706c69 73743030 ... 00000780 000005a0 };
                MetadataKeyValue = {length = 35, bytes = 0x636f6d2e 6170706c 652e7175 69636b74 ... 6f746f2d 696e666f };
            };
        }
    -- Metadata Track Samples --
    [sample 0] pts=0.0s dur=0.0s
    [sample 1] pts=0.0s dur=0.0s
    [sample 2] pts=0.0s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 3] pts=0.016666666666666666s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 4] pts=0.03333333333333333s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 5] pts=0.05s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 6] pts=0.06666666666666667s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 7] pts=0.08333333333333333s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 8] pts=0.1s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 9] pts=0.11666666666666667s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 10] pts=0.13333333333333333s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 11] pts=0.15s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 12] pts=0.16666666666666666s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 13] pts=0.18333333333333332s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 14] pts=0.2s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 15] pts=0.21666666666666667s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 16] pts=0.23333333333333334s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 17] pts=0.25s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 18] pts=0.26666666666666666s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 19] pts=0.2833333333333333s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 20] pts=0.3s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 21] pts=0.31666666666666665s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 22] pts=0.3333333333333333s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 23] pts=0.35s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 24] pts=0.36666666666666664s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 25] pts=0.38333333333333336s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 26] pts=0.4s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 27] pts=0.4166666666666667s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 28] pts=0.43333333333333335s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 29] pts=0.45s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 30] pts=0.4666666666666667s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 31] pts=0.48333333333333334s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 32] pts=0.5s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 33] pts=0.5166666666666667s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 34] pts=0.5333333333333333s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 35] pts=0.55s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 36] pts=0.5666666666666667s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 37] pts=0.5833333333333334s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 38] pts=0.6s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 39] pts=0.6166666666666667s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 40] pts=0.6333333333333333s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 41] pts=0.65s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 42] pts=0.6666666666666666s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 43] pts=0.6833333333333333s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 44] pts=0.7s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 45] pts=0.7166666666666667s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 46] pts=0.7333333333333333s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 47] pts=0.75s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 48] pts=0.7666666666666667s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 49] pts=0.7833333333333333s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 50] pts=0.8s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 51] pts=0.8166666666666667s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 52] pts=0.8333333333333334s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 53] pts=0.85s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 54] pts=0.8666666666666667s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 55] pts=0.8833333333333333s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 56] pts=0.9s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 57] pts=0.9166666666666666s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 58] pts=0.9333333333333333s dur=0.016666666666666666s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000bdc36d3ce3b5eb6d800000007b80ad425a2d64410a08cb3e7feea6bd>
    [sample 59] pts=nans dur=0.0s
    [sample 60] pts=nans dur=0.0s
    [sample 61] pts=1.0s dur=0.0s
  Track id=3 type=meta
    timeRange: start=0.0s dur=0.5016666666666667s
    naturalTimeScale: 600
    nominalFrameRate: 600.0
    naturalSize: (0.0, 0.0)
    format: type='meta' subType='mebx'
      ext[MetadataKeyTable]:
        {
            1 =     {
                MetadataKeyDataType = {length = 4, bytes = 0x00000041};
                MetadataKeyDataTypeNameSpace = 0;
                MetadataKeyLocalID = 1;
                MetadataKeyNamespace = 1835299937;
                MetadataKeyValue = {length = 36, bytes = 0x636f6d2e 6170706c 652e7175 69636b74 ... 6167652d 74696d65 };
            };
            2 =     {
                MetadataKeyDataType = {length = 4, bytes = 0x00000053};
                MetadataKeyDataTypeNameSpace = 0;
                MetadataKeyLocalID = 2;
                MetadataKeyNamespace = 1835299937;
                MetadataKeyValue = {length = 52, bytes = 0x636f6d2e 6170706c 652e7175 69636b74 ... 72616e73 666f726d };
            };
        }
    -- Metadata Track Samples --
    [sample 0] pts=0.0s dur=0.0s
    [sample 1] pts=0.0s dur=0.0s
    [sample 2] pts=0.0s dur=0.0016666666666666668s
      item key=com.apple.quicktime.still-image-time space=mdta id=mdta/com.apple.quicktime.still-image-time dt=com.apple.metadata.datatype.int8 value="-1"
      item key=com.apple.quicktime.live-photo-still-image-transform space=mdta id=mdta/com.apple.quicktime.live-photo-still-image-transform dt=com.apple.metadata.perspective-transform-float64 value=?
    [sample 3] pts=nans dur=0.0s
    [sample 4] pts=nans dur=0.0s
    [sample 5] pts=0.5016666666666667s dur=0.0s
```
