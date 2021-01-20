/*
 * Copyright 2019 The Closure Compiler Authors
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
 * @fileoverview Definitions for console debugging facilities.
 *     https://console.spec.whatwg.org/
 * @externs
 */

/**
 * @constructor
 * @see https://console.spec.whatwg.org/
 */
function Console() {};

/**
 * If condition is false, perform Logger("error", data).
 * @param {*} condition
 * @param {...*} var_data
 * @return {undefined}
 */
Console.prototype.assert = function(condition, var_data) {};

/**
 * @return {undefined}
 */
Console.prototype.clear = function() {};

/**
 * @param {...*} var_data
 * @return {undefined}
 */
Console.prototype.debug = function(var_data) {};

/**
 * @param {...*} var_data
 * @return {undefined}
 */
Console.prototype.error = function(var_data) {};

/**
 * @param {...*} var_data
 * @return {undefined}
 */
Console.prototype.info = function(var_data) {};

/**
 * @param {...*} var_data
 * @return {undefined}
 */
Console.prototype.log = function(var_data) {};

/**
 * @param {!Object} tabularData
 * @param {*=} properties
 * @return {undefined}
 */
Console.prototype.table = function(tabularData, properties) {};

/**
 * @param {...*} var_data
 * @return {undefined}
 */
Console.prototype.trace = function(var_data) {};

/**
 * @param {...*} var_data
 * @return {undefined}
 */
Console.prototype.warn = function(var_data) {};

/**
 * @param {*} item
 * @return {undefined}
 */
Console.prototype.dir = function(item) {};

/**
 * @param {...*} var_data
 * @return {undefined}
 */
Console.prototype.dirxml = function(var_data) {};

/**
 * @param {string=} label
 * @return {undefined}
 */
Console.prototype.count = function(label) {};

/**
 * @param {string=} label
 * @return {undefined}
 */
Console.prototype.countReset = function(label) {};

/**
 * @param {...*} var_data
 * @return {undefined}
 */
Console.prototype.group = function(var_data) {};

/**
 * @param {...*} var_data
 * @return {undefined}
 */
Console.prototype.groupCollapsed = function(var_data) {};

/**
 * @return {undefined}
 */
Console.prototype.groupEnd = function() {};

/**
 * @param {string} label
 * @return {undefined}
 */
Console.prototype.time = function(label) {};

/**
 * @param {string} label
 * @param {...*} data
 * @return {undefined}
 */
Console.prototype.timeLog = function(label, data) {};

/**
 * @param {string} label
 * @return {undefined}
 */
Console.prototype.timeEnd = function(label) {};

/** @type {!Console} */
Window.prototype.console;

/**
 * @type {!Console}
 * @suppress {duplicate}
 */
var console;
