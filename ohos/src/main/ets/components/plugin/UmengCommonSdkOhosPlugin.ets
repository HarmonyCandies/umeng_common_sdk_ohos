import {
  AbilityAware,
  AbilityPluginBinding,
  Any,
  FlutterPlugin,
  FlutterPluginBinding,
  MethodCall,
  MethodCallHandler,
  MethodChannel,
  MethodResult,
} from '@ohos/flutter_ohos';
import { common } from '@kit.AbilityKit';
import * as umeng from '@umeng/analytics';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = "UmengCommonSdkOhosPlugin";

/** UmengCommonSdkOhosPlugin **/
export default class UmengCommonSdkOhosPlugin implements FlutterPlugin, MethodCallHandler, AbilityAware {
  private context: common.UIAbilityContext | null = null;
  private channel: MethodChannel | null = null;

  getUniqueClassName(): string {
    return "UmengCommonSdkOhosPlugin"
  }

  onAttachedToEngine(binding: FlutterPluginBinding): void {
    this.channel = new MethodChannel(binding.getBinaryMessenger(), "umeng_common_sdk");
    this.channel.setMethodCallHandler(this)
  }

  onDetachedFromEngine(binding: FlutterPluginBinding): void {
    if (this.channel != null) {
      this.channel.setMethodCallHandler(null)
    }
  }

  onAttachedToAbility(binding: AbilityPluginBinding): void {
    this.context = binding.getAbility().context;
    umeng.preInit({
      context: this.context.getApplicationContext(),
      plugins: [
        new umeng.InternalPlugin(),
      ],
    });
  }

  onDetachedFromAbility(): void {
    this.context = null;
  }

  onMethodCall(call: MethodCall, result: MethodResult): void {
    switch (call.method) {
      case "getPlatformVersion":
        result.success("OpenHarmony ^ ^ ");
        break;
      case "initCommon":
        this.initCommon();
        break;
      case "onEvent":
        this.onEvent(call.args);
        break;
      case "onProfileSignIn":
        this.onProfileSignIn(call.args);
        break;
      case "onProfileSignOff":
        this.onProfileSignOff();
        break;
      case "setPageCollectionModeAuto":
        this.setPageCollectionModeAuto();
        break;
      case "setPageCollectionModeManual":
        this.setPageCollectionModeManual();
        break;
      case "onPageStart":
        this.onPageStart(call.args);
        break;
      case "onPageEnd":
        this.onPageEnd(call.args);
        break;
      case "reportError":
        this.reportError(call.args);
        break;
      default:
        result.notImplemented();
        break;
    }
  }

  // 鸿蒙 SDK，配置在项目的 AppScope/resources/rawfile/umconfig.json 中
  private initCommon(): void {
    umeng.init();
  }

  private umengOnEventObject(eventID: string, params?: Map<string, Any>): void {
    let _params: Record<string, string | number> | undefined = undefined;
    if (params != null) {
      _params = {};
      params.forEach((value: Any, key: string) => {
        _params![key] = value as string | number;
      });
    }
    umeng.onEventObject(eventID, _params);
  }

  private onEvent(args: Any[]): void {
    let event: string = args[0];
    let props: Map<string, Any> | undefined;

    if (args.length > 1) {
      props = args[1];
    }

    this.umengOnEventObject(event, props);
  }

  private onProfileSignIn(args: Any[]): void {
    let userId: string = args[0];
    umeng.onProfileSignIn("account", userId)
  }

  private onProfileSignOff(): void {
    umeng.onProfileSignOff();
  }

  private setPageCollectionModeAuto(): void {
    hilog.info(0x0000, TAG, '%{public}s', "setPageCollectionModeAuto is not available for ohos now");
  }

  private setPageCollectionModeManual(): void {
    hilog.info(0x0000, TAG, '%{public}s', "setPageCollectionModeManual is not available for ohos now");
  }

  private onPageStart(args: Any[]): void {
    hilog.info(0x0000, TAG, '%{public}s', "onPageStart is not available for ohos now");
  }

  private onPageEnd(args: Any[]): void {
    hilog.info(0x0000, TAG, '%{public}s', "onPageEnd is not available for ohos now");
  }

  private reportError(args: Any[]): void {
    hilog.info(0x0000, TAG, '%{public}s', "reportError is not available for ohos now");
  }
}