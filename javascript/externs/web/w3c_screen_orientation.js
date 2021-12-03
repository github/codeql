/*
 * Copyright 2016 The Closure Compiler Authors
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
 * @fileoverview Definitions for W3C's Screen Orientation API.
 * @see https://w3c.github.io/screen-orientation/
 *
 * @externs
 */

/**
 * @interface
 * @extends {EventTarget}
 * @see https://w3c.github.io/screen-orientation/#screenorientation-interface
 */
var ScreenOrientation = function() {};

/**
 * @param {string} orientation
 * @return {!Promise<void>}
 */
ScreenOrientation.prototype.lock = function(orientation) {};

/** @return {void} */
ScreenOrientation.prototype.unlock = function() {};

/** @const {string} */
ScreenOrientation.prototype.type;

/** @const {number} */
ScreenOrientation.prototype.angle;

/** @type {?function(!Event)} */
ScreenOrientation.prototype.onchange;

/**
 * @type {?ScreenOrientation}
 * @see https://w3c.github.io/screen-orientation/#extensions-to-the-screen-interface
 */
Screen.prototype.orientation;
