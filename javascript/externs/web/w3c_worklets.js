/*
 * Copyright 2020 The Closure Compiler Authors.
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
 * @fileoverview Definitions for the Worklets API.
 * This file is based on the W3C Editor's Draft 07 April 2020.
 * @see https://drafts.css-houdini.org/worklets/
 *
 * @externs
 */

/**
 * @interface
 * @see https://drafts.css-houdini.org/worklets/#the-global-scope
 */
function WorkletGlobalScope() {}

/**
 * @record
 * @see https://drafts.css-houdini.org/worklets/#dictdef-workletoptions
 */
function WorkletOptions() {};

/**
 * @type {!RequestCredentials}
 * See https://fetch.spec.whatwg.org/#requestcredentials for valid values.
 */
WorkletOptions.prototype.credentials;

/**
 * @interface
 * @see https://drafts.css-houdini.org/worklets/#worklet-section
 */
function Worklet() {}

/**
 * @param {string} moduleURL
 * @param {!WorkletOptions=} options
 * @return {!Promise<void>}
 */
Worklet.prototype.addModule = function(moduleURL, options) {};
