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

import io.jsonwebtoken.ClaimJwtException;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Clock;
import io.jsonwebtoken.CompressionCodec;
import io.jsonwebtoken.CompressionCodecResolver;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Header;
import io.jsonwebtoken.IncorrectClaimException;
import io.jsonwebtoken.InvalidClaimException;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.JwsHeader;
import io.jsonwebtoken.Jwt;
import io.jsonwebtoken.JwtHandler;
import io.jsonwebtoken.JwtHandlerAdapter;
import io.jsonwebtoken.JwtParser;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.MissingClaimException;
import io.jsonwebtoken.PrematureJwtException;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.SigningKeyResolver;
import io.jsonwebtoken.impl.crypto.JwtSignatureValidator;
import io.jsonwebtoken.UnsupportedJwtException;
import io.jsonwebtoken.io.Decoder;
import io.jsonwebtoken.io.Decoders;
import io.jsonwebtoken.io.DeserializationException;
import io.jsonwebtoken.io.Deserializer;
import io.jsonwebtoken.lang.Assert;
import io.jsonwebtoken.lang.DateFormats;
import io.jsonwebtoken.lang.Objects;
import io.jsonwebtoken.lang.Strings;
import io.jsonwebtoken.security.InvalidKeyException;
import io.jsonwebtoken.security.SignatureException;
import io.jsonwebtoken.security.WeakKeyException;

import javax.crypto.spec.SecretKeySpec;
import java.security.Key;
import java.util.Date;
import java.util.Map;

@SuppressWarnings("unchecked")
public class DefaultJwtParser implements JwtParser {
    @Deprecated
    public DefaultJwtParser() {
    }

    DefaultJwtParser(SigningKeyResolver signingKeyResolver, Key key, byte[] keyBytes, Clock clock,
            long allowedClockSkewMillis, Claims expectedClaims, Decoder<String, byte[]> base64UrlDecoder,
            Deserializer<Map<String, ?>> deserializer, CompressionCodecResolver compressionCodecResolver) {
    }

    @Override
    public JwtParser deserializeJsonWith(Deserializer<Map<String, ?>> deserializer) {
        return null;
    }

    @Override
    public JwtParser base64UrlDecodeWith(Decoder<String, byte[]> base64UrlDecoder) {
        return null;
    }

    @Override
    public JwtParser requireIssuedAt(Date issuedAt) {
        return null;
    }

    @Override
    public JwtParser requireIssuer(String issuer) {
        return null;
    }

    @Override
    public JwtParser requireAudience(String audience) {
        return null;
    }

    @Override
    public JwtParser requireSubject(String subject) {
        return null;
    }

    @Override
    public JwtParser requireId(String id) {
        return null;
    }

    @Override
    public JwtParser requireExpiration(Date expiration) {
        return null;
    }

    @Override
    public JwtParser requireNotBefore(Date notBefore) {
        return null;
    }

    @Override
    public JwtParser require(String claimName, Object value) {
        return null;
    }

    @Override
    public JwtParser setClock(Clock clock) {
        return null;
    }

    @Override
    public JwtParser setAllowedClockSkewSeconds(long seconds) throws IllegalArgumentException {
        return null;
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
    public JwtParser setCompressionCodecResolver(CompressionCodecResolver compressionCodecResolver) {
        return null;
    }

    @Override
    public boolean isSigned(String jwt) {
        return false;
    }

    @Override
    public Jwt parse(String jwt) throws ExpiredJwtException, MalformedJwtException, SignatureException {
        return null;
    }

    /**
     * @since 0.10.0
     */
    private static Object normalize(Object o) {
        return null;
    }

    private void validateExpectedClaims(Header header, Claims claims) {
        return;
    }

    /*
     * @since 0.5 mostly to allow testing overrides
     */
    protected JwtSignatureValidator createSignatureValidator(SignatureAlgorithm alg, Key key) {
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

    @SuppressWarnings("unchecked")
    protected Map<String, ?> readValue(String val) {
        return null;
    }
}
