package com.auth0.jwt;

import com.auth0.jwt.exceptions.JWTDecodeException;

abstract class TokenUtils {

    /**
     * Splits the given token on the "." chars into a String array with 3 parts.
     *
     * @param token the string to split.
     * @return the array representing the 3 parts of the token.
     * @throws JWTDecodeException if the Token doesn't have 3 parts.
     */
    static String[] splitToken(String token) throws JWTDecodeException {
        if (token == null) {
            throw new JWTDecodeException("The token is null.");
        }

        char delimiter = '.';

        int firstPeriodIndex = token.indexOf(delimiter);
        if (firstPeriodIndex == -1) {
            throw wrongNumberOfParts(0);
        }

        int secondPeriodIndex = token.indexOf(delimiter, firstPeriodIndex + 1);
        if (secondPeriodIndex == -1) {
            throw wrongNumberOfParts(2);
        }

        // too many ?
        if (token.indexOf(delimiter, secondPeriodIndex + 1) != -1) {
            throw wrongNumberOfParts("> 3");
        }

        String[] parts = new String[3];
        parts[0] = token.substring(0, firstPeriodIndex);
        parts[1] = token.substring(firstPeriodIndex + 1, secondPeriodIndex);
        parts[2] = token.substring(secondPeriodIndex + 1);

        return parts;
    }

    private static JWTDecodeException wrongNumberOfParts(Object partCount) {
        return new JWTDecodeException(String.format("The token was expected to have 3 parts, but got %s.", partCount));
    }
}
