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
 * @fileoverview Definitions for module "child_process"
 */

var child_process = {};

var events = require("events");

/**
 * @interface
 * @extends {events.EventEmitter}
 */
child_process.ChildProcess = function() {};

/**
 * @type {internal.Writable}
 */
child_process.ChildProcess.prototype.stdin;

/**
 * @type {internal.Readable}
 */
child_process.ChildProcess.prototype.stdout;

/**
 * @type {internal.Readable}
 */
child_process.ChildProcess.prototype.stderr;

/**
 * @type {Array<*>}
 */
child_process.ChildProcess.prototype.stdio;

/**
 * @type {number}
 */
child_process.ChildProcess.prototype.pid;

/**
 * @param {string=} signal
 * @return {void}
 */
child_process.ChildProcess.prototype.kill = function(signal) {};

/**
 * @param {*} message
 * @param {*=} sendHandle
 * @return {boolean}
 */
child_process.ChildProcess.prototype.send = function(message, sendHandle) {};

/**
 * @type {boolean}
 */
child_process.ChildProcess.prototype.connected;

/**
 * @return {void}
 */
child_process.ChildProcess.prototype.disconnect = function() {};

/**
 * @return {void}
 */
child_process.ChildProcess.prototype.unref = function() {};

/**
 * @return {void}
 */
child_process.ChildProcess.prototype.ref = function() {};

/**
 * @interface
 */
child_process.SpawnOptions = function() {};

/**
 * @type {string}
 */
child_process.SpawnOptions.prototype.cwd;

/**
 * @type {*}
 */
child_process.SpawnOptions.prototype.env;

/**
 * @type {*}
 */
child_process.SpawnOptions.prototype.stdio;

/**
 * @type {boolean}
 */
child_process.SpawnOptions.prototype.detached;

/**
 * @type {number}
 */
child_process.SpawnOptions.prototype.uid;

/**
 * @type {number}
 */
child_process.SpawnOptions.prototype.gid;

/**
 * @type {(boolean|string)}
 */
child_process.SpawnOptions.prototype.shell;

/**
 * @param {string} command
 * @param {Array<string>=} args
 * @param {child_process.SpawnOptions=} options
 * @return {child_process.ChildProcess}
 */
child_process.spawn = function(command, args, options) {};

/**
 * @interface
 */
child_process.ExecOptions = function() {};

/**
 * @type {string}
 */
child_process.ExecOptions.prototype.cwd;

/**
 * @type {*}
 */
child_process.ExecOptions.prototype.env;

/**
 * @type {string}
 */
child_process.ExecOptions.prototype.shell;

/**
 * @type {number}
 */
child_process.ExecOptions.prototype.timeout;

/**
 * @type {number}
 */
child_process.ExecOptions.prototype.maxBuffer;

/**
 * @type {string}
 */
child_process.ExecOptions.prototype.killSignal;

/**
 * @type {number}
 */
child_process.ExecOptions.prototype.uid;

/**
 * @type {number}
 */
child_process.ExecOptions.prototype.gid;

/**
 * @interface
 * @extends {child_process.ExecOptions}
 */
child_process.ExecOptionsWithStringEncoding = function() {};

/**
 * @type {(string)}
 */
child_process.ExecOptionsWithStringEncoding.prototype.encoding;

/**
 * @interface
 * @extends {child_process.ExecOptions}
 */
child_process.ExecOptionsWithBufferEncoding = function() {};

/**
 * @type {string}
 */
child_process.ExecOptionsWithBufferEncoding.prototype.encoding;

/**
 * @param {string} command
 * @param {(function(Error, string, string): void)=} callback
 * @return {child_process.ChildProcess}
 */
child_process.exec = function(command, callback) {};

/**
 * @param {string} command
 * @param {child_process.ExecOptionsWithStringEncoding} options
 * @param {(function(Error, string, string): void)=} callback
 * @return {child_process.ChildProcess}
 */
child_process.exec = function(command, options, callback) {};

/**
 * @param {string} command
 * @param {child_process.ExecOptionsWithBufferEncoding} options
 * @param {(function(Error, Buffer, Buffer): void)=} callback
 * @return {child_process.ChildProcess}
 */
child_process.exec = function(command, options, callback) {};

/**
 * @param {string} command
 * @param {child_process.ExecOptions} options
 * @param {(function(Error, string, string): void)=} callback
 * @return {child_process.ChildProcess}
 */
child_process.exec = function(command, options, callback) {};

/**
 * @interface
 */
child_process.ExecFileOptions = function() {};

/**
 * @type {string}
 */
child_process.ExecFileOptions.prototype.cwd;

/**
 * @type {*}
 */
child_process.ExecFileOptions.prototype.env;

/**
 * @type {number}
 */
child_process.ExecFileOptions.prototype.timeout;

/**
 * @type {number}
 */
child_process.ExecFileOptions.prototype.maxBuffer;

/**
 * @type {string}
 */
child_process.ExecFileOptions.prototype.killSignal;

/**
 * @type {number}
 */
child_process.ExecFileOptions.prototype.uid;

/**
 * @type {number}
 */
child_process.ExecFileOptions.prototype.gid;

/**
 * @interface
 * @extends {child_process.ExecFileOptions}
 */
child_process.ExecFileOptionsWithStringEncoding = function() {};

/**
 * @type {(string)}
 */
child_process.ExecFileOptionsWithStringEncoding.prototype.encoding;

/**
 * @interface
 * @extends {child_process.ExecFileOptions}
 */
child_process.ExecFileOptionsWithBufferEncoding = function() {};

/**
 * @type {string}
 */
child_process.ExecFileOptionsWithBufferEncoding.prototype.encoding;

/**
 * @param {string} file
 * @param {(function(Error, string, string): void)=} callback
 * @return {child_process.ChildProcess}
 */
child_process.execFile = function(file, callback) {};

/**
 * @param {string} file
 * @param {child_process.ExecFileOptionsWithStringEncoding=} options
 * @param {(function(Error, string, string): void)=} callback
 * @return {child_process.ChildProcess}
 */
child_process.execFile = function(file, options, callback) {};

/**
 * @param {string} file
 * @param {child_process.ExecFileOptionsWithBufferEncoding=} options
 * @param {(function(Error, Buffer, Buffer): void)=} callback
 * @return {child_process.ChildProcess}
 */
child_process.execFile = function(file, options, callback) {};

/**
 * @param {string} file
 * @param {child_process.ExecFileOptions=} options
 * @param {(function(Error, string, string): void)=} callback
 * @return {child_process.ChildProcess}
 */
child_process.execFile = function(file, options, callback) {};

/**
 * @param {string} file
 * @param {Array<string>=} args
 * @param {(function(Error, string, string): void)=} callback
 * @return {child_process.ChildProcess}
 */
child_process.execFile = function(file, args, callback) {};

/**
 * @param {string} file
 * @param {Array<string>=} args
 * @param {child_process.ExecFileOptionsWithStringEncoding=} options
 * @param {(function(Error, string, string): void)=} callback
 * @return {child_process.ChildProcess}
 */
child_process.execFile = function(file, args, options, callback) {};

/**
 * @param {string} file
 * @param {Array<string>=} args
 * @param {child_process.ExecFileOptionsWithBufferEncoding=} options
 * @param {(function(Error, Buffer, Buffer): void)=} callback
 * @return {child_process.ChildProcess}
 */
child_process.execFile = function(file, args, options, callback) {};

/**
 * @param {string} file
 * @param {Array<string>=} args
 * @param {child_process.ExecFileOptions=} options
 * @param {(function(Error, string, string): void)=} callback
 * @return {child_process.ChildProcess}
 */
child_process.execFile = function(file, args, options, callback) {};

/**
 * @interface
 */
child_process.ForkOptions = function() {};

/**
 * @type {string}
 */
child_process.ForkOptions.prototype.cwd;

/**
 * @type {*}
 */
child_process.ForkOptions.prototype.env;

/**
 * @type {string}
 */
child_process.ForkOptions.prototype.execPath;

/**
 * @type {Array<string>}
 */
child_process.ForkOptions.prototype.execArgv;

/**
 * @type {boolean}
 */
child_process.ForkOptions.prototype.silent;

/**
 * @type {number}
 */
child_process.ForkOptions.prototype.uid;

/**
 * @type {number}
 */
child_process.ForkOptions.prototype.gid;

/**
 * @param {string} modulePath
 * @param {Array<string>=} args
 * @param {child_process.ForkOptions=} options
 * @return {child_process.ChildProcess}
 */
child_process.fork = function(modulePath, args, options) {};

/**
 * @interface
 */
child_process.SpawnSyncOptions = function() {};

/**
 * @type {string}
 */
child_process.SpawnSyncOptions.prototype.cwd;

/**
 * @type {(string|Buffer)}
 */
child_process.SpawnSyncOptions.prototype.input;

/**
 * @type {*}
 */
child_process.SpawnSyncOptions.prototype.stdio;

/**
 * @type {*}
 */
child_process.SpawnSyncOptions.prototype.env;

/**
 * @type {number}
 */
child_process.SpawnSyncOptions.prototype.uid;

/**
 * @type {number}
 */
child_process.SpawnSyncOptions.prototype.gid;

/**
 * @type {number}
 */
child_process.SpawnSyncOptions.prototype.timeout;

/**
 * @type {string}
 */
child_process.SpawnSyncOptions.prototype.killSignal;

/**
 * @type {number}
 */
child_process.SpawnSyncOptions.prototype.maxBuffer;

/**
 * @type {string}
 */
child_process.SpawnSyncOptions.prototype.encoding;

/**
 * @type {(boolean|string)}
 */
child_process.SpawnSyncOptions.prototype.shell;

/**
 * @interface
 * @extends {child_process.SpawnSyncOptions}
 */
child_process.SpawnSyncOptionsWithStringEncoding = function() {};

/**
 * @type {(string)}
 */
child_process.SpawnSyncOptionsWithStringEncoding.prototype.encoding;

/**
 * @interface
 * @extends {child_process.SpawnSyncOptions}
 */
child_process.SpawnSyncOptionsWithBufferEncoding = function() {};

/**
 * @type {string}
 */
child_process.SpawnSyncOptionsWithBufferEncoding.prototype.encoding;

/**
 * @interface
 * @template T
 */
child_process.SpawnSyncReturns = function() {};

/**
 * @type {number}
 */
child_process.SpawnSyncReturns.prototype.pid;

/**
 * @type {Array<string>}
 */
child_process.SpawnSyncReturns.prototype.output;

/**
 * @type {T}
 */
child_process.SpawnSyncReturns.prototype.stdout;

/**
 * @type {T}
 */
child_process.SpawnSyncReturns.prototype.stderr;

/**
 * @type {number}
 */
child_process.SpawnSyncReturns.prototype.status;

/**
 * @type {string}
 */
child_process.SpawnSyncReturns.prototype.signal;

/**
 * @type {Error}
 */
child_process.SpawnSyncReturns.prototype.error;

/**
 * @param {string} command
 * @return {child_process.SpawnSyncReturns<Buffer>}
 */
child_process.spawnSync = function(command) {};

/**
 * @param {string} command
 * @param {child_process.SpawnSyncOptionsWithStringEncoding=} options
 * @return {child_process.SpawnSyncReturns<string>}
 */
child_process.spawnSync = function(command, options) {};

/**
 * @param {string} command
 * @param {child_process.SpawnSyncOptionsWithBufferEncoding=} options
 * @return {child_process.SpawnSyncReturns<Buffer>}
 */
child_process.spawnSync = function(command, options) {};

/**
 * @param {string} command
 * @param {child_process.SpawnSyncOptions=} options
 * @return {child_process.SpawnSyncReturns<Buffer>}
 */
child_process.spawnSync = function(command, options) {};

/**
 * @param {string} command
 * @param {Array<string>=} args
 * @param {child_process.SpawnSyncOptionsWithStringEncoding=} options
 * @return {child_process.SpawnSyncReturns<string>}
 */
child_process.spawnSync = function(command, args, options) {};

/**
 * @param {string} command
 * @param {Array<string>=} args
 * @param {child_process.SpawnSyncOptionsWithBufferEncoding=} options
 * @return {child_process.SpawnSyncReturns<Buffer>}
 */
child_process.spawnSync = function(command, args, options) {};

/**
 * @param {string} command
 * @param {Array<string>=} args
 * @param {child_process.SpawnSyncOptions=} options
 * @return {child_process.SpawnSyncReturns<Buffer>}
 */
child_process.spawnSync = function(command, args, options) {};

/**
 * @interface
 */
child_process.ExecSyncOptions = function() {};

/**
 * @type {string}
 */
child_process.ExecSyncOptions.prototype.cwd;

/**
 * @type {(string|Buffer)}
 */
child_process.ExecSyncOptions.prototype.input;

/**
 * @type {*}
 */
child_process.ExecSyncOptions.prototype.stdio;

/**
 * @type {*}
 */
child_process.ExecSyncOptions.prototype.env;

/**
 * @type {string}
 */
child_process.ExecSyncOptions.prototype.shell;

/**
 * @type {number}
 */
child_process.ExecSyncOptions.prototype.uid;

/**
 * @type {number}
 */
child_process.ExecSyncOptions.prototype.gid;

/**
 * @type {number}
 */
child_process.ExecSyncOptions.prototype.timeout;

/**
 * @type {string}
 */
child_process.ExecSyncOptions.prototype.killSignal;

/**
 * @type {number}
 */
child_process.ExecSyncOptions.prototype.maxBuffer;

/**
 * @type {string}
 */
child_process.ExecSyncOptions.prototype.encoding;

/**
 * @interface
 * @extends {child_process.ExecSyncOptions}
 */
child_process.ExecSyncOptionsWithStringEncoding = function() {};

/**
 * @type {(string)}
 */
child_process.ExecSyncOptionsWithStringEncoding.prototype.encoding;

/**
 * @interface
 * @extends {child_process.ExecSyncOptions}
 */
child_process.ExecSyncOptionsWithBufferEncoding = function() {};

/**
 * @type {string}
 */
child_process.ExecSyncOptionsWithBufferEncoding.prototype.encoding;

/**
 * @param {string} command
 * @return {Buffer}
 */
child_process.execSync = function(command) {};

/**
 * @param {string} command
 * @param {child_process.ExecSyncOptionsWithStringEncoding=} options
 * @return {string}
 */
child_process.execSync = function(command, options) {};

/**
 * @param {string} command
 * @param {child_process.ExecSyncOptionsWithBufferEncoding=} options
 * @return {Buffer}
 */
child_process.execSync = function(command, options) {};

/**
 * @param {string} command
 * @param {child_process.ExecSyncOptions=} options
 * @return {Buffer}
 */
child_process.execSync = function(command, options) {};

/**
 * @interface
 */
child_process.ExecFileSyncOptions = function() {};

/**
 * @type {string}
 */
child_process.ExecFileSyncOptions.prototype.cwd;

/**
 * @type {(string|Buffer)}
 */
child_process.ExecFileSyncOptions.prototype.input;

/**
 * @type {*}
 */
child_process.ExecFileSyncOptions.prototype.stdio;

/**
 * @type {*}
 */
child_process.ExecFileSyncOptions.prototype.env;

/**
 * @type {number}
 */
child_process.ExecFileSyncOptions.prototype.uid;

/**
 * @type {number}
 */
child_process.ExecFileSyncOptions.prototype.gid;

/**
 * @type {number}
 */
child_process.ExecFileSyncOptions.prototype.timeout;

/**
 * @type {string}
 */
child_process.ExecFileSyncOptions.prototype.killSignal;

/**
 * @type {number}
 */
child_process.ExecFileSyncOptions.prototype.maxBuffer;

/**
 * @type {string}
 */
child_process.ExecFileSyncOptions.prototype.encoding;

/**
 * @interface
 * @extends {child_process.ExecFileSyncOptions}
 */
child_process.ExecFileSyncOptionsWithStringEncoding = function() {};

/**
 * @type {(string)}
 */
child_process.ExecFileSyncOptionsWithStringEncoding.prototype.encoding;

/**
 * @interface
 * @extends {child_process.ExecFileSyncOptions}
 */
child_process.ExecFileSyncOptionsWithBufferEncoding = function() {};

/**
 * @type {string}
 */
child_process.ExecFileSyncOptionsWithBufferEncoding.prototype.encoding;

/**
 * @param {string} command
 * @return {Buffer}
 */
child_process.execFileSync = function(command) {};

/**
 * @param {string} command
 * @param {child_process.ExecFileSyncOptionsWithStringEncoding=} options
 * @return {string}
 */
child_process.execFileSync = function(command, options) {};

/**
 * @param {string} command
 * @param {child_process.ExecFileSyncOptionsWithBufferEncoding=} options
 * @return {Buffer}
 */
child_process.execFileSync = function(command, options) {};

/**
 * @param {string} command
 * @param {child_process.ExecFileSyncOptions=} options
 * @return {Buffer}
 */
child_process.execFileSync = function(command, options) {};

/**
 * @param {string} command
 * @param {Array<string>=} args
 * @param {child_process.ExecFileSyncOptionsWithStringEncoding=} options
 * @return {string}
 */
child_process.execFileSync = function(command, args, options) {};

/**
 * @param {string} command
 * @param {Array<string>=} args
 * @param {child_process.ExecFileSyncOptionsWithBufferEncoding=} options
 * @return {Buffer}
 */
child_process.execFileSync = function(command, args, options) {};

/**
 * @param {string} command
 * @param {Array<string>=} args
 * @param {child_process.ExecFileSyncOptions=} options
 * @return {Buffer}
 */
child_process.execFileSync = function(command, args, options) {};

module.exports.ChildProcess = child_process.ChildProcess;

module.exports.SpawnOptions = child_process.SpawnOptions;

module.exports.spawn = child_process.spawn;

module.exports.ExecOptions = child_process.ExecOptions;

module.exports.ExecOptionsWithStringEncoding = child_process.ExecOptionsWithStringEncoding;

module.exports.ExecOptionsWithBufferEncoding = child_process.ExecOptionsWithBufferEncoding;

module.exports.exec = child_process.exec;

module.exports.exec = child_process.exec;

module.exports.exec = child_process.exec;

module.exports.exec = child_process.exec;

module.exports.ExecFileOptions = child_process.ExecFileOptions;

module.exports.ExecFileOptionsWithStringEncoding = child_process.ExecFileOptionsWithStringEncoding;

module.exports.ExecFileOptionsWithBufferEncoding = child_process.ExecFileOptionsWithBufferEncoding;

module.exports.execFile = child_process.execFile;

module.exports.execFile = child_process.execFile;

module.exports.execFile = child_process.execFile;

module.exports.execFile = child_process.execFile;

module.exports.execFile = child_process.execFile;

module.exports.execFile = child_process.execFile;

module.exports.execFile = child_process.execFile;

module.exports.execFile = child_process.execFile;

module.exports.ForkOptions = child_process.ForkOptions;

module.exports.fork = child_process.fork;

module.exports.SpawnSyncOptions = child_process.SpawnSyncOptions;

module.exports.SpawnSyncOptionsWithStringEncoding = child_process.SpawnSyncOptionsWithStringEncoding;

module.exports.SpawnSyncOptionsWithBufferEncoding = child_process.SpawnSyncOptionsWithBufferEncoding;

module.exports.SpawnSyncReturns = child_process.SpawnSyncReturns;

module.exports.spawnSync = child_process.spawnSync;

module.exports.spawnSync = child_process.spawnSync;

module.exports.spawnSync = child_process.spawnSync;

module.exports.spawnSync = child_process.spawnSync;

module.exports.spawnSync = child_process.spawnSync;

module.exports.spawnSync = child_process.spawnSync;

module.exports.spawnSync = child_process.spawnSync;

module.exports.ExecSyncOptions = child_process.ExecSyncOptions;

module.exports.ExecSyncOptionsWithStringEncoding = child_process.ExecSyncOptionsWithStringEncoding;

module.exports.ExecSyncOptionsWithBufferEncoding = child_process.ExecSyncOptionsWithBufferEncoding;

module.exports.execSync = child_process.execSync;

module.exports.execSync = child_process.execSync;

module.exports.execSync = child_process.execSync;

module.exports.execSync = child_process.execSync;

module.exports.ExecFileSyncOptions = child_process.ExecFileSyncOptions;

module.exports.ExecFileSyncOptionsWithStringEncoding = child_process.ExecFileSyncOptionsWithStringEncoding;

module.exports.ExecFileSyncOptionsWithBufferEncoding = child_process.ExecFileSyncOptionsWithBufferEncoding;

module.exports.execFileSync = child_process.execFileSync;

module.exports.execFileSync = child_process.execFileSync;

module.exports.execFileSync = child_process.execFileSync;

module.exports.execFileSync = child_process.execFileSync;

module.exports.execFileSync = child_process.execFileSync;

module.exports.execFileSync = child_process.execFileSync;

module.exports.execFileSync = child_process.execFileSync;

