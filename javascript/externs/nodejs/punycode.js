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
 * @fileoverview Definitions for module "punycode"
 */

var punycode = {};

/**
 * @param {string} string
 * @return {string}
 */
punycode.decode = function(string) {};

/**
 * @param {string} string
 * @return {string}
 */
punycode.encode = function(string) {};

/**
 * @param {string} domain
 * @return {string}
 */
punycode.toUnicode = function(domain) {};

/**
 * @param {string} domain
 * @return {string}
 */
punycode.toASCII = function(domain) {};

/**
 * @type {punycode.ucs2}
 */
punycode.ucs2;

/**
 * @interface
 */
function ucs2() {}

/**
 * @param {string} string
 * @return {Array<number>}
 */
ucs2.prototype.decode = function(string) {};

/**
 * @param {Array<number>} codePoints
 * @return {string}
 */
ucs2.prototype.encode = function(codePoints) {};

/**
 * @type {*}
 */
punycode.version;

module.exports.decode = punycode.decode;

module.exports.encode = punycode.encode;

module.exports.toUnicode = punycode.toUnicode;

module.exports.toASCII = punycode.toASCII;

module.exports.ucs2 = punycode.ucs2;

module.exports.version = punycode.version;

