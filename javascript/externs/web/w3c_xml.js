/*
 * Copyright 2008 The Closure Compiler Authors
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
 * @fileoverview Definitions for W3C's XML related specifications.
 *  This file depends on w3c_dom2.js.
 *  The whole file has been fully type annotated.
 *
 *  Provides the XML standards from W3C.
 *   Includes:
 *    XPath          - Fully type annotated
 *    XMLHttpRequest - Fully type annotated
 *
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html
 * @see https://xhr.spec.whatwg.org/
 *
 * @externs
 * @author stevey@google.com (Steve Yegge)
 */


/**
 * @constructor
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathException
 */
function XPathException() {}

/**
 * @const {number}
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#INVALID_EXPRESSION_ERR
 */
XPathException.INVALID_EXPRESSION_ERR;

/**
 * @const {number}
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#TYPE_ERR
 */
XPathException.TYPE_ERR;

/**
 * @type {number}
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#
 */
XPathException.prototype.code;

/**
 * @constructor
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathEvaluator
 */
function XPathEvaluator() {}

/**
 * @param {string} expr
 * @param {?XPathNSResolver=} opt_resolver
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathEvaluator-createExpression
 * @throws XPathException
 * @throws DOMException
 * @return {undefined}
 */
XPathEvaluator.prototype.createExpression = function(expr, opt_resolver) {};

/**
 * @param {Node} nodeResolver
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathEvaluator-createNSResolver
 * @return {undefined}
 */
XPathEvaluator.prototype.createNSResolver = function(nodeResolver) {};

/**
 * @param {string} expr
 * @param {Node} contextNode
 * @param {?XPathNSResolver=} opt_resolver
 * @param {?number=} opt_type
 * @param {*=} opt_result
 * @return {XPathResult}
 * @throws XPathException
 * @throws DOMException
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathEvaluator-evaluate
 */
XPathEvaluator.prototype.evaluate = function(expr, contextNode, opt_resolver,
    opt_type, opt_result) {};


/**
 * @constructor
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathExpression
 */
function XPathExpression() {}

/**
 * @param {Node} contextNode
 * @param {number=} opt_type
 * @param {*=} opt_result
 * @return {*}
 * @throws XPathException
 * @throws DOMException
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathExpression-evaluate
 */
XPathExpression.prototype.evaluate = function(contextNode, opt_type,
    opt_result) {};


/**
 * @constructor
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathNSResolver
 */
function XPathNSResolver() {}

/**
 * @param {string} prefix
 * @return {?string}
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathNSResolver-lookupNamespaceURI
 */
XPathNSResolver.prototype.lookupNamespaceURI = function(prefix) {};

/**
 * From http://www.w3.org/TR/xpath
 *
 * XPath is a language for addressing parts of an XML document, designed to be
 * used by both XSLT and XPointer.
 *
 * @constructor
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathResult
 */
function XPathResult() {}

/**
 * @type {boolean} {@see XPathException.TYPE_ERR}
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathResult-booleanValue
 */
XPathResult.prototype.booleanValue;

/**
 * @type {boolean} {@see XPathException.TYPE_ERR}
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathResult-invalid-iterator-state
 */
XPathResult.prototype.invalidInteratorState;

/**
 * @type {number}
 * @throws XPathException {@see XPathException.TYPE_ERR}
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathResult-numberValue
 */
XPathResult.prototype.numberValue;

/**
 * @type {number}
 * @throws XPathException {@see XPathException.TYPE_ERR}
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathResult-resultType
 */
XPathResult.prototype.resultType;

/**
 * @type {Node}
 * @throws XPathException {@see XPathException.TYPE_ERR}
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathResult-singleNodeValue
 */
XPathResult.prototype.singleNodeValue;

/**
 * @type {number}
 * @throws XPathException {@see XPathException.TYPE_ERR}
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathResult-snapshot-length
 */
XPathResult.prototype.snapshotLength;

/**
 * @type {string}
 * @throws XPathException {@see XPathException.TYPE_ERR}
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathResult-stringValue
 */
XPathResult.prototype.stringValue;

/**
 * @return {Node}
 * @throws XPathException {@see XPathException.TYPE_ERR}
 * @throws DOMException {@see DOMException.INVALID_STATE_ERR}
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathResult-iterateNext
 */
XPathResult.prototype.iterateNext = function() {};

/**
 * @param {number} index
 * @return {Node}
 * @throws XPathException
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathResult-snapshotItem
 */
XPathResult.prototype.snapshotItem = function(index) {};

/**
 * @const {number}
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathResult-ANY-TYPE
 */
XPathResult.ANY_TYPE;

/**
 * @const {number}
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathResult-NUMBER-TYPE
 */
XPathResult.NUMBER_TYPE;

/**
 * @const {number}
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathResult-STRING-TYPE
 */
XPathResult.STRING_TYPE;

/**
 * @const {number}
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathResult-BOOLEAN-TYPE
 */
XPathResult.BOOLEAN_TYPE;

/**
 * @const {number}
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathResult-UNORDERED-NODE-ITERATOR-TYPE
 */
XPathResult.UNORDERED_NODE_ITERATOR_TYPE;

/**
 * @const {number}
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathResult-ORDERED-NODE-ITERATOR-TYPE
 */
XPathResult.ORDERED_NODE_ITERATOR_TYPE;

/**
 * @const {number}
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathResult-UNORDERED-NODE-SNAPSHOT-TYPE
 */
XPathResult.UNORDERED_NODE_SNAPSHOT_TYPE;

/**
 * @const {number}
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathResult-ORDERED-NODE-SNAPSHOT-TYPE
 */
XPathResult.ORDERED_NODE_SNAPSHOT_TYPE;

/**
 * @const {number}
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathResult-ANY-UNORDERED-NODE-TYPE
 */
XPathResult.ANY_UNORDERED_NODE_TYPE;

/**
 * @const {number}
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathResult-FIRST-ORDERED-NODE-TYPE
 */
XPathResult.FIRST_ORDERED_NODE_TYPE;

/**
 * @constructor
 * @extends {Node}
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathNamespace
 */
function XPathNamespace() {}

/**
 * @type {Element}
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPathNamespace-ownerElement
 */
XPathNamespace.prototype.ownerElement;

/**
 * @const {number}
 * @see http://www.w3.org/TR/DOM-Level-3-XPath/xpath.html#XPATH_NAMESPACE_NODE
 */
XPathNamespace.XPATH_NAMESPACE_NODE;

/**
 * From https://xhr.spec.whatwg.org/#xmlhttprequest
 *
 * (Draft)
 *
 * The XMLHttpRequest Object specification defines an API that provides
 * scripted client functionality for transferring data between a client and a
 * server.
 *
 * @constructor
 * @implements {EventTarget}
 * @see https://xhr.spec.whatwg.org/#xmlhttprequest
 */
function XMLHttpRequest() {}

/** @override */
XMLHttpRequest.prototype.addEventListener = function(
    type, listener, opt_options) {};

/** @override */
XMLHttpRequest.prototype.removeEventListener = function(
    type, listener, opt_options) {};

/** @override */
XMLHttpRequest.prototype.dispatchEvent = function(evt) {};

/**
 * @param {string} method
 * @param {string} url
 * @param {?boolean=} opt_async
 * @param {?string=} opt_user
 * @param {?string=} opt_password
 * @return {undefined}
 * @see https://xhr.spec.whatwg.org/#the-open()-method
 */
XMLHttpRequest.prototype.open = function(method, url, opt_async, opt_user,
    opt_password) {};

/**
 * @param {string} header
 * @param {string} value
 * @return {undefined}
 * @see https://xhr.spec.whatwg.org/#the-setrequestheader()-method
 */
XMLHttpRequest.prototype.setRequestHeader = function(header, value) {};

/**
 * @param {ArrayBuffer|ArrayBufferView|Blob|Document|FormData|string=} opt_data
 * @return {undefined}
 * @see https://xhr.spec.whatwg.org/#the-send()-method
 */
XMLHttpRequest.prototype.send = function(opt_data) {};

/**
 * @return {undefined}
 * @see https://xhr.spec.whatwg.org/#the-abort()-method
 */
XMLHttpRequest.prototype.abort = function() {};

/**
 * @return {string}
 * @see https://xhr.spec.whatwg.org/#the-getallresponseheaders()-method
 */
XMLHttpRequest.prototype.getAllResponseHeaders = function() {};

/**
 * @param {string} header
 * @return {?string}
 * @see https://xhr.spec.whatwg.org/#the-getresponseheader()-method
 */
XMLHttpRequest.prototype.getResponseHeader = function(header) {};

/**
 * @type {string}
 * @see https://xhr.spec.whatwg.org/#the-responsetext-attribute
 */
XMLHttpRequest.prototype.responseText;

/**
 * This is not supported in any IE browser (as of August 2016).
 * @type {string}
 * @see https://xhr.spec.whatwg.org/#the-responseurl-attribute
 */
XMLHttpRequest.prototype.responseURL;

/**
 * @type {Document}
 * @see https://xhr.spec.whatwg.org/#the-responsexml-attribute
 */
XMLHttpRequest.prototype.responseXML;

/**
 * @type {number}
 * @see https://xhr.spec.whatwg.org/#dom-xmlhttprequest-readystate
 */
XMLHttpRequest.prototype.readyState;

/**
 * @type {number}
 * @see https://xhr.spec.whatwg.org/#the-status-attribute
 */
XMLHttpRequest.prototype.status;

/**
 * @type {string}
 * @see https://xhr.spec.whatwg.org/#the-statustext-attribute
 */
XMLHttpRequest.prototype.statusText;

/**
 * @type {number}
 * @see https://xhr.spec.whatwg.org/#the-timeout-attribute
 */
XMLHttpRequest.prototype.timeout;

/**
 * @type {?function(!Event)}
 * @see https://xhr.spec.whatwg.org/#event-handlers
 */
XMLHttpRequest.prototype.onreadystatechange;

/**
 * @type {?function(!Event)}
 * @see https://xhr.spec.whatwg.org/#event-handlers
 */
XMLHttpRequest.prototype.onerror;

/**
 * @const {number}
 * @see https://xhr.spec.whatwg.org/#states
 */
XMLHttpRequest.UNSENT;

/**
 * @const {number}
 * @see https://xhr.spec.whatwg.org/#states
 */
XMLHttpRequest.prototype.UNSENT;

/**
 * @const {number}
 * @see https://xhr.spec.whatwg.org/#states
 */
XMLHttpRequest.OPENED;

/**
 * @const {number}
 * @see https://xhr.spec.whatwg.org/#states
 */
XMLHttpRequest.prototype.OPENED;

/**
 * @const {number}
 * @see https://xhr.spec.whatwg.org/#states
 */
XMLHttpRequest.HEADERS_RECEIVED;

/**
 * @const {number}
 * @see https://xhr.spec.whatwg.org/#states
 */
XMLHttpRequest.prototype.HEADERS_RECEIVED;

/**
 * @const {number}
 * @see https://xhr.spec.whatwg.org/#states
 */
XMLHttpRequest.LOADING;

/**
 * @const {number}
 * @see https://xhr.spec.whatwg.org/#states
 */
XMLHttpRequest.prototype.LOADING;

/**
 * @const {number}
 * @see https://xhr.spec.whatwg.org/#states
 */
XMLHttpRequest.DONE;

/**
 * @const {number}
 * @see https://xhr.spec.whatwg.org/#states
 */
XMLHttpRequest.prototype.DONE;


/**
 * @see https://xhr.spec.whatwg.org/#formdataentryvalue
 * @typedef {!File|string}
 */
var FormDataEntryValue;

/**
 * The FormData object represents an ordered collection of entries. Each entry
 * has a name and value.
 *
 * @param {?Element=} form An optional form to use for constructing the form
 *     data set.
 * @constructor
 * @implements {Iterable<!Array<!FormDataEntryValue>>}
 * @see https://xhr.spec.whatwg.org/#interface-formdata
 */
function FormData(form) {}

/**
 * @param {string} name
 * @param {?Blob|string} value
 * @param {string=} filename
 * @return {undefined}
 * @see https://xhr.spec.whatwg.org/#dom-formdata-append
 */
FormData.prototype.append = function(name, value, filename) {};

/**
 * @param {string} name
 * @return {undefined}
 * @see https://xhr.spec.whatwg.org/#dom-formdata-delete
 */
FormData.prototype.delete = function(name) {};

/**
 * @param {string} name
 * @return {?FormDataEntryValue}
 * @see https://xhr.spec.whatwg.org/#dom-formdata-get
 */
FormData.prototype.get = function(name) {};

/**
 * @param {string} name
 * @return {!Array<!FormDataEntryValue>}
 * @see https://xhr.spec.whatwg.org/#dom-formdata-getall
 */
FormData.prototype.getAll = function(name) {};

/**
 * @param {string} name
 * @return {boolean}
 * @see https://xhr.spec.whatwg.org/#dom-formdata-has
 */
FormData.prototype.has = function(name) {};

/**
 * @param {string} name
 * @param {!Blob|string} value
 * @param {string=} filename
 * @return {undefined}
 * @see https://xhr.spec.whatwg.org/#dom-formdata-set
 */
FormData.prototype.set = function(name, value, filename) {};

