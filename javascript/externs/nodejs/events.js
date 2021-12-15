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
 * @fileoverview Definitions for module "events"
 */

var events = function() {};

/**
 * @constructor
 * @extends {NodeJS.EventEmitter}
 */
events.EventEmitter;

/**
 * @type {events.EventEmitter}
 */
events.EventEmitter.EventEmitter;

/**
 * @param {events.EventEmitter} emitter
 * @param {string} event
 * @return {number}
 */
events.EventEmitter.listenerCount = function(emitter, event) {};

/**
 * @type {number}
 */
events.EventEmitter.defaultMaxListeners;

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
events.EventEmitter.prototype.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
events.EventEmitter.prototype.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
events.EventEmitter.prototype.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
events.EventEmitter.prototype.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
events.EventEmitter.prototype.prependOnceListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
events.EventEmitter.prototype.removeListener = function(event, listener) {};

/**
 * @param {string=} event
 * @return {*}
 */
events.EventEmitter.prototype.removeAllListeners = function(event) {};

/**
 * @param {number} n
 * @return {*}
 */
events.EventEmitter.prototype.setMaxListeners = function(n) {};

/**
 * @return {number}
 */
events.EventEmitter.prototype.getMaxListeners = function() {};

/**
 * @param {string} event
 * @return {Array<Function>}
 */
events.EventEmitter.prototype.listeners = function(event) {};

/**
 * @param {string} event
 * @param {...*} args
 * @return {boolean}
 */
events.EventEmitter.prototype.emit = function(event, args) {};

/**
 * @return {Array<string>}
 */
events.EventEmitter.prototype.eventNames = function() {};

/**
 * @param {string} type
 * @return {number}
 */
events.EventEmitter.prototype.listenerCount = function(type) {};

module.exports = events;

