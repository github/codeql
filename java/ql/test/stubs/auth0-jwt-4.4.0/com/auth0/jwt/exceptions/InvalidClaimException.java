package com.auth0.jwt.exceptions;

/**
 * The exception that will be thrown while verifying Claims of a JWT.
 */
public class InvalidClaimException extends JWTVerificationException {
    public InvalidClaimException(String message) {
        super(message);
    }
}