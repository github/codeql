package com.auth0.jwt.exceptions;

/**
 * The exception that is thrown when a JWT cannot be created.
 */
public class JWTCreationException extends RuntimeException {
    public JWTCreationException(String message, Throwable cause) {
        super(message, cause);
    }
}
