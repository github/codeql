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
 * @fileoverview Definitions for W3C's Battery Status API.
 *  The whole file has been fully type annotated. Created from
 *  http://www.w3.org/TR/2014/CR-battery-status-20141209/
 *
 * @externs
 */



/**
 * @interface
 * @extends {EventTarget}
 */
function BatteryManager() {}


/**
 * @type {boolean}
 */
BatteryManager.prototype.charging;


/**
 * @type {number}
 */
BatteryManager.prototype.chargingTime;


/**
 * @type {number}
 */
BatteryManager.prototype.dischargingTime;


/**
 * @type {number}
 */
BatteryManager.prototype.level;


/**
 * @type {?function(!Event)}
 */
BatteryManager.prototype.onchargingchange;


/**
 * @type {?function(!Event)}
 */
BatteryManager.prototype.onchargingtimechange;


/**
 * @type {?function(!Event)}
 */
BatteryManager.prototype.ondischargingtimechange;


/**
 * @type {?function(!Event)}
 */
BatteryManager.prototype.onlevelchange;
