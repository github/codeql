/*
 * Copyright 2016 The Closure Compiler Authors
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
 * @fileoverview Definitions for WKWebView's User Content interface.
 *   https://developer.apple.com/library/prerelease/ios/documentation/WebKit/Reference/WKUserContentController_Ref/
 *   https://trac.webkit.org/browser/trunk/Source/WebCore/page/WebKitNamespace.h
 *
 * @externs
 */

/** @constructor */
function WebKitNamespace() {}


/**
 * @type {!UserMessageHandlersNamespace}
 */
WebKitNamespace.prototype.messageHandlers;


/**
 * @constructor
 * @implements {IObject<string, UserMessageHandler>}
 */
function UserMessageHandlersNamespace() {}


/** @constructor */
function UserMessageHandler() {}


/**
 * @param {*} message
 * @return {undefined}
 */
UserMessageHandler.prototype.postMessage = function(message) {};


/**
 * @type {!WebKitNamespace}
 * @const
 */
var webkit;
