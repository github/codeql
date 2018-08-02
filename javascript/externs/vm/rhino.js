/**
 * @externs
 * Source: https://developer.mozilla.org/en-US/docs/Mozilla/Projects/Rhino/Shell
 */

/**
 * @type {Array.<string>}
 */
var arguments;

/**
 * @type {Object}
 */
var environment;

/**
 * @type {string}
 */
var history;

/**
 */
function help() {}

/**
 * @param {string} className
 */
function defineClass(className) {}

/**
 * @param {string} filename
 */
function deserialize(filename) {}

/**
 */
function gc() {}

/**
 * @param {...string} files
 */
function load(files) {}

/**
 * @param {string} className
 */
function loadClass(className) {}

/**
 * @param {...*} exprs
 */
function print(exprs) {}

/**
 * @param {string} path
 * @param {string=} characterCoding
 */
function readFile(path, characterCoding) {}

/**
 * @param {string} url
 * @param {string=} characterCoding
 */
function readUrl(url, characterCoding) {}

/**
 * @param {string} commandName
 * @param {...*} args
 */
function runCommand(commandName, args) {}

/**
 * @param {Object} object
 */
function seal(object) {}

/**
 * @param {Object} object
 * @param {string} filename
 */
function serialize(object, filename) {}

/**
 * @param {string|function} functionOrScript
 */
function spawn(functionOrScript) {}

/**
 * @param {function} fun
 */
function sync(fun) {}

/**
 */
function quit() {}

/**
 * @param {number=} num
 */
function version(num) {}
