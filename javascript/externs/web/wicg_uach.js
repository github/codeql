/*
 * Copyright 2008 The Closure Compiler Authors
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
 * @fileoverview The current draft spec of User Agent Client Hint interface.
 * @see https://wicg.github.io/ua-client-hints/#interface
 * @externs
 */

/**
 * @see https://wicg.github.io/ua-client-hints/#dictdef-navigatoruabrandversion
 * @record
 * @struct
 */
function NavigatorUABrandVersion() {}

/** @type {string} */
NavigatorUABrandVersion.prototype.brand;

/** @type {string} */
NavigatorUABrandVersion.prototype.version;


/**
 * @see https://wicg.github.io/ua-client-hints/#dictdef-uadatavalues
 * @record
 * @struct
 */
function UADataValues() {}

/** @type {string} */
UADataValues.prototype.platform;

/** @type {string} */
UADataValues.prototype.platformVersion;

/** @type {string} */
UADataValues.prototype.architecture;

/** @type {string} */
UADataValues.prototype.model;

/** @type {string} */
UADataValues.prototype.uaFullVersion;

/**
 * @see https://wicg.github.io/ua-client-hints/#navigatoruadata
 * @record
 * @struct
 */
function NavigatorUAData() {}

/** @type {!Array<!NavigatorUABrandVersion>} */
NavigatorUAData.prototype.brands;

/** @type {boolean} */
NavigatorUAData.prototype.mobile;

/** @type {function(!Array<string>) : !Promise<!UADataValues>} */
NavigatorUAData.prototype.getHighEntropyValues;

/**
 * @type {?NavigatorUAData}
 * @see https://wicg.github.io/ua-client-hints/#interface
 */
Navigator.prototype.userAgentData;

/**
 * @type {?NavigatorUAData}
 * @see https://wicg.github.io/ua-client-hints/#interface
 */
WorkerNavigator.prototype.userAgentData;
