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
 * @fileoverview Definitions for module "path"
 */

var path = {};

/**
 * @interface
 */
path.ParsedPath = function() {};

/**
 * @type {string}
 */
path.ParsedPath.prototype.root;

/**
 * @type {string}
 */
path.ParsedPath.prototype.dir;

/**
 * @type {string}
 */
path.ParsedPath.prototype.base;

/**
 * @type {string}
 */
path.ParsedPath.prototype.ext;

/**
 * @type {string}
 */
path.ParsedPath.prototype.name;

/**
 * @param {string} p
 * @return {string}
 */
path.normalize = function(p) {};

/**
 * @param {...*} paths
 * @return {string}
 */
path.join = function(paths) {};

/**
 * @param {...string} paths
 * @return {string}
 */
path.join = function(paths) {};

/**
 * @param {...*} pathSegments
 * @return {string}
 */
path.resolve = function(pathSegments) {};

/**
 * @param {string} path
 * @return {boolean}
 */
path.isAbsolute = function(path) {};

/**
 * @param {string} from
 * @param {string} to
 * @return {string}
 */
path.relative = function(from, to) {};

/**
 * @param {string} p
 * @return {string}
 */
path.dirname = function(p) {};

/**
 * @param {string} p
 * @param {string=} ext
 * @return {string}
 */
path.basename = function(p, ext) {};

/**
 * @param {string} p
 * @return {string}
 */
path.extname = function(p) {};

/**
 * @type {string}
 */
path.sep;

/**
 * @type {string}
 */
path.delimiter;

/**
 * @param {string} pathString
 * @return {path.ParsedPath}
 */
path.parse = function(pathString) {};

/**
 * @param {path.ParsedPath} pathObject
 * @return {string}
 */
path.format = function(pathObject) {};

path.posix = path.posix || {};

/**
 * @param {string} p
 * @return {string}
 */
path.posix.normalize = function(p) {};

/**
 * @param {...*} paths
 * @return {string}
 */
path.posix.join = function(paths) {};

/**
 * @param {...*} pathSegments
 * @return {string}
 */
path.posix.resolve = function(pathSegments) {};

/**
 * @param {string} p
 * @return {boolean}
 */
path.posix.isAbsolute = function(p) {};

/**
 * @param {string} from
 * @param {string} to
 * @return {string}
 */
path.posix.relative = function(from, to) {};

/**
 * @param {string} p
 * @return {string}
 */
path.posix.dirname = function(p) {};

/**
 * @param {string} p
 * @param {string=} ext
 * @return {string}
 */
path.posix.basename = function(p, ext) {};

/**
 * @param {string} p
 * @return {string}
 */
path.posix.extname = function(p) {};

/**
 * @type {string}
 */
path.posix.sep;

/**
 * @type {string}
 */
path.posix.delimiter;

/**
 * @param {string} p
 * @return {path.ParsedPath}
 */
path.posix.parse = function(p) {};

/**
 * @param {path.ParsedPath} pP
 * @return {string}
 */
path.posix.format = function(pP) {};


path.win32 = path.win32 || {};

/**
 * @param {string} p
 * @return {string}
 */
path.win32.normalize = function(p) {};

/**
 * @param {...*} paths
 * @return {string}
 */
path.win32.join = function(paths) {};

/**
 * @param {...*} pathSegments
 * @return {string}
 */
path.win32.resolve = function(pathSegments) {};

/**
 * @param {string} p
 * @return {boolean}
 */
path.win32.isAbsolute = function(p) {};

/**
 * @param {string} from
 * @param {string} to
 * @return {string}
 */
path.win32.relative = function(from, to) {};

/**
 * @param {string} p
 * @return {string}
 */
path.win32.dirname = function(p) {};

/**
 * @param {string} p
 * @param {string=} ext
 * @return {string}
 */
path.win32.basename = function(p, ext) {};

/**
 * @param {string} p
 * @return {string}
 */
path.win32.extname = function(p) {};

/**
 * @type {string}
 */
path.win32.sep;

/**
 * @type {string}
 */
path.win32.delimiter;

/**
 * @param {string} p
 * @return {path.ParsedPath}
 */
path.win32.parse = function(p) {};

/**
 * @param {path.ParsedPath} pP
 * @return {string}
 */
path.win32.format = function(pP) {};


module.exports.ParsedPath = path.ParsedPath;

module.exports.normalize = path.normalize;

module.exports.join = path.join;

module.exports.join = path.join;

module.exports.resolve = path.resolve;

module.exports.isAbsolute = path.isAbsolute;

module.exports.relative = path.relative;

module.exports.dirname = path.dirname;

module.exports.basename = path.basename;

module.exports.extname = path.extname;

module.exports.sep = path.sep;

module.exports.delimiter = path.delimiter;

module.exports.parse = path.parse;

module.exports.format = path.format;

module.exports.posix = path.posix;

module.exports.win32 = path.win32;

/**
 * @param {string} path
 * @return {string}
 */
path._makeLong = function(path) {};

module.exports._makeLong = path._makeLong;

/**
 * @param {string} path
 * @param {(function(boolean): *)} callback
 * @return {boolean}
 */
path.exists = function(path, callback) {};

/**
 * @param {string} path
 * @return {boolean}
 */
path.existsSync = function(path) {};

module.exports.exists = path.exists;

module.exports.existsSync = path.existsSync;

