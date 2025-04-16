# umeng_common_sdk_ohos

[![pub package](https://img.shields.io/pub/v/umeng_common_sdk_ohos.svg)](https://pub.dartlang.org/packages/umeng_common_sdk_ohos)
[![GitHub stars](https://img.shields.io/github/stars/harmonycandies/umeng_common_sdk_ohos)](https://github.com/harmonycandies/umeng_common_sdk_ohos/stargazers)
[![GitHub forks](https://img.shields.io/github/forks/harmonycandies/umeng_common_sdk_ohos)](https://github.com/harmonycandies/umeng_common_sdk_ohos/network)
[![GitHub license](https://img.shields.io/github/license/harmonycandies/umeng_common_sdk_ohos)](https://github.com/harmonycandies/umeng_common_sdk_ohos/blob/main/LICENSE)
[![GitHub issues](https://img.shields.io/github/issues/harmonycandies/umeng_common_sdk_ohos)](https://github.com/harmonycandies/umeng_common_sdk_ohos/issues)
[![flutter-candies](https://pub.idqqimg.com/wpa/images/group.png)](https://qm.qq.com/q/ajfsyk2RcA)

[`device_info_plus`][1] 在 OpenHarmony 平台的实现。

## 集成

```yaml
dependencies:
  umeng_common_sdk: 1.2.8
  umeng_common_sdk_ohos: 1.2.8
```

### OpenHarmony/HarmonyOS

在项目的 `AppScope/resources/rawfile` 目录下新增一个配置文件 `umconfig.json`

```json
{
  "appKey": "你的apppkey",
  "channel": "你的渠道"
}
```

虽然当前平台不使用 `UmengCommonSdk.initCommon` 提供的配置

但是仍然需要调用 `UmengCommonSdk.initCommon` 方法来完成 SDK 的初始化

### 示例

```dart
import 'package:umeng_common_sdk/umeng_common_sdk.dart';

// Initialize the SDK 
UmengCommonSdk.initCommon('android_key', 'ios_key', 'channel');

// track the event
UmengCommonSdk.onEvent('event_id', {
    'key1': 'value1',
    'key2': 'value2',
});
```

### 支持的方法

受限于 SDK，当前在 OpenHarmony 平台仅支持以下方法

```text
UmengCommonSdk.initCommon
UmengCommonSdk.onEvent
UmengCommonSdk.onProfileSignIn
UmengCommonSdk.onProfileSignOff
```

[1]: https://pub.dev/packages/umeng_common_sdk
