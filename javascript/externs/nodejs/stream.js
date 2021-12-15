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
 * @fileoverview Definitions for module "stream"
 */

var events = require("events");

/**
 * @constructor
 * @extends {events.EventEmitter}
 */
function internal() {}

/**
 * @template T
 * @param {T} destination
 * @param {{end: boolean}=} options
 * @return {T}
 */
internal.prototype.pipe = function(destination, options) {};

var internal = internal || {};

/**
 * @constructor
 * @extends {internal}
 */
internal.Stream;

/**
 * @interface
 */
internal.ReadableOptions = function() {};

/**
 * @type {number}
 */
internal.ReadableOptions.prototype.highWaterMark;

/**
 * @type {string}
 */
internal.ReadableOptions.prototype.encoding;

/**
 * @type {boolean}
 */
internal.ReadableOptions.prototype.objectMode;

/**
 * @type {(function(number=): *)}
 */
internal.ReadableOptions.prototype.read;

/**
 * @param {internal.ReadableOptions=} opts
 * @return {internal.Readable}
 * @constructor
 */
internal.Readable = function(opts) {};

/**
 * @type {boolean}
 */
internal.Readable.prototype.readable;

/**
 * @param {number} size
 * @return {void}
 */
internal.Readable.prototype._read = function(size) {};

/**
 * @param {number=} size
 * @return {*}
 */
internal.Readable.prototype.read = function(size) {};

/**
 * @param {string} encoding
 * @return {void}
 */
internal.Readable.prototype.setEncoding = function(encoding) {};

/**
 * @return {internal.Readable}
 */
internal.Readable.prototype.pause = function() {};

/**
 * @return {internal.Readable}
 */
internal.Readable.prototype.resume = function() {};

/**
 * @template T
 * @param {T} destination
 * @param {{end: boolean}=} options
 * @return {T}
 */
internal.Readable.prototype.pipe = function(destination, options) {};

/**
 * @template T
 * @param {T=} destination
 * @return {void}
 */
internal.Readable.prototype.unpipe = function(destination) {};

/**
 * @param {*} chunk
 * @return {void}
 */
internal.Readable.prototype.unshift = function(chunk) {};

/**
 * @param {NodeJS.ReadableStream} oldStream
 * @return {NodeJS.ReadableStream}
 */
internal.Readable.prototype.wrap = function(oldStream) {};

/**
 * @param {*} chunk
 * @param {string=} encoding
 * @return {boolean}
 */
internal.Readable.prototype.push = function(chunk, encoding) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
internal.Readable.prototype.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(): void)} listener
 * @return {*}
 */
internal.Readable.prototype.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function((Buffer|string)): void)} listener
 * @return {*}
 */
internal.Readable.prototype.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(Error): void)} listener
 * @return {*}
 */
internal.Readable.prototype.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {...*} args
 * @return {boolean}
 */
internal.Readable.prototype.emit = function(event, args) {};

/**
 * @param {string} event
 * @return {boolean}
 */
internal.Readable.prototype.emit = function(event) {};

/**
 * @param {string} event
 * @param {(Buffer|string)} chunk
 * @return {boolean}
 */
internal.Readable.prototype.emit = function(event, chunk) {};

/**
 * @param {string} event
 * @param {Error} err
 * @return {boolean}
 */
internal.Readable.prototype.emit = function(event, err) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
internal.Readable.prototype.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(): void)} listener
 * @return {*}
 */
internal.Readable.prototype.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function((Buffer|string)): void)} listener
 * @return {*}
 */
internal.Readable.prototype.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(Error): void)} listener
 * @return {*}
 */
internal.Readable.prototype.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
internal.Readable.prototype.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(): void)} listener
 * @return {*}
 */
internal.Readable.prototype.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function((Buffer|string)): void)} listener
 * @return {*}
 */
internal.Readable.prototype.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(Error): void)} listener
 * @return {*}
 */
internal.Readable.prototype.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
internal.Readable.prototype.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(): void)} listener
 * @return {*}
 */
internal.Readable.prototype.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function((Buffer|string)): void)} listener
 * @return {*}
 */
internal.Readable.prototype.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(Error): void)} listener
 * @return {*}
 */
internal.Readable.prototype.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
internal.Readable.prototype.prependOnceListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(): void)} listener
 * @return {*}
 */
internal.Readable.prototype.prependOnceListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function((Buffer|string)): void)} listener
 * @return {*}
 */
internal.Readable.prototype.prependOnceListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(Error): void)} listener
 * @return {*}
 */
internal.Readable.prototype.prependOnceListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
internal.Readable.prototype.removeListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(): void)} listener
 * @return {*}
 */
internal.Readable.prototype.removeListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function((Buffer|string)): void)} listener
 * @return {*}
 */
internal.Readable.prototype.removeListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(Error): void)} listener
 * @return {*}
 */
internal.Readable.prototype.removeListener = function(event, listener) {};

/**
 * @interface
 */
internal.WritableOptions = function() {};

/**
 * @type {number}
 */
internal.WritableOptions.prototype.highWaterMark;

/**
 * @type {boolean}
 */
internal.WritableOptions.prototype.decodeStrings;

/**
 * @type {boolean}
 */
internal.WritableOptions.prototype.objectMode;

/**
 * @type {(function((string|Buffer), string, Function): *)}
 */
internal.WritableOptions.prototype.write;

/**
 * @type {(function(Array<{chunk: (string|Buffer), encoding: string}>, Function): *)}
 */
internal.WritableOptions.prototype.writev;

/**
 * @param {internal.WritableOptions=} opts
 * @return {internal.Writable}
 * @constructor
 */
internal.Writable = function(opts) {};

/**
 * @type {boolean}
 */
internal.Writable.prototype.writable;

/**
 * @param {*} chunk
 * @param {string} encoding
 * @param {Function} callback
 * @return {void}
 */
internal.Writable.prototype._write = function(chunk, encoding, callback) {};

/**
 * @param {*} chunk
 * @param {Function=} cb
 * @return {boolean}
 */
internal.Writable.prototype.write = function(chunk, cb) {};

/**
 * @param {*} chunk
 * @param {string=} encoding
 * @param {Function=} cb
 * @return {boolean}
 */
internal.Writable.prototype.write = function(chunk, encoding, cb) {};

/**
 * @return {void}
 */
internal.Writable.prototype.end = function() {};

/**
 * @param {*} chunk
 * @param {Function=} cb
 * @return {void}
 */
internal.Writable.prototype.end = function(chunk, cb) {};

/**
 * @param {*} chunk
 * @param {string=} encoding
 * @param {Function=} cb
 * @return {void}
 */
internal.Writable.prototype.end = function(chunk, encoding, cb) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
internal.Writable.prototype.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(): void)} listener
 * @return {*}
 */
internal.Writable.prototype.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(Error): void)} listener
 * @return {*}
 */
internal.Writable.prototype.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(internal.Readable): void)} listener
 * @return {*}
 */
internal.Writable.prototype.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {...*} args
 * @return {boolean}
 */
internal.Writable.prototype.emit = function(event, args) {};

/**
 * @param {string} event
 * @return {boolean}
 */
internal.Writable.prototype.emit = function(event) {};

/**
 * @param {string} event
 * @param {(Buffer|string)} chunk
 * @return {boolean}
 */
internal.Writable.prototype.emit = function(event, chunk) {};

/**
 * @param {string} event
 * @param {Error} err
 * @return {boolean}
 */
internal.Writable.prototype.emit = function(event, err) {};

/**
 * @param {string} event
 * @param {internal.Readable} src
 * @return {boolean}
 */
internal.Writable.prototype.emit = function(event, src) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
internal.Writable.prototype.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(): void)} listener
 * @return {*}
 */
internal.Writable.prototype.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(Error): void)} listener
 * @return {*}
 */
internal.Writable.prototype.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(internal.Readable): void)} listener
 * @return {*}
 */
internal.Writable.prototype.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
internal.Writable.prototype.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(): void)} listener
 * @return {*}
 */
internal.Writable.prototype.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(Error): void)} listener
 * @return {*}
 */
internal.Writable.prototype.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(internal.Readable): void)} listener
 * @return {*}
 */
internal.Writable.prototype.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
internal.Writable.prototype.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(): void)} listener
 * @return {*}
 */
internal.Writable.prototype.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(Error): void)} listener
 * @return {*}
 */
internal.Writable.prototype.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(internal.Readable): void)} listener
 * @return {*}
 */
internal.Writable.prototype.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
internal.Writable.prototype.prependOnceListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(): void)} listener
 * @return {*}
 */
internal.Writable.prototype.prependOnceListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(Error): void)} listener
 * @return {*}
 */
internal.Writable.prototype.prependOnceListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(internal.Readable): void)} listener
 * @return {*}
 */
internal.Writable.prototype.prependOnceListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
internal.Writable.prototype.removeListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(): void)} listener
 * @return {*}
 */
internal.Writable.prototype.removeListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(Error): void)} listener
 * @return {*}
 */
internal.Writable.prototype.removeListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(internal.Readable): void)} listener
 * @return {*}
 */
internal.Writable.prototype.removeListener = function(event, listener) {};

/**
 * @interface
 * @extends {internal.ReadableOptions}
 * @extends {internal.WritableOptions}
 */
internal.DuplexOptions = function() {};

/**
 * @type {boolean}
 */
internal.DuplexOptions.prototype.allowHalfOpen;

/**
 * @type {boolean}
 */
internal.DuplexOptions.prototype.readableObjectMode;

/**
 * @type {boolean}
 */
internal.DuplexOptions.prototype.writableObjectMode;

/**
 * @param {internal.DuplexOptions=} opts
 * @return {internal.Duplex}
 * @constructor
 */
internal.Duplex = function(opts) {};

/**
 * @return {internal.Duplex}
 */
internal.Duplex.prototype.pause = function() {};

/**
 * @return {internal.Duplex}
 */
internal.Duplex.prototype.resume = function() {};

/**
 * @type {boolean}
 */
internal.Duplex.prototype.writable;

/**
 * @param {*} chunk
 * @param {string} encoding
 * @param {Function} callback
 * @return {void}
 */
internal.Duplex.prototype._write = function(chunk, encoding, callback) {};

/**
 * @param {*} chunk
 * @param {Function=} cb
 * @return {boolean}
 */
internal.Duplex.prototype.write = function(chunk, cb) {};

/**
 * @param {*} chunk
 * @param {string=} encoding
 * @param {Function=} cb
 * @return {boolean}
 */
internal.Duplex.prototype.write = function(chunk, encoding, cb) {};

/**
 * @return {void}
 */
internal.Duplex.prototype.end = function() {};

/**
 * @param {*} chunk
 * @param {Function=} cb
 * @return {void}
 */
internal.Duplex.prototype.end = function(chunk, cb) {};

/**
 * @param {*} chunk
 * @param {string=} encoding
 * @param {Function=} cb
 * @return {void}
 */
internal.Duplex.prototype.end = function(chunk, encoding, cb) {};

/**
 * @interface
 * @extends {internal.ReadableOptions}
 * @extends {internal.WritableOptions}
 */
internal.TransformOptions = function() {};

/**
 * @type {(function((string|Buffer), string, Function): *)}
 */
internal.TransformOptions.prototype.transform;

/**
 * @type {(function(Function): *)}
 */
internal.TransformOptions.prototype.flush;

/**
 * @param {internal.TransformOptions=} opts
 * @return {internal.Transform}
 * @constructor
 */
internal.Transform = function(opts) {};

/**
 * @type {boolean}
 */
internal.Transform.prototype.readable;

/**
 * @type {boolean}
 */
internal.Transform.prototype.writable;

/**
 * @param {*} chunk
 * @param {string} encoding
 * @param {Function} callback
 * @return {void}
 */
internal.Transform.prototype._transform = function(chunk, encoding, callback) {};

/**
 * @param {Function} callback
 * @return {void}
 */
internal.Transform.prototype._flush = function(callback) {};

/**
 * @param {number=} size
 * @return {*}
 */
internal.Transform.prototype.read = function(size) {};

/**
 * @param {string} encoding
 * @return {void}
 */
internal.Transform.prototype.setEncoding = function(encoding) {};

/**
 * @return {internal.Transform}
 */
internal.Transform.prototype.pause = function() {};

/**
 * @return {internal.Transform}
 */
internal.Transform.prototype.resume = function() {};

/**
 * @template T
 * @param {T} destination
 * @param {{end: boolean}=} options
 * @return {T}
 */
internal.Transform.prototype.pipe = function(destination, options) {};

/**
 * @template T
 * @param {T=} destination
 * @return {void}
 */
internal.Transform.prototype.unpipe = function(destination) {};

/**
 * @param {*} chunk
 * @return {void}
 */
internal.Transform.prototype.unshift = function(chunk) {};

/**
 * @param {NodeJS.ReadableStream} oldStream
 * @return {NodeJS.ReadableStream}
 */
internal.Transform.prototype.wrap = function(oldStream) {};

/**
 * @param {*} chunk
 * @param {string=} encoding
 * @return {boolean}
 */
internal.Transform.prototype.push = function(chunk, encoding) {};

/**
 * @param {*} chunk
 * @param {Function=} cb
 * @return {boolean}
 */
internal.Transform.prototype.write = function(chunk, cb) {};

/**
 * @param {*} chunk
 * @param {string=} encoding
 * @param {Function=} cb
 * @return {boolean}
 */
internal.Transform.prototype.write = function(chunk, encoding, cb) {};

/**
 * @return {void}
 */
internal.Transform.prototype.end = function() {};

/**
 * @param {*} chunk
 * @param {Function=} cb
 * @return {void}
 */
internal.Transform.prototype.end = function(chunk, cb) {};

/**
 * @param {*} chunk
 * @param {string=} encoding
 * @param {Function=} cb
 * @return {void}
 */
internal.Transform.prototype.end = function(chunk, encoding, cb) {};

/**
 * @constructor
 * @extends {internal.Transform}
 */
internal.PassThrough;


module.exports = internal;

