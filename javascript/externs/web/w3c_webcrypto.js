/*
 * Copyright 2015 The Closure Compiler Authors
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
 * @fileoverview Definitions for W3C's Web Cryptography specification
 * http://www.w3.org/TR/webCryptoAPI
 * @externs
 * @author chrismoon@google.com (Chris Moon)
 * This file was created using the best practices as described in:
 *     chrome_extensions.js
 */


/**
 * @const
 * @see http://www.w3.org/TR/webCryptoAPI
 */
var webCrypto = {};


/**
 * @typedef {?{
 *   name: string
 * }}
 * @see http://www.w3.org/TR/WebCryptoAPI/#algorithm-dictionary
 */
webCrypto.Algorithm;


/**
 * @typedef {string|!webCrypto.Algorithm}
 * @see http://www.w3.org/TR/WebCryptoAPI/#dfn-AlgorithmIdentifier
 */
webCrypto.AlgorithmIdentifier;


/**
 * @constructor
 * @see http://www.w3.org/TR/webCryptoAPI/#dfn-CryptoKey
 */
webCrypto.CryptoKey = function() {};


/**
 * @type {string} An enumerated value representing the type of the key, a secret
 *    key (for symmetric algorithm), a public or a private key
 *    (for an asymmetric algorithm).
 */
webCrypto.CryptoKey.prototype.type;


/**
 * @type {boolean} Determines whether or not the raw keying material may be
 *     exported by the application.
 */
webCrypto.CryptoKey.prototype.extractable;


/**
 * @type {!Object} An opaque object representing a particular cipher the key
 *     has to be used with.
 */
webCrypto.CryptoKey.prototype.algorithm;


/**
 * @type {!Object} Returns the cached ECMAScript object associated with the
 *   usages internal slot, which indicates which cryptographic operations are
 *   permissible to be used with this key.
 */
webCrypto.CryptoKey.prototype.usages;


/**
 * @typedef {?{
 *   name: string
 * }}
 * @see http://www.w3.org/TR/WebCryptoAPI/#key-algorithm-dictionary-members
 */
webCrypto.KeyAlgorithm;


/**
 * @constructor
 * @see http://www.w3.org/TR/WebCryptoAPI/#dfn-JsonWebKey
 * @see Section 3.1:
 *     https://tools.ietf.org/html/draft-ietf-jose-json-web-key-41
 */
webCrypto.JsonWebKey = function() {};


/**
 * @type {string} Identifies the cryptographic algorithm family used with
 *     the key, such as "RSA" or "EC".
 */
webCrypto.JsonWebKey.prototype.kty;


/**
 * @type {string} Identifies the intended use of the public key.
 */
webCrypto.JsonWebKey.prototype.use;


/**
 * @type {!Array<string>} Identifies the operation(s) that the key is
 *     intended to be used for.
 */
webCrypto.JsonWebKey.prototype.key_ops;


/**
 * @type {string} Identifies the algorithm intended for use with the key.
 */
webCrypto.JsonWebKey.prototype.alg;


/**
 * @type {boolean} Boolean to be used with kty values.
 */
webCrypto.JsonWebKey.prototype.ext;


/**
 * @type {string} Identifies the cryptographic curve used with the key.
 */
webCrypto.JsonWebKey.prototype.crv;


/**
 * @type {string} Contains the x coordinate for the elliptic curve point.
 */
webCrypto.JsonWebKey.prototype.x;


/**
 * @type {string} Contains the y coordinate for the elliptic curve point.
 */
webCrypto.JsonWebKey.prototype.y;


/**
 * @type {string} Contains the Elliptic Curve private key value.
 */
webCrypto.JsonWebKey.prototype.d;


/**
 * @type {string} Contains the modulus value for the RSA public key.
 */
webCrypto.JsonWebKey.prototype.n;


/**
 * @type {string} Contains the exponent value for the RSA public key.
 */
webCrypto.JsonWebKey.prototype.e;


/**
 * @type {string} Contains the first prime factor.
 */
webCrypto.JsonWebKey.prototype.p;


/**
 * @type {string} Contains the second prime factor.
 */
webCrypto.JsonWebKey.prototype.q;


/**
 * @type {string} Contains the Chinese Remainder Theorem (CRT) exponent of
 *     the first factor.
 */
webCrypto.JsonWebKey.prototype.dp;


/**
 * @type {string} Contains the Chinese Remainder Theorem (CRT) exponent of
 *     the second factor.
 */
webCrypto.JsonWebKey.prototype.dq;


/**
 * @type {string} Contains the Chinese Remainder Theorem (CRT) coefficient
 *     of the second factor.
 */
webCrypto.JsonWebKey.prototype.qi;


/**
 * @type {!Array<!webCrypto.RsaOtherPrimesInfo>} Contains an array of
 *     information about any third and subsequent primes, should they exist.
 */
webCrypto.JsonWebKey.prototype.oth;


/**
 * @type {string} Contains the value of the symmetric (or other
 *     single-valued) key.
 */
webCrypto.JsonWebKey.prototype.k;


/**
 * @constructor
 * @see http://www.w3.org/TR/WebCryptoAPI/#dfn-RsaOtherPrimesInfo
 * @see Section-6.3.2.7:
 *     https://tools.ietf.org/html/draft-ietf-jose-json-web-algorithms-40
 */
webCrypto.RsaOtherPrimesInfo = function() {};


/**
 * @type {string} Parameter within an "oth" array member represents the value
 *     of a subsequent prime factor.
 */
webCrypto.RsaOtherPrimesInfo.prototype.r;


/**
 * @type {string} Parameter within an "oth" array member represents the CRT
 *     exponent of the corresponding prime factor.
 */
webCrypto.RsaOtherPrimesInfo.prototype.d;


/**
 * @type {string} Parameter within an "oth" array member represents the CRT
 *     coefficient of the corresponding prime factor.
 */
webCrypto.RsaOtherPrimesInfo.prototype.t;


/**
 * @constructor
 * @see http://www.w3.org/TR/WebCryptoAPI/#subtlecrypto-interface
 */
webCrypto.SubtleCrypto = function() {};


/**
 * @param {!webCrypto.AlgorithmIdentifier} algorithm Supported
 *     values are: AES-CBC, AES-CTR, AES-GCM, and RSA-OAEP.
 * @param {!webCrypto.CryptoKey} key Key to be used for signing.
 * @param {!BufferSource} data Data to be encrypted (cleartext).
 * @return {!Promise<*>} Ciphertext generated by the encryption of the
 *     cleartext.
 */
webCrypto.SubtleCrypto.prototype.encrypt = function(algorithm, key,
    data) {};


/**
 * @param {!webCrypto.AlgorithmIdentifier} algorithm Supported
 *     values are: AES-CBC, AES-CTR, AES-GCM, and RSA-OAEP.
 * @param {!webCrypto.CryptoKey} key Key to be used for signing.
 * @param {!BufferSource} data Data to be decrypted (ciphertext).
 * @return {!Promise<*>} Cleartext generated by the decryption of the
 *     ciphertext.
 */
webCrypto.SubtleCrypto.prototype.decrypt = function(algorithm, key,
    data) {};


/**
 * @param {!webCrypto.AlgorithmIdentifier} algorithm Supported
 *     values are: HMAC, RSASSA-PKCS1-v1_5, and ECDSA.
 * @param {!webCrypto.CryptoKey} key Private key to be used for signing.
 * @param {!BufferSource} data Data to be signed.
 * @return {!Promise<*>} Returns the signature on success.
 */
webCrypto.SubtleCrypto.prototype.sign = function(algorithm, key,
    data) {};


/**
 * @param {!webCrypto.AlgorithmIdentifier} algorithm Supported
 *     values are: HMAC, RSASSA-PKCS1-v1_5, and ECDSA.
 * @param {!webCrypto.CryptoKey} key Private key to be used for signing.
 * @param {!BufferSource} signature Signature to verify.
 * @param {!BufferSource} data Data whose signature needs to be verified.
 * @return {!Promise<*>} Returns a boolean indicating if the signature operating
 *     has been successful.
 */
webCrypto.SubtleCrypto.prototype.verify = function(algorithm, key,
    signature, data) {};


/**
 * @param {!webCrypto.AlgorithmIdentifier} algorithm Supported
 *     values are: SHA-1, SHA-256, SHA-384, and SHA-512.
 * @param {!BufferSource} data Data to be hashed using the hashing algorithm.
 * @return {!Promise<*>} returns the hash on success.
 */
webCrypto.SubtleCrypto.prototype.digest = function(algorithm, data) {};


/**
 * @param {!webCrypto.AlgorithmIdentifier} algorithm Supported
 *     values are: SHA-1, SHA-256, SHA-384, and SHA-512.
 * @param {boolean} extractable If the key can be extracted from the CryptoKey
 *     object at a later stage.
 * @param {!Array<string>} keyUsages Indication of new key options i.e.
 *     encrypt, decrypt, sign, verify, deriveKey, deriveBits, wrapKey,
 *     unwrapKey.
 * @return {!Promise<*>} returns the generated key as a CryptoKey or a
 *     CryptoKeyPair.
 */
webCrypto.SubtleCrypto.prototype.generateKey = function(algorithm,
    extractable, keyUsages) {};


/**
 * @param {!webCrypto.AlgorithmIdentifier} algorithm The key derivation
 *     algorithm to use. Supported values are:  ECDH, DH, PBKDF2, and HKDF-CTR.
 * @param {!webCrypto.CryptoKey} baseKey Key to be used by the key
 *     derivation algorithm.
 * @param {!webCrypto.AlgorithmIdentifier} derivedKeyAlgo Defines the key
 *     derivation algorithm to use.
 * @param {boolean} extractable Indicates if the key can be extracted from the
 *     CryptoKey object at a later stage.
 * @param {!Array<string>} keyUsages Indicates what can be done with the
 *     derivated key.
 * @return {!Promise<*>} returns the generated key as a CryptoKey or a
 *     CryptoKeyPair.
 */
webCrypto.SubtleCrypto.prototype.deriveKey = function(algorithm,
   baseKey, derivedKeyAlgo, extractable, keyUsages) {};


/**
 * @param {!webCrypto.AlgorithmIdentifier} algorithm The key derivation
 *     algorithm to use.
 * @param {!webCrypto.CryptoKey} baseKey Key to be used by the key
 *     derivation algorithm.
 * @param {number} length
 * @return {!Promise<*>} returns the generated key as a CryptoKey or a
 *     CryptoKeyPair.
 */
webCrypto.SubtleCrypto.prototype.deriveBits = function(algorithm,
   baseKey, length) {};


/**
 * @param {string} format Enumerated value describing the data
 *     format of the key to imported.
 * @param {!BufferSource|!webCrypto.JsonWebKey} keyData The key
 *     in the given format.
 * @param {!webCrypto.AlgorithmIdentifier} algorithm Supported values
 *     are: AES-CTR, AES-CBC, AES-GCM, RSA-OAEP, AES-KW, HMAC,
 *     RSASSA-PKCS1-v1_5, ECDSA, ECDH, DH.
 * @param {boolean} extractable If the key can be extracted from the CryptoKey
 *     object at a later stage.
 * @param {!Array<string>} keyUsages Indication of new key options i.e.
 *     encrypt, decrypt, sign, verify, deriveKey, deriveBits, wrapKey,
 *     unwrapKey.
 * @return {!Promise<*>} returns the generated key as a CryptoKey.
 */
webCrypto.SubtleCrypto.prototype.importKey = function(format, keyData,
    algorithm, extractable, keyUsages) {};


/**
 * @param {string} format Enumerated value describing the data
 *     format of the key to imported.
 * @param {!webCrypto.CryptoKey} key CryptoKey to export.
 * @return {!Promise<*>} returns the key in the requested format.
 */
webCrypto.SubtleCrypto.prototype.exportKey = function(format, key) {};


/**
 * @param {string} format Value describing the data format in which the key must
 *     be wrapped. It can be one of the following: raw, pkcs8, spki, jwk.
 * @param {!webCrypto.CryptoKey} key CryptoKey to wrap.
 * @param {!webCrypto.CryptoKey} wrappingKey CryptoKey used to perform
 *     the wrapping.
 * @param {!webCrypto.AlgorithmIdentifier} wrapAlgorithm algorithm used
 *     to perform the wrapping. It is one of the following: AES-CBC, AES-CTR,
 *     AES-GCM, RSA-OAEP, and AES-KW.
 * @return {!Promise<*>} returns the wrapped key in the requested format.
 */
webCrypto.SubtleCrypto.prototype.wrapKey = function(format,
   key, wrappingKey, wrapAlgorithm) {};


/**
 * @param {string} format Value describing the data format in which the key must
 *     be wrapped. It can be one of the following: raw, pkcs8, spki, jwk.
 * @param {!BufferSource} wrappedKey Contains the wrapped key in the given
 *     format.
 * @param {!webCrypto.CryptoKey} unwrappingKey CryptoKey used to perform
 *     the unwrapping.
 * @param {!webCrypto.AlgorithmIdentifier} unwrapAlgorithm Algorithm
 *    used to perform the unwrapping. It is one of the following: AES-CBC,
 *    AES-CTR, AES-GCM, RSA-OAEP, and AES-KW.
 * @param {!webCrypto.AlgorithmIdentifier} unwrappedKeyAlgorithm
 *     Represents the algorithm of the wrapped key.
 * @param {boolean} extractable Indicates if the key can be extracted from the
 *     CryptoKey object at a later stage.
 * @param {!Array<string>} keyUsages Indicates what can be done with the
 *     derivated key.
 * @return {!Promise<*>} returns the unwrapped key as a CryptoKey.
 */
webCrypto.SubtleCrypto.prototype.unwrapKey = function(format, wrappedKey,
    unwrappingKey, unwrapAlgorithm, unwrappedKeyAlgorithm, extractable,
    keyUsages) {};


/**
 * Web Cryptography API
 * @see http://www.w3.org/TR/WebCryptoAPI/
 */

/** @see https://developer.mozilla.org/en/DOM/window.crypto */
Window.prototype.crypto;


/**
 * @see https://developer.mozilla.org/en/DOM/window.crypto.getRandomValues
 * @param {!ArrayBufferView} typedArray
 * @return {!ArrayBufferView}
 * @throws {Error}
 */
Window.prototype.crypto.getRandomValues = function(typedArray) {};


/**
 * @type {webCrypto.SubtleCrypto}
 * @see http://www.w3.org/TR/WebCryptoAPI/#Crypto-attribute-subtle
 */
Window.prototype.crypto.subtle;
