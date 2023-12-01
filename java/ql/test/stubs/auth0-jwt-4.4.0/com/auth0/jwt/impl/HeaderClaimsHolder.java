package com.auth0.jwt.impl;

import java.util.Map;

/**
 * Holds the header claims when serializing a JWT.
 */
public final class HeaderClaimsHolder extends ClaimsHolder {
    public HeaderClaimsHolder(Map<String, Object> claims) {
        super(claims);
    }
}
