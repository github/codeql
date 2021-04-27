/*
 * Copyright 2008 The Closure Compiler Authors
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
 * @fileoverview The spec of Trust Token interface.
 * @see https://github.com/WICG/trust-token-api
 * @externs
 */

/**
 * Trust Tokens operation (issuance, signing, and redemption) is specified via
 * an instance of the following parameters struct, provided via Fetch, XHR, or
 * the iframe tag
 * TODO(b/161890603): Trust Token: Remove the 'issuer' fields after Chrome 86
 * hits stable.
 * @record
 * @see https://docs.google.com/document/d/1qUjtKgA7nMv9YGMhi0xWKEojkSITKzGLdIcZgoz6ZkI
 */

function TrustTokenAttributeType() {}

/**
 * Possible values: 'token-request', 'send-srr', 'srr-token-redemption'
 * @type {string}
 */
TrustTokenAttributeType.prototype.type;

/** @type {string|undefined} */
TrustTokenAttributeType.prototype.issuer;

/** @type {!Array<string>|undefined} */
TrustTokenAttributeType.prototype.issuers;

/**
 * Possible values: 'none', 'refresh'
 * @type {string|undefined}
 */
TrustTokenAttributeType.prototype.refreshPolicy;

/**
 * Possible values: 'omit', 'include', 'headers-only'
 * @type {string|undefined}
 */
TrustTokenAttributeType.prototype.signRequestData;

/** @type {boolean|undefined} */
TrustTokenAttributeType.prototype.includeTimestampHeader;

/** @type {!Array<string>|undefined} */
TrustTokenAttributeType.prototype.additionalSignedHeaders;

/** @type {string|undefined} */
TrustTokenAttributeType.prototype.additionalSigningData;

/**
 * @type {?function(!TrustTokenAttributeType): void}
 * @see https://docs.google.com/document/d/1qUjtKgA7nMv9YGMhi0xWKEojkSITKzGLdIcZgoz6ZkI.
 */
XMLHttpRequest.prototype.setTrustToken;

/**
 * @param {!string} issuer The trust token issuer, e.g.
 *     https://adservice.google.com
 * @return {!Promise<boolean>}
 * @see https://docs.google.com/document/d/1TNnya6B8pyomDK2F1R9CL3dY10OAmqWlnCxsWyOBDVQ/edit
 */
Document.prototype.hasTrustToken = function(issuer) {};

/** @type {undefined|!TrustTokenAttributeType} */
RequestInit.prototype.trustToken;

/**
 * @type {undefined|!TrustTokenAttributeType}
 * @see https://github.com/WICG/trust-token-api#extension-iframe-activation
 */
HTMLIFrameElement.prototype.trustToken;
