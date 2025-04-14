// Generated automatically from com.auth0.jwt.interfaces.KeyProvider for testing purposes

package com.auth0.jwt.interfaces;

import java.security.PrivateKey;
import java.security.PublicKey;

interface KeyProvider<U extends PublicKey, R extends PrivateKey>
{
    R getPrivateKey();
    String getPrivateKeyId();
    U getPublicKeyById(String p0);
}
