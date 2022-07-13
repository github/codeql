package com.auth0.jwt;

import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTCreationException;

import java.util.*;

/**
 * The JWTCreator class holds the sign method to generate a complete JWT (with Signature) from a given Header and Payload content.
 * <p>
 * This class is thread-safe.
 */
public final class JWTCreator {
    /**
     * Initialize a JWTCreator instance.
     *
     * @return a JWTCreator.Builder instance to configure.
     */
    static JWTCreator.Builder init() {
        return null;
    }

    /**
     * The Builder class holds the Claims that defines the JWT to be created.
     */
    public static class Builder {
        Builder() {
        }

        /**
         * Add specific Claims to set as the Header.
         * If provided map is null then nothing is changed
         * If provided map contains a claim with null value then that claim will be removed from the header
         *
         * @param headerClaims the values to use as Claims in the token's Header.
         * @return this same Builder instance.
         */
        public Builder withHeader(Map<String, Object> headerClaims) {
            return null;
        }

        /**
         * Add a specific Key Id ("kid") claim to the Header.
         * If the {@link Algorithm} used to sign this token was instantiated with a KeyProvider, the 'kid' value will be taken from that provider and this one will be ignored.
         *
         * @param keyId the Key Id value.
         * @return this same Builder instance.
         */
        public Builder withKeyId(String keyId) {
            return null;
        }

        /**
         * Add a specific Issuer ("iss") claim to the Payload.
         *
         * @param issuer the Issuer value.
         * @return this same Builder instance.
         */
        public Builder withIssuer(String issuer) {
            return null;
        }

        /**
         * Add a specific Subject ("sub") claim to the Payload.
         *
         * @param subject the Subject value.
         * @return this same Builder instance.
         */
        public Builder withSubject(String subject) {
            return null;
        }

        /**
         * Add a specific Audience ("aud") claim to the Payload.
         *
         * @param audience the Audience value.
         * @return this same Builder instance.
         */
        public Builder withAudience(String... audience) {
            return null;
        }

        /**
         * Add a specific Expires At ("exp") claim to the Payload.
         *
         * @param expiresAt the Expires At value.
         * @return this same Builder instance.
         */
        public Builder withExpiresAt(Date expiresAt) {
            return null;
        }

        /**
         * Add a specific Not Before ("nbf") claim to the Payload.
         *
         * @param notBefore the Not Before value.
         * @return this same Builder instance.
         */
        public Builder withNotBefore(Date notBefore) {
            return null;
        }

        /**
         * Add a specific Issued At ("iat") claim to the Payload.
         *
         * @param issuedAt the Issued At value.
         * @return this same Builder instance.
         */
        public Builder withIssuedAt(Date issuedAt) {
            return null;
        }

        /**
         * Add a specific JWT Id ("jti") claim to the Payload.
         *
         * @param jwtId the Token Id value.
         * @return this same Builder instance.
         */
        public Builder withJWTId(String jwtId) {
            return null;
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
            return null;
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
            return null;
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
            return null;
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
            return null;
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
            return null;
        }

        /**
         * Add a custom Claim value.
         *
         * @param name  the Claim's name.
         * @param value the Claim's value.
         * @return this same Builder instance.
         * @throws IllegalArgumentException if the name is null.
         */
        public Builder withClaim(String name, Date value) throws IllegalArgumentException {
            return null;
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
            return null;
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
            return null;
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
            return null;
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
            return null;
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
            return null;
        }

        /**
         * Add specific Claims to set as the Payload. If the provided map is null then
         * nothing is changed.
         * <p>
         * Accepted types are {@linkplain Map} and {@linkplain List} with basic types
         * {@linkplain Boolean}, {@linkplain Integer}, {@linkplain Long}, {@linkplain Double},
         * {@linkplain String} and {@linkplain Date}. {@linkplain Map}s cannot contain null keys or values.
         * {@linkplain List}s can contain null elements.
         * </p>
         *
         * <p>
         * If any of the claims are invalid, none will be added.
         * </p>
         *
         * @param payloadClaims the values to use as Claims in the token's payload.
         * @throws IllegalArgumentException if any of the claim keys or null, or if the values are not of a supported type.
         * @return this same Builder instance.
         */
        public Builder withPayload(Map<String, ?> payloadClaims) throws IllegalArgumentException {
            return null;
        }

        /**
         * Creates a new JWT and signs is with the given algorithm
         *
         * @param algorithm used to sign the JWT
         * @return a new JWT token
         * @throws IllegalArgumentException if the provided algorithm is null.
         * @throws JWTCreationException     if the claims could not be converted to a valid JSON or there was a problem with the signing key.
         */
        public String sign(Algorithm algorithm) throws IllegalArgumentException, JWTCreationException {
            return null;
        }
    }
}