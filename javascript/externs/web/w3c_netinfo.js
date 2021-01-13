/*
 * Copyright 2017 The Closure Compiler Authors.
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
 * @fileoverview Externs for the Network Information API.
 * @externs
 */

/**
 * @see http://wicg.github.io/netinfo/#-dfn-networkinformation-dfn-interface
 * @constructor
 */
function NetworkInformation() {}

/** @type {ConnectionType} */
NetworkInformation.prototype.type;

/** @type {EffectiveConnectionType} */
NetworkInformation.prototype.effectiveType;

/** @type {Megabit} */
NetworkInformation.prototype.downlinkMax;

/** @type {Megabit} */
NetworkInformation.prototype.downlink;

/** @type {Millisecond} */
NetworkInformation.prototype.rtt;

/** @type {?function(Event)} */
NetworkInformation.prototype.onchange;

/** @type {boolean} */
NetworkInformation.prototype.saveData;

/**
 * @typedef {number}
 */
var Megabit;

/**
 * @typedef {number}
 */
var Millisecond;

/**
 * Enum of:
 * 'bluetooth',
 * 'cellular',
 * 'ethernet',
 * 'mixed',
 * 'none',
 * 'other',
 * 'unknown',
 * 'wifi',
 * 'wimax'
 * @typedef {string}
 */
var ConnectionType;

/**
 * Enum of:
 * '2g',
 * '3g',
 * '4g',
 * 'slow-2g'
 * @typedef {string}
 */
var EffectiveConnectionType;

/** @type {!NetworkInformation} */
Navigator.prototype.connection;
