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
 * @fileoverview Definitions for module "repl"
 */

var repl = {};

var readline = require("readline");

/**
 * @interface
 */
repl.ReplOptions = function() {};

/**
 * @type {string}
 */
repl.ReplOptions.prototype.prompt;

/**
 * @type {NodeJS.ReadableStream}
 */
repl.ReplOptions.prototype.input;

/**
 * @type {NodeJS.WritableStream}
 */
repl.ReplOptions.prototype.output;

/**
 * @type {boolean}
 */
repl.ReplOptions.prototype.terminal;

/**
 * @type {Function}
 */
repl.ReplOptions.prototype.eval;

/**
 * @type {boolean}
 */
repl.ReplOptions.prototype.useColors;

/**
 * @type {boolean}
 */
repl.ReplOptions.prototype.useGlobal;

/**
 * @type {boolean}
 */
repl.ReplOptions.prototype.ignoreUndefined;

/**
 * @type {Function}
 */
repl.ReplOptions.prototype.writer;

/**
 * @type {Function}
 */
repl.ReplOptions.prototype.completer;

/**
 * @type {*}
 */
repl.ReplOptions.prototype.replMode;

/**
 * @type {*}
 */
repl.ReplOptions.prototype.breakEvalOnSigint;

/**
 * @interface
 * @extends {readline.ReadLine}
 */
repl.REPLServer = function() {};

/**
 * @param {string} keyword
 * @param {(Function|{help: string, action: Function})} cmd
 * @return {void}
 */
repl.REPLServer.prototype.defineCommand = function(keyword, cmd) {};

/**
 * @param {boolean=} preserveCursor
 * @return {void}
 */
repl.REPLServer.prototype.displayPrompt = function(preserveCursor) {};

/**
 * @param {repl.ReplOptions} options
 * @return {repl.REPLServer}
 */
repl.start = function(options) {};

module.exports.ReplOptions = repl.ReplOptions;

module.exports.REPLServer = repl.REPLServer;

module.exports.start = repl.start;

/**
 * @interface
 */
repl.REPLServer = function() {};

repl.REPLServer.prototype.context;


module.exports.REPLServer = repl.REPLServer;

