/*
 * Copyright 2012 The Closure Compiler Authors
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
 * @fileoverview Definitions for components of the WebRTC browser API.
 * @see https://www.w3.org/TR/webrtc/
 * @see https://tools.ietf.org/html/draft-ietf-rtcweb-jsep-19
 * @see https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API
 * @see https://www.w3.org/TR/mediacapture-streams/
 *
 * @externs
 * @author bemasc@google.com (Benjamin M. Schwartz)
 */

/**
 * @typedef {string}
 * @see {https://www.w3.org/TR/mediacapture-streams/
 *     #idl-def-MediaStreamTrackState}
 * In WebIDL this is an enum with values 'live', 'mute', and 'ended',
 * but there is no mechanism in Closure for describing a specialization of
 * the string type.
 */
var MediaStreamTrackState;

/**
 * @interface
 */
function SourceInfo() {}

/** @const {string} */
SourceInfo.prototype.kind;

/** @const {string} */
SourceInfo.prototype.id;

/** @const {?string} */
SourceInfo.prototype.label;

/** @const {boolean} */
SourceInfo.prototype.facing;

/**
 * @interface
 * @see https://w3c.github.io/mediacapture-image/#mediasettingsrange-section
 */
function MediaSettingsRange() {}

/**
 * @const {number}
 */
MediaSettingsRange.prototype.max;

/**
 * @const {number}
 */
MediaSettingsRange.prototype.min;

/**
 * @const {number}
 */
MediaSettingsRange.prototype.step;

/**
 * @interface
 * @see https://www.w3.org/TR/mediacapture-streams/#idl-def-MediaTrackCapabilities
 * @see https://w3c.github.io/mediacapture-image/#mediatrackcapabilities-section
 */
function MediaTrackCapabilities() {}

/** @type {number} */
MediaTrackCapabilities.prototype.width;

/** @type {number} */
MediaTrackCapabilities.prototype.height;

/** @type {number} */
MediaTrackCapabilities.prototype.aspectRatio;

/** @type {number} */
MediaTrackCapabilities.prototype.frameRate;

/** @type {!Array<string>} */
MediaTrackCapabilities.prototype.facingMode;

/** @type {number} */
MediaTrackCapabilities.prototype.volume;

/** @type {number} */
MediaTrackCapabilities.prototype.sampleRate;

/** @type {number} */
MediaTrackCapabilities.prototype.sampleSize;

/** @type {!Array<boolean>} */
MediaTrackCapabilities.prototype.echoCancellation;

/** @type {number} */
MediaTrackCapabilities.prototype.latency;

/** @type {number} */
MediaTrackCapabilities.prototype.channelCount;

/** @type {string} */
MediaTrackCapabilities.prototype.deviceId;

/** @type {string} */
MediaTrackCapabilities.prototype.groupId;

/** @type {!Array<string>} */
MediaTrackCapabilities.prototype.whiteBalanceMode;

/** @type {!Array<string>} */
MediaTrackCapabilities.prototype.exposureMode;

/** @type {!Array<string>} */
MediaTrackCapabilities.prototype.focusMode;

/** @type {!MediaSettingsRange} */
MediaTrackCapabilities.prototype.exposureCompensation;

/** @type {!MediaSettingsRange} */
MediaTrackCapabilities.prototype.colorTemperature

/** @type {!MediaSettingsRange} */
MediaTrackCapabilities.prototype.iso

/** @type {!MediaSettingsRange} */
MediaTrackCapabilities.prototype.brightness

/** @type {!MediaSettingsRange} */
MediaTrackCapabilities.prototype.contrast

/** @type {!MediaSettingsRange} */
MediaTrackCapabilities.prototype.saturation

/** @type {!MediaSettingsRange} */
MediaTrackCapabilities.prototype.sharpness

/** @type {!MediaSettingsRange} */
MediaTrackCapabilities.prototype.zoom

/** @type {boolean} */
MediaTrackCapabilities.prototype.torch

/**
 * @interface
 * @see https://www.w3.org/TR/mediacapture-streams/#media-track-settings
 * @see https://w3c.github.io/mediacapture-image/#mediatracksettings-section
 */
function MediaTrackSettings() {}

/** @type {number} */
MediaTrackSettings.prototype.width;

/** @type {number} */
MediaTrackSettings.prototype.height;

/** @type {number} */
MediaTrackSettings.prototype.aspectRatio;

/** @type {number} */
MediaTrackSettings.prototype.frameRate;

/** @type {string} */
MediaTrackSettings.prototype.facingMode;

/** @type {number} */
MediaTrackSettings.prototype.volume;

/** @type {number} */
MediaTrackSettings.prototype.sampleRate;

/** @type {number} */
MediaTrackSettings.prototype.sampleSize;

/** @type {boolean} */
MediaTrackSettings.prototype.echoCancellation;

/** @type {number} */
MediaTrackSettings.prototype.latency;

/** @type {number} */
MediaTrackSettings.prototype.channelCount;

/** @type {string} */
MediaTrackSettings.prototype.deviceId;

/** @type {string} */
MediaTrackSettings.prototype.groupId;

/** @type {string} */
MediaTrackSettings.prototype.whiteBalanceMode;

/** @type {string} */
MediaTrackSettings.prototype.exposureMode;

/** @type {string} */
MediaTrackSettings.prototype.focusMode;

/** @type {!Array<{x: number, y: number}>} */
MediaTrackSettings.prototype.pointsOfInterest;

/** @type {number} */
MediaTrackSettings.prototype.exposureCompensation;

/** @type {number} */
MediaTrackSettings.prototype.colorTemperature

/** @type {number} */
MediaTrackSettings.prototype.iso

/** @type {number} */
MediaTrackSettings.prototype.brightness

/** @type {number} */
MediaTrackSettings.prototype.contrast

/** @type {number} */
MediaTrackSettings.prototype.saturation

/** @type {number} */
MediaTrackSettings.prototype.sharpness

/** @type {number} */
MediaTrackSettings.prototype.zoom

/** @type {boolean} */
MediaTrackSettings.prototype.torch


/**
 * @interface
 * @see https://w3c.github.io/mediacapture-main/#media-track-supported-constraints
 */
function MediaTrackSupportedConstraints() {}

/** @type {boolean|undefined} */
MediaTrackSupportedConstraints.prototype.width;

/** @type {boolean|undefined} */
MediaTrackSupportedConstraints.prototype.height;

/** @type {boolean|undefined} */
MediaTrackSupportedConstraints.prototype.aspectRatio;

/** @type {boolean|undefined} */
MediaTrackSupportedConstraints.prototype.frameRate;

/** @type {boolean|undefined} */
MediaTrackSupportedConstraints.prototype.facingMode;

/** @type {boolean|undefined} */
MediaTrackSupportedConstraints.prototype.volume;

/** @type {boolean|undefined} */
MediaTrackSupportedConstraints.prototype.sampleRate;

/** @type {boolean|undefined} */
MediaTrackSupportedConstraints.prototype.sampleSize;

/** @type {boolean|undefined} */
MediaTrackSupportedConstraints.prototype.echoCancellation;

/** @type {boolean|undefined} */
MediaTrackSupportedConstraints.prototype.autoGainControl;

/** @type {boolean|undefined} */
MediaTrackSupportedConstraints.prototype.noiseSuppression;

/** @type {boolean|undefined} */
MediaTrackSupportedConstraints.prototype.latency;

/** @type {boolean|undefined} */
MediaTrackSupportedConstraints.prototype.channelCount;

/** @type {boolean|undefined} */
MediaTrackSupportedConstraints.prototype.deviceId;

/** @type {boolean|undefined} */
MediaTrackSupportedConstraints.prototype.groupId;


/**
 * @interface
 * @extends {EventTarget}
 * @see https://www.w3.org/TR/mediacapture-streams/#mediastreamtrack
 */
function MediaStreamTrack() {}

/**
 * @const {string}
 */
MediaStreamTrack.prototype.kind;

/**
 * @const {string}
 */
MediaStreamTrack.prototype.id;

/**
 * @const {string}
 */
MediaStreamTrack.prototype.label;

/**
 * @type {boolean}
 */
MediaStreamTrack.prototype.enabled;

/**
 * @const {boolean}
 */
MediaStreamTrack.prototype.muted;

/**
 * @type {string}
 * @see https://crbug.com/653531
 * @see https://wicg.github.io/mst-content-hint/
 */
MediaStreamTrack.prototype.contentHint;

/**
 * @const {boolean}
 */
MediaStreamTrack.prototype.remote;

/**
 * @type {MediaStreamTrackState}
 * Read only.
 */
MediaStreamTrack.prototype.readyState;

/**
 * @type {?function(!Event)}
 */
MediaStreamTrack.prototype.onmute;

/**
 * @type {?function(!Event)}
 */
MediaStreamTrack.prototype.onunmute;

/**
 * @type {?function(!Event)}
 */
MediaStreamTrack.prototype.onended;

/**
 * @type {?function(!Event)}
 */
MediaStreamTrack.prototype.onoverconstrained;

/**
 * Applies the specified set of constraints to the track, if any specified; or
 * if no constraints are specified, removes all constraints from the track.
 *
 * @param {MediaTrackConstraints=} constraints Constraints to apply to the
 *   track.
 * @return {!Promise<void>} A |Promise| that is resolved when the constraints
 *   have been applied, or rejected if there was an error applying the
 *   constraints.
 */
MediaStreamTrack.prototype.applyConstraints = function(constraints) {};

/**
 * @return {!MediaStreamTrack}
 */
MediaStreamTrack.prototype.clone = function() {};

/** @return {void} */
MediaStreamTrack.prototype.stop = function() {};

/** @return {!MediaTrackCapabilities} */
MediaStreamTrack.prototype.getCapabilities = function() {};

/** @return {!MediaTrackConstraints} */
MediaStreamTrack.prototype.getConstraints = function() {};

/** @return {!MediaTrackSettings} */
MediaStreamTrack.prototype.getSettings = function() {};

/**
 * @typedef {{track: MediaStreamTrack}}
 */
var MediaStreamTrackEventInit;


/**
 * @param {string} type
 * @param {!MediaStreamTrackEventInit} eventInitDict
 * @constructor
 * @extends {Event}
 * @see https://www.w3.org/TR/mediacapture-streams/#mediastreamtrackevent
 */
function MediaStreamTrackEvent(type, eventInitDict) {}

/**
 * @const {!MediaStreamTrack}
 */
MediaStreamTrackEvent.prototype.track;

/**
 * @param {!MediaStream|!Array<!MediaStreamTrack>=} streamOrTracks
 * @constructor
 * @implements {EventTarget}
 * @see https://www.w3.org/TR/mediacapture-streams/#mediastream
 */
function MediaStream(streamOrTracks) {}

/**
 * @override
 */
MediaStream.prototype.addEventListener = function(type, listener,
    opt_useCapture) {};

/**
 * @override
 */
MediaStream.prototype.removeEventListener = function(type, listener,
    opt_useCapture) {};

/**
 * @override
 * @return {boolean}
 */
MediaStream.prototype.dispatchEvent = function(evt) {};

/**
 * TODO(bemasc): Remove this property.
 * @deprecated
 * @const {string}
 */
MediaStream.prototype.label;

/**
 * @const {string}
 */
MediaStream.prototype.id;

/**
 * @return {!Array<!MediaStreamTrack>}
 */
MediaStream.prototype.getAudioTracks = function() {};

/**
 * @return {!Array<!MediaStreamTrack>}
 */
MediaStream.prototype.getVideoTracks = function() {};

/**
 * @return {!Array<!MediaStreamTrack>}
 */
MediaStream.prototype.getTracks = function() {};

/**
 * @param {string} trackId
 * @return {MediaStreamTrack}
 */
MediaStream.prototype.getTrackById = function(trackId) {};

/**
 * @param {!MediaStreamTrack} track
 * @return {undefined}
 */
MediaStream.prototype.addTrack = function(track) {};

/**
 * @param {!MediaStreamTrack} track
 * @return {undefined}
 */
MediaStream.prototype.removeTrack = function(track) {};

/**
 * @return {!MediaStream}
 */
MediaStream.prototype.clone = function() {};

/**
 * @deprecated
 * @type {boolean}
 */
MediaStream.prototype.ended;

/**
 * @deprecated
 * @type {?function(!Event)}
 */
MediaStream.prototype.onended;

/**
 * @type {boolean}
 */
MediaStream.prototype.active;

/**
 * @type {?function(!Event)}
 */
MediaStream.prototype.onactive;

/**
 * @type {?function(!Event)}
 */
MediaStream.prototype.oninactive;

/**
 * @type {?function(!MediaStreamTrackEvent)}
 */
MediaStream.prototype.onaddtrack;

/**
 * @type {?function(!MediaStreamTrackEvent)}
 */
MediaStream.prototype.onremovetrack;

/**
 * @deprecated
 * TODO(bemasc): Remove this method once browsers have updated to
 * MediaStreamTrack.stop().
 * @return {undefined}
 */
MediaStream.prototype.stop = function() {};

/**
 * @typedef {{tone: string}}
 * @see https://www.w3.org/TR/webrtc/#dom-rtcdtmftonechangeeventinit
 */
var RTCDTMFToneChangeEventInit;


/**
 * @param {string} type
 * @param {!RTCDTMFToneChangeEventInit} eventInitDict
 * @constructor
 * @extends {Event}
 * @see https://www.w3.org/TR/webrtc/#dom-rtcdtmftonechangeevent
 */
function RTCDTMFToneChangeEvent(type, eventInitDict) {}

/**
 * @const {string}
 */
RTCDTMFToneChangeEvent.prototype.tone;


/**
 * @interface
 * @see https://www.w3.org/TR/webrtc/#rtcdtmfsender
 */
function RTCDTMFSender() {}

/**
 * @param {string} tones
 * @param {number=} opt_duration
 * @param {number=} opt_interToneGap
 */
RTCDTMFSender.prototype.insertDTMF =
    function(tones, opt_duration, opt_interToneGap) {};

/**
 * @type {?boolean}
 */
RTCDTMFSender.prototype.canInsertDTMF;

/**
 * @type {?function(!RTCDTMFToneChangeEvent)}
 */
RTCDTMFSender.prototype.ontonechange;

/**
 * @const {string}
 */
RTCDTMFSender.prototype.toneBuffer;


/**
 * @typedef {{
 *   mimeType: string,
 *   clockRate: number,
 *   channels: (number|undefined),
 *   sdpFmtpLine: (string|undefined),
 * }}
 *
 * @see https://www.w3.org/TR/webrtc/#dom-rtcrtpcodeccapability
 */
var RTCRtpCodecCapability;


/**
 * @typedef {{
 *   uri: string,
 * }}
 *
 * @see https://www.w3.org/TR/webrtc/#dom-rtcrtpheaderextensioncapability
 */
var RTCRtpHeaderExtensionCapability;


/**
 * @typedef {{
 *   codecs: !Array<!RTCRtpCodecCapability>,
 *   headerExtensions: !Array<!RTCRtpHeaderExtensionCapability>,
 * }}
 *
 * @see https://www.w3.org/TR/webrtc/#dom-rtcrtpcapabilities
 */
var RTCRtpCapabilities;


/**
 * @constructor
 * @see https://www.w3.org/TR/webrtc/#rtcrtpsender-interface
 */
function RTCRtpSender() {}

/**
 * @const {!RTCDTMFSender}
 */
RTCRtpSender.prototype.dtmf;

/**
 * @const {!MediaStreamTrack}
 */
RTCRtpSender.prototype.track;

/**
 * @param {?MediaStreamTrack} track
 * @return {!Promise<void>}
 * @see https://www.w3.org/TR/webrtc/#dom-rtcrtpsender
 */
RTCRtpSender.prototype.replaceTrack = function(track) {};


/**
 * @return {!RTCRtpSendParameters}
 */
RTCRtpSender.prototype.getParameters = function() {};


/**
 * @param {!RTCRtpSendParameters} params
 * @return {!Promise<undefined>}
 */
RTCRtpSender.prototype.setParameters = function(params) {};


/**
 * @return {!Promise<!RTCStatsReport>}
 */
RTCRtpSender.prototype.getStats = function() {};

/**
 * @param {string} kind
 * @return {?RTCRtpCapabilities}
 */
RTCRtpSender.getCapabilities = function(kind) {};


/**
 * @record
 * @see https://www.w3.org/TR/webrtc/#dom-rtcrtpsendparameters
 */
function RTCRtpSendParameters() {}

/**
 * @type {string|undefined}
 */
RTCRtpSendParameters.prototype.transactionId;

/**
 * @type {!Array<!RTCRtpEncodingParameters>}
 */
RTCRtpSendParameters.prototype.encodings;

/**
 * Possible string values are "maintain-framerate", "maintain-resolution", and
 * "balanced".
 * @type {string|undefined}
 */
RTCRtpSendParameters.prototype.degradationPreference;


/**
 * @interface
 * @see https://www.w3.org/TR/webrtc/#dom-rtcrtpcontributingsource
 */
function RTCRtpContributingSource() {}

/**
 * @type {?number}
 */
RTCRtpContributingSource.prototype.source;

/**
 * @type {?Date|number}
 */
RTCRtpContributingSource.prototype.timestamp;

/**
 * @type {number|undefined}
 */
RTCRtpContributingSource.prototype.audioLevel;

/**
 * This is a relatively new field and browsers may not yet be compliant to the
 * spec.
 * @type {?number}
 * @see https://w3c.github.io/webrtc-pc/#dom-rtcrtpcontributingsource-rtptimestamp
 */
RTCRtpContributingSource.prototype.rtpTimestamp;

/**
 * This is a relatively new field and browsers may not yet be compliant to the
 * spec.
 * @type {number|undefined}
 * @see https://w3c.github.io/webrtc-extensions/#dictionary-rtcrtpcontributingsource-members
 */
RTCRtpContributingSource.prototype.captureTimestamp;

/**
 * @constructor
 * @see https://www.w3.org/TR/webrtc/#rtcrtpreceiver-interface
 */
function RTCRtpReceiver() {}

/**
 * @const {!MediaStreamTrack}
 */
RTCRtpReceiver.prototype.track;

/**
 * @return {!Array<!RTCRtpContributingSource>}
 */
RTCRtpReceiver.prototype.getContributingSources = function() {};

/**
 * @return {!Array<!RTCRtpContributingSource>}
 */
RTCRtpReceiver.prototype.getSynchronizationSources = function() {};


/**
 * @return {!Promise<!RTCStatsReport>}
 */
RTCRtpReceiver.prototype.getStats = function() {};

/**
 * Chrome exclusive hint to control jitter buffer delay. Measured in seconds.
 * @see https://henbos.github.io/webrtc-extensions/#dfn-playoutdelayhint
 * @type {?number|undefined}
 */
RTCRtpReceiver.prototype.playoutDelayHint;

/**
 * Get most optimistic view of the capabilities of the system for sending media
 * of the given kind.
 * @see https://www.w3.org/TR/webrtc/#dom-rtcrtpreceiver-getcapabilities
 * @param {!string} kind Media kind: 'video' or 'audio'.
 * @return {!RTCRtpCapabilities}
 */
RTCRtpReceiver.getCapabilities = function(kind) {};

/**
 * @see https://www.w3.org/TR/webrtc/#dom-rtcrtptransceiverinit
 * @record
 */
function RTCRtpTransceiverInit() {}

/**
 * The direction of the `RTCRtpTransceiver`. Defaults to "sendrecv".
 * @type {?RTCRtpTransceiverDirection|undefined}
 */
RTCRtpTransceiverInit.prototype.direction;

/**
 * The streams to add to the tranceiver's sender.
 * @type {?Array<!MediaStream>|undefined}
 */
RTCRtpTransceiverInit.prototype.streams;

/**
 * @type {?Array<!RTCRtpEncodingParameters>|undefined}
 */
RTCRtpTransceiverInit.prototype.sendEncodings;

/**
 * @see https://www.w3.org/TR/webrtc/#dom-rtcrtpencodingparameters
 * @record
 */
function RTCRtpEncodingParameters() {}

/**
 * @type {?number|undefined}
 */
RTCRtpEncodingParameters.prototype.codecPayloadType;

/**
 * Possible values are "disabled" and "enabled".
 * @type {?string|undefined}
 */
RTCRtpEncodingParameters.prototype.dtx;

/**
 * @type {?boolean|undefined}
 */
RTCRtpEncodingParameters.prototype.active;

/**
 * Possible values are "very-low", "low" (default), "medium", and "high".
 * @type {?string|undefined}
 */
RTCRtpEncodingParameters.prototype.priority;

/**
 * Possible values are "very-low", "low" (default), "medium", and "high".
 * @see https://w3c.github.io/webrtc-dscp-exp/
 * @type {?string|undefined}
 */
RTCRtpEncodingParameters.prototype.networkPriority;

/**
 * @type {?number|undefined}
 */
RTCRtpEncodingParameters.prototype.ptime;

/**
 * @type {?number|undefined}
 */
RTCRtpEncodingParameters.prototype.maxBitrate;

/**
 * @type {?number|undefined}
 */
RTCRtpEncodingParameters.prototype.maxFramerate;

/**
 * @type {?string|number}
 */
RTCRtpEncodingParameters.prototype.rid;

/**
 * @type {?number|number}
 */
RTCRtpEncodingParameters.prototype.scaleResolutionDownBy;

/**
 * @see https://w3c.github.io/webrtc-extensions/#dom-rtcrtpencodingparameters-adaptiveptime
 * @type {?boolean|undefined}
 */
RTCRtpEncodingParameters.prototype.adaptivePtime;

/**
 * @interface
 * @see https://www.w3.org/TR/webrtc/#rtcrtptransceiver-interface
 */
function RTCRtpTransceiver() {}

/**
 * @const {?string}
 */
RTCRtpTransceiver.prototype.mid;

/**
 * @const {boolean}
 */
RTCRtpTransceiver.prototype.stopped;

/**
 * @type {!RTCRtpTransceiverDirection}
 */
RTCRtpTransceiver.prototype.direction;

/**
 * @const {?RTCRtpTransceiverDirection}
 */
RTCRtpTransceiver.prototype.currentDirection;

/**
 * @param {!RTCRtpTransceiverDirection} direction
 */
RTCRtpTransceiver.prototype.setDirection = function(direction) {};

/**
 */
RTCRtpTransceiver.prototype.stop = function() {};

/**
 * @const {?RTCRtpSender}
 */
RTCRtpTransceiver.prototype.sender;

/**
 * @const {?RTCRtpReceiver}
 */
RTCRtpTransceiver.prototype.receiver;

/**
 * @param {!Array<!RTCRtpCodecCapability>} codecs
 */
RTCRtpTransceiver.prototype.setCodecPreferences = function(codecs) {};

/**
 * @see https://w3c.github.io/mediacapture-main/getusermedia.html#dom-longrange
 * @record
 */
function LongRange() {}

/**
 * @type {number|undefined}
 */
LongRange.prototype.max;

/**
 * @type {number|undefined}
 */
LongRange.prototype.min;

/**
 * @see https://w3c.github.io/mediacapture-main/getusermedia.html#dom-doublerange
 * @record
 */
function DoubleRange() {}

/**
 * @type {number|undefined}
 */
DoubleRange.prototype.max;

/**
 * @type {number|undefined}
 */
DoubleRange.prototype.min;


/**
 * @see https://w3c.github.io/mediacapture-main/getusermedia.html#dom-constrainbooleanparameters
 * @record
 */
function ConstrainBooleanParameters() {}

/**
 * @type {boolean|undefined}
 */
ConstrainBooleanParameters.prototype.exact;

/**
 * @type {boolean|undefined}
 */
ConstrainBooleanParameters.prototype.ideal;

/**
 * @see https://w3c.github.io/mediacapture-main/getusermedia.html#dom-constraindomstringparameters
 * @record
 */
function ConstrainDOMStringParameters() {}

/**
 * @type {string|Array<string>|undefined}
 */
ConstrainDOMStringParameters.prototype.exact;

/**
 * @type {string|Array<string>|undefined}
 */
ConstrainDOMStringParameters.prototype.ideal;

/**
 * @see https://w3c.github.io/mediacapture-main/getusermedia.html#dom-constraindoublerange
 * @record
 * @extends {DoubleRange}
 */
function ConstrainDoubleRange() {}

/**
 * @type {number|undefined}
 */
ConstrainDoubleRange.prototype.exact;

/**
 * @type {number|undefined}
 */
ConstrainDoubleRange.prototype.ideal;


/**
 * @see https://w3c.github.io/mediacapture-main/getusermedia.html#dom-constrainlongrange
 * @record
 * @extends {LongRange}
 */
function ConstrainLongRange() {}

/**
 * @type {number|undefined}
 */
ConstrainLongRange.prototype.exact;

/**
 * @type {number|undefined}
 */
ConstrainLongRange.prototype.ideal;

/**
 * @see https://w3c.github.io/mediacapture-main/getusermedia.html#dom-constrainboolean
 * @typedef {boolean|ConstrainBooleanParameters}
 */
var ConstrainBoolean;

/**
 * @see https://w3c.github.io/mediacapture-main/getusermedia.html#dom-constraindomString
 * @typedef {string|Array<string>|ConstrainDOMStringParameters}
 */
var ConstrainDOMString;

/**
 * @see https://w3c.github.io/mediacapture-main/getusermedia.html#dom-constraindouble
 * @typedef {number|ConstrainDoubleRange}
 */
var ConstrainDouble;

/**
 * @see https://w3c.github.io/mediacapture-main/getusermedia.html#dom-constrainlong
 * @typedef {number|ConstrainLongRange}
 */
var ConstrainLong;


/**
 * @see https://w3c.github.io/mediacapture-main/getusermedia.html#dom-mediatrackconstraintset
 * @record
 * @private
 */
function MediaTrackConstraintSet() {}

/**
 * @type {ConstrainBoolean|undefined}
 */
MediaTrackConstraintSet.prototype.autoGainControl;

/**
 * @type {ConstrainDouble|undefined}
 */
MediaTrackConstraintSet.prototype.aspectRatio;

/**
 * @type {ConstrainLong|undefined}
 */
MediaTrackConstraintSet.prototype.channelCount;

/**
 * @type {ConstrainDOMString|undefined}
 */
MediaTrackConstraintSet.prototype.deviceId;

/**
 * @type {ConstrainBoolean|undefined}
 */
MediaTrackConstraintSet.prototype.echoCancellation;

/**
 * @type {ConstrainDOMString|undefined}
 */
MediaTrackConstraintSet.prototype.facingMode;

/**
 * @type {ConstrainDouble|undefined}
 */
MediaTrackConstraintSet.prototype.frameRate;

/**
 * @type {ConstrainDOMString|undefined}
 */
MediaTrackConstraintSet.prototype.groupId;

/**
 * @type {ConstrainLong|undefined}
 */
MediaTrackConstraintSet.prototype.height;

/**
 * @type {ConstrainDouble|undefined}
 */
MediaTrackConstraintSet.prototype.latency;

/**
 * @type {ConstrainBoolean|undefined}
 */
MediaTrackConstraintSet.prototype.noiseSuppression;

/**
 * @type {ConstrainLong|undefined}
 */
MediaTrackConstraintSet.prototype.sampleRate;

/**
 * @type {ConstrainLong|undefined}
 */
MediaTrackConstraintSet.prototype.sampleSize;

/**
 * @type {ConstrainDouble|undefined}
 */
MediaTrackConstraintSet.prototype.volume;

/**
 * @type {ConstrainLong|undefined}
 */
MediaTrackConstraintSet.prototype.width;


/**
 * @record
 * @extends {MediaTrackConstraintSet}
 */
function MediaTrackConstraints() {}

/**
 * @type {Array<!MediaTrackConstraintSet>|undefined}
 */
MediaTrackConstraints.prototype.advanced;

/**
 * @see https://w3c.github.io/mediacapture-main/getusermedia.html#media-track-constraints
 * @record
 */
function MediaStreamConstraints() {}

/**
 * @type {boolean|MediaTrackConstraints|undefined}
 */
MediaStreamConstraints.prototype.audio;

/**
 * @type {boolean|MediaTrackConstraints|undefined}
 */
MediaStreamConstraints.prototype.video;

/**
 * @see {http://dev.w3.org/2011/webrtc/editor/getusermedia.html#
 *     navigatorusermediaerror-and-navigatorusermediaerrorcallback}
 * @interface
 */
function NavigatorUserMediaError() {}

/**
 * @const {number}
 * @deprecated Removed from the standard and some browsers.
 */
NavigatorUserMediaError.prototype.PERMISSION_DENIED;

/**
 * @type {number}
 * @deprecated Removed from the standard and some browsers.
 * Read only.
 */
NavigatorUserMediaError.prototype.code;

/**
 * @type {string}
 * Read only.
 */
NavigatorUserMediaError.prototype.name;

/**
 * @type {?string}
 * Read only.
 */
NavigatorUserMediaError.prototype.message;

/**
 * @type {?string}
 * Read only.
 */
NavigatorUserMediaError.prototype.constraintName;

/**
 * @param {string} type
 * @param {!Object} eventInitDict
 * @constructor
 */
function MediaStreamEvent(type, eventInitDict) {}

/**
 * @const {?MediaStream}
 */
MediaStreamEvent.prototype.stream;

/**
 * @record
 * @see https://www.w3.org/TR/mediastream-recording/#dictdef-mediarecorderoptions
 */
function MediaRecorderOptions() {}

/** @type {(string|undefined)} */
MediaRecorderOptions.prototype.mimeType

/** @type {(number|undefined)} */
MediaRecorderOptions.prototype.audioBitsPerSecond

/** @type {(number|undefined)} */
MediaRecorderOptions.prototype.videoBitsPerSecond

/** @type {(number|undefined)} */
MediaRecorderOptions.prototype.bitsPerSecond

/**
 * @see https://www.w3.org/TR/mediastream-recording/#mediarecorder-api
 * @param {!MediaStream} stream
 * @param {MediaRecorderOptions=} options
 * @implements {EventTarget}
 * @constructor
 */
function MediaRecorder(stream, options) {}

/**
 * @override
 */
MediaRecorder.prototype.addEventListener = function(type, listener,
    opt_useCapture) {};

/**
 * @override
 */
MediaRecorder.prototype.removeEventListener = function(type, listener,
    opt_useCapture) {};

/**
 * @override
 * @return {boolean}
 */
MediaRecorder.prototype.dispatchEvent = function(evt) {};

/**
 * @type {!MediaStream}
 */
MediaRecorder.prototype.stream;

/**
 * @type {string}
 */
MediaRecorder.prototype.mimeType;

/**
 * @type {string}
 */
MediaRecorder.prototype.state;

/**
 * @type {(function(!Event)|undefined)}
 */
MediaRecorder.prototype.onstart;

/**
 * @type {(function(!Event)|undefined)}
 */
MediaRecorder.prototype.onstop;

/**
 * @type {(function(!Event)|undefined)}
 */
MediaRecorder.prototype.ondataavailable;

/**
 * @type {(function(!Event)|undefined)}
 */
MediaRecorder.prototype.onpause;

/**
 * @type {(function(!Event)|undefined)}
 */
MediaRecorder.prototype.onresume;

/**
 * @type {(function(!Event)|undefined)}
 */
MediaRecorder.prototype.onerror;

/**
 * @type {number}
 */
MediaRecorder.prototype.videoBitsPerSecond;

/**
 * @type {number}
 */
MediaRecorder.prototype.audioBitsPerSecond;

/**
 * @param {number=} timeslice
 */
MediaRecorder.prototype.start = function(timeslice) {};

/** @return {void} */
MediaRecorder.prototype.stop = function() {};

/** @return {void} */
MediaRecorder.prototype.pause = function() {};

/** @return {void} */
MediaRecorder.prototype.resume = function() {};

/** @return {void} */
MediaRecorder.prototype.requestData = function() {};

/**
 * @param {string} type
 * @return {boolean}
 */
MediaRecorder.isTypeSupported = function(type) {};

/**
 * @constructor
 * @extends {Event}
 * @param {string} type
 * @param {{data: !Blob, timecode: (number|undefined)}} eventInitDict
 * @see https://www.w3.org/TR/mediastream-recording/#blobevent-section
 */
function BlobEvent(type, eventInitDict) {}

/** @type {!Blob} */
BlobEvent.prototype.data;

/** @type {number} */
BlobEvent.prototype.timecode;

/**
 * @interface
 * @see https://w3c.github.io/mediacapture-image/##photosettings-section
 */
function PhotoSettings() {}

/**
 * @type {string}
 */
PhotoSettings.prototype.fillLightMode;

/**
 * @type {number}
 */
PhotoSettings.prototype.imageHeight;

/**
 * @type {number}
 */
PhotoSettings.prototype.imageWidth;

/**
 * @type {boolean}
 */
PhotoSettings.prototype.redEyeReduction;

/**
 * @interface
 * @see https://w3c.github.io/mediacapture-image/##photocapabilities-section
 */
function PhotoCapabilities() {}

/**
 * @const {string}
 */
PhotoCapabilities.prototype.redEyeReduction;

/**
 * @const {!MediaSettingsRange}
 */
PhotoCapabilities.prototype.imageHeight;

/**
 * @const {!MediaSettingsRange}
 */
PhotoCapabilities.prototype.imageWidth;

/**
 * @const {!Array<string>}
 */
PhotoCapabilities.prototype.fillLightMode;

/**
 * @see https://w3c.github.io/mediacapture-image/
 * @param {!MediaStreamTrack} videoTrack
 * @constructor
 */
function ImageCapture(videoTrack) {}

/**
 * @param {!PhotoSettings=} photoSettings
 * @return {!Promise<!Blob>}
 */
ImageCapture.prototype.takePhoto = function(photoSettings) {};

/**
 * @return {!Promise<!PhotoCapabilities>}
 */
ImageCapture.prototype.getPhotoCapabilities = function() {};

/**
 * @return {!Promise<!ImageBitmap>}
 */
ImageCapture.prototype.grabFrame = function() {};

/**
 * @const {!MediaStreamTrack}
 */
ImageCapture.prototype.track;

/**
 * @see https://www.w3.org/TR/webrtc/#rtctrackevent
 * @param {string} type
 * @param {!Object} eventInitDict
 * @constructor
 */
function RTCTrackEvent(type, eventInitDict) {}

/**
 * @const {!RTCRtpReceiver}
 */
RTCTrackEvent.prototype.receiver;

/**
 * @const {!MediaStreamTrack}
 */
RTCTrackEvent.prototype.track;

/**
 * @const {!Array<!MediaStream>}
 */
RTCTrackEvent.prototype.streams;

/**
 * @const {!RTCRtpTransceiver}
 */
RTCTrackEvent.prototype.transceiver;

/**
 * @typedef {string}
 * @see https://www.w3.org/TR/mediacapture-streams/#idl-def-MediaDeviceKind
 * In WebIDL this is an enum with values 'audioinput', 'audiooutput', and
 * 'videoinput', but there is no mechanism in Closure for describing a
 * specialization of the string type.
 */
var MediaDeviceKind;

/**
 * Possible values are "sendrecv", "sendonly", "recvonly", and "inactive".
 * @typedef {string}
 * @see https://www.w3.org/TR/webrtc/#dom-rtcrtptransceiverdirection
 */
var RTCRtpTransceiverDirection;

/**
 * @interface
 */
function MediaDeviceInfo() {}

/** @const {string} */
MediaDeviceInfo.prototype.deviceId;

/** @const {!MediaDeviceKind} */
MediaDeviceInfo.prototype.kind;

/** @const {string} */
MediaDeviceInfo.prototype.label;

/** @const {string} */
MediaDeviceInfo.prototype.groupId;

/**
 * @interface
 * @extends {EventTarget}
 * @see https://www.w3.org/TR/mediacapture-streams/#mediadevices
 */
function MediaDevices() {}

/**
 * @return {!Promise<!Array<!MediaDeviceInfo>>}
 */
MediaDevices.prototype.enumerateDevices = function() {};

/**
 * @see https://developer.mozilla.org/en-US/docs/Web/API/MediaDevices/getUserMedia
 * @param {!MediaStreamConstraints} constraints
 * @return {!Promise<!MediaStream>}
 */
MediaDevices.prototype.getUserMedia = function(constraints) {}

/**
 * @see https://w3c.github.io/mediacapture-screen-share/#dom-mediadevices-getdisplaymedia
 * @param {!MediaStreamConstraints=} constraints
 * @return {!Promise<!MediaStream>}
 */
MediaDevices.prototype.getDisplayMedia = function(constraints) {}

/**
 * @see https://w3c.github.io/mediacapture-main/#dom-mediadevices-getsupportedconstraints
 * @return {!MediaTrackSupportedConstraints}
 */
MediaDevices.prototype.getSupportedConstraints = function()  {}

/** @const {!MediaDevices} */
Navigator.prototype.mediaDevices;

/**
 * @typedef {string}
 * @see https://www.w3.org/TR/webrtc/#rtcsdptype
 * In WebIDL this is an enum with values 'offer', 'pranswer', and 'answer',
 * but there is no mechanism in Closure for describing a specialization of
 * the string type.
 */
var RTCSdpType;

/**
 * @param {!Object=} descriptionInitDict The RTCSessionDescriptionInit
 * dictionary.  This optional argument may have type
 * {type:RTCSdpType, sdp:string}, but neither of these keys are required to be
 * present, and other keys are ignored, so the closest Closure type is Object.
 * @constructor
 * @see https://www.w3.org/TR/webrtc/#rtcsessiondescription-class
 */
function RTCSessionDescription(descriptionInitDict) {}

/**
 * @type {?RTCSdpType}
 * @see https://www.w3.org/TR/webrtc/#dom-rtcsessiondescription-type
 */
RTCSessionDescription.prototype.type;

/**
 * @type {?string}
 * @see https://www.w3.org/TR/webrtc/#dom-rtcsessiondescription-sdp
 */
RTCSessionDescription.prototype.sdp;

/**
 * TODO(bemasc): Remove this definition once it is removed from the browser.
 * @param {string} label The label index (audio/video/data -> 0,1,2)
 * @param {string} sdp The ICE candidate in SDP text form
 * @constructor
 */
function IceCandidate(label, sdp) {}

/**
 * @return {string}
 */
IceCandidate.prototype.toSdp = function() {};

/**
 * @type {?string}
 */
IceCandidate.prototype.label;

/** @record */
function RTCIceCandidateInit() {};

/** @type {?string|undefined} */
RTCIceCandidateInit.prototype.candidate;

/** @type {(?string|undefined)} */
RTCIceCandidateInit.prototype.sdpMid;

/** @type {(?number|undefined)} */
RTCIceCandidateInit.prototype.sdpMLineIndex;

/** @type {(string|undefined)} */
RTCIceCandidateInit.prototype.usernameFragment;

/**
 * @param {!RTCIceCandidateInit=} candidateInitDict  The RTCIceCandidateInit dictionary.
 * @constructor
 * @see https://www.w3.org/TR/webrtc/#rtcicecandidate-interface
 */
function RTCIceCandidate(candidateInitDict) {}

/**
 * @type {?string}
 */
RTCIceCandidate.prototype.candidate;

/**
 * @type {?string}
 */
RTCIceCandidate.prototype.sdpMid;

/**
 * @type {?number}
 */
RTCIceCandidate.prototype.sdpMLineIndex;

/**
 * @typedef {{urls: string}|{urls: !Array<string>}}
 * @private
 * @see https://www.w3.org/TR/webrtc/#rtciceserver-dictionary
 * This dictionary type also has an optional key {credential: ?string}.
 */
var RTCIceServerRecord_;

/**
 * @interface
 * @private
 */
function RTCIceServerInterface_() {}

/**
 * @type {string|!Array<string>}
 */
RTCIceServerInterface_.prototype.urls;

/**
 * @type {?string}
 */
RTCIceServerInterface_.prototype.username;

/**
 * @type {?string}
 */
RTCIceServerInterface_.prototype.credential;

/**
 * This type, and several below it, are constructed as unions between records
 *
 * @typedef {RTCIceServerRecord_|RTCIceServerInterface_}
 * @private
 */
var RTCIceServer;

/**
 * @typedef {{
 *   iceServers: !Array<!RTCIceServer>,
 *   sdpSemantics: (string|undefined)
 * }}
 * @private
 */
var RTCConfigurationRecord_;

/**
 * @interface
 * @private
 */
function RTCConfigurationInterface_() {}

/**
 * @type {!Array<!RTCIceServer>}
 */
RTCConfigurationInterface_.prototype.iceServers;

/**
 * Allows specifying the SDP semantics. Valid values are "plan-b" and
 * "unified-plan".
 *
 * @see {@link https://webrtc.org/web-apis/chrome/unified-plan/}
 * @type {string|undefined}
 */
RTCConfigurationInterface_.prototype.sdpSemantics;

/**
 * @typedef {RTCConfigurationRecord_|RTCConfigurationInterface_}
 */
var RTCConfiguration;

/**
 * @typedef {function(!RTCSessionDescription)}
 */
var RTCSessionDescriptionCallback;

/**
 * @typedef {function(string)}
 */
var RTCPeerConnectionErrorCallback;

/**
 * @typedef {function()}
 */
var RTCVoidCallback;

/**
 * @typedef {string}
 */
var RTCSignalingState;

/**
 * @typedef {string}
 */
var RTCIceConnectionState;

/**
 * @typedef {string}
 */
var RTCIceGatheringState;

/**
 * @see https://www.w3.org/TR/webrtc/#rtcpeerconnectionstate-enum
 * @typedef {string}
 */
var RTCPeerConnectionState;

/**
 * @param {string} type
 * @param {!Object} eventInitDict
 * @constructor
 */
function RTCPeerConnectionIceEvent(type, eventInitDict) {}

/**
 * @const {RTCIceCandidate}
 */
RTCPeerConnectionIceEvent.prototype.candidate;

// Note: The specification of RTCStats types is still under development.
// Declarations here will be updated and removed to follow the development of
// modern browsers, breaking compatibility with older versions as they become
// obsolete.
/**
 * @see https://www.w3.org/TR/webrtc/#dom-rtcstats
 * @interface
 */
function RTCStats() {}

/**
 * @const {?Date|number}
 */
RTCStats.prototype.timestamp;

/**
 * https://www.w3.org/TR/webrtc-stats/#rtcstatstype-str*
 * @const {string}
 */
RTCStats.prototype.type;

/**
 * @const {string}
 */
RTCStats.prototype.id;

/**
 * @see https://www.w3.org/TR/webrtc-stats/#dom-rtcrtpstreamstats
 * @interface
 * @extends {RTCStats}
 */
function RTCRtpStreamStats() {}

/** @const {number} */
RTCRtpStreamStats.prototype.ssrc;

/** @const {string} */
RTCRtpStreamStats.prototype.kind;

/**
 * Safari 13 still uses .mediaType instead of .kind.
 * @const {string}
 */
RTCRtpStreamStats.prototype.mediaType;

/** @const {string} */
RTCRtpStreamStats.prototype.transportId;

/** @const {string} */
RTCRtpStreamStats.prototype.codecId;


/**
 * @see https://www.w3.org/TR/webrtc-stats/#dom-rtcreceivedrtpstreamstats
 * @interface
 * @extends {RTCRtpStreamStats}
 */
function RTCReceivedRtpStreamStats() {}

/** @const {number} */
RTCReceivedRtpStreamStats.prototype.packetsReceived;

/** @const {number} */
RTCReceivedRtpStreamStats.prototype.packetsLost;

/** @const {number} */
RTCReceivedRtpStreamStats.prototype.jitter;

/** @const {number} */
RTCReceivedRtpStreamStats.prototype.packetsDiscarded;

/** @const {number} */
RTCReceivedRtpStreamStats.prototype.packetsRepaired;

/** @const {number} */
RTCReceivedRtpStreamStats.prototype.burstPacketsLost;

/** @const {number} */
RTCReceivedRtpStreamStats.prototype.burstPacketsDiscarded;

/** @const {number} */
RTCReceivedRtpStreamStats.prototype.burstLossCount;

/** @const {number} */
RTCReceivedRtpStreamStats.prototype.burstDiscardCount;

/** @const {number} */
RTCReceivedRtpStreamStats.prototype.burstLossRate;

/** @const {number} */
RTCReceivedRtpStreamStats.prototype.burstDiscardRate;

/** @const {number} */
RTCReceivedRtpStreamStats.prototype.gapLossRate;

/** @const {number} */
RTCReceivedRtpStreamStats.prototype.gapDiscardRate;



/**
 * @see https://www.w3.org/TR/webrtc-stats/#dom-rtcinboundrtpstreamstats
 * @interface
 * @extends {RTCReceivedRtpStreamStats}
 */
function RTCInboundRtpStreamStats() {}

/** @const {string} */
RTCInboundRtpStreamStats.prototype.trackId;

/** @const {string} */
RTCInboundRtpStreamStats.prototype.receiverId;

/** @const {string} */
RTCInboundRtpStreamStats.prototype.remoteId;

/** @const {number} */
RTCInboundRtpStreamStats.prototype.framesDecoded;

/** @const {number} */
RTCInboundRtpStreamStats.prototype.keyFramesDecoded;

/** @const {number} */
RTCInboundRtpStreamStats.prototype.frameWidth;

/** @const {number} */
RTCInboundRtpStreamStats.prototype.frameHeight;

/** @const {number} */
RTCInboundRtpStreamStats.prototype.frameBitDepth;

/** @const {number} */
RTCInboundRtpStreamStats.prototype.framesPerSecond;

/** @const {number} */
RTCInboundRtpStreamStats.prototype.qpSum;

/** @const {number} */
RTCInboundRtpStreamStats.prototype.totalDecodeTime;

/** @const {number} */
RTCInboundRtpStreamStats.prototype.totalInterframeDelay;

/** @const {number} */
RTCInboundRtpStreamStats.prototype.totalSquaredInterFrameDelay;

/** @const {boolean} */
RTCInboundRtpStreamStats.prototype.voiceActivityFlag;

/** @const {?Date|number} */
RTCInboundRtpStreamStats.prototype.lastPacketReceivedTimestamp;

/** @const {number} */
RTCInboundRtpStreamStats.prototype.averageRtcpInterval;

/** @const {number} */
RTCInboundRtpStreamStats.prototype.headerBytesReceived;

/**
 * Not available in Safari 13, Firefox 69 (Chrome 81+ only).
 * @const {number|undefined}
 */
RTCInboundRtpStreamStats.prototype.fecPacketsReceived;

/**
 * Not available in Safari 13, Firefox 69 (Chrome 81+ only).
 * @const {number|undefined}
 */
RTCInboundRtpStreamStats.prototype.fecPacketsDiscarded;

/** @const {number} */
RTCInboundRtpStreamStats.prototype.bytesReceived;

/** @const {number} */
RTCInboundRtpStreamStats.prototype.packetsFailedDecryption;

/** @const {number} */
RTCInboundRtpStreamStats.prototype.packetsDuplicated;

// TODO: record<USVString, unsigned long long> perDscpPacketsReceived;

/** @const {number} */
RTCInboundRtpStreamStats.prototype.nackCount;

/** @const {number} */
RTCInboundRtpStreamStats.prototype.firCount;

/** @const {number} */
RTCInboundRtpStreamStats.prototype.pliCount;

/** @const {number} */
RTCInboundRtpStreamStats.prototype.sliCount;

/** @const {?Date|number} */
RTCInboundRtpStreamStats.prototype.estimatedPlayoutTimestamp;

/**
 * Firefox specific value.
 * @const {number|undefined}
 */
RTCInboundRtpStreamStats.prototype.bitrateMean;

/** @const {number|undefined} */
RTCInboundRtpStreamStats.prototype.jitterBufferDelay;

/** @const {number|undefined} */
RTCInboundRtpStreamStats.prototype.jitterBufferEmittedCount;

/**
 * Experimental chrome stats under this origin trial:
 * https://groups.google.com/a/chromium.org/forum/#!topic/blink-dev/hE2B1iItPDk
 * @const {number|undefined}
 */
RTCInboundRtpStreamStats.prototype.jitterBufferFlushes;

/** @const {number|undefined} */
RTCInboundRtpStreamStats.prototype.totalSamplesReceived;

/** @const {number|undefined} */
RTCInboundRtpStreamStats.prototype.samplesDecodedWithSilk;

/** @const {number|undefined} */
RTCInboundRtpStreamStats.prototype.samplesDecodedWithCelt;

/** @const {number|undefined} */
RTCInboundRtpStreamStats.prototype.concealedSamples;

/**
 * Not available in Safari 13.
 * @const {number|undefined}
 */
RTCInboundRtpStreamStats.prototype.silentConcealedSamples;

/**
 * Not available in Safari 13.
 * @const {number|undefined}
 */
RTCInboundRtpStreamStats.prototype.concealmentEvents;

/**
 * Not available in Safari 13.
 * @const {number|undefined}
 */
RTCInboundRtpStreamStats.prototype.insertedSamplesForDeceleration

/**
 * Not available in Safari 13.
 * @const {number|undefined}
 */
RTCInboundRtpStreamStats.prototype.removedSamplesForAcceleration;

/**
 * Experimental chrome stats under this origin trial:
 * https://groups.google.com/a/chromium.org/forum/#!topic/blink-dev/hE2B1iItPDk
 * @const {number|undefined}
 */
RTCInboundRtpStreamStats.prototype.delayedPacketOutageSamples;

/**
 * Safari still reprorting it as inbound-rtp, it supposed to be in remote part.
 * @const {number|undefined}
 */
RTCInboundRtpStreamStats.prototype.fractionLost;

/** @const {number} */
RTCInboundRtpStreamStats.prototype.audioLevel;

/** @const {number|undefined} */
RTCInboundRtpStreamStats.prototype.totalAudioEnergy;

/** @const {number|undefined} */
RTCInboundRtpStreamStats.prototype.totalSamplesDuration;

/** @const {number|undefined} */
RTCInboundRtpStreamStats.prototype.framesReceived;

/** @const {string|undefined} */
RTCInboundRtpStreamStats.prototype.decoderImplementation;



/**
 * @see https://www.w3.org/TR/webrtc-stats/#dom-rtcremoteinboundrtpstreamstats
 * @interface
 * @extends {RTCReceivedRtpStreamStats}
 */
function RTCRemoteInboundRtpStreamStats() {}

/** @const {string} */
RTCRemoteInboundRtpStreamStats.prototype.localId;

/** @const {number} */
RTCRemoteInboundRtpStreamStats.prototype.roundTripTime;

/** @const {number} */
RTCRemoteInboundRtpStreamStats.prototype.fractionLost;


/**
 * @see https://www.w3.org/TR/webrtc-stats/#dom-rtcsentrtpstreamstats
 * @interface
 * @extends {RTCRtpStreamStats}
 */
function RTCSentRtpStreamStats() {}

/** @const {number} */
RTCSentRtpStreamStats.prototype.packetsSent;

/** @const {number} */
RTCSentRtpStreamStats.prototype.packetsDiscardedOnSend;

/** @const {number} */
RTCSentRtpStreamStats.prototype.fecPacketsSent;

/** @const {number} */
RTCSentRtpStreamStats.prototype.bytesSent;

/** @const {number} */
RTCSentRtpStreamStats.prototype.bytesDiscardedOnSend;


/**
/**
 * @see https://www.w3.org/TR/webrtc-stats/#dom-rtcoutboundrtpstreamstats
 * @interface
 * @extends {RTCSentRtpStreamStats}
 */
function RTCOutboundRtpStreamStats() {}

/** @const {string} */
RTCOutboundRtpStreamStats.prototype.trackId;

/** @const {string} */
RTCOutboundRtpStreamStats.prototype.senderId;

/** @const {string} */
RTCOutboundRtpStreamStats.prototype.remoteId;

/** @const {number} */
RTCOutboundRtpStreamStats.prototype.lastPacketSentTimestamp;

/** @const {number} */
RTCOutboundRtpStreamStats.prototype.targetBitrate;

/** @const {number} */
RTCOutboundRtpStreamStats.prototype.framesEncoded;

/** @const {number} */
RTCOutboundRtpStreamStats.prototype.totalEncodeTime;

/** @const {number} */
RTCOutboundRtpStreamStats.prototype.averageRTCPInterval;

/** @const {number|undefined} */
RTCOutboundRtpStreamStats.prototype.qualityLimitationResolutionChanges;

/** @const {string|undefined} */
RTCOutboundRtpStreamStats.prototype.qualityLimitationReason;

/** @const {string} */
RTCOutboundRtpStreamStats.prototype.mediaSourceId;

/** @const {number} */
RTCOutboundRtpStreamStats.prototype.frameWidth;

/** @const {number} */
RTCOutboundRtpStreamStats.prototype.frameHeight;

/** @const {number} */
RTCOutboundRtpStreamStats.prototype.qpSum;

/**
 * Firefox specific value.
 * @const {number|undefined}
 */
RTCOutboundRtpStreamStats.prototype.bitrateMean;

/** @const {number} */
RTCOutboundRtpStreamStats.prototype.nackCount;

/** @const {number} */
RTCOutboundRtpStreamStats.prototype.firCount;

/** @const {number} */
RTCOutboundRtpStreamStats.prototype.pliCount;

/** @const {number} */
RTCOutboundRtpStreamStats.prototype.sliCount;

/** @const {string|undefined} */
RTCOutboundRtpStreamStats.prototype.encoderImplementation;


/**
 * @see https://www.w3.org/TR/webrtc-stats/#dom-rtcremoteoutboundrtpstreamstats
 * @interface
 * @extends {RTCSentRtpStreamStats}
 */
function RTCRemoteOutboundRtpStreamStats() {}

/** @const {string} */
RTCRemoteOutboundRtpStreamStats.prototype.localId;

/** @const {?Date|number} */
RTCRemoteOutboundRtpStreamStats.prototype.remoteTimestamp;


/**
 * @see https://www.w3.org/TR/webrtc-stats/#transportstats-dict*
 * @interface
 * @extends {RTCStats}
 */
function RTCTransportStats() {}

/** @type {number} */
RTCTransportStats.prototype.packetsSent;

/** @type {number} */
RTCTransportStats.prototype.packetsReceived;

/** @type {number} */
RTCTransportStats.prototype.bytesSent;

/** @type {number} */
RTCTransportStats.prototype.bytesReceived;

/** @type {string} */
RTCTransportStats.prototype.rtcpTransportStatsId;

/**
 * @type {string}
 * Set of possible string values: 'unknown', 'controlling', 'controlled'.
 */
RTCTransportStats.prototype.iceRole;

/**
 * @type {string}
 * Set of possible string values: 'new', 'connecting', 'connected',
 * 'closed', 'failed'.
 */
RTCTransportStats.prototype.dtlsState;

/** @type {string} */
RTCTransportStats.prototype.selectedCandidatePairId;

/** @type {string} */
RTCTransportStats.prototype.localCertificateId;

/** @type {string} */
RTCTransportStats.prototype.remoteCertificateId;

/** @type {string} */
RTCTransportStats.prototype.tlsVersion;

/** @type {string} */
RTCTransportStats.prototype.dtlsCipher;

/** @type {string} */
RTCTransportStats.prototype.srtpCipher;

/** @type {string} */
RTCTransportStats.prototype.tlsGroup;

/** @type {number} */
RTCTransportStats.prototype.selectedCandidatePairChanges;


/**
 * @see https://w3c.github.io/webrtc-stats/#dom-rtcmediasourcestats
 * @interface
 * @extends {RTCStats}
 */
function RTCMediaSourceStats() {}

/** @const {string} */
RTCMediaSourceStats.prototype.trackIdentifier;

/** @const {string} */
RTCMediaSourceStats.prototype.kind;

/**
 * @see https://w3c.github.io/webrtc-stats/#dom-rtcvideosourcestats
 * @interface
 * @extends {RTCMediaSourceStats}
 */
function RTCVideoSourceStats() {}

/** @const {number} */
RTCVideoSourceStats.prototype.width;

/** @const {number} */
RTCVideoSourceStats.prototype.height;

/** @const {number} */
RTCVideoSourceStats.prototype.bitDepth;

/** @const {number} */
RTCVideoSourceStats.prototype.frames;

/** @const {number} */
RTCVideoSourceStats.prototype.framesPerSecond;

/**
 * @see https://w3c.github.io/webrtc-stats/#dom-rtcaudiosourcestats
 * @interface
 * @extends {RTCMediaSourceStats}
 */
function RTCAudioSourceStats() {}

/** @const {number} */
RTCAudioSourceStats.prototype.audioLevel;

/** @const {number} */
RTCAudioSourceStats.prototype.totalAudioEnergy;

/** @const {number} */
RTCAudioSourceStats.prototype.totalSamplesDuration;

/** @const {number} */
RTCAudioSourceStats.prototype.echoReturnLoss;

/** @const {number} */
RTCAudioSourceStats.prototype.echoReturnLossEnhancement;


/**
 * @interface
 * @extends {Iterable<!Array<string|!RTCStats>>}
 * @see https://w3c.github.io/webrtc-pc/#rtcstatsreport-object
 */
function RTCStatsReport() {}

/**
 * @const {?Date|number}
 */
RTCStatsReport.prototype.timestamp;

/**
 * @return {!Array<string>}
 */
RTCStatsReport.prototype.names = function() {};

/**
 * @param {string} name
 * @return {string}
 */
RTCStatsReport.prototype.stat = function(name) {};

/**
 * @deprecated
 * @const {RTCStatsReport}
 */
RTCStatsReport.prototype.local;

/**
 * @deprecated
 * @const {RTCStatsReport}
 */
RTCStatsReport.prototype.remote;

/**
 * @const {string}
 */
RTCStatsReport.prototype.type;

/**
 * @const {string}
 */
RTCStatsReport.prototype.id;

// Note: Below are Map like methods supported by WebRTC statistics
// specification-compliant RTCStatsReport. Currently only implemented by
// Mozilla.
// See https://www.w3.org/TR/webrtc/#rtcstatsreport-object for definition.
/**
 * @param {function(this:SCOPE, !RTCStats, string, MAP)} callback
 * @param {SCOPE=} opt_thisObj The value of "this" inside callback function.
 * @this {MAP}
 * @template MAP,SCOPE
 */
RTCStatsReport.prototype.forEach = function(callback, opt_thisObj) {};

/**
 * @param {string} key
 * @return {!IteratorIterable<!Array<string|!RTCStats>>}
 */
RTCStatsReport.prototype.entries = function(key) {};

/**
 * @param {string} key
 * @return {!RTCStats}
 */
RTCStatsReport.prototype.get = function(key) {};

/**
 * @return {!IteratorIterable<string>}
 */
RTCStatsReport.prototype.keys = function() {};

/**
 * @return {!IteratorIterable<!RTCStats>}
 */
RTCStatsReport.prototype.values = function() {};

/**
 * @param {string} key
 * @return {boolean}
 */
RTCStatsReport.prototype.has = function(key) {};

/**
 * @const {number}
 */
RTCStatsReport.prototype.size;

/**
 * @return {!Iterator<!Array<string|!RTCStats>>}
 */
RTCStatsReport.prototype[Symbol.iterator] = function() {};


/**
 * TODO(bemasc): Remove this type once it is no longer in use.  It has already
 * been removed from the specification.
 * @typedef {RTCStatsReport}
 * @deprecated
 */
var RTCStatsElement;

/**
 * @interface
 */
function RTCStatsResponse() {}

/**
 * @return {!Array<!RTCStatsReport>}
 */
RTCStatsResponse.prototype.result = function() {};

/**
 * @typedef {function(!RTCStatsResponse, MediaStreamTrack=)}
 */
var RTCStatsCallback;

/**
 * This type is not yet standardized, so the properties here only represent
 * the current capabilities of libjingle (and hence Chromium).
 * TODO(bemasc): Add a link to the relevant standard once MediaConstraint has a
 * standard definition.
 *
 * @interface
 * @private
 */
function MediaConstraintSetInterface_() {}

/**
 * @type {?boolean}
 */
MediaConstraintSetInterface_.prototype.OfferToReceiveAudio;

/**
 * @type {?boolean}
 */
MediaConstraintSetInterface_.prototype.OfferToReceiveVideo;

/**
 * @type {?boolean}
 */
MediaConstraintSetInterface_.prototype.DtlsSrtpKeyAgreement;

/**
 * @type {?boolean}
 */
MediaConstraintSetInterface_.prototype.RtpDataChannels;

/**
 * TODO(bemasc): Make this type public once it is defined in a standard.
 *
 * @typedef {Object|MediaConstraintSetInterface_}
 * @private
 */
var MediaConstraintSet_;

/**
 * @interface
 * @private
 */
function MediaConstraintsInterface_() {}

/**
 * @type {?MediaConstraintSet_}
 */
MediaConstraintsInterface_.prototype.mandatory;

/**
 * @type {?Array<!MediaConstraintSet_>}
 */
MediaConstraintsInterface_.prototype.optional;

/**
 * This type is used extensively in
 * {@see http://dev.w3.org/2011/webrtc/editor/webrtc.html} but is not yet
 * defined.
 *
 * @typedef {Object|MediaConstraintsInterface_}
 */
var MediaConstraints;

/**
 * @interface
 * @extends {EventTarget}
 * @see https://w3c.github.io/webrtc-pc/#dom-rtcdatachannel
 */
function RTCDataChannel() {}

/**
 * @const {string}
 */
RTCDataChannel.prototype.label;

/**
 * @const {boolean}
 */
RTCDataChannel.prototype.reliable;

/**
 * An enumerated string type (RTCDataChannelState) with values:
 * "connecting", "open", "closing", and "closed".
 * @type {string}
 * Read only.
 */
RTCDataChannel.prototype.readyState;

/**
 * @type {number}
 * Read only.
 */
RTCDataChannel.prototype.bufferedAmount;

/**
 * @type {number}
 */
RTCDataChannel.prototype.bufferedAmountLowThreshold;

/**
 * @type {?function(!Event)}
 */
RTCDataChannel.prototype.onopen;

/**
 * @type {?function(!Event)}
 */
RTCDataChannel.prototype.onerror;

/**
 * @type {?function(!Event)}
 */
RTCDataChannel.prototype.onclose;

RTCDataChannel.prototype.close = function() {};

/**
 * @type {?function(!MessageEvent<*>)}
 */
RTCDataChannel.prototype.onmessage;

/**
 * @type {?function(!Event)}
 */
RTCDataChannel.prototype.onbufferedamountlow;

/**
 * @type {string}
 */
RTCDataChannel.prototype.binaryType;

/**
 * @param {string|!Blob|!ArrayBuffer|!ArrayBufferView} data
 * @return {undefined}
 */
RTCDataChannel.prototype.send = function(data) {};

/**
 * @constructor
 * @extends {Event}
 * @private
 */
function RTCDataChannelEvent() {}

/**
 * @type {!RTCDataChannel}
 * Read only.
 */
RTCDataChannelEvent.prototype.channel;

/**
 * @typedef {{reliable: boolean}}
 */
var RTCDataChannelInitRecord_;

/**
 * @interface
 * @private
 */
function RTCDataChannelInitInterface_() {}

/**
 * @type {boolean}
 */
RTCDataChannelInitInterface_.prototype.reliable;

/**
 * @typedef {{
 *   ordered: (boolean|undefined),
 *   maxPacketLifeTime: (number|undefined),
 *   maxRetransmits: (number|undefined),
 *   protocol: (string|undefined),
 *   negotiated: (boolean|undefined),
 *   id: (number|undefined),
 *   priority: (string|undefined),
 * }}
 * see https://www.w3.org/TR/webrtc/#dom-rtcdatachannelinit for documentation
 * Type inconsistencies due to Closure limitations:
 * maxPacketLifeTime should be UnsignedShort
 * maxRetransmits should be UnsignedShort
 * protocol should be USVString
 * id should be UnsignedShort
 * In WebIDL priority is an enum with values 'very-low', 'low',
 * 'medium' and 'high', but there is no mechanism in Closure for describing
 * a specialization of the string type.
 */
var RTCDataChannelInitDictionary_;

/**
 * @typedef {RTCDataChannelInitInterface_|RTCDataChannelInitRecord_|RTCDataChannelInitDictionary_}
 */
var RTCDataChannelInit;

/**
 * @typedef {{expires: number}}
 */
var RTCCertificate;

/**
 * @param {RTCConfiguration} configuration
 * @param {!MediaConstraints=} constraints
 * @constructor
 * @implements {EventTarget}
 * @see https://www.w3.org/TR/webrtc/#interface-definition
 */
function RTCPeerConnection(configuration, constraints) {}

/**
 * @param {Object} keygenAlgorithm
 * @return {Promise<RTCCertificate>}
 */
RTCPeerConnection.generateCertificate = function (keygenAlgorithm) {};

/**
 * @override
 */
RTCPeerConnection.prototype.addEventListener = function(
    type, listener, opt_useCapture) {};

/**
 * @override
 */
RTCPeerConnection.prototype.removeEventListener = function(
    type, listener, opt_useCapture) {};

/**
 * @override
 * @return {boolean}
 */
RTCPeerConnection.prototype.dispatchEvent = function(evt) {};


// NB: Until closure annotations support overloading, many of the following
// functions take odd unions of parameter types.  This is to support the various
// api differences between browsers.  Generally, returning a promise means you
// don't take callback function parameters and draw any further parameters
// forward, and vice versa.

/**
 * @param {(!RTCSessionDescriptionCallback|!MediaConstraints)=}
 *    successCallbackOrConstraints
 * @param {!RTCPeerConnectionErrorCallback=} errorCallback
 * @param {!MediaConstraints=} constraints
 * @return {!Promise<!RTCSessionDescription>|undefined}
 */
RTCPeerConnection.prototype.createOffer = function(successCallbackOrConstraints,
    errorCallback, constraints) {};

/**
 * @param {(!RTCSessionDescriptionCallback|!MediaConstraints)=}
 *    successCallbackOrConstraints
 * @param {!RTCPeerConnectionErrorCallback=} errorCallback
 * @param {!MediaConstraints=} constraints
 * @return {!Promise<!RTCSessionDescription>|undefined}
 */
RTCPeerConnection.prototype.createAnswer =
    function(successCallbackOrConstraints, errorCallback, constraints) {};

/**
 * @param {!RTCSessionDescription=} description
 * @param {!RTCVoidCallback=} successCallback
 * @param {!RTCPeerConnectionErrorCallback=} errorCallback
 * @return {!Promise<!RTCSessionDescription>}
 */
RTCPeerConnection.prototype.setLocalDescription = function(description,
    successCallback, errorCallback) {};

/**
 * @param {!RTCSessionDescription} description
 * @param {!RTCVoidCallback=} successCallback
 * @param {!RTCPeerConnectionErrorCallback=} errorCallback
 * @return {!Promise<!RTCSessionDescription>}
 */
RTCPeerConnection.prototype.setRemoteDescription = function(description,
    successCallback, errorCallback) {};

/**
 * @type {?RTCSessionDescription}
 * Read only.
 */
RTCPeerConnection.prototype.localDescription;

/**
 * @type {?RTCSessionDescription}
 * Read only.
 */
RTCPeerConnection.prototype.remoteDescription;

/**
 * @type {RTCSignalingState}
 * Read only.
 */
RTCPeerConnection.prototype.signalingState;

/**
 * @param {?RTCConfiguration=} configuration
 * @param {?MediaConstraints=} constraints
 * @return {undefined}
 */
RTCPeerConnection.prototype.updateIce = function(configuration, constraints) {};

/**
 * Void in Chrome for now, a promise that you can then/catch in Firefox.
 * @param {!RTCIceCandidate} candidate
 * @param {!RTCVoidCallback=} successCallback
 * @param {function(DOMException)=} errorCallback
 * @return {!Promise|undefined}
 */
RTCPeerConnection.prototype.addIceCandidate = function(candidate, successCallback, errorCallback) {};

/**
 * @type {!RTCIceGatheringState}
 * Read only.
 */
RTCPeerConnection.prototype.iceGatheringState;

/**
 * @type {!RTCIceConnectionState}
 * Read only.
 */
RTCPeerConnection.prototype.iceConnectionState;

/**
 * @type {!RTCPeerConnectionState}
 * Read only.
 */
RTCPeerConnection.prototype.connectionState;

/**
 * @return {!Array<!MediaStream>}
 */
RTCPeerConnection.prototype.getLocalStreams = function() {};

/**
 * @return {!Array<!MediaStream>}
 */
RTCPeerConnection.prototype.getRemoteStreams = function() {};

/**
 * @param {string} streamId
 * @return {MediaStream}
 */
RTCPeerConnection.prototype.getStreamById = function(streamId) {};

/**
 * @return {!Array<!RTCRtpSender>}
 */
RTCPeerConnection.prototype.getSenders = function() {};

/**
 * @return {!Array<!RTCRtpReceiver>}
 */
RTCPeerConnection.prototype.getReceivers = function() {};

/**
 * @param {?string} label
 * @param {RTCDataChannelInit=} dataChannelDict
 * @return {!RTCDataChannel}
 */
RTCPeerConnection.prototype.createDataChannel =
    function(label, dataChannelDict) {};
/**
 * @param {!MediaStream} stream
 * @param {!MediaConstraints=} constraints
 * @return {undefined}
 */
RTCPeerConnection.prototype.addStream = function(stream, constraints) {};

/**
 * @param {!MediaStream} stream
 * @return {undefined}
 */
RTCPeerConnection.prototype.removeStream = function(stream) {};

/**
 * @param {!MediaStreamTrack} track
 * @param {!MediaStream} stream
 * @param {...MediaStream} var_args Additional streams.
 * @return {!RTCRtpSender}
 */
RTCPeerConnection.prototype.addTrack = function(track, stream, var_args) {};

/**
 * @param {!MediaStreamTrack|string} trackOrKind
 * @param {?RTCRtpTransceiverInit=} init
 * @return {!RTCRtpTransceiver}
 */
RTCPeerConnection.prototype.addTransceiver = function(trackOrKind, init) {};

/**
 * Returns the list of transceivers are currently attached to this peer.
 *
 * @return {!Array<!RTCRtpTransceiver>}
 */
RTCPeerConnection.prototype.getTransceivers = function() {};

/**
 * @return {!RTCConfiguration}
 */
RTCPeerConnection.prototype.getConfiguration = function() {};

/**
 * @param {!RTCConfiguration} configuration
 * @return {undefined}
 */
RTCPeerConnection.prototype.setConfiguration = function(configuration) {};

/**
 * @param {!RTCRtpSender} sender
 * @return {undefined}
 */
RTCPeerConnection.prototype.removeTrack = function(sender) {};

// TODO(bemasc): Add identity provider stuff once implementations exist

// TODO(rjogrady): Per w3c spec, getStats() should always return a Promise.
// Remove RTCStatsReport from the return value once Firefox supports that.
/**
 * Firefox' getstats is synchronous and returns a much simpler
 * {!RTCStatsReport} Map-like object.
 * @param {!RTCStatsCallback=} successCallback
 * @param {MediaStreamTrack=} selector
 * @return {undefined|!RTCStatsReport|!Promise<!RTCStatsReport>}
 */
RTCPeerConnection.prototype.getStats = function(successCallback, selector) {};

RTCPeerConnection.prototype.close = function() {};

/**
 * @type {?function(!Event)}
 */
RTCPeerConnection.prototype.onnegotiationneeded;

/**
 * @type {?function(!RTCPeerConnectionIceEvent)}
 */
RTCPeerConnection.prototype.onicecandidate;

/**
 * @type {?function(!Event)}
 */
RTCPeerConnection.prototype.onicegatheringstatechange;

/**
 * @type {?function(!Event)}
 */
RTCPeerConnection.prototype.onsignalingstatechange;

/**
 * @type {?function(!MediaStreamEvent)}
 */
RTCPeerConnection.prototype.onaddstream;

/**
 * @type {?function(!RTCTrackEvent)}
 */
RTCPeerConnection.prototype.ontrack;

/**
 * @type {?function(!MediaStreamEvent)}
 */
RTCPeerConnection.prototype.onremovestream;

/**
 * @type {?function(!Event)}
 */
RTCPeerConnection.prototype.oniceconnectionstatechange;

/**
 * @type {?function(!RTCDataChannelEvent)}
 */
RTCPeerConnection.prototype.ondatachannel;

/**
 * @type {?function(!Event)}
 */
RTCPeerConnection.prototype.onconnectionstatechange;

/**
 * @typedef {string}
 * @see https://www.w3.org/TR/webrtc/#dom-rtcerrordetailtype
 * Possible values: 'data-channel-failure', 'dtls-failure',
 *   'fingerprint-failure', 'sctp-failure', 'sdp-syntax-error',
 *   'hardware-encoder-not-available', 'hardware-encoder-error'
 */
var RTCErrorDetailType;

/**
 * @see https://www.w3.org/TR/webrtc/#rtcerror-interface
 * @interface
 */
function RTCError() {}

/** @const {!RTCErrorDetailType} */
RTCError.prototype.errorDetail;

/** @const {number|undefined} */
RTCError.prototype.sdpLineNumber;

/** @const {number|undefined} */
RTCError.prototype.httpRequestStatusCode;

/** @const {number|undefined} */
RTCError.prototype.sctpCauseCode;

/** @const {number|undefined} */
RTCError.prototype.receivedAlert;

/** @const {number|undefined} */
RTCError.prototype.sentAlert;

/**
 * @see https://www.w3.org/TR/webrtc/#rtcerrorevent-interface
 * @interface
 */
function RTCErrorEvent() {}

/** @const {!RTCError} */
RTCErrorEvent.prototype.error;

/** @const {string} */
RTCErrorEvent.prototype.message;
