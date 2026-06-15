// Generated automatically from com.auth0.jwt.interfaces.Header for testing purposes

package com.auth0.jwt.interfaces;

import com.auth0.jwt.interfaces.Claim;

public interface Header
{
    Claim getHeaderClaim(String p0);
    String getAlgorithm();
    String getContentType();
    String getKeyId();
    String getType();
}
