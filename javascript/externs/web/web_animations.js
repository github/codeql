/*
 * Copyright 2016 The Closure Compiler authors
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
 * @fileoverview Basic externs for the Web Animations API. This is not
 * nessecarily exhaustive. For more information, see the spec-
 *   https://w3c.github.io/web-animations
 * @externs
 */


/**
 * @param {!Object} frames
 * @param {(number|KeyframeAnimationOptions)=} options
 * @return {!Animation}
 * @see https://www.w3.org/TR/web-animations/#the-animatable-interface-mixin
 */
Element.prototype.animate = function(frames, options) {};

/**
 * @return {!Array<!Animation>}
 */
Element.prototype.getAnimations = function() {};


/**
 * @constructor
 * @param {?AnimationEffect=} effect
 * @param {AnimationTimeline=} timeline
 * @implements {EventTarget}
 */
var Animation = function(effect, timeline) {};

/** @override */
Animation.prototype.addEventListener = function(type, listener, options) {};

/** @override */
Animation.prototype.removeEventListener = function(type, listener, options) {};

/** @override */
Animation.prototype.dispatchEvent = function(evt) {};

/**
 * @return {undefined}
 */
Animation.prototype.cancel = function() {};

/**
 * @return {undefined}
 */
Animation.prototype.finish = function() {};

/**
 * @return {undefined}
 */
Animation.prototype.pause = function() {};

/**
 * @return {undefined}
 */
Animation.prototype.play = function() {};

/**
 * @return {undefined}
 */
Animation.prototype.reverse = function() {};

/** @type {number} */
Animation.prototype.currentTime;

/** @type {?AnimationEffect} */
Animation.prototype.effect;

/** @type {!Promise<void>} */
Animation.prototype.finished;

/** @type {string} */
Animation.prototype.id;

/** @type {?function(!Event)} */
Animation.prototype.oncancel;

/** @type {?function(!Event)} */
Animation.prototype.onfinish;

/** @type {number} */
Animation.prototype.playbackRate;

/** @type {string} */
Animation.prototype.playState;

/** @type {!Promise<void>} */
Animation.prototype.ready;

/** @type {number} */
Animation.prototype.startTime;

/** @type {!AnimationTimeline} */
Animation.prototype.timeline;


/**
 * @interface
 */
var AnimationEffect = function() {};

/**
 * @return {!ComputedTimingProperties}
 */
AnimationEffect.prototype.getComputedTiming = function() {};

/** @param {AnimationEffectTimingProperties=} timing */
AnimationEffect.prototype.updateTiming = function(timing) {};

/** @type {!AnimationEffectTiming} */
AnimationEffect.prototype.timing;

/**
 * @constructor
 * @param {Element} target
 * @param {(!Array<!Object<string, *>>|!Object<string, !Array<*>>)} frames
 * @param {(number|AnimationEffectTimingProperties)=} options
 * @implements {AnimationEffect}
 */
var KeyframeEffectReadOnly = function(target, frames, options) {};

/** @override */
KeyframeEffectReadOnly.prototype.getComputedTiming = function() {};

/** @override */
KeyframeEffectReadOnly.prototype.timing;


/**
 * @constructor
 * @param {Element} target
 * @param {(!Array<!Object<string, *>>|!Object<string, !Array<*>>)} frames
 * @param {(number|AnimationEffectTimingProperties)=} options
 * @extends {KeyframeEffectReadOnly}
 */
var KeyframeEffect = function(target, frames, options) {};


/**
 * @record
 */
var AnimationEffectTimingProperties = function() {};

/** @type {number|undefined} */
AnimationEffectTimingProperties.prototype.delay;

/** @type {number|undefined} */
AnimationEffectTimingProperties.prototype.endDelay;

/** @type {string|undefined} */
AnimationEffectTimingProperties.prototype.fill;

/** @type {number|undefined} */
AnimationEffectTimingProperties.prototype.iterationStart;

/** @type {number|undefined} */
AnimationEffectTimingProperties.prototype.iterations;

/** @type {number|string|undefined} */
AnimationEffectTimingProperties.prototype.duration;

/** @type {string|undefined} */
AnimationEffectTimingProperties.prototype.direction;

/** @type {string|undefined} */
AnimationEffectTimingProperties.prototype.easing;

/**
 * @record
 * @extends {AnimationEffectTimingProperties}
 */
var KeyframeEffectOptions = function() {};

/**
 * Possible values: 'replace', 'accumulate'
 * @type {string|undefined}
 */
KeyframeEffectOptions.prototype.iterationComposite;

/**
 * Possible values: 'replace', 'add', 'accumulate'
 * @type {string|undefined}
 */
KeyframeEffectOptions.prototype.composite;

/**
 * @record
 * @extends {KeyframeEffectOptions}
 */
var KeyframeAnimationOptions = function() {};

/** @type {string|undefined} */
KeyframeAnimationOptions.prototype.id;


/**
 * @record
 * @extends {AnimationEffectTimingProperties}
 */
var ComputedTimingProperties = function() {};

/** @type {number} */
ComputedTimingProperties.prototype.endTime;

/** @type {number} */
ComputedTimingProperties.prototype.activeDuration;

/** @type {?number} */
ComputedTimingProperties.prototype.localTime;

/** @type {?number} */
ComputedTimingProperties.prototype.progress;

/** @type {?number} */
ComputedTimingProperties.prototype.currentIteration;


/**
 * @interface
 */
var AnimationEffectTimingReadOnly = function() {};

/** @type {number} */
AnimationEffectTimingReadOnly.prototype.delay;

/** @type {number} */
AnimationEffectTimingReadOnly.prototype.endDelay;

/** @type {string} */
AnimationEffectTimingReadOnly.prototype.fill;

/** @type {number} */
AnimationEffectTimingReadOnly.prototype.iterationStart;

/** @type {number} */
AnimationEffectTimingReadOnly.prototype.iterations;

/** @type {number|string} */
AnimationEffectTimingReadOnly.prototype.duration;

/** @type {string} */
AnimationEffectTimingReadOnly.prototype.direction;

/** @type {string} */
AnimationEffectTimingReadOnly.prototype.easing;


/**
 * @interface
 * @extends {AnimationEffectTimingReadOnly}
 */
var AnimationEffectTiming = function() {};


/**
 * @interface
 */
var AnimationTimeline = function() {};

/** @type {?number} */
AnimationTimeline.prototype.currentTime;


/**
 * @constructor
 * @implements {AnimationTimeline}
 */
var DocumentTimeline = function() {};

/** @override */
DocumentTimeline.prototype.currentTime;


/** @type {!DocumentTimeline} */
Document.prototype.timeline;

/**
 * Externs for the Web Animations API (Level 2 / Groups).
 *
 * This defines externs for the "-next" version of the Web Animations API
 * polyfill found online at:
 *    https://github.com/web-animations/web-animations.js
 *
 * These features are NOT natively implemented in browsers and are not clearly
 * part of the official spec. This is NOT intended to be exhaustive, and
 * requires the base externs from web-animations.js.
 *
 */


/** @type {Element} */
KeyframeEffectReadOnly.prototype.target;

/** @type {?function(number, !KeyframeEffect, !Animation)|undefined} */
KeyframeEffectReadOnly.prototype.onsample;


/**
 * @param {!AnimationEffect} effect
 * @return {!Animation}
 */
DocumentTimeline.prototype.play = function(effect) {};

/**
 * @return {!Array<!Animation>}
 */
DocumentTimeline.prototype.getAnimations = function() {};


/**
 * @param {!Array<!AnimationEffect>} children
 * @param {AnimationEffectTimingProperties=} timing
 * @constructor
 * @implements {AnimationEffect}
 */
var SequenceEffect = function(children, timing) {};

/** @override */
SequenceEffect.prototype.getComputedTiming = function() {};

/** @override */
SequenceEffect.prototype.timing;

/** @type {!Array<!AnimationEffect>} */
SequenceEffect.prototype.children;


/**
 * @param {!Array<!AnimationEffect>} children
 * @param {AnimationEffectTimingProperties=} timing
 * @constructor
 * @implements {AnimationEffect}
 */
var GroupEffect = function(children, timing) {};

/** @override */
GroupEffect.prototype.getComputedTiming = function() {};

/** @override */
GroupEffect.prototype.timing;

/** @type {!Array<!AnimationEffect>} */
GroupEffect.prototype.children;
