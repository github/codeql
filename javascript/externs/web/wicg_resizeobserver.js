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
 * @fileoverview The current draft spec of ResizeObserver.
 * @see https://wicg.github.io/ResizeObserver/
 * @see https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver
 * @externs
 */

/**
 * @typedef {function(!Array<!ResizeObserverEntry>, !ResizeObserver)}
 */
var ResizeObserverCallback;

/**
 * @typedef {{box: string}}
 */
var ResizeObserverOptions;

/**
 * @constructor
 * @param {!ResizeObserverCallback} callback
 * @see https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver/ResizeObserver
 */
function ResizeObserver(callback) {}

/**
 * @param {!Element} target
 * @param {!ResizeObserverOptions=} opt_options
 * @return {void}
 * @see https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver/observe
 */
ResizeObserver.prototype.observe = function(target, opt_options) {};

/**
 * @param {!Element} target
 * @return {void}
 * @see https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver/unobserve
 */
ResizeObserver.prototype.unobserve = function(target) {};

/**
 * @return {void}
 * @see https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserver/disconnect
 */
ResizeObserver.prototype.disconnect = function() {};

/**
 * @interface
 * @see https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserverEntry
 */
function ResizeObserverEntry() {}

/**
 * @const {!Element}
 * @see https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserverEntry/target
 */
ResizeObserverEntry.prototype.target;

/**
 * @const {!DOMRectReadOnly}
 * @see https://developer.mozilla.org/en-US/docs/Web/API/ResizeObserverEntry/contentRect
 */
ResizeObserverEntry.prototype.contentRect;
