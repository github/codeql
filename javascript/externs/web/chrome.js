/*
 * Copyright 2013 The Closure Compiler Authors
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
 * @fileoverview Definitions for globals in Chrome.  This file describes the
 * externs API for the chrome.* object when running in a normal browser
 * context.  For APIs available in Chrome Extensions, see chrome_extensions.js
 * in this directory.
 * @externs
 */


/**
 * namespace
 * @const
 */
var chrome = {};


/**
 * @see http://developer.chrome.com/apps/runtime.html#type-Port
 * @constructor
 */
function Port() {}


/** @type {string} */
Port.prototype.name;


/** @type {!ChromeEvent} */
Port.prototype.onDisconnect;


/** @type {!ChromeEvent} */
Port.prototype.onMessage;


/** @type {!MessageSender|undefined} */
Port.prototype.sender;


/**
 * @param {*} obj Message object.
 * @return {undefined}
 */
Port.prototype.postMessage = function(obj) {};


/** @return {undefined} */
Port.prototype.disconnect = function() {};


/**
 * @see https://developer.chrome.com/extensions/events.html
 * @constructor
 * TODO(tbreisacher): Update *Listener methods to take {function()}
 * instead of {!Function}. See discussion at go/ChromeEvent-TODO
 */
function ChromeEvent() {}


/**
 * @param {!Function} callback
 * @return {undefined}
 */
ChromeEvent.prototype.addListener = function(callback) {};


/**
 * @param {!Function} callback
 * @return {undefined}
 */
ChromeEvent.prototype.removeListener = function(callback) {};


/**
 * @param {!Function} callback
 * @return {boolean}
 */
ChromeEvent.prototype.hasListener = function(callback) {};


/** @return {boolean} */
ChromeEvent.prototype.hasListeners = function() {};

// TODO(tbreisacher): Add the addRules, getRules, and removeRules methods?



/**
 * Event whose listeners take a string parameter.
 * @constructor
 */
function ChromeStringEvent() {}


/**
 * @param {function(string): void} callback
 * @return {undefined}
 */
ChromeStringEvent.prototype.addListener = function(callback) {};


/**
 * @param {function(string): void} callback
 * @return {undefined}
 */
ChromeStringEvent.prototype.removeListener = function(callback) {};


/**
 * @param {function(string): void} callback
 * @return {boolean}
 */
ChromeStringEvent.prototype.hasListener = function(callback) {};


/** @return {boolean} */
ChromeStringEvent.prototype.hasListeners = function() {};



/**
 * Event whose listeners take a boolean parameter.
 * @constructor
 */

function ChromeBooleanEvent() {}


/**
 * @param {function(boolean): void} callback
 * @return {undefined}
 */
ChromeBooleanEvent.prototype.addListener = function(callback) {};


/**
 * @param {function(boolean): void} callback
 * @return {undefined}
 */
ChromeBooleanEvent.prototype.removeListener = function(callback) {};


/**
 * @param {function(boolean): void} callback
 * @return {boolean}
 */
ChromeBooleanEvent.prototype.hasListener = function(callback) {};


/**
 * @return {boolean}
 */
ChromeBooleanEvent.prototype.hasListeners = function() {};



/**
 * Event whose listeners take a number parameter.
 * @constructor
 */

function ChromeNumberEvent() {}


/**
 * @param {function(number): void} callback
 * @return {undefined}
 */
ChromeNumberEvent.prototype.addListener = function(callback) {};


/**
 * @param {function(number): void} callback
 * @return {undefined}
 */
ChromeNumberEvent.prototype.removeListener = function(callback) {};


/**
 * @param {function(number): void} callback
 * @return {boolean}
 */
ChromeNumberEvent.prototype.hasListener = function(callback) {};


/**
 * @return {boolean}
 */
ChromeNumberEvent.prototype.hasListeners = function() {};



/**
 * Event whose listeners take an Object parameter.
 * @constructor
 */
function ChromeObjectEvent() {}


/**
 * @param {function(!Object): void} callback Callback.
 * @return {undefined}
 */
ChromeObjectEvent.prototype.addListener = function(callback) {};


/**
 * @param {function(!Object): void} callback Callback.
 * @return {undefined}
 */
ChromeObjectEvent.prototype.removeListener = function(callback) {};


/**
 * @param {function(!Object): void} callback Callback.
 * @return {boolean}
 */
ChromeObjectEvent.prototype.hasListener = function(callback) {};


/**
 * @return {boolean}
 */
ChromeObjectEvent.prototype.hasListeners = function() {};



/**
 * Event whose listeners take a string array parameter.
 * @constructor
 */
function ChromeStringArrayEvent() {}


/**
 * @param {function(!Array<string>): void} callback
 * @return {undefined}
 */
ChromeStringArrayEvent.prototype.addListener = function(callback) {};


/**
 * @param {function(!Array<string>): void} callback
 * @return {undefined}
 */
ChromeStringArrayEvent.prototype.removeListener = function(callback) {};


/**
 * @param {function(!Array<string>): void} callback
 * @return {boolean}
 */
ChromeStringArrayEvent.prototype.hasListener = function(callback) {};


/** @return {boolean} */
ChromeStringArrayEvent.prototype.hasListeners = function() {};



/**
 * Event whose listeners take two strings as parameters.
 * @constructor
 */
function ChromeStringStringEvent() {}


/**
 * @param {function(string, string): void} callback
 * @return {undefined}
 */
ChromeStringStringEvent.prototype.addListener = function(callback) {};


/**
 * @param {function(string, string): void} callback
 * @return {undefined}
 */
ChromeStringStringEvent.prototype.removeListener = function(callback) {};


/**
 * @param {function(string, string): void} callback
 * @return {boolean}
 */
ChromeStringStringEvent.prototype.hasListener = function(callback) {};


/** @return {boolean} */
ChromeStringStringEvent.prototype.hasListeners = function() {};



/**
 * @see http://developer.chrome.com/extensions/runtime.html#type-MessageSender
 * @constructor
 */
function MessageSender() {}


/** @type {!Tab|undefined} */
MessageSender.prototype.tab;


/** @type {number|undefined} */
MessageSender.prototype.frameId;


/** @type {string|undefined} */
MessageSender.prototype.id;


/** @type {string|undefined} */
MessageSender.prototype.url;


/** @type {string|undefined} */
MessageSender.prototype.tlsChannelId;


/**
 * @enum {string}
 * @see https://developer.chrome.com/extensions/tabs#type-MutedInfoReason
 */
var MutedInfoReason = {
  USER: '',
  CAPTURE: '',
  EXTENSION: '',
};


/**
 * @see https://developer.chrome.com/extensions/tabs#type-MutedInfo
 * @constructor
 */
var MutedInfo = function() {};


/** @type {boolean} */
MutedInfo.prototype.muted;


/** @type {!MutedInfoReason|string|undefined} */
MutedInfo.prototype.reason;


/** @type {string|undefined} */
MutedInfo.prototype.extensionId;




/**
 * @see https://developer.chrome.com/extensions/tabs#type-Tab
 * @constructor
 */
function Tab() {}


// TODO: Make this field optional once dependent projects have been updated.
/** @type {number} */
Tab.prototype.id;


/** @type {number} */
Tab.prototype.index;


/** @type {number} */
Tab.prototype.windowId;


// TODO: Make this field optional once dependent projects have been updated.
/** @type {number} */
Tab.prototype.openerTabId;


/** @type {boolean} */
Tab.prototype.highlighted;


/** @type {boolean} */
Tab.prototype.active;


/** @type {boolean} */
Tab.prototype.pinned;


/** @type {boolean|undefined} */
Tab.prototype.audible;


/** @type {boolean} */
Tab.prototype.discarded;


/** @type {boolean} */
Tab.prototype.autoDiscardable;


/** @type {!MutedInfo|undefined} */
Tab.prototype.mutedInfo;


// TODO: Make this field optional once dependent projects have been updated.
/** @type {string} */
Tab.prototype.url;


// TODO: Make this field optional once dependent projects have been updated.
/** @type {string} */
Tab.prototype.title;


// TODO: Make this field optional once dependent projects have been updated.
/** @type {string} */
Tab.prototype.favIconUrl;


// TODO: Make this field optional once dependent projects have been updated.
/** @type {string} */
Tab.prototype.status;


/** @type {boolean} */
Tab.prototype.incognito;


/** @type {number|undefined} */
Tab.prototype.width;


/** @type {number|undefined} */
Tab.prototype.height;


/** @type {string|undefined} */
Tab.prototype.sessionId;


/** @const */
chrome.app = {};

/**
 * @see https://developer.chrome.com/webstore/inline_installation#already-installed
 * @type {boolean}
 */
chrome.app.isInstalled;

/**
 * @const
 * @see https://developer.chrome.com/apps/webstore
 */
chrome.webstore = {};


/**
 * @param {string|function()|function(string, string=)=}
 *     opt_urlOrSuccessCallbackOrFailureCallback Either the URL to install or
 *     the succcess callback taking no arg or the failure callback taking an
 *     error string arg.
 * @param {function()|function(string, string=)=}
 *     opt_successCallbackOrFailureCallback Either the succcess callback taking
 *     no arg or the failure callback taking an error string arg.
 * @param {function(string, string=)=} opt_failureCallback The failure callback.
 * @return {undefined}
 */
chrome.webstore.install = function(
    opt_urlOrSuccessCallbackOrFailureCallback,
    opt_successCallbackOrFailureCallback,
    opt_failureCallback) {};


/** @type {!ChromeStringEvent} */
chrome.webstore.onInstallStageChanged;


/** @type {!ChromeNumberEvent} */
chrome.webstore.onDownloadProgress;


/**
 * @see https://developer.chrome.com/extensions/runtime.html
 * @const
 */
chrome.runtime = {};


/** @type {!Object|undefined} */
chrome.runtime.lastError = {};


/** @type {string|undefined} */
chrome.runtime.lastError.message;


/**
 * @param {string|!Object=} opt_extensionIdOrConnectInfo Either the
 *     extensionId to connect to, in which case connectInfo params can be
 *     passed in the next optional argument, or the connectInfo params.
 * @param {!Object=} opt_connectInfo The connectInfo object,
 *     if arg1 was the extensionId to connect to.
 * @return {!Port} New port.
 */
chrome.runtime.connect = function(
    opt_extensionIdOrConnectInfo, opt_connectInfo) {};


/**
 * @param {string|*} extensionIdOrMessage Either the extensionId to send the
 *     message to, in which case the message is passed as the next arg, or the
 *     message itself.
 * @param {(*|!Object|function(*): void)=} opt_messageOrOptsOrCallback
 *     One of:
 *     The message, if arg1 was the extensionId.
 *     The options for message sending, if arg1 was the message and this
 *     argument is not a function.
 *     The callback, if arg1 was the message and this argument is a function.
 * @param {(!Object|function(*): void)=} opt_optsOrCallback
 *     Either the options for message sending, if arg2 was the message,
 *     or the callback.
 * @param {function(*): void=} opt_callback The callback function which
 *     takes a JSON response object sent by the handler of the request.
 * @return {undefined}
 */
chrome.runtime.sendMessage = function(
    extensionIdOrMessage, opt_messageOrOptsOrCallback, opt_optsOrCallback,
    opt_callback) {};


/**
 * Returns an object representing current load times. Note that the properties
 * on the object do not change and the function must be called again to get
 * up-to-date data.
 *
 * @return {!ChromeLoadTimes}
 */
chrome.loadTimes = function() {};



/**
 * The data object given by chrome.loadTimes().
 * @constructor
 */
function ChromeLoadTimes() {}


/** @type {number} */
ChromeLoadTimes.prototype.requestTime;


/** @type {number} */
ChromeLoadTimes.prototype.startLoadTime;


/** @type {number} */
ChromeLoadTimes.prototype.commitLoadTime;


/** @type {number} */
ChromeLoadTimes.prototype.finishDocumentLoadTime;


/** @type {number} */
ChromeLoadTimes.prototype.finishLoadTime;


/** @type {number} */
ChromeLoadTimes.prototype.firstPaintTime;


/** @type {number} */
ChromeLoadTimes.prototype.firstPaintAfterLoadTime;


/** @type {number} */
ChromeLoadTimes.prototype.navigationType;


/**
 * True iff the resource was fetched over SPDY.
 * @type {boolean}
 */
ChromeLoadTimes.prototype.wasFetchedViaSpdy;


/** @type {boolean} */
ChromeLoadTimes.prototype.wasNpnNegotiated;


/** @type {string} */
ChromeLoadTimes.prototype.npnNegotiatedProtocol;


/** @type {boolean} */
ChromeLoadTimes.prototype.wasAlternateProtocolAvailable;


/** @type {string} */
ChromeLoadTimes.prototype.connectionInfo;


/**
 * Returns an object containing timing information.
 * @return {!ChromeCsiInfo}
 */
chrome.csi = function() {};



/**
 * The data object given by chrome.csi().
 * @constructor
 */
function ChromeCsiInfo() {}


/**
 * Same as chrome.loadTimes().requestTime, if defined.
 * Otherwise, gives the same value as chrome.loadTimes().startLoadTime.
 * In milliseconds, truncated.
 * @type {number}
 */
ChromeCsiInfo.prototype.startE;


/**
 * Same as chrome.loadTimes().finishDocumentLoadTime but in milliseconds and
 * truncated.
 * @type {number}
 */
ChromeCsiInfo.prototype.onloadT;


/**
 * The time since startE in milliseconds.
 * @type {number}
 */
ChromeCsiInfo.prototype.pageT;


/** @type {number} */
ChromeCsiInfo.prototype.tran;


/**
 * @param {string|!ArrayBuffer|!Object} message
 * @see https://developers.google.com/native-client/devguide/tutorial
 * @return {undefined}
 */
HTMLEmbedElement.prototype.postMessage = function(message) {};
