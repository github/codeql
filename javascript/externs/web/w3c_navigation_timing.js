/*
 * Copyright 2011 The Closure Compiler Authors
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
 * @fileoverview Definitions for W3C's Navigation Timing specification.
 *
 * Created from
 * @see http://dvcs.w3.org/hg/webperf/raw-file/tip/specs/NavigationTiming/Overview.html
 * @see http://w3c-test.org/webperf/specs/ResourceTiming
 * @see http://www.w3.org/TR/performance-timeline
 * @see http://www.w3.org/TR/user-timing/
 *
 * @externs
 */

/** @constructor */
function PerformanceTiming() {}
/** @type {number} */ PerformanceTiming.prototype.navigationStart;
/** @type {number} */ PerformanceTiming.prototype.unloadEventStart;
/** @type {number} */ PerformanceTiming.prototype.unloadEventEnd;
/** @type {number} */ PerformanceTiming.prototype.redirectStart;
/** @type {number} */ PerformanceTiming.prototype.redirectEnd;
/** @type {number} */ PerformanceTiming.prototype.fetchStart;
/** @type {number} */ PerformanceTiming.prototype.domainLookupStart;
/** @type {number} */ PerformanceTiming.prototype.domainLookupEnd;
/** @type {number} */ PerformanceTiming.prototype.connectStart;
/** @type {number} */ PerformanceTiming.prototype.connectEnd;
/** @type {number} */ PerformanceTiming.prototype.secureConnectionStart;
/** @type {number} */ PerformanceTiming.prototype.requestStart;
/** @type {number} */ PerformanceTiming.prototype.responseStart;
/** @type {number} */ PerformanceTiming.prototype.responseEnd;
/** @type {number} */ PerformanceTiming.prototype.domLoading;
/** @type {number} */ PerformanceTiming.prototype.domInteractive;
/** @type {number} */ PerformanceTiming.prototype.domContentLoadedEventStart;
/** @type {number} */ PerformanceTiming.prototype.domContentLoadedEventEnd;
/** @type {number} */ PerformanceTiming.prototype.domComplete;
/** @type {number} */ PerformanceTiming.prototype.loadEventStart;
/** @type {number} */ PerformanceTiming.prototype.loadEventEnd;

/** @constructor */
function PerformanceEntry() {}
/** @type {string} */ PerformanceEntry.prototype.name;
/** @type {string} */ PerformanceEntry.prototype.entryType;
/** @type {number} */ PerformanceEntry.prototype.startTime;
/** @type {number} */ PerformanceEntry.prototype.duration;

/**
 * https://www.w3.org/TR/resource-timing-2/#performanceresourcetiming
 * @constructor
 * @extends {PerformanceEntry}
 */
function PerformanceResourceTiming() {}
/** @type {number} */ PerformanceResourceTiming.prototype.redirectStart;
/** @type {number} */ PerformanceResourceTiming.prototype.redirectEnd;
/** @type {number} */ PerformanceResourceTiming.prototype.fetchStart;
/** @type {number} */ PerformanceResourceTiming.prototype.domainLookupStart;
/** @type {number} */ PerformanceResourceTiming.prototype.domainLookupEnd;
/** @type {number} */ PerformanceResourceTiming.prototype.connectStart;
/** @type {number} */ PerformanceResourceTiming.prototype.connectEnd;
/** @type {number} */
PerformanceResourceTiming.prototype.secureConnectionStart;
/** @type {number} */ PerformanceResourceTiming.prototype.requestStart;
/** @type {number} */ PerformanceResourceTiming.prototype.responseStart;
/** @type {number} */ PerformanceResourceTiming.prototype.responseEnd;
/** @type {string} */ PerformanceResourceTiming.prototype.initiatorType;
/** @type {number|undefined} */
PerformanceResourceTiming.prototype.transferSize;
/** @type {number|undefined} */
PerformanceResourceTiming.prototype.encodedBodySize;
/** @type {number|undefined} */
PerformanceResourceTiming.prototype.decodedBodySize;
/** @type {number|undefined} */
PerformanceResourceTiming.prototype.workerStart;
/** @type {string} */ PerformanceResourceTiming.prototype.nextHopProtocol;

/**
 * Possible values are 'navigate', 'reload', 'back_forward', and 'prerender'.
 * See https://w3c.github.io/navigation-timing/#sec-performance-navigation-types
 * @typedef {string}
 */
var NavigationType;

/**
 * https://w3c.github.io/navigation-timing/#sec-PerformanceNavigationTiming
 * @constructor
 * @extends {PerformanceResourceTiming}
 */
function PerformanceNavigationTiming() {}
/** @type {number} */ PerformanceNavigationTiming.prototype.unloadEventStart;
/** @type {number} */ PerformanceNavigationTiming.prototype.unloadEventEnd;
/** @type {number} */ PerformanceNavigationTiming.prototype.domInteractive;
/** @type {number} */ PerformanceNavigationTiming.prototype
    .domContentLoadedEventStart;
/** @type {number} */ PerformanceNavigationTiming.prototype
    .domContentLoadedEventEnd;
/** @type {number} */ PerformanceNavigationTiming.prototype.domComplete;
/** @type {number} */ PerformanceNavigationTiming.prototype.loadEventStart;
/** @type {number} */ PerformanceNavigationTiming.prototype.loadEventEnd;
/** @type {NavigationType} */ PerformanceNavigationTiming.prototype.type;
/** @type {number} */ PerformanceNavigationTiming.prototype.redirectCount;

/**
 * https://w3c.github.io/paint-timing/#sec-PerformancePaintTiming
 * @constructor
 * @extends {PerformanceEntry}
 */
function PerformancePaintTiming() {}

/** @constructor */
function PerformanceNavigation() {}
/** @const {number} */ PerformanceNavigation.TYPE_NAVIGATE;
/** @const {number} */ PerformanceNavigation.prototype.TYPE_NAVIGATE;
/** @const {number} */ PerformanceNavigation.TYPE_RELOAD;
/** @const {number} */ PerformanceNavigation.prototype.TYPE_RELOAD;
/** @const {number} */ PerformanceNavigation.TYPE_BACK_FORWARD;
/** @const {number} */ PerformanceNavigation.prototype.TYPE_BACK_FORWARD;
/** @const {number} */ PerformanceNavigation.TYPE_RESERVED;
/** @const {number} */ PerformanceNavigation.prototype.TYPE_RESERVED;
/** @type {number} */ PerformanceNavigation.prototype.type;
/** @type {number} */ PerformanceNavigation.prototype.redirectCount;

/**
 * https://w3c.github.io/longtasks/#taskattributiontiming
 * @constructor
 * @extends {PerformanceEntry}
 */
function TaskAttributionTiming() {}
/** @type {string} */ TaskAttributionTiming.prototype.containerId;
/** @type {string} */ TaskAttributionTiming.prototype.containerName;
/** @type {string} */ TaskAttributionTiming.prototype.containerSrc;
/** @type {string} */ TaskAttributionTiming.prototype.containerType;

/**
 * https://w3c.github.io/longtasks/#performancelongtasktiming
 * @constructor
 * @extends {PerformanceEntry}
 */
function PerformanceLongTaskTiming() {}
/** @type {!Array<!TaskAttributionTiming>} */
PerformanceLongTaskTiming.prototype.attribution;

/**
 * https://wicg.github.io/layout-instability/#sec-layout-shift
 * @constructor
 * @extends {PerformanceEntry}
 */
function LayoutShift() {}
/** @type {number} */ LayoutShift.prototype.value;
/** @type {boolean} */ LayoutShift.prototype.hadRecentInput;
/** @type {number} */ LayoutShift.prototype.lastInputTime;
/** @type {!Array<!LayoutShiftAttribution>} */ LayoutShift.prototype.sources;

/**
 * https://wicg.github.io/layout-instability/#sec-layout-shift
 * @constructor
 */
function LayoutShiftAttribution() {}
/** @type {?Node} */ LayoutShiftAttribution.prototype.node;
/** @type {!DOMRectReadOnly} */ LayoutShiftAttribution.prototype.previousRect;
/** @type {!DOMRectReadOnly} */ LayoutShiftAttribution.prototype.currentRect;

/**
 * https://wicg.github.io/largest-contentful-paint/#largestcontentfulpaint
 * @constructor
 * @extends {PerformanceEntry}
 */
function LargestContentfulPaint() {}
/** @type {number} */ LargestContentfulPaint.prototype.renderTime;
/** @type {number} */ LargestContentfulPaint.prototype.loadTime;
/** @type {number} */ LargestContentfulPaint.prototype.size;
/** @type {string} */ LargestContentfulPaint.prototype.id;
/** @type {string} */ LargestContentfulPaint.prototype.url;
/** @type {?Element} */ LargestContentfulPaint.prototype.element;

/**
 * https://wicg.github.io/event-timing/#sec-performance-event-timing
 * @constructor
 * @extends {PerformanceEntry}
 */
function PerformanceEventTiming() {}
/** @type {number} */ PerformanceEventTiming.prototype.processingStart;
/** @type {number} */ PerformanceEventTiming.prototype.processingEnd;
/** @type {boolean} */ PerformanceEventTiming.prototype.cancelable;
/** @type {?Node} */ PerformanceEventTiming.prototype.target;

/** @constructor */
function Performance() {}

/** @type {PerformanceTiming} */
Performance.prototype.timing;

/** @type {PerformanceNavigation} */
Performance.prototype.navigation;

/** @type {number} */
Performance.prototype.timeOrigin;


/**
 * Clears the buffer used to store the current list of
 * PerformanceResourceTiming resources.
 * @return {undefined}
 */
Performance.prototype.clearResourceTimings = function() {};

/**
 * A callback that is invoked when the resourcetimingbufferfull event is fired.
 * @type {?function(Event)}
 */
Performance.prototype.onresourcetimingbufferfull = function() {};

/**
 * Set the maximum number of PerformanceResourceTiming resources that may be
 * stored in the buffer.
 * @param {number} maxSize
 * @return {undefined}
 */
Performance.prototype.setResourceTimingBufferSize = function(maxSize) {};

/**
 * @return {!Array<!PerformanceEntry>} A copy of the PerformanceEntry list,
 *     in chronological order with respect to startTime.
 * @nosideeffects
 */
Performance.prototype.getEntries = function() {};

/**
 * @param {string} entryType Only return `PerformanceEntry`s with this
 *     entryType.
 * @return {!Array<!PerformanceEntry>} A copy of the PerformanceEntry list,
 *     in chronological order with respect to startTime.
 * @nosideeffects
 */
Performance.prototype.getEntriesByType = function(entryType) {};

/**
 * @param {string} name Only return `PerformanceEntry`s with this name.
 * @param {string=} opt_entryType Only return `PerformanceEntry`s with
 *     this entryType.
 * @return {!Array<!PerformanceEntry>} PerformanceEntry list in chronological
 *     order with respect to startTime.
 * @nosideeffects
 */
Performance.prototype.getEntriesByName = function(name, opt_entryType) {};

/**
 * @return {number}
 * @nosideeffects
 */
Performance.prototype.now = function() {};

/**
 * @param {string} markName
 * @return {undefined}
 */
Performance.prototype.mark = function(markName) {};

/**
 * @param {string=} opt_markName
 * @return {undefined}
 */
Performance.prototype.clearMarks = function(opt_markName) {};

/**
 * @param {string} measureName
 * @param {string=} opt_startMark
 * @param {string=} opt_endMark
 * @return {undefined}
 */
Performance.prototype.measure = function(
    measureName, opt_startMark, opt_endMark) {};

/**
 * @param {string=} opt_measureName
 * @return {undefined}
 */
Performance.prototype.clearMeasures = function(opt_measureName) {};

/** @type {Performance} */
Window.prototype.performance;

/**
 * @type {!Performance}
 * @suppress {duplicate}
 */
var performance;

/**
 * @constructor
 * @extends {Performance}
 */
function WorkerPerformance() {}

/**
 * @typedef {function(!PerformanceObserverEntryList, !PerformanceObserver): void}
 */
var PerformanceObserverCallback;

/**
 * See:
 * https://w3c.github.io/performance-timeline/#the-performanceobserver-interface
 * @constructor
 * @param {!PerformanceObserverCallback} callback
 */
function PerformanceObserver(callback) {}

/**
 * @param {!PerformanceObserverInit} options
 */
PerformanceObserver.prototype.observe = function(options) {};

/** @return {void} */
PerformanceObserver.prototype.disconnect = function() {};

/**
 * @see https://developer.mozilla.org/en-US/docs/Web/API/PerformanceObserver/takeRecords
 * @see https://www.w3.org/TR/performance-timeline-2/#takerecords-method
 * @return {!Array<!PerformanceEntry>} The current PerformanceEntry list stored
 *     in the performance observer buffer, emptying it out.
 */
PerformanceObserver.prototype.takeRecords = function() {};

/** @const {!Array<string>} */
PerformanceObserver.prototype.supportedEntryTypes;

/**
 * @record
 */
function PerformanceObserverInit() {}

/** @type {undefined|!Array<string>} */
PerformanceObserverInit.prototype.entryTypes;
/** @type {undefined|string} */
PerformanceObserverInit.prototype.type;
/** @type {undefined|boolean} */
PerformanceObserverInit.prototype.buffered;

/**
 * @constructor
 */
function PerformanceObserverEntryList() {}

/** @return {!Array<!PerformanceEntry>} */
PerformanceObserverEntryList.prototype.getEntries = function() {};
/**
 * @param {string} type
 * @return {!Array<!PerformanceEntry>}
 */
PerformanceObserverEntryList.prototype.getEntriesByName = function(type) {};
/**
 * @param {string} name
 * @param {string=} opt_type
 * @return {!Array<!PerformanceEntry>}
 */
PerformanceObserverEntryList.prototype.getEntriesByType = function(
    name, opt_type) {};
