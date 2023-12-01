package com.auth0.jwt;

import com.auth0.jwt.exceptions.JWTDecodeException;
import com.auth0.jwt.impl.JWTParser;
import com.auth0.jwt.interfaces.Claim;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.auth0.jwt.interfaces.Header;
import com.auth0.jwt.interfaces.Payload;

import java.io.Serializable;
import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Base64;
import java.util.Date;
import java.util.List;
import java.util.Map;

/**
 * The JWTDecoder class holds the decode method to parse a given JWT token into it's JWT representation.
 * <p>
 * This class is thread-safe.
 */
@SuppressWarnings("WeakerAccess")
final class JWTDecoder implements DecodedJWT, Serializable {

    private static final long serialVersionUID = 1873362438023312895L;

    private final String[] parts;
    private final Header header;
    private final Payload payload;

    JWTDecoder(String jwt) throws JWTDecodeException {
        this(new JWTParser(), jwt);
    }

    JWTDecoder(JWTParser converter, String jwt) throws JWTDecodeException {
        parts = TokenUtils.splitToken(jwt);
        String headerJson;
        String payloadJson;
        try {
            headerJson = new String(Base64.getUrlDecoder().decode(parts[0]), StandardCharsets.UTF_8);
            payloadJson = new String(Base64.getUrlDecoder().decode(parts[1]), StandardCharsets.UTF_8);
        } catch (NullPointerException e) {
            throw new JWTDecodeException("The UTF-8 Charset isn't initialized.", e);
        } catch (IllegalArgumentException e) {
            throw new JWTDecodeException("The input is not a valid base 64 encoded string.", e);
        }
        header = converter.parseHeader(headerJson);
        payload = converter.parsePayload(payloadJson);
    }

    @Override
    public String getAlgorithm() {
        return header.getAlgorithm();
    }

    @Override
    public String getType() {
        return header.getType();
    }

    @Override
    public String getContentType() {
        return header.getContentType();
    }

    @Override
    public String getKeyId() {
        return header.getKeyId();
    }

    @Override
    public Claim getHeaderClaim(String name) {
        return header.getHeaderClaim(name);
    }

    @Override
    public String getIssuer() {
        return payload.getIssuer();
    }

    @Override
    public String getSubject() {
        return payload.getSubject();
    }

    @Override
    public List<String> getAudience() {
        return payload.getAudience();
    }

    @Override
    public Date getExpiresAt() {
        return payload.getExpiresAt();
    }

    @Override
    public Instant getExpiresAtAsInstant() {
        return payload.getExpiresAtAsInstant();
    }

    @Override
    public Date getNotBefore() {
        return payload.getNotBefore();
    }

    @Override
    public Instant getNotBeforeAsInstant() {
        return  payload.getNotBeforeAsInstant();
    }

    @Override
    public Date getIssuedAt() {
        return payload.getIssuedAt();
    }

    @Override
    public Instant getIssuedAtAsInstant() {
        return payload.getIssuedAtAsInstant();
    }

    @Override
    public String getId() {
        return payload.getId();
    }

    @Override
    public Claim getClaim(String name) {
        return payload.getClaim(name);
    }

    @Override
    public Map<String, Claim> getClaims() {
        return payload.getClaims();
    }

    @Override
    public String getHeader() {
        return parts[0];
    }

    @Override
    public String getPayload() {
        return parts[1];
    }

    @Override
    public String getSignature() {
        return parts[2];
    }

    @Override
    public String getToken() {
        return String.format("%s.%s.%s", parts[0], parts[1], parts[2]);
    }
}
