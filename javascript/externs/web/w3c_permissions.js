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
 * @fileoverview Definitions for W3C's Permissions API.
 * @see https://w3c.github.io/permissions/
 *
 * @externs
 */


/**
 * @typedef {{name: PermissionName}}
 * @see https://w3c.github.io/permissions/#permission-descriptor
 */
var PermissionDescriptor;


/**
 * @typedef {{name: PermissionName, userVisibleOnly: boolean}}
 * @see https://w3c.github.io/permissions/#push
 */
var PushPermissionDescriptor;


/**
 * @typedef {{name: PermissionName, sysex: boolean}}
 * @see https://w3c.github.io/permissions/#midi
 */
var MidiPermissionDescriptor;


/**
 * Set of possible values: 'geolocation', 'notifications', 'push', 'midi'.
 * @typedef {string}
 * @see https://w3c.github.io/permissions/#idl-def-PermissionName
 */
var PermissionName;


/**
 * Set of possible values: 'granted', 'denied', 'prompt'.
 * @typedef {string}
 * @see https://w3c.github.io/permissions/#idl-def-PermissionState
 */
var PermissionState;


/**
 * @constructor
 * @implements {EventTarget}
 * @see https://w3c.github.io/permissions/#status-of-a-permission
 */
function PermissionStatus() {}

/** @type {PermissionState} */
PermissionStatus.prototype.state;

/**
 * @type {PermissionState}
 * @deprecated, use PermissionStatus.state for newer clients
 */
PermissionStatus.prototype.status;

/** @type {?function(!Event)} */
PermissionStatus.prototype.onchange;

/**
 * @param {boolean=} opt_useCapture
 * @override
 * @return {undefined}
 */
PermissionStatus.prototype.addEventListener = function(type,
                                                       listener,
                                                       opt_useCapture) {};

/**
 * @param {boolean=} opt_useCapture
 * @override
 * @return {undefined}
 */
PermissionStatus.prototype.removeEventListener = function(type,
                                                          listener,
                                                          opt_useCapture) {};
/**
 * @override
 * @return {boolean}
 */
PermissionStatus.prototype.dispatchEvent = function(evt) {};


/**
 * @constructor
 * @see https://w3c.github.io/permissions/#idl-def-permissions
 */
function Permissions() {}

/**
 * @param {PermissionDescriptor} permission The permission to look up
 * @return {!Promise<!PermissionStatus>}
 * @see https://w3c.github.io/permissions/#dom-permissions-query
 */
Permissions.prototype.query = function(permission) {};


/** @type {Permissions} */
Navigator.prototype.permissions;
