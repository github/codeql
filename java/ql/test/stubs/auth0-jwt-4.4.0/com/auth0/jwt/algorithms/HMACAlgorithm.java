package com.auth0.jwt.algorithms;

import com.auth0.jwt.exceptions.SignatureGenerationException;
import com.auth0.jwt.exceptions.SignatureVerificationException;
import com.auth0.jwt.interfaces.DecodedJWT;

import java.nio.charset.StandardCharsets;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;
import java.util.Base64;

/**
 * Subclass representing an Hash-based MAC signing algorithm
 * <p>
 * This class is thread-safe.
 */
class HMACAlgorithm extends Algorithm {

    private final CryptoHelper crypto;
    private final byte[] secret;

    //Visible for testing
    HMACAlgorithm(CryptoHelper crypto, String id, String algorithm, byte[] secretBytes)
            throws IllegalArgumentException {
        super(id, algorithm);
        if (secretBytes == null) {
            throw new IllegalArgumentException("The Secret cannot be null");
        }
        this.secret = Arrays.copyOf(secretBytes, secretBytes.length);
        this.crypto = crypto;
    }

    HMACAlgorithm(String id, String algorithm, byte[] secretBytes) throws IllegalArgumentException {
        this(new CryptoHelper(), id, algorithm, secretBytes);
    }

    HMACAlgorithm(String id, String algorithm, String secret) throws IllegalArgumentException {
        this(new CryptoHelper(), id, algorithm, getSecretBytes(secret));
    }

    //Visible for testing
    static byte[] getSecretBytes(String secret) throws IllegalArgumentException {
        if (secret == null) {
            throw new IllegalArgumentException("The Secret cannot be null");
        }
        return secret.getBytes(StandardCharsets.UTF_8);
    }

    @Override
    public void verify(DecodedJWT jwt) throws SignatureVerificationException {
        try {
            byte[] signatureBytes = Base64.getUrlDecoder().decode(jwt.getSignature());
            boolean valid = crypto.verifySignatureFor(
                    getDescription(), secret, jwt.getHeader(), jwt.getPayload(), signatureBytes);
            if (!valid) {
                throw new SignatureVerificationException(this);
            }
        } catch (IllegalStateException | InvalidKeyException | NoSuchAlgorithmException | IllegalArgumentException e) {
            throw new SignatureVerificationException(this, e);
        }
    }

    @Override
    public byte[] sign(byte[] headerBytes, byte[] payloadBytes) throws SignatureGenerationException {
        try {
            return crypto.createSignatureFor(getDescription(), secret, headerBytes, payloadBytes);
        } catch (NoSuchAlgorithmException | InvalidKeyException e) {
            throw new SignatureGenerationException(this, e);
        }
    }

    @Override
    public byte[] sign(byte[] contentBytes) throws SignatureGenerationException {
        try {
            return crypto.createSignatureFor(getDescription(), secret, contentBytes);
        } catch (NoSuchAlgorithmException | InvalidKeyException e) {
            throw new SignatureGenerationException(this, e);
        }
    }
}
