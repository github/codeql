package com.auth0.jwt.impl;

import java.util.HashMap;
import java.util.Map;

/**
 * The ClaimsHolder class is just a wrapper for the Map of Claims used for building a JWT.
 */
public abstract class ClaimsHolder {
    private Map<String, Object> claims;

    protected ClaimsHolder(Map<String, Object> claims) {
        this.claims = claims == null ? new HashMap<>() : claims;
    }

    Map<String, Object> getClaims() {
        return claims;
    }
}
