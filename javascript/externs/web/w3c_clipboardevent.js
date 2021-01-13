/*
 * Copyright 2015 The Closure Compiler Authors
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
 * @fileoverview Definitions for W3C's ClipboardEvent API.
 * @see http://www.w3.org/TR/clipboard-apis/
 *
 * @externs
 */



/**
 * @record
 * @extends {EventInit}
 * @see https://www.w3.org/TR/clipboard-apis/#dfn-eventinit
 */
function ClipboardEventInit() {}

/** @type {?DataTransfer|undefined} */
ClipboardEventInit.prototype.clipboardData;


/**
 * @constructor
 * @extends {Event}
 * @param {string} type
 * @param {ClipboardEventInit=} opt_eventInitDict
 */
function ClipboardEvent(type, opt_eventInitDict) {}


/** @const {?DataTransfer} */
ClipboardEvent.prototype.clipboardData;
