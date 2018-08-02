/*
 * Copyright 2016 Semmle
 */

/**
 * @fileoverview Definitions approved for inclusion in ECMAScript 2017.
 * @see https://github.com/tc39/proposals/blob/master/finished-proposals.md
 * @externs
 */

/**
 * @param {*} obj
 * @return {!Array}
 * @nosideeffects
 */
Object.values = function(obj) {};

/**
 * @param {*} obj
 * @return {!Array.<Array>}
 * @nosideeffects
 */
Object.entries = function(obj) {};

/**
 * @param {number} maxLength
 * @param {string=} fillString
 * @return {string}
 * @nosideeffects
 */
String.prototype.padStart = function(maxLength, fillString) {};

/**
 * @param {number} maxLength
 * @param {string=} fillString
 * @return {string}
 * @nosideeffects
 */
String.prototype.padEnd = function(maxLength, fillString) {};

/**
 * @param {!Object} obj
 * @return {!Array.<!ObjectPropertyDescriptor>}
 * @nosideeffects
 */
Object.getOwnPropertyDescriptors = function(obj) {};
