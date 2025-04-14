// Generated automatically from com.auth0.jwt.JWTCreator for testing purposes

package com.auth0.jwt;

import com.auth0.jwt.algorithms.Algorithm;
import java.time.Instant;
import java.util.Date;
import java.util.List;
import java.util.Map;

public class JWTCreator
{
    protected JWTCreator() {}
    static public class Builder
    {
        public JWTCreator.Builder withArrayClaim(String p0, Integer[] p1){ return null; }
        public JWTCreator.Builder withArrayClaim(String p0, Long[] p1){ return null; }
        public JWTCreator.Builder withArrayClaim(String p0, String[] p1){ return null; }
        public JWTCreator.Builder withAudience(String... p0){ return null; }
        public JWTCreator.Builder withClaim(String p0, Boolean p1){ return null; }
        public JWTCreator.Builder withClaim(String p0, Date p1){ return null; }
        public JWTCreator.Builder withClaim(String p0, Double p1){ return null; }
        public JWTCreator.Builder withClaim(String p0, Instant p1){ return null; }
        public JWTCreator.Builder withClaim(String p0, Integer p1){ return null; }
        public JWTCreator.Builder withClaim(String p0, List<? extends Object> p1){ return null; }
        public JWTCreator.Builder withClaim(String p0, Long p1){ return null; }
        public JWTCreator.Builder withClaim(String p0, Map<String, ? extends Object> p1){ return null; }
        public JWTCreator.Builder withClaim(String p0, String p1){ return null; }
        public JWTCreator.Builder withExpiresAt(Date p0){ return null; }
        public JWTCreator.Builder withExpiresAt(Instant p0){ return null; }
        public JWTCreator.Builder withHeader(Map<String, Object> p0){ return null; }
        public JWTCreator.Builder withHeader(String p0){ return null; }
        public JWTCreator.Builder withIssuedAt(Date p0){ return null; }
        public JWTCreator.Builder withIssuedAt(Instant p0){ return null; }
        public JWTCreator.Builder withIssuer(String p0){ return null; }
        public JWTCreator.Builder withJWTId(String p0){ return null; }
        public JWTCreator.Builder withKeyId(String p0){ return null; }
        public JWTCreator.Builder withNotBefore(Date p0){ return null; }
        public JWTCreator.Builder withNotBefore(Instant p0){ return null; }
        public JWTCreator.Builder withNullClaim(String p0){ return null; }
        public JWTCreator.Builder withPayload(Map<String, ? extends Object> p0){ return null; }
        public JWTCreator.Builder withPayload(String p0){ return null; }
        public JWTCreator.Builder withSubject(String p0){ return null; }
        public String sign(Algorithm p0){ return null; }
    }
}
