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
 * @fileoverview Definitions for module "string_decoder"
 */

var string_decoder = {};

/**
 * @interface
 */
string_decoder.NodeStringDecoder = function() {};

/**
 * @param {Buffer} buffer
 * @return {string}
 */
string_decoder.NodeStringDecoder.prototype.write = function(buffer) {};

/**
 * @param {Buffer=} buffer
 * @return {string}
 */
string_decoder.NodeStringDecoder.prototype.end = function(buffer) {};

/**
 * @type {(function(new: string_decoder.NodeStringDecoder, string=))}
 */
string_decoder.StringDecoder;

module.exports.NodeStringDecoder = string_decoder.NodeStringDecoder;

module.exports.StringDecoder = string_decoder.StringDecoder;

/**
 * @interface
 */
string_decoder.NodeStringDecoder = function() {};

/**
 * @param {Buffer} buffer
 * @return {number}
 */
string_decoder.NodeStringDecoder.prototype.detectIncompleteChar = function(buffer) {};

module.exports.NodeStringDecoder = string_decoder.NodeStringDecoder;

