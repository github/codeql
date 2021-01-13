/*
 * Copyright 2009 The Closure Compiler Authors
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
 * @fileoverview Definitions for W3C's WebStorage specification.
 * This file depends on w3c_dom1.js and w3c_event.js.
 * @externs
 */

/**
 * @interface
 * @see https://www.w3.org/TR/webstorage/#the-storage-interface
 */
function Storage() {}

/**
 * @const {number}
 */
Storage.prototype.length;

/**
 * @param {number} index
 * @return {?string}
 */
Storage.prototype.key = function(index) {};

/**
 * @param {string} key
 * @return {?string}
 */
Storage.prototype.getItem = function(key) {};

/**
 * @param {string} key
 * @param {string} data
 * @return {void}
 */
Storage.prototype.setItem = function(key, data) {};

/**
 * @param {string} key
 * @return {void}
 */
Storage.prototype.removeItem = function(key) {};

/**
 * @return {void}
 */
Storage.prototype.clear = function() {};

/**
 * @interface
 * @see https://www.w3.org/TR/webstorage/#the-sessionstorage-attribute
 */
function WindowSessionStorage() {}

/**
 * @type {!Storage}
 */
WindowSessionStorage.prototype.sessionStorage;

/**
 * Window implements WindowSessionStorage
 *
 * @type {!Storage}
 */
Window.prototype.sessionStorage;

/**
 * @interface
 * @see https://www.w3.org/TR/webstorage/#the-localstorage-attribute
 */
function WindowLocalStorage() {}

/**
 * @type {!Storage}
 */
WindowLocalStorage.prototype.localStorage;

/**
 * Window implements WindowLocalStorage
 *
 * @type {!Storage}
 */
Window.prototype.localStorage;

/**
 * @record
 * @extends {EventInit}
 * @see https://www.w3.org/TR/webstorage/#the-storageevent-interface
 */
function StorageEventInit() {}

/** @type {undefined|string} */
StorageEventInit.prototype.key;

/** @type {undefined|string} */
StorageEventInit.prototype.oldValue;

/** @type {undefined|string} */
StorageEventInit.prototype.newValue;

/** @type {string} */
StorageEventInit.prototype.url;

/** @type {undefined|!Storage} */
StorageEventInit.prototype.storageArea;

/**
 * This is the storage event interface.
 * @see https://www.w3.org/TR/webstorage/#the-storage-event
 * @extends {Event}
 * @param {string} type
 * @param {!StorageEventInit=} eventInitDict
 * @constructor
 */
function StorageEvent(type, eventInitDict) {}

/**
 * @type {string}
 */
StorageEvent.prototype.key;

/**
 * @type {?string}
 */
StorageEvent.prototype.oldValue;

/**
 * @type {?string}
 */
StorageEvent.prototype.newValue;

/**
 * @type {string}
 */
StorageEvent.prototype.url;

/**
 * @type {?Storage}
 */
StorageEvent.prototype.storageArea;

/**
 * @param {string} typeArg
 * @param {boolean} canBubbleArg
 * @param {boolean} cancelableArg
 * @param {string} keyArg
 * @param {?string} oldValueArg
 * @param {?string} newValueArg
 * @param {string} urlArg
 * @param {?Storage} storageAreaArg
 * @return {void}
 */
StorageEvent.prototype.initStorageEvent = function(typeArg, canBubbleArg,
                                                   cancelableArg, keyArg,
                                                   oldValueArg, newValueArg,
                                                   urlArg, storageAreaArg) {};

