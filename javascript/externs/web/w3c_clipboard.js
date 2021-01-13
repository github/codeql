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
 * @fileoverview Declaration of the asynchronous clipboard Web API.
 * @externs
 */

/**
 * @interface
 * @see https://w3c.github.io/clipboard-apis/#async-clipboard-api
 */
function Clipboard() {}

/**
 * @return {!Promise<string>}
 */
Clipboard.prototype.readText = function() {};

/**
 * @param {string} text
 * @return {!Promise<void>}
 */
Clipboard.prototype.writeText = function(text) {};

/** @const {!Clipboard} */
Navigator.prototype.clipboard;
