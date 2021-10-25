/*
 * Copyright 2014 The Closure Compiler Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
/**
 * @fileoverview Definitions of the fetch api.
 *
 * This api is still in development and not yet stable. Use at your
 * own risk.
 *
 * Based on Living Standard — Last Updated 17 August 2016
 *
 * @see https://fetch.spec.whatwg.org/
 * @externs
 */


/**
 * @typedef {string}
 * @see https://w3c.github.io/webappsec-referrer-policy/#enumdef-referrerpolicy
 * Possible values: '', 'no-referrer', 'no-referrer-when-downgrade',
 *  'same-origin', 'origin', 'strict-origin', 'origin-when-cross-origin',
 *  'strict-origin-when-cross-origin', 'unsafe-url'
 */
var ReferrerPolicy;


/**
 * @typedef {!Headers|!Array<!Array<string>>|!IObject<string,string>}
 * @see https://fetch.spec.whatwg.org/#headersinit
 */
var HeadersInit;


/**
 * @param {!HeadersInit=} opt_headersInit
 * @constructor
 * @implements {Iterable<!Array<string>>}
 * @see https://fetch.spec.whatwg.org/#headers
 */
function Headers(opt_headersInit) {}

/**
 * @param {string} name
 * @param {string} value
 * @return {undefined}
 */
Headers.prototype.append = function(name, value) {};

/**
 * @param {string} name
 * @return {undefined}
 */
Headers.prototype.delete = function(name) {};

/** @return {!Iterator<!Array<string>>} */
Headers.prototype.entries = function() {};

/**
 * @param {string} name
 * @return {?string}
 */
Headers.prototype.get = function(name) {};

/**
 * @param {string} name
 * @return {!Array<string>}
 */
Headers.prototype.getAll = function(name) {};

/**
 * @param {string} name
 * @return {boolean}
 */
Headers.prototype.has = function(name) {};

/** @return {!Iterator<string>} */
Headers.prototype.keys = function() {};

/**
 * @param {string} name
 * @param {string} value
 * @return {undefined}
 */
Headers.prototype.set = function(name, value) {};

/** @return {!Iterator<string>} */
Headers.prototype.values = function() {};

/** @return {!Iterator<!Array<string>>} */
Headers.prototype[Symbol.iterator] = function() {};


/**
 * @typedef {!Blob|!BufferSource|!FormData|string}
 * @see https://fetch.spec.whatwg.org/#bodyinit
 */
var BodyInit;


/**
 * @typedef {!BodyInit|!ReadableStream}
 * @see https://fetch.spec.whatwg.org/#responsebodyinit
 */
var ResponseBodyInit;


/**
 * @interface
 * @see https://fetch.spec.whatwg.org/#body
 */
function Body() {};

/** @type {boolean} */
Body.prototype.bodyUsed;

/** @return {!Promise<!ArrayBuffer>} */
Body.prototype.arrayBuffer = function() {};

/** @return {!Promise<!Blob>} */
Body.prototype.blob = function() {};

/** @return {!Promise<!FormData>} */
Body.prototype.formData = function() {};

/** @return {!Promise<*>} */
Body.prototype.json = function() {};

/** @return {!Promise<string>} */
Body.prototype.text = function() {};


/**
 * @typedef {!Request|string}
 * @see https://fetch.spec.whatwg.org/#requestinfo
 */
var RequestInfo;


/**
 * @param {!RequestInfo} input
 * @param {!RequestInit=} opt_init
 * @constructor
 * @implements {Body}
 * @see https://fetch.spec.whatwg.org/#request
 */
function Request(input, opt_init) {}

/** @override */
Request.prototype.bodyUsed;

/** @override */
Request.prototype.arrayBuffer = function() {};

/** @override */
Request.prototype.blob = function() {};

/** @override */
Request.prototype.formData = function() {};

/** @override */
Request.prototype.json = function() {};

/** @override */
Request.prototype.text = function() {};

/** @type {string} */
Request.prototype.method;

/** @type {string} */
Request.prototype.url;

/** @type {!Headers} */
Request.prototype.headers;

/** @type {!FetchRequestType} */
Request.prototype.type;

/** @type {!RequestDestination} */
Request.prototype.destination;

/** @type {string} */
Request.prototype.referrer;

/** @type {!RequestMode} */
Request.prototype.mode;

/** @type {!RequestCredentials} */
Request.prototype.credentials;

/** @type {!RequestCache} */
Request.prototype.cache;

/** @type {!RequestRedirect} */
Request.prototype.redirect;

/** @type {string} */
Request.prototype.integrity;

/** @return {!Request} */
Request.prototype.clone = function() {};


/**
 * @record
 * @see https://fetch.spec.whatwg.org/#requestinit
 */
function RequestInit() {};

/** @type {(undefined|string)} */
RequestInit.prototype.method;

/** @type {(undefined|!HeadersInit)} */
RequestInit.prototype.headers;

/** @type {(undefined|?BodyInit)} */
RequestInit.prototype.body;

/** @type {(undefined|string)} */
RequestInit.prototype.referrer;

/** @type {(undefined|!ReferrerPolicy)} */
RequestInit.prototype.referrerPolicy;

/** @type {(undefined|!RequestMode)} */
RequestInit.prototype.mode;

/** @type {(undefined|!RequestCredentials)} */
RequestInit.prototype.credentials;

/** @type {(undefined|!RequestCache)} */
RequestInit.prototype.cache;

/** @type {(undefined|!RequestRedirect)} */
RequestInit.prototype.redirect;

/** @type {(undefined|string)} */
RequestInit.prototype.integrity;

/** @type {(undefined|null)} */
RequestInit.prototype.window;

/**
 * @typedef {string}
 * @see https://fetch.spec.whatwg.org/#requesttype
 *  Possible values: '', 'audio', 'font', 'image', 'script', 'style',
 *  'track', 'video'
 */
var FetchRequestType;


/**
 * @typedef {string}
 * @see https://fetch.spec.whatwg.org/#requestdestination
 * Possible values: '', 'document', 'embed', 'font', 'image', 'manifest',
 *  'media', 'object', 'report', 'script', 'serviceworker', 'sharedworker',
 *  'style', 'worker', 'xslt'
 */
var RequestDestination;


/**
 * @typedef {string}
 * @see https://fetch.spec.whatwg.org/#requestmode
 * Possible values: 'navigate', 'same-origin', 'no-cors', 'cors'
 */
var RequestMode ;


/**
 * @typedef {string}
 * @see https://fetch.spec.whatwg.org/#requestcredentials
 * Possible values: 'omit', 'same-origin', 'include'
 */
var RequestCredentials;


/**
 * @typedef {string}
 * @see https://fetch.spec.whatwg.org/#requestcache
 *  Possible values: 'default', 'no-store', 'reload', 'no-cache', 'force-cache',
 * 'only-if-cached'
 */
var RequestCache;


/**
 * @typedef {string}
 * @see https://fetch.spec.whatwg.org/#requestredirect
 * Possible values: 'follow', 'error', 'manual'
 */
var RequestRedirect;


/**
 * @param {?ResponseBodyInit=} opt_body
 * @param {!ResponseInit=} opt_init
 * @constructor
 * @implements {Body}
 * @see https://fetch.spec.whatwg.org/#response
 */
function Response(opt_body, opt_init) {}

/** @return {!Response} */
Response.error = function() {};

/**
 * @param {string} url
 * @param {number=} opt_status
 * @return {!Response}
 */
Response.redirect = function(url, opt_status) {};

/** @override */
Response.prototype.bodyUsed;

/** @override */
Response.prototype.arrayBuffer = function() {};

/** @override */
Response.prototype.blob = function() {};

/** @override */
Response.prototype.formData = function() {};

/** @override */
Response.prototype.json = function() {};

/** @override */
Response.prototype.text = function() {};

/** @type {!ResponseType} */
Response.prototype.type;

/** @type {string} */
Response.prototype.url;

/** @type {boolean} */
Response.prototype.redirected;

/** @type {number} */
Response.prototype.status;

/** @type {boolean} */
Response.prototype.ok;

/** @type {string} */
Response.prototype.statusText;

/** @type {!Headers} */
Response.prototype.headers;

/** @type {?ReadableStream} */
Response.prototype.body;

/** @type {!Promise<!Headers>} */
Response.prototype.trailer;

/** @return {!Response} */
Response.prototype.clone = function() {};


/**
 * @record
 * @see https://fetch.spec.whatwg.org/#responseinit
 */
function ResponseInit() {};

/** @type {(undefined|number)} */
ResponseInit.prototype.status;

/** @type {(undefined|string)} */
ResponseInit.prototype.statusText;

/** @type {(undefined|!HeadersInit)} */
ResponseInit.prototype.headers;


/**
 * @typedef {string}
 * @see https://fetch.spec.whatwg.org/#responsetype
 * Possible values: 'basic', 'cors', 'default', 'error', 'opaque',
 *  'opaqueredirect'
 */
var ResponseType;

/**
 * @param {!RequestInfo} input
 * @param {!RequestInit=} opt_init
 * @return {!Promise<!Response>}
 * @see https://fetch.spec.whatwg.org/#fetch-method
 */
function fetch(input, opt_init) {}

/**
 * @param {!RequestInfo} input
 * @param {!RequestInit=} opt_init
 * @return {!Promise<!Response>}
 * @see https://fetch.spec.whatwg.org/#fetch-method
 */
Window.prototype.fetch = function(input, opt_init) {};

/**
 * @param {!RequestInfo} input
 * @param {!RequestInit=} opt_init
 * @return {!Promise<!Response>}
 * @see https://fetch.spec.whatwg.org/#fetch-method
 */
WorkerGlobalScope.prototype.fetch = function(input, opt_init) {};
