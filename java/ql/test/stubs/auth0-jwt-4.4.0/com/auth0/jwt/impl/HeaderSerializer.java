package com.auth0.jwt.impl;

/**
 * Responsible for serializing a JWT's header representation to JSON.
 */
public class HeaderSerializer extends ClaimsSerializer<HeaderClaimsHolder> {
    public HeaderSerializer() {
        super(HeaderClaimsHolder.class);
    }
}
