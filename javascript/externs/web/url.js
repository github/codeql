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
 * @fileoverview Definitions for URL and URLSearchParams from the spec at
 * https://url.spec.whatwg.org.
 *
 * @externs
 * @author rdcronin@google.com (Devlin Cronin)
 */

/**
 * @typedef {Array<string>}
 */
var URLSearchParamsTupleType;

/**
 * Represents the query string of a URL.
 *
 * * When `init` is a string, it is basically parsed as a query string
 *   `'name1=value1&name2=value2'`.
 *
 * * When `init` is an array of arrays of string
 *   `([['name1', 'value1'], ['name2', 'value2']])`,
 *   it must contain pairs of strings, where the first item in the pair will be
 *   interpreted as a key and the second as a value.
 *
 *   NOTE: The specification uses Iterable rather than Array, but this is not
 *   supported in Edge 17 - 18.
 *
 * * When `init` is an object, keys and values will be interpreted as such
 *   `({name1: 'value1', name2: 'value2'}).
 *
 * @see https://url.spec.whatwg.org/#interface-urlsearchparams
 * @constructor
 * @implements {Iterable<!Array<string>>}
 * @param {(string|!Array<!URLSearchParamsTupleType>|!Object<string,string>)=}
 *     init
 */
function URLSearchParams(init) {}

/**
 * @param {string} name
 * @param {string} value
 * @return {undefined}
 */
URLSearchParams.prototype.append = function(name, value) {};

/**
 * @param {string} name
 * @return {undefined}
 */
URLSearchParams.prototype.delete = function(name) {};

/**
 * @return {!IteratorIterable<!Array<string>>}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/API/URLSearchParams/entries
 */
URLSearchParams.prototype.entries = function() {};

/**
 * @param {function(string, string)} callback
 * @return {undefined}
 */
URLSearchParams.prototype.forEach = function(callback) {};

/**
 * @param {string} name
 * @return {?string}
 */
URLSearchParams.prototype.get = function(name) {};

/**
 * @param {string} name
 * @return {!Array<string>}
 */
URLSearchParams.prototype.getAll = function(name) {};

/**
 * @param {string} name
 * @return {boolean}
 */
URLSearchParams.prototype.has = function(name) {};

/**
 * @return {!IteratorIterable<string>}
 */
URLSearchParams.prototype.keys = function() {};


/**
 * @param {string} name
 * @param {string} value
 * @return {undefined}
 */
URLSearchParams.prototype.set = function(name, value) {};

/**
 * @return {undefined}
 */
URLSearchParams.prototype.sort = function() {};

/**
 * @return {!IteratorIterable<string>}
 */
URLSearchParams.prototype.values = function() {};

/**
 * @see https://url.spec.whatwg.org
 * @constructor
 * @param {string} url
 * @param {(string|!URL)=} base
 */
function URL(url, base) {}

/** @type {string} */
URL.prototype.href;

/**
 * @const {string}
 */
URL.prototype.origin;

/** @type {string} */
URL.prototype.protocol;

/** @type {string} */
URL.prototype.username;

/** @type {string} */
URL.prototype.password;

/** @type {string} */
URL.prototype.host;

/** @type {string} */
URL.prototype.hostname;

/** @type {string} */
URL.prototype.port;

/** @type {string} */
URL.prototype.pathname;

/** @type {string} */
URL.prototype.search;

/**
 * @const {!URLSearchParams}
 */
URL.prototype.searchParams;

/** @type {string} */
URL.prototype.hash;

/**
 * @param {string} domain
 * @return {string}
 */
URL.domainToASCII = function(domain) {};

/**
 * @param {string} domain
 * @return {string}
 */
URL.domainToUnicode = function(domain) {};

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-createObjectURL
 * @param {!File|!Blob|!MediaSource|!MediaStream} obj
 * @return {string}
 */
URL.createObjectURL = function(obj) {};

/**
 * @see http://www.w3.org/TR/FileAPI/#dfn-revokeObjectURL
 * @param {string} url
 * @return {undefined}
 */
URL.revokeObjectURL = function(url) {};
