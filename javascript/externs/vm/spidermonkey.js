/**
 * Externs for Spidermonkey-specific API.
 *
 * @externs
 */

/**
 * @param {Object} object
 * @param {*=} keyOnly
 * @return {Object}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Iterator
 */
function Iterator(object, keyOnly) {}

/**
 * @return {*}
 */
Iterator.prototype.next = function() {};

/**
 * @type {Object}
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/StopIteration
 */
var StopIteration;
