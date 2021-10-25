/*
 * Copyright 2015 The Closure Compiler Authors
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
 * @fileoverview Definitions for cooperative scheduling of background tasks in
 * the browser. This spec is still very likely to change.
 *
 * @see https://w3c.github.io/requestidlecallback/
 * @see https://developers.google.com/web/updates/2015/08/27/using-requestidlecallback?hl=en
 * @externs
 */


/**
 * @typedef {{
 *   timeout: (number|undefined)
 * }}
 */
var IdleCallbackOptions;


/**
 * Schedules a callback to run when the browser is idle.
 * @param {function(!IdleDeadline)} callback Called when the browser is idle.
 * @param {number|IdleCallbackOptions=} opt_options If set, gives the browser a time in ms by which
 *     it must execute the callback. No timeout enforced otherwise.
 * @return {number} A handle that can be used to cancel the scheduled callback.
 */
function requestIdleCallback(callback, opt_options) {}


/**
 * Cancels a callback scheduled to run when the browser is idle.
 * @param {number} handle The handle returned by {@code requestIdleCallback} for
 *     the scheduled callback to cancel.
 * @return {undefined}
 */
function cancelIdleCallback(handle) {}



/**
 * An interface for an object passed into the callback for
 * {@code requestIdleCallback} that remains up-to-date on the amount of idle
 * time left in the current time slice.
 * @interface
 */
function IdleDeadline() {}


/**
 * @return {number} The amount of idle time (milliseconds) remaining in the
 *     current time slice. Will always be positive or 0.
 */
IdleDeadline.prototype.timeRemaining = function() {};


/**
 * Whether the callback was forced to run due to a timeout. Specifically,
 * whether the callback was invoked by the idle callback timeout algorithm:
 * https://w3c.github.io/requestidlecallback/#dfn-invoke-idle-callback-timeout-algorithm
 * @type {boolean}
 */
IdleDeadline.prototype.didTimeout;
