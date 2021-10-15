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
 * @fileoverview Definitions for module "domain"
 */

var domain = {};

var events = require("events");

/**
 * @constructor
 * @extends {events.EventEmitter}
 * @implements {NodeJS.Domain}
 */
domain.Domain;

/**
 * @param {Function} fn
 * @return {void}
 */
domain.Domain.prototype.run = function(fn) {};

/**
 * @param {events.EventEmitter} emitter
 * @return {void}
 */
domain.Domain.prototype.add = function(emitter) {};

/**
 * @param {events.EventEmitter} emitter
 * @return {void}
 */
domain.Domain.prototype.remove = function(emitter) {};

/**
 * @param {(function(Error, *): *)} cb
 * @return {*}
 */
domain.Domain.prototype.bind = function(cb) {};

/**
 * @param {(function(*): *)} cb
 * @return {*}
 */
domain.Domain.prototype.intercept = function(cb) {};

/**
 * @return {void}
 */
domain.Domain.prototype.dispose = function() {};

/**
 * @type {Array<*>}
 */
domain.Domain.prototype.members;

/**
 * @return {void}
 */
domain.Domain.prototype.enter = function() {};

/**
 * @return {void}
 */
domain.Domain.prototype.exit = function() {};

/**
 * @return {domain.Domain}
 */
domain.create = function() {};

module.exports.Domain = domain.Domain;

module.exports.create = domain.create;

/**
 * @type {domain.Domain}
 */
domain.active;

module.exports.active = domain.active;

