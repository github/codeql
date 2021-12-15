/**
 * @externs
 * Sources:
 *  * https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey/Introduction_to_the_JavaScript_shell
 *  * https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey/Shell_global_objects
 *  * http://mxr.mozilla.org/mozilla-central/source/js/src/shell/js.cpp 
 */

/**
 * @type {Object}
 */
var environment;

/**
 * @type {Array.<string>}
 */
var arguments;

/**
 * @type {Array.<string>}
 */
var scriptArgs;

/**
 * @constructor
 * @param {string=} name
 * @see https://developer.mozilla.org/en-US/docs/Archive/Mozilla/SpiderMonkey/File_object
 */
function File(name) {}

/**
 * @type {File}
 */
File.input;

/**
 * @type {File}
 */
File.output;

/**
 * @type {File}
 */
File.error;

/**
 * @type {File}
 */
File.currentDir;

/**
 * @type {string}
 */
File.separator;

/**
 * @type {number}
 */
File.prototype.number;

/**
 * @type {File}
 */
File.prototype.parent;

/**
 * @type {string}
 */
File.prototype.path;

/**
 * @type {string}
 */
File.prototype.name;

/**
 * @type {boolean}
 */
File.prototype.isDirectory;

/**
 * @type {boolean}
 */
File.prototype.isFile;

/**
 * @type {boolean}
 */
File.prototype.exists;

/**
 * @type {boolean}
 */
File.prototype.canRead;

/**
 * @type {boolean}
 */
File.prototype.canWrite;

/**
 * @type {boolean}
 */
File.prototype.canAppend;

/**
 * @type {boolean}
 */
File.prototype.canReplace;

/**
 * @type {boolean}
 */
File.prototype.isOpen;

/**
 * @type {string}
 */
File.prototype.type;

/**
 * @type {string}
 */
File.prototype.mode;

/**
 * @type {Date}
 */
File.prototype.creationTime;

/**
 * @type {Date}
 */
File.prototype.lastModified;

/**
 * @type {number}
 */
File.prototype.size;

/**
 * @type {boolean}
 */
File.prototype.hasRandomAccess;

/**
 * @type {boolean}
 */
File.prototype.hasAutoFlush;

/**
 * @type {number}
 */
File.prototype.position;

/**
 * @type {boolean}
 */
File.prototype.isNative;

/**
 * @param {string} mode
 * @param {string} type
 */
File.prototype.open = function(mode, type) {};

/**
 */
File.prototype.close = function() {};

/**
 */
File.prototype.remove = function() {};

/**
 * @param {string} destination
 */
File.prototype.copyTo = function(destination) {};

/**
 * @param {string} newName
 */
File.prototype.renameTo = function(newName) {};

/**
 */
File.prototype.flush = function() {};

/**
 * @param {number} offset
 * @param {number} whence
 * @return {number}
 */
File.prototype.seek = function(offset, whence) {};

/**
 * @param {number} numBytes
 * @return {string}
 */
File.prototype.read = function(numBytes) {};

/**
 * @return {string}
 */
File.prototype.readln = function() {};


/**
 * @return {Array.<string>}
 */
File.prototype.readAll = function() {};

/**
 * @param {string} data
 */
File.prototype.write = function(data) {};

/**
 * @param {string} data
 */
File.prototype.writeln = function(data) {};

/**
 * @param {Array.<string>} lines
 */
File.prototype.writeAll = function(lines) {};

/**
 * @param {RegExp=} filter
 * @return {Array.<File>}
 */
File.prototype.list = function(filter) {};

/**
 * @param {string} name
 */
File.prototype.mkdir = function(name) {};

/**
 * @return {string}
 */
File.prototype.toURL = function() {};

/**
 * @see https://developer.mozilla.org/en-US/docs/Mozilla/Projects/SpiderMonkey/Parser_API
 */
function Reflect() {}

/**
 * @param {string} code
 * @param {Object=} options
 * @return {Object}
 */
Reflect.parse = function(code, options) {};

/**
 * @param {number=} number
 * @return {number}
 */
function version(number) {}

/**
 */
function revertVersion() {}

/**
 * @param {...string} options
 */
function options(options) {}

/**
 * @param {...string} files
 */
function load(files) {}

/**
 * @param {...string} files
 */
function loadRelativeToScript(files) {}

/**
 * @param {string} code
 * @param {Object=} options
 */
function evaluate(code, options) {}

/**
 * @param {string} file
 * @return {number}
 */
function run(file) {}

/**
 * @return {string}
 */
function readline() {}

/**
 * @param {...*} exprs
 */
function print(exprs) {}

/**
 * @param {...*} exprs
 */
function printErr(exprs) {}

/**
 * @param {*} expr
 */
function putstr(expr) {}

/**
 * @return {number}
 */
function dateNow() {}

/**
 * @param {...string} names
 * @return {string}
 */
function help(names) {}

/**
 * @param {number=} status
 */
function quit(status) {}

/**
 * @param {*} actual
 * @param {*} expected
 * @param {string=} msg
 * @throws {Error}
 */
function assertEq(actual, expected, msg) {}

/**
 * @throws {Error}
 */
function assertJit() {}

/**
 */
function gc() {}

/**
 */
function gcstats() {}

/**
 * @param {string} name
 * @param {number} value
 */
function gcparam(name, value) {}

/**
 * @param {Object=} start
 * @param {string} kind
 */
function countHeap(start, kind) {}

/**
 * @return {Object}
 */
function makeFinalizeObserver() {}

/**
 * @return {number}
 */
function finalizeCount() {}

/**
 * @param {number} level
 */
function gczeal(level) {}

/**
 * @param {boolean} debug
 */
function setDebug(debug) {}

/**
 * @param {function} f
 */
function setDebuggerHandler(f) {}

/**
 * @param {function} f
 */
function setThrowHook(f) {}

/**
 * @param {function=} fun
 * @param {number=} pc
 * @param {*} exp
 */
function trap(fun, pc, exp) {}

/**
 * @param {function} fun
 * @param {number=} pc
 */
function untrap(fun, pc) {}

/**
 * @param {function=} fun
 * @param {number} line
 */
function line2pc(fun, line) {}

/**
 * @param {function} fun
 * @param {number=} pc
 */
function pc2line(fun, pc) {}

/**
 * @param {number=} number
 */
function stackQuota(number) {}

/**
 * @return {boolean}
 */
function stringsAreUTF8() {}

/**
 * @param {number} mode
 */
function testUTF8(mode) {}

/**
 * @param {string=} fileName
 * @param {*=} start
 * @param {*=} toFind
 * @param {number=} maxDepth
 * @param {*=} toIgnore
 */
function dumpHeap(fileName, start, toFind, maxDepth, toIgnore) {}

/**
 */
function dumpObject() {}

/**
 * @param {string|boolean} mode
 */
function tracing(mode) {}

/**
 * @param {...string} strings
 */
function stats(strings) {}

/**
 */
function build() {}

/**
 * @param {Object=} obj
 */
function clear(obj) {}

/**
 * @param {function} fun
 * @param {Object=} scope
 */
function clone(fun, scope) {}

/**
 * @param {Object} obj
 */
function getpda(obj) {}

/**
 * @param {*} n
 * @return {number}
 */
function toint32(n) {}

/**
 * @param {number} n
 * @param {string} str
 * @param {boolean} save
 */
function evalInFrame(n, str, save) {}

/**
 * @param {string} filename
 * @param {string=} options
 */
function snarf(filename, options) {}

/**
 * @param {string} filename
 * @param {string=} options
 */
function read(filename, options) {}

/**
 * @param {number=} seconds
 */
function timeout(seconds) {}

/**
 * @param {Object} obj
 */
function parent(obj) {}

/**
 * @param {Object} obj
 */
function wrap(obj) {}

/**
 * @param {*} sd
 */
function serialize(sd) {}

/**
 * @param {*} a
 */
function deserialize(a) {}

/**
 */
function mjitstats() {}

/**
 */
function stringstats() {}

/**
 * @param {Object} callback
 */
function setGCCallback(callback) {}

/**
 */
function startTimingMutator() {}

/**
 */
function stopTimingMutator() {}

/**
 * @throws {Error}
 */
function throwError() {}

/**
 * @param {function} fun
 */
function disassemble(fun) {}

/**
 * @param {function} fun
 */
function dis(fun) {}

/**
 * @param {string} file
 */
function disfile(file) {}

/**
 * @param {function} fun
 */
function dissrc(fun) {}

/**
 * @param {function} fun
 */
function notes(fun) {}

/**
 * @param {boolean} showArgs
 * @param {boolean} showLocals
 * @param {boolean} showThisProps
 */
function stackDump(showArgs, showLocals, showThisProps) {}

/**
 * @param {string} str
 * @return string
 */
function intern(str) {}

/**
 * @param {Object} obj
 */
function getslx(obj) {}

/**
 * @param {string} s
 * @param {Object=} o
 */
function evalcx(s, o) {}

/**
 * @param {string} str
 */
function evalInWorker(str) {}

/**
 * @return {Object}
 */
function getSharedArrayBuffer() {}

/**
 * @param {Object} buf
 */
function setSharedArrayBuffer(buf) {}

/**
 * @param {Object} obj
 * @return {*}
 */
function shapeOf(obj) {}

/**
 * @param {...Array.<*>} arrays
 */
function arrayInfo(arrays) {}

/**
 * @param {number} dt
 */
function sleep(dt) {}

/**
 * @param {string} code
 * @throws {Error}
 */
function compile(code) {}

/**
 * @param {string} code
 * @throws {Error}
 */
function parse(code) {}

/**
 * @param {string} code
 * @return {boolean}
 */
function syntaxParse(code) {}

/**
 * @param {string} code
 * @param {Object=} options
 */
function offThreadCompileScript(code, options) {}

/**
 * @throws {Error}
 */
function runOffThreadScript() {}

/**
 * @param {number=} seconds
 * @param {function=} func
 */
function timeout(seconds, func) {}

/**
 * @param {boolean} cond
 */
function interruptIf(cond) {}

/**
 * @param {function} fun
 */
function invokeInterruptCallback(fun) {}

/**
 * @param {function} fun
 */
function setInterruptCallback(fun) {}

/**
 */
function enableLastWarning() {}

/**
 */
function disableLastWarning() {}

/**
 * @return {Object}
 */
function getLastWarning() {}

/**
 */
function clearLastWarning() {}

/**
 * @return {number}
 */
function elapsed() {}

/**
 * @param {function} func
 * @return {string}
 */
function decompileFunction(func) {}

/**
 * @param {function} func
 * @return {string}
 */
function decompileBody(func) {}

/**
 * @return {string}
 */
function decompileThis() {}

/**
 * @return {string}
 */
function thisFilename() {}

/**
 * @param {Object=} options
 * @return {Object}
 */
function newGlobal(options) {}

/**
 * @param {string} filename
 * @param {number} offset
 * @param {number} size
 */
function createMappedArrayBuffer(filename, offset, size) {}

/**
 * @return {number}
 */
function getMaxArgs() {}

/**
 * @return {Object}
 */
function objectEmulatingUndefined() {}

/**
 * @return {boolean}
 */
function isCachingEnabled() {}

/**
 * @param {boolean} b
 */
function setCachingEnabled(b) {}

/**
 * @param {string} code
 */
function cacheEntry(code) {}

/**
 */
function printProfilerEvents() {}

/**
 */
function enableSingleStepProfiling() {}

/**
 */
function disableSingleStepProfiling() {}

/**
 * @param {string} s
 * @return {boolean}
 */
function isLatin1(s) {}

/**
 * @return {number}
 */
function stackPointerInfo() {}

/**
 * @param {Object} params
 * @return {Array.<*>}
 */
function entryPoints(params) {}

/**
 * @param {Object} object
 * @param {boolean} deep
 */
function seal(object, deep) {}
