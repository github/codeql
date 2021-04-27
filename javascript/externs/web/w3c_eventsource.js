/*
 * Copyright 2012 The Closure Compiler Authors
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
 * @fileoverview Definitions for W3C's EventSource API.
 * @see https://html.spec.whatwg.org/multipage/server-sent-events.html#server-sent-events
 *
 * @externs
 */

/** @record */
function EventSourceInit() {};

/** @type {(boolean|undefined)} */
EventSourceInit.prototype.withCredentials;

/**
 * @constructor
 * @implements {EventTarget}
 * @param {string} url
 * @param {EventSourceInit=} opt_eventSourceInitDict
 */
function EventSource(url, opt_eventSourceInitDict) {}

/** @override */
EventSource.prototype.addEventListener = function(type, listener, opt_options) {
};

/** @override */
EventSource.prototype.removeEventListener = function(
    type, listener, opt_options) {};

/** @override */
EventSource.prototype.dispatchEvent = function(evt) {};

/**
 * @const {string}
 */
EventSource.prototype.url;

/** @const {boolean} */
EventSource.prototype.withCredentials;

/**
 * @const {number}
 */
EventSource.prototype.CONNECTING;

/**
 * @const {number}
 */
EventSource.CONNECTING;

/**
 * @const {number}
 */
EventSource.prototype.OPEN;

/**
 * @const {number}
 */
EventSource.OPEN;

/**
 * @const {number}
 */
EventSource.prototype.CLOSED;

/**
 * @const {number}
 */
EventSource.CLOSED;

/**
 * @const {number}
 */
EventSource.prototype.readyState;

/**
 * @type {?function(!Event): void}
 */
EventSource.prototype.onopen = function(e) {};

/**
 * @type {?function(!MessageEvent<string>): void}
 */
EventSource.prototype.onmessage = function(e) {};

/**
 * @type {?function(!Event): void}
 */
EventSource.prototype.onerror = function(e) {};

/**
 * @return {undefined}
 */
EventSource.prototype.close = function() {};
