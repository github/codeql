package com.auth0.jwt.algorithms;

import com.auth0.jwt.exceptions.SignatureGenerationException;
import com.auth0.jwt.exceptions.SignatureVerificationException;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.auth0.jwt.interfaces.ECDSAKeyProvider;

import java.math.BigInteger;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.security.SignatureException;
import java.security.interfaces.ECPrivateKey;
import java.security.interfaces.ECPublicKey;
import java.util.Base64;

/**
 * Subclass representing an Elliptic Curve signing algorithm
 * <p>
 * This class is thread-safe.
 */
class ECDSAAlgorithm extends Algorithm {

    private final ECDSAKeyProvider keyProvider;
    private final CryptoHelper crypto;
    private final int ecNumberSize;

    //Visible for testing
    ECDSAAlgorithm(CryptoHelper crypto, String id, String algorithm, int ecNumberSize, ECDSAKeyProvider keyProvider)
            throws IllegalArgumentException {
        super(id, algorithm);
        if (keyProvider == null) {
            throw new IllegalArgumentException("The Key Provider cannot be null.");
        }
        this.keyProvider = keyProvider;
        this.crypto = crypto;
        this.ecNumberSize = ecNumberSize;
    }

    ECDSAAlgorithm(String id, String algorithm, int ecNumberSize, ECDSAKeyProvider keyProvider)
            throws IllegalArgumentException {
        this(new CryptoHelper(), id, algorithm, ecNumberSize, keyProvider);
    }

    @Override
    public void verify(DecodedJWT jwt) throws SignatureVerificationException {
        try {
            byte[] signatureBytes = Base64.getUrlDecoder().decode(jwt.getSignature());
            ECPublicKey publicKey = keyProvider.getPublicKeyById(jwt.getKeyId());
            if (publicKey == null) {
                throw new IllegalStateException("The given Public Key is null.");
            }
            validateSignatureStructure(signatureBytes, publicKey);
            boolean valid = crypto.verifySignatureFor(
                    getDescription(), publicKey, jwt.getHeader(), jwt.getPayload(), JOSEToDER(signatureBytes));

            if (!valid) {
                throw new SignatureVerificationException(this);
            }
        } catch (NoSuchAlgorithmException | SignatureException | InvalidKeyException
                | IllegalStateException | IllegalArgumentException e) {
            throw new SignatureVerificationException(this, e);
        }
    }

    @Override
    public byte[] sign(byte[] headerBytes, byte[] payloadBytes) throws SignatureGenerationException {
        try {
            ECPrivateKey privateKey = keyProvider.getPrivateKey();
            if (privateKey == null) {
                throw new IllegalStateException("The given Private Key is null.");
            }
            byte[] signature = crypto.createSignatureFor(getDescription(), privateKey, headerBytes, payloadBytes);
            return DERToJOSE(signature);
        } catch (NoSuchAlgorithmException | SignatureException | InvalidKeyException | IllegalStateException e) {
            throw new SignatureGenerationException(this, e);
        }
    }

    @Override
    public byte[] sign(byte[] contentBytes) throws SignatureGenerationException {
        try {
            ECPrivateKey privateKey = keyProvider.getPrivateKey();
            if (privateKey == null) {
                throw new IllegalStateException("The given Private Key is null.");
            }
            byte[] signature = crypto.createSignatureFor(getDescription(), privateKey, contentBytes);
            return DERToJOSE(signature);
        } catch (NoSuchAlgorithmException | SignatureException | InvalidKeyException | IllegalStateException e) {
            throw new SignatureGenerationException(this, e);
        }
    }

    @Override
    public String getSigningKeyId() {
        return keyProvider.getPrivateKeyId();
    }

    //Visible for testing
    byte[] DERToJOSE(byte[] derSignature) throws SignatureException {
        // DER Structure: http://crypto.stackexchange.com/a/1797
        boolean derEncoded = derSignature[0] == 0x30 && derSignature.length != ecNumberSize * 2;
        if (!derEncoded) {
            throw new SignatureException("Invalid DER signature format.");
        }

        final byte[] joseSignature = new byte[ecNumberSize * 2];

        //Skip 0x30
        int offset = 1;
        if (derSignature[1] == (byte) 0x81) {
            //Skip sign
            offset++;
        }

        //Convert to unsigned. Should match DER length - offset
        int encodedLength = derSignature[offset++] & 0xff;
        if (encodedLength != derSignature.length - offset) {
            throw new SignatureException("Invalid DER signature format.");
        }

        //Skip 0x02
        offset++;

        //Obtain R number length (Includes padding) and skip it
        int rlength = derSignature[offset++];
        if (rlength > ecNumberSize + 1) {
            throw new SignatureException("Invalid DER signature format.");
        }
        int rpadding = ecNumberSize - rlength;
        //Retrieve R number
        System.arraycopy(derSignature, offset + Math.max(-rpadding, 0),
                joseSignature, Math.max(rpadding, 0), rlength + Math.min(rpadding, 0));

        //Skip R number and 0x02
        offset += rlength + 1;

        //Obtain S number length. (Includes padding)
        int slength = derSignature[offset++];
        if (slength > ecNumberSize + 1) {
            throw new SignatureException("Invalid DER signature format.");
        }
        int spadding = ecNumberSize - slength;
        //Retrieve R number
        System.arraycopy(derSignature, offset + Math.max(-spadding, 0), joseSignature,
                ecNumberSize + Math.max(spadding, 0), slength + Math.min(spadding, 0));

        return joseSignature;
    }

    /**
     * Added check for extra protection against CVE-2022-21449.
     * This method ensures the signature's structure is as expected.
     *
     * @param joseSignature is the signature from the JWT
     * @param publicKey     public key used to verify the JWT
     * @throws SignatureException if the signature's structure is not as per expectation
     */
    // Visible for testing
    void validateSignatureStructure(byte[] joseSignature, ECPublicKey publicKey) throws SignatureException {
        // check signature length, moved this check from JOSEToDER method
        if (joseSignature.length != ecNumberSize * 2) {
            throw new SignatureException("Invalid JOSE signature format.");
        }

        if (isAllZeros(joseSignature)) {
            throw new SignatureException("Invalid signature format.");
        }

        // get R
        byte[] rBytes = new byte[ecNumberSize];
        System.arraycopy(joseSignature, 0, rBytes, 0, ecNumberSize);
        if (isAllZeros(rBytes)) {
            throw new SignatureException("Invalid signature format.");
        }

        // get S
        byte[] sBytes = new byte[ecNumberSize];
        System.arraycopy(joseSignature, ecNumberSize, sBytes, 0, ecNumberSize);
        if (isAllZeros(sBytes)) {
            throw new SignatureException("Invalid signature format.");
        }

        //moved this check from JOSEToDER method
        int rPadding = countPadding(joseSignature, 0, ecNumberSize);
        int sPadding = countPadding(joseSignature, ecNumberSize, joseSignature.length);
        int rLength = ecNumberSize - rPadding;
        int sLength = ecNumberSize - sPadding;

        int length = 2 + rLength + 2 + sLength;
        if (length > 255) {
            throw new SignatureException("Invalid JOSE signature format.");
        }

        BigInteger order = publicKey.getParams().getOrder();
        BigInteger r = new BigInteger(1, rBytes);
        BigInteger s = new BigInteger(1, sBytes);

        // R and S must be less than N
        if (order.compareTo(r) < 1) {
            throw new SignatureException("Invalid signature format.");
        }

        if (order.compareTo(s) < 1) {
            throw new SignatureException("Invalid signature format.");
        }
    }

    //Visible for testing
    byte[] JOSEToDER(byte[] joseSignature) throws SignatureException {
        // Retrieve R and S number's length and padding.
        int rPadding = countPadding(joseSignature, 0, ecNumberSize);
        int sPadding = countPadding(joseSignature, ecNumberSize, joseSignature.length);
        int rLength = ecNumberSize - rPadding;
        int sLength = ecNumberSize - sPadding;

        int length = 2 + rLength + 2 + sLength;

        final byte[] derSignature;
        int offset;
        if (length > 0x7f) {
            derSignature = new byte[3 + length];
            derSignature[1] = (byte) 0x81;
            offset = 2;
        } else {
            derSignature = new byte[2 + length];
            offset = 1;
        }

        // DER Structure: http://crypto.stackexchange.com/a/1797
        // Header with signature length info
        derSignature[0] = (byte) 0x30;
        derSignature[offset++] = (byte) (length & 0xff);

        // Header with "min R" number length
        derSignature[offset++] = (byte) 0x02;
        derSignature[offset++] = (byte) rLength;

        // R number
        if (rPadding < 0) {
            //Sign
            derSignature[offset++] = (byte) 0x00;
            System.arraycopy(joseSignature, 0, derSignature, offset, ecNumberSize);
            offset += ecNumberSize;
        } else {
            int copyLength = Math.min(ecNumberSize, rLength);
            System.arraycopy(joseSignature, rPadding, derSignature, offset, copyLength);
            offset += copyLength;
        }

        // Header with "min S" number length
        derSignature[offset++] = (byte) 0x02;
        derSignature[offset++] = (byte) sLength;

        // S number
        if (sPadding < 0) {
            //Sign
            derSignature[offset++] = (byte) 0x00;
            System.arraycopy(joseSignature, ecNumberSize, derSignature, offset, ecNumberSize);
        } else {
            System.arraycopy(joseSignature, ecNumberSize + sPadding, derSignature, offset,
                    Math.min(ecNumberSize, sLength));
        }

        return derSignature;
    }

    private boolean isAllZeros(byte[] bytes) {
        for (byte b : bytes) {
            if (b != 0) {
                return false;
            }
        }
        return true;
    }

    private int countPadding(byte[] bytes, int fromIndex, int toIndex) {
        int padding = 0;
        while (fromIndex + padding < toIndex && bytes[fromIndex + padding] == 0) {
            padding++;
        }
        return (bytes[fromIndex + padding] & 0xff) > 0x7f ? padding - 1 : padding;
    }

    //Visible for testing
    static ECDSAKeyProvider providerForKeys(final ECPublicKey publicKey, final ECPrivateKey privateKey) {
        if (publicKey == null && privateKey == null) {
            throw new IllegalArgumentException("Both provided Keys cannot be null.");
        }
        return new ECDSAKeyProvider() {
            @Override
            public ECPublicKey getPublicKeyById(String keyId) {
                return publicKey;
            }

            @Override
            public ECPrivateKey getPrivateKey() {
                return privateKey;
            }

            @Override
            public String getPrivateKeyId() {
                return null;
            }
        };
    }
}
