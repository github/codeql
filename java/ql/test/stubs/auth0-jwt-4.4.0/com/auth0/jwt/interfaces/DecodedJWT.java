package com.auth0.jwt.interfaces;

/**
 * Class that represents a Json Web Token that was decoded from it's string representation.
 */
public interface DecodedJWT extends Payload, Header {
    /**
     * Getter for the String Token used to create this JWT instance.
     *
     * @return the String Token.
     */
    String getToken();

    /**
     * Getter for the Header contained in the JWT as a Base64 encoded String.
     * This represents the first part of the token.
     *
     * @return the Header of the JWT.
     */
    String getHeader();

    /**
     * Getter for the Payload contained in the JWT as a Base64 encoded String.
     * This represents the second part of the token.
     *
     * @return the Payload of the JWT.
     */
    String getPayload();

    /**
     * Getter for the Signature contained in the JWT as a Base64 encoded String.
     * This represents the third part of the token.
     *
     * @return the Signature of the JWT.
     */
    String getSignature();
}
