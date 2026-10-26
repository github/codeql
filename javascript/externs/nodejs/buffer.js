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
 * @fileoverview Definitions for module "buffer"
 */

var buffer = {};

/**
 * @type {number}
 */
buffer.INSPECT_MAX_BYTES;

/**
 * @param {string} str
 * @param {string=} encoding
 * @return {Buffer}
 * @constructor
 */
var BuffType = function(str, encoding) {};

/**
 * @param {number} size
 * @return {Buffer}
 * @constructor
 */
var BuffType = function(size) {};

/**
 * @param {Uint8Array} array
 * @return {Buffer}
 * @constructor
 */
var BuffType = function(array) {};

/**
 * @param {ArrayBuffer} arrayBuffer
 * @return {Buffer}
 * @constructor
 */
var BuffType = function(arrayBuffer) {};

/**
 * @param {Array<*>} array
 * @return {Buffer}
 * @constructor
 */
var BuffType = function(array) {};

/**
 * @param {Buffer} buffer
 * @return {Buffer}
 * @constructor
 */
var BuffType = function(buffer) {};

/**
 * @type {Buffer}
 */
BuffType.prototype;

/**
 * @type {(function(Array<*>): Buffer)|(function(ArrayBuffer, number=, number=): Buffer)|(function(Buffer): Buffer)|(function(string, string=): Buffer)}
 */
BuffType.from;

/**
 * @type {(function(*): boolean)}
 */
BuffType.isBuffer;

/**
 * @type {(function(string): boolean)}
 */
BuffType.isEncoding;

/**
 * @type {(function(string, string=): number)}
 */
BuffType.byteLength;

/**
 * @type {(function(Array<Buffer>, number=): Buffer)}
 */
BuffType.concat;

/**
 * @type {(function(Buffer, Buffer): number)}
 */
BuffType.compare;

/**
 * @type {(function(number, (string|Buffer|number)=, string=): Buffer)}
 */
BuffType.alloc;

/**
 * @type {(function(number): Buffer)}
 */
BuffType.allocUnsafe;

/**
 * @type {(function(number): Buffer)}
 */
BuffType.allocUnsafeSlow;


/**
 * @param {string} str
 * @param {string=} encoding
 * @return {Buffer}
 * @constructor
 */
var SlowBuffType = function(str, encoding) {};

/**
 * @param {number} size
 * @return {Buffer}
 * @constructor
 */
var SlowBuffType = function(size) {};

/**
 * @param {Uint8Array} size
 * @return {Buffer}
 * @constructor
 */
var SlowBuffType = function(size) {};

/**
 * @param {Array<*>} array
 * @return {Buffer}
 * @constructor
 */
var SlowBuffType = function(array) {};

/**
 * @type {Buffer}
 */
SlowBuffType.prototype;

/**
 * @type {(function(*): boolean)}
 */
SlowBuffType.isBuffer;

/**
 * @type {(function(string, string=): number)}
 */
SlowBuffType.byteLength;

/**
 * @type {(function(Array<Buffer>, number=): Buffer)}
 */
SlowBuffType.concat;


module.exports.Buffer = BuffType;

module.exports.SlowBuffer = SlowBuffType;

module.exports.INSPECT_MAX_BYTES = buffer.INSPECT_MAX_BYTES;

