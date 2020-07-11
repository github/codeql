
/*
 * Copyright 2018 Semmle
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @fileoverview Simple externs definitions for Jest APIs.
 *
 * The goal is to declare global functions provided by the framework Jest
 *
 * @externs
 */

function after(callback, timeout) { if(callback) callback(); }

function afterAll(callback, timeout) { if(callback) callback(); }

function afterEach(callback, timeout) { if(callback) callback(); }

function before(callback, timeout) { if(callback) callback(); }

function beforeAll(callback, timeout) { if(callback) callback(); }

function beforeEach(callback, timeout) { if(callback) callback(); }

function describe(name, callback) { if(callback) callback(); }
describe.each = function(name, callback, timeout) { if(callback) callback(); }
describe.only = function (name, callback) { if(callback) callback(); }
describe.only.each = function (name, callback) { if(callback) callback(); }
describe.skip = function (name, callback) { if(callback) callback(); } 
describe.skip.each = function (name, callback) { if(callback) callback(); }

function test(name, callback, timeout) { if(callback) callback(); }
test.each = function (name, callback, timeout) { if(callback) callback(); }
test.only = function (name, callback, timeout) { if(callback) callback(); }
test.only.each = function (name, callback) { if(callback) callback(); }
test.skip = function (name, callback) { if(callback) callback(); }
test.skip.each = function (name, callback) { if(callback) callback(); }
test.todo = function (name) { }

function it(name, callback, timeout) { if(callback) callback(); }
it.each = function (name, callback, timeout) { if(callback) callback(); }
it.only = function (name, callback, timeout) { if(callback) callback(); }
it.only.each = function (name, callback) { if(callback) callback(); }
it.skip = function (name, callback) { if(callback) callback(); }
it.skip.each = function (name, callback) { if(callback) callback(); }
it.todo = function (name) { }

function expect(value) { };
expect.prototype = {
  extend: function (matchers) { },
  anything: function() { },
  any: function(constructor) { },
  arrayContaining: function(array) { },
  assertions: function(number) { },
  hasAssertions: function() { },
  arrayContaining: function(array) { },
  objectContaining: function(object) { },
  stringContaining: function(string) { },
  stringMatching: function (string) { },
  objectContaining: function (object) { },
  stringContaining: function (string) { },
  stringMatching: function (string) { },
  addSnapshotSerializer: function (serializer) { },
  get not() { },
  get resolves() { },
  get rejects() { },
  toBe: function (value) { },
  toHaveBeenCalled: function () { },
  toHaveBeenCalledTimes: function (number) { },
  toHaveBeenCalledWith: function (arg1, arg2) { },
  toHaveBeenLastCalledWith: function (arg1, arg2) { },
  toHaveBeenNthCalledWith: function (nthCall, arg1, arg2) { },
  toHaveReturned: function () { },
  toHaveReturnedTimes: function (number) { },
  toHaveReturnedWith: function (value) { },
  toHaveLastReturnedWith: function (value) { },
  toHaveNthReturnedWith: function (nthCall, value) { },
  toHaveLength: function (number) { },
  toHaveProperty: function (keyPath, value) { },
  toBeCloseTo: function (number, numDigits) { },
  toBeDefined: function () { },
  toBeFalsy: function () { },
  toBeGreaterThan: function (number) { },
  toBeGreaterThanOrEqual: function (number) { },
  toBeLessThan: function (number) { },
  toBeLessThanOrEqual: function (number) { },
  toBeInstanceOf: function (Class)  { },
  toBeNull: function () { },
  toBeTruthy: function () { },
  toBeUndefined: function () { },
  toBeNaN: function () { },
  toContain: function (item) { },
  toContainEqual: function (item) { },
  toEqual: function (value) { },
  toMatch: function (regexpOrString) { },
  toMatchObject: function (object) { },
  toMatchSnapshot: function (propertyMatchers, hint) { },
  toMatchInlineSnapshot: function (propertyMatchers, inlineSnapshot) { },
  toStrictEqual: function (value) { },
  toThrow: function (error) { },
  toThrowErrorMatchingSnapshot: function (hint) { },
  toThrowErrorMatchingInlineSnapshot: function (inlineSnapshot) { },
}

Object.defineProperty(Object.prototype, 'expect', {
  get: function() { return expect(this.valueOf() || this); },
  enumerable: false,
  configurable: true
});

function mockFn() { }
mockFn.prototype = {
  getMockName: function () { },
  get mock() { },
  get calls() { },
  get results() { },
  get instances() { },
  mockClear: function () { },
  mockReset: function () { },
  mockRestore: function () { },
  mockImplementation: function (callback) { if(callback) callback(); },
  mockImplementationOnce: function (callback) { if(callback) callback(); },
  mockName: function (value) { },
  mockReturnThis: function () { },
  mockReturnValue: function (value) { },
  mockReturnValueOnce: function (value) { },
  mockResolvedValue: function (value) { },
  mockResolvedValueOnce: function (value) { },
  mockRejectedValue: function (value) { },
  mockRejectedValueOnce: function (value) { }
}

Object.defineProperty(Object.prototype, 'mockFn', {
  get: function() { return mockFn(this.valueOf() || this); },
  enumerable: false,
  configurable: true
});

function jest() { }
jest.prototype = {
  disableAutomock: function() { },
  enableAutomock: function() { },
  createMockFromModule: function(moduleName) { },
  mock: function(moduleName, factory, options) { },
  unmock: function(moduleName) { },
  doMock: function(moduleName, factory, options) { },
  dontMock: function(moduleName) { },
  setMock: function(moduleName, moduleExports) { },
  requireActual: function(moduleName) { },
  requireMock: function(moduleName) { },
  resetModules: function() { },
  isolateModules: function(fn) { },

  fn: function (implementation) { implementation(); },
  isMockFunction: function (fn) { },
  spyOn: function (object, methodName) { },
  spyOn: function (object, methodName, accessType) { },
  clearAllMocks: function () { },
  resetAllMocks: function () { },
  restoreAllMocks: function () { },

  useFakeTimers: function (implementation) { implementation(); },
  useRealTimers: function () { },
  runAllTicks: function () { },
  runAllTimers: function () { },
  runAllImmediates: function () { },
  advanceTimersByTime: function (msToRun) { },
  runOnlyPendingTimers: function () { },
  advanceTimersToNextTimer: function (steps) { },
  clearAllTimers: function () { },
  getTimerCount: function () { },
  setSystemTime: function (now) { },
  getRealSystemTime: function () { },

  setTimeout: function (timeout) { },
  retryTimes: function () { }

}

Object.defineProperty(Object.prototype, 'jest', {
  get: function() { return jest(this.valueOf() || this); },
  enumerable: false,
  configurable: true
});
