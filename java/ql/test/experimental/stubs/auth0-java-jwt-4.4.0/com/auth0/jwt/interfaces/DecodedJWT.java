// Generated automatically from com.auth0.jwt.interfaces.DecodedJWT for testing purposes

package com.auth0.jwt.interfaces;

import com.auth0.jwt.interfaces.Header;
import com.auth0.jwt.interfaces.Payload;

public interface DecodedJWT extends Header, Payload
{
    String getHeader();
    String getPayload();
    String getSignature();
    String getToken();
}
