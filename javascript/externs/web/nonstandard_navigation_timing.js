/*
 * Copyright 2011 The Closure Compiler Authors
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
 * @fileoverview Nonstandard Definitions for W3C's Navigation Timing
 * specification.
 *
 * @externs
 */

// Nonstandard. Only available in Blink.
// Returns more granular results with the --enable-memory-info flag.
/** @type {MemoryInfo} */ Performance.prototype.memory;

/**
 * Clear out the buffer of performance timing events for webkit browsers.
 * @return {undefined}
 */
Performance.prototype.webkitClearResourceTimings = function() {};

/**
 * @return {number}
 * @nosideeffects
 */
Performance.prototype.webkitNow = function() {};
