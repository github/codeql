/*
 * Copyright 2009 The Closure Compiler Authors
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
 * @fileoverview Definitions for all iPhone extensions. Created from:
 * http://developer.apple.com/library/safari/navigation/
 *
 * @externs
 * @author agrieve@google.com (Andrew Grieve)
 */


/**
 * @type {number}
 */
Touch.prototype.webkitForce;

/**
 * @type {number}
 */
Touch.prototype.webkitRadiusX;

/**
 * @type {number}
 */
Touch.prototype.webkitRadiusY;

/**
 * The distance between two fingers since the start of an event as a multiplier
 * of the initial distance. The initial value is 1.0. If less than 1.0, the
 * gesture is pinch close (to zoom out). If greater than 1.0, the gesture is
 * pinch open (to zoom in).
 * @type {number}
 */
TouchEvent.prototype.scale;

/**
 * The delta rotation since the start of an event, in degrees, where clockwise
 * is positive and counter-clockwise is negative. The initial value is 0.0.
 * @type {number}
 */
TouchEvent.prototype.rotation;

/**
 * Initializes a newly created TouchEvent object.
 * @param {string} type
 * @param {boolean} canBubble
 * @param {boolean} cancelable
 * @param {Window} view
 * @param {number} detail
 * @param {number} screenX
 * @param {number} screenY
 * @param {number} clientX
 * @param {number} clientY
 * @param {boolean} ctrlKey
 * @param {boolean} altKey
 * @param {boolean} shiftKey
 * @param {boolean} metaKey
 * @param {TouchList} touches
 * @param {TouchList} targetTouches
 * @param {TouchList} changedTouches
 * @param {number} scale
 * @param {number} rotation
 * @return {undefined}
 */
TouchEvent.prototype.initTouchEvent = function(type, canBubble, cancelable,
    view, detail, screenX, screenY, clientX, clientY, ctrlKey, altKey, shiftKey,
    metaKey, touches, targetTouches, changedTouches, scale, rotation) {};

/**
 * The GestureEvent class encapsulates information about a multi-touch gesture.
 *
 * GestureEvent objects are high-level events that encapsulate the low-level
 * TouchEvent objects. Both GestureEvent and TouchEvent events are sent during
 * a multi-touch sequence. Gesture events contain scaling and rotation
 * information allowing gestures to be combined, if supported by the platform.
 * If not supported, one gesture ends before another starts. Listen for
 * GestureEvent events if you want to respond to gestures only, not process
 * the low-level TouchEvent objects.
 *
 * @see http://developer.apple.com/library/safari/#documentation/UserExperience/Reference/GestureEventClassReference/GestureEvent/GestureEvent.html
 * @extends {UIEvent}
 * @constructor
 */
function GestureEvent() {}

/**
 * The distance between two fingers since the start of an event as a multiplier
 * of the initial distance. The initial value is 1.0. If less than 1.0, the
 * gesture is pinch close (to zoom out). If greater than 1.0, the gesture is
 * pinch open (to zoom in).
 * @type {number}
 */
GestureEvent.prototype.scale;

/**
 * The delta rotation since the start of an event, in degrees, where clockwise
 * is positive and counter-clockwise is negative. The initial value is 0.0.
 * @type {number}
 */
GestureEvent.prototype.rotation;

/**
 * The target of this gesture.
 * @type {EventTarget}
 */
GestureEvent.prototype.target;

/**
 * Initializes a newly created GestureEvent object.
 * @param {string} type
 * @param {boolean} canBubble
 * @param {boolean} cancelable
 * @param {Window} view
 * @param {number} detail
 * @param {number} screenX
 * @param {number} screenY
 * @param {number} clientX
 * @param {number} clientY
 * @param {boolean} ctrlKey
 * @param {boolean} altKey
 * @param {boolean} shiftKey
 * @param {boolean} metaKey
 * @param {EventTarget} target
 * @param {number} scale
 * @param {number} rotation
 * @return {undefined}
 */
GestureEvent.prototype.initGestureEvent = function(type, canBubble, cancelable,
    view, detail, screenX, screenY, clientX, clientY, ctrlKey, altKey, shiftKey,
    metaKey, target, scale, rotation) {};


/**
 * Specifies the JavaScript method to invoke when a gesture is started by
 * two or more fingers touching the surface.
 * @type {?function(!GestureEvent)}
 */
Element.prototype.ongesturestart;

/**
 * Specifies the JavaScript method to invoke when fingers are moved during a
 * gesture.
 * @type {?function(!GestureEvent)}
 */
Element.prototype.ongesturechange;

/**
 * Specifies the JavaScript method to invoke when a gesture ends (when there are
 * 0 or 1 fingers touching the surface).
 * @type {?function(!GestureEvent)}
 */
Element.prototype.ongestureend;

/**
 * Specifies the JavaScript method to invoke when the browser device's
 * orientation changes, i.e.the device is rotated.
 * @type {?function(!Event)}
 * @see http://developer.apple.com/library/IOS/#documentation/AppleApplications/Reference/SafariWebContent/HandlingEvents/HandlingEvents.html
 */
Window.prototype.onorientationchange;

/**
 * Returns the orientation of the browser's device, one of [-90, 0, 90, 180].
 * @type {number}
 * @see http://developer.apple.com/library/IOS/#documentation/AppleApplications/Reference/SafariWebContent/HandlingEvents/HandlingEvents.html
 */
Window.prototype.orientation;

/**
 * @implicitCast
 * @type {boolean}
 */
HTMLInputElement.prototype.autocorrect;

/**
 * @implicitCast
 * @type {boolean}
 */
HTMLInputElement.prototype.autocapitalize;

/**
 * @implicitCast
 * @type {boolean}
 */
HTMLTextAreaElement.prototype.autocorrect;

/**
 * @implicitCast
 * @type {boolean}
 */
HTMLTextAreaElement.prototype.autocapitalize;
