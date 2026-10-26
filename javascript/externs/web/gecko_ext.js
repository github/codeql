/*
 * Copyright 2017 Semmle Ltd.
 */

/**
 * @fileoverview More non-standard Gecko extensions.
 * @externs
 */

/**
 * Non-standard Gecko extension: XMLHttpRequest takes an optional parameter.
 *
 * @constructor
 * @implements {EventTarget}
 * @param {Object=} options
 * @see https://developer.mozilla.org/en-US/docs/Web/API/XMLHttpRequest#XMLHttpRequest%28%29
 */
function XMLHttpRequest(options) {}
