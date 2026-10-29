/*
 * Copyright 2017 Semmle Ltd.
 */


/**
 * @fileoverview A model of the builtin Proxy object.
 * @externs
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy
 */

/**
 * @param {*} target
 * @param {Object} handler
 * @constructor
 */
function Proxy(target, handler) {
}

/**
 * @returns {Proxy}
 */
Proxy.prototype.revocable = function() {};
