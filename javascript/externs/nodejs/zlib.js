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
 * @fileoverview Definitions for module "zlib"
 */

var zlib = {};

/**
 * @interface
 */
zlib.ZlibOptions = function() {};

/**
 * @type {number}
 */
zlib.ZlibOptions.prototype.chunkSize;

/**
 * @type {number}
 */
zlib.ZlibOptions.prototype.windowBits;

/**
 * @type {number}
 */
zlib.ZlibOptions.prototype.level;

/**
 * @type {number}
 */
zlib.ZlibOptions.prototype.memLevel;

/**
 * @type {number}
 */
zlib.ZlibOptions.prototype.strategy;

/**
 * @type {*}
 */
zlib.ZlibOptions.prototype.dictionary;

/**
 * @interface
 * @extends {internal.Transform}
 */
zlib.Gzip = function() {};

/**
 * @interface
 * @extends {internal.Transform}
 */
zlib.Gunzip = function() {};

/**
 * @interface
 * @extends {internal.Transform}
 */
zlib.Deflate = function() {};

/**
 * @interface
 * @extends {internal.Transform}
 */
zlib.Inflate = function() {};

/**
 * @interface
 * @extends {internal.Transform}
 */
zlib.DeflateRaw = function() {};

/**
 * @interface
 * @extends {internal.Transform}
 */
zlib.InflateRaw = function() {};

/**
 * @interface
 * @extends {internal.Transform}
 */
zlib.Unzip = function() {};

/**
 * @param {zlib.ZlibOptions=} options
 * @return {zlib.Gzip}
 */
zlib.createGzip = function(options) {};

/**
 * @param {zlib.ZlibOptions=} options
 * @return {zlib.Gunzip}
 */
zlib.createGunzip = function(options) {};

/**
 * @param {zlib.ZlibOptions=} options
 * @return {zlib.Deflate}
 */
zlib.createDeflate = function(options) {};

/**
 * @param {zlib.ZlibOptions=} options
 * @return {zlib.Inflate}
 */
zlib.createInflate = function(options) {};

/**
 * @param {zlib.ZlibOptions=} options
 * @return {zlib.DeflateRaw}
 */
zlib.createDeflateRaw = function(options) {};

/**
 * @param {zlib.ZlibOptions=} options
 * @return {zlib.InflateRaw}
 */
zlib.createInflateRaw = function(options) {};

/**
 * @param {zlib.ZlibOptions=} options
 * @return {zlib.Unzip}
 */
zlib.createUnzip = function(options) {};

/**
 * @param {Buffer} buf
 * @param {(function(Error, *): void)} callback
 * @return {void}
 */
zlib.deflate = function(buf, callback) {};

/**
 * @param {Buffer} buf
 * @param {zlib.ZlibOptions=} options
 * @return {*}
 */
zlib.deflateSync = function(buf, options) {};

/**
 * @param {Buffer} buf
 * @param {(function(Error, *): void)} callback
 * @return {void}
 */
zlib.deflateRaw = function(buf, callback) {};

/**
 * @param {Buffer} buf
 * @param {zlib.ZlibOptions=} options
 * @return {*}
 */
zlib.deflateRawSync = function(buf, options) {};

/**
 * @param {Buffer} buf
 * @param {(function(Error, *): void)} callback
 * @return {void}
 */
zlib.gzip = function(buf, callback) {};

/**
 * @param {Buffer} buf
 * @param {zlib.ZlibOptions=} options
 * @return {*}
 */
zlib.gzipSync = function(buf, options) {};

/**
 * @param {Buffer} buf
 * @param {(function(Error, *): void)} callback
 * @return {void}
 */
zlib.gunzip = function(buf, callback) {};

/**
 * @param {Buffer} buf
 * @param {zlib.ZlibOptions=} options
 * @return {*}
 */
zlib.gunzipSync = function(buf, options) {};

/**
 * @param {Buffer} buf
 * @param {(function(Error, *): void)} callback
 * @return {void}
 */
zlib.inflate = function(buf, callback) {};

/**
 * @param {Buffer} buf
 * @param {zlib.ZlibOptions=} options
 * @return {*}
 */
zlib.inflateSync = function(buf, options) {};

/**
 * @param {Buffer} buf
 * @param {(function(Error, *): void)} callback
 * @return {void}
 */
zlib.inflateRaw = function(buf, callback) {};

/**
 * @param {Buffer} buf
 * @param {zlib.ZlibOptions=} options
 * @return {*}
 */
zlib.inflateRawSync = function(buf, options) {};

/**
 * @param {Buffer} buf
 * @param {(function(Error, *): void)} callback
 * @return {void}
 */
zlib.unzip = function(buf, callback) {};

/**
 * @param {Buffer} buf
 * @param {zlib.ZlibOptions=} options
 * @return {*}
 */
zlib.unzipSync = function(buf, options) {};

/**
 * @type {number}
 */
zlib.Z_NO_FLUSH;

/**
 * @type {number}
 */
zlib.Z_PARTIAL_FLUSH;

/**
 * @type {number}
 */
zlib.Z_SYNC_FLUSH;

/**
 * @type {number}
 */
zlib.Z_FULL_FLUSH;

/**
 * @type {number}
 */
zlib.Z_FINISH;

/**
 * @type {number}
 */
zlib.Z_BLOCK;

/**
 * @type {number}
 */
zlib.Z_TREES;

/**
 * @type {number}
 */
zlib.Z_OK;

/**
 * @type {number}
 */
zlib.Z_STREAM_END;

/**
 * @type {number}
 */
zlib.Z_NEED_DICT;

/**
 * @type {number}
 */
zlib.Z_ERRNO;

/**
 * @type {number}
 */
zlib.Z_STREAM_ERROR;

/**
 * @type {number}
 */
zlib.Z_DATA_ERROR;

/**
 * @type {number}
 */
zlib.Z_MEM_ERROR;

/**
 * @type {number}
 */
zlib.Z_BUF_ERROR;

/**
 * @type {number}
 */
zlib.Z_VERSION_ERROR;

/**
 * @type {number}
 */
zlib.Z_NO_COMPRESSION;

/**
 * @type {number}
 */
zlib.Z_BEST_SPEED;

/**
 * @type {number}
 */
zlib.Z_BEST_COMPRESSION;

/**
 * @type {number}
 */
zlib.Z_DEFAULT_COMPRESSION;

/**
 * @type {number}
 */
zlib.Z_FILTERED;

/**
 * @type {number}
 */
zlib.Z_HUFFMAN_ONLY;

/**
 * @type {number}
 */
zlib.Z_RLE;

/**
 * @type {number}
 */
zlib.Z_FIXED;

/**
 * @type {number}
 */
zlib.Z_DEFAULT_STRATEGY;

/**
 * @type {number}
 */
zlib.Z_BINARY;

/**
 * @type {number}
 */
zlib.Z_TEXT;

/**
 * @type {number}
 */
zlib.Z_ASCII;

/**
 * @type {number}
 */
zlib.Z_UNKNOWN;

/**
 * @type {number}
 */
zlib.Z_DEFLATED;

/**
 * @type {number}
 */
zlib.Z_NULL;

module.exports.ZlibOptions = zlib.ZlibOptions;

module.exports.Gzip = zlib.Gzip;

module.exports.Gunzip = zlib.Gunzip;

module.exports.Deflate = zlib.Deflate;

module.exports.Inflate = zlib.Inflate;

module.exports.DeflateRaw = zlib.DeflateRaw;

module.exports.InflateRaw = zlib.InflateRaw;

module.exports.Unzip = zlib.Unzip;

module.exports.createGzip = zlib.createGzip;

module.exports.createGunzip = zlib.createGunzip;

module.exports.createDeflate = zlib.createDeflate;

module.exports.createInflate = zlib.createInflate;

module.exports.createDeflateRaw = zlib.createDeflateRaw;

module.exports.createInflateRaw = zlib.createInflateRaw;

module.exports.createUnzip = zlib.createUnzip;

module.exports.deflate = zlib.deflate;

module.exports.deflateSync = zlib.deflateSync;

module.exports.deflateRaw = zlib.deflateRaw;

module.exports.deflateRawSync = zlib.deflateRawSync;

module.exports.gzip = zlib.gzip;

module.exports.gzipSync = zlib.gzipSync;

module.exports.gunzip = zlib.gunzip;

module.exports.gunzipSync = zlib.gunzipSync;

module.exports.inflate = zlib.inflate;

module.exports.inflateSync = zlib.inflateSync;

module.exports.inflateRaw = zlib.inflateRaw;

module.exports.inflateRawSync = zlib.inflateRawSync;

module.exports.unzip = zlib.unzip;

module.exports.unzipSync = zlib.unzipSync;

module.exports.Z_NO_FLUSH = zlib.Z_NO_FLUSH;

module.exports.Z_PARTIAL_FLUSH = zlib.Z_PARTIAL_FLUSH;

module.exports.Z_SYNC_FLUSH = zlib.Z_SYNC_FLUSH;

module.exports.Z_FULL_FLUSH = zlib.Z_FULL_FLUSH;

module.exports.Z_FINISH = zlib.Z_FINISH;

module.exports.Z_BLOCK = zlib.Z_BLOCK;

module.exports.Z_TREES = zlib.Z_TREES;

module.exports.Z_OK = zlib.Z_OK;

module.exports.Z_STREAM_END = zlib.Z_STREAM_END;

module.exports.Z_NEED_DICT = zlib.Z_NEED_DICT;

module.exports.Z_ERRNO = zlib.Z_ERRNO;

module.exports.Z_STREAM_ERROR = zlib.Z_STREAM_ERROR;

module.exports.Z_DATA_ERROR = zlib.Z_DATA_ERROR;

module.exports.Z_MEM_ERROR = zlib.Z_MEM_ERROR;

module.exports.Z_BUF_ERROR = zlib.Z_BUF_ERROR;

module.exports.Z_VERSION_ERROR = zlib.Z_VERSION_ERROR;

module.exports.Z_NO_COMPRESSION = zlib.Z_NO_COMPRESSION;

module.exports.Z_BEST_SPEED = zlib.Z_BEST_SPEED;

module.exports.Z_BEST_COMPRESSION = zlib.Z_BEST_COMPRESSION;

module.exports.Z_DEFAULT_COMPRESSION = zlib.Z_DEFAULT_COMPRESSION;

module.exports.Z_FILTERED = zlib.Z_FILTERED;

module.exports.Z_HUFFMAN_ONLY = zlib.Z_HUFFMAN_ONLY;

module.exports.Z_RLE = zlib.Z_RLE;

module.exports.Z_FIXED = zlib.Z_FIXED;

module.exports.Z_DEFAULT_STRATEGY = zlib.Z_DEFAULT_STRATEGY;

module.exports.Z_BINARY = zlib.Z_BINARY;

module.exports.Z_TEXT = zlib.Z_TEXT;

module.exports.Z_ASCII = zlib.Z_ASCII;

module.exports.Z_UNKNOWN = zlib.Z_UNKNOWN;

module.exports.Z_DEFLATED = zlib.Z_DEFLATED;

module.exports.Z_NULL = zlib.Z_NULL;

