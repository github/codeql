package com.auth0.jwt.impl;

import java.util.Map;

/**
 * Holds the payload claims when serializing a JWT.
 */
public final class PayloadClaimsHolder extends ClaimsHolder {
    public PayloadClaimsHolder(Map<String, Object> claims) {
        super(claims);
    }
}
