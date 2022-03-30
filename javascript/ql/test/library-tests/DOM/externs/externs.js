/** @externs */

/**
 * @constructor
 * @name EventTarget
 */
function EventTarget() {}

/** @type {EventTarget} */
var window;

/**
 * @see http://dev.w3.org/html5/workers/
 * @interface
 * @extends {EventTarget}
 */
function WorkerGlobalScope() {}

/** @type {WorkerLocation} */
WorkerGlobalScope.prototype.location;

/**
 * @constructor
 * @implements {EventTarget}
 */
function Node() {}

/**
 * @type {Node}
 */
Node.prototype.parentNode;
