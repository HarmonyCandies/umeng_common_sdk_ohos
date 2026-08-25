## 1.2.10

**本包已停止维护。**

官方 [`umeng_common_sdk`](https://pub.dev/packages/umeng_common_sdk) 自 `1.3.1` 起已内置 HarmonyOS/OpenHarmony 平台支持，请直接使用官方包，无需再依赖本包：

```yaml
dependencies:
  umeng_common_sdk: ^1.3.1
```

* 修复 ohos MethodChannel 除 getPlatformVersion 外未回调 MethodResult，导致 Dart 端 initCommon / onEvent 等 Future 永久挂起

## 1.2.9

* 修复文档错误

## 1.2.8

* 增加对 HarmonyOS/OpenHarmony Flutter 的支持
* 版本号与 `umeng_common_sdk`  对齐
