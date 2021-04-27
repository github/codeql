/*
 * Copyright 2016 The Closure Compiler Authors
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
 * @fileoverview Definitions for W3C's DOM4 specification. This file depends on
 * w3c_dom3.js. The whole file has been fully type annotated. Created from
 * https://www.w3.org/TR/domcore/.
 *
 * @externs
 * @author zhoumotongxue008@gmail.com (Michael Zhou)
 */

/**
 * @typedef {?(DocumentType|Element|CharacterData)}
 * @see https://www.w3.org/TR/domcore/#interface-childnode
 */
var ChildNode;

/**
 * @return {undefined}
 * @see https://www.w3.org/TR/domcore/#dom-childnode-remove
 */
DocumentType.prototype.remove = function() {};

/**
 * @return {undefined}
 * @see https://www.w3.org/TR/domcore/#dom-childnode-remove
 */
Element.prototype.remove = function() {};

/**
 * @return {undefined}
 * @see https://www.w3.org/TR/domcore/#dom-childnode-remove
 */
CharacterData.prototype.remove = function() {};

/**
 * @param {...(!Node|string)} nodes
 * @return {undefined}
 * @see https://dom.spec.whatwg.org/#dom-childnode-replacewith
 */
DocumentType.prototype.replaceWith = function(nodes) {};

/**
 * @const {string}
 * @see https://www.w3.org/TR/2015/REC-dom-20151119/#sec-domerror
 */
DOMException.prototype.name;

/**
 * @const {string}
 * @see https://www.w3.org/TR/2015/REC-dom-20151119/#sec-domerror
 */
DOMException.prototype.message;

/**
 * @const {number}
 * @see https://www.w3.org/TR/2015/REC-dom-20151119/#dfn-error-names-table
 */
DOMException.SECURITY_ERR;

/**
 * @const {number}
 * @see https://www.w3.org/TR/2015/REC-dom-20151119/#dfn-error-names-table
 */
DOMException.NETWORK_ERR;

/**
 * @const {number}
 * @see https://www.w3.org/TR/2015/REC-dom-20151119/#dfn-error-names-table
 */
DOMException.ABORT_ERR;

/**
 * @const {number}
 * @see https://www.w3.org/TR/2015/REC-dom-20151119/#dfn-error-names-table
 */
DOMException.URL_MISMATCH_ERR;

/**
 * @const {number}
 * @see https://www.w3.org/TR/2015/REC-dom-20151119/#dfn-error-names-table
 */
DOMException.QUOTA_EXCEEDED_ERR;

/**
 * @const {number}
 * @see https://www.w3.org/TR/2015/REC-dom-20151119/#dfn-error-names-table
 */
DOMException.TIMEOUT_ERR;

/**
 * @const {number}
 * @see https://www.w3.org/TR/2015/REC-dom-20151119/#dfn-error-names-table
 */
DOMException.INVALID_NODE_TYPE_ERR;

/**
 * @const {number}
 * @see https://www.w3.org/TR/2015/REC-dom-20151119/#dfn-error-names-table
 */
DOMException.DATA_CLONE_ERR;

/**
 * @param {...(!Node|string)} nodes
 * @return {undefined}
 * @see https://dom.spec.whatwg.org/#dom-childnode-replacewith
 */
Element.prototype.replaceWith = function(nodes) {};

/**
 * @param {...(!Node|string)} nodes
 * @return {undefined}
 * @see https://dom.spec.whatwg.org/#dom-childnode-replacewith
 */
CharacterData.prototype.replaceWith = function(nodes) {};

/**
 * @return {!Array<string>}
 * @see https://dom.spec.whatwg.org/#dom-element-getattributenames
 */
Element.prototype.getAttributeNames = function() {};

/**
 * @param {...(!Node|string)} nodes
 * @return {undefined}
 * @see https://dom.spec.whatwg.org/#dom-parentnode-append
 */
Element.prototype.append = function(nodes) {};

/**
 * @param {...(!Node|string)} nodes
 * @return {undefined}
 * @see https://dom.spec.whatwg.org/#dom-parentnode-append
 */
Document.prototype.append = function(nodes) {};

/**
 * @param {...(!Node|string)} nodes
 * @return {undefined}
 * @see https://dom.spec.whatwg.org/#dom-parentnode-append
 */
DocumentFragment.prototype.append = function(nodes) {};

/**
 * @param {...(!Node|string)} nodes
 * @return {undefined}
 * @see https://dom.spec.whatwg.org/#dom-parentnode-prepend
 */
Element.prototype.prepend = function(nodes) {};

/**
 * @param {...(!Node|string)} nodes
 * @return {undefined}
 * @see https://dom.spec.whatwg.org/#dom-parentnode-prepend
 */
Document.prototype.prepend = function(nodes) {};

/**
 * @param {...(!Node|string)} nodes
 * @return {undefined}
 * @see https://dom.spec.whatwg.org/#dom-parentnode-prepend
 */
DocumentFragment.prototype.prepend = function(nodes) {};

/**
 * @param {...(!Node|string)} nodes
 * @return {undefined}
 * @see https://dom.spec.whatwg.org/#dom-childnode-before
 */
Element.prototype.before = function(nodes) {};

/**
 * @param {...(!Node|string)} nodes
 * @return {undefined}
 * @see https://dom.spec.whatwg.org/#dom-childnode-before
 */
DocumentType.prototype.before = function(nodes) {};

/**
 * @param {...(!Node|string)} nodes
 * @return {undefined}
 * @see https://dom.spec.whatwg.org/#dom-childnode-before
 */
CharacterData.prototype.before = function(nodes) {};

/**
 * @param {...(!Node|string)} nodes
 * @return {undefined}
 * @see https://dom.spec.whatwg.org/#dom-childnode-after
 */
Element.prototype.after = function(nodes) {};

/**
 * @param {...(!Node|string)} nodes
 * @return {undefined}
 * @see https://dom.spec.whatwg.org/#dom-childnode-after
 */
DocumentType.prototype.after = function(nodes) {};

/**
 * @param {...(!Node|string)} nodes
 * @return {undefined}
 * @see https://dom.spec.whatwg.org/#dom-childnode-after
 */
CharacterData.prototype.after = function(nodes) {};

/**
 * @param {string} name
 * @param {boolean=} force
 * @return {boolean}
 * @throws {DOMException}
 * @see https://dom.spec.whatwg.org/#dom-element-toggleattribute
 */
Element.prototype.toggleAttribute = function(name, force) {};

/**
 * @type {Element}
 * @see http://msdn.microsoft.com/en-us/library/ms534327(VS.85).aspx
 */
Node.prototype.parentElement;

/**
 * @param {string} name
 * @return {!HTMLCollection<!Element>}
 * @nosideeffects
 * @see https://dom.spec.whatwg.org/#dom-document-getelementsbyclassname-classnames-classnames
 */
Document.prototype.getElementsByClassName = function(name) {};

/**
 * @param {string} classNames
 * @return {!HTMLCollection<!Element>}
 * @nosideeffects
 * @see https://dom.spec.whatwg.org/#dom-element-getelementsbyclassname-classnames-classnames
 */
Element.prototype.getElementsByClassName = function(classNames) {};

/**
 * @param {string} where
 * @param {Element} element
 * @return {!Element}
 * @throws {DOMException}
 * @see https://dom.spec.whatwg.org/#dom-element-insertadjacentelement
 */
Element.prototype.insertAdjacentElement = function(where, element) {};

/**
 * @param {string} where
 * @param {string} data
 * @return {undefined}
 * @throws {DOMException}
 * @see https://dom.spec.whatwg.org/#dom-element-insertadjacenttext
 */
Element.prototype.insertAdjacentText = function(where, data) {};
