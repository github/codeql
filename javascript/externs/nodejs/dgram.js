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
 * @fileoverview Definitions for module "dgram"
 */

var dgram = {};

var events = require("events");

/**
 * @interface
 */
function RemoteInfo() {}

/**
 * @type {string}
 */
RemoteInfo.prototype.address;

/**
 * @type {number}
 */
RemoteInfo.prototype.port;

/**
 * @type {number}
 */
RemoteInfo.prototype.size;

/**
 * @interface
 */
function AddressInfo() {}

/**
 * @type {string}
 */
AddressInfo.prototype.address;

/**
 * @type {string}
 */
AddressInfo.prototype.family;

/**
 * @type {number}
 */
AddressInfo.prototype.port;

/**
 * @interface
 */
function BindOptions() {}

/**
 * @type {number}
 */
BindOptions.prototype.port;

/**
 * @type {string}
 */
BindOptions.prototype.address;

/**
 * @type {boolean}
 */
BindOptions.prototype.exclusive;

/**
 * @interface
 */
function SocketOptions() {}

/**
 * @type {(string)}
 */
SocketOptions.prototype.type;

/**
 * @type {boolean}
 */
SocketOptions.prototype.reuseAddr;

/**
 * @param {string} type
 * @param {(function(Buffer, dgram.RemoteInfo): void)=} callback
 * @return {dgram.Socket}
 */
dgram.createSocket = function(type, callback) {};

/**
 * @param {dgram.SocketOptions} options
 * @param {(function(Buffer, dgram.RemoteInfo): void)=} callback
 * @return {dgram.Socket}
 */
dgram.createSocket = function(options, callback) {};

/**
 * @interface
 * @extends {events.EventEmitter}
 */
dgram.Socket = function() {};

/**
 * @param {(Buffer|String|Array<*>)} msg
 * @param {number} port
 * @param {string} address
 * @param {(function(Error, number): void)=} callback
 * @return {void}
 */
dgram.Socket.prototype.send = function(msg, port, address, callback) {};

/**
 * @param {(Buffer|String|Array<*>)} msg
 * @param {number} offset
 * @param {number} length
 * @param {number} port
 * @param {string} address
 * @param {(function(Error, number): void)=} callback
 * @return {void}
 */
dgram.Socket.prototype.send = function(msg, offset, length, port, address, callback) {};

/**
 * @param {number=} port
 * @param {string=} address
 * @param {(function(): void)=} callback
 * @return {void}
 */
dgram.Socket.prototype.bind = function(port, address, callback) {};

/**
 * @param {dgram.BindOptions} options
 * @param {Function=} callback
 * @return {void}
 */
dgram.Socket.prototype.bind = function(options, callback) {};

/**
 * @param {*=} callback
 * @return {void}
 */
dgram.Socket.prototype.close = function(callback) {};

/**
 * @return {dgram.AddressInfo}
 */
dgram.Socket.prototype.address = function() {};

/**
 * @param {boolean} flag
 * @return {void}
 */
dgram.Socket.prototype.setBroadcast = function(flag) {};

/**
 * @param {number} ttl
 * @return {void}
 */
dgram.Socket.prototype.setTTL = function(ttl) {};

/**
 * @param {number} ttl
 * @return {void}
 */
dgram.Socket.prototype.setMulticastTTL = function(ttl) {};

/**
 * @param {boolean} flag
 * @return {void}
 */
dgram.Socket.prototype.setMulticastLoopback = function(flag) {};

/**
 * @param {string} multicastAddress
 * @param {string=} multicastInterface
 * @return {void}
 */
dgram.Socket.prototype.addMembership = function(multicastAddress, multicastInterface) {};

/**
 * @param {string} multicastAddress
 * @param {string=} multicastInterface
 * @return {void}
 */
dgram.Socket.prototype.dropMembership = function(multicastAddress, multicastInterface) {};

/**
 * @return {void}
 */
dgram.Socket.prototype.ref = function() {};

/**
 * @return {void}
 */
dgram.Socket.prototype.unref = function() {};

module.exports.createSocket = dgram.createSocket;

module.exports.createSocket = dgram.createSocket;

module.exports.Socket = dgram.Socket;

