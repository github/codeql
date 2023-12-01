package com.auth0.jwt.algorithms;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.nio.charset.StandardCharsets;
import java.security.*;

/**
 * Class used to perform the signature hash calculations.
 * <p>
 * This class is thread-safe.
 */
class CryptoHelper {

    private static final byte JWT_PART_SEPARATOR = (byte) 46;

    /**
     * Verify signature for JWT header and payload.
     *
     * @param algorithm      algorithm name.
     * @param secretBytes    algorithm secret.
     * @param header         JWT header.
     * @param payload        JWT payload.
     * @param signatureBytes JWT signature.
     * @return true if signature is valid.
     * @throws NoSuchAlgorithmException if the algorithm is not supported.
     * @throws InvalidKeyException      if the given key is inappropriate for initializing the specified algorithm.
     */

    boolean verifySignatureFor(
            String algorithm,
            byte[] secretBytes,
            String header,
            String payload,
            byte[] signatureBytes
    ) throws NoSuchAlgorithmException, InvalidKeyException {
        return verifySignatureFor(algorithm, secretBytes,
                header.getBytes(StandardCharsets.UTF_8), payload.getBytes(StandardCharsets.UTF_8), signatureBytes);
    }

    /**
     * Verify signature for JWT header and payload.
     *
     * @param algorithm      algorithm name.
     * @param secretBytes    algorithm secret.
     * @param headerBytes    JWT header.
     * @param payloadBytes   JWT payload.
     * @param signatureBytes JWT signature.
     * @return true if signature is valid.
     * @throws NoSuchAlgorithmException if the algorithm is not supported.
     * @throws InvalidKeyException      if the given key is inappropriate for initializing the specified algorithm.
     */

    boolean verifySignatureFor(
            String algorithm,
            byte[] secretBytes,
            byte[] headerBytes,
            byte[] payloadBytes,
            byte[] signatureBytes
    ) throws NoSuchAlgorithmException, InvalidKeyException {
        return MessageDigest.isEqual(createSignatureFor(algorithm, secretBytes, headerBytes, payloadBytes),
                signatureBytes);
    }

    /**
     * Verify signature for JWT header and payload.
     *
     * @param algorithm      algorithm name.
     * @param publicKey      algorithm public key.
     * @param header         JWT header.
     * @param payload        JWT payload.
     * @param signatureBytes JWT signature.
     * @return true if signature is valid.
     * @throws NoSuchAlgorithmException if the algorithm is not supported.
     * @throws InvalidKeyException      if the given key is inappropriate for initializing the specified algorithm.
     */
    boolean verifySignatureFor(
            String algorithm,
            PublicKey publicKey,
            String header,
            String payload,
            byte[] signatureBytes
    ) throws NoSuchAlgorithmException, InvalidKeyException, SignatureException {
        return verifySignatureFor(algorithm, publicKey, header.getBytes(StandardCharsets.UTF_8),
                payload.getBytes(StandardCharsets.UTF_8), signatureBytes);
    }

    /**
     * Verify signature for JWT header and payload using a public key.
     *
     * @param algorithm      algorithm name.
     * @param publicKey      the public key to use for verification.
     * @param headerBytes    JWT header.
     * @param payloadBytes   JWT payload.
     * @param signatureBytes JWT signature.
     * @return true if signature is valid.
     * @throws NoSuchAlgorithmException if the algorithm is not supported.
     * @throws InvalidKeyException      if the given key is inappropriate for initializing the specified algorithm.
     */
    boolean verifySignatureFor(
            String algorithm,
            PublicKey publicKey,
            byte[] headerBytes,
            byte[] payloadBytes,
            byte[] signatureBytes
    ) throws NoSuchAlgorithmException, InvalidKeyException, SignatureException {
        final Signature s = Signature.getInstance(algorithm);
        s.initVerify(publicKey);
        s.update(headerBytes);
        s.update(JWT_PART_SEPARATOR);
        s.update(payloadBytes);
        return s.verify(signatureBytes);
    }

    /**
     * Create signature for JWT header and payload using a private key.
     *
     * @param algorithm    algorithm name.
     * @param privateKey   the private key to use for signing.
     * @param headerBytes  JWT header.
     * @param payloadBytes JWT payload.
     * @return the signature bytes.
     * @throws NoSuchAlgorithmException if the algorithm is not supported.
     * @throws InvalidKeyException      if the given key is inappropriate for initializing the specified algorithm.
     * @throws SignatureException       if this signature object is not initialized properly
     *                                  or if this signature algorithm is unable to process the input data provided.
     */
    byte[] createSignatureFor(
            String algorithm,
            PrivateKey privateKey,
            byte[] headerBytes,
            byte[] payloadBytes
    ) throws NoSuchAlgorithmException, InvalidKeyException, SignatureException {
        final Signature s = Signature.getInstance(algorithm);
        s.initSign(privateKey);
        s.update(headerBytes);
        s.update(JWT_PART_SEPARATOR);
        s.update(payloadBytes);
        return s.sign();
    }

    /**
     * Create signature for JWT header and payload.
     *
     * @param algorithm    algorithm name.
     * @param secretBytes  algorithm secret.
     * @param headerBytes  JWT header.
     * @param payloadBytes JWT payload.
     * @return the signature bytes.
     * @throws NoSuchAlgorithmException if the algorithm is not supported.
     * @throws InvalidKeyException      if the given key is inappropriate for initializing the specified algorithm.
     */
    byte[] createSignatureFor(
            String algorithm,
            byte[] secretBytes,
            byte[] headerBytes,
            byte[] payloadBytes
    ) throws NoSuchAlgorithmException, InvalidKeyException {
        final Mac mac = Mac.getInstance(algorithm);
        mac.init(new SecretKeySpec(secretBytes, algorithm));
        mac.update(headerBytes);
        mac.update(JWT_PART_SEPARATOR);
        return mac.doFinal(payloadBytes);
    }

    /**
     * Create signature.
     * To get the correct JWT Signature, ensure the content is in the format {HEADER}.{PAYLOAD}
     *
     * @param algorithm    algorithm name.
     * @param secretBytes  algorithm secret.
     * @param contentBytes the content to be signed.
     * @return the signature bytes.
     * @throws NoSuchAlgorithmException if the algorithm is not supported.
     * @throws InvalidKeyException      if the given key is inappropriate for initializing the specified algorithm.
     */
    byte[] createSignatureFor(String algorithm, byte[] secretBytes, byte[] contentBytes)
            throws NoSuchAlgorithmException, InvalidKeyException {
        final Mac mac = Mac.getInstance(algorithm);
        mac.init(new SecretKeySpec(secretBytes, algorithm));
        return mac.doFinal(contentBytes);
    }

    /**
     * Create signature using a private key.
     * To get the correct JWT Signature, ensure the content is in the format {HEADER}.{PAYLOAD}
     *
     * @param algorithm    algorithm name.
     * @param privateKey   the private key to use for signing.
     * @param contentBytes the content to be signed.
     * @return the signature bytes.
     * @throws NoSuchAlgorithmException if the algorithm is not supported.
     * @throws InvalidKeyException      if the given key is inappropriate for initializing the specified algorithm.
     * @throws SignatureException       if this signature object is not initialized properly
     *                                  or if this signature algorithm is unable to process the input data provided.
     */

    byte[] createSignatureFor(
            String algorithm,
            PrivateKey privateKey,
            byte[] contentBytes
    ) throws NoSuchAlgorithmException, InvalidKeyException, SignatureException {
        final Signature s = Signature.getInstance(algorithm);
        s.initSign(privateKey);
        s.update(contentBytes);
        return s.sign();
    }
}
