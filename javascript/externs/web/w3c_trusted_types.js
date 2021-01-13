/*
 * Copyright 2018 The Closure Compiler Authors
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
 * @fileoverview Definitions for W3C's Trusted Types specification.
 * @see https://w3c.github.io/webappsec-trusted-types/dist/spec/
 * @externs
 */


/** @constructor */
function TrustedHTML() {}

// function TrustedScript() was moved to `es3.js` so that is could be used by
// `eval()`.

/** @constructor */
function TrustedScriptURL() {}


/**
 * @template Options
 * @constructor
 */
function TrustedTypePolicy() {}

/**
 * @param {string} s
 * @return {!TrustedHTML}
 */
TrustedTypePolicy.prototype.createHTML = function(s) {};

/**
 * @param {string} s
 * @return {!TrustedScript}
 */
TrustedTypePolicy.prototype.createScript = function(s) {};

/**
 * @param {string} s
 * @return {!TrustedScriptURL}
 */
TrustedTypePolicy.prototype.createScriptURL = function(s) {};


/** @constructor */
function TrustedTypePolicyFactory() {}

/** @record @private */
function TrustedTypePolicyOptions() {};

/**
 *  @type {(function(string, ...*): string)|undefined},
 */
TrustedTypePolicyOptions.prototype.createHTML;

/**
 *  @type {(function(string, ...*): string)|undefined},
 */
TrustedTypePolicyOptions.prototype.createScript;

/**
 *  @type {(function(string, ...*): string)|undefined},
 */
TrustedTypePolicyOptions.prototype.createScriptURL;


/**
 * @param {string} name
 * @param {!TrustedTypePolicyOptions} policy
 * @return {!TrustedTypePolicy}
 */
TrustedTypePolicyFactory.prototype.createPolicy = function(name, policy) {};


/**
 * @param {*} obj
 * @return {boolean}
 */
TrustedTypePolicyFactory.prototype.isHTML = function(obj) {};

/**
 * @param {*} obj
 * @return {boolean}
 */
TrustedTypePolicyFactory.prototype.isScript = function(obj) {};

/**
 * @param {*} obj
 * @return {boolean}
 */
TrustedTypePolicyFactory.prototype.isScriptURL = function(obj) {};


/** @type {!TrustedHTML} */
TrustedTypePolicyFactory.prototype.emptyHTML;


/** @type {!TrustedScript} */
TrustedTypePolicyFactory.prototype.emptyScript;

/**
 * @param {string} tagName
 * @param {string} attribute
 * @param {string=} elementNs
 * @param {string=} attrNs
 * @return {?string}
 */
TrustedTypePolicyFactory.prototype.getAttributeType = function(
    tagName, attribute, elementNs, attrNs) {};

/**
 * @param {string} tagName
 * @param {string} property
 * @param {string=} elementNs
 * @return {?string}
 */
TrustedTypePolicyFactory.prototype.getPropertyType = function(
    tagName, property, elementNs) {};

/** @type {?TrustedTypePolicy} */
TrustedTypePolicyFactory.prototype.defaultPolicy;


/** @type {!TrustedTypePolicyFactory} */
var trustedTypes;
