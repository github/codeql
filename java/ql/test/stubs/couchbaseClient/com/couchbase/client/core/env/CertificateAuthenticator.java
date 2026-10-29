/*
 * Copyright (c) 2019 Couchbase, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.couchbase.client.core.env;

import java.nio.file.Path;
import java.security.KeyStore;
import java.security.PrivateKey;
import java.security.cert.X509Certificate;
import java.util.List;
import java.util.Optional;

public class CertificateAuthenticator implements Authenticator {

  public static CertificateAuthenticator fromKeyStore(
      final Path keyStorePath, final String keyStorePassword, final Optional<String> keyStoreType) {
    return null;
  }

  public static CertificateAuthenticator fromKeyStore(
      final KeyStore keyStore, final String keyStorePassword) {
    return null;
  }

  public static CertificateAuthenticator fromKey(
      final PrivateKey key, final String keyPassword, final List<X509Certificate> keyCertChain) {
    return null;
  }
}