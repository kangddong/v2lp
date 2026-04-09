# Working Captured Live Photo Report

이 문서는 직접 촬영한 뒤 배경화면 설정이 가능한 것으로 확인된 Live Photo 샘플의 구조를 기록한다.

## 샘플 요약

- 라벨: `되는거3 - 직접 촬영`
- 사진 리소스: `public.jpeg`
- 비디오 리소스: `com.apple.quicktime-movie`
- 공통 Asset Identifier: `54B5722A-BC4A-493A-A00D-707D10FE8EC6`
- 촬영 기기: `iPhone 14 Pro`

## 핵심 관찰

- 비디오 공통 메타데이터에 `creationDate`, `identifier`, `location`, `make`, `model`, `software`가 포함되어 있다.
- 최상위 `mdta` 메타데이터에 `content.identifier` 외에도 위치, 기기 정보, `full-frame-rate-playback-intent`, `live-photo.vitality-score`, `live-photo.vitality-scoring-version`가 존재한다.
- 트랙은 총 5개이며 `vide`, `soun`, `meta`, `meta`, `meta` 구성이다.
- 오디오 트랙이 존재한다. 포맷은 `lpcm`이다.
- `Track id=3`은 `mdta/com.apple.quicktime.video-orientation` 전용 `mebx` 트랙이다.
- `Track id=4`는 `mdta/com.apple.quicktime.live-photo-info` 전용 `mebx` 트랙이며 `MetadataKeySetupData`와 `MetadataKeyStructuralDependency`를 포함한다.
- `Track id=5`는 `mdta/com.apple.quicktime.still-image-time`, `mdta/com.apple.quicktime.live-photo-still-image-transform`, `mdta/com.apple.quicktime.live-photo-still-image-transform-reference-dimensions`를 함께 가진 `mebx` 트랙이다.

## 다운받은 샘플과의 차이

- 직접 촬영 샘플은 `video-orientation`용 별도 `mebx` 트랙이 추가로 있다.
- 직접 촬영 샘플의 스틸 관련 메타 트랙에는 `live-photo-still-image-transform-reference-dimensions`가 더 있다.
- 직접 촬영 샘플은 위치, 기기, vitality score 계열의 상위 `mdta` 메타데이터가 더 많다.
- 직접 촬영 샘플은 오디오 트랙을 포함한다.

## 원본 리포트

```text
========== Live Photo Report ==========
Date: 2026-04-08 07:28:13 +0000

Resources: 2
  [0] type=1 uti=public.jpeg name=IMG_1124.jpeg
  [1] type=9 uti=com.apple.quicktime-movie name=IMG_1124.mov

---------- Resource [0]: photo ----------
UTI: public.jpeg
Original Filename: IMG_1124.jpeg
Size: 1769379 bytes
Image Count: 1
Source Type: public.jpeg
-- Properties --
  ColorModel: RGB
  DPIHeight: 72
  DPIWidth: 72
  Depth: 8
  Orientation: 6
  PixelHeight: 3024
  PixelWidth: 4032
  ProfileName: Display P3
  {Exif}:
    ApertureValue: 1.663754482562451
    BrightnessValue: 1.850935958468862
    ColorSpace: 65535
    ComponentsConfiguration: <array 4>
    DateTimeDigitized: 2026:01:09 18:32:08
    DateTimeOriginal: 2026:01:09 18:32:08
    DigitalZoomRatio: 1.325153374233129
    ExifVersion: <array 3>
    ExposureBiasValue: 0
    ExposureMode: 0
    ExposureProgram: 2
    ExposureTime: 0.04545454545454546
    FNumber: 1.78
    Flash: 9
    FlashPixVersion: <array 2>
    FocalLenIn35mmFilm: 64
    FocalLength: 6.86
    ISOSpeedRatings: <array 1>
    LensMake: Apple
    LensModel: iPhone 14 Pro back triple camera 6.86mm f/1.78
    LensSpecification: <array 4>
    MeteringMode: 5
    OffsetTime: +09:00
    OffsetTimeDigitized: +09:00
    OffsetTimeOriginal: +09:00
    PixelXDimension: 4032
    PixelYDimension: 3024
    SceneCaptureType: 0
    SceneType: 1
    SensingMethod: 2
    ShutterSpeedValue: 4.45371546042687
    SubjectArea: <array 4>
    SubsecTimeDigitized: 810
    SubsecTimeOriginal: 810
    WhiteBalance: 0
  {GPS}:
    Altitude: 43.63891231028668
    AltitudeRef: 0
    DateStamp: 2026:01:09
    DestBearing: 268.3829039812646
    DestBearingRef: T
    HPositioningError: 18.17182585664625
    ImgDirection: 268.3829039812646
    ImgDirectionRef: T
    Latitude: 37.39377166666667
    LatitudeRef: N
    Longitude: 126.9636
    LongitudeRef: E
    Speed: 0
    SpeedRef: K
    TimeStamp: 09:32:02
  {MakerApple}:
    1: 16
    12: <array 2>
    13: -73
    14: 0
    15: 2
    16: 3
    17: 54B5722A-BC4A-493A-A00D-707D10FE8EC6
    2: <data 512 bytes>
    20: 2
    23: 65564
    25: 0
    28: 2
    3:
      epoch: 0
      flags: 1
      timescale: 1000000000
      value: 3664128273396666
    31: 0
    32: 8593DE2F-CFC8-4D11-A652-A2C81F5BB7EA
    33: 0
    35: <array 2>
    37: 5262
    38: 3
    39: 29.71027
    4: 1
    43: 030D8F1E-327E-4739-A083-CD5A8671EF65
    45: 3421
    46: 1
    47: 110
    5: 186
    51: 24576
    52: 1
    53: 0
    54: 167
    55: 4
    56: 55
    57: 0
    58: 0
    59: 0
    6: 91
    60: 4
    61: 18
    63: 0
    64:
      0: 1
      1: 0
      2: 0
      3: 0
    65: 0
    66: 0
    67: 0
    68: 0
    69: 0
    7: 1
    70: 0
    72: 1065
    73: 0
    74: 2
    77: 37.12479
    78:
      1: 1
      2: <array 2>
    79: 0
    8: <array 3>
    82: 1
    85: 0
    88: 2051
    89: 9737
    96: 23651
    97: 24
  {TIFF}:
    DateTime: 2026:01:09 18:32:08
    HostComputer: iPhone 14 Pro
    Make: Apple
    Model: iPhone 14 Pro
    Orientation: 6
    ResolutionUnit: 2
    Software: 26.0.1
    XResolution: 72
    YResolution: 72

---------- Resource [1]: pairedVideo ----------
UTI: com.apple.quicktime-movie
Original Filename: IMG_1124.mov
Size: 5780499 bytes
Duration: 3.0433s  (value=1826, timescale=600)
-- Common Metadata (6) --
  commonKey=creationDate value="2026-01-09T18:32:07+0900"
  commonKey=identifier value="54B5722A-BC4A-493A-A00D-707D10FE8EC6"
  commonKey=location value="+37.3938+126.9636+043.639/"
  commonKey=make value="Apple"
  commonKey=model value="iPhone 14 Pro"
  commonKey=software value="26.0.1"
-- Metadata Formats: ["com.apple.quicktime.mdta"] --
-- Format: com.apple.quicktime.mdta --
  [mdta / com.apple.quicktime.location.accuracy.horizontal] id=mdta/com.apple.quicktime.location.accuracy.horizontal
    value="18.171826" dataType=com.apple.metadata.datatype.UTF-8
  [mdta / com.apple.quicktime.full-frame-rate-playback-intent] id=mdta/com.apple.quicktime.full-frame-rate-playback-intent
    value="1" dataType=com.apple.metadata.datatype.int64
  [mdta / com.apple.quicktime.content.identifier] id=mdta/com.apple.quicktime.content.identifier
    value="54B5722A-BC4A-493A-A00D-707D10FE8EC6" dataType=com.apple.metadata.datatype.UTF-8
  [mdta / com.apple.quicktime.live-photo.vitality-score] id=mdta/com.apple.quicktime.live-photo.vitality-score
    value="0.9282608032226562" dataType=com.apple.metadata.datatype.float32
  [mdta / com.apple.quicktime.live-photo.vitality-scoring-version] id=mdta/com.apple.quicktime.live-photo.vitality-scoring-version
    value="4" dataType=com.apple.metadata.datatype.int64
  [mdta / com.apple.quicktime.location.ISO6709] id=mdta/com.apple.quicktime.location.ISO6709
    value="+37.3938+126.9636+043.639/" dataType=com.apple.metadata.datatype.UTF-8
  [mdta / com.apple.quicktime.make] id=mdta/com.apple.quicktime.make
    value="Apple" dataType=com.apple.metadata.datatype.UTF-8
  [mdta / com.apple.quicktime.model] id=mdta/com.apple.quicktime.model
    value="iPhone 14 Pro" dataType=com.apple.metadata.datatype.UTF-8
  [mdta / com.apple.quicktime.software] id=mdta/com.apple.quicktime.software
    value="26.0.1" dataType=com.apple.metadata.datatype.UTF-8
  [mdta / com.apple.quicktime.creationdate] id=mdta/com.apple.quicktime.creationdate
    value="2026-01-09T18:32:07+0900" dataType=com.apple.metadata.datatype.UTF-8
-- Tracks (5) --
  Track id=1 type=vide
    timeRange: start=0.0s dur=3.0433333333333334s
    naturalTimeScale: 600
    nominalFrameRate: 28.915663
    naturalSize: (1744.0, 1308.0)
    format: type='vide' subType='avc1'
      ext[CVCleanAperture]:
        {
            Height = 1308;
            HorizontalOffset = 0;
            VerticalOffset = 0;
            Width = 1744;
        }
      ext[CVFieldCount]:
        1
      ext[CVImageBufferChromaLocationBottomField]:
        Left
      ext[CVImageBufferChromaLocationTopField]:
        Left
      ext[CVImageBufferColorPrimaries]:
        P3_D65
      ext[CVImageBufferTransferFunction]:
        ITU_R_709_2
      ext[CVImageBufferYCbCrMatrix]:
        ITU_R_601_4
      ext[Depth]:
        24
      ext[FormatName]:
        H.264
      ext[FullRangeVideo]:
        1
      ext[RevisionLevel]:
        0
      ext[SampleDescriptionExtensionAtoms]:
        {
            avcC = {length = 157, bytes = 0x01640032 ffe1008a 27640032 ad843080 ... 28ee3cb0 fdf8f800 };
        }
      ext[SpatialQuality]:
        512
      ext[TemporalQuality]:
        512
      ext[VerbatimSampleDescription]:
        {length = 313, bytes = 0x00000139 61766331 00000000 00000001 ... 00000001 00000000 }
      ext[Version]:
        0
  Track id=2 type=soun
    timeRange: start=0.0s dur=3.0433333333333334s
    naturalTimeScale: 48000
    nominalFrameRate: 48000.0
    naturalSize: (0.0, 0.0)
    format: type='soun' subType='lpcm'
      ext[VerbatimSampleDescription]:
        {length = 72, bytes = 0x00000048 6c70636d 00000000 00000001 ... 00000002 00000001 }
  Track id=3 type=meta
    timeRange: start=0.0s dur=3.0433333333333334s
    naturalTimeScale: 600
    nominalFrameRate: 0.32858709
    naturalSize: (0.0, 0.0)
    format: type='meta' subType='mebx'
      ext[MetadataKeyTable]:
        {
            1 =     {
                MetadataKeyDataType = {length = 4, bytes = 0x00000042};
                MetadataKeyDataTypeNameSpace = 0;
                MetadataKeyLocalID = 1;
                MetadataKeyNamespace = 1835299937;
                MetadataKeyStructuralDependency =         {
                    StructuralDependencyIsInvalidFlag = 0;
                };
                MetadataKeyValue = {length = 37, bytes = 0x636f6d2e 6170706c 652e7175 69636b74 ... 656e7461 74696f6e };
            };
        }
    -- Metadata Track Samples --
    [sample 0] pts=0.0s dur=0.0s
    [sample 1] pts=0.0s dur=3.0433333333333334s
      item key=com.apple.quicktime.video-orientation space=mdta id=mdta/com.apple.quicktime.video-orientation dt=com.apple.metadata.datatype.int16 value="6"
    [sample 2] pts=nans dur=0.0s
    [sample 3] pts=nans dur=0.0s
    [sample 4] pts=3.0433333333333334s dur=0.0s
  Track id=4 type=meta
    timeRange: start=0.0s dur=3.0433333333333334s
    naturalTimeScale: 600
    nominalFrameRate: 28.915663
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
                MetadataKeyStructuralDependency =         {
                    StructuralDependencyIsInvalidFlag = 0;
                };
                MetadataKeyValue = {length = 35, bytes = 0x636f6d2e 6170706c 652e7175 69636b74 ... 6f746f2d 696e666f };
            };
        }
    -- Metadata Track Samples --
    [sample 0] pts=0.0s dur=0.0s
    [sample 1] pts=0.0s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3caa5bf69839000000b7d6fc29735bee28b935e63f2985803f>
    [sample 2] pts=0.03333333333333333s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c8d65109b3d0000002ee8933f54c12bbf93dff43ffc9d613f>
    [sample 3] pts=0.06666666666666667s dur=0.035s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3cb038141c34000000c8f802405ba7b9bfdf9eba3f98a3713f>
    [sample 4] pts=0.10166666666666667s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3cf0e1ad9a320000005b7730409feb0ac062ad80be87cdb53f>
    [sample 5] pts=0.135s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3ce443050f36000000e6c93640e6d431c0df9a2ec01b51933f>
    [sample 6] pts=0.16833333333333333s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c8778364f38000000361c7b409d2d76c02a5a933f3c7753bf>
    [sample 7] pts=0.20166666666666666s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c1c650c9310000000effe2b41f6e5f3c0aa8cac4119482dc1>
    [sample 8] pts=0.235s dur=0.035s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c4956d18d2f0000001dea3e41b70a21c13eae993ff9bf1ac1>
    [sample 9] pts=0.27s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c9f7e7fa436000000efdf3d41ab922ac103108940245bf3c0>
    [sample 10] pts=0.30333333333333334s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3cd5e7ad4334000000f1de4241bb173fc1847d9040306848c1>
    [sample 11] pts=0.33666666666666667s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c6d5ea04733000000098b43414bbd43c16512c0bf35b90ac1>
    [sample 12] pts=0.37s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c675296da260000003ede294134f22cc139dbe6c042588340>
    [sample 13] pts=0.4033333333333333s dur=0.035s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c07ff55ee3600000085563e4173a3fcc0263ca93f9df81c41>
    [sample 14] pts=0.43833333333333335s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3ca696915638000000b2a05841c61c01c1e6203abe5867ee3f>
    [sample 15] pts=0.4716666666666667s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c6a6541083900000067ba72410d0b1cc128a69abfd04372bf>
    [sample 16] pts=0.505s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c61788e97340000007f058741faad3cc1173cacbfcc960cc0>
    [sample 17] pts=0.5383333333333333s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c3a6c9ecf30000000e61a96418bb256c157cdbbbf5b55a4bf>
    [sample 18] pts=0.5716666666666667s dur=0.035s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3cd0495f7c350000003c25a741dd986ac1a1f05ebf78b17dbf>
    [sample 19] pts=0.6066666666666667s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c3ace8481390000007ad2b84106ea7dc1e1aaffbe0bc3f9bf>
    [sample 20] pts=0.64s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c5083cf57390000005d9bcb41a82287c1b2e8a93e63e8b1bf>
    [sample 21] pts=0.6733333333333333s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c607bb1e2350000007820df4157c68ec13e1a953e15997abf>
    [sample 22] pts=0.7066666666666667s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c3e61df0c360000008d67f341d5ee9ac18ff3933d03db53c0>
    [sample 23] pts=0.74s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3cea716df52f000000734904429fe9a2c1258175bd450095be>
    [sample 24] pts=0.7733333333333333s dur=0.035s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3ceb47495332000000c4220f428c5dadc113bf11bfb63341c0>
    [sample 25] pts=0.8083333333333333s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c2c7329583b00000015b61942cb4ab1c19d0da4bffa5de73f>
    [sample 26] pts=0.8416666666666667s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c082dea9a3700000020942542007fb0c1a6cefbbe513e7140>
    [sample 27] pts=0.875s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c0f96ffae300000002c263342fdbcbdc18d42bb3e7be81cc0>
    [sample 28] pts=0.9083333333333333s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3caeecada131000000a711414214b0c8c10be73c3d9dc8a2bd>
    [sample 29] pts=0.9416666666666667s dur=0.035s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3cbfc2028e3300000005944f4233fac9c10cf65d3edcea9340>
    [sample 30] pts=0.9766666666666667s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3cf46eb62e33000000065e5e42e6e5d2c1aaf0193fc427fc3f>
    [sample 31] pts=1.01s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3cc0c403dd3200000034616d429ee3dec1fd6c363f4101573f>
    [sample 32] pts=1.0433333333333332s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c2c2c419f3000000099df7c42270bebc12e50143f5e06c03e>
    [sample 33] pts=1.0766666666666667s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c2631e9942c0000005c748642b9c0f6c1267f2d3f25e2163f>
    [sample 34] pts=1.11s dur=0.035s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3cb965194c3a000000ecc58e42e8ff00c28718783fca8df43e>
    [sample 35] pts=1.145s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3ca17a01483a000000d65a9742598806c26953013f0be03d3e>
    [sample 36] pts=1.1783333333333332s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c5237909535000000bf39a0425d050cc287e6a23e14468e3e>
    [sample 37] pts=1.2116666666666667s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3cc83e1514390000007f63a942a68111c2d506193e2aee143f>
    [sample 38] pts=1.245s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c53b025ef4200000079d1b242991317c2e11793bcff1de33d>
    [sample 39] pts=1.2783333333333333s dur=0.035s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c4ae470af3f0000007786bc4297c41cc2cf19183d53d839be>
    [sample 40] pts=1.3133333333333332s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c3c5d55953e0000009882c6429f8622c2c9a296bcd94d07bd>
    [sample 41] pts=1.3466666666666667s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c1a58aa2a3e00000067c4d042356d28c23def573e5d5e15be>
    [sample 42] pts=1.38s dur=0.06833333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c2ddc5b113d000000b050db4233822ec21c86cdbdb1a308bd>
    [sample 43] pts=1.4483333333333333s dur=0.08s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c6a11870b350000003877f24226bf39c2bf3d8340dcc373be>
    [sample 44] pts=1.5283333333333333s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3cf234290306000000d946124308e845c298b9f0417bb72f3e>
    [sample 45] pts=1.5616666666666668s dur=0.035s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c384d31a1130000001c371e43f1324ec22b324442a07b1bc0>
    [sample 46] pts=1.5966666666666667s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c74b000a022000000e62d20434f7555c2c8ff2f4024c915c0>
    [sample 47] pts=1.63s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3cd777d201190000001a7c2e4318215ec2de7ceec06ecd98be>
    [sample 48] pts=1.6633333333333333s dur=0.035s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3cd39fa22826000000b22a38434ce264c250726fbf4f3a0e40>
    [sample 49] pts=1.6983333333333333s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3cae95e9fd260000003f1b3f43d0806bc2c0bf0dc0a8a9913e>
    [sample 50] pts=1.7316666666666667s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3cf90cf66f230000006439444377fa71c291c75cc018f5ae3e>
    [sample 51] pts=1.765s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3cc6e13d61200000005f9648435a6f78c2b27338c03b52c03e>
    [sample 52] pts=1.7983333333333333s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c20c66ce021000000aa154d4395f97ec20f50c6bf24a9053f>
    [sample 53] pts=1.8316666666666668s dur=0.035s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c93a9c9900c000000e7a655439f9082c27e078341c9314f3f>
    [sample 54] pts=1.8666666666666667s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c1c8e017708000000eba36243fada87c2b1fdaa4127cdbcc0>
    [sample 55] pts=1.9s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3cafe9118806000000d38b73432b758fc2d0c8dd41380ddec0>
    [sample 56] pts=1.9333333333333333s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3cc80bc35e0c000000ca6e83438ad79ec2ff3cd14101efccc1>
    [sample 57] pts=1.9666666666666666s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c9cf76a4412000000d7658b439bf5acc2da657f41491a45c1>
    [sample 58] pts=2.0s dur=0.035s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3cd3b9e8632c000000a3b090434a4db7c242439ac0d77d0740>
    [sample 59] pts=2.035s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c53443d4d27000000c9919443af67bec2470b62409f342bc0>
    [sample 60] pts=2.0683333333333334s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3cedd024641000000005b7984371e0c5c23c988241a75d6fc1>
    [sample 61] pts=2.1016666666666666s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c0af5ebb80a000000997c9c433366ccc2602f6b41072a9cc0>
    [sample 62] pts=2.135s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c7941e03c0d000000bcda9f437bf1d1c2776e404120601f40>
    [sample 63] pts=2.1683333333333334s dur=0.035s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c93c328ae0c00000022e4a2433635d6c2b5463a41ad3237bf>
    [sample 64] pts=2.203333333333333s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3cbb29f87d07000000fe49a643886bd9c22df187415293ae3f>
    [sample 65] pts=2.236666666666667s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3cfce5c43109000000b3c5a9438acbdbc239b37941bef2a33f>
    [sample 66] pts=2.27s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3ccdb8150325000000ca08ad43edbeddc2fdd58c40b8f9a4c0>
    [sample 67] pts=2.3033333333333332s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3cd112d51420000000e55cb04335f3e1c2cc00dd407bc03dc1>
    [sample 68] pts=2.3366666666666664s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c0510c9f9080000005510b4437fa0e6c2c9ab7c419855abc0>
    [sample 69] pts=2.37s dur=0.035s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c1e73718a0b000000f4b3b743605aeac2b89e4d412f8bc33f>
    [sample 70] pts=2.405s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c57f5968222000000a80abb436b41edc2cba38e40c01b93c0>
    [sample 71] pts=2.4383333333333335s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c6f9410812c000000b81cbe435f99efc236d848406e3a9dc0>
    [sample 72] pts=2.4716666666666667s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3cc4d917b8200000004705c143df6af1c21a70fd408c6a50c0>
    [sample 73] pts=2.505s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3cd8d977ce3700000016d3c3434404f3c28d150c40f81cb8bf>
    [sample 74] pts=2.5383333333333336s dur=0.035s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c67ad9731260000000f6ec5431005f5c28a2afcc0960a41bf>
    [sample 75] pts=2.5733333333333333s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3cc434646914000000d849c5438293f7c26d3b45c17426afbf>
    [sample 76] pts=2.6066666666666665s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c8178f3022a00000045fec4438a46f8c24492aec07a574d40>
    [sample 77] pts=2.64s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3ca4bef60e2c0000002584c5434fa4f8c24b5784c046ec483f>
    [sample 78] pts=2.6733333333333333s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c8960c1852700000000cdc643ee5ef9c28253b0c0d2d4d4bf>
    [sample 79] pts=2.7066666666666666s dur=0.035s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c007859f93400000095d0c843094afac2d204b4bf983f0cc0>
    [sample 80] pts=2.7416666666666667s dur=0.03333333333333333s
      item key=com.apple.quicktime.live-photo-info space=mdta id=mdta/com.apple.quicktime.live-photo-info dt=com.apple.quicktime.com.apple.quicktime.live-photo-info value=<data 136B: 03000000ffd0cc3c164a6c7e360000002456cb431c55fbc252f4babe7e7cbfbd>
    (truncated at 80)
  Track id=5 type=meta
    timeRange: start=0.0s dur=1.495s
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
    [sample 1] pts=0.0s dur=0.0s
    [sample 2] pts=0.0s dur=0.0016666666666666668s
      item key=com.apple.quicktime.still-image-time space=mdta id=mdta/com.apple.quicktime.still-image-time dt=com.apple.metadata.datatype.int8 value="-1"
      item key=com.apple.quicktime.live-photo-still-image-transform space=mdta id=mdta/com.apple.quicktime.live-photo-still-image-transform dt=com.apple.metadata.perspective-transform-float64 value=?
      item key=com.apple.quicktime.live-photo-still-image-transform-reference-dimensions space=mdta id=mdta/com.apple.quicktime.live-photo-still-image-transform-reference-dimensions dt=com.apple.metadata.datatype.dimensions-float32 value=?
    [sample 3] pts=nans dur=0.0s
    [sample 4] pts=nans dur=0.0s
    [sample 5] pts=1.495s dur=0.0s
```
