package com.auth0.jwt.exceptions;

/**
 * The exception that is thrown when any part of the token contained an invalid JWT or JSON format.
 */
public class JWTDecodeException extends JWTVerificationException {
    public JWTDecodeException(String message) {
        this(message, null);
    }

    public JWTDecodeException(String message, Throwable cause) {
        super(message, cause);
    }
}
