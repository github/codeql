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
 * @fileoverview Definitions for module "url"
 */

var url = {};

/**
 * @interface
 */
url.Url = function() {};

/**
 * @type {string}
 */
url.Url.prototype.href;

/**
 * @type {string}
 */
url.Url.prototype.protocol;

/**
 * @type {string}
 */
url.Url.prototype.auth;

/**
 * @type {string}
 */
url.Url.prototype.hostname;

/**
 * @type {string}
 */
url.Url.prototype.port;

/**
 * @type {string}
 */
url.Url.prototype.host;

/**
 * @type {string}
 */
url.Url.prototype.pathname;

/**
 * @type {string}
 */
url.Url.prototype.search;

/**
 * @type {*}
 */
url.Url.prototype.query;

/**
 * @type {boolean}
 */
url.Url.prototype.slashes;

/**
 * @type {string}
 */
url.Url.prototype.hash;

/**
 * @type {string}
 */
url.Url.prototype.path;

/**
 * @param {string} urlStr
 * @param {boolean=} parseQueryString
 * @param {boolean=} slashesDenoteHost
 * @return {url.Url}
 */
url.parse = function(urlStr, parseQueryString, slashesDenoteHost) {};

/**
 * @param {url.Url} url
 * @return {string}
 */
url.format = function(url) {};

/**
 * @param {string} from
 * @param {string} to
 * @return {string}
 */
url.resolve = function(from, to) {};

module.exports.Url = url.Url;

module.exports.parse = url.parse;

module.exports.format = url.format;

module.exports.resolve = url.resolve;

