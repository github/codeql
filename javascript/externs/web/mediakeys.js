/*
 * Copyright 2015 The Closure Compiler authors
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
 * @fileoverview MediaKey externs.
 * Based on {@link https://w3c.github.io/encrypted-media/ EME draft 5 December
 * 2019}.
 * @externs
 */


/**
 * @typedef {{
 *   contentType: string,
 *   encryptionScheme: (?string|undefined),
 *   robustness: (string|undefined)
 * }}
 * @see https://w3c.github.io/encrypted-media/#mediakeysystemmediacapability-dictionary
 */
var MediaKeySystemMediaCapability;


/** @typedef {{
 *   label: (string|undefined),
 *   initDataTypes: (!Array<string>|undefined),
 *   audioCapabilities: (!Array<!MediaKeySystemMediaCapability>|undefined),
 *   videoCapabilities: (!Array<!MediaKeySystemMediaCapability>|undefined),
 *   distinctiveIdentifier: (string|undefined),
 *   persistentState: (string|undefined),
 *   sessionTypes: (!Array<string>|undefined)
 * }}
 * @see https://w3c.github.io/encrypted-media/#mediakeysystemconfiguration-dictionary
 */
var MediaKeySystemConfiguration;


/**
 * @param {string} keySystem
 * @param {!Array<!MediaKeySystemConfiguration>} supportedConfigurations
 * @return {!Promise<!MediaKeySystemAccess>}
 * @see https://w3c.github.io/encrypted-media/#navigator-extension-requestmediakeysystemaccess
 */
Navigator.prototype.requestMediaKeySystemAccess =
    function(keySystem, supportedConfigurations) {};


/** @const {MediaKeys} */
HTMLMediaElement.prototype.mediaKeys;


/**
 * @param {MediaKeys} mediaKeys
 * @return {!Promise}
 * @see https://w3c.github.io/encrypted-media/#dom-htmlmediaelement-setmediakeys
 */
HTMLMediaElement.prototype.setMediaKeys = function(mediaKeys) {};



/**
 * @interface
 * @see https://w3c.github.io/encrypted-media/#mediakeysystemaccess-interface
 */
function MediaKeySystemAccess() {}


/** @return {!Promise<!MediaKeys>} */
MediaKeySystemAccess.prototype.createMediaKeys = function() {};


/** @return {!MediaKeySystemConfiguration} */
MediaKeySystemAccess.prototype.getConfiguration = function() {};


/** @const {string} */
MediaKeySystemAccess.prototype.keySystem;



/**
 * @interface
 * @see https://w3c.github.io/encrypted-media/#mediakeys-interface
 */
function MediaKeys() {}


/**
 * @param {string=} opt_sessionType defaults to "temporary"
 * @return {!MediaKeySession}
 * @throws {TypeError} if opt_sessionType is invalid.
 */
MediaKeys.prototype.createSession = function(opt_sessionType) {};


/**
 * @param {!BufferSource} serverCertificate
 * @return {!Promise}
 */
MediaKeys.prototype.setServerCertificate = function(serverCertificate) {};



/**
 * @interface
 * @see https://w3c.github.io/encrypted-media/#mediakeystatusmap-interface
 */
function MediaKeyStatusMap() {}


/** @const {number} */
MediaKeyStatusMap.prototype.size;


/**
 * Array entry 0 is the key, 1 is the value.
 * @return {!Iterator<!Array<!BufferSource|string>>}
 */
MediaKeyStatusMap.prototype.entries = function() {};


/**
 * The function is called with each value.
 * @param {function(string, !BufferSource)} callback A callback function to run for
 *     each media key. The first parameter is the key status; the second
 *     parameter is the key ID.
 * @return {undefined}
 */
MediaKeyStatusMap.prototype.forEach = function(callback) {};


/**
 * @param {!BufferSource} keyId
 * @return {string|undefined}
 */
MediaKeyStatusMap.prototype.get = function(keyId) {};


/**
 * @param {!BufferSource} keyId
 * @return {boolean}
 */
MediaKeyStatusMap.prototype.has = function(keyId) {};


/**
 * @return {!Iterator<!BufferSource>}
 */
MediaKeyStatusMap.prototype.keys = function() {};


/**
 * @return {!Iterator<string>}
 */
MediaKeyStatusMap.prototype.values = function() {};



/**
 * @interface
 * @extends {EventTarget}
 * @see https://w3c.github.io/encrypted-media/#mediakeysession-interface
 */
function MediaKeySession() {}


/** @const {string} */
MediaKeySession.prototype.sessionId;


/** @const {number} */
MediaKeySession.prototype.expiration;


/** @const {!Promise} */
MediaKeySession.prototype.closed;


/** @const {!MediaKeyStatusMap} */
MediaKeySession.prototype.keyStatuses;


/**
 * @param {string} initDataType
 * @param {!BufferSource} initData
 * @return {!Promise}
 */
MediaKeySession.prototype.generateRequest = function(initDataType, initData) {};


/**
 * @param {string} sessionId
 * @return {!Promise<boolean>}}
 */
MediaKeySession.prototype.load = function(sessionId) {};


/**
 * @param {!BufferSource} response
 * @return {!Promise}
 */
MediaKeySession.prototype.update = function(response) {};


/** @return {!Promise} */
MediaKeySession.prototype.close = function() {};


/** @return {!Promise} */
MediaKeySession.prototype.remove = function() {};


/** @override */
MediaKeySession.prototype.addEventListener = function(
    type, listener, opt_options) {};


/** @override */
MediaKeySession.prototype.removeEventListener = function(
    type, listener, opt_options) {};


/** @override */
MediaKeySession.prototype.dispatchEvent = function(evt) {};

/**
 * @record
 * @extends {EventInit}
 * @see https://w3c.github.io/encrypted-media/#dom-mediakeymessageeventinit
 */
function MediaKeyMessageEventInit() {};

/** @type {string} */
MediaKeyMessageEventInit.prototype.messageType;

/** @type {!ArrayBuffer} */
MediaKeyMessageEventInit.prototype.message;


/**
 * @constructor
 * @param {string} type
 * @param {MediaKeyMessageEventInit} eventInitDict
 * @extends {Event}
 * @see https://w3c.github.io/encrypted-media/#mediakeymessageevent
 */
function MediaKeyMessageEvent(type, eventInitDict) {}


/** @const {string} */
MediaKeyMessageEvent.prototype.messageType;


/** @const {!ArrayBuffer} */
MediaKeyMessageEvent.prototype.message;


/** @const {!MediaKeySession} */
MediaKeyMessageEvent.prototype.target;

/**
 * @record
 * @extends {EventInit}
 * @see https://w3c.github.io/encrypted-media/#dom-mediaencryptedeventinit
 */
function MediaEncryptedEventInit() {};

/** @type {(string | undefined)} */
MediaEncryptedEventInit.prototype.initDataType;

/** @type {(ArrayBuffer | undefined)} */
MediaEncryptedEventInit.prototype.initData;

/**
 * @constructor
 * @param {string} type
 * @param {MediaEncryptedEventInit=} opt_eventInitDict
 * @extends {Event}
 * @see https://w3c.github.io/encrypted-media/#mediaencryptedevent
 */
function MediaEncryptedEvent(type, opt_eventInitDict) {}


/** @const {string} */
MediaEncryptedEvent.prototype.initDataType;


/** @const {ArrayBuffer} */
MediaEncryptedEvent.prototype.initData;


/** @const {!HTMLMediaElement} */
MediaEncryptedEvent.prototype.target;

