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
 * @fileoverview Definitions for module "timers"
 */

var timers = {};

/**
 * @param {(function(...*): void)} callback
 * @param {number} ms
 * @param {...*} args
 * @return {NodeJS.Timer}
 */
timers.setTimeout = function(callback, ms, args) {};

/**
 * @param {NodeJS.Timer} timeoutId
 * @return {void}
 */
timers.clearTimeout = function(timeoutId) {};

/**
 * @param {(function(...*): void)} callback
 * @param {number} ms
 * @param {...*} args
 * @return {NodeJS.Timer}
 */
timers.setInterval = function(callback, ms, args) {};

/**
 * @param {NodeJS.Timer} intervalId
 * @return {void}
 */
timers.clearInterval = function(intervalId) {};

/**
 * @param {(function(...*): void)} callback
 * @param {...*} args
 * @return {*}
 */
timers.setImmediate = function(callback, args) {};

/**
 * @param {*} immediateId
 * @return {void}
 */
timers.clearImmediate = function(immediateId) {};

module.exports.setTimeout = timers.setTimeout;

module.exports.clearTimeout = timers.clearTimeout;

module.exports.setInterval = timers.setInterval;

module.exports.clearInterval = timers.clearInterval;

module.exports.setImmediate = timers.setImmediate;

module.exports.clearImmediate = timers.clearImmediate;

/**
 * @param {NodeJS.Timer} item
 * @return {*}
 */
timers.active = function(item) {};

/**
 * @param {NodeJS.Timer} item
 * @return {*}
 */
timers._unrefActive = function(item) {};

/**
 * @param {NodeJS.Timer} item
 * @return {*}
 */
timers.unenroll = function(item) {};

/**
 * @param {NodeJS.Timer} item
 * @param {number} msecs
 * @return {*}
 */
timers.enroll = function(item, msecs) {};

module.exports.active = timers.active;

module.exports._unrefActive = timers._unrefActive;

module.exports.unenroll = timers.unenroll;

module.exports.enroll = timers.enroll;

