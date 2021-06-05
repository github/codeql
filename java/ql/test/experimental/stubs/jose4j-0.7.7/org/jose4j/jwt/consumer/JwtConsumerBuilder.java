/*
 * Copyright 2012-2017 Brian Campbell
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

package org.jose4j.jwt.consumer;

import java.security.Key;
import java.util.*;

/**
 * <p>
 * Use the JwtConsumerBuilder to create the appropriate JwtConsumer for your JWT processing needs.
 * </p>
 *
 * The specific validation requirements for a JWT are context dependent, however,
 * it typically advisable to require a (reasonable) expiration time, a trusted issuer, and
 * and audience that identifies your system as the intended recipient.
 * For example, a {@code JwtConsumer} might be set up and used like this:
 *
 * <pre>
 *
 *   JwtConsumer jwtConsumer = new JwtConsumerBuilder()
     .setRequireExpirationTime() // the JWT must have an expiration time
     .setMaxFutureValidityInMinutes(300) // but the  expiration time can't be too crazy
     .setExpectedIssuer("Issuer") // whom the JWT needs to have been issued by
     .setExpectedAudience("Audience") // to whom the JWT is intended for
     .setVerificationKey(publicKey) // verify the signature with the public key
     .build(); // create the JwtConsumer instance

   try
   {
     //  Validate the JWT and process it to the Claims
     JwtClaims jwtClaims = jwtConsumer.processToClaims(jwt);
     System.out.println("JWT validation succeeded! " + jwtClaims);
   }
   catch (InvalidJwtException e)
   {
     // InvalidJwtException will be thrown, if the JWT failed processing or validation in anyway.
     // Hopefully with meaningful explanations(s) about what went wrong.
     System.out.println("Invalid JWT! " + e);
   }
 *
 * </pre>
 *
 * <p>
 *   JwtConsumer instances created from this are thread safe and reusable (as long as
 *   any custom Validators or Customizers used are also thread safe).
 * </p>
 */
public class JwtConsumerBuilder
{
    /**
     * Creates a new JwtConsumerBuilder, which is set up by default to build a JwtConsumer
     * that requires a signature and will validate the core JWT claims when they
     * are present. The various methods on the builder should be used to customize
     * the JwtConsumer's behavior as appropriate.
     */
    public JwtConsumerBuilder()
    {
    }

    /**
     * Require that the JWT be encrypted, which is not required by default.
     * @return the same JwtConsumerBuilder
     */
    public JwtConsumerBuilder setEnableRequireEncryption()
    {
        return null;
    }

    /**
     * Require that the JWT have some integrity protection, 
     * either a signature/MAC JWS or a JWE using a symmetric key management algorithm.
     * @return the same JwtConsumerBuilder
     */
    public JwtConsumerBuilder setEnableRequireIntegrity()
    {
        return null;
    }

    /**
     * Because integrity protection is needed in most usages of JWT, a signature on the JWT is required by default.
     * Calling this turns that requirement off. It may be necessary, for example, when integrity is ensured though
     * other means like a JWE using a symmetric key management algorithm. Use this in conjunction with
     * {@link #setEnableRequireIntegrity()} for that case.
     * @return the same JwtConsumerBuilder
     */
    public JwtConsumerBuilder setDisableRequireSignature()
    {
        return null;
    }

    /**
     * <p>
     * According to <a href="http://tools.ietf.org/html/rfc7519#section-5.2">section 5.2 of the JWT spec</a>,
     * when nested signing or encryption is employed with a JWT, the "cty" header parameter has to be present and
     * have a value of "JWT" to indicate that a nested JWT is the payload of the outer JWT.
     * </p>
     * <p>
     * Not all JWTs follow that requirement of the spec and this provides a work around for
     * consuming non-compliant JWTs.
     * Calling this method tells the JwtConsumer to be a bit more liberal in processing and
     * make a best effort when the "cty" header isnâ€™t present and the payload doesn't parse as JSON
     * but can be parsed into a JOSE object.
     * </p>
     * @return the same JwtConsumerBuilder
     */
    public JwtConsumerBuilder setEnableLiberalContentTypeHandling()
    {
        return null;
    }

    /**
     * <p>
     * Skip signature verification.
     * </p>
     * This might be useful in cases where you don't have enough
     * information to set up a validating JWT consumer without cracking open the JWT first. For example,
     * in some contexts you might not know who issued the token without looking at the "iss" claim inside the JWT.
     * In such a case two JwtConsumers cab be used in a "two-pass" validation of sorts - the first JwtConsumer parses the JWT but
     * doesn't validate the signature or claims due to the use of methods like this one and the second JwtConsumers
     * does the actual validation.
     *
     * @return the same JwtConsumerBuilder
     */
    public JwtConsumerBuilder setSkipSignatureVerification()
    {
        return null;
    }

    /**
     * <p>
     * Skip all claims validation.
     * </p>
     * This might be useful in cases where you don't have enough
     * information to set up a validating JWT consumer without cracking open the JWT first. For example,
     * in some contexts you might not know who issued the token without looking at the "iss" claim inside the JWT.
     * In such a case two JwtConsumers cab be used in a "two-pass" validation of sorts - the first JwtConsumer parses the JWT but
     * doesn't validate the signature or claims due to the use of methods like this one and the second JwtConsumers
     * does the actual validation.
     *
     * @return the same JwtConsumerBuilder
     */
    public JwtConsumerBuilder setSkipAllValidators()
    {
        return null;
    }

    /**
     * Skip all the default claim validation but not those provided via {@link #registerValidator(Validator)}.
     * @return the same JwtConsumerBuilder
     */
    public JwtConsumerBuilder setSkipAllDefaultValidators()
    {
        return null;
    }

    /**
     * Set the key to be used for JWS signature/MAC verification.
     * @param verificationKey the verification key.
     * @return the same JwtConsumerBuilder
     */
    public JwtConsumerBuilder setVerificationKey(Key verificationKey)
    {
        return null;
    }

    /**
     * Indicates that the JwtConsumer will not call the VerificationKeyResolver for a JWS using the
     * 'none' algorithm.
     * @return the same JwtConsumerBuilder
     */
    public JwtConsumerBuilder setSkipVerificationKeyResolutionOnNone()
    {
        return null;
    }

    /**
     * Set the key to be used for JWE decryption.
     * @param decryptionKey the decryption key.
     * @return the same JwtConsumerBuilder
     */
    public JwtConsumerBuilder setDecryptionKey(Key decryptionKey)
    {
        return null;
    }

    /**
     * <p>
     * Set the audience value(s) to use when validating the audience ("aud") claim of a JWT
     * and require that an audience claim be present.
     * Audience validation will succeed, if any one of the provided values is equal to any one
     * of the values of the "aud" claim in the JWT.
     * </p>
     * <p>
     * From <a href="http://tools.ietf.org/html/rfc7519#section-4.1.3">Section 4.1.3 of RFC 7519</a>:
     *  The "aud" (audience) claim identifies the recipients that the JWT is
     * intended for.  Each principal intended to process the JWT MUST
     * identify itself with a value in the audience claim.  If the principal
     * processing the claim does not identify itself with a value in the
     * "aud" claim when this claim is present, then the JWT MUST be
     * rejected.  In the general case, the "aud" value is an array of case-
     * sensitive strings, each containing a StringOrURI value.  In the
     * special case when the JWT has one audience, the "aud" value MAY be a
     * single case-sensitive string containing a StringOrURI value.  The
     * interpretation of audience values is generally application specific.
     * Use of this claim is OPTIONAL.
     * </p>
     * <p>Equivalent to calling {@link #setExpectedAudience(boolean, String...)} with {@code true} as the first argument.</p>
     * @param audience the audience value(s) that identify valid recipient(s) of a JWT
     * @return the same JwtConsumerBuilder
     */
    public JwtConsumerBuilder setExpectedAudience(String... audience)
    {
        return null;
    }

    /**
     * Set the audience value(s) to use when validating the audience ("aud") claim of a JWT.
     * Audience validation will succeed, if any one of the provided values is equal to any one
     * of the values of the "aud" claim in the JWT.
     * </p>
     * <p>
     * If present, the audience claim will always be validated (unless explicitly disabled). The {@code requireAudienceClaim} parameter
     * can be used to indicate whether or not the presence of the audience claim is required. In most cases
     *  {@code requireAudienceClaim} should be {@code true}.
     * </p>
     * <p>
     * From <a href="http://tools.ietf.org/html/rfc7519#section-4.1.3">Section 4.1.3 of RFC 7519</a>:
     *  The "aud" (audience) claim identifies the recipients that the JWT is
     * intended for.  Each principal intended to process the JWT MUST
     * identify itself with a value in the audience claim.  If the principal
     * processing the claim does not identify itself with a value in the
     * "aud" claim when this claim is present, then the JWT MUST be
     * rejected.  In the general case, the "aud" value is an array of case-
     * sensitive strings, each containing a StringOrURI value.  In the
     * special case when the JWT has one audience, the "aud" value MAY be a
     * single case-sensitive string containing a StringOrURI value.  The
     * interpretation of audience values is generally application specific.
     * Use of this claim is OPTIONAL.
     * </p>
     * @param requireAudienceClaim true, if an audience claim has to be present for validation to succeed. false, otherwise
     * @param audience the audience value(s) that identify valid recipient(s) of a JWT
     * @return the same JwtConsumerBuilder
     */
    public JwtConsumerBuilder setExpectedAudience(boolean requireAudienceClaim, String... audience)
    {
        return null;
    }

    /**
     * Skip the default audience validation.
     * @return the same JwtConsumerBuilder
     */
    public JwtConsumerBuilder setSkipDefaultAudienceValidation()
    {
        return null;
    }

    /**
     * Indicates whether or not the issuer ("iss") claim is required and optionally what the expected values can be.
     * @param requireIssuer true if issuer claim is required, false otherwise
     * @param expectedIssuers the values, one of which the issuer claim must match to pass validation, {@code null} means that any value is acceptable
     * @return the same JwtConsumerBuilder
     */
    public JwtConsumerBuilder setExpectedIssuers(boolean requireIssuer, String... expectedIssuers)
    {
        return null;
    }

    /**
     * Indicates whether or not the issuer ("iss") claim is required and optionally what the expected value is.
     * @param requireIssuer true if issuer is required, false otherwise
     * @param expectedIssuer the value that the issuer claim must have to pass validation, {@code null} means that any value is acceptable
     * @return the same JwtConsumerBuilder
     */
    public JwtConsumerBuilder setExpectedIssuer(boolean requireIssuer, String expectedIssuer)
    {
        return null;
    }

    /**
     * Indicates the expected value of the issuer ("iss") claim and that the claim is required.
     * Equivalent to calling {@link #setExpectedIssuer(boolean, String)} with {@code true} as the first argument.
     * @param expectedIssuer the value that the issuer claim must have to pass validation, {@code null} means that any value is acceptable
     * @return the same JwtConsumerBuilder
     */
    public JwtConsumerBuilder setExpectedIssuer(String expectedIssuer)
    {
        return null;
    }

    /**
     * Require that a subject ("sub") claim be present in the JWT.
     * @return the same JwtConsumerBuilder
     */
    public JwtConsumerBuilder setRequireSubject()
    {
        return null;
    }

    /**
     * Require that a subject ("sub") claim be present in the JWT and that its value
     * match that of the provided subject.
     * The subject ("sub") claim is defined in <a href="http://tools.ietf.org/html/rfc7519#section-4.1.2">Section 4.1.2 of RFC 7519</a>.
     *
     * @param subject the required value of the subject claim.
     * @return the same JwtConsumerBuilder
     */
    public JwtConsumerBuilder setExpectedSubject(String subject)
    {
        return null;
    }

    /**
     * Require that a <a href="http://tools.ietf.org/html/rfc7519#section-4.1.7">JWT ID ("jti") claim</a> be present in the JWT.
     * @return the same JwtConsumerBuilder
     */
    public JwtConsumerBuilder setRequireJwtId()
    {
        return null;
    }

    /**
     * Require that the JWT contain an <a href="http://tools.ietf.org/html/rfc7519#section-4.1.4">expiration time ("exp") claim</a>.
     * The expiration time is always checked when present (unless explicitly disabled) but
     * calling this method strengthens the requirement such that a JWT without an expiration time
     * will not pass validation.
     * @return the same JwtConsumerBuilder
     */
    public JwtConsumerBuilder setRequireExpirationTime()
    {
        return null;
    }

    /**
     * Require that the JWT contain an <a href="http://tools.ietf.org/html/rfc7519#section-4.1.6">issued at time ("iat") claim</a>.
     * @return the same JwtConsumerBuilder
     */
    public JwtConsumerBuilder setRequireIssuedAt()
    {
        return null;
    }

    /**
     * Places restrictions on how far from the time of evaluation the value of an
     * <a href="http://tools.ietf.org/html/rfc7519#section-4.1.6">issued at time ("iat") claim</a> can be while still
     * accepting the token as valid. Also use {@link #setRequireIssuedAt()} to require that an "iat" claim be present.
     * @param allowedSecondsInTheFuture how many seconds ahead of the current evaluation time the value of the "iat" claim can be
     * @param allowedSecondsInThePast how many seconds ago the value of the "iat" claim can be
     * @return the same JwtConsumerBuilder
     */
    public JwtConsumerBuilder setIssuedAtRestrictions(int allowedSecondsInTheFuture, int allowedSecondsInThePast)
    {
        return null;
    }

    /**
     * Require that the JWT contain an <a href="http://tools.ietf.org/html/rfc7519#section-4.1.5">not before ("nbf") claim</a>.
     * @return the same JwtConsumerBuilder
     */
    public JwtConsumerBuilder setRequireNotBefore()
    {
        return null;
    }

    /**
     * Set the amount of clock skew to allow for when validate the expiration time, issued at time, and not before time claims.
     * @param secondsOfAllowedClockSkew the number of seconds of leniency in date comparisons
     * @return the same JwtConsumerBuilder
     */
    public JwtConsumerBuilder setAllowedClockSkewInSeconds(int secondsOfAllowedClockSkew)
    {
        return null;
    }

    /**
     * Set maximum on how far in the future the "exp" claim can be.
     * @param maxFutureValidityInMinutes how far is too far (in minutes)
     * @return the same JwtConsumerBuilder
     */
    public JwtConsumerBuilder setMaxFutureValidityInMinutes(int maxFutureValidityInMinutes)
    {
        return null;
    }

    /**
     * Bypass the strict checks on the verification key. This might be needed, for example, if the
     * JWT issuer is using 1024 bit RSA keys or HMAC secrets that are too small (smaller than the size of the hash output).
     * @return the same JwtConsumerBuilder
     */
    public JwtConsumerBuilder setRelaxVerificationKeyValidation()
    {
        return null;
    }

    /**
     * Bypass the strict checks on the decryption key.
     * @return the same JwtConsumerBuilder
     */
    public JwtConsumerBuilder setRelaxDecryptionKeyValidation()
    {
        return null;
    }

    /**
     * Create the JwtConsumer with the options provided to the builder.
     * @return the JwtConsumer
     */
    public JwtConsumer build()
    {
        return null;
   }
}
