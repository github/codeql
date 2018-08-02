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
 * @fileoverview Definitions for module "cluster"
 */

var cluster = {};

var child_process = require("child_process");

var events = require("events");

var net = require("net");

/**
 * @interface
 */
cluster.ClusterSettings = function() {};

/**
 * @type {Array<string>}
 */
cluster.ClusterSettings.prototype.execArgv;

/**
 * @type {string}
 */
cluster.ClusterSettings.prototype.exec;

/**
 * @type {Array<string>}
 */
cluster.ClusterSettings.prototype.args;

/**
 * @type {boolean}
 */
cluster.ClusterSettings.prototype.silent;

/**
 * @type {Array<*>}
 */
cluster.ClusterSettings.prototype.stdio;

/**
 * @type {number}
 */
cluster.ClusterSettings.prototype.uid;

/**
 * @type {number}
 */
cluster.ClusterSettings.prototype.gid;

/**
 * @interface
 */
cluster.ClusterSetupMasterSettings = function() {};

/**
 * @type {string}
 */
cluster.ClusterSetupMasterSettings.prototype.exec;

/**
 * @type {Array<string>}
 */
cluster.ClusterSetupMasterSettings.prototype.args;

/**
 * @type {boolean}
 */
cluster.ClusterSetupMasterSettings.prototype.silent;

/**
 * @type {Array<*>}
 */
cluster.ClusterSetupMasterSettings.prototype.stdio;

/**
 * @interface
 */
cluster.Address = function() {};

/**
 * @type {string}
 */
cluster.Address.prototype.address;

/**
 * @type {number}
 */
cluster.Address.prototype.port;

/**
 * @type {(number|string)}
 */
cluster.Address.prototype.addressType;

/**
 * @constructor
 * @extends {events.EventEmitter}
 */
cluster.Worker;

/**
 * @type {string}
 */
cluster.Worker.prototype.id;

/**
 * @type {child_process.ChildProcess}
 */
cluster.Worker.prototype.process;

/**
 * @type {boolean}
 */
cluster.Worker.prototype.suicide;

/**
 * @param {*} message
 * @param {*=} sendHandle
 * @return {boolean}
 */
cluster.Worker.prototype.send = function(message, sendHandle) {};

/**
 * @param {string=} signal
 * @return {void}
 */
cluster.Worker.prototype.kill = function(signal) {};

/**
 * @param {string=} signal
 * @return {void}
 */
cluster.Worker.prototype.destroy = function(signal) {};

/**
 * @return {void}
 */
cluster.Worker.prototype.disconnect = function() {};

/**
 * @return {boolean}
 */
cluster.Worker.prototype.isConnected = function() {};

/**
 * @return {boolean}
 */
cluster.Worker.prototype.isDead = function() {};

/**
 * @type {boolean}
 */
cluster.Worker.prototype.exitedAfterDisconnect;

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
cluster.Worker.prototype.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(): void)} listener
 * @return {*}
 */
cluster.Worker.prototype.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(number, string): void)} listener
 * @return {*}
 */
cluster.Worker.prototype.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Address): void)} listener
 * @return {*}
 */
cluster.Worker.prototype.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(*, (net.Socket|net.Server)): void)} listener
 * @return {*}
 */
cluster.Worker.prototype.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
cluster.Worker.prototype.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(): void)} listener
 * @return {*}
 */
cluster.Worker.prototype.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(number, string): void)} listener
 * @return {*}
 */
cluster.Worker.prototype.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Address): void)} listener
 * @return {*}
 */
cluster.Worker.prototype.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(*, (net.Socket|net.Server)): void)} listener
 * @return {*}
 */
cluster.Worker.prototype.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
cluster.Worker.prototype.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(): void)} listener
 * @return {*}
 */
cluster.Worker.prototype.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(number, string): void)} listener
 * @return {*}
 */
cluster.Worker.prototype.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Address): void)} listener
 * @return {*}
 */
cluster.Worker.prototype.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(*, (net.Socket|net.Server)): void)} listener
 * @return {*}
 */
cluster.Worker.prototype.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
cluster.Worker.prototype.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(): void)} listener
 * @return {*}
 */
cluster.Worker.prototype.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(number, string): void)} listener
 * @return {*}
 */
cluster.Worker.prototype.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Address): void)} listener
 * @return {*}
 */
cluster.Worker.prototype.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(*, (net.Socket|net.Server)): void)} listener
 * @return {*}
 */
cluster.Worker.prototype.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
cluster.Worker.prototype.prependOnceListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(): void)} listener
 * @return {*}
 */
cluster.Worker.prototype.prependOnceListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(number, string): void)} listener
 * @return {*}
 */
cluster.Worker.prototype.prependOnceListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Address): void)} listener
 * @return {*}
 */
cluster.Worker.prototype.prependOnceListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(*, (net.Socket|net.Server)): void)} listener
 * @return {*}
 */
cluster.Worker.prototype.prependOnceListener = function(event, listener) {};

/**
 * @interface
 * @extends {events.EventEmitter}
 */
cluster.Cluster = function() {};

/**
 * @type {cluster.Worker}
 */
cluster.Cluster.prototype.Worker;

/**
 * @param {Function=} callback
 * @return {void}
 */
cluster.Cluster.prototype.disconnect = function(callback) {};

/**
 * @param {*=} env
 * @return {cluster.Worker}
 */
cluster.Cluster.prototype.fork = function(env) {};

/**
 * @type {boolean}
 */
cluster.Cluster.prototype.isMaster;

/**
 * @type {boolean}
 */
cluster.Cluster.prototype.isWorker;

/**
 * @type {cluster.ClusterSettings}
 */
cluster.Cluster.prototype.settings;

/**
 * @param {cluster.ClusterSetupMasterSettings=} settings
 * @return {void}
 */
cluster.Cluster.prototype.setupMaster = function(settings) {};

/**
 * @type {cluster.Worker}
 */
cluster.Cluster.prototype.worker;

cluster.Cluster.prototype.workers;


/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
cluster.Cluster.prototype.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker): void)} listener
 * @return {*}
 */
cluster.Cluster.prototype.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker, number, string): void)} listener
 * @return {*}
 */
cluster.Cluster.prototype.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker, cluster.Address): void)} listener
 * @return {*}
 */
cluster.Cluster.prototype.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker, *, (net.Socket|net.Server)): void)} listener
 * @return {*}
 */
cluster.Cluster.prototype.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(*): void)} listener
 * @return {*}
 */
cluster.Cluster.prototype.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
cluster.Cluster.prototype.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker): void)} listener
 * @return {*}
 */
cluster.Cluster.prototype.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker, number, string): void)} listener
 * @return {*}
 */
cluster.Cluster.prototype.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker, cluster.Address): void)} listener
 * @return {*}
 */
cluster.Cluster.prototype.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker, *, (net.Socket|net.Server)): void)} listener
 * @return {*}
 */
cluster.Cluster.prototype.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(*): void)} listener
 * @return {*}
 */
cluster.Cluster.prototype.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
cluster.Cluster.prototype.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker): void)} listener
 * @return {*}
 */
cluster.Cluster.prototype.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker, number, string): void)} listener
 * @return {*}
 */
cluster.Cluster.prototype.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker, cluster.Address): void)} listener
 * @return {*}
 */
cluster.Cluster.prototype.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker, *, (net.Socket|net.Server)): void)} listener
 * @return {*}
 */
cluster.Cluster.prototype.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(*): void)} listener
 * @return {*}
 */
cluster.Cluster.prototype.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
cluster.Cluster.prototype.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker): void)} listener
 * @return {*}
 */
cluster.Cluster.prototype.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker, number, string): void)} listener
 * @return {*}
 */
cluster.Cluster.prototype.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker, cluster.Address): void)} listener
 * @return {*}
 */
cluster.Cluster.prototype.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker, *, (net.Socket|net.Server)): void)} listener
 * @return {*}
 */
cluster.Cluster.prototype.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(*): void)} listener
 * @return {*}
 */
cluster.Cluster.prototype.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
cluster.Cluster.prototype.prependOnceListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker): void)} listener
 * @return {*}
 */
cluster.Cluster.prototype.prependOnceListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker, number, string): void)} listener
 * @return {*}
 */
cluster.Cluster.prototype.prependOnceListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker, cluster.Address): void)} listener
 * @return {*}
 */
cluster.Cluster.prototype.prependOnceListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker, *, (net.Socket|net.Server)): void)} listener
 * @return {*}
 */
cluster.Cluster.prototype.prependOnceListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(*): void)} listener
 * @return {*}
 */
cluster.Cluster.prototype.prependOnceListener = function(event, listener) {};

/**
 * @param {Function=} callback
 * @return {void}
 */
cluster.disconnect = function(callback) {};

/**
 * @param {*=} env
 * @return {cluster.Worker}
 */
cluster.fork = function(env) {};

/**
 * @type {boolean}
 */
cluster.isMaster;

/**
 * @type {boolean}
 */
cluster.isWorker;

/**
 * @type {cluster.ClusterSettings}
 */
cluster.settings;

/**
 * @param {cluster.ClusterSetupMasterSettings=} settings
 * @return {void}
 */
cluster.setupMaster = function(settings) {};

/**
 * @type {cluster.Worker}
 */
cluster.worker;

cluster.workers;


/**
 * @param {string} event
 * @param {Function} listener
 * @return {cluster.Cluster}
 */
cluster.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker): void)} listener
 * @return {cluster.Cluster}
 */
cluster.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker, number, string): void)} listener
 * @return {cluster.Cluster}
 */
cluster.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker, cluster.Address): void)} listener
 * @return {cluster.Cluster}
 */
cluster.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker, *, (net.Socket|net.Server)): void)} listener
 * @return {cluster.Cluster}
 */
cluster.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(*): void)} listener
 * @return {cluster.Cluster}
 */
cluster.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {cluster.Cluster}
 */
cluster.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker): void)} listener
 * @return {cluster.Cluster}
 */
cluster.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker, number, string): void)} listener
 * @return {cluster.Cluster}
 */
cluster.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker, cluster.Address): void)} listener
 * @return {cluster.Cluster}
 */
cluster.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker, *, (net.Socket|net.Server)): void)} listener
 * @return {cluster.Cluster}
 */
cluster.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(*): void)} listener
 * @return {cluster.Cluster}
 */
cluster.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {cluster.Cluster}
 */
cluster.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker): void)} listener
 * @return {cluster.Cluster}
 */
cluster.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker, number, string): void)} listener
 * @return {cluster.Cluster}
 */
cluster.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker, cluster.Address): void)} listener
 * @return {cluster.Cluster}
 */
cluster.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker, *, (net.Socket|net.Server)): void)} listener
 * @return {cluster.Cluster}
 */
cluster.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(*): void)} listener
 * @return {cluster.Cluster}
 */
cluster.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {cluster.Cluster}
 */
cluster.removeListener = function(event, listener) {};

/**
 * @param {string=} event
 * @return {cluster.Cluster}
 */
cluster.removeAllListeners = function(event) {};

/**
 * @param {number} n
 * @return {cluster.Cluster}
 */
cluster.setMaxListeners = function(n) {};

/**
 * @return {number}
 */
cluster.getMaxListeners = function() {};

/**
 * @param {string} event
 * @return {Array<Function>}
 */
cluster.listeners = function(event) {};

/**
 * @param {string} event
 * @param {...*} args
 * @return {boolean}
 */
cluster.emit = function(event, args) {};

/**
 * @param {string} type
 * @return {number}
 */
cluster.listenerCount = function(type) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {cluster.Cluster}
 */
cluster.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker): void)} listener
 * @return {cluster.Cluster}
 */
cluster.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker, number, string): void)} listener
 * @return {cluster.Cluster}
 */
cluster.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker, cluster.Address): void)} listener
 * @return {cluster.Cluster}
 */
cluster.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker, *, (net.Socket|net.Server)): void)} listener
 * @return {cluster.Cluster}
 */
cluster.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(*): void)} listener
 * @return {cluster.Cluster}
 */
cluster.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {cluster.Cluster}
 */
cluster.prependOnceListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker): void)} listener
 * @return {cluster.Cluster}
 */
cluster.prependOnceListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker, number, string): void)} listener
 * @return {cluster.Cluster}
 */
cluster.prependOnceListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker, cluster.Address): void)} listener
 * @return {cluster.Cluster}
 */
cluster.prependOnceListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(cluster.Worker, *, (net.Socket|net.Server)): void)} listener
 * @return {cluster.Cluster}
 */
cluster.prependOnceListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(*): void)} listener
 * @return {cluster.Cluster}
 */
cluster.prependOnceListener = function(event, listener) {};

/**
 * @return {Array<string>}
 */
cluster.eventNames = function() {};

module.exports.ClusterSettings = cluster.ClusterSettings;

module.exports.ClusterSetupMasterSettings = cluster.ClusterSetupMasterSettings;

module.exports.Address = cluster.Address;

module.exports.Worker = cluster.Worker;

module.exports.Cluster = cluster.Cluster;

module.exports.disconnect = cluster.disconnect;

module.exports.fork = cluster.fork;

module.exports.isMaster = cluster.isMaster;

module.exports.isWorker = cluster.isWorker;

module.exports.settings = cluster.settings;

module.exports.setupMaster = cluster.setupMaster;

module.exports.worker = cluster.worker;

module.exports.workers = cluster.workers;

module.exports.addListener = cluster.addListener;

module.exports.addListener = cluster.addListener;

module.exports.addListener = cluster.addListener;

module.exports.addListener = cluster.addListener;

module.exports.addListener = cluster.addListener;

module.exports.addListener = cluster.addListener;

module.exports.on = cluster.on;

module.exports.on = cluster.on;

module.exports.on = cluster.on;

module.exports.on = cluster.on;

module.exports.on = cluster.on;

module.exports.on = cluster.on;

module.exports.once = cluster.once;

module.exports.once = cluster.once;

module.exports.once = cluster.once;

module.exports.once = cluster.once;

module.exports.once = cluster.once;

module.exports.once = cluster.once;

module.exports.removeListener = cluster.removeListener;

module.exports.removeAllListeners = cluster.removeAllListeners;

module.exports.setMaxListeners = cluster.setMaxListeners;

module.exports.getMaxListeners = cluster.getMaxListeners;

module.exports.listeners = cluster.listeners;

module.exports.emit = cluster.emit;

module.exports.listenerCount = cluster.listenerCount;

module.exports.prependListener = cluster.prependListener;

module.exports.prependListener = cluster.prependListener;

module.exports.prependListener = cluster.prependListener;

module.exports.prependListener = cluster.prependListener;

module.exports.prependListener = cluster.prependListener;

module.exports.prependListener = cluster.prependListener;

module.exports.prependOnceListener = cluster.prependOnceListener;

module.exports.prependOnceListener = cluster.prependOnceListener;

module.exports.prependOnceListener = cluster.prependOnceListener;

module.exports.prependOnceListener = cluster.prependOnceListener;

module.exports.prependOnceListener = cluster.prependOnceListener;

module.exports.prependOnceListener = cluster.prependOnceListener;

module.exports.eventNames = cluster.eventNames;

