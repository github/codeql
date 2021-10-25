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
 * @fileoverview Definitions for module "fs"
 */

var fs = {};

var events = require("events");

/**
 * @interface
 */
function Stats() {}

/**
 * @return {boolean}
 */
Stats.prototype.isFile = function() {};

/**
 * @return {boolean}
 */
Stats.prototype.isDirectory = function() {};

/**
 * @return {boolean}
 */
Stats.prototype.isBlockDevice = function() {};

/**
 * @return {boolean}
 */
Stats.prototype.isCharacterDevice = function() {};

/**
 * @return {boolean}
 */
Stats.prototype.isSymbolicLink = function() {};

/**
 * @return {boolean}
 */
Stats.prototype.isFIFO = function() {};

/**
 * @return {boolean}
 */
Stats.prototype.isSocket = function() {};

/**
 * @type {number}
 */
Stats.prototype.dev;

/**
 * @type {number}
 */
Stats.prototype.ino;

/**
 * @type {number}
 */
Stats.prototype.mode;

/**
 * @type {number}
 */
Stats.prototype.nlink;

/**
 * @type {number}
 */
Stats.prototype.uid;

/**
 * @type {number}
 */
Stats.prototype.gid;

/**
 * @type {number}
 */
Stats.prototype.rdev;

/**
 * @type {number}
 */
Stats.prototype.size;

/**
 * @type {number}
 */
Stats.prototype.blksize;

/**
 * @type {number}
 */
Stats.prototype.blocks;

/**
 * @type {Date}
 */
Stats.prototype.atime;

/**
 * @type {Date}
 */
Stats.prototype.mtime;

/**
 * @type {Date}
 */
Stats.prototype.ctime;

/**
 * @type {Date}
 */
Stats.prototype.birthtime;

/**
 * @interface
 * @extends {events.EventEmitter}
 */
function FSWatcher() {}

/**
 * @return {void}
 */
FSWatcher.prototype.close = function() {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
FSWatcher.prototype.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(string, (string|Buffer)): void)} listener
 * @return {*}
 */
FSWatcher.prototype.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(number, string): void)} listener
 * @return {*}
 */
FSWatcher.prototype.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
FSWatcher.prototype.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(string, (string|Buffer)): void)} listener
 * @return {*}
 */
FSWatcher.prototype.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(number, string): void)} listener
 * @return {*}
 */
FSWatcher.prototype.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
FSWatcher.prototype.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(string, (string|Buffer)): void)} listener
 * @return {*}
 */
FSWatcher.prototype.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(number, string): void)} listener
 * @return {*}
 */
FSWatcher.prototype.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
FSWatcher.prototype.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(string, (string|Buffer)): void)} listener
 * @return {*}
 */
FSWatcher.prototype.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(number, string): void)} listener
 * @return {*}
 */
FSWatcher.prototype.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
FSWatcher.prototype.prependOnceListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(string, (string|Buffer)): void)} listener
 * @return {*}
 */
FSWatcher.prototype.prependOnceListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(number, string): void)} listener
 * @return {*}
 */
FSWatcher.prototype.prependOnceListener = function(event, listener) {};

/**
 * @interface
 * @extends {internal.Readable}
 */
fs.ReadStream = function() {};

/**
 * @return {void}
 */
fs.ReadStream.prototype.close = function() {};

/**
 * @return {void}
 */
fs.ReadStream.prototype.destroy = function() {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
fs.ReadStream.prototype.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(number): void)} listener
 * @return {*}
 */
fs.ReadStream.prototype.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(): void)} listener
 * @return {*}
 */
fs.ReadStream.prototype.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
fs.ReadStream.prototype.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(number): void)} listener
 * @return {*}
 */
fs.ReadStream.prototype.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(): void)} listener
 * @return {*}
 */
fs.ReadStream.prototype.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
fs.ReadStream.prototype.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(number): void)} listener
 * @return {*}
 */
fs.ReadStream.prototype.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(): void)} listener
 * @return {*}
 */
fs.ReadStream.prototype.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
fs.ReadStream.prototype.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(number): void)} listener
 * @return {*}
 */
fs.ReadStream.prototype.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(): void)} listener
 * @return {*}
 */
fs.ReadStream.prototype.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
fs.ReadStream.prototype.prependOnceListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(number): void)} listener
 * @return {*}
 */
fs.ReadStream.prototype.prependOnceListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(): void)} listener
 * @return {*}
 */
fs.ReadStream.prototype.prependOnceListener = function(event, listener) {};

/**
 * @interface
 * @extends {internal.Writable}
 */
fs.WriteStream = function() {};

/**
 * @return {void}
 */
fs.WriteStream.prototype.close = function() {};

/**
 * @type {number}
 */
fs.WriteStream.prototype.bytesWritten;

/**
 * @type {(string|Buffer)}
 */
fs.WriteStream.prototype.path;

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
fs.WriteStream.prototype.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(number): void)} listener
 * @return {*}
 */
fs.WriteStream.prototype.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(): void)} listener
 * @return {*}
 */
fs.WriteStream.prototype.addListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
fs.WriteStream.prototype.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(number): void)} listener
 * @return {*}
 */
fs.WriteStream.prototype.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(): void)} listener
 * @return {*}
 */
fs.WriteStream.prototype.on = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
fs.WriteStream.prototype.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(number): void)} listener
 * @return {*}
 */
fs.WriteStream.prototype.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(): void)} listener
 * @return {*}
 */
fs.WriteStream.prototype.once = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
fs.WriteStream.prototype.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(number): void)} listener
 * @return {*}
 */
fs.WriteStream.prototype.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(): void)} listener
 * @return {*}
 */
fs.WriteStream.prototype.prependListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {Function} listener
 * @return {*}
 */
fs.WriteStream.prototype.prependOnceListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(number): void)} listener
 * @return {*}
 */
fs.WriteStream.prototype.prependOnceListener = function(event, listener) {};

/**
 * @param {string} event
 * @param {(function(): void)} listener
 * @return {*}
 */
fs.WriteStream.prototype.prependOnceListener = function(event, listener) {};

/**
 * @param {string} oldPath
 * @param {string} newPath
 * @param {(function(NodeJS.ErrnoException=): void)=} callback
 * @return {void}
 */
fs.rename = function(oldPath, newPath, callback) {};

/**
 * @param {string} oldPath
 * @param {string} newPath
 * @return {void}
 */
fs.renameSync = function(oldPath, newPath) {};

/**
 * @param {(string|Buffer)} path
 * @param {(function(NodeJS.ErrnoException=): void)=} callback
 * @return {void}
 */
fs.truncate = function(path, callback) {};

/**
 * @param {(string|Buffer)} path
 * @param {number} len
 * @param {(function(NodeJS.ErrnoException=): void)=} callback
 * @return {void}
 */
fs.truncate = function(path, len, callback) {};

/**
 * @param {(string|Buffer)} path
 * @param {number=} len
 * @return {void}
 */
fs.truncateSync = function(path, len) {};

/**
 * @param {number} fd
 * @param {(function(NodeJS.ErrnoException=): void)=} callback
 * @return {void}
 */
fs.ftruncate = function(fd, callback) {};

/**
 * @param {number} fd
 * @param {number} len
 * @param {(function(NodeJS.ErrnoException=): void)=} callback
 * @return {void}
 */
fs.ftruncate = function(fd, len, callback) {};

/**
 * @param {number} fd
 * @param {number=} len
 * @return {void}
 */
fs.ftruncateSync = function(fd, len) {};

/**
 * @param {(string|Buffer)} path
 * @param {number} uid
 * @param {number} gid
 * @param {(function(NodeJS.ErrnoException=): void)=} callback
 * @return {void}
 */
fs.chown = function(path, uid, gid, callback) {};

/**
 * @param {(string|Buffer)} path
 * @param {number} uid
 * @param {number} gid
 * @return {void}
 */
fs.chownSync = function(path, uid, gid) {};

/**
 * @param {number} fd
 * @param {number} uid
 * @param {number} gid
 * @param {(function(NodeJS.ErrnoException=): void)=} callback
 * @return {void}
 */
fs.fchown = function(fd, uid, gid, callback) {};

/**
 * @param {number} fd
 * @param {number} uid
 * @param {number} gid
 * @return {void}
 */
fs.fchownSync = function(fd, uid, gid) {};

/**
 * @param {(string|Buffer)} path
 * @param {number} uid
 * @param {number} gid
 * @param {(function(NodeJS.ErrnoException=): void)=} callback
 * @return {void}
 */
fs.lchown = function(path, uid, gid, callback) {};

/**
 * @param {(string|Buffer)} path
 * @param {number} uid
 * @param {number} gid
 * @return {void}
 */
fs.lchownSync = function(path, uid, gid) {};

/**
 * @param {(string|Buffer)} path
 * @param {number} mode
 * @param {(function(NodeJS.ErrnoException=): void)=} callback
 * @return {void}
 */
fs.chmod = function(path, mode, callback) {};

/**
 * @param {(string|Buffer)} path
 * @param {string} mode
 * @param {(function(NodeJS.ErrnoException=): void)=} callback
 * @return {void}
 */
fs.chmod = function(path, mode, callback) {};

/**
 * @param {(string|Buffer)} path
 * @param {number} mode
 * @return {void}
 */
fs.chmodSync = function(path, mode) {};

/**
 * @param {(string|Buffer)} path
 * @param {string} mode
 * @return {void}
 */
fs.chmodSync = function(path, mode) {};

/**
 * @param {number} fd
 * @param {number} mode
 * @param {(function(NodeJS.ErrnoException=): void)=} callback
 * @return {void}
 */
fs.fchmod = function(fd, mode, callback) {};

/**
 * @param {number} fd
 * @param {string} mode
 * @param {(function(NodeJS.ErrnoException=): void)=} callback
 * @return {void}
 */
fs.fchmod = function(fd, mode, callback) {};

/**
 * @param {number} fd
 * @param {number} mode
 * @return {void}
 */
fs.fchmodSync = function(fd, mode) {};

/**
 * @param {number} fd
 * @param {string} mode
 * @return {void}
 */
fs.fchmodSync = function(fd, mode) {};

/**
 * @param {(string|Buffer)} path
 * @param {number} mode
 * @param {(function(NodeJS.ErrnoException=): void)=} callback
 * @return {void}
 */
fs.lchmod = function(path, mode, callback) {};

/**
 * @param {(string|Buffer)} path
 * @param {string} mode
 * @param {(function(NodeJS.ErrnoException=): void)=} callback
 * @return {void}
 */
fs.lchmod = function(path, mode, callback) {};

/**
 * @param {(string|Buffer)} path
 * @param {number} mode
 * @return {void}
 */
fs.lchmodSync = function(path, mode) {};

/**
 * @param {(string|Buffer)} path
 * @param {string} mode
 * @return {void}
 */
fs.lchmodSync = function(path, mode) {};

/**
 * @param {(string|Buffer)} path
 * @param {(function(NodeJS.ErrnoException, fs.Stats): *)=} callback
 * @return {void}
 */
fs.stat = function(path, callback) {};

/**
 * @param {(string|Buffer)} path
 * @param {(function(NodeJS.ErrnoException, fs.Stats): *)=} callback
 * @return {void}
 */
fs.lstat = function(path, callback) {};

/**
 * @param {number} fd
 * @param {(function(NodeJS.ErrnoException, fs.Stats): *)=} callback
 * @return {void}
 */
fs.fstat = function(fd, callback) {};

/**
 * @param {(string|Buffer)} path
 * @return {fs.Stats}
 */
fs.statSync = function(path) {};

/**
 * @param {(string|Buffer)} path
 * @return {fs.Stats}
 */
fs.lstatSync = function(path) {};

/**
 * @param {number} fd
 * @return {fs.Stats}
 */
fs.fstatSync = function(fd) {};

/**
 * @param {(string|Buffer)} srcpath
 * @param {(string|Buffer)} dstpath
 * @param {(function(NodeJS.ErrnoException=): void)=} callback
 * @return {void}
 */
fs.link = function(srcpath, dstpath, callback) {};

/**
 * @param {(string|Buffer)} srcpath
 * @param {(string|Buffer)} dstpath
 * @return {void}
 */
fs.linkSync = function(srcpath, dstpath) {};

/**
 * @param {(string|Buffer)} srcpath
 * @param {(string|Buffer)} dstpath
 * @param {string=} type
 * @param {(function(NodeJS.ErrnoException=): void)=} callback
 * @return {void}
 */
fs.symlink = function(srcpath, dstpath, type, callback) {};

/**
 * @param {(string|Buffer)} srcpath
 * @param {(string|Buffer)} dstpath
 * @param {string=} type
 * @return {void}
 */
fs.symlinkSync = function(srcpath, dstpath, type) {};

/**
 * @param {(string|Buffer)} path
 * @param {(function(NodeJS.ErrnoException, string): *)=} callback
 * @return {void}
 */
fs.readlink = function(path, callback) {};

/**
 * @param {(string|Buffer)} path
 * @return {string}
 */
fs.readlinkSync = function(path) {};

/**
 * @param {(string|Buffer)} path
 * @param {(function(NodeJS.ErrnoException, string): *)=} callback
 * @return {void}
 */
fs.realpath = function(path, callback) {};

/**
 * @param {(string|Buffer)} path
 * @param {Object<string,string>} cache
 * @param {(function(NodeJS.ErrnoException, string): *)} callback
 * @return {void}
 */
fs.realpath = function(path, cache, callback) {};

/**
 * @param {(string|Buffer)} path
 * @param {Object<string,string>=} cache
 * @return {string}
 */
fs.realpathSync = function(path, cache) {};

/**
 * @param {(string|Buffer)} path
 * @param {(function(NodeJS.ErrnoException=): void)=} callback
 * @return {void}
 */
fs.unlink = function(path, callback) {};

/**
 * @param {(string|Buffer)} path
 * @return {void}
 */
fs.unlinkSync = function(path) {};

/**
 * @param {(string|Buffer)} path
 * @param {(function(NodeJS.ErrnoException=): void)=} callback
 * @return {void}
 */
fs.rmdir = function(path, callback) {};

/**
 * @param {(string|Buffer)} path
 * @return {void}
 */
fs.rmdirSync = function(path) {};

/**
 * @param {(string|Buffer)} path
 * @param {(function(NodeJS.ErrnoException=): void)=} callback
 * @return {void}
 */
fs.mkdir = function(path, callback) {};

/**
 * @param {(string|Buffer)} path
 * @param {number} mode
 * @param {(function(NodeJS.ErrnoException=): void)=} callback
 * @return {void}
 */
fs.mkdir = function(path, mode, callback) {};

/**
 * @param {(string|Buffer)} path
 * @param {string} mode
 * @param {(function(NodeJS.ErrnoException=): void)=} callback
 * @return {void}
 */
fs.mkdir = function(path, mode, callback) {};

/**
 * @param {(string|Buffer)} path
 * @param {number=} mode
 * @return {void}
 */
fs.mkdirSync = function(path, mode) {};

/**
 * @param {(string|Buffer)} path
 * @param {string=} mode
 * @return {void}
 */
fs.mkdirSync = function(path, mode) {};

/**
 * @param {string} prefix
 * @param {(function(NodeJS.ErrnoException, string): void)=} callback
 * @return {void}
 */
fs.mkdtemp = function(prefix, callback) {};

/**
 * @param {string} prefix
 * @return {string}
 */
fs.mkdtempSync = function(prefix) {};

/**
 * @param {(string|Buffer)} path
 * @param {(function(NodeJS.ErrnoException, Array<string>): void)=} callback
 * @return {void}
 */
fs.readdir = function(path, callback) {};

/**
 * @param {(string|Buffer)} path
 * @return {Array<string>}
 */
fs.readdirSync = function(path) {};

/**
 * @param {number} fd
 * @param {(function(NodeJS.ErrnoException=): void)=} callback
 * @return {void}
 */
fs.close = function(fd, callback) {};

/**
 * @param {number} fd
 * @return {void}
 */
fs.closeSync = function(fd) {};

/**
 * @param {(string|Buffer)} path
 * @param {(string|number)} flags
 * @param {(function(NodeJS.ErrnoException, number): void)} callback
 * @return {void}
 */
fs.open = function(path, flags, callback) {};

/**
 * @param {(string|Buffer)} path
 * @param {(string|number)} flags
 * @param {number} mode
 * @param {(function(NodeJS.ErrnoException, number): void)} callback
 * @return {void}
 */
fs.open = function(path, flags, mode, callback) {};

/**
 * @param {(string|Buffer)} path
 * @param {(string|number)} flags
 * @param {number=} mode
 * @return {number}
 */
fs.openSync = function(path, flags, mode) {};

/**
 * @param {(string|Buffer)} path
 * @param {number} atime
 * @param {number} mtime
 * @param {(function(NodeJS.ErrnoException=): void)=} callback
 * @return {void}
 */
fs.utimes = function(path, atime, mtime, callback) {};

/**
 * @param {(string|Buffer)} path
 * @param {Date} atime
 * @param {Date} mtime
 * @param {(function(NodeJS.ErrnoException=): void)=} callback
 * @return {void}
 */
fs.utimes = function(path, atime, mtime, callback) {};

/**
 * @param {(string|Buffer)} path
 * @param {number} atime
 * @param {number} mtime
 * @return {void}
 */
fs.utimesSync = function(path, atime, mtime) {};

/**
 * @param {(string|Buffer)} path
 * @param {Date} atime
 * @param {Date} mtime
 * @return {void}
 */
fs.utimesSync = function(path, atime, mtime) {};

/**
 * @param {number} fd
 * @param {number} atime
 * @param {number} mtime
 * @param {(function(NodeJS.ErrnoException=): void)=} callback
 * @return {void}
 */
fs.futimes = function(fd, atime, mtime, callback) {};

/**
 * @param {number} fd
 * @param {Date} atime
 * @param {Date} mtime
 * @param {(function(NodeJS.ErrnoException=): void)=} callback
 * @return {void}
 */
fs.futimes = function(fd, atime, mtime, callback) {};

/**
 * @param {number} fd
 * @param {number} atime
 * @param {number} mtime
 * @return {void}
 */
fs.futimesSync = function(fd, atime, mtime) {};

/**
 * @param {number} fd
 * @param {Date} atime
 * @param {Date} mtime
 * @return {void}
 */
fs.futimesSync = function(fd, atime, mtime) {};

/**
 * @param {number} fd
 * @param {(function(NodeJS.ErrnoException=): void)=} callback
 * @return {void}
 */
fs.fsync = function(fd, callback) {};

/**
 * @param {number} fd
 * @return {void}
 */
fs.fsyncSync = function(fd) {};

/**
 * @param {number} fd
 * @param {Buffer} buffer
 * @param {number} offset
 * @param {number} length
 * @param {number} position
 * @param {(function(NodeJS.ErrnoException, number, Buffer): void)=} callback
 * @return {void}
 */
fs.write = function(fd, buffer, offset, length, position, callback) {};

/**
 * @param {number} fd
 * @param {Buffer} buffer
 * @param {number} offset
 * @param {number} length
 * @param {(function(NodeJS.ErrnoException, number, Buffer): void)=} callback
 * @return {void}
 */
fs.write = function(fd, buffer, offset, length, callback) {};

/**
 * @param {number} fd
 * @param {*} data
 * @param {(function(NodeJS.ErrnoException, number, string): void)=} callback
 * @return {void}
 */
fs.write = function(fd, data, callback) {};

/**
 * @param {number} fd
 * @param {*} data
 * @param {number} offset
 * @param {(function(NodeJS.ErrnoException, number, string): void)=} callback
 * @return {void}
 */
fs.write = function(fd, data, offset, callback) {};

/**
 * @param {number} fd
 * @param {*} data
 * @param {number} offset
 * @param {string} encoding
 * @param {(function(NodeJS.ErrnoException, number, string): void)=} callback
 * @return {void}
 */
fs.write = function(fd, data, offset, encoding, callback) {};

/**
 * @param {number} fd
 * @param {Buffer} buffer
 * @param {number} offset
 * @param {number} length
 * @param {number=} position
 * @return {number}
 */
fs.writeSync = function(fd, buffer, offset, length, position) {};

/**
 * @param {number} fd
 * @param {*} data
 * @param {number=} position
 * @param {string=} enconding
 * @return {number}
 */
fs.writeSync = function(fd, data, position, enconding) {};

/**
 * @param {number} fd
 * @param {Buffer} buffer
 * @param {number} offset
 * @param {number} length
 * @param {number} position
 * @param {(function(NodeJS.ErrnoException, number, Buffer): void)=} callback
 * @return {void}
 */
fs.read = function(fd, buffer, offset, length, position, callback) {};

/**
 * @param {number} fd
 * @param {Buffer} buffer
 * @param {number} offset
 * @param {number} length
 * @param {number} position
 * @return {number}
 */
fs.readSync = function(fd, buffer, offset, length, position) {};

/**
 * @param {string} filename
 * @param {string} encoding
 * @param {(function(NodeJS.ErrnoException, string): void)} callback
 * @return {void}
 */
fs.readFile = function(filename, encoding, callback) {};

/**
 * @param {string} filename
 * @param {{encoding: string, flag: string}} options
 * @param {(function(NodeJS.ErrnoException, string): void)} callback
 * @return {void}
 */
fs.readFile = function(filename, options, callback) {};

/**
 * @param {string} filename
 * @param {{flag: string}} options
 * @param {(function(NodeJS.ErrnoException, Buffer): void)} callback
 * @return {void}
 */
fs.readFile = function(filename, options, callback) {};

/**
 * @param {string} filename
 * @param {(function(NodeJS.ErrnoException, Buffer): void)} callback
 * @return {void}
 */
fs.readFile = function(filename, callback) {};

/**
 * @param {string} filename
 * @param {string} encoding
 * @return {string}
 */
fs.readFileSync = function(filename, encoding) {};

/**
 * @param {string} filename
 * @param {{encoding: string, flag: string}} options
 * @return {string}
 */
fs.readFileSync = function(filename, options) {};

/**
 * @param {string} filename
 * @param {{flag: string}=} options
 * @return {Buffer}
 */
fs.readFileSync = function(filename, options) {};

/**
 * @param {string} filename
 * @param {*} data
 * @param {(function(NodeJS.ErrnoException): void)=} callback
 * @return {void}
 */
fs.writeFile = function(filename, data, callback) {};

/**
 * @param {string} filename
 * @param {*} data
 * @param {{encoding: string, mode: number, flag: string}} options
 * @param {(function(NodeJS.ErrnoException): void)=} callback
 * @return {void}
 */
fs.writeFile = function(filename, data, options, callback) {};

/**
 * @param {string} filename
 * @param {*} data
 * @param {{encoding: string, mode: string, flag: string}} options
 * @param {(function(NodeJS.ErrnoException): void)=} callback
 * @return {void}
 */
fs.writeFile = function(filename, data, options, callback) {};

/**
 * @param {string} filename
 * @param {*} data
 * @param {{encoding: string, mode: number, flag: string}=} options
 * @return {void}
 */
fs.writeFileSync = function(filename, data, options) {};

/**
 * @param {string} filename
 * @param {*} data
 * @param {{encoding: string, mode: string, flag: string}=} options
 * @return {void}
 */
fs.writeFileSync = function(filename, data, options) {};

/**
 * @param {string} filename
 * @param {*} data
 * @param {{encoding: string, mode: number, flag: string}} options
 * @param {(function(NodeJS.ErrnoException): void)=} callback
 * @return {void}
 */
fs.appendFile = function(filename, data, options, callback) {};

/**
 * @param {string} filename
 * @param {*} data
 * @param {{encoding: string, mode: string, flag: string}} options
 * @param {(function(NodeJS.ErrnoException): void)=} callback
 * @return {void}
 */
fs.appendFile = function(filename, data, options, callback) {};

/**
 * @param {string} filename
 * @param {*} data
 * @param {(function(NodeJS.ErrnoException): void)=} callback
 * @return {void}
 */
fs.appendFile = function(filename, data, callback) {};

/**
 * @param {string} filename
 * @param {*} data
 * @param {{encoding: string, mode: number, flag: string}=} options
 * @return {void}
 */
fs.appendFileSync = function(filename, data, options) {};

/**
 * @param {string} filename
 * @param {*} data
 * @param {{encoding: string, mode: string, flag: string}=} options
 * @return {void}
 */
fs.appendFileSync = function(filename, data, options) {};

/**
 * @param {string} filename
 * @param {(function(fs.Stats, fs.Stats): void)} listener
 * @return {void}
 */
fs.watchFile = function(filename, listener) {};

/**
 * @param {string} filename
 * @param {{persistent: boolean, interval: number}} options
 * @param {(function(fs.Stats, fs.Stats): void)} listener
 * @return {void}
 */
fs.watchFile = function(filename, options, listener) {};

/**
 * @param {string} filename
 * @param {(function(fs.Stats, fs.Stats): void)=} listener
 * @return {void}
 */
fs.unwatchFile = function(filename, listener) {};

/**
 * @param {string} filename
 * @param {(function(string, string): *)=} listener
 * @return {fs.FSWatcher}
 */
fs.watch = function(filename, listener) {};

/**
 * @param {string} filename
 * @param {string} encoding
 * @param {(function(string, (string|Buffer)): *)=} listener
 * @return {fs.FSWatcher}
 */
fs.watch = function(filename, encoding, listener) {};

/**
 * @param {string} filename
 * @param {{persistent: boolean, recursive: boolean, encoding: string}} options
 * @param {(function(string, (string|Buffer)): *)=} listener
 * @return {fs.FSWatcher}
 */
fs.watch = function(filename, options, listener) {};

/**
 * @param {(string|Buffer)} path
 * @param {(function(boolean): void)=} callback
 * @return {void}
 */
fs.exists = function(path, callback) {};

/**
 * @param {(string|Buffer)} path
 * @return {boolean}
 */
fs.existsSync = function(path) {};

/**
 * @interface
 */
function Constants() {}

/**
 * @type {number}
 */
Constants.prototype.F_OK;

/**
 * @type {number}
 */
Constants.prototype.R_OK;

/**
 * @type {number}
 */
Constants.prototype.W_OK;

/**
 * @type {number}
 */
Constants.prototype.X_OK;

/**
 * @type {fs.Constants}
 */
fs.constants;

/**
 * @param {(string|Buffer)} path
 * @param {(function(NodeJS.ErrnoException): void)} callback
 * @return {void}
 */
fs.access = function(path, callback) {};

/**
 * @param {(string|Buffer)} path
 * @param {number} mode
 * @param {(function(NodeJS.ErrnoException): void)} callback
 * @return {void}
 */
fs.access = function(path, mode, callback) {};

/**
 * @param {(string|Buffer)} path
 * @param {number=} mode
 * @return {void}
 */
fs.accessSync = function(path, mode) {};

/**
 * @param {(string|Buffer)} path
 * @param {{flags: string, encoding: string, fd: number, mode: number, autoClose: boolean, start: number, end: number}=} options
 * @return {fs.ReadStream}
 */
fs.createReadStream = function(path, options) {};

/**
 * @param {(string|Buffer)} path
 * @param {{flags: string, encoding: string, fd: number, mode: number}=} options
 * @return {fs.WriteStream}
 */
fs.createWriteStream = function(path, options) {};

/**
 * @param {number} fd
 * @param {Function} callback
 * @return {void}
 */
fs.fdatasync = function(fd, callback) {};

/**
 * @param {number} fd
 * @return {void}
 */
fs.fdatasyncSync = function(fd) {};

module.exports.ReadStream = fs.ReadStream;

module.exports.WriteStream = fs.WriteStream;

module.exports.rename = fs.rename;

module.exports.renameSync = fs.renameSync;

module.exports.truncate = fs.truncate;

module.exports.truncate = fs.truncate;

module.exports.truncateSync = fs.truncateSync;

module.exports.ftruncate = fs.ftruncate;

module.exports.ftruncate = fs.ftruncate;

module.exports.ftruncateSync = fs.ftruncateSync;

module.exports.chown = fs.chown;

module.exports.chownSync = fs.chownSync;

module.exports.fchown = fs.fchown;

module.exports.fchownSync = fs.fchownSync;

module.exports.lchown = fs.lchown;

module.exports.lchownSync = fs.lchownSync;

module.exports.chmod = fs.chmod;

module.exports.chmod = fs.chmod;

module.exports.chmodSync = fs.chmodSync;

module.exports.chmodSync = fs.chmodSync;

module.exports.fchmod = fs.fchmod;

module.exports.fchmod = fs.fchmod;

module.exports.fchmodSync = fs.fchmodSync;

module.exports.fchmodSync = fs.fchmodSync;

module.exports.lchmod = fs.lchmod;

module.exports.lchmod = fs.lchmod;

module.exports.lchmodSync = fs.lchmodSync;

module.exports.lchmodSync = fs.lchmodSync;

module.exports.stat = fs.stat;

module.exports.lstat = fs.lstat;

module.exports.fstat = fs.fstat;

module.exports.statSync = fs.statSync;

module.exports.lstatSync = fs.lstatSync;

module.exports.fstatSync = fs.fstatSync;

module.exports.link = fs.link;

module.exports.linkSync = fs.linkSync;

module.exports.symlink = fs.symlink;

module.exports.symlinkSync = fs.symlinkSync;

module.exports.readlink = fs.readlink;

module.exports.readlinkSync = fs.readlinkSync;

module.exports.realpath = fs.realpath;

module.exports.realpath = fs.realpath;

module.exports.realpathSync = fs.realpathSync;

module.exports.unlink = fs.unlink;

module.exports.unlinkSync = fs.unlinkSync;

module.exports.rmdir = fs.rmdir;

module.exports.rmdirSync = fs.rmdirSync;

module.exports.mkdir = fs.mkdir;

module.exports.mkdir = fs.mkdir;

module.exports.mkdir = fs.mkdir;

module.exports.mkdirSync = fs.mkdirSync;

module.exports.mkdirSync = fs.mkdirSync;

module.exports.mkdtemp = fs.mkdtemp;

module.exports.mkdtempSync = fs.mkdtempSync;

module.exports.readdir = fs.readdir;

module.exports.readdirSync = fs.readdirSync;

module.exports.close = fs.close;

module.exports.closeSync = fs.closeSync;

module.exports.open = fs.open;

module.exports.open = fs.open;

module.exports.openSync = fs.openSync;

module.exports.utimes = fs.utimes;

module.exports.utimes = fs.utimes;

module.exports.utimesSync = fs.utimesSync;

module.exports.utimesSync = fs.utimesSync;

module.exports.futimes = fs.futimes;

module.exports.futimes = fs.futimes;

module.exports.futimesSync = fs.futimesSync;

module.exports.futimesSync = fs.futimesSync;

module.exports.fsync = fs.fsync;

module.exports.fsyncSync = fs.fsyncSync;

module.exports.write = fs.write;

module.exports.write = fs.write;

module.exports.write = fs.write;

module.exports.write = fs.write;

module.exports.write = fs.write;

module.exports.writeSync = fs.writeSync;

module.exports.writeSync = fs.writeSync;

module.exports.read = fs.read;

module.exports.readSync = fs.readSync;

module.exports.readFile = fs.readFile;

module.exports.readFile = fs.readFile;

module.exports.readFile = fs.readFile;

module.exports.readFile = fs.readFile;

module.exports.readFileSync = fs.readFileSync;

module.exports.readFileSync = fs.readFileSync;

module.exports.readFileSync = fs.readFileSync;

module.exports.writeFile = fs.writeFile;

module.exports.writeFile = fs.writeFile;

module.exports.writeFile = fs.writeFile;

module.exports.writeFileSync = fs.writeFileSync;

module.exports.writeFileSync = fs.writeFileSync;

module.exports.appendFile = fs.appendFile;

module.exports.appendFile = fs.appendFile;

module.exports.appendFile = fs.appendFile;

module.exports.appendFileSync = fs.appendFileSync;

module.exports.appendFileSync = fs.appendFileSync;

module.exports.watchFile = fs.watchFile;

module.exports.watchFile = fs.watchFile;

module.exports.unwatchFile = fs.unwatchFile;

module.exports.watch = fs.watch;

module.exports.watch = fs.watch;

module.exports.watch = fs.watch;

module.exports.exists = fs.exists;

module.exports.existsSync = fs.existsSync;

module.exports.constants = fs.constants;

module.exports.access = fs.access;

module.exports.access = fs.access;

module.exports.accessSync = fs.accessSync;

module.exports.createReadStream = fs.createReadStream;

module.exports.createWriteStream = fs.createWriteStream;

module.exports.fdatasync = fs.fdatasync;

module.exports.fdatasyncSync = fs.fdatasyncSync;

/**
 * @param {string} path
 * @param {(number|Date)} atime
 * @param {(number|Date)} mtime
 * @param {number=} flags
 * @param {Function=} callback
 * @return {void}
 */
fs.utimensat = function(path, atime, mtime, flags, callback) {};

/**
 * @param {string} path
 * @param {(number|Date)} atime
 * @param {(number|Date)} mtime
 * @param {number=} flags
 * @return {void}
 */
fs.utimensatSync = function(path, atime, mtime, flags) {};

/**
 * @param {*} fd
 * @param {(number|Date)} atime
 * @param {(number|Date)} mtime
 * @param {number=} flags
 * @param {Function=} callback
 * @return {void}
 */
fs.futimensat = function(fd, atime, mtime, flags, callback) {};

/**
 * @param {*} fd
 * @param {(number|Date)} atime
 * @param {(number|Date)} mtime
 * @param {number=} flags
 * @return {void}
 */
fs.futimensatSync = function(fd, atime, mtime, flags) {};

/**
 * @constructor
 * @extends {internal.Writable}
 */
fs.SyncWriteStream;

/**
 * @type {number}
 */
fs.F_OK;

/**
 * @type {number}
 */
fs.R_OK;

/**
 * @type {number}
 */
fs.W_OK;

/**
 * @type {number}
 */
fs.X_OK;

module.exports.utimensat = fs.utimensat;

module.exports.utimensatSync = fs.utimensatSync;

module.exports.futimensat = fs.futimensat;

module.exports.futimensatSync = fs.futimensatSync;

module.exports.SyncWriteStream = fs.SyncWriteStream;

module.exports.F_OK = fs.F_OK;

module.exports.R_OK = fs.R_OK;

module.exports.W_OK = fs.W_OK;

module.exports.X_OK = fs.X_OK;

