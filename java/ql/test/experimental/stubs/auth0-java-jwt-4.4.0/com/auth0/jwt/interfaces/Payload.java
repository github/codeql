// Generated automatically from com.auth0.jwt.interfaces.Payload for testing purposes

package com.auth0.jwt.interfaces;

import com.auth0.jwt.interfaces.Claim;
import java.time.Instant;
import java.util.Date;
import java.util.List;
import java.util.Map;

public interface Payload
{
    Claim getClaim(String p0);
    Date getExpiresAt();
    Date getIssuedAt();
    Date getNotBefore();
    List<String> getAudience();
    Map<String, Claim> getClaims();
    String getId();
    String getIssuer();
    String getSubject();
    default Instant getExpiresAtAsInstant(){ return null; }
    default Instant getIssuedAtAsInstant(){ return null; }
    default Instant getNotBeforeAsInstant(){ return null; }
}
