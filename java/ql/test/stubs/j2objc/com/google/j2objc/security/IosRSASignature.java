/*
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

/*
 * MODIFIED version of the file available at
 *   https://github.com/google/j2objc/blob/24fc3bb5d007ec318cbbdd25229499f520cef177/jre_emul/Classes/com/google/j2objc/security/IosRSASignature.java
 * For test purposes, some code in this file has been stubbed
 * to avoid dependencies on other source files.
 */

package com.google.j2objc.security;

import java.io.IOException;
import java.io.OutputStream;
import java.security.InvalidKeyException;
import java.security.InvalidParameterException;
import java.security.Key;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.SignatureException;
import java.security.SignatureSpi;
import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;

/*-[
#include "NSDataOutputStream.h"
#include <CommonCrypto/CommonDigest.h>
#include <Security/Security.h>

// Public iOS API (Security/SecKey.h). These functions are private in OS X due
// to issues with ECC certificates, but are still useful for jre_emul unit tests.
OSStatus SecKeyRawSign(
    SecKeyRef           key,
    SecPadding          padding,
    const uint8_t       *dataToSign,
    size_t              dataToSignLen,
    uint8_t             *sig,
    size_t              *sigLen);
OSStatus SecKeyRawVerify(
    SecKeyRef           key,
    SecPadding          padding,
    const uint8_t       *signedData,
    size_t              signedDataLen,
    const uint8_t       *sig,
    size_t              sigLen);
]-*/

/**
 * Signature verification provider, implemented using the iOS Security Framework.
 *
 * @author Tom Ball
 */
public abstract class IosRSASignature extends SignatureSpi {

  protected OutputStream buffer = newNSDataOutputStream();
  private Key key;

  @Override
  protected void engineInitVerify(PublicKey publicKey)
      throws InvalidKeyException {
    key = publicKey;
  }

  private static native OutputStream newNSDataOutputStream() /*-[
    return [NSDataOutputStream stream];
  ]-*/;

  @Override
  protected void engineInitSign(PrivateKey privateKey)
      throws InvalidKeyException {
    key = privateKey;
  }

  @Override
  protected void engineUpdate(byte b) throws SignatureException {
    try {
      buffer.write(b);
    } catch (IOException e) {
      throw new SignatureException(e);
    }
  }

  @Override
  protected void engineUpdate(byte[] b, int off, int len)
      throws SignatureException {
    try {
      buffer.write(b, off, len);
    } catch (IOException e) {
      throw new SignatureException(e);
    }
  }

  @Override
  protected byte[] engineSign() throws SignatureException {
    if (key == null || !(key instanceof RSAPrivateKey)) {
      throw new SignatureException("Needs RSA private key");
    }
    long privateKey = -1;
    return nativeEngineSign(privateKey);
  }

  protected abstract byte[] nativeEngineSign(long nativeKey);
  protected abstract boolean nativeEngineVerify(long nativeKey, byte[] sigBytes);

  @Override
  protected boolean engineVerify(byte[] sigBytes) throws SignatureException {
    if (key == null || !(key instanceof RSAPublicKey)) {
      throw new SignatureException("Needs RSA public key");
    }
    long publicKey = -1;
    return nativeEngineVerify(publicKey, sigBytes);
  }

  @Override
  protected Object engineGetParameter(String param) throws InvalidParameterException {
    return null;
  }

  @Override
  protected void engineSetParameter(String param, Object value) throws InvalidParameterException {
  }

  /*-[
  - (IOSByteArray *)nativeEngineSign:(SecKeyRef)privateKey
                           hashBytes:(uint8_t *)hashBytes
                                size:(size_t)hashBytesSize {
    size_t signedHashBytesSize = SecKeyGetBlockSize(privateKey);
    uint8_t *signedHashBytes = calloc(signedHashBytesSize, sizeof(uint8_t));
    SecKeyRawSign(privateKey,
                  kSecPaddingNone,
                  hashBytes,
                  hashBytesSize,
                  signedHashBytes,
                  &signedHashBytesSize);
    IOSByteArray *result = [IOSByteArray arrayWithBytes:(jbyte *)signedHashBytes
                                                  count:(NSUInteger)signedHashBytesSize];
    if (signedHashBytes) {
      free(signedHashBytes);
    }
    return result;
  }

  - (jboolean)nativeEngineVerify:(SecKeyRef)publicKey
                       signature:(IOSByteArray *)signature
                       hashBytes:(uint8_t *)hashBytes
                            size:(size_t)hashBytesSize {
    size_t signatureSize = SecKeyGetBlockSize(publicKey);
    if (signatureSize != (size_t)signature->size_) {
      return false;
    }
    OSStatus status = SecKeyRawVerify(publicKey,
                                      kSecPaddingNone,
                                      hashBytes,
                                      hashBytesSize,
                                      (uint8_t*)signature->buffer_,
                                      signatureSize);
    return status == errSecSuccess;
  }
  ]-*/

  public static final class MD5RSA extends IosRSASignature {
    @Override
    protected native byte[] nativeEngineSign(long nativeKey) /*-[
      NSData *plainData = [(NSDataOutputStream *)buffer_ data];
      size_t hashBytesSize = CC_MD5_DIGEST_LENGTH;
      uint8_t* hashBytes = malloc(hashBytesSize);
      if (!CC_MD5([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
        return nil;
      }
      IOSByteArray *result = [self nativeEngineSign:(SecKeyRef)nativeKey
                                          hashBytes:hashBytes
                                               size:hashBytesSize];
      free(hashBytes);
      return result;
    ]-*/;

    @Override
    protected native boolean nativeEngineVerify(long nativeKey, byte[] sigBytes) /*-[
      NSData *plainData = [(NSDataOutputStream *)buffer_ data];
      size_t hashBytesSize = CC_MD5_DIGEST_LENGTH;
      uint8_t* hashBytes = malloc(hashBytesSize);
      if (!CC_MD5([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
        return false;
      }
      BOOL result = [self nativeEngineVerify:(SecKeyRef)nativeKey
                                   signature:sigBytes
                                   hashBytes:hashBytes
                                        size:hashBytesSize];
      free(hashBytes);
      return result;
    ]-*/;
  }

  public static final class SHA1RSA extends IosRSASignature {
    @Override
    protected native byte[] nativeEngineSign(long nativeKey) /*-[
      NSData *plainData = [(NSDataOutputStream *)buffer_ data];
      size_t hashBytesSize = CC_SHA1_DIGEST_LENGTH;
      uint8_t* hashBytes = malloc(hashBytesSize);
      if (!CC_SHA1([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
        return nil;
      }
      IOSByteArray *result = [self nativeEngineSign:(SecKeyRef)nativeKey
                                          hashBytes:hashBytes
                                               size:hashBytesSize];
      free(hashBytes);
      return result;
    ]-*/;

    @Override
    protected native boolean nativeEngineVerify(long nativeKey, byte[] sigBytes) /*-[
      NSData *plainData = [(NSDataOutputStream *)buffer_ data];
      size_t hashBytesSize = CC_SHA1_DIGEST_LENGTH;
      uint8_t* hashBytes = malloc(hashBytesSize);
      if (!CC_SHA1([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
        return false;
      }
      BOOL result = [self nativeEngineVerify:(SecKeyRef)nativeKey
                                   signature:sigBytes
                                   hashBytes:hashBytes
                                        size:hashBytesSize];
      free(hashBytes);
      return result;
    ]-*/;
  }

  public static final class SHA256RSA extends IosRSASignature {
    @Override
    protected native byte[] nativeEngineSign(long nativeKey) /*-[
      NSData *plainData = [(NSDataOutputStream *)buffer_ data];
      size_t hashBytesSize = CC_SHA256_DIGEST_LENGTH;
      uint8_t* hashBytes = malloc(hashBytesSize);
      if (!CC_SHA256([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
        return nil;
      }
      IOSByteArray *result = [self nativeEngineSign:(SecKeyRef)nativeKey
                                          hashBytes:hashBytes
                                               size:hashBytesSize];
      free(hashBytes);
      return result;
    ]-*/;

    @Override
    protected native boolean nativeEngineVerify(long nativeKey, byte[] sigBytes) /*-[
      NSData *plainData = [(NSDataOutputStream *)buffer_ data];
      size_t hashBytesSize = CC_SHA256_DIGEST_LENGTH;
      uint8_t* hashBytes = malloc(hashBytesSize);
      if (!CC_SHA256([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
        return false;
      }
      BOOL result = [self nativeEngineVerify:(SecKeyRef)nativeKey
                                   signature:sigBytes
                                   hashBytes:hashBytes
                                        size:hashBytesSize];
      free(hashBytes);
      return result;
    ]-*/;
  }

  public static final class SHA384RSA extends IosRSASignature {
    @Override
    protected native byte[] nativeEngineSign(long nativeKey) /*-[
      NSData *plainData = [(NSDataOutputStream *)buffer_ data];
      size_t hashBytesSize = CC_SHA384_DIGEST_LENGTH;
      uint8_t* hashBytes = malloc(hashBytesSize);
      if (!CC_SHA384([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
        return nil;
      }
      IOSByteArray *result = [self nativeEngineSign:(SecKeyRef)nativeKey
                                          hashBytes:hashBytes
                                               size:hashBytesSize];
      free(hashBytes);
      return result;
    ]-*/;

    @Override
    protected native boolean nativeEngineVerify(long nativeKey, byte[] sigBytes) /*-[
      NSData *plainData = [(NSDataOutputStream *)buffer_ data];
      size_t hashBytesSize = CC_SHA384_DIGEST_LENGTH;
      uint8_t* hashBytes = malloc(hashBytesSize);
      if (!CC_SHA384([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
        return false;
      }
      BOOL result = [self nativeEngineVerify:(SecKeyRef)nativeKey
                                   signature:sigBytes
                                   hashBytes:hashBytes
                                        size:hashBytesSize];
      free(hashBytes);
      return result;
    ]-*/;
  }

  public static final class SHA512RSA extends IosRSASignature {
    @Override
    protected native byte[] nativeEngineSign(long nativeKey) /*-[
      NSData *plainData = [(NSDataOutputStream *)buffer_ data];
      size_t hashBytesSize = CC_SHA512_DIGEST_LENGTH;
      uint8_t* hashBytes = malloc(hashBytesSize);
      if (!CC_SHA512([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
        return nil;
      }
      IOSByteArray *result = [self nativeEngineSign:(SecKeyRef)nativeKey
                                          hashBytes:hashBytes
                                               size:hashBytesSize];
      free(hashBytes);
      return result;
    ]-*/;

    @Override
    protected native boolean nativeEngineVerify(long nativeKey, byte[] sigBytes) /*-[
      NSData *plainData = [(NSDataOutputStream *)buffer_ data];
      size_t hashBytesSize = CC_SHA512_DIGEST_LENGTH;
      uint8_t* hashBytes = malloc(hashBytesSize);
      if (!CC_SHA512([plainData bytes], (CC_LONG)[plainData length], hashBytes)) {
        return false;
      }
      jboolean result = [self nativeEngineVerify:(SecKeyRef)nativeKey
                                       signature:sigBytes
                                       hashBytes:hashBytes
                                            size:hashBytesSize];
      free(hashBytes);
      return result;
    ]-*/;
  }
}
