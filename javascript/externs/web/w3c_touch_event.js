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
 * @fileoverview Definitions for W3C's Touch Events specification.
 * @see http://www.w3.org/TR/touch-events/
 * @externs
 */

/**
 * @typedef {{
 *   identifier: number,
 *   target: !EventTarget,
 *   clientX: (number|undefined),
 *   clientY: (number|undefined),
 *   screenX: (number|undefined),
 *   screenY: (number|undefined),
 *   pageX: (number|undefined),
 *   pageY: (number|undefined),
 *   radiusX: (number|undefined),
 *   radiusY: (number|undefined),
 *   rotationAngle: (number|undefined),
 *   force: (number|undefined)
 * }}
 */
var TouchInitDict;

/**
 * The Touch class represents a single touch on the surface. A touch is the
 * presence or movement of a finger that is part of a unique multi-touch
 * sequence.
 * @see http://www.w3.org/TR/touch-events/#touch-interface
 * @param {!TouchInitDict} touchInitDict
 * @constructor
 */
function Touch(touchInitDict) {}

/**
 * The x-coordinate of the touch's location relative to the window's viewport.
 * @type {number}
 */
Touch.prototype.clientX;

/**
 * The y-coordinate of the touch's location relative to the window's viewport.
 * @type {number}
 */
Touch.prototype.clientY;

/**
 * The unique identifier for this touch object.
 * @type {number}
 */
Touch.prototype.identifier;

/**
 * The x-coordinate of the touch's location in page coordinates.
 * @type {number}
 */
Touch.prototype.pageX;

/**
 * The y-coordinate of the touch's location in page coordinates.
 * @type {number}
 */
Touch.prototype.pageY;

/**
 * The x-coordinate of the touch's location in screen coordinates.
 * @type {number}
 */
Touch.prototype.screenX;

/**
 * The y-coordinate of the touch's location in screen coordinates.
 * @type {number}
 */
Touch.prototype.screenY;

/**
 * The target of this touch.
 * @type {EventTarget}
 */
Touch.prototype.target;

/**
 * @type {number}
 * @see http://www.w3.org/TR/touch-events-extensions/#widl-Touch-force
 */
Touch.prototype.force;

/**
 * @type {number}
 * @see http://www.w3.org/TR/touch-events-extensions/#widl-Touch-radiusX
 */
Touch.prototype.radiusX;

/**
 * @type {number}
 * @see http://www.w3.org/TR/touch-events-extensions/#widl-Touch-radiusY
 */
Touch.prototype.radiusY;


/**
 * @type {number}
 * @see http://www.w3.org/TR/2011/WD-touch-events-20110505/#widl-Touch-rotationAngle
 */
Touch.prototype.rotationAngle;


/**
 * Creates a new Touch object.
 * @see http://www.w3.org/TR/touch-events/#widl-Document-createTouch-Touch-WindowProxy-view-EventTarget-target-long-identifier-long-pageX-long-pageY-long-screenX-long-screenY
 * @param {Window} view
 * @param {EventTarget} target
 * @param {number} identifier
 * @param {number} pageX
 * @param {number} pageY
 * @param {number} screenX
 * @param {number} screenY
 * @return {Touch}
 */
Document.prototype.createTouch = function(view, target, identifier, pageX,
    pageY, screenX, screenY) {};


/**
 * The TouchList class is used to represent a collection of Touch objects.
 * @see http://www.w3.org/TR/touch-events/#touchlist-interface
 * @constructor
 * @implements {IArrayLike<!Touch>}
 */
function TouchList() {}

/**
 * The number of Touch objects in this TouchList object.
 * @type {number}
 */
TouchList.prototype.length;

/**
 * Returns the Touch object at the given index.
 * @param {number} index
 * @return {?Touch}
 */
TouchList.prototype.item = function(index) {};

/**
 * @param {number} identifier
 * @return {?Touch}
 * @see http://www.w3.org/TR/touch-events-extensions/#widl-TouchList-identifiedTouch-Touch-long-identifier
 */
TouchList.prototype.identifiedTouch = function(identifier) {};

/**
 * Creates a new TouchList object.
 * @see http://www.w3.org/TR/touch-events/#widl-Document-createTouchList-TouchList-Touch-touches
 * @param {Array<?Touch>} touches
 * @return {TouchList}
 */
Document.prototype.createTouchList = function(touches) {};

/**
 * @record
 * @extends {UIEventInit}
 */
function TouchEventInit() {}

/** @type {undefined|?EventTarget} */
TouchEventInit.prototype.relatedTarget;

/** @type {undefined|!Array<?Touch>} */
TouchEventInit.prototype.touches;

/** @type {undefined|!Array<?Touch>} */
TouchEventInit.prototype.targetTouches;

/** @type {undefined|!Array<?Touch>} */
TouchEventInit.prototype.changedTouches;

/**
 * The TouchEvent class encapsulates information about a touch event.
 *
 * <p>The system continually sends TouchEvent objects to an application as
 * fingers touch and move across a surface. A touch event provides a snapshot of
 * all touches during a multi-touch sequence, most importantly the touches that
 * are new or have changed for a particular target. A multi-touch sequence
 * begins when a finger first touches the surface. Other fingers may
 * subsequently touch the surface, and all fingers may move across the surface.
 * The sequence ends when the last of these fingers is lifted from the surface.
 * An application receives touch event objects during each phase of any touch.
 * </p>
 *
 * <p>The different types of TouchEvent objects that can occur are:
 * <ul>
 *   <li>touchstart - Sent when a finger for a given event touches the surface.
 *   <li>touchmove - Sent when a given event moves on the surface.
 *   <li>touchend - Sent when a given event lifts from the surface.
 *   <li>touchcancel - Sent when the system cancels tracking for the touch.
 * </ul>
 * TouchEvent objects are combined together to form high-level GestureEvent
 * objects that are also sent during a multi-touch sequence.</p>
 *
 * @see http://www.w3.org/TR/touch-events/#touchevent-interface
 * @param {string} type
 * @param {!TouchEventInit=} opt_eventInitDict
 * @extends {UIEvent}
 * @constructor
 */
function TouchEvent(type, opt_eventInitDict) {}

/**
 * A collection of Touch objects representing all touches associated with this
 * target.
 * @type {TouchList}
 */
TouchEvent.prototype.touches;

/**
 * A collection of Touch objects representing all touches associated with this
 * target.
 * @type {TouchList}
 */
TouchEvent.prototype.targetTouches;

/**
 * A collection of Touch objects representing all touches that changed in this event.
 * @type {TouchList}
 */
TouchEvent.prototype.changedTouches;

/**
 * @type {boolean}
 */
TouchEvent.prototype.altKey;

/**
 * @type {boolean}
 */
TouchEvent.prototype.metaKey;

/**
 * @type {boolean}
 */
TouchEvent.prototype.ctrlKey;

/**
 * @type {boolean}
 */
TouchEvent.prototype.shiftKey;


/**
 * Specifies the JavaScript method to invoke when the system cancels tracking
 * for the touch.
 * @type {?function(!TouchEvent)}
 */
Element.prototype.ontouchcancel;

/**
 * Specifies the JavaScript method to invoke when a given event lifts from the
 * surface.
 * @type {?function(!TouchEvent)}
 */
Element.prototype.ontouchend;

/**
 * Specifies the JavaScript method to invoke when a finger for a given event
 * moves on the surface.
 * @type {?function(!TouchEvent)}
 */
Element.prototype.ontouchmove;

/**
 * Specifies the JavaScript method to invoke when a finger for a given event
 * touches the surface.
 * @type {?function(!TouchEvent)}
 */
Element.prototype.ontouchstart;
