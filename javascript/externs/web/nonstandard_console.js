/*
 * Copyright 2019 The Closure Compiler Authors
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
 * @fileoverview Definitions for console debugging facilities implemented in
 *     various browsers but not part of https://console.spec.whatwg.org/.
 * @externs
 */

/**
 * @constructor
 * @see https://cs.chromium.org/search/?q=%22interface+MemoryInfo%22+file:idl+file:WebKit+package:chromium&type=cs
 */
function MemoryInfo() {};

/** @type {number} */
MemoryInfo.prototype.totalJSHeapSize;

/** @type {number} */
MemoryInfo.prototype.usedJSHeapSize;

/** @type {number} */
MemoryInfo.prototype.jsHeapSizeLimit;

/**
 * @param {*} value
 * @return {undefined}
 */
Console.prototype.markTimeline = function(value) {};

/**
 * @param {string=} title
 * @return {undefined}
 */
Console.prototype.profile = function(title) {};

/** @type {Array<ScriptProfile>} */
Console.prototype.profiles;

/**
 * @param {string=} title
 * @return {undefined}
 */
Console.prototype.profileEnd = function(title) {};

/**
 * @param {*} value
 * @return {undefined}
 */
Console.prototype.timeStamp = function(value) {};

/** @type {MemoryInfo} */
Console.prototype.memory;
