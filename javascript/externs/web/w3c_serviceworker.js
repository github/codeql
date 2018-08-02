/*
 * Copyright 2014 The Closure Compiler Authors
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
 * @fileoverview Externs for service worker.
 *
 * @see http://www.w3.org/TR/service-workers/
 * @externs
 */

/**
 * @see http://www.w3.org/TR/service-workers/#service-worker-interface
 * @constructor
 * @extends {Worker}
 */
function ServiceWorker() {}

/** @type {string} */
ServiceWorker.prototype.scriptURL;

/** @type {ServiceWorkerState} */
ServiceWorker.prototype.state;

/** @type {?function(!Event)} */
ServiceWorker.prototype.onstatechange;

/**
 *  Set of possible string values: 'installing', 'installed', 'activating',
 * 'activated', 'redundant'.
 *  @typedef {string}
 */
var ServiceWorkerState ;

/**
 * @see https://w3c.github.io/push-api/
 * @constructor
 */
function PushSubscription() {}

/** @type {string} */
PushSubscription.prototype.endpoint;

/**
 * Please note there is an intent to deprecate this field in Chrome 43 or 44.
 * See https://www.chromestatus.com/feature/5283829761703936.
 * @type {string}
 */
PushSubscription.prototype.subscriptionId;

/** @return {!Promise<boolean>} */
PushSubscription.prototype.unsubscribe = function() {};

/** @enum {string} */
// This is commented out since it has not been implemented yet in Chrome beta.
// Uncomment once it is available.
// var PushPermissionStatus  = {
//  GRANTED: 'granted',
//  DENIED: 'denied',
//  DEFAULT: 'default'
//};

/**
 * @see https://w3c.github.io/push-api/#idl-def-PushManager
 * @constructor
 */
function PushManager() {}

/**
 * @param {PushSubscriptionOptions=} opt_options
 * @return {!Promise<PushSubscription>}
 */
PushManager.prototype.subscribe = function(opt_options) {};

/** @return {!Promise<PushSubscription>} */
PushManager.prototype.getSubscription = function() {};

/** @return {!Promise<PushPermissionStatus>} */
// This is commented out since it has not been implemented yet in Chrome beta.
// Uncomment once it is available.
// PushManager.prototype.hasPermission = function() {};

/**
 * @typedef {{userVisibleOnly: (boolean|undefined)}}
 * @see https://w3c.github.io/push-api/#idl-def-PushSubscriptionOptions
 */
var PushSubscriptionOptions;

/**
 * @see http://www.w3.org/TR/push-api/#idl-def-PushMessageData
 * @constructor
 */
function PushMessageData() {}

/** @return {!ArrayBuffer} */
PushMessageData.prototype.arrayBuffer = function() {};

/** @return {!Blob} */
PushMessageData.prototype.blob = function() {};

/** @return {*} */
PushMessageData.prototype.json = function() {};

/** @return {string} */
PushMessageData.prototype.text = function() {};


/**
 * @see http://www.w3.org/TR/push-api/#idl-def-PushEvent
 * @constructor
 * @param {string} type
 * @param {!ExtendableEventInit=} opt_eventInitDict
 * @extends {ExtendableEvent}
 */
function PushEvent(type, opt_eventInitDict) {}

/** @type {?PushMessageData} */
PushEvent.prototype.data;


/**
 * @see http://www.w3.org/TR/service-workers/#service-worker-registration-interface
 * @interface
 * @extends {EventTarget}
 */
function ServiceWorkerRegistration() {}

/** @type {ServiceWorker} */
ServiceWorkerRegistration.prototype.installing;

/** @type {ServiceWorker} */
ServiceWorkerRegistration.prototype.waiting;

/** @type {ServiceWorker} */
ServiceWorkerRegistration.prototype.active;

/** @type {string} */
ServiceWorkerRegistration.prototype.scope;

/** @return {!Promise<boolean>} */
ServiceWorkerRegistration.prototype.unregister = function() {};

/** @type {?function(!Event)} */
ServiceWorkerRegistration.prototype.onupdatefound;

/** @return {!Promise<void>} */
ServiceWorkerRegistration.prototype.update = function() {};

/**
 * @see https://w3c.github.io/push-api/
 * @type {!PushManager}
 */
ServiceWorkerRegistration.prototype.pushManager;

/**
 * @see https://notifications.spec.whatwg.org/#service-worker-api
 * @param {string} title
 * @param {NotificationOptions=} opt_options
 * @return {!Promise<void>}
 */
ServiceWorkerRegistration.prototype.showNotification =
    function(title, opt_options) {};

/**
 * @see https://notifications.spec.whatwg.org/#service-worker-api
 * @param {!GetNotificationOptions=} opt_filter
 * @return {!Promise<?Array<?Notification>>}
 */
ServiceWorkerRegistration.prototype.getNotifications = function(opt_filter) {};

/**
 * @see http://www.w3.org/TR/service-workers/#service-worker-container-interface
 * @interface
 * @extends {EventTarget}
 */
function ServiceWorkerContainer() {}

/** @type {?ServiceWorker} */
ServiceWorkerContainer.prototype.controller;

/** @type {!Promise<!ServiceWorkerRegistration>} */
ServiceWorkerContainer.prototype.ready;

/**
 * @param {string} scriptURL
 * @param {RegistrationOptions=} opt_options
 * @return {!Promise<!ServiceWorkerRegistration>}
 */
ServiceWorkerContainer.prototype.register = function(scriptURL, opt_options) {};

/**
 * @param {string=} opt_documentURL
 * @return {!Promise<!ServiceWorkerRegistration|undefined>}
 */
ServiceWorkerContainer.prototype.getRegistration = function(opt_documentURL) {};

/**
 * @return {!Promise<Array<!ServiceWorkerRegistration>>}
 */
ServiceWorkerContainer.prototype.getRegistrations = function() {};

/** @type {?function(!Event)} */
ServiceWorkerContainer.prototype.oncontrollerchange;

/** @type {?function(!ErrorEvent)} */
ServiceWorkerContainer.prototype.onerror;

/**
 * @typedef {{scope: (string|undefined), useCache: (boolean|undefined)}}
 */
var RegistrationOptions;

/** @type {!ServiceWorkerContainer} */
Navigator.prototype.serviceWorker;

/**
 * @see http://www.w3.org/TR/service-workers/#service-worker-global-scope-interface
 * @interface
 * @extends {WorkerGlobalScope}
 */
function ServiceWorkerGlobalScope() {}

/** @type {!Cache} */
ServiceWorkerGlobalScope.prototype.scriptCache;

/** @type {!CacheStorage} */
ServiceWorkerGlobalScope.prototype.caches;

/** @type {!ServiceWorkerClients} */
ServiceWorkerGlobalScope.prototype.clients;

/** @type {string} */
ServiceWorkerGlobalScope.prototype.scope;

/** @type {!ServiceWorkerRegistration} */
ServiceWorkerGlobalScope.prototype.registration;

/** @return {!Promise<void>} */
ServiceWorkerGlobalScope.prototype.skipWaiting = function() {};

/** @type {!Console} */
ServiceWorkerGlobalScope.prototype.console;

/** @type {?function(!InstallEvent)} */
ServiceWorkerGlobalScope.prototype.oninstall;

/** @type {?function(!ExtendableEvent)} */
ServiceWorkerGlobalScope.prototype.onactivate;

/** @type {?function(!FetchEvent)} */
ServiceWorkerGlobalScope.prototype.onfetch;

/**
 * TODO(mtragut): This handler should get a custom event in the future.
 * @type {?function(!Event)}
 */
ServiceWorkerGlobalScope.prototype.onbeforeevicted;

/**
 * TODO(mtragut): This handler should get a custom event in the future.
 * @type {?function(!Event)}
 */
ServiceWorkerGlobalScope.prototype.onevicted;

/** @type {?function(!MessageEvent)} */
ServiceWorkerGlobalScope.prototype.onmessage;

/** @type {!IDBFactory|undefined} */
ServiceWorkerGlobalScope.prototype.indexedDB;

/**
 * @see http://www.w3.org/TR/service-workers/#service-worker-client-interface
 * @constructor
 */
function ServiceWorkerClient() {}

/** @type {!Promise<void>} */
ServiceWorkerClient.prototype.ready;

/** @type {boolean} */
ServiceWorkerClient.prototype.hidden;

/** @type {boolean} */
ServiceWorkerClient.prototype.focused;

/** @type {VisibilityState} */
ServiceWorkerClient.prototype.visibilityState;

/** @type {string} */
ServiceWorkerClient.prototype.url;

/**
 * // TODO(mtragut): Possibly replace the type with enum ContextFrameType once
 * the enum is defined.
 * @type {string}
 */
ServiceWorkerClient.prototype.frameType;

/**
 * @param {*} message
 * @param {(!Array<!Transferable>|undefined)=} opt_transfer
 * @return {undefined}
 */
ServiceWorkerClient.prototype.postMessage = function(message, opt_transfer) {};

/** @return {!Promise} */
ServiceWorkerClient.prototype.focus = function() {};

/**
 * @see http://www.w3.org/TR/service-workers/#service-worker-clients-interface
 * @interface
 */
function ServiceWorkerClients() {}

/**
 * Deprecated in Chrome M43+, use matchAll instead. Reference:
 * https://github.com/slightlyoff/ServiceWorker/issues/610.
 * TODO(joeltine): Remove when getAll is fully deprecated.
 * @param {ServiceWorkerClientQueryOptions=} opt_options
 * @return {!Promise<!Array<!ServiceWorkerClient>>}
 */
ServiceWorkerClients.prototype.getAll = function(opt_options) {};

/**
 * @param {ServiceWorkerClientQueryOptions=} opt_options
 * @return {!Promise<!Array<!ServiceWorkerClient>>}
 */
ServiceWorkerClients.prototype.matchAll = function(opt_options) {};

/**
 * @return {!Promise<void>}
 */
ServiceWorkerClients.prototype.claim = function() {};

/**
 * @param {string} url
 * @return {!Promise<!ServiceWorkerClient>}
 */
ServiceWorkerClients.prototype.openWindow = function(url) {};

/** @typedef {{includeUncontrolled: (boolean|undefined)}} */
var ServiceWorkerClientQueryOptions;

/**
 * @see http://www.w3.org/TR/service-workers/#cache-interface
 * @interface
 */
function Cache() {}

/**
 * @param {!RequestInfo} request
 * @param {CacheQueryOptions=} opt_options
 * @return {!Promise<!Response|undefined>}
 */
Cache.prototype.match = function(request, opt_options) {};

/**
 * @param {RequestInfo=} opt_request
 * @param {CacheQueryOptions=} opt_options
 * @return {!Promise<!Array<!Response>>}
 */
Cache.prototype.matchAll = function(opt_request, opt_options) {};

/**
 * @param {!RequestInfo} request
 * @return {!Promise<void>}
 */
Cache.prototype.add = function(request) {};

/**
 * @param {!Array<!RequestInfo>} requests
 * @return {!Promise<void>}
 */
Cache.prototype.addAll = function(requests) {};

/**
 * @param {!RequestInfo} request
 * @param {!Response} response
 * @return {!Promise<void>}
 */
Cache.prototype.put = function(request, response) {};

/**
 * @param {!RequestInfo} request
 * @param {CacheQueryOptions=} opt_options
 * @return {!Promise<boolean>}
 */
Cache.prototype.delete = function(request, opt_options) {};

/**
 * @param {RequestInfo=} opt_request
 * @param {CacheQueryOptions=} opt_options
 * @return {!Promise<!Array<!Request>>}
 */
Cache.prototype.keys = function(opt_request, opt_options) {};

/**
 * @typedef {{
 *   ignoreSearch: (boolean|undefined),
 *   ignoreMethod: (boolean|undefined),
 *   ignoreVary: (boolean|undefined),
 *   prefixMatch: (boolean|undefined),
 *   cacheName: (string|undefined)
 * }}
 */
var CacheQueryOptions;

/**
 * @see http://www.w3.org/TR/service-workers/#cache-storage-interface
 * @interface
 */
function CacheStorage() {}

/**
 * Window instances have a property called caches which implements CacheStorage
 * @see https://www.w3.org/TR/service-workers/#cache-objects
 * @type {!CacheStorage}
 */
Window.prototype.caches;

/**
 * @param {!RequestInfo} request
 * @param {CacheQueryOptions=} opt_options
 * @return {!Promise<!Response|undefined>}
 */
CacheStorage.prototype.match = function(request, opt_options) {};

/**
 * @param {string} cacheName
 * @return {!Promise<boolean>}
 */
CacheStorage.prototype.has = function(cacheName) {};

/**
 * @param {string} cacheName
 * @return {!Promise<!Cache>}
 */
CacheStorage.prototype.open = function(cacheName) {};

/**
 * @param {string} cacheName
 * @return {!Promise<boolean>}
 */
CacheStorage.prototype.delete = function(cacheName) {};

/** @return {!Promise<!Array<string>>} */
CacheStorage.prototype.keys = function() {};

/**
 * @see http://www.w3.org/TR/service-workers/#extendable-event-interface
 * @constructor
 * @param {string} type
 * @param {ExtendableEventInit=} opt_eventInitDict
 * @extends {Event}
 */
function ExtendableEvent(type, opt_eventInitDict) {}

/**
 * @param {IThenable} f
 * @return {undefined}
 */
ExtendableEvent.prototype.waitUntil = function(f) {};

/**
 * @typedef {{
 *   bubbles: (boolean|undefined),
 *   cancelable: (boolean|undefined)
 * }}
 */
var ExtendableEventInit;

/**
 * @see http://www.w3.org/TR/service-workers/#install-event-interface
 * @constructor
 * @param {string} type
 * @param {InstallEventInit=} opt_eventInitDict
 * @extends {ExtendableEvent}
 */
function InstallEvent(type, opt_eventInitDict) {}

/** @type {ServiceWorker} */
ExtendableEvent.prototype.activeWorker;

/**
 * @typedef {{
 *   bubbles: (boolean|undefined),
 *   cancelable: (boolean|undefined),
 *   activeWorker: (!ServiceWorker|undefined)
 * }}
 */
var InstallEventInit;

/**
 * @see http://www.w3.org/TR/service-workers/#fetch-event-interface
 * @constructor
 * @param {string} type
 * @param {FetchEventInit=} opt_eventInitDict
 * @extends {Event}
 */
function FetchEvent(type, opt_eventInitDict) {}

/** @type {!Request} */
FetchEvent.prototype.request;

/** @type {!ServiceWorkerClient} */
FetchEvent.prototype.client;

/** @type {!boolean} */
FetchEvent.prototype.isReload;

/**
 * @param {(Response|Promise<Response>)} r
 * @return {undefined}
 */
FetchEvent.prototype.respondWith = function(r) {};

/**
 * @param {string} url
 * @return {!Promise<!Response>}
 */
FetchEvent.prototype.forwardTo = function(url) {};

/**
 * @return {!Promise<!Response>}
 */
FetchEvent.prototype.default = function() {};

/**
 * @typedef {{
 *   bubbles: (boolean|undefined),
 *   cancelable: (boolean|undefined),
 *   request: (!Request|undefined),
 *   client: (!ServiceWorkerClient|undefined),
 *   isReload: (!boolean|undefined)
 * }}
 */
var FetchEventInit;
