
   
package com.auth0.jwt.exceptions;

import com.auth0.jwt.algorithms.Algorithm;

public class SignatureVerificationException extends RuntimeException {
    public SignatureVerificationException(Algorithm algorithm) {
    }

    public SignatureVerificationException(Algorithm algorithm, Throwable cause) {
    }
}