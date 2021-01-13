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
 * @fileoverview Definitions for the W3C Keyboard Lock API.
 * @see https://wicg.github.io/keyboard-lock/
 * @externs
 */

/**
 * Keyboard API object.
 * @constructor
 * @see https://w3c.github.io/keyboard-lock/#keyboard-interface
 */
function Keyboard() {}

/**
 * Lock the specified keys for this page, or all keys if keyCodes is omitted.
 * @param {?Array<string>=} keyCodes
 * @return {!Promise<undefined>}
 */
Keyboard.prototype.lock = function(keyCodes) {};

/**
 * Unlock any locked keys.
 */
Keyboard.prototype.unlock = function() {};


/**
 * @type {!Keyboard}
 * @see https://w3c.github.io/keyboard-lock/#API
 */
Navigator.prototype.keyboard;
