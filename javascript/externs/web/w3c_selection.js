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
 * @fileoverview Definitions for W3C's Selection API.
 *
 * @see https://w3c.github.io/selection-api/
 *
 * @externs
 */

/**
 * @constructor
 * @see http://w3c.github.io/selection-api/#selection-interface
 */
function Selection() {}

/**
 * @type {?Node}
 * @see https://w3c.github.io/selection-api/#dom-selection-anchornode
 */
Selection.prototype.anchorNode;

/**
 * @type {number}
 * @see https://w3c.github.io/selection-api/#dom-selection-anchoroffset
 */
Selection.prototype.anchorOffset;

/**
 * @type {?Node}
 * @see https://w3c.github.io/selection-api/#dom-selection-focusnode
 */
Selection.prototype.focusNode;

/**
 * @type {number}
 * @see https://w3c.github.io/selection-api/#dom-selection-focusoffset
 */
Selection.prototype.focusOffset;

/**
 * @type {boolean}
 * @see https://w3c.github.io/selection-api/#dom-selection-iscollapsed
 */
Selection.prototype.isCollapsed;

/**
 * @type {number}
 * @see https://w3c.github.io/selection-api/#dom-selection-rangecount
 */
Selection.prototype.rangeCount;

/**
 * @type {string}
 * @see https://w3c.github.io/selection-api/#dom-selection-type
 */
Selection.prototype.type;

/**
 * @param {number} index
 * @return {!Range}
 * @nosideeffects
 * @see https://w3c.github.io/selection-api/#dom-selection-getrangeat
 */
Selection.prototype.getRangeAt = function(index) {};

/**
 * TODO(tjgq): Clean up internal usages and make the `range` parameter a
 * `!Range` per the spec.
 * @param {?Range} range
 * @return {undefined}
 * @see https://w3c.github.io/selection-api/#dom-selection-addrange
 */
Selection.prototype.addRange = function(range) {};

/**
 * @param {!Range} range
 * @return {undefined}
 * @see https://w3c.github.io/selection-api/#dom-selection-removerange
 */
Selection.prototype.removeRange = function(range) {};

/**
 * @return {undefined}
 * @see https://w3c.github.io/selection-api/#dom-selection-removeallranges
 */
Selection.prototype.removeAllRanges = function() {};

/**
 * @return {undefined}
 * @see https://w3c.github.io/selection-api/#dom-selection-empty
 */
Selection.prototype.empty = function() {};

/**
 * @param {?Node} node
 * @param {number=} offset
 * @return {undefined}
 * @see https://w3c.github.io/selection-api/#dom-selection-collapse
 */
Selection.prototype.collapse = function(node, offset) {};

/**
 * @param {?Node} node
 * @param {number=} offset
 * @return {undefined}
 * @see https://w3c.github.io/selection-api/#dom-selection-setposition
 */
Selection.prototype.setPosition = function(node, offset) {};

/**
 * @return {undefined}
 * @see https://w3c.github.io/selection-api/#dom-selection-collapsetostart
 */
Selection.prototype.collapseToStart = function() {};

/**
 * @return {undefined}
 * @see https://w3c.github.io/selection-api/#dom-selection-collapsetoend
 */
Selection.prototype.collapseToEnd = function() {};

/**
 * TODO(tjgq): Clean up internal usages and make the `node` parameter a `!Node`
 * per the spec.
 * @param {?Node} node
 * @param {number=} offset
 * @return {undefined}
 * @see https://w3c.github.io/selection-api/#dom-selection-extend
 */
Selection.prototype.extend = function(node, offset) {};

/**
 * TODO(tjgq): Clean up internal usages and make the `anchorNode` and
 * `focusNode` parameters `!Node` per the spec.
 * @param {?Node} anchorNode
 * @param {number} anchorOffset
 * @param {?Node} focusNode
 * @param {number} focusOffset
 * @return {undefined}
 * @see https://w3c.github.io/selection-api/#dom-selection-setbaseandextent
 */
Selection.prototype.setBaseAndExtent = function(anchorNode, anchorOffset, focusNode, focusOffset) {};

/**
 * TODO(tjgq): Clean up internal usages and make the `node` parameter a `!Node`
 * per the spec.
 * @param {?Node} node
 * @return {undefined}
 * @see http://w3c.github.io/selection-api/#dom-selection-selectallchildren
 */
Selection.prototype.selectAllChildren = function(node) {};

/**
 * @return {undefined}
 * @see https://w3c.github.io/selection-api/#dom-selection-deletefromdocument
 */
Selection.prototype.deleteFromDocument = function() {};

/**
 * @param {!Node} node
 * @param {boolean=} allowPartialContainment
 * @return {boolean}
 * @nosideeffects
 * @see https://w3c.github.io/selection-api/#dom-selection-containsnode
 */
Selection.prototype.containsNode = function(node, allowPartialContainment) {};

/**
 * @return {?Selection}
 * @nosideeffects
 * @see https://w3c.github.io/selection-api/#dom-window-getselection
 */
Window.prototype.getSelection = function() {};

/**
 * @return {?Selection}
 * @nosideeffects
 * @see https://w3c.github.io/selection-api/#dom-document-getselection
 */
Document.prototype.getSelection = function() {};

/**
 * TODO(tjgq): Clean up internal usages and make this `?function(!Event): void`
 * per the spec.
 * @type {?function(?Event)}
 * @see https://w3c.github.io/selection-api/#dom-globaleventhandlers-onselectstart
 */
Element.prototype.onselectstart;

/**
 * @type {?function(!Event): void}
 * @see https://w3c.github.io/selection-api/#dom-globaleventhandlers-onselectionchange
 */
Element.prototype.onselectionchange;
