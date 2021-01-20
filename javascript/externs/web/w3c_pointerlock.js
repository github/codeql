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
 * @fileoverview Definitions for W3C's Pointer Lock API.
 * @see https://w3c.github.io/pointerlock/
 *
 * @externs
 */

/**
 * TODO(bradfordcsmith): update the link when PR is merged
 * @see https://github.com/w3c/pointerlock/pull/49/
 * @record
 */
function PointerLockOptions() {}

/** @type {undefined|boolean} */
PointerLockOptions.prototype.unadjustedMovement;

/**
 * @see https://w3c.github.io/pointerlock/#widl-Element-requestPointerLock-void
 * @param {!PointerLockOptions=} options
 * @return {void|!Promise<void>}
 */
Element.prototype.requestPointerLock = function(options) {};

/**
 * @see https://w3c.github.io/pointerlock/#widl-Document-pointerLockElement
 * @type {?Element}
 */
Document.prototype.pointerLockElement;

/**
 * @see https://w3c.github.io/pointerlock/#widl-Document-exitPointerLock-void
 * @return {void}
 */
Document.prototype.exitPointerLock = function() {};

/**
 * @see https://w3c.github.io/pointerlock/#widl-MouseEvent-movementX
 * @type {number}
 */
MouseEvent.prototype.movementX;

/**
 * @see https://w3c.github.io/pointerlock/#widl-MouseEvent-movementY
 * @type {number}
 */
MouseEvent.prototype.movementY;
