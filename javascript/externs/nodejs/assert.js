// Automatically generated from TypeScript type definitions provided by
// DefinitelyTyped (https://github.com/DefinitelyTyped/DefinitelyTyped),
// which is licensed under the MIT license; see file DefinitelyTyped-LICENSE
// in parent directory.
// Type definitions for Node.js 10.5.x
// Project: http://nodejs.org/
// Definitions by: Microsoft TypeScript <http://typescriptlang.org>
//                 DefinitelyTyped <https://github.com/DefinitelyTyped/DefinitelyTyped>
//                 Parambir Singh <https://github.com/parambirs>
//                 Christian Vaagland Tellnes <https://github.com/tellnes>
//                 Wilco Bakker <https://github.com/WilcoBakker>
//                 Nicolas Voigt <https://github.com/octo-sniffle>
//                 Chigozirim C. <https://github.com/smac89>
//                 Flarna <https://github.com/Flarna>
//                 Mariusz Wiktorczyk <https://github.com/mwiktorczyk>
//                 wwwy3y3 <https://github.com/wwwy3y3>
//                 Deividas Bakanas <https://github.com/DeividasBakanas>
//                 Kelvin Jin <https://github.com/kjin>
//                 Alvis HT Tang <https://github.com/alvis>
//                 Sebastian Silbermann <https://github.com/eps1lon>
//                 Hannes Magnusson <https://github.com/Hannes-Magnusson-CK>
//                 Alberto Schiabel <https://github.com/jkomyno>
//                 Klaus Meinhardt <https://github.com/ajafff>
//                 Huw <https://github.com/hoo29>
//                 Nicolas Even <https://github.com/n-e>
//                 Bruno Scheufler <https://github.com/brunoscheufler>
//                 Mohsen Azimi <https://github.com/mohsen1>
//                 Hoàng Văn Khải <https://github.com/KSXGitHub>
//                 Alexander T. <https://github.com/a-tarasyuk>
//                 Lishude <https://github.com/islishude>
//                 Andrew Makarov <https://github.com/r3nya>
//                 Zane Hannan AU <https://github.com/ZaneHannanAU>
// Definitions: https://github.com/DefinitelyTyped/DefinitelyTyped

/**
 * @externs
 * @fileoverview Definitions for module "assert"
 */

/**
 * @param {*} value
 * @param {string=} message
 * @return {void}
 */
var internal = function(value, message) {};

var internal = internal || {};

/**
 * @param {{message: string, actual: *, expected: *, operator: string, stackStartFunction: Function}=} options
 * @return {internal.AssertionError}
 * @constructor
 */
internal.AssertionError = function(options) {};

/**
 * @type {string}
 */
internal.AssertionError.prototype.name;

/**
 * @type {string}
 */
internal.AssertionError.prototype.message;

/**
 * @type {*}
 */
internal.AssertionError.prototype.actual;

/**
 * @type {*}
 */
internal.AssertionError.prototype.expected;

/**
 * @type {string}
 */
internal.AssertionError.prototype.operator;

/**
 * @type {boolean}
 */
internal.AssertionError.prototype.generatedMessage;

/**
 * @param {*} actual
 * @param {*} expected
 * @param {string} message
 * @param {string} operator
 * @return {void}
 */
internal.fail = function(actual, expected, message, operator) {};

/**
 * @param {*} value
 * @param {string=} message
 * @return {void}
 */
internal.ok = function(value, message) {};

/**
 * @param {*} actual
 * @param {*} expected
 * @param {string=} message
 * @return {void}
 */
internal.equal = function(actual, expected, message) {};

/**
 * @param {*} actual
 * @param {*} expected
 * @param {string=} message
 * @return {void}
 */
internal.notEqual = function(actual, expected, message) {};

/**
 * @param {*} actual
 * @param {*} expected
 * @param {string=} message
 * @return {void}
 */
internal.deepEqual = function(actual, expected, message) {};

/**
 * @param {*} acutal
 * @param {*} expected
 * @param {string=} message
 * @return {void}
 */
internal.notDeepEqual = function(acutal, expected, message) {};

/**
 * @param {*} actual
 * @param {*} expected
 * @param {string=} message
 * @return {void}
 */
internal.strictEqual = function(actual, expected, message) {};

/**
 * @param {*} actual
 * @param {*} expected
 * @param {string=} message
 * @return {void}
 */
internal.notStrictEqual = function(actual, expected, message) {};

/**
 * @param {*} actual
 * @param {*} expected
 * @param {string=} message
 * @return {void}
 */
internal.deepStrictEqual = function(actual, expected, message) {};

/**
 * @param {*} actual
 * @param {*} expected
 * @param {string=} message
 * @return {void}
 */
internal.notDeepStrictEqual = function(actual, expected, message) {};

/**
 * @type {(function(Function, string=): void)|(function(Function, Function, string=): void)|(function(Function, RegExp, string=): void)|(function(Function, (function(*): boolean), string=): void)}
 */
internal.throws;

/**
 * @type {(function(Function, string=): void)|(function(Function, Function, string=): void)|(function(Function, RegExp, string=): void)|(function(Function, (function(*): boolean), string=): void)}
 */
internal.doesNotThrow;

/**
 * @param {*} value
 * @return {void}
 */
internal.ifError = function(value) {};


module.exports = internal;

