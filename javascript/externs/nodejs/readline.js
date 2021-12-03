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
 * @fileoverview Definitions for module "readline"
 */

var readline = {};

var events = require("events");

var stream = require("stream");

/**
 * @interface
 */
readline.Key = function() {};

/**
 * @type {string}
 */
readline.Key.prototype.sequence;

/**
 * @type {string}
 */
readline.Key.prototype.name;

/**
 * @type {boolean}
 */
readline.Key.prototype.ctrl;

/**
 * @type {boolean}
 */
readline.Key.prototype.meta;

/**
 * @type {boolean}
 */
readline.Key.prototype.shift;

/**
 * @interface
 * @extends {events.EventEmitter}
 */
readline.ReadLine = function() {};

/**
 * @param {string} prompt
 * @return {void}
 */
readline.ReadLine.prototype.setPrompt = function(prompt) {};

/**
 * @param {boolean=} preserveCursor
 * @return {void}
 */
readline.ReadLine.prototype.prompt = function(preserveCursor) {};

/**
 * @param {string} query
 * @param {(function(string): void)} callback
 * @return {void}
 */
readline.ReadLine.prototype.question = function(query, callback) {};

/**
 * @return {readline.ReadLine}
 */
readline.ReadLine.prototype.pause = function() {};

/**
 * @return {readline.ReadLine}
 */
readline.ReadLine.prototype.resume = function() {};

/**
 * @return {void}
 */
readline.ReadLine.prototype.close = function() {};

/**
 * @param {(string|Buffer)} data
 * @param {readline.Key=} key
 * @return {void}
 */
readline.ReadLine.prototype.write = function(data, key) {};

/**
 * @interface
 * @type {((function(string): readline.CompleterResult)|(function(string, (function(*, readline.CompleterResult): void)): *))}
 */
readline.Completer = function() {};

/**
 * @interface
 */
readline.CompleterResult = function() {};

/**
 * @type {Array<string>}
 */
readline.CompleterResult.prototype.completions;

/**
 * @type {string}
 */
readline.CompleterResult.prototype.line;

/**
 * @interface
 */
readline.ReadLineOptions = function() {};

/**
 * @type {NodeJS.ReadableStream}
 */
readline.ReadLineOptions.prototype.input;

/**
 * @type {NodeJS.WritableStream}
 */
readline.ReadLineOptions.prototype.output;

/**
 * @type {readline.Completer}
 */
readline.ReadLineOptions.prototype.completer;

/**
 * @type {boolean}
 */
readline.ReadLineOptions.prototype.terminal;

/**
 * @type {number}
 */
readline.ReadLineOptions.prototype.historySize;

/**
 * @param {NodeJS.ReadableStream} input
 * @param {NodeJS.WritableStream=} output
 * @param {readline.Completer=} completer
 * @param {boolean=} terminal
 * @return {readline.ReadLine}
 */
readline.createInterface = function(input, output, completer, terminal) {};

/**
 * @param {readline.ReadLineOptions} options
 * @return {readline.ReadLine}
 */
readline.createInterface = function(options) {};

/**
 * @param {NodeJS.WritableStream} stream
 * @param {number} x
 * @param {number} y
 * @return {void}
 */
readline.cursorTo = function(stream, x, y) {};

/**
 * @param {NodeJS.WritableStream} stream
 * @param {(number|string)} dx
 * @param {(number|string)} dy
 * @return {void}
 */
readline.moveCursor = function(stream, dx, dy) {};

/**
 * @param {NodeJS.WritableStream} stream
 * @param {number} dir
 * @return {void}
 */
readline.clearLine = function(stream, dir) {};

/**
 * @param {NodeJS.WritableStream} stream
 * @return {void}
 */
readline.clearScreenDown = function(stream) {};

module.exports.Key = readline.Key;

module.exports.ReadLine = readline.ReadLine;

module.exports.Completer = readline.Completer;

module.exports.CompleterResult = readline.CompleterResult;

module.exports.ReadLineOptions = readline.ReadLineOptions;

module.exports.createInterface = readline.createInterface;

module.exports.createInterface = readline.createInterface;

module.exports.cursorTo = readline.cursorTo;

module.exports.moveCursor = readline.moveCursor;

module.exports.clearLine = readline.clearLine;

module.exports.clearScreenDown = readline.clearScreenDown;

/**
 * @interface
 * @extends {readline.ReadLine}
 */
readline.Interface = function() {};

module.exports.Interface = readline.Interface;

