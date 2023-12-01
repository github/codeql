package com.auth0.jwt.algorithms;

import com.auth0.jwt.exceptions.SignatureGenerationException;
import com.auth0.jwt.exceptions.SignatureVerificationException;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.auth0.jwt.interfaces.RSAKeyProvider;

import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.SignatureException;
import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;
import java.util.Base64;

/**
 * Subclass representing an RSA signing algorithm
 * <p>
 * This class is thread-safe.
 */
class RSAAlgorithm extends Algorithm {

    private final RSAKeyProvider keyProvider;
    private final CryptoHelper crypto;

    //Visible for testing
    RSAAlgorithm(CryptoHelper crypto, String id, String algorithm, RSAKeyProvider keyProvider)
            throws IllegalArgumentException {
        super(id, algorithm);
        if (keyProvider == null) {
            throw new IllegalArgumentException("The Key Provider cannot be null.");
        }
        this.keyProvider = keyProvider;
        this.crypto = crypto;
    }

    RSAAlgorithm(String id, String algorithm, RSAKeyProvider keyProvider) throws IllegalArgumentException {
        this(new CryptoHelper(), id, algorithm, keyProvider);
    }

    @Override
    public void verify(DecodedJWT jwt) throws SignatureVerificationException {
        try {
            byte[] signatureBytes = Base64.getUrlDecoder().decode(jwt.getSignature());
            RSAPublicKey publicKey = keyProvider.getPublicKeyById(jwt.getKeyId());
            if (publicKey == null) {
                throw new IllegalStateException("The given Public Key is null.");
            }
            boolean valid = crypto.verifySignatureFor(
                    getDescription(), publicKey, jwt.getHeader(), jwt.getPayload(), signatureBytes);
            if (!valid) {
                throw new SignatureVerificationException(this);
            }
        } catch (NoSuchAlgorithmException | SignatureException | InvalidKeyException
                | IllegalArgumentException | IllegalStateException e) {
            throw new SignatureVerificationException(this, e);
        }
    }

    @Override
    public byte[] sign(byte[] headerBytes, byte[] payloadBytes) throws SignatureGenerationException {
        try {
            RSAPrivateKey privateKey = keyProvider.getPrivateKey();
            if (privateKey == null) {
                throw new IllegalStateException("The given Private Key is null.");
            }
            return crypto.createSignatureFor(getDescription(), privateKey, headerBytes, payloadBytes);
        } catch (NoSuchAlgorithmException | SignatureException | InvalidKeyException | IllegalStateException e) {
            throw new SignatureGenerationException(this, e);
        }
    }

    @Override
    public byte[] sign(byte[] contentBytes) throws SignatureGenerationException {
        try {
            RSAPrivateKey privateKey = keyProvider.getPrivateKey();
            if (privateKey == null) {
                throw new IllegalStateException("The given Private Key is null.");
            }
            return crypto.createSignatureFor(getDescription(), privateKey, contentBytes);
        } catch (NoSuchAlgorithmException | SignatureException | InvalidKeyException | IllegalStateException e) {
            throw new SignatureGenerationException(this, e);
        }
    }

    @Override
    public String getSigningKeyId() {
        return keyProvider.getPrivateKeyId();
    }

    //Visible for testing
    static RSAKeyProvider providerForKeys(final RSAPublicKey publicKey, final RSAPrivateKey privateKey) {
        if (publicKey == null && privateKey == null) {
            throw new IllegalArgumentException("Both provided Keys cannot be null.");
        }
        return new RSAKeyProvider() {
            @Override
            public RSAPublicKey getPublicKeyById(String keyId) {
                return publicKey;
            }

            @Override
            public RSAPrivateKey getPrivateKey() {
                return privateKey;
            }

            @Override
            public String getPrivateKeyId() {
                return null;
            }
        };
    }
}
