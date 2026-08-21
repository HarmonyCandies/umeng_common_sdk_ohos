'use strict';

/**
 * Host unit test: every MethodChannel path must complete MethodResult.
 *
 * Run: node test/host/method_result_completer_test.cjs
 *
 * The ArkTS plugin cannot be constructed here (needs @ohos/flutter_ohos and
 * @umeng/analytics). completeResult + a RecordingMethodResult cover hang vs complete.
 */

const assert = require('node:assert/strict');
const fs = require('node:fs');
const path = require('node:path');

const {
  RESULT_NONE,
  RESULT_SUCCESS,
  RESULT_ERROR,
  RESULT_NOT_IMPLEMENTED,
  KNOWN_METHODS,
  completeResult,
  applyMethodOutcome,
  RecordingMethodResult,
  onMethodCall,
} = require('./method_result_completer.cjs');

const REPO_ROOT = path.resolve(__dirname, '..', '..');
const COMPLETER_ETS = path.join(
  REPO_ROOT,
  'ohos/src/main/ets/components/plugin/method_result_completer.ets',
);
const PLUGIN_ETS = path.join(
  REPO_ROOT,
  'ohos/src/main/ets/components/plugin/UmengCommonSdkOhosPlugin.ets',
);

function record(method, args, hasContext) {
  const result = new RecordingMethodResult();
  onMethodCall(method, args, result, hasContext);
  return result;
}

function extractQuotedCases(source) {
  const names = [];
  const re = /case\s+['"]([^'"]+)['"]/g;
  let match = re.exec(source);
  while (match) {
    names.push(match[1]);
    match = re.exec(source);
  }
  return names;
}

function extractExportedStringArray(source, constName) {
  const block = source.match(new RegExp(`export const ${constName}: string\\[] = \\[([\\s\\S]*?)\\];`));
  assert.ok(block, `expected export const ${constName} in ArkTS helper`);
  return [...block[1].matchAll(/'([^']+)'/g)].map((m) => m[1]);
}

let passed = 0;
function test(name, fn) {
  fn();
  passed += 1;
  console.log(`ok  ${name}`);
}

test('initCommon with context completes success (would hang before the fix)', () => {
  const result = record('initCommon', ['android_key', 'ios_key', 'channel'], true);
  assert.notEqual(result.status, RESULT_NONE, 'initCommon must not leave MethodResult pending');
  assert.equal(result.status, RESULT_SUCCESS);
  assert.equal(result.completions, 1);
});

test('initCommon without context completes error instead of hanging', () => {
  const result = record('initCommon', ['android_key', 'ios_key', 'channel'], false);
  assert.notEqual(result.status, RESULT_NONE);
  assert.equal(result.status, RESULT_ERROR);
  assert.equal(result.errorCode, 'NO_CONTEXT');
});

test('onEvent with event id completes success (would hang before the fix)', () => {
  const result = record('onEvent', ['login', { name: 'jack' }], true);
  assert.notEqual(result.status, RESULT_NONE, 'onEvent must not leave MethodResult pending');
  assert.equal(result.status, RESULT_SUCCESS);
});

test('onEvent without args completes error instead of hanging', () => {
  const result = record('onEvent', null, true);
  assert.notEqual(result.status, RESULT_NONE);
  assert.equal(result.status, RESULT_ERROR);
  assert.equal(result.errorCode, 'INVALID_ARGS');
});

test('unknown method completes notImplemented', () => {
  const result = record('definitelyNotAMethod', null, true);
  assert.notEqual(result.status, RESULT_NONE);
  assert.equal(result.status, RESULT_NOT_IMPLEMENTED);
});

test('every known method maps to success/error/notImplemented, never none', () => {
  const samples = {
    getPlatformVersion: { args: null, hasContext: true, status: RESULT_SUCCESS, value: 'OpenHarmony ^ ^ ' },
    initCommon: { args: ['a', 'i', 'c'], hasContext: true, status: RESULT_SUCCESS },
    onEvent: { args: ['event'], hasContext: true, status: RESULT_SUCCESS },
    onProfileSignIn: { args: ['user-1'], hasContext: true, status: RESULT_SUCCESS },
    onProfileSignOff: { args: null, hasContext: true, status: RESULT_SUCCESS },
    setPageCollectionModeAuto: { args: null, hasContext: true, status: RESULT_SUCCESS },
    setPageCollectionModeManual: { args: null, hasContext: true, status: RESULT_SUCCESS },
    onPageStart: { args: ['home'], hasContext: true, status: RESULT_SUCCESS },
    onPageEnd: { args: ['home'], hasContext: true, status: RESULT_SUCCESS },
    reportError: { args: ['lost space'], hasContext: true, status: RESULT_SUCCESS },
  };

  for (const method of KNOWN_METHODS) {
    const sample = samples[method];
    assert.ok(sample, `missing sample for ${method}`);
    const outcome = completeResult(method, sample.args, sample.hasContext);
    assert.notEqual(outcome.status, RESULT_NONE, `${method} mapped to none (hang)`);
    assert.ok(
      [RESULT_SUCCESS, RESULT_ERROR, RESULT_NOT_IMPLEMENTED].includes(outcome.status),
      `${method} mapped to unexpected status ${outcome.status}`,
    );
    assert.equal(outcome.status, sample.status, `${method} status`);

    const recorder = new RecordingMethodResult();
    applyMethodOutcome(recorder, outcome);
    assert.notEqual(recorder.status, RESULT_NONE, `${method} recorder still none`);
    assert.equal(recorder.status, sample.status);
    assert.equal(recorder.completions, 1);
    if (sample.value !== undefined) {
      assert.equal(recorder.value, sample.value);
    }
  }
});

test('ohos-unavailable stubs still complete success so Dart does not hang', () => {
  for (const method of [
    'setPageCollectionModeAuto',
    'setPageCollectionModeManual',
    'onPageStart',
    'onPageEnd',
    'reportError',
  ]) {
    const result = record(method, null, false);
    assert.equal(result.status, RESULT_SUCCESS, `${method} stub must complete`);
  }
});

test('applyMethodOutcome never leaves status none, even for a broken outcome', () => {
  const recorder = new RecordingMethodResult();
  applyMethodOutcome(recorder, { status: RESULT_NONE, value: null, errorCode: '', errorMessage: '' });
  assert.notEqual(recorder.status, RESULT_NONE);
  assert.equal(recorder.status, RESULT_ERROR);
  assert.equal(recorder.errorCode, 'INCOMPLETE_RESULT');
});

test('ArkTS helper exports the same known methods and never names none as a success path', () => {
  const ets = fs.readFileSync(COMPLETER_ETS, 'utf8');
  const exported = extractExportedStringArray(ets, 'KNOWN_METHODS');
  assert.deepEqual(exported, KNOWN_METHODS);

  const cases = extractQuotedCases(ets);
  for (const method of KNOWN_METHODS) {
    assert.ok(cases.includes(method), `ArkTS completeResult missing case ${method}`);
  }
  assert.match(ets, /RESULT_NOT_IMPLEMENTED/);
  assert.match(ets, /Never leave MethodResult incomplete/);
});

test('plugin onMethodCall always applies completeResult (no silent break paths)', () => {
  const plugin = fs.readFileSync(PLUGIN_ETS, 'utf8');
  const onMethodCall = plugin.match(/onMethodCall\(call: MethodCall, result: MethodResult\): void \{([\s\S]*?)\n  \}/);
  assert.ok(onMethodCall, 'expected onMethodCall in plugin');
  const body = onMethodCall[1];
  assert.match(body, /completeResult\(/);
  assert.match(body, /applyMethodOutcome\(/);
  assert.match(body, /result\.error\('SDK_ERROR'/);
  assert.doesNotMatch(body, /case\s+['"]initCommon['"]/,
    'onMethodCall must complete via completeResult, not a per-method switch that forgets result');
  assert.doesNotMatch(body, /case\s+['"]onEvent['"]/,
    'onMethodCall must complete via completeResult, not a per-method switch that forgets result');
});

console.log(`\n${passed} tests passed`);
