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
 * @fileoverview Definitions for W3C's DOM Level 3 specification.
 *  This file depends on w3c_dom2.js.
 *  The whole file has been fully type annotated.
 *  Created from
 *   http://www.w3.org/TR/DOM-Level-3-Core/ecma-script-binding.html
 *
 * @externs
 * @author stevey@google.com (Steve Yegge)
 */

/**
 * @type {number}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ID-258A00AF
 */
DOMException.prototype.code;

/**
 * @const {number}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ID-258A00AF
 */
DOMException.VALIDATION_ERR;

/**
 * @const {number}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ID-258A00AF
 */
DOMException.TYPE_MISMATCH_ERR;

/**
 * @constructor
 * @implements {IArrayLike<string>}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#DOMStringList
 */
function DOMStringList() {}

/**
 * @type {number}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#DOMStringList-length
 */
DOMStringList.prototype.length;

/**
 * @param {string} str
 * @return {boolean}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#DOMStringList-contains
 * @nosideeffects
 */
DOMStringList.prototype.contains = function(str) {};

/**
 * @param {number} index
 * @return {string}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#DOMStringList-item
 * @nosideeffects
 */
DOMStringList.prototype.item = function(index) {};

/**
 * @constructor
 * @implements {IArrayLike<!DOMImplementation>}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#DOMImplementationList
 */
function DOMImplementationList() {}

/**
 * @type {number}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#DOMImplementationList-length
 */
DOMImplementationList.prototype.length;

/**
 * @param {number} index
 * @return {DOMImplementation}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#DOMImplementationList-item
 * @nosideeffects
 */
DOMImplementationList.prototype.item = function(index) {};

/**
 * @constructor
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#DOMImplementationSource
 */
function DOMImplementationSource() {}

/**
 * @param {?string} namespaceURI
 * @param {string} publicId
 * @param {DocumentType=} doctype
 * @return {Document}
 * @see https://dom.spec.whatwg.org/#ref-for-dom-domimplementation-createdocument%E2%91%A0
 * @nosideeffects
 */
DOMImplementation.prototype.createDocument = function(namespaceURI, publicId, doctype) {};

/**
 * @param {string} qualifiedName
 * @param {string} publicId
 * @param {string} systemId
 * @return {DocumentType}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#Level-2-Core-DOM-createDocType
 * @nosideeffects
 */
DOMImplementation.prototype.createDocumentType = function(qualifiedName, publicId, systemId) {};

/**
 * @param {string} features
 * @return {DOMImplementation}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ID-getDOMImpl
 * @nosideeffects
 */
DOMImplementationSource.prototype.getDOMImplementation = function(features) {};

/**
 * @param {string} features
 * @return {DOMImplementationList}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ID-getDOMImpls
 * @nosideeffects
 */
DOMImplementationSource.prototype.getDOMImplementationList = function(features) {};

/**
 * @param {Node} externalNode
 * @return {Node}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#Document3-adoptNode
 */
Document.prototype.adoptNode = function(externalNode) {};

/**
 * @type {string}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#Document3-documentURI
 */
Document.prototype.documentURI;

/**
 * @type {string}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#Document3-inputEncoding
 */
Document.prototype.inputEncoding;

/**
 * @type {string}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#Document3-encoding
 */
Document.prototype.xmlEncoding;

/**
 * @type {boolean}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#Document3-standalone
 */
Document.prototype.xmlStandalone;

/**
 * @type {string}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#Document3-version
 */
Document.prototype.xmlVersion;

/**
 * @type {?string}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#Node3-baseURI
 */
Node.prototype.baseURI;

/**
 * @type {string}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ID-NodeNSLocalN
 */
Node.prototype.localName;

/**
 * @type {string}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ID-NodeNSname
 */
Node.prototype.namespaceURI;

/**
 * @type {string}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ID-NodeNSPrefix
 */
Node.prototype.prefix;

/**
 * @type {string}
 * @implicitCast
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#Node3-textContent
 */
Node.prototype.textContent;

/**
 * @const {number}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#Node-DOCUMENT_POSITION_DISCONNECTED
 */
Node.DOCUMENT_POSITION_DISCONNECTED;

/**
 * @const {number}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#Node-DOCUMENT_POSITION_PRECEDING
 */
Node.DOCUMENT_POSITION_PRECEDING;

/**
 * @const {number}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#Node-DOCUMENT_POSITION_FOLLOWING
 */
Node.DOCUMENT_POSITION_FOLLOWING;

/**
 * @const {number}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#Node-DOCUMENT_POSITION_CONTAINS
 */
Node.DOCUMENT_POSITION_CONTAINS;

/**
 * @const {number}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#Node-DOCUMENT_POSITION_CONTAINED_BY
 */
Node.DOCUMENT_POSITION_CONTAINED_BY;

/**
 * @const {number}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#Node-DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC
 */
Node.DOCUMENT_POSITION_IMPLEMENTATION_SPECIFIC;

/**
 * @param {Node} other
 * @return {number}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#Node3-compareDocumentPosition
 * @nosideeffects
 */
Node.prototype.compareDocumentPosition = function(other) {};

/**
 * @param {string} feature
 * @param {string} version
 * @return {Object}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#Node3-getFeature
 * @nosideeffects
 */
Node.prototype.getFeature = function(feature, version) {};

/**
 * @param {string} key
 * @return {Object}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#Node3-getUserData
 * @nosideeffects
 */
Node.prototype.getUserData = function(key) {};

/**
 * @return {boolean}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ID-NodeHasAttrs
 * @nosideeffects
 */
Node.prototype.hasAttributes = function() {};

/**
 * @param {?string} namespaceURI
 * @return {boolean}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#Node3-isDefaultNamespace
 * @nosideeffects
 */
Node.prototype.isDefaultNamespace = function(namespaceURI) {};

/**
 * @param {Node} arg
 * @return {boolean}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#Node3-isEqualNode
 * @nosideeffects
 */
Node.prototype.isEqualNode = function(arg) {};

/**
 * @param {Node} other
 * @return {boolean}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#Node3-isSameNode
 * @nosideeffects
 */
Node.prototype.isSameNode = function(other) {};

/**
 * @param {string} prefix
 * @return {string}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#Node3-lookupNamespaceURI
 * @nosideeffects
 */
Node.prototype.lookupNamespaceURI = function(prefix) {};

/**
 * @param {?string} namespaceURI
 * @return {string}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#Node3-lookupNamespacePrefix
 * @nosideeffects
 */
Node.prototype.lookupPrefix = function(namespaceURI) {};

/**
 * @return {undefined}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ID-normalize
 */
Node.prototype.normalize = function() {};

/**
 * @param {string} query
 * @return {?Element}
 * @see http://www.w3.org/TR/selectors-api/#queryselector
 * @nosideeffects
 */
Node.prototype.querySelector = function(query) {};

/**
 * @param {string} query
 * @return {!NodeList<!Element>}
 * @see http://www.w3.org/TR/selectors-api/#queryselectorall
 * @nosideeffects
 */
Node.prototype.querySelectorAll = function(query) {};

/**
 * @type {Element}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#Attr-ownerElement
 */
Attr.prototype.ownerElement;

/**
 * @type {boolean}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#Attr-isId
 */
Attr.prototype.isId;

/**
 * @param {?string} namespaceURI
 * @param {string} localName
 * @return {Attr}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ID-ElGetAtNodeNS
 * @nosideeffects
 */
Element.prototype.getAttributeNodeNS = function(namespaceURI, localName) {};

/**
 * @param {?string} namespaceURI
 * @param {string} localName
 * @return {string}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ID-ElGetAttrNS
 * @nosideeffects
 */
Element.prototype.getAttributeNS = function(namespaceURI, localName) {};

/**
 * @param {?string} namespaceURI
 * @param {string} localName
 * @return {!NodeList<!Element>}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ID-A6C90942
 * @nosideeffects
 */
Element.prototype.getElementsByTagNameNS = function(namespaceURI, localName) {};

/**
 * @param {string} name
 * @return {boolean}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ID-ElHasAttr
 * @nosideeffects
 */
Element.prototype.hasAttribute = function(name) {};

/**
 * @param {?string} namespaceURI
 * @param {string} localName
 * @return {boolean}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ID-ElHasAttrNS
 * @nosideeffects
 */
Element.prototype.hasAttributeNS = function(namespaceURI, localName) {};

/**
 * @param {?string} namespaceURI
 * @param {string} localName
 * @return {undefined}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ID-ElRemAtNS
 */
Element.prototype.removeAttributeNS = function(namespaceURI, localName) {};

/**
 * @param {Attr} newAttr
 * @return {Attr}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ID-ElSetAtNodeNS
 */
Element.prototype.setAttributeNodeNS = function(newAttr) {};

/**
 * @param {?string} namespaceURI
 * @param {string} qualifiedName
 * @param {string|number|boolean} value Values are converted to strings with
 *     ToString, so we accept number and boolean since both convert easily to
 *     strings.
 * @return {undefined}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ID-ElSetAttrNS
 */
Element.prototype.setAttributeNS = function(namespaceURI, qualifiedName, value) {};

/**
 * @type {string}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#Text3-wholeText
 */
Text.prototype.wholeText;

/**
 * @constructor
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ERROR-Interfaces-DOMError
 */
function DOMError() {}

/**
 * @type {DOMLocator}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ERROR-DOMError-location
 */
DOMError.prototype.location;

/**
 * @type {string}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ERROR-DOMError-message
 */
DOMError.prototype.message;

/**
 * @type {Object}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ERROR-DOMError-relatedData
 */
DOMError.prototype.relatedData;

/**
 * @type {Object}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ERROR-DOMError-relatedException
 */
DOMError.prototype.relatedException;

/**
 * @const {number}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ERROR-DOMError-severity-warning
 */
DOMError.SEVERITY_WARNING;

/**
 * @const {number}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ERROR-DOMError-severity-error
 */
DOMError.SEVERITY_ERROR;

/**
 * @const {number}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ERROR-DOMError-severity-fatal-error
 */
DOMError.SEVERITY_FATAL_ERROR;

/**
 * @type {number}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ERROR-DOMError-severity
 */
DOMError.prototype.severity;

/**
 * @type {string}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ERROR-DOMError-type
 */
DOMError.prototype.type;

/**
 * @type {string}
 * @see http://www.w3.org/TR/dom/#domerror
 */
DOMError.prototype.name;

/**
 * @constructor
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ERROR-Interfaces-DOMErrorHandler
 */
function DOMErrorHandler() {}

/**
 * @param {DOMError} error
 * @return {boolean}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ID-ERRORS-DOMErrorHandler-handleError
 */
DOMErrorHandler.prototype.handleError = function(error) {};

/**
 * @constructor
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#Interfaces-DOMLocator
 */
function DOMLocator() {}

/**
 * @type {number}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#DOMLocator-byteOffset
 */
DOMLocator.prototype.byteOffset;

/**
 * @type {number}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#DOMLocator-column-number
 */
DOMLocator.prototype.columnNumber;

/**
 * @type {number}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#DOMLocator-line-number
 */
DOMLocator.prototype.lineNumber;

/**
 * @type {Node}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#DOMLocator-node
 */
DOMLocator.prototype.relatedNode;

/**
 * @type {string}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#DOMLocator-uri
 */
DOMLocator.prototype.uri;

/**
 * @type {number}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#DOMLocator-utf16Offset
 */
DOMLocator.prototype.utf16Offset;

/**
 * @type {string}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ID-Core-DocType-publicId
 */
DocumentType.prototype.publicId;

/**
 * @type {string}
 * @see http://www.w3.org/TR/DOM-Level-3-Core/core.html#ID-Core-DocType-systemId
 */
DocumentType.prototype.systemId;
