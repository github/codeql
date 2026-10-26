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
 * @fileoverview Definitions for module "util"
 */

var util = {};

/**
 * @interface
 */
util.InspectOptions = function() {};

/**
 * @type {boolean}
 */
util.InspectOptions.prototype.showHidden;

/**
 * @type {number}
 */
util.InspectOptions.prototype.depth;

/**
 * @type {boolean}
 */
util.InspectOptions.prototype.colors;

/**
 * @type {boolean}
 */
util.InspectOptions.prototype.customInspect;

/**
 * @param {*} format
 * @param {...*} param
 * @return {string}
 */
util.format = function(format, param) {};

/**
 * @param {string} string
 * @return {void}
 */
util.debug = function(string) {};

/**
 * @param {...*} param
 * @return {void}
 */
util.error = function(param) {};

/**
 * @param {...*} param
 * @return {void}
 */
util.puts = function(param) {};

/**
 * @param {...*} param
 * @return {void}
 */
util.print = function(param) {};

/**
 * @param {string} string
 * @return {void}
 */
util.log = function(string) {};

/**
 * @param {*} object
 * @param {boolean=} showHidden
 * @param {number=} depth
 * @param {boolean=} color
 * @return {string}
 */
util.inspect = function(object, showHidden, depth, color) {};

/**
 * @param {*} object
 * @param {util.InspectOptions} options
 * @return {string}
 */
util.inspect = function(object, options) {};

/**
 * @param {*} object
 * @return {boolean}
 */
util.isArray = function(object) {};

/**
 * @param {*} object
 * @return {boolean}
 */
util.isRegExp = function(object) {};

/**
 * @param {*} object
 * @return {boolean}
 */
util.isDate = function(object) {};

/**
 * @param {*} object
 * @return {boolean}
 */
util.isError = function(object) {};

/**
 * @param {*} constructor
 * @param {*} superConstructor
 * @return {void}
 */
util.inherits = function(constructor, superConstructor) {};

/**
 * @param {string} key
 * @return {(function(string, ...*): void)}
 */
util.debuglog = function(key) {};

/**
 * @param {*} object
 * @return {boolean}
 */
util.isBoolean = function(object) {};

/**
 * @param {*} object
 * @return {boolean}
 */
util.isBuffer = function(object) {};

/**
 * @param {*} object
 * @return {boolean}
 */
util.isFunction = function(object) {};

/**
 * @param {*} object
 * @return {boolean}
 */
util.isNull = function(object) {};

/**
 * @param {*} object
 * @return {boolean}
 */
util.isNullOrUndefined = function(object) {};

/**
 * @param {*} object
 * @return {boolean}
 */
util.isNumber = function(object) {};

/**
 * @param {*} object
 * @return {boolean}
 */
util.isObject = function(object) {};

/**
 * @param {*} object
 * @return {boolean}
 */
util.isPrimitive = function(object) {};

/**
 * @param {*} object
 * @return {boolean}
 */
util.isString = function(object) {};

/**
 * @param {*} object
 * @return {boolean}
 */
util.isSymbol = function(object) {};

/**
 * @param {*} object
 * @return {boolean}
 */
util.isUndefined = function(object) {};

/**
 * @param {Function} fn
 * @param {string} message
 * @return {Function}
 */
util.deprecate = function(fn, message) {};

module.exports.InspectOptions = util.InspectOptions;

module.exports.format = util.format;

module.exports.debug = util.debug;

module.exports.error = util.error;

module.exports.puts = util.puts;

module.exports.print = util.print;

module.exports.log = util.log;

module.exports.inspect = util.inspect;

module.exports.inspect = util.inspect;

module.exports.isArray = util.isArray;

module.exports.isRegExp = util.isRegExp;

module.exports.isDate = util.isDate;

module.exports.isError = util.isError;

module.exports.inherits = util.inherits;

module.exports.debuglog = util.debuglog;

module.exports.isBoolean = util.isBoolean;

module.exports.isBuffer = util.isBuffer;

module.exports.isFunction = util.isFunction;

module.exports.isNull = util.isNull;

module.exports.isNullOrUndefined = util.isNullOrUndefined;

module.exports.isNumber = util.isNumber;

module.exports.isObject = util.isObject;

module.exports.isPrimitive = util.isPrimitive;

module.exports.isString = util.isString;

module.exports.isSymbol = util.isSymbol;

module.exports.isUndefined = util.isUndefined;

module.exports.deprecate = util.deprecate;

/**
 * @param {Object} destination
 * @param {Object} source
 * @return {Object}
 */
util._extend = function(destination, source) {};

module.exports._extend = util._extend;

