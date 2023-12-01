package com.auth0.jwt;

import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTCreationException;
import com.auth0.jwt.exceptions.SignatureGenerationException;
import com.auth0.jwt.impl.*;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.MapperFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.json.JsonMapper;
import com.fasterxml.jackson.databind.module.SimpleModule;

import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.*;
import java.util.Map.Entry;

/**
 * The JWTCreator class holds the sign method to generate a complete JWT (with Signature)
 * from a given Header and Payload content.
 * <p>
 * This class is thread-safe.
 */
@SuppressWarnings("WeakerAccess")
public final class JWTCreator {

    private final Algorithm algorithm;
    private final String headerJson;
    private final String payloadJson;

    private static final ObjectMapper mapper;
    private static final SimpleModule module;

    static {
        module = new SimpleModule();
        module.addSerializer(PayloadClaimsHolder.class, new PayloadSerializer());
        module.addSerializer(HeaderClaimsHolder.class, new HeaderSerializer());

        mapper = JsonMapper.builder()
                .configure(MapperFeature.SORT_PROPERTIES_ALPHABETICALLY, true)
                .build()
                .registerModule(module);
    }

    private JWTCreator(Algorithm algorithm, Map<String, Object> headerClaims, Map<String, Object> payloadClaims)
            throws JWTCreationException {
        this.algorithm = algorithm;
        try {
            headerJson = mapper.writeValueAsString(new HeaderClaimsHolder(headerClaims));
            payloadJson = mapper.writeValueAsString(new PayloadClaimsHolder(payloadClaims));
        } catch (JsonProcessingException e) {
            throw new JWTCreationException("Some of the Claims couldn't be converted to a valid JSON format.", e);
        }
    }


    /**
     * Initialize a JWTCreator instance.
     *
     * @return a JWTCreator.Builder instance to configure.
     */
    static JWTCreator.Builder init() {
        return new Builder();
    }

    /**
     * The Builder class holds the Claims that defines the JWT to be created.
     */
    public static class Builder {
        private final Map<String, Object> payloadClaims;
        private final Map<String, Object> headerClaims;

        Builder() {
            this.payloadClaims = new LinkedHashMap<>();
            this.headerClaims = new LinkedHashMap<>();
        }

        /**
         * Add specific Claims to set as the Header.
         * If provided map is null then nothing is changed
         *
         * @param headerClaims the values to use as Claims in the token's Header.
         * @return this same Builder instance.
         */
        public Builder withHeader(Map<String, Object> headerClaims) {
            if (headerClaims == null) {
                return this;
            }

            for (Map.Entry<String, Object> entry : headerClaims.entrySet()) {
                if (entry.getValue() == null) {
                    this.headerClaims.remove(entry.getKey());
                } else {
                    this.headerClaims.put(entry.getKey(), entry.getValue());
                }
            }

            return this;
        }

        /**
         * Add specific Claims to set as the Header.
         * If provided json is null then nothing is changed
         *
         * @param headerClaimsJson the values to use as Claims in the token's Header.
         * @return this same Builder instance.
         * @throws IllegalArgumentException if json value has invalid structure
         */
        public Builder withHeader(String headerClaimsJson) throws IllegalArgumentException {
            if (headerClaimsJson == null) {
                return this;
            }

            try {
                Map<String, Object> headerClaims = mapper.readValue(headerClaimsJson, LinkedHashMap.class);
                return withHeader(headerClaims);
            } catch (JsonProcessingException e) {
                throw new IllegalArgumentException("Invalid header JSON", e);
            }
        }

        /**
         * Add a specific Key Id ("kid") claim to the Header.
         * If the {@link Algorithm} used to sign this token was instantiated with a KeyProvider,
         * the 'kid' value will be taken from that provider and this one will be ignored.
         *
         * @param keyId the Key Id value.
         * @return this same Builder instance.
         */
        public Builder withKeyId(String keyId) {
            this.headerClaims.put(HeaderParams.KEY_ID, keyId);
            return this;
        }

        /**
         * Add a specific Issuer ("iss") claim to the Payload.
         *
         * @param issuer the Issuer value.
         * @return this same Builder instance.
         */
        public Builder withIssuer(String issuer) {
            addClaim(RegisteredClaims.ISSUER, issuer);
            return this;
        }

        /**
         * Add a specific Subject ("sub") claim to the Payload.
         *
         * @param subject the Subject value.
         * @return this same Builder instance.
         */
        public Builder withSubject(String subject) {
            addClaim(RegisteredClaims.SUBJECT, subject);
            return this;
        }

        /**
         * Add a specific Audience ("aud") claim to the Payload.
         *
         * @param audience the Audience value.
         * @return this same Builder instance.
         */
        public Builder withAudience(String... audience) {
            addClaim(RegisteredClaims.AUDIENCE, audience);
            return this;
        }

        /**
         * Add a specific Expires At ("exp") claim to the payload. The claim will be written as seconds since the epoch.
         * Milliseconds will be truncated by rounding down to the nearest second.
         *
         * @param expiresAt the Expires At value.
         * @return this same Builder instance.
         */
        public Builder withExpiresAt(Date expiresAt) {
            addClaim(RegisteredClaims.EXPIRES_AT, expiresAt);
            return this;
        }

        /**
         * Add a specific Expires At ("exp") claim to the payload. The claim will be written as seconds since the epoch;
         * Milliseconds will be truncated by rounding down to the nearest second.
         *
         * @param expiresAt the Expires At value.
         * @return this same Builder instance.
         */
        public Builder withExpiresAt(Instant expiresAt) {
            addClaim(RegisteredClaims.EXPIRES_AT, expiresAt);
            return this;
        }

        /**
         * Add a specific Not Before ("nbf") claim to the Payload. The claim will be written as seconds since the epoch;
         * Milliseconds will be truncated by rounding down to the nearest second.
         *
         * @param notBefore the Not Before value.
         * @return this same Builder instance.
         */
        public Builder withNotBefore(Date notBefore) {
            addClaim(RegisteredClaims.NOT_BEFORE, notBefore);
            return this;
        }

        /**
         * Add a specific Not Before ("nbf") claim to the Payload. The claim will be written as seconds since the epoch;
         * Milliseconds will be truncated by rounding down to the nearest second.
         *
         * @param notBefore the Not Before value.
         * @return this same Builder instance.
         */
        public Builder withNotBefore(Instant notBefore) {
            addClaim(RegisteredClaims.NOT_BEFORE, notBefore);
            return this;
        }

        /**
         * Add a specific Issued At ("iat") claim to the Payload. The claim will be written as seconds since the epoch;
         * Milliseconds will be truncated by rounding down to the nearest second.
         *
         * @param issuedAt the Issued At value.
         * @return this same Builder instance.
         */
        public Builder withIssuedAt(Date issuedAt) {
            addClaim(RegisteredClaims.ISSUED_AT, issuedAt);
            return this;
        }

        /**
         * Add a specific Issued At ("iat") claim to the Payload. The claim will be written as seconds since the epoch;
         * Milliseconds will be truncated by rounding down to the nearest second.
         *
         * @param issuedAt the Issued At value.
         * @return this same Builder instance.
         */
        public Builder withIssuedAt(Instant issuedAt) {
            addClaim(RegisteredClaims.ISSUED_AT, issuedAt);
            return this;
        }

        /**
         * Add a specific JWT Id ("jti") claim to the Payload.
         *
         * @param jwtId the Token Id value.
         * @return this same Builder instance.
         */
        public Builder withJWTId(String jwtId) {
            addClaim(RegisteredClaims.JWT_ID, jwtId);
            return this;
        }

        /**
         * Add a custom Claim value.
         *
         * @param name  the Claim's name.
         * @param value the Claim's value.
         * @return this same Builder instance.
         * @throws IllegalArgumentException if the name is null.
         */
        public Builder withClaim(String name, Boolean value) throws IllegalArgumentException {
            assertNonNull(name);
            addClaim(name, value);
            return this;
        }

        /**
         * Add a custom Claim value.
         *
         * @param name  the Claim's name.
         * @param value the Claim's value.
         * @return this same Builder instance.
         * @throws IllegalArgumentException if the name is null.
         */
        public Builder withClaim(String name, Integer value) throws IllegalArgumentException {
            assertNonNull(name);
            addClaim(name, value);
            return this;
        }

        /**
         * Add a custom Claim value.
         *
         * @param name  the Claim's name.
         * @param value the Claim's value.
         * @return this same Builder instance.
         * @throws IllegalArgumentException if the name is null.
         */
        public Builder withClaim(String name, Long value) throws IllegalArgumentException {
            assertNonNull(name);
            addClaim(name, value);
            return this;
        }

        /**
         * Add a custom Claim value.
         *
         * @param name  the Claim's name.
         * @param value the Claim's value.
         * @return this same Builder instance.
         * @throws IllegalArgumentException if the name is null.
         */
        public Builder withClaim(String name, Double value) throws IllegalArgumentException {
            assertNonNull(name);
            addClaim(name, value);
            return this;
        }

        /**
         * Add a custom Claim value.
         *
         * @param name  the Claim's name.
         * @param value the Claim's value.
         * @return this same Builder instance.
         * @throws IllegalArgumentException if the name is null.
         */
        public Builder withClaim(String name, String value) throws IllegalArgumentException {
            assertNonNull(name);
            addClaim(name, value);
            return this;
        }

        /**
         * Add a custom Claim value. The claim will be written as seconds since the epoch.
         * Milliseconds will be truncated by rounding down to the nearest second.
         *
         * @param name  the Claim's name.
         * @param value the Claim's value.
         * @return this same Builder instance.
         * @throws IllegalArgumentException if the name is null.
         */
        public Builder withClaim(String name, Date value) throws IllegalArgumentException {
            assertNonNull(name);
            addClaim(name, value);
            return this;
        }

        /**
         * Add a custom Claim value. The claim will be written as seconds since the epoch.
         * Milliseconds will be truncated by rounding down to the nearest second.
         *
         * @param name  the Claim's name.
         * @param value the Claim's value.
         * @return this same Builder instance.
         * @throws IllegalArgumentException if the name is null.
         */
        public Builder withClaim(String name, Instant value) throws IllegalArgumentException {
            assertNonNull(name);
            addClaim(name, value);
            return this;
        }

        /**
         * Add a custom Map Claim with the given items.
         * <p>
         * Accepted nested types are {@linkplain Map} and {@linkplain List} with basic types
         * {@linkplain Boolean}, {@linkplain Integer}, {@linkplain Long}, {@linkplain Double},
         * {@linkplain String} and {@linkplain Date}. {@linkplain Map}s cannot contain null keys or values.
         * {@linkplain List}s can contain null elements.
         *
         * @param name the Claim's name.
         * @param map  the Claim's key-values.
         * @return this same Builder instance.
         * @throws IllegalArgumentException if the name is null, or if the map contents does not validate.
         */
        public Builder withClaim(String name, Map<String, ?> map) throws IllegalArgumentException {
            assertNonNull(name);
            // validate map contents
            if (map != null && !validateClaim(map)) {
                throw new IllegalArgumentException("Expected map containing Map, List, Boolean, Integer, "
                        + "Long, Double, String and Date");
            }
            addClaim(name, map);
            return this;
        }

        /**
         * Add a custom List Claim with the given items.
         * <p>
         * Accepted nested types are {@linkplain Map} and {@linkplain List} with basic types
         * {@linkplain Boolean}, {@linkplain Integer}, {@linkplain Long}, {@linkplain Double},
         * {@linkplain String} and {@linkplain Date}. {@linkplain Map}s cannot contain null keys or values.
         * {@linkplain List}s can contain null elements.
         *
         * @param name the Claim's name.
         * @param list the Claim's list of values.
         * @return this same Builder instance.
         * @throws IllegalArgumentException if the name is null, or if the list contents does not validate.
         */
        public Builder withClaim(String name, List<?> list) throws IllegalArgumentException {
            assertNonNull(name);
            // validate list contents
            if (list != null && !validateClaim(list)) {
                throw new IllegalArgumentException("Expected list containing Map, List, Boolean, Integer, "
                        + "Long, Double, String and Date");
            }
            addClaim(name, list);
            return this;
        }

        /**
         * Add a custom claim with null value.
         *
         * @param name the Claim's name.
         * @return this same Builder instance.
         * @throws IllegalArgumentException if the name is null
         */
        public Builder withNullClaim(String name) throws IllegalArgumentException {
            assertNonNull(name);
            addClaim(name, null);
            return this;
        }

        /**
         * Add a custom Array Claim with the given items.
         *
         * @param name  the Claim's name.
         * @param items the Claim's value.
         * @return this same Builder instance.
         * @throws IllegalArgumentException if the name is null.
         */
        public Builder withArrayClaim(String name, String[] items) throws IllegalArgumentException {
            assertNonNull(name);
            addClaim(name, items);
            return this;
        }

        /**
         * Add a custom Array Claim with the given items.
         *
         * @param name  the Claim's name.
         * @param items the Claim's value.
         * @return this same Builder instance.
         * @throws IllegalArgumentException if the name is null.
         */
        public Builder withArrayClaim(String name, Integer[] items) throws IllegalArgumentException {
            assertNonNull(name);
            addClaim(name, items);
            return this;
        }

        /**
         * Add a custom Array Claim with the given items.
         *
         * @param name  the Claim's name.
         * @param items the Claim's value.
         * @return this same Builder instance.
         * @throws IllegalArgumentException if the name is null
         */
        public Builder withArrayClaim(String name, Long[] items) throws IllegalArgumentException {
            assertNonNull(name);
            addClaim(name, items);
            return this;
        }

        /**
         * Add specific Claims to set as the Payload. If the provided map is null then
         * nothing is changed.
         * <p>
         * Accepted types are {@linkplain Map} and {@linkplain List} with basic types
         * {@linkplain Boolean}, {@linkplain Integer}, {@linkplain Long}, {@linkplain Double},
         * {@linkplain String} and {@linkplain Date}.
         * {@linkplain Map}s and {@linkplain List}s can contain null elements.
         * </p>
         *
         * <p>
         * If any of the claims are invalid, none will be added.
         * </p>
         *
         * @param payloadClaims the values to use as Claims in the token's payload.
         * @return this same Builder instance.
         * @throws IllegalArgumentException if any of the claim keys or null,
         *                                  or if the values are not of a supported type.
         */
        public Builder withPayload(Map<String, ?> payloadClaims) throws IllegalArgumentException {
            if (payloadClaims == null) {
                return this;
            }

            if (!validatePayload(payloadClaims)) {
                throw new IllegalArgumentException("Claim values must only be of types Map, List, Boolean, Integer, "
                        + "Long, Double, String, Date, Instant, and Null");
            }

            // add claims only after validating all claims so as not to corrupt the claims map of this builder
            for (Map.Entry<String, ?> entry : payloadClaims.entrySet()) {
                addClaim(entry.getKey(), entry.getValue());
            }

            return this;
        }

        /**
         * Add specific Claims to set as the Payload. If the provided json is null then
         * nothing is changed.
         *
         * <p>
         * If any of the claims are invalid, none will be added.
         * </p>
         *
         * @param payloadClaimsJson the values to use as Claims in the token's payload.
         * @return this same Builder instance.
         * @throws IllegalArgumentException if any of the claim keys or null,
         *                                  or if the values are not of a supported type,
         *                                  or if json value has invalid structure.
         */
        public Builder withPayload(String payloadClaimsJson) throws IllegalArgumentException {
            if (payloadClaimsJson == null) {
                return this;
            }

            try {
                Map<String, Object> payloadClaims =  mapper.readValue(payloadClaimsJson, LinkedHashMap.class);
                return withPayload(payloadClaims);
            } catch (JsonProcessingException e) {
                throw new IllegalArgumentException("Invalid payload JSON", e);
            }
        }

        private boolean validatePayload(Map<String, ?> payload) {
            for (Map.Entry<String, ?> entry : payload.entrySet()) {
                String key = entry.getKey();
                assertNonNull(key);

                Object value = entry.getValue();
                if (value instanceof List && !validateClaim((List<?>) value)) {
                    return false;
                } else if (value instanceof Map && !validateClaim((Map<?, ?>) value)) {
                    return false;
                } else if (!isSupportedType(value)) {
                    return false;
                }
            }
            return true;
        }

        private static boolean validateClaim(Map<?, ?> map) {
            // do not accept null values in maps
            for (Entry<?, ?> entry : map.entrySet()) {
                Object value = entry.getValue();
                if (!isSupportedType(value)) {
                    return false;
                }

                if (!(entry.getKey() instanceof String)) {
                    return false;
                }
            }
            return true;
        }

        private static boolean validateClaim(List<?> list) {
            // accept null values in list
            for (Object object : list) {
                if (!isSupportedType(object)) {
                    return false;
                }
            }
            return true;
        }

        private static boolean isSupportedType(Object value) {
            if (value instanceof List) {
                return validateClaim((List<?>) value);
            } else if (value instanceof Map) {
                return validateClaim((Map<?, ?>) value);
            } else {
                return isBasicType(value);
            }
        }

        private static boolean isBasicType(Object value) {
            if (value == null) {
                return true;
            } else {
                Class<?> c = value.getClass();

                if (c.isArray()) {
                    return c == Integer[].class || c == Long[].class || c == String[].class;
                }
                return c == String.class || c == Integer.class || c == Long.class || c == Double.class
                        || c == Date.class || c == Instant.class || c == Boolean.class;
            }
        }

        /**
         * Creates a new JWT and signs is with the given algorithm.
         *
         * @param algorithm used to sign the JWT
         * @return a new JWT token
         * @throws IllegalArgumentException if the provided algorithm is null.
         * @throws JWTCreationException     if the claims could not be converted to a valid JSON
         *                                  or there was a problem with the signing key.
         */
        public String sign(Algorithm algorithm) throws IllegalArgumentException, JWTCreationException {
            if (algorithm == null) {
                throw new IllegalArgumentException("The Algorithm cannot be null.");
            }
            headerClaims.put(HeaderParams.ALGORITHM, algorithm.getName());
            if (!headerClaims.containsKey(HeaderParams.TYPE)) {
                headerClaims.put(HeaderParams.TYPE, "JWT");
            }
            String signingKeyId = algorithm.getSigningKeyId();
            if (signingKeyId != null) {
                withKeyId(signingKeyId);
            }
            return new JWTCreator(algorithm, headerClaims, payloadClaims).sign();
        }

        private void assertNonNull(String name) {
            if (name == null) {
                throw new IllegalArgumentException("The Custom Claim's name can't be null.");
            }
        }

        private void addClaim(String name, Object value) {
            payloadClaims.put(name, value);
        }
    }

    private String sign() throws SignatureGenerationException {
        String header = Base64.getUrlEncoder().withoutPadding()
                .encodeToString(headerJson.getBytes(StandardCharsets.UTF_8));
        String payload = Base64.getUrlEncoder().withoutPadding()
                .encodeToString(payloadJson.getBytes(StandardCharsets.UTF_8));

        byte[] signatureBytes = algorithm.sign(header.getBytes(StandardCharsets.UTF_8),
                payload.getBytes(StandardCharsets.UTF_8));
        String signature = Base64.getUrlEncoder().withoutPadding().encodeToString((signatureBytes));

        return String.format("%s.%s.%s", header, payload, signature);
    }
}
