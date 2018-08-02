/*
 * Copyright 2016 Semmle Ltd.
 */


/**
 * @fileoverview An incomplete model of the Vows library.
 * @externs
 * @see vowsjs.org/#reference
 */

var assert = require('assert');

/**
 * @param {number} eps
 * @param {number} actual
 * @param {number} expected
 * @param {string=} message
 * @return {void}
 */
function epsilon (eps, actual, expected, message) {}
assert.epsilon = epsilon;

/**
 * @param {string} actual
 * @param {RegExp} expected
 * @param {string=} message
 * @return {void}
 */
function match (actual, expected, message) {}
assert.match = match;
assert.matches = match;

/**
 * @param {*} actual
 * @param {string=} message
 * @return {void}
 */
function isTrue (actual, message) {}
assert.isTrue = isTrue;

/**
 * @param {*} actual
 * @param {string=} message
 * @return {void}
 */
function isFalse (actual, message) {}
assert.isFalse = isFalse;

/**
 * @param {*} actual
 * @param {string=} message
 * @return {void}
 */
function isZero (actual, message) {}
assert.isZero = isZero;

/**
 * @param {*} actual
 * @param {string=} message
 * @return {void}
 */
function isNotZero (actual, message) {}
assert.isNotZero = isNotZero;

/**
 * @param {number} actual
 * @param {number} expected
 * @param {string=} message
 * @return {void}
 */
function greater (actual, expected, message) {}
assert.greater = greater;

/**
 * @param {number} actual
 * @param {number} expected
 * @param {string=} message
 * @return {void}
 */
function lesser (actual, expected, message) {}
assert.lesser = lesser;

/**
 * @param {number} actual
 * @param {number} expected
 * @param {number} delta
 * @param {string=} message
 * @return {void}
 */
function inDelta (actual, expected, delta, message) {}
assert.inDelta = inDelta;

/**
 * @param {Array.<*>|Object|string} actual
 * @param {*} expected
 * @param {string=} message
 * @return {void}
 */
function include (actual, expected, message) {}
assert.include = include;
assert.includes = include;

/**
 * @param {Array.<*>|Object|string} actual
 * @param {*} expected
 * @param {string=} message
 * @return {void}
 */
function notInclude (actual, expected, message) {}
assert.notInclude = notInclude;
assert.notIncludes = notInclude;

/**
 * @param {Array.<*>|Object|string} actual
 * @param {*} expected
 * @param {string=} message
 * @return {void}
 */
function deepInclude (actual, expected, message) {}
assert.deepInclude = deepInclude;
assert.deepIncludes = deepInclude;

/**
 * @param {Array.<*>|Object|Function|string} actual
 * @param {string=} message
 * @return {void}
 */
function isEmpty (actual, message) {}
assert.isEmpty = isEmpty;

/**
 * @param {Array.<*>|Object|Function|string} actual
 * @param {string=} message
 * @return {void}
 */
function isNotEmpty (actual, message) {}
assert.isNotEmpty = isNotEmpty;

/**
 * @param {Array.<*>|Object|Function|string} actual
 * @param {number} expected
 * @param {string=} message
 * @return {void}
 */
function lengthOf (actual, expected, message) {}
assert.lengthOf = lengthOf;

/**
 * @param {*} actual
 * @param {string=} message
 * @return {void}
 */
function isArray (actual, message) {}
assert.isArray = isArray;

/**
 * @param {*} actual
 * @param {string=} message
 * @return {void}
 */

function isObject (actual, message) {}
assert.isObject = isObject;

/**
 * @param {*} actual
 * @param {string=} message
 * @return {void}
 */
function isNumber (actual, message) {}
assert.isNumber = isNumber;

/**
 * @param {*} actual
 * @param {string=} message
 * @return {void}
 */
function isBoolean (actual, message) {}
assert.isBoolean = isBoolean;

/**
 * @param {*} actual
 * @param {string=} message
 * @return {void}
 */
function isNaN (actual, message) {}
assert.isNaN = isNaN;

/**
 * @param {*} actual
 * @param {string=} message
 * @return {void}
 */
function isNull (actual, message) {}
assert.isNull = isNull;

/**
 * @param {*} actual
 * @param {string=} message
 * @return {void}
 */
function isNotNull (actual, message) {}
assert.isNotNull = isNotNull;

/**
 * @param {*} actual
 * @param {string=} message
 * @return {void}
 */
function isUndefined (actual, message) {}
assert.isUndefined = isUndefined;

/**
 * @param {*} actual
 * @param {string=} message
 * @return {void}
 */
function isDefined (actual, message) {}
assert.isDefined = isDefined;

/**
 * @param {*} actual
 * @param {string=} message
 * @return {void}
 */
function isString (actual, message) {}
assert.isString = isString;

/**
 * @param {*} actual
 * @param {string=} message
 * @return {void}
 */
function isFunction (actual, message) {}
assert.isFunction = isFunction;

/**
 * @param {*} actual
 * @param {string} expected
 * @param {string=} message
 * @return {void}
 */
function typeOf (actual, expected, message) {}
assert.typeOf = typeOf;

/**
 * @param {*} actual
 * @param {Object} expected
 * @param {string=} message
 * @return {void}
 */
function instanceOf (actual, expected, message) {}
assert.instanceOf = instanceOf;

/**
 * @type {Object}
 */
exports.options;

/**
 * @type {Object}
 */
exports.reporter;

/**
 * @type {Object}
 */
exports.console;

/**
 * @param {*} val
 * @return {string}
 */
exports.inspect = function (val) {};

/**
 * @param {Object} obj
 * @param {Array.<string>} targets
 * @return {Object}
 */
exports.prepare = function (obj, targets) {};

/**
 * @param {Object} batch
 * @return {void}
 */
exports.tryEnd = function (batch) {};

/**
 * @type {Array.<Object>}
 */
exports.suites;

/**
 * @param {Object} subject
 * @param {...*} args
 * @return {Object}
 */
exports.describe = function (subject, args) {};

/**
 * @type {string}
 */
exports.version;
