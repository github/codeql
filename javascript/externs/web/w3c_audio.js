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
 * @fileoverview Definitions for the API related to audio.
 * Definitions for the Web Audio API.
 * This file is based on the W3C Working Draft 08 December 2015.
 * @see http://www.w3.org/TR/webaudio/
 *
 * @externs
 */

/**
 * @implements {EventTarget}
 * @constructor
 */
function BaseAudioContext() {}

/** @type {!AudioDestinationNode} */
BaseAudioContext.prototype.destination;

/** @type {number} */
BaseAudioContext.prototype.sampleRate;

/** @type {number} */
BaseAudioContext.prototype.currentTime;

/** @type {!AudioListener} */
BaseAudioContext.prototype.listener;

/** @type {!AudioWorklet} */
BaseAudioContext.prototype.audioWorklet;

/**
 * @type {string}
 * See https://www.w3.org/TR/webaudio/#BaseAudioContext for valid values
 */
BaseAudioContext.prototype.state;

/**
 * @param {number} numberOfChannels
 * @param {number} length
 * @param {number} sampleRate
 * @return {!AudioBuffer}
 */
BaseAudioContext.prototype.createBuffer =
    function(numberOfChannels, length, sampleRate) {};

/**
 * @param {!ArrayBuffer} audioData
 * @param {function(!AudioBuffer)=} successCallback
 * @param {function(?)=} errorCallback
 * @return {!Promise<!AudioBuffer>}
 */
BaseAudioContext.prototype.decodeAudioData =
    function(audioData, successCallback, errorCallback) {};

/**
 * @return {!AudioBufferSourceNode}
 */
BaseAudioContext.prototype.createBufferSource = function() {};

/**
 * @deprecated Use createAudioWorker instead
 * @param {number=} bufferSize
 * @param {number=} numberOfInputChannels_opt
 * @param {number=} numberOfOutputChannels_opt
 * @return {!ScriptProcessorNode}
 */
BaseAudioContext.prototype.createScriptProcessor = function(bufferSize,
    numberOfInputChannels_opt, numberOfOutputChannels_opt) {};

/**
 * @return {!AnalyserNode}
 */
BaseAudioContext.prototype.createAnalyser = function() {};

/**
 * @return {!GainNode}
 */
BaseAudioContext.prototype.createGain = function() {};

/**
 * @param {number=} maxDelayTime
 * @return {!DelayNode}
 */
BaseAudioContext.prototype.createDelay = function(maxDelayTime) {};

/**
 * @return {!BiquadFilterNode}
 */
BaseAudioContext.prototype.createBiquadFilter = function() {};

/**
 * @return {!WaveShaperNode}
 */
BaseAudioContext.prototype.createWaveShaper = function() {};

/**
 * @return {!PannerNode}
 */
BaseAudioContext.prototype.createPanner = function() {};

/**
 * @return {!StereoPannerNode}
 */
BaseAudioContext.prototype.createStereoPanner = function() {};

/**
 * @return {!ConvolverNode}
 */
BaseAudioContext.prototype.createConvolver = function() {};

/**
 * @param {number=} numberOfOutputs
 * @return {!ChannelSplitterNode}
 */
BaseAudioContext.prototype.createChannelSplitter = function(numberOfOutputs) {};

/**
 * @param {number=} numberOfInputs
 * @return {!ChannelMergerNode}
 */
BaseAudioContext.prototype.createChannelMerger = function(numberOfInputs) {};

/**
 * @return {!ConstantSourceNode}
 */
BaseAudioContext.prototype.createConstantSource = function() {};

/**
 * @return {!DynamicsCompressorNode}
 */
BaseAudioContext.prototype.createDynamicsCompressor = function() {};

/**
 * @return {!OscillatorNode}
 */
BaseAudioContext.prototype.createOscillator = function() {};

/**
 * @param {!Float32Array} real
 * @param {!Float32Array} imag
 * @return {!PeriodicWave}
 */
BaseAudioContext.prototype.createPeriodicWave = function(real, imag) {};

/**
 * @return {!Promise<void>}
 */
BaseAudioContext.prototype.resume = function() {};

/**
 * @return {!Promise<void>}
 */
BaseAudioContext.prototype.suspend = function() {};

/**
 * @return {!Promise<void>}
 */
BaseAudioContext.prototype.close = function() {};

/** @type {?function(!Event)} */
BaseAudioContext.prototype.onstatechange;

/**
 * @param  {string} scriptURL
 * @return {!Promise<!AudioWorker>}
 */
BaseAudioContext.prototype.createAudioWorker = function(scriptURL) {};

/**
 * @param  {!IArrayLike<number>} feedforward
 * @param  {!IArrayLike<number>} feedback
 * @return {!IIRFilterNode}
 */
BaseAudioContext.prototype.createIIRFilter = function(feedforward, feedback) {};

/**
 * @return {!SpatialPannerNode}
 */
BaseAudioContext.prototype.createSpatialPanner = function() {};

/**
 * @record
 * @see https://webaudio.github.io/web-audio-api/#idl-def-AudioContextOptions
 */
function AudioContextOptions() {};

/** @type {(undefined|string|number)} */
AudioContextOptions.prototype.latencyHint;

/** @type {(undefined|number)} */
AudioContextOptions.prototype.sampleRate;

/**
 * Includes the non-standard contextOptions optional options parameter
 * implemented by Chrome and Firefox.
 * @param {!AudioContextOptions=} contextOptions
 * @constructor
 * @extends {BaseAudioContext}
 */
function AudioContext(contextOptions) {}

/**
 * @param {!HTMLMediaElement} mediaElement
 * @return {!MediaElementAudioSourceNode}
 */
AudioContext.prototype.createMediaElementSource = function(mediaElement) {};

/**
 * @return {!MediaStreamAudioDestinationNode}
 */
AudioContext.prototype.createMediaStreamDestination = function() {};

/**
 * @param {!MediaStream} mediaStream
 * @return {!MediaStreamAudioSourceNode}
 */
AudioContext.prototype.createMediaStreamSource = function(mediaStream) {};

/**
 * @deprecated Use createScriptProcessor instead.
 * @param {number} bufferSize
 * @param {number} numberOfInputs
 * @param {number} numberOfOuputs
 * @return {!ScriptProcessorNode}
 */
AudioContext.prototype.createJavaScriptNode = function(bufferSize,
    numberOfInputs, numberOfOuputs) {};

/**
 * @deprecated Use createGain instead.
 * @return {!GainNode}
 */
AudioContext.prototype.createGainNode = function() {};

/**
 * @deprecated Use createDelay instead.
 * @param {number=} maxDelayTime
 * @return {!DelayNode}
 */
AudioContext.prototype.createDelayNode = function(maxDelayTime) {};

/**
 * @param {number} numberOfChannels
 * @param {number} length
 * @param {number} sampleRate
 * @constructor
 * @extends {BaseAudioContext}
 */
function OfflineAudioContext(numberOfChannels, length, sampleRate) {}

/**
 * @return {!Promise<!AudioBuffer>}
 */
OfflineAudioContext.prototype.startRendering = function() {};

/** @type {function(!OfflineAudioCompletionEvent)} */
OfflineAudioContext.prototype.oncomplete;

/**
 * @constructor
 * @extends {Event}
 */
function OfflineAudioCompletionEvent() {}

/** @type {AudioBuffer} */
OfflineAudioCompletionEvent.prototype.renderedBuffer;

/**
 * @constructor
 * @implements {EventTarget}
 * @see https://www.w3.org/TR/webaudio/#the-audionode-interface
 */
function AudioNode() {}

/**
 * @override
 */
AudioNode.prototype.addEventListener = function(type, listener,
    opt_useCapture) {};

/**
 * @override
 */
AudioNode.prototype.removeEventListener = function(type, listener,
    opt_useCapture) {};

/**
 * @override
 * @return {boolean}
 */
AudioNode.prototype.dispatchEvent = function(evt) {};

/**
 * @param {!AudioNode|!AudioParam} destination
 * @param {number=} output
 * @param {number=} input
 * @return {AudioNode|void}
 */
AudioNode.prototype.connect = function(destination, output, input) {};

/**
 * @param {!AudioNode|!AudioParam|number=} destination
 * @param {number=} output
 * @param {number=} input
 */
AudioNode.prototype.disconnect = function(destination, output, input) {};

/** @type {!AudioContext} */
AudioNode.prototype.context;

/** @type {number} */
AudioNode.prototype.numberOfInputs;

/** @type {number} */
AudioNode.prototype.numberOfOutputs;

/** @type {number} */
AudioNode.prototype.channelCount;

/**
 * @type {string}
 * See https://www.w3.org/TR/webaudio/#the-audionode-interface for valid values
 */
AudioNode.prototype.channelCountMode;

/**
 * @type {string}
 * See https://www.w3.org/TR/webaudio/#the-audionode-interface for valid values
 */
AudioNode.prototype.channelInterpretation;

/**
 * @constructor
 * @extends {AudioNode}
 */
function AudioSourceNode() {}

/**
 * @constructor
 * @extends {AudioNode}
 */
function AudioDestinationNode() {}

/**
 * @deprecated Use AudioDestinationNode#maxChannelCount
 * @type {number}
 */
AudioDestinationNode.prototype.numberOfChannels;

/** @type {number} */
AudioDestinationNode.prototype.maxChannelCount;

/**
 * @constructor
 */
function AudioParam() {}

/** @type {number} */
AudioParam.prototype.value;

/**
 * @type {string}
 * See https://www.w3.org/TR/webaudio/#dom-audioparam-automationrate for valid
 * values.
 */
AudioParam.prototype.automationRate;

/**
 * @deprecated
 * @type {number}
 */
AudioParam.prototype.maxValue;

/**
 * @deprecated
 * @type {number}
 */
AudioParam.prototype.minValue;

/** @type {number} */
AudioParam.prototype.defaultValue;

/**
 * @deprecated
 * @type {number}
 */
AudioParam.prototype.units;

/**
 * @param {number} value
 * @param {number} startTime
 * @return {!AudioParam}
 * @throws {!TypeError} if startTime is negative or not a finite number
 */
AudioParam.prototype.setValueAtTime = function(value, startTime) {};

/**
 * @param {number} value
 * @param {number} endTime
 * @return {!AudioParam}
 * @throws {!TypeError} if endTime is negative or not a finite number
 */
AudioParam.prototype.linearRampToValueAtTime = function(value, endTime) {};

/**
 * @param {number} value
 * @param {number} endTime
 * @return {!AudioParam}
 * @throws {!TypeError} if endTime is negative or not a finite number
 */
AudioParam.prototype.exponentialRampToValueAtTime = function(value, endTime) {};

/**
 * @param {number} target
 * @param {number} startTime
 * @param {number} timeConstant
 * @return {!AudioParam}
 * @throws {!TypeError} if startTime is negative or not a finite number, or
 * timeConstant is not strictly positive
 */
AudioParam.prototype.setTargetAtTime = function(target, startTime,
    timeConstant) {};

/**
 * @deprecated Use setTargetAtTime instead.
 * @param {number} target
 * @param {number} startTime
 * @param {number} timeConstant
 * @return {!AudioParam}
 */
AudioParam.prototype.setTargetValueAtTime = function(target, startTime,
    timeConstant) {};

/**
 * @param {!Float32Array} values
 * @param {number} startTime
 * @param {number} duration
 * @return {!AudioParam}
 * @throws {!TypeError} if startTime is negative or not a finite number
 */
AudioParam.prototype.setValueCurveAtTime = function(values, startTime,
    duration) {};

/**
 * @param {number} startTime
 * @return {!AudioParam}
 * @throws {!TypeError} if startTime is negative or not a finite number
 */
AudioParam.prototype.cancelScheduledValues = function(startTime) {};

/**
 * @constructor
 * @extends {AudioParam}
 */
function AudioGain() {}

/**
 * @constructor
 * @extends {AudioNode}
 */
function GainNode() {}

/** @type {!AudioParam} */
GainNode.prototype.gain;

/**
 * @constructor
 * @extends {AudioNode}
 */
function DelayNode() {}

/** @type {!AudioParam} */
DelayNode.prototype.delayTime;

/**
 * @constructor
 */
function AudioBuffer() {}

/**
 * @deprecated
 * @type {!AudioGain}
 */
AudioBuffer.prototype.gain;

/** @type {number} */
AudioBuffer.prototype.sampleRate;

/** @type {number} */
AudioBuffer.prototype.length;

/** @type {number} */
AudioBuffer.prototype.duration;

/** @type {number} */
AudioBuffer.prototype.numberOfChannels;

/**
 * @param {number} channel
 * @return {!Float32Array}
 */
AudioBuffer.prototype.getChannelData = function(channel) {};

/**
 * @param  {!Float32Array} destination
 * @param  {number} channelNumber
 * @param  {number=} startInChannel
 */
AudioBuffer.prototype.copyFromChannel = function(destination,
    channelNumber, startInChannel) {};

/**
 * @param  {!Float32Array} source
 * @param  {number} channelNumber
 * @param  {number=} startInChannel
 */
AudioBuffer.prototype.copyToChannel = function(source, channelNumber,
    startInChannel) {};

/**
 * @constructor
 * @extends {AudioNode}
 */
function AudioBufferSourceNode() {}

/**
 * @deprecated
 * @const {number}
 */
AudioBufferSourceNode.prototype.UNSCHEDULED_STATE;

/**
 * @deprecated
 * @const {number}
 */
AudioBufferSourceNode.prototype.SCHEDULED_STATE;

/**
 * @deprecated
 * @const {number}
 */
AudioBufferSourceNode.prototype.PLAYING_STATE;

/**
 * @deprecated
 * @const {number}
 */
AudioBufferSourceNode.prototype.FINISHED_STATE;

/**
 * @deprecated
 * @type {number}
 */
AudioBufferSourceNode.prototype.playbackState;

/** @type {AudioBuffer} */
AudioBufferSourceNode.prototype.buffer;

/**
 * @deprecated
 * @type {number}
 */
AudioBufferSourceNode.prototype.gain;

/** @type {!AudioParam} */
AudioBufferSourceNode.prototype.playbackRate;

/** @type {boolean} */
AudioBufferSourceNode.prototype.loop;

/** @type {number} */
AudioBufferSourceNode.prototype.loopStart;

/** @type {number} */
AudioBufferSourceNode.prototype.loopEnd;

/** @type {?function(!Event): void} */
AudioBufferSourceNode.prototype.onended;

/** @type {!AudioParam} */
AudioBufferSourceNode.prototype.detune;

/**
 * @param {number=} when
 * @param {number=} opt_offset
 * @param {number=} opt_duration
 * @throws {!TypeError} if any parameter is negative
 */
AudioBufferSourceNode.prototype.start = function(when, opt_offset,
    opt_duration) {};

/**
 * @param {number=} when
 * @throws {!TypeError} if when is negative
 */
AudioBufferSourceNode.prototype.stop = function(when) {};

/**
 * @deprecated Use AudioBufferSourceNode#start
 * @param {number} when
 * @return {undefined}
 */
AudioBufferSourceNode.prototype.noteOn = function(when) {};

/**
 * @param {number=} when
 * @param {number=} opt_offset
 * @param {number=} opt_duration
 * @deprecated Use AudioBufferSourceNode#start
 */
AudioBufferSourceNode.prototype.noteGrainOn = function(when, opt_offset,
    opt_duration) {};

/**
 * @param {number} when
 * @deprecated Use AudioBufferSourceNode#stop
 */
AudioBufferSourceNode.prototype.noteOff = function(when) {};

/**
 * @constructor
 * @extends {AudioNode}
 */
function MediaElementAudioSourceNode() {}

/**
 * @constructor
 */
function AudioWorker() {}

/** @type {?function(!Event)} */
AudioWorker.prototype.onloaded;

/** @type {?function(!Event)} */
AudioWorker.prototype.onmessage;

/** @type {!Array<!AudioWorkerParamDescriptor>} */
AudioWorker.prototype.parameters;

/**
 * @param  {string} name
 * @param  {number} defaultValue
 * @return {!AudioParam}
 */
AudioWorker.prototype.addParameter = function(name, defaultValue) {};

/**
 * @param  {number} numberOfInputs
 * @param  {number} numberOfOutputs
 * @return {!AudioWorkerNode}
 */
AudioWorker.prototype.createNode = function(numberOfInputs, numberOfOutputs) {};

/**
 * @param  {*} message
 * @param  {!Array<!Transferable>=} transfer
 */
AudioWorker.prototype.postMessage = function(message, transfer) {};

/**
 * @param  {string} name
 */
AudioWorker.prototype.removeParameter = function(name) {};

/**
 */
AudioWorker.prototype.terminate = function() {};

/**
 * @constructor
 * @extends {AudioNode}
 */
function AudioWorkerNode() {}

/** @type {?function(!Event)} */
AudioWorkerNode.prototype.onmessage;

/**
 * @param  {*} message
 * @param  {!Array<!Transferable>=} transfer
 */
AudioWorkerNode.prototype.postMessage = function(message, transfer) {};

/**
 * @constructor
 */
function AudioWorkerParamDescriptor() {}

/** @type {number} */
AudioWorkerParamDescriptor.prototype.defaultValue;

/** @type {string} */
AudioWorkerParamDescriptor.prototype.name;

/**
 * @constructor
 */
function AudioWorkerGlobalScope() {}

/** @type {?function(!Event)} */
AudioWorkerGlobalScope.prototype.onaudioprocess;

/** @type {?function(!Event)} */
AudioWorkerGlobalScope.prototype.onnodecreate;

/** @type {!Array<!AudioWorkerParamDescriptor>} */
AudioWorkerGlobalScope.prototype.parameters;

/** @type {number} */
AudioWorkerGlobalScope.prototype.sampleRate;

/**
 * @param  {string} name
 * @param  {number} defaultValue
 * @return {!AudioParam}
 */
AudioWorkerGlobalScope.prototype.addParameter = function(name, defaultValue) {};

/**
 * @param  {string} name
 */
AudioWorkerGlobalScope.prototype.removeParameter = function(name) {};

/**
 * @constructor
 */
function AudioWorkerNodeProcessor() {}

/** @type {?function(!Event)} */
AudioWorkerNodeProcessor.prototype.onmessage;

/**
 * @param  {*} message
 * @param  {!Array<!Transferable>=} transfer
 */
AudioWorkerNodeProcessor.prototype.postMessage = function(message, transfer) {};

/**
 * @constructor
 * @extends {AudioNode}
 * @deprecated Use AudioWorkerNode
 */
function JavaScriptAudioNode() {}

/**
 * @type {EventListener|(function(!AudioProcessingEvent):(boolean|undefined))}
 * @deprecated Use AudioWorkerNode
 */
JavaScriptAudioNode.prototype.onaudioprocess;

/**
 * @type {number}
 * @deprecated Use AudioWorkerNode
 */
JavaScriptAudioNode.prototype.bufferSize;

/**
 * @constructor
 * @extends {AudioNode}
 * @deprecated Use AudioWorkerNode
 */
function ScriptProcessorNode() {}

/**
 * @type {EventListener|(function(!AudioProcessingEvent):(boolean|undefined))}
 * @deprecated Use AudioWorkerNode
 */
ScriptProcessorNode.prototype.onaudioprocess;

/**
 * @type {number}
 * @deprecated Use AudioWorkerNode
 */
ScriptProcessorNode.prototype.bufferSize;

/**
 * @constructor
 * @extends {Event}
 */
function AudioWorkerNodeCreationEvent() {}

/** @type {!Array} */
AudioWorkerNodeCreationEvent.prototype.inputs;

/** @type {!AudioWorkerNodeProcessor} */
AudioWorkerNodeCreationEvent.prototype.node;

/** @type {!Array} */
AudioWorkerNodeCreationEvent.prototype.outputs;

/**
 * @constructor
 * @extends {Event}
 */
function AudioProcessEvent() {}

/** @type {!Float32Array} */
AudioProcessEvent.prototype.inputs;

/** @type {!AudioWorkerNodeProcessor} */
AudioProcessEvent.prototype.node;

/** @type {!Float32Array} */
AudioProcessEvent.prototype.outputs;

/** @type {!Object} */
AudioProcessEvent.prototype.parameters;

/** @type {number} */
AudioProcessEvent.prototype.playbackTime;

/**
 * @constructor
 * @extends {Event}
 * @deprecated Use AudioProcessEvent
 */
function AudioProcessingEvent() {}

/**
 * @type {!ScriptProcessorNode}
 * @deprecated Use AudioProcessEvent
 */
AudioProcessingEvent.prototype.node;

/**
 * @type {number}
 * @deprecated Use AudioProcessEvent
 */
AudioProcessingEvent.prototype.playbackTime;

/**
 * @type {!AudioBuffer}
 * @deprecated Use AudioProcessEvent
 */
AudioProcessingEvent.prototype.inputBuffer;

/**
 * @type {!AudioBuffer}
 * @deprecated Use AudioProcessEvent
 */
AudioProcessingEvent.prototype.outputBuffer;

/**
 * @deprecated
 * @constructor
 * @extends {AudioNode}
 */
function AudioPannerNode() {}

/**
 * @deprecated
 * @const {number}
 */
AudioPannerNode.prototype.EQUALPOWER;

/**
 * @deprecated
 * @const {number}
 */
AudioPannerNode.prototype.HRTF;

/**
 * @deprecated
 * @const {number}
 */
AudioPannerNode.prototype.SOUNDFIELD;

/**
 * @deprecated
 * @const {number}
 */
AudioPannerNode.prototype.LINEAR_DISTANCE;

/**
 * @deprecated
 * @const {number}
 */
AudioPannerNode.prototype.INVERSE_DISTANCE;

/**
 * @deprecated
 * @const {number}
 */
AudioPannerNode.prototype.EXPONENTIAL_DISTANCE;

/**
 * @deprecated
 * @type {number|string}
 */
AudioPannerNode.prototype.panningModel;

/**
 * @deprecated
 * @param {number} x
 * @param {number} y
 * @param {number} z
 * @return {undefined}
 */
AudioPannerNode.prototype.setPosition = function(x, y, z) {};

/**
 * @deprecated
 * @param {number} x
 * @param {number} y
 * @param {number} z
 * @return {undefined}
 */
AudioPannerNode.prototype.setOrientation = function(x, y, z) {};

/**
 * @deprecated
 * @param {number} x
 * @param {number} y
 * @param {number} z
 * @return {undefined}
 */
AudioPannerNode.prototype.setVelocity = function(x, y, z) {};

/**
 * @deprecated
 * @type {number|string}
 */
AudioPannerNode.prototype.distanceModel;

/**
 * @deprecated
 * @type {number}
 */
AudioPannerNode.prototype.refDistance;

/**
 * @deprecated
 * @type {number}
 */
AudioPannerNode.prototype.maxDistance;

/**
 * @deprecated
 * @type {number}
 */
AudioPannerNode.prototype.rolloffFactor;

/**
 * @deprecated
 * @type {number}
 */
AudioPannerNode.prototype.coneInnerAngle;

/**
 * @deprecated
 * @type {number}
 */
AudioPannerNode.prototype.coneOuterAngle;

/**
 * @deprecated
 * @type {number}
 */
AudioPannerNode.prototype.coneOuterGain;

/**
 * @deprecated
 * @type {!AudioGain}
 */
AudioPannerNode.prototype.coneGain;

/**
 * @deprecated
 * @type {!AudioGain}
 */
AudioPannerNode.prototype.distanceGain;

/**
 * @constructor
 * @extends {AudioNode}
 */
function PannerNode() {}

/** @type {number} */
PannerNode.prototype.coneInnerAngle;

/** @type {number} */
PannerNode.prototype.coneOuterAngle;

/** @type {number} */
PannerNode.prototype.coneOuterGain;

/**
 * @type {string}
 * See https://www.w3.org/TR/webaudio/#the-pannernode-interface for valid values
 */
PannerNode.prototype.distanceModel;

/** @type {number} */
PannerNode.prototype.maxDistance;

/**
 * @type {string}
 * See https://www.w3.org/TR/webaudio/#the-pannernode-interface for valid values
 */
PannerNode.prototype.panningModel;

/** @type {number} */
PannerNode.prototype.refDistance;

/** @type {number} */
PannerNode.prototype.rolloffFactor;

/**
 * @param {number} x
 * @param {number} y
 * @param {number} z
 */
PannerNode.prototype.setOrientation = function(x, y, z) {};

/**
 * @param {number} x
 * @param {number} y
 * @param {number} z
 */
PannerNode.prototype.setPosition = function(x, y, z) {};

/**
 * @param {number} x
 * @param {number} y
 * @param {number} z
 */
PannerNode.prototype.setVelocity = function(x, y, z) {};

/**
 * @constructor
 * @deprecated Use SpatialListener
 */
function AudioListener() {}

/**
 * @type {number}
 * @deprecated Use SpatialListener
 */
AudioListener.prototype.gain;

/**
 * @type {number}
 * @deprecated Use SpatialListener
 */
AudioListener.prototype.dopplerFactor;

/**
 * @type {number}
 * @deprecated Use SpatialListener
 */
AudioListener.prototype.speedOfSound;

/**
 * @param {number} x
 * @param {number} y
 * @param {number} z
 * @deprecated Use SpatialListener
 */
AudioListener.prototype.setPosition = function(x, y, z) {};

/**
 * @param {number} x
 * @param {number} y
 * @param {number} z
 * @param {number} xUp
 * @param {number} yUp
 * @param {number} zUp
 * @deprecated Use SpatialListener
 */
AudioListener.prototype.setOrientation = function(x, y, z, xUp, yUp, zUp) {};

/**
 * @param {number} x
 * @param {number} y
 * @param {number} z
 * @deprecated Use SpatialListener
 */
AudioListener.prototype.setVelocity = function(x, y, z) {};

/**
 * @constructor
 * @extends {AudioNode}
 */
function SpatialPannerNode() {}

/** @type {number} */
SpatialPannerNode.prototype.coneInnerAngle;

/** @type {number} */
SpatialPannerNode.prototype.coneOuterAngle;

/** @type {number} */
SpatialPannerNode.prototype.coneOuterGain;

/**
 * @type {string}
 * See https://www.w3.org/TR/webaudio/#the-pannernode-interface for valid values
 */
SpatialPannerNode.prototype.distanceModel;

/** @type {number} */
SpatialPannerNode.prototype.maxDistance;

/** @type {!AudioParam} */
SpatialPannerNode.prototype.orientationX;

/** @type {!AudioParam} */
SpatialPannerNode.prototype.orientationY;

/** @type {!AudioParam} */
SpatialPannerNode.prototype.orientationZ;

/**
 * @type {string}
 * See https://www.w3.org/TR/webaudio/#the-pannernode-interface for valid values
 */
SpatialPannerNode.prototype.panningModel;

/** @type {!AudioParam} */
SpatialPannerNode.prototype.positionX;

/** @type {!AudioParam} */
SpatialPannerNode.prototype.positionY;

/** @type {!AudioParam} */
SpatialPannerNode.prototype.positionZ;

/** @type {number} */
SpatialPannerNode.prototype.refDistance;

/** @type {number} */
SpatialPannerNode.prototype.rolloffFactor;

/**
 * @constructor
 */
function SpatialListener() {}

/** @type {!AudioParam} */
SpatialListener.prototype.forwardX;

/** @type {!AudioParam} */
SpatialListener.prototype.forwardY;

/** @type {!AudioParam} */
SpatialListener.prototype.forwardZ;

/** @type {!AudioParam} */
SpatialListener.prototype.positionX;

/** @type {!AudioParam} */
SpatialListener.prototype.positionY;

/** @type {!AudioParam} */
SpatialListener.prototype.positionZ;

/** @type {!AudioParam} */
SpatialListener.prototype.upX;

/** @type {!AudioParam} */
SpatialListener.prototype.upY;

/** @type {!AudioParam} */
SpatialListener.prototype.upZ;

/**
 * @constructor
 * @extends {AudioNode}
 * @see http://webaudio.github.io/web-audio-api/#the-stereopannernode-interface
 */
function StereoPannerNode() {}

/** @type {!AudioParam} */
StereoPannerNode.prototype.pan;

/**
 * @constructor
 * @extends {AudioNode}
 */
function ConvolverNode() {}

/** @type {?AudioBuffer} */
ConvolverNode.prototype.buffer;

/** @type {boolean} */
ConvolverNode.prototype.normalize;

/**
 * @constructor
 * @extends {AudioNode}
 */
var AnalyserNode = function() {};

/**
 * @param {!Float32Array} array
 */
AnalyserNode.prototype.getFloatFrequencyData = function(array) {};

/**
 * @param {!Uint8Array} array
 */
AnalyserNode.prototype.getByteFrequencyData = function(array) {};

/**
 * @param {!Uint8Array} array
 */
AnalyserNode.prototype.getByteTimeDomainData = function(array) {};

/**
 * @param {!Float32Array} array
 */
AnalyserNode.prototype.getFloatTimeDomainData = function(array) {};

/** @type {number} */
AnalyserNode.prototype.fftSize;

/** @type {number} */
AnalyserNode.prototype.frequencyBinCount;

/** @type {number} */
AnalyserNode.prototype.minDecibels;

/** @type {number} */
AnalyserNode.prototype.maxDecibels;

/** @type {number} */
AnalyserNode.prototype.smoothingTimeConstant;

/**
 * @constructor
 * @extends {AnalyserNode}
 * @deprecated Use AnalyserNode
 *
 * This constructor has been added for backwards compatibility.
 */
var RealtimeAnalyserNode = function() {};

/**
 * @constructor
 * @extends {AudioNode}
 */
function ChannelSplitterNode() {}

/**
 * @constructor
 * @extends {ChannelSplitterNode}
 * @deprecated Use ChannelSplitterNode
 *
 * This constructor has been added for backwards compatibility.
 */
function AudioChannelSplitter() {}

/**
 * @constructor
 * @extends {AudioNode}
 */
function ChannelMergerNode() {}

/**
 * @constructor
 * @extends {ChannelMergerNode}
 * @deprecated Use ChannelMergerNode
 *
 * This constructor has been added for backwards compatibility.
 */
function AudioChannelMerger() {}

/**
 * @constructor
 * @extends {AudioNode}
 */
function DynamicsCompressorNode() {}

/** @type {!AudioParam} */
DynamicsCompressorNode.prototype.threshold;

/** @type {!AudioParam} */
DynamicsCompressorNode.prototype.knee;

/** @type {!AudioParam} */
DynamicsCompressorNode.prototype.ratio;

/** @type {number} */
DynamicsCompressorNode.prototype.reduction;

/** @type {!AudioParam} */
DynamicsCompressorNode.prototype.attack;

/** @type {!AudioParam} */
DynamicsCompressorNode.prototype.release;

/**
 * @constructor
 * @extends {AudioNode}
 */
function BiquadFilterNode() {}

/**
 * A read-able and write-able string that specifies the type of the filter.
 * See http://webaudio.github.io/web-audio-api/#the-biquadfilternode-interface
 * for valid values.
 * @type {string}
 */
BiquadFilterNode.prototype.type;

/** @type {!AudioParam} */
BiquadFilterNode.prototype.frequency;

/** @type {!AudioParam} */
BiquadFilterNode.prototype.detune;

/** @type {!AudioParam} */
BiquadFilterNode.prototype.Q;

/** @type {!AudioParam} */
BiquadFilterNode.prototype.gain;
/**
 * @param {Float32Array} frequencyHz
 * @param {Float32Array} magResponse
 * @param {Float32Array} phaseResponse
 * @return {undefined}
 */
BiquadFilterNode.prototype.getFrequencyResponse = function(
    frequencyHz, magResponse, phaseResponse) {};

/**
 * @constructor
 * @extends {AudioNode}
 */
function IIRFilterNode() {}

/**
 * @param {!Float32Array} frequencyHz
 * @param {!Float32Array} magResponse
 * @param {!Float32Array} phaseResponse
 * @return {undefined}
 */
IIRFilterNode.prototype.getFrequencyResponse = function(
    frequencyHz, magResponse, phaseResponse) {};

/**
 * @constructor
 * @extends {AudioNode}
 */
function WaveShaperNode() {}

/** @type {Float32Array} */
WaveShaperNode.prototype.curve;

/** @type {string} */
WaveShaperNode.prototype.oversample;

/**
 * @deprecated
 * @constructor
 */
function WaveTable() {}

/**
 * @constructor
 * @extends {AudioNode}
 */
function OscillatorNode() {}

/**
 * @type {string}
 * See https://www.w3.org/TR/webaudio/#the-oscillatornode-interface for valid values
 */
OscillatorNode.prototype.type;

/**
 * @deprecated
 * @type {number}
 */
OscillatorNode.prototype.playbackState;

/** @type {!AudioParam} */
OscillatorNode.prototype.frequency;

/** @type {!AudioParam} */
OscillatorNode.prototype.detune;

/**
 * @param {number=} when
 */
OscillatorNode.prototype.start = function(when) {};

/**
 * @param {number=} when
 */
OscillatorNode.prototype.stop = function(when) {};

/**
 * @deprecated
 * @param {!WaveTable} waveTable
 */
OscillatorNode.prototype.setWaveTable = function(waveTable) {};

/**
 * @param {!PeriodicWave} periodicWave
 */
OscillatorNode.prototype.setPeriodicWave = function(periodicWave) {};

/** @type {?function(!Event)} */
OscillatorNode.prototype.onended;

/**
 * @constructor
 */
function PeriodicWave() {}

/**
 * @record
 * @see https://www.w3.org/TR/webaudio/#dictdef-constantsourceoptions
 */
function ConstantSourceOptions() {};

/** @const {(number|undefined)} */
ConstantSourceOptions.offset;

/**
 * @param {!BaseAudioContext} context
 * @param {!ConstantSourceOptions=} options
 * @constructor
 * @extends {AudioNode}
 * @see https://www.w3.org/TR/webaudio/#ConstantSourceNode
 */
function ConstantSourceNode(context, options) {}

/**
 * @param {number=} when
 */
ConstantSourceNode.prototype.start = function(when) {};

/**
 * @param {number=} when
 */
ConstantSourceNode.prototype.stop = function(when) {};

/** @type {!AudioParam} */
ConstantSourceNode.prototype.offset;

/**
 * @constructor
 * @extends {AudioNode}
 */
function MediaStreamAudioSourceNode() {}

/**
 * @constructor
 * @extends {AudioNode}
 */
function MediaStreamAudioDestinationNode() {}

/** @type {!MediaStream} */
MediaStreamAudioDestinationNode.prototype.stream;

/**
 * @constructor
 * @see https://www.w3.org/TR/webaudio/#audioworklet
 * @implements {Worklet}
 */
function AudioWorklet() {}

/**
 * @constructor
 * @see https://www.w3.org/TR/webaudio/#audioworkletglobalscope
 * @implements {WorkletGlobalScope}
 */
function AudioWorkletGlobalScope() {}

/** @type {number} */
AudioWorkletGlobalScope.prototype.currentFrame;

/** @type {number} */
AudioWorkletGlobalScope.prototype.currentTime;

/** @type {number} */
AudioWorkletGlobalScope.prototype.sampleRate;

/**
 * @param {!string} name
 * @param {!function()} processorCtor
 */
AudioWorkletGlobalScope.prototype.registerProcessor = function(
    name, processorCtor) {};

/**
 * @constructor
 * @extends {AudioNode}
 * @param {!BaseAudioContext} context
 * @param {string} name
 * @param {!AudioWorkletNodeOptions=} options
 * @see https://www.w3.org/TR/webaudio/#audioworkletnode
 */
function AudioWorkletNode(context, name, options) {}

/** @type {!EventListener|function()} */
AudioWorkletNode.prototype.onprocesserror;

/** @type {!Object<string, !AudioParam>} */
AudioWorkletNode.prototype.parameters;

/** @type {!MessagePort} */
AudioWorkletNode.prototype.port;

/**
 * @record
 * @see https://webaudio.github.io/web-audio-api/#dictdef-audioworkletnodeoptions
 */
function AudioWorkletNodeOptions() {};

/** @type {number} */
AudioWorkletNodeOptions.prototype.numberOfInputs;

/** @type {number} */
AudioWorkletNodeOptions.prototype.numberOfOutputs;

/** @type {!Array<number>} */
AudioWorkletNodeOptions.prototype.outputChannelCount;

/** @type {!Object<string, number>} */
AudioWorkletNodeOptions.prototype.parameterData;

/** @type {?Object} */
AudioWorkletNodeOptions.prototype.processorOptions;

/**
 * @constructor
 * @param {!AudioWorkletNodeOptions=} options
 * @see https://www.w3.org/TR/webaudio/#audioworkletprocessor
 */
function AudioWorkletProcessor(options) {}

/** @type {!MessagePort} */
AudioWorkletProcessor.prototype.port;

/**
 * @param {!Array<!Array<!Float32Array>>} inputs
 * @param {!Array<!Array<!Float32Array>>} outputs
 * @param {!Object<string, !Float32Array>} parameters
 * @return {boolean}
 */
AudioWorkletProcessor.prototype.process = function(
    inputs, outputs, parameters) {};

/**
 * @record
 * @see https://www.w3.org/TR/webaudio/#dictdef-audioparamdescriptor
 */
function AudioParamDescriptor() {};

/**
 * @type {string}
 * See https://www.w3.org/TR/webaudio/#dom-audioparam-automationrate for valid
 * values.
 */
AudioParamDescriptor.prototype.automationRate;

/** @type {number} */
AudioParamDescriptor.prototype.defaultValue;

/** @type {number} */
AudioParamDescriptor.prototype.maxValue;

/** @type {number} */
AudioParamDescriptor.prototype.minValue;

/** @type {string} */
AudioParamDescriptor.prototype.name;
