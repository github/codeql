/*
 * Copyright 2011 The Closure Compiler Authors.
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
 * @fileoverview Browser specific definitions for W3C's IndexedDB API
 * @externs
 */

/** @type {!IDBFactory|undefined} */
Window.prototype.moz_indexedDB;

/** @type {!IDBFactory|undefined} */
Window.prototype.mozIndexedDB;

/** @type {!IDBFactory|undefined} */
Window.prototype.webkitIndexedDB;

/** @type {!IDBFactory|undefined} */
Window.prototype.msIndexedDB;

/**
 * @constructor
 * @extends {IDBRequest}
 * @see http://www.w3.org/TR/IndexedDB/#idl-def-IDBRequest
 * @see https://www.w3.org/TR/IndexedDB-2/#request-api
 */
function webkitIDBRequest() {}

/**
 * @constructor
 * @extends {IDBCursor}
 * @see http://www.w3.org/TR/IndexedDB/#idl-def-IDBCursor
 * @see https://www.w3.org/TR/IndexedDB-2/#cursor-interface
 */
function webkitIDBCursor() {}

/**
 * @constructor
 * @extends {IDBTransaction}
 * @see http://www.w3.org/TR/IndexedDB/#idl-def-IDBTransaction
 * @see https://www.w3.org/TR/IndexedDB-2/#transaction
 */
function webkitIDBTransaction() {}

/**
 * @constructor
 * @extends {IDBKeyRange}
 * @see http://www.w3.org/TR/IndexedDB/#idl-def-IDBKeyRange
 * @see https://www.w3.org/TR/IndexedDB-2/#keyrange
 */
function webkitIDBKeyRange() {}

/**
 * @param {string} type
 * @param {!IDBVersionChangeEventInit=} eventInit
 * @constructor
 * @extends {IDBVersionChangeEvent}
 * @see http://www.w3.org/TR/IndexedDB/#idl-def-IDBVersionChangeEvent
 */
function webkitIDBVersionChangeEvent(type, eventInit) {}

/**
 * @const {string}
 */
webkitIDBVersionChangeEvent.prototype.version;
