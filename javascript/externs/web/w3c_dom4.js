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
 * @fileoverview Definitions for W3C's DOM4 specification. This file depends on
 * w3c_dom3.js. The whole file has been fully type annotated. Created from
 * https://www.w3.org/TR/domcore/.
 *
 * @externs
 * @author zhoumotongxue008@gmail.com (Michael Zhou)
 */

/**
 * @typedef {?(DocumentType|Element|CharacterData)}
 * @see https://www.w3.org/TR/domcore/#interface-childnode
 */
var ChildNode;

/**
 * @return {undefined}
 * @see https://www.w3.org/TR/domcore/#dom-childnode-remove
 */
DocumentType.prototype.remove = function() {};

/**
 * @return {undefined}
 * @see https://www.w3.org/TR/domcore/#dom-childnode-remove
 */
Element.prototype.remove = function() {};

/**
 * @return {undefined}
 * @see https://www.w3.org/TR/domcore/#dom-childnode-remove
 */
CharacterData.prototype.remove = function() {};
