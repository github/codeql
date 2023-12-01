package com.auth0.jwt.exceptions;

import com.auth0.jwt.algorithms.Algorithm;

/**
 * The exception that is thrown when signature is not able to be generated.
 */
public class SignatureGenerationException extends JWTCreationException {
    public SignatureGenerationException(Algorithm algorithm, Throwable cause) {
        super("The Token's Signature couldn't be generated when signing using the Algorithm: " + algorithm, cause);
    }
}
