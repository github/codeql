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
 * @fileoverview Definitions for W3C's Geolocation specification
 *     http://www.w3.org/TR/geolocation-API/
 * @externs
 */

/**
 * @constructor
 * @see http://www.w3.org/TR/geolocation-API/#geolocation
 */
function Geolocation() {}

/**
 * @typedef {function(!GeolocationPosition): void}
 */
var PositionCallback;

/**
 * @typedef {function(!GeolocationPositionError): void}
 */
var PositionErrorCallback;

/**
 * @param {PositionCallback} successCallback
 * @param {PositionErrorCallback=} opt_errorCallback
 * @param {GeolocationPositionOptions=} opt_options
 * @return {undefined}
 */
Geolocation.prototype.getCurrentPosition = function(successCallback,
                                                       opt_errorCallback,
                                                       opt_options) {};

/**
 * @param {PositionCallback} successCallback
 * @param {PositionErrorCallback=} opt_errorCallback
 * @param {GeolocationPositionOptions=} opt_options
 * @return {number}
 */
Geolocation.prototype.watchPosition = function(successCallback,
                                                  opt_errorCallback,
                                                  opt_options) {};

/**
 * @param {number} watchId
 * @return {undefined}
 */
Geolocation.prototype.clearWatch = function(watchId) {};


/**
 * @record
 * @see http://www.w3.org/TR/geolocation-API/#coordinates
 */
function GeolocationCoordinates() {}
/** @type {number} */
GeolocationCoordinates.prototype.latitude;
/** @type {number} */
GeolocationCoordinates.prototype.longitude;
/** @type {number} */
GeolocationCoordinates.prototype.accuracy;
/** @type {number|null} */
GeolocationCoordinates.prototype.altitude;
/** @type {number|null} */
GeolocationCoordinates.prototype.altitudeAccuracy;
/** @type {number|null} */
GeolocationCoordinates.prototype.heading;
/** @type {number|null} */
GeolocationCoordinates.prototype.speed;


/**
 * @record
 * @see http://www.w3.org/TR/geolocation-API/#position
 */
function GeolocationPosition() {}
/** @type {GeolocationCoordinates} */
GeolocationPosition.prototype.coords;
/** @type {number} */
GeolocationPosition.prototype.timestamp;


/**
 * @record
 * @see http://www.w3.org/TR/geolocation-API/#position-options
 */
function GeolocationPositionOptions() {}
/** @type {boolean|undefined} */
GeolocationPositionOptions.prototype.enableHighAccuracy;
/** @type {number|undefined} */
GeolocationPositionOptions.prototype.maximumAge;
/** @type {number|undefined} */
GeolocationPositionOptions.prototype.timeout;


/**
 * @record
 * @see http://www.w3.org/TR/geolocation-API/#position-error
 */
function GeolocationPositionError() {}
/** @type {number} */
GeolocationPositionError.prototype.code;
/** @type {string} */
GeolocationPositionError.prototype.message;
/** @const {number} */
GeolocationPositionError.prototype.UNKNOWN_ERROR;
/** @const {number} */
GeolocationPositionError.prototype.PERMISSION_DENIED;
/** @const {number} */
GeolocationPositionError.prototype.POSITION_UNAVAILABLE;
/** @const {number} */
GeolocationPositionError.prototype.TIMEOUT;

/** @type {Geolocation} */
Navigator.prototype.geolocation;
