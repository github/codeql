/*
 * Copyright (C) 2014 jsonwebtoken.io
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
package io.jsonwebtoken.impl;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Header;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.JwsHeader;
import io.jsonwebtoken.Jwt;
import io.jsonwebtoken.JwtHandler;
import io.jsonwebtoken.JwtParser;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.SignatureException;
import io.jsonwebtoken.SigningKeyResolver;

import java.security.Key;

@SuppressWarnings("unchecked")
public class DefaultJwtParser implements JwtParser {
    @Deprecated
    public DefaultJwtParser() {
    }

    @Override
    public JwtParser setSigningKey(byte[] key) {
        return null;
    }

    @Override
    public JwtParser setSigningKey(String base64EncodedSecretKey) {
        return null;
    }

    @Override
    public JwtParser setSigningKey(Key key) {
        return null;
    }

    @Override
    public JwtParser setSigningKeyResolver(SigningKeyResolver signingKeyResolver) {
        return null;
    }

    @Override
    public Jwt parse(String jwt) throws ExpiredJwtException, MalformedJwtException, SignatureException {
        return null;
    }

    @Override
    public <T> T parse(String compact, JwtHandler<T> handler)
            throws ExpiredJwtException, MalformedJwtException, SignatureException {
        return null;
    }

    @Override
    public Jwt<Header, String> parsePlaintextJwt(String plaintextJwt) {
        return null;
    }

    @Override
    public Jwt<Header, Claims> parseClaimsJwt(String claimsJwt) {
        return null;
    }

    @Override
    public Jws<String> parsePlaintextJws(String plaintextJws) {
        return null;
    }

    @Override
    public Jws<Claims> parseClaimsJws(String claimsJws) {
        return null;
    }
}
