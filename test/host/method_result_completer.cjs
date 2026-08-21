'use strict';

/**
 * Host-runnable twin of
 * ohos/src/main/ets/components/plugin/method_result_completer.ets
 *
 * Keep the method → outcome mapping in sync with the ArkTS helper.
 * The plugin cannot be constructed on a Linux host (Flutter OHOS + Umeng SDK).
 */

const RESULT_NONE = 'none';
const RESULT_SUCCESS = 'success';
const RESULT_ERROR = 'error';
const RESULT_NOT_IMPLEMENTED = 'notImplemented';

const KNOWN_METHODS = [
  'getPlatformVersion',
  'initCommon',
  'onEvent',
  'onProfileSignIn',
  'onProfileSignOff',
  'setPageCollectionModeAuto',
  'setPageCollectionModeManual',
  'onPageStart',
  'onPageEnd',
  'reportError',
];

class MethodOutcome {
  constructor(status, value, errorCode, errorMessage) {
    this.status = status;
    this.value = value;
    this.errorCode = errorCode;
    this.errorMessage = errorMessage;
  }
}

function hasListArg(args, index) {
  if (args == null) {
    return false;
  }
  if (args.length == null) {
    return false;
  }
  return args.length > index && args[index] != null;
}

function completeResult(method, args, hasContext) {
  switch (method) {
    case 'getPlatformVersion':
      return new MethodOutcome(RESULT_SUCCESS, 'OpenHarmony ^ ^ ', '', '');
    case 'initCommon':
      if (!hasContext) {
        return new MethodOutcome(RESULT_ERROR, null, 'NO_CONTEXT',
          'Ability context is null; plugin is not attached to an ability');
      }
      return new MethodOutcome(RESULT_SUCCESS, null, '', '');
    case 'onEvent':
      if (!hasListArg(args, 0)) {
        return new MethodOutcome(RESULT_ERROR, null, 'INVALID_ARGS', 'onEvent requires an event id');
      }
      return new MethodOutcome(RESULT_SUCCESS, null, '', '');
    case 'onProfileSignIn':
      if (!hasListArg(args, 0)) {
        return new MethodOutcome(RESULT_ERROR, null, 'INVALID_ARGS', 'onProfileSignIn requires a user id');
      }
      return new MethodOutcome(RESULT_SUCCESS, null, '', '');
    case 'onProfileSignOff':
    case 'setPageCollectionModeAuto':
    case 'setPageCollectionModeManual':
    case 'onPageStart':
    case 'onPageEnd':
    case 'reportError':
      return new MethodOutcome(RESULT_SUCCESS, null, '', '');
    default:
      return new MethodOutcome(RESULT_NOT_IMPLEMENTED, null, '', '');
  }
}

function applyMethodOutcome(result, outcome) {
  if (outcome.status === RESULT_SUCCESS) {
    result.success(outcome.value);
    return;
  }
  if (outcome.status === RESULT_ERROR) {
    result.error(outcome.errorCode, outcome.errorMessage, null);
    return;
  }
  if (outcome.status === RESULT_NOT_IMPLEMENTED) {
    result.notImplemented();
    return;
  }
  result.error('INCOMPLETE_RESULT', `MethodResult was not completed (status=${outcome.status})`, null);
}

class RecordingMethodResult {
  constructor() {
    this.status = RESULT_NONE;
    this.value = undefined;
    this.errorCode = undefined;
    this.errorMessage = undefined;
    this.errorDetails = undefined;
    this.completions = 0;
  }

  success(value) {
    this._complete(RESULT_SUCCESS);
    this.value = value;
  }

  error(code, message, details) {
    this._complete(RESULT_ERROR);
    this.errorCode = code;
    this.errorMessage = message;
    this.errorDetails = details;
  }

  notImplemented() {
    this._complete(RESULT_NOT_IMPLEMENTED);
  }

  _complete(status) {
    if (this.status !== RESULT_NONE) {
      throw new Error(`MethodResult completed twice (was ${this.status}, now ${status})`);
    }
    this.status = status;
    this.completions += 1;
  }
}

/**
 * Host stand-in for UmengCommonSdkOhosPlugin.onMethodCall.
 * Completes a fake MethodResult without the Umeng SDK or a Harmony device.
 */
function onMethodCall(method, args, result, hasContext) {
  const outcome = completeResult(method, args, hasContext);
  applyMethodOutcome(result, outcome);
  return result;
}

module.exports = {
  RESULT_NONE,
  RESULT_SUCCESS,
  RESULT_ERROR,
  RESULT_NOT_IMPLEMENTED,
  KNOWN_METHODS,
  MethodOutcome,
  completeResult,
  applyMethodOutcome,
  RecordingMethodResult,
  onMethodCall,
};
