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
 * @fileoverview Definitions for module "vm"
 */

var vm = {};

/**
 * @interface
 */
vm.Context = function() {};

/**
 * @interface
 */
vm.ScriptOptions = function() {};

/**
 * @type {string}
 */
vm.ScriptOptions.prototype.filename;

/**
 * @type {number}
 */
vm.ScriptOptions.prototype.lineOffset;

/**
 * @type {number}
 */
vm.ScriptOptions.prototype.columnOffset;

/**
 * @type {boolean}
 */
vm.ScriptOptions.prototype.displayErrors;

/**
 * @type {number}
 */
vm.ScriptOptions.prototype.timeout;

/**
 * @type {Buffer}
 */
vm.ScriptOptions.prototype.cachedData;

/**
 * @type {boolean}
 */
vm.ScriptOptions.prototype.produceCachedData;

/**
 * @interface
 */
vm.RunningScriptOptions = function() {};

/**
 * @type {string}
 */
vm.RunningScriptOptions.prototype.filename;

/**
 * @type {number}
 */
vm.RunningScriptOptions.prototype.lineOffset;

/**
 * @type {number}
 */
vm.RunningScriptOptions.prototype.columnOffset;

/**
 * @type {boolean}
 */
vm.RunningScriptOptions.prototype.displayErrors;

/**
 * @type {number}
 */
vm.RunningScriptOptions.prototype.timeout;

/**
 * @param {string} code
 * @param {vm.ScriptOptions=} options
 * @return {vm.Script}
 * @constructor
 */
vm.Script = function(code, options) {};

/**
 * @param {vm.Context} contextifiedSandbox
 * @param {vm.RunningScriptOptions=} options
 * @return {*}
 */
vm.Script.prototype.runInContext = function(contextifiedSandbox, options) {};

/**
 * @param {vm.Context=} sandbox
 * @param {vm.RunningScriptOptions=} options
 * @return {*}
 */
vm.Script.prototype.runInNewContext = function(sandbox, options) {};

/**
 * @param {vm.RunningScriptOptions=} options
 * @return {*}
 */
vm.Script.prototype.runInThisContext = function(options) {};

/**
 * @param {vm.Context=} sandbox
 * @return {vm.Context}
 */
vm.createContext = function(sandbox) {};

/**
 * @param {vm.Context} sandbox
 * @return {boolean}
 */
vm.isContext = function(sandbox) {};

/**
 * @param {string} code
 * @param {vm.Context} contextifiedSandbox
 * @param {vm.RunningScriptOptions=} options
 * @return {*}
 */
vm.runInContext = function(code, contextifiedSandbox, options) {};

/**
 * @param {string} code
 * @return {*}
 */
vm.runInDebugContext = function(code) {};

/**
 * @param {string} code
 * @param {vm.Context=} sandbox
 * @param {vm.RunningScriptOptions=} options
 * @return {*}
 */
vm.runInNewContext = function(code, sandbox, options) {};

/**
 * @param {string} code
 * @param {vm.RunningScriptOptions=} options
 * @return {*}
 */
vm.runInThisContext = function(code, options) {};

module.exports.Context = vm.Context;

module.exports.ScriptOptions = vm.ScriptOptions;

module.exports.RunningScriptOptions = vm.RunningScriptOptions;

module.exports.Script = vm.Script;

module.exports.createContext = vm.createContext;

module.exports.isContext = vm.isContext;

module.exports.runInContext = vm.runInContext;

module.exports.runInDebugContext = vm.runInDebugContext;

module.exports.runInNewContext = vm.runInNewContext;

module.exports.runInThisContext = vm.runInThisContext;

/**
 * @param {string} code
 * @param {string=} filename
 * @return {vm.Script}
 */
vm.createScript = function(code, filename) {};

module.exports.createScript = vm.createScript;

