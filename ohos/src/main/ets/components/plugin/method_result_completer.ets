/**
 * Host-testable MethodResult completion policy.
 *
 * Flutter MethodChannel Futures stay pending until result.success / result.error /
 * result.notImplemented is invoked. Returning status "none" is the hang bug.
 */

export const RESULT_NONE: string = 'none';
export const RESULT_SUCCESS: string = 'success';
export const RESULT_ERROR: string = 'error';
export const RESULT_NOT_IMPLEMENTED: string = 'notImplemented';

export const KNOWN_METHODS: string[] = [
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

export class MethodOutcome {
  status: string;
  value: string | null;
  errorCode: string;
  errorMessage: string;

  constructor(status: string, value: string | null, errorCode: string, errorMessage: string) {
    this.status = status;
    this.value = value;
    this.errorCode = errorCode;
    this.errorMessage = errorMessage;
  }
}

export interface MethodResultLike {
  success(result: Object | null): void;
  error(errorCode: string, errorMessage: string, errorDetails: Object | null): void;
  notImplemented(): void;
}

function hasListArg(args: Object | null, index: number): boolean {
  if (args == null) {
    return false;
  }
  let list: Object[] = args as Object[];
  if (list.length == null) {
    return false;
  }
  return list.length > index && list[index] != null;
}

export function completeResult(method: string, args: Object | null, hasContext: boolean): MethodOutcome {
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
      // Stubs that are not available on ohos still complete so Dart Futures do not hang.
      return new MethodOutcome(RESULT_SUCCESS, null, '', '');
    default:
      return new MethodOutcome(RESULT_NOT_IMPLEMENTED, null, '', '');
  }
}

export function applyMethodOutcome(result: MethodResultLike, outcome: MethodOutcome): void {
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
  // Never leave MethodResult incomplete — that is the hang bug.
  result.error('INCOMPLETE_RESULT', `MethodResult was not completed (status=${outcome.status})`, null);
}
