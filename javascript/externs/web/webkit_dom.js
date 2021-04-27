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
 * @fileoverview Definitions for all the extensions over W3C's DOM
 *  specification by WebKit. This file depends on w3c_dom2.js.
 *  All the provided definitions has been type annotated
 *
 * @externs
 */

/**
 * @param {boolean=} opt_center
 * @see https://bugzilla.mozilla.org/show_bug.cgi?id=403510
 * @return {undefined}
 */
Element.prototype.scrollIntoViewIfNeeded = function(opt_center) {};

/**
 * @constructor
 * @see http://trac.webkit.org/browser/trunk/Source/WebCore/inspector/ScriptProfileNode.idl
 */
function ScriptProfileNode() {};

/** @type {string} */
ScriptProfileNode.prototype.functionName;

/** @type {string} */
ScriptProfileNode.prototype.url;

/** @type {number} */
ScriptProfileNode.prototype.lineNumber;

/** @type {number} */
ScriptProfileNode.prototype.totalTime;

/** @type {number} */
ScriptProfileNode.prototype.selfTime;

/** @type {number} */
ScriptProfileNode.prototype.numberOfCalls;

/** @type {Array<ScriptProfileNode>} */
ScriptProfileNode.prototype.children;

/** @type {boolean} */
ScriptProfileNode.prototype.visible;

/** @type {number} */
ScriptProfileNode.prototype.callUID;

/**
 * @constructor
 * @see http://trac.webkit.org/browser/trunk/Source/WebCore/inspector/ScriptProfile.idl
 */
function ScriptProfile() {};

/** @type {string} */
ScriptProfile.prototype.title;

/** @type {number} */
ScriptProfile.prototype.uid;

/** @type {ScriptProfileNode} */
ScriptProfile.prototype.head;

/**
 * @type {number}
 * @see http://developer.android.com/reference/android/webkit/WebView.html
 */
Window.prototype.devicePixelRatio;

/**
 * @param {string} contextId
 * @param {string} name
 * @param {number} width
 * @param {number} height
 * @nosideeffects
 * @return {undefined}
 */
Document.prototype.getCSSCanvasContext =
    function(contextId, name, width, height) {};

/**
 * @param {number} x
 * @param {number} y
 * @return {?Range}
 * @nosideeffects
 * @see https://developer.mozilla.org/en-US/docs/Web/API/Document/caretRangeFromPoint
 */
Document.prototype.caretRangeFromPoint = function(x, y) {};

/**
 * @return {!Promise<boolean>}
 * @nosideeffects
 * @see https://webkit.org/blog/8124/introducing-storage-access-api
 */
Document.prototype.hasStorageAccess = function() {};

/**
 * @return {!Promise<void>}
 * @see https://webkit.org/blog/8124/introducing-storage-access-api
 * @see https://developer.mozilla.org/docs/Web/API/Document/requestStorageAccess#Syntax
 */
Document.prototype.requestStorageAccess = function() {};
