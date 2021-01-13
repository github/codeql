/*
 * Copyright 2011 The Closure Compiler Authors
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
 * @fileoverview Nonstandard enhancements to W3C's Selection API.
 *
 * @externs
 */

// The following were sources from the webkit externs.

/** @type {?Node} */
Selection.prototype.baseNode;

/** @type {number} */
Selection.prototype.baseOffset;

/** @type {?Node} */
Selection.prototype.extentNode;

/** @type {number} */
Selection.prototype.extentOffset;

/**
 * @param {string} alter
 * @param {string} direction
 * @param {string} granularity
 * @return {undefined}
 */
Selection.prototype.modify = function(alter, direction, granularity) {};


// The following were sources from the gecko externs.


/**
 * @see https://developer.mozilla.org/en/DOM/Selection/selectionLanguageChange
 */
Selection.prototype.selectionLanguageChange;


// The following were sources from the ie externs.


/**
 * @type {?Selection}
 * @see http://msdn.microsoft.com/en-us/library/ms535869(VS.85).aspx
 */
Document.prototype.selection;

/**
 * @return {undefined}
 * @see http://msdn.microsoft.com/en-us/library/ms536418(VS.85).aspx
 */
Selection.prototype.clear = function() {};

/**
 * @return {?TextRange|?ControlRange}
 * @see http://msdn.microsoft.com/en-us/library/ms536394(VS.85).aspx
 */
Selection.prototype.createRange = function() {};

/**
 * @return {?Array<?TextRange>}
 * @see http://msdn.microsoft.com/en-us/library/ms536396(VS.85).aspx
 */
Selection.prototype.createRangeCollection = function() {};
