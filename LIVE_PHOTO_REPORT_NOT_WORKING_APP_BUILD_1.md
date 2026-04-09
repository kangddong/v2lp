# Not Working App Build 1 Live Photo Report

이 문서는 같은 6초 영상 소스를 우리 앱으로 변환했고, 배경화면 설정이 되지 않은 Live Photo 샘플의 구조를 기록한다.

## 샘플 요약

- 라벨: `6초영상 - 우리 앱에서 만든 것`
- 생성 주체: 우리 앱
- 원본 특성: 같은 6초 영상 소스 기반
- 사진 리소스: `public.jpeg`
- 비디오 리소스: `com.apple.quicktime-movie`
- 공통 Asset Identifier: `D1FE61E0-E804-4204-99A6-62AB93703F86`

## 빠른 관찰

- 사진은 `478x848` JPEG, 비디오는 `478x848` H.264(`avc1`)다.
- 비디오 길이는 약 `3.0233s`다.
- 상위 `mdta`는 `content.identifier`만 있다.
- 트랙은 총 4개이며 `vide`, `soun`, `meta(still-image-time + transform + reference-dimensions)`, `meta(live-photo-info)` 구성이다.
- `live-photo-info` 트랙의 `MetadataKeySetupData` 길이는 `390B`다.
- `still-image-time` 트랙에는 외부 플랫폼 작동본과 달리 `reference-dimensions`가 추가되어 있다.

## 원본 리포트

```text
========== Live Photo Report ==========
Date: 2026-04-09 13:06:56 +0000

Resources: 2
  [0] type=1 uti=public.jpeg name=IMG_1990.jpeg
  [1] type=9 uti=com.apple.quicktime-movie name=IMG_1990.mov

---------- Resource [0]: photo ----------
UTI: public.jpeg
Original Filename: IMG_1990.jpeg
Size: 77488 bytes
Image Count: 1
Source Type: public.jpeg
-- Properties --
  ColorModel: RGB
  DPIHeight: 72
  DPIWidth: 72
  Depth: 8
  Orientation: 1
  PixelHeight: 848
  PixelWidth: 478
  ProfileName: HDTV
  {Exif}:
    ColorSpace: 65535
    PixelXDimension: 478
    PixelYDimension: 848
  {JFIF}:
    DensityUnit: 0
    JFIFVersion: <array 3>
    XDensity: 72
    YDensity: 72
  {MakerApple}:
    17: D1FE61E0-E804-4204-99A6-62AB93703F86
  {TIFF}:
    Orientation: 1
    ResolutionUnit: 2
    XResolution: 72
    YResolution: 72

---------- Resource [1]: pairedVideo ----------
UTI: com.apple.quicktime-movie
Original Filename: IMG_1990.mov
Size: 76130 bytes
Duration: 3.0233s  (value=133329, timescale=44100)
-- Common Metadata (1) --
  commonKey=identifier value="D1FE61E0-E804-4204-99A6-62AB93703F86"
-- Metadata Formats: ["com.apple.quicktime.mdta"] --
-- Format: com.apple.quicktime.mdta --
  [mdta / com.apple.quicktime.content.identifier] id=mdta/com.apple.quicktime.content.identifier
    value="D1FE61E0-E804-4204-99A6-62AB93703F86" dataType=com.apple.metadata.datatype.UTF-8
-- Tracks (4) --
  Track id=1 type=vide
    timeRange: start=0.0s dur=3.0233333333333334s
    naturalTimeScale: 600
    nominalFrameRate: 31.753033
    naturalSize: (478.0, 848.0)
    format: type='vide' subType='avc1'
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
        H.264
      ext[FullRangeVideo]:
        0
      ext[RevisionLevel]:
        0
      ext[SampleDescriptionExtensionAtoms]:
        {
            avcC = {length = 35, bytes = 0x0164001f ffe10010 2764001f ac565078 ... 28ee3cb0 fdf8f800 };
        }
      ext[SpatialQuality]:
        512
      ext[TemporalQuality]:
        512
      ext[VerbatimSampleDescription]:
        {length = 151, bytes = 0x00000097 61766331 00000000 00000001 ... 00010001 00000000 }
      ext[Version]:
        0
  Track id=2 type=soun
    timeRange: start=0.0s dur=3.0s
    naturalTimeScale: 44100
    nominalFrameRate: 43.066406
    naturalSize: (0.0, 0.0)
    format: type='soun' subType='aac '
      ext[VerbatimSampleDescription]:
        {length = 143, bytes = 0x0000008f 6d703461 00000000 00000001 ... 00000008 00000000 }
  Track id=3 type=meta
    timeRange: start=0.0s dur=0.0016780045351473922s
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
            3 =     {
                MetadataKeyDataType = {length = 4, bytes = 0x00000047};
                MetadataKeyDataTypeNameSpace = 0;
                MetadataKeyLocalID = 3;
                MetadataKeyNamespace = 1835299937;
                MetadataKeyValue = {length = 73, bytes = 0x636f6d2e 6170706c 652e7175 69636b74 ... 6d656e73 696f6e73 };
            };
        }
    -- Metadata Track Samples --
    [sample 0] pts=0.0s dur=0.0s
    [sample 1] pts=0.0s dur=0.0016666666666666668s
      item key=com.apple.quicktime.still-image-time space=mdta id=mdta/com.apple.quicktime.still-image-time dt=com.apple.metadata.datatype.int8 value="-1"
      item key=com.apple.quicktime.live-photo-still-image-transform space=mdta id=mdta/com.apple.quicktime.live-photo-still-image-transform dt=com.apple.metadata.perspective-transform-float64 value=?
      item key=com.apple.quicktime.live-photo-still-image-transform-reference-dimensions space=mdta id=mdta/com.apple.quicktime.live-photo-still-image-transform-reference-dimensions dt=com.apple.metadata.datatype.dimensions-float32 value=?
    [sample 2] pts=nans dur=0.0s
    [sample 3] pts=nans dur=0.0s
    [sample 4] pts=0.0016780045351473922s dur=0.0s
  Track id=4 type=meta
    timeRange: start=0.0s dur=2.993333333333333s
    naturalTimeScale: 600
    nominalFrameRate: 32.07127
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
                MetadataKeySetupData = {length = 390, bytes = 0x00000176 63666776 62706c69 73743030 ... 00000780 000005a0 };
                MetadataKeyValue = {length = 35, bytes = 0x636f6d2e 6170706c 652e7175 69636b74 ... 6f746f2d 696e666f };
            };
        }
    -- Metadata Track Samples --
    [sample 0] pts=0.0s dur=0.0s
    [sample 1] pts=0.0s dur=0.015s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 2] pts=0.015s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 3] pts=0.04666666666666667s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 4] pts=0.07833333333333334s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 5] pts=0.11s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 6] pts=0.14166666666666666s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 7] pts=0.17333333333333334s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 8] pts=0.205s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 9] pts=0.23666666666666666s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 10] pts=0.2683333333333333s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 11] pts=0.3s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 12] pts=0.33166666666666667s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 13] pts=0.36333333333333334s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 14] pts=0.395s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 15] pts=0.4266666666666667s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 16] pts=0.4583333333333333s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 17] pts=0.49s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 18] pts=0.5216666666666666s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 19] pts=0.5533333333333333s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 20] pts=0.585s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 21] pts=0.6166666666666667s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 22] pts=0.6483333333333333s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 23] pts=0.68s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 24] pts=0.7116666666666667s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 25] pts=0.7433333333333333s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 26] pts=0.775s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 27] pts=0.8066666666666666s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 28] pts=0.8383333333333334s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 29] pts=0.87s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 30] pts=0.9016666666666666s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 31] pts=0.9333333333333333s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 32] pts=0.965s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 33] pts=0.9966666666666667s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 34] pts=1.0283333333333333s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 35] pts=1.06s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 36] pts=1.0916666666666666s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 37] pts=1.1233333333333333s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 38] pts=1.155s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 39] pts=1.1866666666666668s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 40] pts=1.2183333333333333s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 41] pts=1.25s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 42] pts=1.2816666666666667s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 43] pts=1.3133333333333332s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 44] pts=1.345s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 45] pts=1.3766666666666667s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 46] pts=1.4083333333333334s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 47] pts=1.44s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 48] pts=1.4716666666666667s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 49] pts=1.5033333333333334s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 50] pts=1.535s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 51] pts=1.5666666666666667s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 52] pts=1.5983333333333334s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 53] pts=1.63s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 54] pts=1.6616666666666666s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 55] pts=1.6933333333333334s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 56] pts=1.725s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 57] pts=1.7566666666666666s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 58] pts=1.7883333333333333s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 59] pts=1.82s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 60] pts=1.8516666666666666s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 61] pts=1.8833333333333333s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 62] pts=1.915s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 63] pts=1.9466666666666668s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 64] pts=1.9783333333333333s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 65] pts=2.01s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 66] pts=2.0416666666666665s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 67] pts=2.0733333333333333s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 68] pts=2.105s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 69] pts=2.1366666666666667s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 70] pts=2.1683333333333334s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 71] pts=2.2s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 72] pts=2.2316666666666665s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 73] pts=2.263333333333333s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 74] pts=2.295s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 75] pts=2.3266666666666667s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 76] pts=2.3583333333333334s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 77] pts=2.39s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 78] pts=2.421666666666667s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 79] pts=2.453333333333333s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    [sample 80] pts=2.485s dur=0.03166666666666667s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000d195883cd2a773172e0000004c7ebf27e91997a98afedd3dc4a9533e>
    (truncated at 80)
```
