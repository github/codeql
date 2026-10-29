// Adapted from the Google Closure externs; original copyright header included below.
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
 * @interface
 */
function EventTarget() {}

/**
 * @constructor
 * @implements {EventTarget}
 * @see http://www.w3.org/TR/1998/REC-DOM-Level-1-19981001/level-one-core.html#ID-1950641247
 */
function Node() {}

/**
 * @constructor
 * @extends {Node}
 * @see http://www.w3.org/TR/1998/REC-DOM-Level-1-19981001/level-one-core.html#ID-745549614
 */
function Element() {}

Element.prototype.innerHTML;

/** @externs */
