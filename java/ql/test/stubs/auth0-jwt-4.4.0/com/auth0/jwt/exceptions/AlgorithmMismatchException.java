package com.auth0.jwt.exceptions;

/**
 * The exception that will be thrown if the exception doesn't match the one mentioned in the JWT Header.
 */
public class AlgorithmMismatchException extends JWTVerificationException {
    public AlgorithmMismatchException(String message) {
        super(message);
    }
}
