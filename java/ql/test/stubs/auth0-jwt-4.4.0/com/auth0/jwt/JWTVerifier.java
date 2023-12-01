package com.auth0.jwt;

import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.*;
import com.auth0.jwt.impl.JWTParser;
import com.auth0.jwt.interfaces.Claim;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.auth0.jwt.impl.ExpectedCheckHolder;
import com.auth0.jwt.interfaces.Verification;

import java.time.Clock;
import java.time.Duration;
import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.*;
import java.util.function.BiPredicate;

/**
 * The JWTVerifier class holds the verify method to assert that a given Token has not only a proper JWT format,
 * but also its signature matches.
 * <p>
 * This class is thread-safe.
 *
 * @see com.auth0.jwt.interfaces.JWTVerifier
 */
public final class JWTVerifier implements com.auth0.jwt.interfaces.JWTVerifier {
    private final Algorithm algorithm;
    final List<ExpectedCheckHolder> expectedChecks;
    private final JWTParser parser;

    JWTVerifier(Algorithm algorithm, List<ExpectedCheckHolder> expectedChecks) {
        this.algorithm = algorithm;
        this.expectedChecks = Collections.unmodifiableList(expectedChecks);
        this.parser = new JWTParser();
    }

    /**
     * Initialize a {@link Verification} instance using the given Algorithm.
     *
     * @param algorithm the Algorithm to use on the JWT verification.
     * @return a {@link Verification} instance to configure.
     * @throws IllegalArgumentException if the provided algorithm is null.
     */
    static Verification init(Algorithm algorithm) throws IllegalArgumentException {
        return new BaseVerification(algorithm);
    }

    /**
     * {@link Verification} implementation that accepts all the expected Claim values for verification, and
     * builds a {@link com.auth0.jwt.interfaces.JWTVerifier} used to verify a JWT's signature and expected claims.
     *
     * Note that this class is <strong>not</strong> thread-safe. Calling {@link #build()} returns an instance of
     * {@link com.auth0.jwt.interfaces.JWTVerifier} which can be reused.
     */
    public static class BaseVerification implements Verification {
        private final Algorithm algorithm;
        private final List<ExpectedCheckHolder> expectedChecks;
        private long defaultLeeway;
        private final Map<String, Long> customLeeways;
        private boolean ignoreIssuedAt;
        private Clock clock;

        BaseVerification(Algorithm algorithm) throws IllegalArgumentException {
            if (algorithm == null) {
                throw new IllegalArgumentException("The Algorithm cannot be null.");
            }

            this.algorithm = algorithm;
            this.expectedChecks = new ArrayList<>();
            this.customLeeways = new HashMap<>();
            this.defaultLeeway = 0;
        }

        @Override
        public Verification withIssuer(String... issuer) {
            List<String> value = isNullOrEmpty(issuer) ? null : Arrays.asList(issuer);
            addCheck(RegisteredClaims.ISSUER, ((claim, decodedJWT) -> {
                if (verifyNull(claim, value)) {
                    return true;
                }
                if (value == null || !value.contains(claim.asString())) {
                    throw new IncorrectClaimException(
                            "The Claim 'iss' value doesn't match the required issuer.", RegisteredClaims.ISSUER, claim);
                }
                return true;
            }));
            return this;
        }

        @Override
        public Verification withSubject(String subject) {
            addCheck(RegisteredClaims.SUBJECT, (claim, decodedJWT) ->
                    verifyNull(claim, subject) || subject.equals(claim.asString()));
            return this;
        }

        @Override
        public Verification withAudience(String... audience) {
            List<String> value = isNullOrEmpty(audience) ? null : Arrays.asList(audience);
            addCheck(RegisteredClaims.AUDIENCE, ((claim, decodedJWT) -> {
                if (verifyNull(claim, value)) {
                    return true;
                }
                if (!assertValidAudienceClaim(decodedJWT.getAudience(), value, true)) {
                    throw new IncorrectClaimException("The Claim 'aud' value doesn't contain the required audience.",
                            RegisteredClaims.AUDIENCE, claim);
                }
                return true;
            }));
            return this;
        }

        @Override
        public Verification withAnyOfAudience(String... audience) {
            List<String> value = isNullOrEmpty(audience) ? null : Arrays.asList(audience);
            addCheck(RegisteredClaims.AUDIENCE, ((claim, decodedJWT) -> {
                if (verifyNull(claim, value)) {
                    return true;
                }
                if (!assertValidAudienceClaim(decodedJWT.getAudience(), value, false)) {
                    throw new IncorrectClaimException("The Claim 'aud' value doesn't contain the required audience.",
                            RegisteredClaims.AUDIENCE, claim);
                }
                return true;
            }));
            return this;
        }

        @Override
        public Verification acceptLeeway(long leeway) throws IllegalArgumentException {
            assertPositive(leeway);
            this.defaultLeeway = leeway;
            return this;
        }

        @Override
        public Verification acceptExpiresAt(long leeway) throws IllegalArgumentException {
            assertPositive(leeway);
            customLeeways.put(RegisteredClaims.EXPIRES_AT, leeway);
            return this;
        }

        @Override
        public Verification acceptNotBefore(long leeway) throws IllegalArgumentException {
            assertPositive(leeway);
            customLeeways.put(RegisteredClaims.NOT_BEFORE, leeway);
            return this;
        }

        @Override
        public Verification acceptIssuedAt(long leeway) throws IllegalArgumentException {
            assertPositive(leeway);
            customLeeways.put(RegisteredClaims.ISSUED_AT, leeway);
            return this;
        }

        @Override
        public Verification ignoreIssuedAt() {
            this.ignoreIssuedAt = true;
            return this;
        }

        @Override
        public Verification withJWTId(String jwtId) {
            addCheck(RegisteredClaims.JWT_ID, ((claim, decodedJWT) ->
                    verifyNull(claim, jwtId) || jwtId.equals(claim.asString())));
            return this;
        }

        @Override
        public Verification withClaimPresence(String name) throws IllegalArgumentException {
            assertNonNull(name);
            //since addCheck already checks presence, we just return true
            withClaim(name, ((claim, decodedJWT) -> true));
            return this;
        }

        @Override
        public Verification withNullClaim(String name) throws IllegalArgumentException {
            assertNonNull(name);
            withClaim(name, ((claim, decodedJWT) -> claim.isNull()));
            return this;
        }

        @Override
        public Verification withClaim(String name, Boolean value) throws IllegalArgumentException {
            assertNonNull(name);
            addCheck(name, ((claim, decodedJWT) -> verifyNull(claim, value)
                    || value.equals(claim.asBoolean())));
            return this;
        }

        @Override
        public Verification withClaim(String name, Integer value) throws IllegalArgumentException {
            assertNonNull(name);
            addCheck(name, ((claim, decodedJWT) -> verifyNull(claim, value)
                    || value.equals(claim.asInt())));
            return this;
        }

        @Override
        public Verification withClaim(String name, Long value) throws IllegalArgumentException {
            assertNonNull(name);
            addCheck(name, ((claim, decodedJWT) -> verifyNull(claim, value)
                    || value.equals(claim.asLong())));
            return this;
        }

        @Override
        public Verification withClaim(String name, Double value) throws IllegalArgumentException {
            assertNonNull(name);
            addCheck(name, ((claim, decodedJWT) -> verifyNull(claim, value)
                    || value.equals(claim.asDouble())));
            return this;
        }

        @Override
        public Verification withClaim(String name, String value) throws IllegalArgumentException {
            assertNonNull(name);
            addCheck(name, ((claim, decodedJWT) -> verifyNull(claim, value)
                    || value.equals(claim.asString())));
            return this;
        }

        @Override
        public Verification withClaim(String name, Date value) throws IllegalArgumentException {
            return withClaim(name, value != null ? value.toInstant() : null);
        }

        @Override
        public Verification withClaim(String name, Instant value) throws IllegalArgumentException {
            assertNonNull(name);
            // Since date-time claims are serialized as epoch seconds,
            // we need to compare them with only seconds-granularity
            addCheck(name,
                    ((claim, decodedJWT) -> verifyNull(claim, value)
                            || value.truncatedTo(ChronoUnit.SECONDS).equals(claim.asInstant())));
            return this;
        }

        @Override
        public Verification withClaim(String name, BiPredicate<Claim, DecodedJWT> predicate)
                throws IllegalArgumentException {
            assertNonNull(name);
            addCheck(name, ((claim, decodedJWT) -> verifyNull(claim, predicate)
                    || predicate.test(claim, decodedJWT)));
            return this;
        }

        @Override
        public Verification withArrayClaim(String name, String... items) throws IllegalArgumentException {
            assertNonNull(name);
            addCheck(name, ((claim, decodedJWT) -> verifyNull(claim, items)
                    || assertValidCollectionClaim(claim, items)));
            return this;
        }

        @Override
        public Verification withArrayClaim(String name, Integer... items) throws IllegalArgumentException {
            assertNonNull(name);
            addCheck(name, ((claim, decodedJWT) -> verifyNull(claim, items)
                    || assertValidCollectionClaim(claim, items)));
            return this;
        }

        @Override
        public Verification withArrayClaim(String name, Long... items) throws IllegalArgumentException {
            assertNonNull(name);
            addCheck(name, ((claim, decodedJWT) -> verifyNull(claim, items)
                    || assertValidCollectionClaim(claim, items)));
            return this;
        }

        @Override
        public JWTVerifier build() {
            return this.build(Clock.systemUTC());
        }

        /**
         * Creates a new and reusable instance of the JWTVerifier with the configuration already provided.
         * ONLY FOR TEST PURPOSES.
         *
         * @param clock the instance that will handle the current time.
         * @return a new JWTVerifier instance with a custom {@link java.time.Clock}
         */
        public JWTVerifier build(Clock clock) {
            this.clock = clock;
            addMandatoryClaimChecks();
            return new JWTVerifier(algorithm, expectedChecks);
        }

        /**
         * Fetches the Leeway set for claim or returns the {@link BaseVerification#defaultLeeway}.
         *
         * @param name Claim for which leeway is fetched
         * @return Leeway value set for the claim
         */
        public long getLeewayFor(String name) {
            return customLeeways.getOrDefault(name, defaultLeeway);
        }

        private void addMandatoryClaimChecks() {
            long expiresAtLeeway = getLeewayFor(RegisteredClaims.EXPIRES_AT);
            long notBeforeLeeway = getLeewayFor(RegisteredClaims.NOT_BEFORE);
            long issuedAtLeeway = getLeewayFor(RegisteredClaims.ISSUED_AT);

            expectedChecks.add(constructExpectedCheck(RegisteredClaims.EXPIRES_AT, (claim, decodedJWT) ->
                    assertValidInstantClaim(RegisteredClaims.EXPIRES_AT, claim, expiresAtLeeway, true)));
            expectedChecks.add(constructExpectedCheck(RegisteredClaims.NOT_BEFORE, (claim, decodedJWT) ->
                    assertValidInstantClaim(RegisteredClaims.NOT_BEFORE, claim, notBeforeLeeway, false)));
            if (!ignoreIssuedAt) {
                expectedChecks.add(constructExpectedCheck(RegisteredClaims.ISSUED_AT, (claim, decodedJWT) ->
                        assertValidInstantClaim(RegisteredClaims.ISSUED_AT, claim, issuedAtLeeway, false)));
            }
        }

        private boolean assertValidCollectionClaim(Claim claim, Object[] expectedClaimValue) {
            List<Object> claimArr;
            Object[] claimAsObject = claim.as(Object[].class);

            // Jackson uses 'natural' mapping which uses Integer if value fits in 32 bits.
            if (expectedClaimValue instanceof Long[]) {
                // convert Integers to Longs for comparison with equals
                claimArr = new ArrayList<>(claimAsObject.length);
                for (Object cao : claimAsObject) {
                    if (cao instanceof Integer) {
                        claimArr.add(((Integer) cao).longValue());
                    } else {
                        claimArr.add(cao);
                    }
                }
            } else {
                claimArr = Arrays.asList(claim.as(Object[].class));
            }
            List<Object> valueArr = Arrays.asList(expectedClaimValue);
            return claimArr.containsAll(valueArr);
        }

        private boolean assertValidInstantClaim(String claimName, Claim claim, long leeway, boolean shouldBeFuture) {
            Instant claimVal = claim.asInstant();
            Instant now = clock.instant().truncatedTo(ChronoUnit.SECONDS);
            boolean isValid;
            if (shouldBeFuture) {
                isValid = assertInstantIsFuture(claimVal, leeway, now);
                if (!isValid) {
                    throw new TokenExpiredException(String.format("The Token has expired on %s.", claimVal), claimVal);
                }
            } else {
                isValid = assertInstantIsLessThanOrEqualToNow(claimVal, leeway, now);
                if (!isValid) {
                    throw new IncorrectClaimException(
                            String.format("The Token can't be used before %s.", claimVal), claimName, claim);
                }
            }
            return true;
        }

        private boolean assertInstantIsFuture(Instant claimVal, long leeway, Instant now) {
            return claimVal == null || now.minus(Duration.ofSeconds(leeway)).isBefore(claimVal);
        }

        private boolean assertInstantIsLessThanOrEqualToNow(Instant claimVal, long leeway, Instant now) {
            return !(claimVal != null && now.plus(Duration.ofSeconds(leeway)).isBefore(claimVal));
        }

        private boolean assertValidAudienceClaim(
                List<String> audience,
                List<String> values,
                boolean shouldContainAll
        ) {
            return !(audience == null || (shouldContainAll && !audience.containsAll(values))
                    || (!shouldContainAll && Collections.disjoint(audience, values)));
        }

        private void assertPositive(long leeway) {
            if (leeway < 0) {
                throw new IllegalArgumentException("Leeway value can't be negative.");
            }
        }

        private void assertNonNull(String name) {
            if (name == null) {
                throw new IllegalArgumentException("The Custom Claim's name can't be null.");
            }
        }

        private void addCheck(String name, BiPredicate<Claim, DecodedJWT> predicate) {
            expectedChecks.add(constructExpectedCheck(name, (claim, decodedJWT) -> {
                if (claim.isMissing()) {
                    throw new MissingClaimException(name);
                }
                return predicate.test(claim, decodedJWT);
            }));
        }

        private ExpectedCheckHolder constructExpectedCheck(String claimName, BiPredicate<Claim, DecodedJWT> check) {
            return new ExpectedCheckHolder() {
                @Override
                public String getClaimName() {
                    return claimName;
                }

                @Override
                public boolean verify(Claim claim, DecodedJWT decodedJWT) {
                    return check.test(claim, decodedJWT);
                }
            };
        }

        private boolean verifyNull(Claim claim, Object value) {
            return value == null && claim.isNull();
        }

        private boolean isNullOrEmpty(String[] args) {
            if (args == null || args.length == 0) {
                return true;
            }
            boolean isAllNull = true;
            for (String arg : args) {
                if (arg != null) {
                    isAllNull = false;
                    break;
                }
            }
            return isAllNull;
        }
    }


    /**
     * Perform the verification against the given Token, using any previous configured options.
     *
     * @param token to verify.
     * @return a verified and decoded JWT.
     * @throws AlgorithmMismatchException     if the algorithm stated in the token's header is not equal to
     *                                        the one defined in the {@link JWTVerifier}.
     * @throws SignatureVerificationException if the signature is invalid.
     * @throws TokenExpiredException          if the token has expired.
     * @throws MissingClaimException          if a claim to be verified is missing.
     * @throws IncorrectClaimException        if a claim contained a different value than the expected one.
     */
    @Override
    public DecodedJWT verify(String token) throws JWTVerificationException {
        DecodedJWT jwt = new JWTDecoder(parser, token);
        return verify(jwt);
    }

    /**
     * Perform the verification against the given decoded JWT, using any previous configured options.
     *
     * @param jwt to verify.
     * @return a verified and decoded JWT.
     * @throws AlgorithmMismatchException     if the algorithm stated in the token's header is not equal to
     *                                        the one defined in the {@link JWTVerifier}.
     * @throws SignatureVerificationException if the signature is invalid.
     * @throws TokenExpiredException          if the token has expired.
     * @throws MissingClaimException          if a claim to be verified is missing.
     * @throws IncorrectClaimException        if a claim contained a different value than the expected one.
     */
    @Override
    public DecodedJWT verify(DecodedJWT jwt) throws JWTVerificationException {
        verifyAlgorithm(jwt, algorithm);
        algorithm.verify(jwt);
        verifyClaims(jwt, expectedChecks);
        return jwt;
    }

    private void verifyAlgorithm(DecodedJWT jwt, Algorithm expectedAlgorithm) throws AlgorithmMismatchException {
        if (!expectedAlgorithm.getName().equals(jwt.getAlgorithm())) {
            throw new AlgorithmMismatchException(
                    "The provided Algorithm doesn't match the one defined in the JWT's Header.");
        }
    }

    private void verifyClaims(DecodedJWT jwt, List<ExpectedCheckHolder> expectedChecks)
            throws TokenExpiredException, InvalidClaimException {
        for (ExpectedCheckHolder expectedCheck : expectedChecks) {
            boolean isValid;
            String claimName = expectedCheck.getClaimName();
            Claim claim = jwt.getClaim(claimName);

            isValid = expectedCheck.verify(claim, jwt);

            if (!isValid) {
                throw new IncorrectClaimException(
                        String.format("The Claim '%s' value doesn't match the required one.", claimName),
                        claimName,
                        claim
                );
            }
        }
    }
}
