// Adapted from the Google Closure externs; original copyright header included below.
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
 * @externs
 */

/**
 * @interface
 */
function EventTarget() {}

/**
 * Stub for the DOM hierarchy.
 *
 * @constructor
 * @extends {EventTarget}
 */
function DomObjectStub() {}

/**
 * @type {!DomObjectStub}
 */
DomObjectStub.prototype.body;

/**
 * @type {!DomObjectStub}
 */
DomObjectStub.prototype.value;

/**
 * @type {!DomObjectStub}
 */
var document;

/**
 * @constructor
 * @implements {EventTarget}
 */
function Node() {}

/**
 * @type {Node}
 */
Node.prototype.parentNode;

/**
 * @return {DomObjectStub}
 */
DomObjectStub.prototype.insertRow = function() {};

/**
 * @return {DomObjectStub}
 */
DomObjectStub.prototype.insertCell = function() {};
