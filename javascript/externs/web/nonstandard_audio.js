/*
 * Copyright 2012 The Closure Compiler Authors.
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
 * @fileoverview Nonstandard definitions for the API related to audio.
 *
 * @externs
 */

/**
 * Definitions for the Web Audio API with webkit prefix.
 */

/**
 * @constructor
 * @extends {AudioContext}
 */
function webkitAudioContext() {}

/**
 * @param {number} numberOfChannels
 * @param {number} length
 * @param {number} sampleRate
 * @constructor
 * @extends {OfflineAudioContext}
 */
function webkitOfflineAudioContext(numberOfChannels, length, sampleRate) {}

/**
 * @constructor
 * @extends {AudioPannerNode}
 */
function webkitAudioPannerNode() {}

/**
 * @constructor
 * @extends {PannerNode}
 */
function webkitPannerNode() {}

/**
 * Definitions for the Audio API as implemented in Firefox.
 *   Please note that this document describes a non-standard experimental API.
 *   This API is considered deprecated.
 * @see https://developer.mozilla.org/en/DOM/HTMLAudioElement
 */

/**
 * @param {string=} src
 * @constructor
 * @extends {HTMLAudioElement}
 */
function Audio(src) {}

/**
 * @param {number} channels
 * @param {number} rate
 */
Audio.prototype.mozSetup = function(channels, rate) {};

/**
 * @param {Array|Float32Array} buffer
 */
Audio.prototype.mozWriteAudio = function(buffer) {};

/**
 * @return {number}
 */
Audio.prototype.mozCurrentSampleOffset = function() {};
