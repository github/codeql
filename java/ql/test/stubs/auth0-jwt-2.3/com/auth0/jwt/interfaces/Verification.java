package com.auth0.jwt.interfaces;

import java.util.Date;

/**
 * Holds the Claims and claim-based configurations required for a JWT to be considered valid.
 */
public interface Verification {
    /**
     * Require a specific Issuer ("iss") claim.
     *
     * @param issuer the required Issuer value. If multiple values are given, the claim must at least match one of them
     * @return this same Verification instance.
     */
    Verification withIssuer(String... issuer);

    /**
     * Require a specific Subject ("sub") claim.
     *
     * @param subject the required Subject value
     * @return this same Verification instance.
     */
    Verification withSubject(String subject);

    /**
     * Require a specific Audience ("aud") claim. If multiple audiences are specified, they must all be present
     * in the "aud" claim.
     *
     * If this is used in conjunction with {@link #withAnyOfAudience(String...)}, whichever one is configured last will
     * determine the audience validation behavior.
     *
     * @param audience the required Audience value
     * @return this same Verification instance.
     */
    Verification withAudience(String... audience);

    /**
     * Set a specific leeway window in seconds in which the Expires At ("exp") Claim will still be valid.
     * Expiration Date is always verified when the value is present. This method overrides the value set with acceptLeeway
     *
     * @param leeway the window in seconds in which the Expires At Claim will still be valid.
     * @return this same Verification instance.
     * @throws IllegalArgumentException if leeway is negative.
     */
    Verification acceptExpiresAt(long leeway) throws IllegalArgumentException;

    /**
     * Set a specific leeway window in seconds in which the Not Before ("nbf") Claim will still be valid.
     * Not Before Date is always verified when the value is present. This method overrides the value set with acceptLeeway
     *
     * @param leeway the window in seconds in which the Not Before Claim will still be valid.
     * @return this same Verification instance.
     * @throws IllegalArgumentException if leeway is negative.
     */
    Verification acceptNotBefore(long leeway) throws IllegalArgumentException;

    /**
     * Set a specific leeway window in seconds in which the Issued At ("iat") Claim will still be valid.
     * This method overrides the value set with {@link #acceptLeeway(long)}.
     * By default, the Issued At claim is always verified when the value is present, unless disabled with {@link #ignoreIssuedAt()}.
     * If Issued At verification has been disabled, no verification of the Issued At claim will be performed, and this method has no effect.
     *
     * @param leeway the window in seconds in which the Issued At Claim will still be valid.
     * @return this same Verification instance.
     * @throws IllegalArgumentException if leeway is negative.
     */
    Verification acceptIssuedAt(long leeway) throws IllegalArgumentException;

    /**
     * Require a specific JWT Id ("jti") claim.
     *
     * @param jwtId the required Id value
     * @return this same Verification instance.
     */
    Verification withJWTId(String jwtId);

    /**
     * Require a claim to be present, with any value.
     * @param name the Claim's name.
     * @return this same Verification instance
     * @throws IllegalArgumentException if the name is null.
     */
    Verification withClaimPresence(String name) throws IllegalArgumentException;

    /**
     * Require a specific Claim value.
     *
     * @param name  the Claim's name.
     * @param value the Claim's value.
     * @return this same Verification instance.
     * @throws IllegalArgumentException if the name is null.
     */
    Verification withClaim(String name, Boolean value) throws IllegalArgumentException;

    /**
     * Require a specific Claim value.
     *
     * @param name  the Claim's name.
     * @param value the Claim's value.
     * @return this same Verification instance.
     * @throws IllegalArgumentException if the name is null.
     */
    Verification withClaim(String name, Integer value) throws IllegalArgumentException;

    /**
     * Require a specific Claim value.
     *
     * @param name  the Claim's name.
     * @param value the Claim's value.
     * @return this same Verification instance.
     * @throws IllegalArgumentException if the name is null.
     */
    Verification withClaim(String name, Long value) throws IllegalArgumentException;

    /**
     * Require a specific Claim value.
     *
     * @param name  the Claim's name.
     * @param value the Claim's value.
     * @return this same Verification instance.
     * @throws IllegalArgumentException if the name is null.
     */
    Verification withClaim(String name, Double value) throws IllegalArgumentException;

    /**
     * Require a specific Claim value.
     *
     * @param name  the Claim's name.
     * @param value the Claim's value.
     * @return this same Verification instance.
     * @throws IllegalArgumentException if the name is null.
     */
    Verification withClaim(String name, String value) throws IllegalArgumentException;

    /**
     * Require a specific Claim value.
     *
     * @param name  the Claim's name.
     * @param value the Claim's value.
     * @return this same Verification instance.
     * @throws IllegalArgumentException if the name is null.
     */
    Verification withClaim(String name, Date value) throws IllegalArgumentException;

    /**
     * Require a specific Array Claim to contain at least the given items.
     *
     * @param name  the Claim's name.
     * @param items the items the Claim must contain.
     * @return this same Verification instance.
     * @throws IllegalArgumentException if the name is null.
     */
    Verification withArrayClaim(String name, String... items) throws IllegalArgumentException;

    /**
     * Require a specific Array Claim to contain at least the given items.
     *
     * @param name  the Claim's name.
     * @param items the items the Claim must contain.
     * @return this same Verification instance.
     * @throws IllegalArgumentException if the name is null.
     */
    Verification withArrayClaim(String name, Integer... items) throws IllegalArgumentException;

    /**
     * Require a specific Array Claim to contain at least the given items.
     *
     * @param name  the Claim's name.
     * @param items the items the Claim must contain.
     * @return this same Verification instance.
     * @throws IllegalArgumentException if the name is null.
     */

    Verification withArrayClaim(String name, Long ... items) throws IllegalArgumentException;

    /**
     * Skip the Issued At ("iat") date verification. By default, the verification is performed.
     *
     * @return this same Verification instance.
     */
    Verification ignoreIssuedAt();

    /**
     * Creates a new and reusable instance of the JWTVerifier with the configuration already provided.
     *
     * @return a new JWTVerifier instance.
     */
    JWTVerifier build();
}