/*
 * Copyright 2013 The Closure Compiler Authors.
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
 * @fileoverview Definitions for W3C's Gamepad specification.
 * @see http://www.w3.org/TR/gamepad/
 * @externs
 */

/**
 * @return {!Array.<!Gamepad>}
 */
navigator.getGamepads = function() {};

/**
 * @return {!Array.<!Gamepad>}
 */
navigator.webkitGetGamepads = function() {};


/**
 * @interface
 */
var Gamepad = function() {};

/**
 * @type {string}
 */
Gamepad.prototype.id;  // read-only

/**
 * @type {number}
 */
Gamepad.prototype.index;  // read-only

/**
 * @type {boolean}
 */
Gamepad.prototype.connected;  // read-only

/**
 * @type {number}
 */
Gamepad.prototype.timestamp;  // read-only

/**
 * @type {string}
 */
Gamepad.prototype.mapping;  // read-only

/**
 * @type {!Array.<number>}
 */
Gamepad.prototype.axes;  // read-only

/**
 * Note: The W3C spec changed, this property now returns an array of
 * GamepadButton objects.
 *
 * @type {(!Array.<!GamepadButton>|!Array.<number>)}
 */
Gamepad.prototype.buttons;


/**
 * @interface
 */
var GamepadButton = function() {};

/**
 * @type {boolean}
 */
GamepadButton.prototype.pressed;  // read-only

/**
 * @type {number}
 */
GamepadButton.prototype.value;  // read-only
