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
 * @fileoverview Definitions for module "querystring"
 */

var querystring = {};

/**
 * @interface
 */
querystring.StringifyOptions = function() {};

/**
 * @type {Function}
 */
querystring.StringifyOptions.prototype.encodeURIComponent;

/**
 * @interface
 */
querystring.ParseOptions = function() {};

/**
 * @type {number}
 */
querystring.ParseOptions.prototype.maxKeys;

/**
 * @type {Function}
 */
querystring.ParseOptions.prototype.decodeURIComponent;

/**
 * @template T
 * @param {T} obj
 * @param {string=} sep
 * @param {string=} eq
 * @param {querystring.StringifyOptions=} options
 * @return {string}
 */
querystring.stringify = function(obj, sep, eq, options) {};

/**
 * @param {string} str
 * @param {string=} sep
 * @param {string=} eq
 * @param {querystring.ParseOptions=} options
 * @return {*}
 */
querystring.parse = function(str, sep, eq, options) {};

/**
 * @template T
 * @param {string} str
 * @param {string=} sep
 * @param {string=} eq
 * @param {querystring.ParseOptions=} options
 * @return {T}
 */
querystring.parse = function(str, sep, eq, options) {};

/**
 * @param {string} str
 * @return {string}
 */
querystring.escape = function(str) {};

/**
 * @param {string} str
 * @return {string}
 */
querystring.unescape = function(str) {};

module.exports.StringifyOptions = querystring.StringifyOptions;

module.exports.ParseOptions = querystring.ParseOptions;

module.exports.stringify = querystring.stringify;

module.exports.parse = querystring.parse;

module.exports.parse = querystring.parse;

module.exports.escape = querystring.escape;

module.exports.unescape = querystring.unescape;

/**
 * @param {Buffer} s
 * @param {boolean} decodeSpaces
 * @return {void}
 */
querystring.unescapeBuffer = function(s, decodeSpaces) {};

module.exports.unescapeBuffer = querystring.unescapeBuffer;

