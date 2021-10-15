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
 * @fileoverview Definitions for module "tty"
 */

var tty = {};

var net = require("net");

/**
 * @param {number} fd
 * @return {boolean}
 */
tty.isatty = function(fd) {};

/**
 * @interface
 * @extends {net.Socket}
 */
tty.ReadStream = function() {};

/**
 * @type {boolean}
 */
tty.ReadStream.prototype.isRaw;

/**
 * @param {boolean} mode
 * @return {void}
 */
tty.ReadStream.prototype.setRawMode = function(mode) {};

/**
 * @type {boolean}
 */
tty.ReadStream.prototype.isTTY;

/**
 * @interface
 * @extends {net.Socket}
 */
tty.WriteStream = function() {};

/**
 * @type {number}
 */
tty.WriteStream.prototype.columns;

/**
 * @type {number}
 */
tty.WriteStream.prototype.rows;

/**
 * @type {boolean}
 */
tty.WriteStream.prototype.isTTY;

module.exports.isatty = tty.isatty;

module.exports.ReadStream = tty.ReadStream;

module.exports.WriteStream = tty.WriteStream;

/**
 * @param {boolean} mode
 * @return {void}
 */
tty.setRawMode = function(mode) {};

/**
 * @param {string} path
 * @param {Array<string>=} args
 * @return {Array<*>}
 */
tty.open = function(path, args) {};

/**
 * @param {*} fd
 * @param {number} row
 * @param {number} col
 * @return {*}
 */
tty.setWindowSize = function(fd, row, col) {};

/**
 * @param {*} fd
 * @return {Array<number>}
 */
tty.getWindowSize = function(fd) {};

module.exports.setRawMode = tty.setRawMode;

module.exports.open = tty.open;

module.exports.setWindowSize = tty.setWindowSize;

module.exports.getWindowSize = tty.getWindowSize;

