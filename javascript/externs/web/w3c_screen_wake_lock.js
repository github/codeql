/*
 * Copyright 2020 The Closure Compiler Authors
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
 * Screen Wake Lock API
 * W3C Editor's Draft 01 September 2020
 * @externs
 * @see https://w3c.github.io/screen-wake-lock/
 */


/** @type {!WakeLock} */
Navigator.prototype.wakeLock;


/**
 * @interface
 * @see https://w3c.github.io/screen-wake-lock/#the-wakelock-interface
 */
function WakeLock() {};

/**
 * @param {string} type
 * @return {!Promise<!WakeLockSentinel>}
 */
WakeLock.prototype.request = function(type) {};


/**
 * @interface
 * @extends {EventTarget}
 * @see https://w3c.github.io/screen-wake-lock/#the-wakelocksentinel-interface
 */
function WakeLockSentinel() {};

/** @type {?function(!Event)} */
WakeLockSentinel.prototype.onrelease;

/** @return {!Promise<void>} */
WakeLockSentinel.prototype.release = function() {};

/** @type {boolean} @const */
WakeLockSentinel.prototype.released;

/** @type {string} @const */
WakeLockSentinel.prototype.type;
