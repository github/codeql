/*
 * Copyright 2018 The Closure Compiler Authors.
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
 * @fileoverview Definitions for ECMAScript 6 Proxy objects.
 * @see https://tc39.github.io/ecma262/#sec-proxy-objects
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy
 * @externs
 */


/**
 * @record
 * @template TARGET
 * @see https://tc39.github.io/ecma262/#sec-proxy-object-internal-methods-and-internal-slots
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy/handler
 */
function ProxyHandler() {}

/**
 * @type {(function(TARGET):?Object)|undefined}
 * @see https://tc39.github.io/ecma262/#sec-proxy-object-internal-methods-and-internal-slots-getprototypeof
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy/handler/getPrototypeOf
 */
ProxyHandler.prototype.getPrototypeOf /* = function(target) {} */;

/**
 * @type {(function(TARGET, ?Object):boolean)|undefined}
 * @see https://tc39.github.io/ecma262/#sec-proxy-object-internal-methods-and-internal-slots-setprototypeof-v
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy/handler/setPrototypeOf
 */
ProxyHandler.prototype.setPrototypeOf /* = function(target, proto) {} */;

/**
 * @type {(function(TARGET):boolean)|undefined}
 * @see https://tc39.github.io/ecma262/#sec-proxy-object-internal-methods-and-internal-slots-isextensible
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy/handler/isExtensible
 */
ProxyHandler.prototype.isExtensible /* = function(target) {} */;

/**
 * @type {(function(TARGET):boolean)|undefined}
 * @see https://tc39.github.io/ecma262/#sec-proxy-object-internal-methods-and-internal-slots-preventextensions
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy/handler/preventExtensions
 */
ProxyHandler.prototype.preventExtensions /* = function(target) {} */;

/**
 * @type {(function(TARGET, (string|symbol)):(!ObjectPropertyDescriptor|undefined))|undefined}
 * @see https://tc39.github.io/ecma262/#sec-proxy-object-internal-methods-and-internal-slots-getownproperty-p
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy/handler/getOwnPropertyDescriptor
 */
ProxyHandler.prototype.getOwnPropertyDescriptor /* = function(target, prop) {} */;

/**
 * @type {(function(TARGET, (string|symbol), !ObjectPropertyDescriptor):boolean)|undefined}
 * @see https://tc39.github.io/ecma262/#sec-proxy-object-internal-methods-and-internal-slots-defineownproperty-p-desc
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy/handler/defineProperty
 */
ProxyHandler.prototype.defineProperty /* = function(target, prop, desc) {} */;

/**
 * @type {(function(TARGET, (string|symbol)):boolean)|undefined}
 * @see https://tc39.github.io/ecma262/#sec-proxy-object-internal-methods-and-internal-slots-hasproperty-p
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy/handler/has
 */
ProxyHandler.prototype.has /* = function(target, prop) {} */;

/**
 * @type {(function(TARGET, (string|symbol), !Object):*)|undefined}
 * @see https://tc39.github.io/ecma262/#sec-proxy-object-internal-methods-and-internal-slots-get-p-receiver
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy/handler/get
 */
ProxyHandler.prototype.get /* = function(target, prop, receiver) {} */;

/**
 * @type {(function(TARGET, (string|symbol), *, !Object):boolean)|undefined}
 * @see https://tc39.github.io/ecma262/#sec-proxy-object-internal-methods-and-internal-slots-set-p-v-receiver
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy/handler/set
 */
ProxyHandler.prototype.set /* = function(target, prop, value, receiver) {} */;

/**
 * @type {(function(TARGET, (string|symbol)):boolean)|undefined}
 * @see https://tc39.github.io/ecma262/#sec-proxy-object-internal-methods-and-internal-slots-delete-p
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy/handler/deleteProperty
 */
ProxyHandler.prototype.deleteProperty /* = function (target, prop) {} */;

/**
 * @type {(function(TARGET):!Array<(string|symbol)>)|undefined}
 * @see https://tc39.github.io/ecma262/#sec-proxy-object-internal-methods-and-internal-slots-ownpropertykeys
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy/handler/ownKeys
 */
ProxyHandler.prototype.ownKeys /* = function(target) {} */;

/**
 * @type {(function(TARGET, *, !Array):*)|undefined}
 * @see https://tc39.github.io/ecma262/#sec-proxy-object-internal-methods-and-internal-slots-call-thisargument-argumentslist
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy/handler/apply
 */
ProxyHandler.prototype.apply /* = function(target, thisArg, argList) {} */;

/**
 * @type {(function(TARGET, !Array, function(new: ?, ...?)):!Object)|undefined}
 * @see https://tc39.github.io/ecma262/#sec-proxy-object-internal-methods-and-internal-slots-construct-argumentslist-newtarget
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy/handler/construct
 */
ProxyHandler.prototype.construct /* = function(target, argList, newTarget) {} */;


/**
 * @constructor
 * @param {TARGET} target
 * @param {!ProxyHandler<TARGET>} handler
 * @template TARGET
 * @see https://tc39.github.io/ecma262/#sec-proxy-constructor
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy#Syntax
 */
function Proxy(target, handler) {}

/**
 * @param {TARGET} target
 * @param {!ProxyHandler<TARGET>} handler
 * @return {{proxy: !Proxy<TARGET>, revoke: function():void}}
 * @template TARGET
 * @see https://tc39.github.io/ecma262/#sec-proxy.revocable
 * @see https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Proxy/revocable
 */
Proxy.revocable = function(target, handler) {};
