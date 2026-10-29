// Generated automatically from com.auth0.jwt.interfaces.Verification for testing purposes

package com.auth0.jwt.interfaces;

import com.auth0.jwt.interfaces.Claim;
import com.auth0.jwt.interfaces.DecodedJWT;
import java.time.Instant;
import java.util.Date;
import java.util.function.BiPredicate;

public interface Verification
{
    Verification acceptExpiresAt(long p0);
    Verification acceptIssuedAt(long p0);
    Verification acceptLeeway(long p0);
    Verification acceptNotBefore(long p0);
    Verification ignoreIssuedAt();
    Verification withAnyOfAudience(String... p0);
    Verification withArrayClaim(String p0, Integer... p1);
    Verification withArrayClaim(String p0, Long... p1);
    Verification withArrayClaim(String p0, String... p1);
    Verification withAudience(String... p0);
    Verification withClaim(String p0, BiPredicate<Claim, DecodedJWT> p1);
    Verification withClaim(String p0, Boolean p1);
    Verification withClaim(String p0, Date p1);
    Verification withClaim(String p0, Double p1);
    Verification withClaim(String p0, Integer p1);
    Verification withClaim(String p0, Long p1);
    Verification withClaim(String p0, String p1);
    Verification withClaimPresence(String p0);
    Verification withIssuer(String... p0);
    Verification withJWTId(String p0);
    Verification withNullClaim(String p0);
    Verification withSubject(String p0);
    com.auth0.jwt.JWTVerifier build();
    default Verification withClaim(String p0, Instant p1){ return null; }
    default Verification withIssuer(String p0){ return null; }
}
