package com.auth0.jwt.interfaces;

import com.auth0.jwt.JWTVerifier;

import java.time.Instant;
import java.util.Date;
import java.util.function.BiPredicate;

/**
 * Constructs and holds the checks required for a JWT to be considered valid. Note that implementations are
 * <strong>not</strong> thread-safe. Once built by calling {@link #build()}, the resulting
 * {@link com.auth0.jwt.interfaces.JWTVerifier} is thread-safe.
 */
public interface Verification {

    /**
     * Verifies whether the JWT contains an Issuer ("iss") claim that equals to the value provided.
     * This check is case-sensitive.
     *
     * @param issuer the required Issuer value.
     * @return this same Verification instance.
     */
    default Verification withIssuer(String issuer) {
        return withIssuer(new String[]{issuer});
    }

    /**
     * Verifies whether the JWT contains an Issuer ("iss") claim that contains all the values provided.
     * This check is case-sensitive. An empty array is considered as a {@code null}.
     *
     * @param issuer the required Issuer value. If multiple values are given, the claim must at least match one of them
     * @return this same Verification instance.
     */
    Verification withIssuer(String... issuer);

    /**
     * Verifies whether the JWT contains a Subject ("sub") claim that equals to the value provided.
     * This check is case-sensitive.
     *
     * @param subject the required Subject value
     * @return this same Verification instance.
     */
    Verification withSubject(String subject);

    /**
     * Verifies whether the JWT contains an Audience ("aud") claim that contains all the values provided.
     * This check is case-sensitive. An empty array is considered as a {@code null}.
     *
     * @param audience the required Audience value
     * @return this same Verification instance.
     */
    Verification withAudience(String... audience);

    /**
     * Verifies whether the JWT contains an Audience ("aud") claim contain at least one of the specified audiences.
     * This check is case-sensitive. An empty array is considered as a {@code null}.
     *
     * @param audience the required Audience value for which the "aud" claim must contain at least one value.
     * @return this same Verification instance.
     */
    Verification withAnyOfAudience(String... audience);
    
    /**
     * Define the default window in seconds in which the Not Before, Issued At and Expires At Claims
     * will still be valid. Setting a specific leeway value on a given Claim will override this value for that Claim.
     *
     * @param leeway the window in seconds in which the Not Before, Issued At and Expires At Claims will still be valid.
     * @return this same Verification instance.
     * @throws IllegalArgumentException if leeway is negative.
     */
    Verification acceptLeeway(long leeway) throws IllegalArgumentException;

    /**
     * Set a specific leeway window in seconds in which the Expires At ("exp") Claim will still be valid.
     * Expiration Date is always verified when the value is present.
     * This method overrides the value set with acceptLeeway
     *
     * @param leeway the window in seconds in which the Expires At Claim will still be valid.
     * @return this same Verification instance.
     * @throws IllegalArgumentException if leeway is negative.
     */
    Verification acceptExpiresAt(long leeway) throws IllegalArgumentException;

    /**
     * Set a specific leeway window in seconds in which the Not Before ("nbf") Claim will still be valid.
     * Not Before Date is always verified when the value is present.
     * This method overrides the value set with acceptLeeway
     *
     * @param leeway the window in seconds in which the Not Before Claim will still be valid.
     * @return this same Verification instance.
     * @throws IllegalArgumentException if leeway is negative.
     */
    Verification acceptNotBefore(long leeway) throws IllegalArgumentException;

    /**
     * Set a specific leeway window in seconds in which the Issued At ("iat") Claim will still be valid.
     * This method overrides the value set with {@link #acceptLeeway(long)}.
     * By default, the Issued At claim is always verified when the value is present,
     * unless disabled with {@link #ignoreIssuedAt()}.
     * If Issued At verification has been disabled, no verification of the Issued At claim will be performed,
     * and this method has no effect.
     *
     * @param leeway the window in seconds in which the Issued At Claim will still be valid.
     * @return this same Verification instance.
     * @throws IllegalArgumentException if leeway is negative.
     */
    Verification acceptIssuedAt(long leeway) throws IllegalArgumentException;

    /**
     * Verifies whether the JWT contains a JWT ID ("jti") claim that equals to the value provided.
     * This check is case-sensitive.
     *
     * @param jwtId the required ID value
     * @return this same Verification instance.
     */
    Verification withJWTId(String jwtId);

    /**
     * Verifies whether the claim is present in the JWT, with any value including {@code null}.
     *
     * @param name the Claim's name.
     * @return this same Verification instance
     * @throws IllegalArgumentException if the name is {@code null}.
     */
    Verification withClaimPresence(String name) throws IllegalArgumentException;

    /**
     * Verifies whether the claim is present with a {@code null} value.
     *
     * @param name the Claim's name.
     * @return this same Verification instance.
     * @throws IllegalArgumentException if the name is {@code null}.
     */
    Verification withNullClaim(String name) throws IllegalArgumentException;

    /**
     * Verifies whether the claim is equal to the given Boolean value.
     *
     * @param name  the Claim's name.
     * @param value the Claim's value.
     * @return this same Verification instance.
     * @throws IllegalArgumentException if the name is {@code null}.
     */
    Verification withClaim(String name, Boolean value) throws IllegalArgumentException;

    /**
     * Verifies whether the claim is equal to the given Integer value.
     *
     * @param name  the Claim's name.
     * @param value the Claim's value.
     * @return this same Verification instance.
     * @throws IllegalArgumentException if the name is {@code null}.
     */
    Verification withClaim(String name, Integer value) throws IllegalArgumentException;

    /**
     * Verifies whether the claim is equal to the given Long value.
     *
     * @param name  the Claim's name.
     * @param value the Claim's value.
     * @return this same Verification instance.
     * @throws IllegalArgumentException if the name is {@code null}.
     */
    Verification withClaim(String name, Long value) throws IllegalArgumentException;

    /**
     * Verifies whether the claim is equal to the given Integer value.
     *
     * @param name  the Claim's name.
     * @param value the Claim's value.
     * @return this same Verification instance.
     * @throws IllegalArgumentException if the name is {@code null}.
     */
    Verification withClaim(String name, Double value) throws IllegalArgumentException;

    /**
     * Verifies whether the claim is equal to the given String value.
     * This check is case-sensitive.
     *
     * @param name  the Claim's name.
     * @param value the Claim's value.
     * @return this same Verification instance.
     * @throws IllegalArgumentException if the name is {@code null}.
     */
    Verification withClaim(String name, String value) throws IllegalArgumentException;

    /**
     * Verifies whether the claim is equal to the given Date value.
     * Note that date-time claims are serialized as seconds since the epoch;
     * when verifying date-time claim value, any time units more granular than seconds will not be considered.
     *
     * @param name  the Claim's name.
     * @param value the Claim's value.
     * @return this same Verification instance.
     * @throws IllegalArgumentException if the name is {@code null}.
     */
    Verification withClaim(String name, Date value) throws IllegalArgumentException;

    /**
     * Verifies whether the claim is equal to the given Instant value.
     * Note that date-time claims are serialized as seconds since the epoch;
     * when verifying a date-time claim value, any time units more granular than seconds will not be considered.
     *
     * @param name  the Claim's name.
     * @param value the Claim's value.
     * @return this same Verification instance.
     * @throws IllegalArgumentException if the name is {@code null}.
     */
    default Verification withClaim(String name, Instant value) throws IllegalArgumentException {
        return withClaim(name, value != null ? Date.from(value) : null);
    }

    /**
     * Executes the predicate provided and the validates the JWT if the predicate returns true.
     *
     * @param name the Claim's name
     * @param predicate the predicate check to be done.
     * @return this same Verification instance.
     * @throws IllegalArgumentException if the name is {@code null}.
     */
    Verification withClaim(String name, BiPredicate<Claim, DecodedJWT> predicate) throws IllegalArgumentException;

    /**
     * Verifies whether the claim contain at least the given String items.
     *
     * @param name  the Claim's name.
     * @param items the items the Claim must contain.
     * @return this same Verification instance.
     * @throws IllegalArgumentException if the name is {@code null}.
     */
    Verification withArrayClaim(String name, String... items) throws IllegalArgumentException;

    /**
     * Verifies whether the claim contain at least the given Integer items.
     *
     * @param name  the Claim's name.
     * @param items the items the Claim must contain.
     * @return this same Verification instance.
     * @throws IllegalArgumentException if the name is {@code null}.
     */
    Verification withArrayClaim(String name, Integer... items) throws IllegalArgumentException;

    /**
     * Verifies whether the claim contain at least the given Long items.
     *
     * @param name  the Claim's name.
     * @param items the items the Claim must contain.
     * @return this same Verification instance.
     * @throws IllegalArgumentException if the name is {@code null}.
     */

    Verification withArrayClaim(String name, Long ... items) throws IllegalArgumentException;

    /**
     * Skip the Issued At ("iat") claim verification. By default, the verification is performed.
     *
     * @return this same Verification instance.
     */
    Verification ignoreIssuedAt();

    /**
     * Creates a new and reusable instance of the JWTVerifier with the configuration already provided.
     *
     * @return a new {@link com.auth0.jwt.interfaces.JWTVerifier} instance.
     */
    JWTVerifier build();
}
