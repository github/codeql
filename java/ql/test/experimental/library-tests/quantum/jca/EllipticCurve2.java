package com.example.crypto.algorithms;

//import org.bouncycastle.jce.provider.BouncyCastleProvider;
import java.security.*;
import java.security.spec.ECGenParameterSpec;
import java.util.Arrays;
import java.util.Base64;
import javax.crypto.Cipher;
import javax.crypto.KeyAgreement;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;

/**
 * EllipticCurve2 demonstrates real-world uses of elliptic curve algorithms,
 * including key pair generation, key agreement (ECDH), digital signatures
 * (ECDSA, EdDSA), and a simple simulation of ECIES (using ECDH + AES-GCM).
 *
 * Curve types shown include: - NIST (e.g., secp256r1) - SEC (e.g., secp256k1) -
 * Brainpool (e.g., brainpoolP256r1) - CURVE25519 (for X25519 key agreement) -
 * ES (e.g., Ed25519 for signatures) - Other fallback (e.g., secp256r1 for
 * "OtherEllipticCurveType")
 *
 * Best practices: - Use ephemeral keys and a strong RNG. - Use proper key
 * agreement (with a KDF if needed) and digital signature schemes. - Avoid
 * static key reuse or using weak curves.
 *
 * SAST/CBOM considerations: - Secure implementations use ephemeral keys and
 * modern curves. - Insecure practices (e.g., static keys or reusing keys) must
 * be flagged.
 */
public class EllipticCurve2 {

    // static {
    //     // Register BouncyCastle provider for additional curves and algorithms.
    //     Security.addProvider(new BouncyCastleProvider());
    // }
    // ----------------------------
    // 1. Key Pair Generation Examples
    // ----------------------------
    /**
     * Generates a key pair using a NIST curve (secp256r1).
     */
    public KeyPair generateNISTKeyPair() throws Exception {
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("EC", "BC");
        kpg.initialize(new ECGenParameterSpec("secp256r1"), new SecureRandom());
        return kpg.generateKeyPair();
    }

    /**
     * Generates a key pair using a SEC curve (secp256k1).
     */
    public KeyPair generateSECCurveKeyPair() throws Exception {
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("EC", "BC");
        kpg.initialize(new ECGenParameterSpec("secp256k1"), new SecureRandom());
        return kpg.generateKeyPair();
    }

    /**
     * Generates a key pair using a Brainpool curve (brainpoolP256r1).
     */
    public KeyPair generateBrainpoolKeyPair() throws Exception {
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("EC", "BC");
        kpg.initialize(new ECGenParameterSpec("brainpoolP256r1"), new SecureRandom());
        return kpg.generateKeyPair();
    }

    /**
     * Generates an X25519 key pair.
     */
    public KeyPair generateX25519KeyPair() throws Exception {
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("X25519", "BC");
        return kpg.generateKeyPair();
    }

    /**
     * Generates an Ed25519 key pair (used for signatures).
     */
    public KeyPair generateEd25519KeyPair() throws Exception {
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("Ed25519", "BC");
        return kpg.generateKeyPair();
    }

    /**
     * Generates a key pair for "OtherEllipticCurveType" as a fallback (using
     * secp256r1).
     */
    public KeyPair generateOtherEllipticCurveKeyPair() throws Exception {
        return generateNISTKeyPair();
    }

    // ----------------------------
    // 2. Key Agreement (ECDH) Examples
    // ----------------------------
    /**
     * Performs ECDH key agreement using two ephemeral NIST key pairs. Secure
     * Example: Uses ephemeral keys and a strong RNG.
     *
     * @return The shared secret.
     */
    public byte[] performECDHKeyAgreement() throws Exception {
        KeyPair aliceKP = generateNISTKeyPair();
        KeyPair bobKP = generateNISTKeyPair();

        KeyAgreement ka = KeyAgreement.getInstance("ECDH", "BC");
        ka.init(aliceKP.getPrivate());
        ka.doPhase(bobKP.getPublic(), true);
        return ka.generateSecret();
    }

    /**
     * Insecure ECDH Example: Uses a static key pair for both parties. SAST:
     * Reusing the same key pair eliminates forward secrecy and is insecure.
     *
     * @return The (insecure) shared secret.
     */
    public byte[] insecureECDHKeyAgreement() throws Exception {
        KeyPair staticKP = generateNISTKeyPair();
        KeyAgreement ka = KeyAgreement.getInstance("ECDH", "BC");
        ka.init(staticKP.getPrivate());
        ka.doPhase(staticKP.getPublic(), true);
        return ka.generateSecret();
    }

    // ----------------------------
    // 3. Digital Signature Examples
    // ----------------------------
    /**
     * Generates an ECDSA signature using a NIST key pair. Secure Example.
     *
     * @param message The message to sign.
     * @return The signature.
     */
    public byte[] generateECDSASignature(byte[] message) throws Exception {
        KeyPair kp = generateNISTKeyPair();
        Signature signature = Signature.getInstance("SHA256withECDSA", "BC");
        signature.initSign(kp.getPrivate());
        signature.update(message);
        return signature.sign();
    }

    /**
     * Verifies an ECDSA signature using the corresponding NIST key pair.
     *
     * @param message The original message.
     * @param signatureBytes The signature to verify.
     * @param kp The key pair used for signing.
     * @return True if the signature is valid.
     */
    public boolean verifyECDSASignature(byte[] message, byte[] signatureBytes, KeyPair kp) throws Exception {
        Signature signature = Signature.getInstance("SHA256withECDSA", "BC");
        signature.initVerify(kp.getPublic());
        signature.update(message);
        return signature.verify(signatureBytes);
    }

    /**
     * Generates an Ed25519 signature. Secure Example: Ed25519 is a modern,
     * high-performance signature scheme.
     *
     * @param message The message to sign.
     * @return The signature.
     */
    public byte[] generateEd25519Signature(byte[] message) throws Exception {
        KeyPair kp = generateEd25519KeyPair();
        Signature signature = Signature.getInstance("Ed25519", "BC");
        signature.initSign(kp.getPrivate());
        signature.update(message);
        return signature.sign();
    }

    /**
     * Verifies an Ed25519 signature.
     *
     * @param message The original message.
     * @param signatureBytes The signature to verify.
     * @param kp The key pair used for signing.
     * @return True if the signature is valid.
     */
    public boolean verifyEd25519Signature(byte[] message, byte[] signatureBytes, KeyPair kp) throws Exception {
        Signature signature = Signature.getInstance("Ed25519", "BC");
        signature.initVerify(kp.getPublic());
        signature.update(message);
        return signature.verify(signatureBytes);
    }

    // ----------------------------
    // 4. ECIES-like Encryption (ECDH + AES-GCM)
    // ----------------------------
    /**
     * A simple simulation of ECIES using ECDH for key agreement and AES-GCM for
     * encryption. Secure Example: Uses ephemeral ECDH key pairs, a KDF to
     * derive a symmetric key, and AES-GCM with a random nonce.
     *
     * @param plaintext The plaintext to encrypt.
     * @return The concatenation of the ephemeral public key, IV, and ciphertext
     * (Base64-encoded).
     * @throws Exception if encryption fails.
     */
    public String eciesEncryptionExample(byte[] plaintext) throws Exception {
        // Generate ephemeral key pairs for two parties.
        KeyPair senderKP = generateNISTKeyPair();
        KeyPair receiverKP = generateNISTKeyPair();

        // Perform ECDH key agreement.
        KeyAgreement ka = KeyAgreement.getInstance("ECDH", "BC");
        ka.init(senderKP.getPrivate());
        ka.doPhase(receiverKP.getPublic(), true);
        byte[] sharedSecret = ka.generateSecret();

        // Derive a symmetric key from the shared secret using SHA-256 (first 16 bytes
        // for AES-128).
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] derivedKey = digest.digest(sharedSecret);
        derivedKey = Arrays.copyOf(derivedKey, 16);
        SecretKey aesKey = new SecretKeySpec(derivedKey, "AES");

        // Encrypt plaintext using AES-GCM with a random nonce.
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        byte[] iv = new byte[12];
        new SecureRandom().nextBytes(iv);
        GCMParameterSpec spec = new GCMParameterSpec(128, iv);
        cipher.init(Cipher.ENCRYPT_MODE, aesKey, spec);
        byte[] ciphertext = cipher.doFinal(plaintext);

        // For ECIES, include the sender's ephemeral public key with the output.
        byte[] senderPub = senderKP.getPublic().getEncoded();
        byte[] output = concatenate(senderPub, concatenate(iv, ciphertext));

        return Base64.getEncoder().encodeToString(output);
    }

    // ----------------------------
    // 5. Main Method for Demonstration
    // ----------------------------
    public static void main(String[] args) {
        try {
            EllipticCurve2 test = new EllipticCurve2();

            // Key Agreement Example:
            byte[] sharedSecret = test.performECDHKeyAgreement();
            System.out.println("ECDH Shared Secret (Base64): " + Base64.getEncoder().encodeToString(sharedSecret));

            // ECDSA Signature Example:
            byte[] message = "Test message for ECDSA".getBytes();
            KeyPair nistKP = test.generateNISTKeyPair();
            byte[] ecdsaSig = test.generateECDSASignature(message);
            boolean validSig = test.verifyECDSASignature(message, ecdsaSig, nistKP);
            System.out.println("ECDSA Signature valid? " + validSig);

            // Ed25519 Signature Example:
            byte[] edSig = test.generateEd25519Signature(message);
            KeyPair edKP = test.generateEd25519KeyPair();
            boolean validEdSig = test.verifyEd25519Signature(message, edSig, edKP);
            System.out.println("Ed25519 Signature valid? " + validEdSig);

            // ECIES-like Encryption Example:
            String eciesOutput = test.eciesEncryptionExample("Secret ECIES Message".getBytes());
            System.out.println("ECIES-like Encrypted Output (Base64): " + eciesOutput);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private byte[] concatenate(byte[] a, byte[] b) {
        byte[] result = new byte[a.length + b.length];
        System.arraycopy(a, 0, result, 0, a.length);
        System.arraycopy(b, 0, result, a.length, b.length);
        return result;
    }
}
