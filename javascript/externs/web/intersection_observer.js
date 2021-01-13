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
 * @fileoverview Externs for Intersection Observer objects.
 * @see https://w3c.github.io/IntersectionObserver/
 * @externs
 */

// TODO(user): Once the Intersection Observer spec is adopted by W3C, add
// a w3c_ prefix to this file's name.


/**
 * These contain the information provided from a change event.
 * @see https://w3c.github.io/IntersectionObserver/#intersection-observer-entry
 * @record
 */
function IntersectionObserverEntry() {}

/**
 * The time the change was observed.
 * @see https://w3c.github.io/IntersectionObserver/#dom-intersectionobserverentry-time
 * @const {number}
 */
IntersectionObserverEntry.prototype.time;

/**
 * The root intersection rectangle, if target belongs to the same unit of
 * related similar-origin browsing contexts as the intersection root, null
 * otherwise.
 * @see https://w3c.github.io/IntersectionObserver/#dom-intersectionobserverentry-rootbounds
 * @const {{top: number, right: number, bottom: number, left: number,
 *     height: number, width: number}}
 */
IntersectionObserverEntry.prototype.rootBounds;

/**
 * The rectangle describing the element being observed.
 * @see https://w3c.github.io/IntersectionObserver/#dom-intersectionobserverentry-boundingclientrect
 * @const {!{top: number, right: number, bottom: number, left: number,
 *     height: number, width: number}}
 */
IntersectionObserverEntry.prototype.boundingClientRect;

/**
 * The rectangle describing the intersection between the observed element and
 * the viewport.
 * @see https://w3c.github.io/IntersectionObserver/#dom-intersectionobserverentry-intersectionrect
 * @const {!{top: number, right: number, bottom: number, left: number,
 *     height: number, width: number}}
 */
IntersectionObserverEntry.prototype.intersectionRect;

/**
 * Ratio of intersectionRect area to boundingClientRect area.
 * @see https://w3c.github.io/IntersectionObserver/#dom-intersectionobserverentry-intersectionratio
 * @const {number}
 */
IntersectionObserverEntry.prototype.intersectionRatio;

/**
 * The Element whose intersection with the intersection root changed.
 * @see https://w3c.github.io/IntersectionObserver/#dom-intersectionobserverentry-target
 * @const {!Element}
 */
IntersectionObserverEntry.prototype.target;

/**
 * Whether or not the target is intersecting with the root.
 * @see https://w3c.github.io/IntersectionObserver/#dom-intersectionobserverentry-isintersecting
 * @const {boolean}
 */
IntersectionObserverEntry.prototype.isIntersecting;

/**
 * Whether or not the target is visible with the root.
 * @see https://w3c.github.io/IntersectionObserver/v2/#dom-intersectionobserverentry-isvisible
 * @const {boolean|undefined}
 */
IntersectionObserverEntry.prototype.isVisible;

/**
 * Callback for the IntersectionObserver.
 * @see https://w3c.github.io/IntersectionObserver/#intersection-observer-callback
 * @typedef {function(!Array<!IntersectionObserverEntry>,!IntersectionObserver)}
 */
var IntersectionObserverCallback;

/**
 * Options for the IntersectionObserver.
 * @see https://w3c.github.io/IntersectionObserver/v2/#intersection-observer-init
 * @typedef {{
 *   threshold: (!Array<number>|number|undefined),
 *   delay: (number|undefined),
 *   trackVisibility: (boolean|undefined),
 *   root: (?Element|undefined),
 *   rootMargin: (string|undefined)
 * }}
 */
var IntersectionObserverInit;

/**
 * This is the constructor for Intersection Observer objects.
 * @see https://w3c.github.io/IntersectionObserver/#intersection-observer-interface
 * @param {!IntersectionObserverCallback} handler The callback for the observer.
 * @param {!IntersectionObserverInit=} opt_options The object defining the
 *     thresholds, etc.
 * @constructor
 */
function IntersectionObserver(handler, opt_options) {};

/**
 * The root Element to use for intersection, or null if the observer uses the
 * implicit root.
 * @see https://w3c.github.io/IntersectionObserver/#dom-intersectionobserver-root
 * @const {?Element}
 */
IntersectionObserver.prototype.root;

/**
 * Offsets applied to the intersection root’s bounding box, effectively growing
 * or shrinking the box that is used to calculate intersections.
 * @see https://w3c.github.io/IntersectionObserver/#dom-intersectionobserver-rootmargin
 * @const {string}
 */
IntersectionObserver.prototype.rootMargin;

/**
 * A list of thresholds, sorted in increasing numeric order, where each
 * threshold is a ratio of intersection area to bounding box area of an observed
 * target.
 * @see https://w3c.github.io/IntersectionObserver/#dom-intersectionobserver-thresholds
 * @const {!Array<number>}
 */
IntersectionObserver.prototype.thresholds;

/**
 * This is used to set which element to observe.
 * @see https://w3c.github.io/IntersectionObserver/#dom-intersectionobserver-observe
 * @param {!Element} element The element to observe.
 * @return {undefined}
 */
IntersectionObserver.prototype.observe = function(element) {};

/**
 * This is used to stop observing a given element.
 * @see https://w3c.github.io/IntersectionObserver/#dom-intersectionobserver-unobserve
 * @param {!Element} element The elmenent to stop observing.
 * @return {undefined}
 */
IntersectionObserver.prototype.unobserve = function(element) {};

/**
 * Disconnect.
 * @see https://w3c.github.io/IntersectionObserver/#dom-intersectionobserver-disconnect
 */
IntersectionObserver.prototype.disconnect = function() {};

/**
 * Take records.
 * @see https://w3c.github.io/IntersectionObserver/#dom-intersectionobserver-takerecords
 * @return {!Array.<!IntersectionObserverEntry>}
 */
IntersectionObserver.prototype.takeRecords = function() {};
