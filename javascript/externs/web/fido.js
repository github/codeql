/*
 * Copyright 2018 The Closure Compiler Authors.
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
 * @fileoverview Definitions from the FIDO Specifications
 * @see https://fidoalliance.org/download/
 *
 * @externs
 * @author arnarbi@gmail.com (Arnar Birgisson)
 */

/**
 * U2F JavaScript API namespace
 * @see https://fidoalliance.org/specs/fido-u2f-v1.2-ps-20170411/fido-u2f-javascript-api-v1.2-ps-20170411.html
 * @const
 */
var u2f = {};

/**
 * Data object for a single sign request.
 * @typedef {string}
 */
u2f.Transport;

/**
 * Data object for a registered key.
 * @typedef {{
 *   version: string,
 *   keyHandle: string,
 *   transports: (!Array<!u2f.Transport>|undefined),
 *   appId: ?string
 * }}
 */
u2f.RegisteredKey;

/**
 * An error object for responses
 * @typedef {{
 *   errorCode: number,
 *   errorMessage: ?string
 * }}
 */
u2f.Error;

/**
 * Data object for a sign response.
 * @typedef {{
 *   keyHandle: string,
 *   signatureData: string,
 *   clientData: string
 * }}
 */
u2f.SignResponse;

/**
 * @typedef {{
 *   version: string,
 *   challenge: string
 * }}
 */
u2f.RegisterRequest

/**
 * @param {string} appId
 * @param {string} challenge
 * @param {!Array<!u2f.RegisteredKey>} registeredKeys
 * @param {function((!u2f.Error|!u2f.SignResponse))} callback
 * @param {number=} opt_timeoutSeconds
 */
u2f.sign = function(
    appId, challenge, registeredKeys, callback, opt_timeoutSeconds) {};

/**
 * @param {string} appId
 * @param {!Array<!u2f.RegisterRequest>} registerRequests
 * @param {!Array<!u2f.RegisteredKey>} registeredKeys
 * @param {function((!u2f.Error|!u2f.SignResponse))} callback
 * @param {number=} opt_timeoutSeconds
 */
u2f.register = function(
    appId, registerRequests, registeredKeys, callback, opt_timeoutSeconds) {};
