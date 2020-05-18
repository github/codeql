/**
 * @externs
 */
var fs = {};

/**
 * @param {string} filename
 * @param {*} data
 * @return {void}
 */
fs.writeFileSync = function(filename, data) {};

/**
 * @param {(string|Buffer)} srcpath
 * @param {(string|Buffer)} dstpath
 * @return {void}
 */
fs.linkSync = function(srcpath, dstpath) {};

/**
 * @param {(string|Buffer)} path
 * @param {(string|number)} flags
 * @param {number=} mode
 * @return {number}
 */
fs.openSync = function(path, flags, mode) {};