/*
 * Copyright 2019 The Closure Compiler Authors.
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
 * @fileoverview MediaCapabilities externs.
 * Based on {@link https://w3c.github.io/media-capabilities/ MC draft 6 November
 * 2019}.
 * @externs
 */

/**
 * @typedef {string}
 * @see https://w3c.github.io/media-capabilities/#enumdef-hdrmetadatatype
 */
var HdrMetadataType;

/**
 * @typedef {string}
 * @see https://w3c.github.io/media-capabilities/#enumdef-colorgamut
 */
var ColorGamut;

/**
 * @typedef {string}
 * @see https://w3c.github.io/media-capabilities/#enumdef-transferfunction
 */
var TransferFunction;

/**
 * @typedef {string}
 * @see https://w3c.github.io/media-capabilities/#enumdef-mediadecodingtype
 */
var MediaDecodingType;

/**
 * @typedef {string}
 * @see https://w3c.github.io/media-capabilities/#enumdef-mediaencodingtype
 */
var MediaEncodingType;

/**
 * @typedef {{
 *   contentType: string,
 *   width: number,
 *   height: number,
 *   bitrate: number,
 *   framerate: number,
 *   hasAlphaChannel: (boolean|undefined),
 *   hdrMetadataType: (!HdrMetadataType|undefined),
 *   colorGamut: (!ColorGamut|undefined),
 *   transferFunction: (!TransferFunction|undefined)
 * }}
 * @see https://w3c.github.io/media-capabilities/#dictdef-videoconfiguration
 */
var VideoConfiguration;

// NOTE: channels definition below is not yet stable in the spec as of Dec 2019.
// "The channels needs to be defined as a double (2.1, 4.1, 5.1, ...), an
// unsigned short (number of channels) or as an enum value. The current
// definition is a placeholder."
/**
 * @typedef {{
 *   contentType: string,
 *   channels: (*|undefined),
 *   bitrate: (number|undefined),
 *   samplerate: (number|undefined),
 *   spatialRendering: (boolean|undefined)
 * }}
 * @see https://w3c.github.io/media-capabilities/#dictdef-audioconfiguration
 */
var AudioConfiguration;

// NOTE: encryptionScheme is not yet in the MC spec as of Dec 2019, but has
// already landed in EME and should be in MC soon.
// https://github.com/w3c/media-capabilities/issues/100
/**
 * @typedef {{
 *   robustness: (string|undefined),
 *   encryptionScheme: (string|undefined)
 * }}
 * @see https://w3c.github.io/media-capabilities/#dictdef-keysystemtrackconfiguration
 */
var KeySystemTrackConfiguration;

/**
 * @typedef {{
 *   keySystem: string,
 *   initDataType: (string|undefined),
 *   distinctiveIdentifier: (string|undefined),
 *   persistentState: (string|undefined),
 *   sessionTypes: (!Array<string>|undefined),
 *   audio: (!KeySystemTrackConfiguration|undefined),
 *   video: (!KeySystemTrackConfiguration|undefined)
 * }}
 * @see https://w3c.github.io/media-capabilities/#dictdef-mediacapabilitieskeysystemconfiguration
 */
var MediaCapabilitiesKeySystemConfiguration;

/**
 * @record
 * @see https://w3c.github.io/media-capabilities/#dictdef-mediaconfiguration
 */
function MediaConfiguration() {}

/** @type {!VideoConfiguration|undefined} */
MediaConfiguration.prototype.video;

/** @type {!AudioConfiguration|undefined} */
MediaConfiguration.prototype.audio;

/**
 * @record
 * @extends {MediaConfiguration}
 * @see https://w3c.github.io/media-capabilities/#dictdef-mediadecodingconfiguration
 */
function MediaDecodingConfiguration() {}

/** @type {!MediaDecodingType} */
MediaDecodingConfiguration.prototype.type;

/** @type {!MediaCapabilitiesKeySystemConfiguration|undefined} */
MediaDecodingConfiguration.prototype.keySystemConfiguration;

/**
 * @record
 * @extends {MediaConfiguration}
 * @see https://w3c.github.io/media-capabilities/#dictdef-mediaencodingconfiguration
 */
function MediaEncodingConfiguration() {}

/** @type {!MediaEncodingType} */
MediaEncodingConfiguration.prototype.type;

/**
 * @record
 * @see https://w3c.github.io/media-capabilities/#dictdef-mediacapabilitiesinfo
 */
function MediaCapabilitiesInfo() {}

/** @type {boolean} */
MediaCapabilitiesInfo.prototype.supported;

/** @type {boolean} */
MediaCapabilitiesInfo.prototype.smooth;

/** @type {boolean} */
MediaCapabilitiesInfo.prototype.powerEfficient;

/**
 * @record
 * @extends {MediaCapabilitiesInfo}
 * @see https://w3c.github.io/media-capabilities/#dictdef-mediacapabilitiesdecodinginfo
 */
function MediaCapabilitiesDecodingInfo() {}

/** @type {?MediaKeySystemAccess} */
MediaCapabilitiesDecodingInfo.prototype.keySystemAccess;

/** @type {!MediaDecodingConfiguration} */
MediaCapabilitiesDecodingInfo.prototype.configuration;

/**
 * @record
 * @extends {MediaCapabilitiesInfo}
 * @see https://w3c.github.io/media-capabilities/#dictdef-mediacapabilitiesencodinginfo
 */
function MediaCapabilitiesEncodingInfo() {}

/** @type {!MediaEncodingConfiguration} */
MediaCapabilitiesEncodingInfo.prototype.configuration;

/**
 * @interface
 * @see https://w3c.github.io/media-capabilities/#mediacapabilities
 */
function MediaCapabilities() {}

/**
 * @param {!MediaDecodingConfiguration} configuration
 * @return {!Promise<!MediaCapabilitiesDecodingInfo>}
 */
MediaCapabilities.prototype.decodingInfo = function(configuration) {};

/**
 * @param {!MediaEncodingConfiguration} configuration
 * @return {!Promise<!MediaCapabilitiesEncodingInfo>}
 */
MediaCapabilities.prototype.encodingInfo = function(configuration) {};

/** @const {?MediaCapabilities} */
Navigator.prototype.mediaCapabilities;

/** @const {?MediaCapabilities} */
WorkerNavigator.prototype.mediaCapabilities;
