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
 * @fileoverview Definitions for timing control for script base animations. The
 *  whole file has been fully type annotated.
 *
 * @see http://www.w3.org/TR/animation-timing/
 * @see http://webstuff.nfshost.com/anim-timing/Overview.html
 * @externs
 */

/**
 * @param {function(number)} callback
 * @param {Element=} opt_element In early versions of this API, the callback
 *     was invoked only if the element was visible.
 * @return {number}
 */
function requestAnimationFrame(callback, opt_element) {};

/**
 * @param {number} handle
 * @return {undefined}
 */
function cancelRequestAnimationFrame(handle) {};

/**
 * @param {number} handle
 * @return {undefined}
 */
function cancelAnimationFrame(handle) {};

/**
 * @param {function(number)} callback
 * @param {Element=} opt_element
 * @return {number}
 */
function webkitRequestAnimationFrame(callback, opt_element) {};

/**
 * @param {number} handle
 * @return {undefined}
 */
function webkitCancelRequestAnimationFrame(handle) {};

/**
 * @param {number} handle
 * @return {undefined}
 */
function webkitCancelAnimationFrame(handle) {};

/**
 * @param {?function(number)} callback It's legitimate to pass a null
 *     callback and listen on the MozBeforePaint event instead.
 * @param {Element=} opt_element
 * @return {number}
 */
function mozRequestAnimationFrame(callback, opt_element) {};

/**
 * @param {number} handle
 * @return {undefined}
 */
function mozCancelRequestAnimationFrame(handle) {};

/**
 * @param {number} handle
 * @return {undefined}
 */
function mozCancelAnimationFrame(handle) {};

/**
 * @param {function(number)} callback
 * @param {Element=} opt_element
 * @return {number}
 */
function msRequestAnimationFrame(callback, opt_element) {};

/**
 * @param {number} handle
 * @return {undefined}
 */
function msCancelRequestAnimationFrame(handle) {};

/**
 * @param {number} handle
 * @return {undefined}
 */
function msCancelAnimationFrame(handle) {};

/**
 * @param {function(number)} callback
 * @param {Element=} opt_element
 * @return {number}
 */
function oRequestAnimationFrame(callback, opt_element) {};

/**
 * @param {number} handle
 * @return {undefined}
 */
function oCancelRequestAnimationFrame(handle) {};

/**
 * @param {number} handle
 * @return {undefined}
 */
function oCancelAnimationFrame(handle) {};
