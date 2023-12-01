package com.auth0.jwt.exceptions;

import com.auth0.jwt.interfaces.Claim;

/**
 * This exception is thrown when the expected value is not found while verifying the Claims.
 */
public class IncorrectClaimException extends InvalidClaimException {
    private final String claimName;

    private final Claim claimValue;

    /**
     * Used internally to construct the IncorrectClaimException which is thrown when there is verification
     * failure for a Claim that exists.
     *
     * @param message The error message
     * @param claimName The Claim name for which verification failed
     * @param claim The Claim value for which verification failed
     */
    public IncorrectClaimException(String message, String claimName, Claim claim) {
        super(message);
        this.claimName = claimName;
        this.claimValue = claim;
    }

    /**
     * This method can be used to fetch the name for which the Claim verification failed.
     *
     * @return The claim name for which the verification failed.
     */
    public String getClaimName() {
        return claimName;
    }

    /**
     * This method can be used to fetch the value for which the Claim verification failed.
     *
     * @return The value for which the verification failed
     */
    public Claim getClaimValue() {
        return claimValue;
    }
}