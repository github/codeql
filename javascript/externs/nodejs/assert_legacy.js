/*
 * Copyright 2016 Semmle Ltd.
 */


/**
 * @fileoverview An extension of the node's assert module declaring legacy members
 * @externs
 */

var assert = require('assert');

/**
 * @param {*} actual
 * @param {*} expected
 * @param {string=} message
 * @return {void}
 */
function eql(actual, expected, message) {}
assert.eql = eql;
