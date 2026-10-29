package com.auth0.jwt.exceptions;

import com.auth0.jwt.algorithms.Algorithm;

public class SignatureGenerationException extends RuntimeException {
    public SignatureGenerationException(Algorithm algorithm, Throwable cause) {
    }
}