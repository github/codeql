package com.example.crypto.artifacts;

// import org.bouncycastle.jce.provider.BouncyCastleProvider;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Arrays;
import java.util.Base64;
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.Mac;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;

/**
 * DigestTestCase demonstrates the further use of cryptographic digests
 * as inputs to more complex cryptosystems. In real-world applications,
 * digest outputs are often used as keys, key material for key derivation,
 * or as identifiers. This file shows several flows:
 *
 * 1. Basic digest generation using SHA-256 (secure) and MD5/SHA-1 (insecure).
 * 2. Unsalted versus salted digest for password input.
 * 3. PBKDF2 for secure key derivation.
 * 4. Using a digest as direct key material for AES encryption (processDigest).
 * 5. Using a digest as an identifier (alternativeDigestFlow).
 * 6. **Further Use**: Deriving two separate keys (one for encryption and one
 * for MAC)
 * from a digest via PBKDF2 and using them in an authenticated encryption flow.
 *
 * SAST/CBOM notes:
 * - Secure algorithms (e.g. SHA-256, HMAC-SHA256, PBKDF2WithHmacSHA256) are
 * acceptable.
 * - Insecure functions (e.g. MD5, SHA-1) and unsalted password digests are
 * flagged.
 * - Using a raw digest directly as key material is ambiguous unless produced by
 * a proper KDF.
 */
public class Digest {

    // static {
    //     Security.addProvider(new BouncyCastleProvider());
    // }

    // ---------- Digest Generation Flows ----------

    /**
     * Secure digest generation using SHA-256.
     * SAST: SHA-256 is secure.
     */
    public void simpleHashing() throws Exception {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hash = digest.digest("Simple Test Data".getBytes());
        processDigest(hash);
    }

    /**
     * Insecure digest generation using MD5.
     * SAST: MD5 is deprecated and insecure.
     */
    public void insecureMD5Hashing() throws Exception {
        MessageDigest md5Digest = MessageDigest.getInstance("MD5");
        byte[] hash = md5Digest.digest("Weak Hash Example".getBytes());
        processDigest(hash);
    }

    /**
     * Insecure unsalted password hashing using SHA-256.
     * SAST: Unsalted password hashing is vulnerable to rainbow table attacks.
     */
    public void insecureUnsaltedPasswordHashing(String password) throws Exception {
        MessageDigest sha256Digest = MessageDigest.getInstance("SHA-256");
        byte[] hash = sha256Digest.digest(password.getBytes());
        processDigest(hash);
    }

    /**
     * Secure salted hashing using SHA-256.
     * SAST: Salting the input improves security.
     */
    public void secureSaltedHashing(String password) throws Exception {
        byte[] salt = generateSalt(16);
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        digest.update(salt);
        byte[] hash = digest.digest(password.getBytes());
        processDigest(hash);
    }

    /**
     * Secure key derivation using PBKDF2 with HMAC-SHA256.
     * SAST: PBKDF2 with sufficient iterations is recommended.
     */
    public void securePBKDF2Hashing(String password) throws Exception {
        byte[] salt = generateSalt(16);
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, 10000, 256);
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
        byte[] hash = factory.generateSecret(spec).getEncoded();
        processDigest(hash);
    }

    /**
     * Insecure digest generation using SHA-1.
     * SAST: SHA-1 is deprecated due to collision vulnerabilities.
     */
    public void insecureRawSHA1Hashing(String input) throws Exception {
        MessageDigest sha1Digest = MessageDigest.getInstance("SHA-1");
        byte[] hash = sha1Digest.digest(input.getBytes());
        processDigest(hash);
    }

    /**
     * Secure MAC computation using HMAC-SHA256.
     * SAST: HMAC-SHA256 is considered secure.
     */
    public void secureHMACHashing(String input, byte[] key) throws Exception {
        Mac hmac = Mac.getInstance("HmacSHA256");
        SecretKey secretKey = new SecretKeySpec(key, "HmacSHA256");
        hmac.init(secretKey);
        byte[] hash = hmac.doFinal(input.getBytes());
        processDigest(hash);
    }

    // ---------- Further Use of Digest Outputs ----------

    /**
     * Processes the digest by using it directly as key material for AES encryption.
     * SAST: Using a raw digest as key material is acceptable only if the digest is
     * produced
     * via a secure KDF. This method is ambiguous if the digest is from an insecure
     * function.
     *
     * @param digest The computed digest.
     * @throws Exception if encryption fails.
     */
    public void processDigest(byte[] digest) throws Exception {
        // Derive a 128-bit AES key from the digest.
        SecretKey key = new SecretKeySpec(digest, 0, 16, "AES");
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        cipher.init(Cipher.ENCRYPT_MODE, key, new SecureRandom());
        byte[] encryptedData = cipher.doFinal("Sensitive Data".getBytes());
        storeEncryptedDigest(encryptedData);
    }

    /**
     * Alternative flow: Uses the digest as an identifier (e.g., checksum) and
     * encrypts it.
     * SAST: Using a digest as an identifier is common; encryption must use secure
     * primitives.
     *
     * @param digest The computed digest.
     * @throws Exception if encryption fails.
     */
    public void alternativeDigestFlow(byte[] digest) throws Exception {
        byte[] identifier = Base64.getEncoder().encode(digest);
        encryptAndSend(identifier);
    }

    /**
     * Further use: Derives two separate keys from a digest using PBKDF2,
     * then uses one key for encryption and the other for computing a MAC over the
     * ciphertext.
     *
     * SAST: This approach of key derivation and splitting is acceptable if PBKDF2
     * is used securely.
     *
     * @param digest The input digest (must be generated from a secure source).
     * @throws Exception if key derivation or encryption fails.
     */
    public void furtherUseDigestForKeyDerivation(byte[] digest) throws Exception {
        // Treat the digest (in Base64) as a password input to PBKDF2.
        String digestAsPassword = Base64.getEncoder().encodeToString(digest);
        byte[] salt = generateSalt(16);
        // Derive 256 bits (32 bytes) of key material.
        PBEKeySpec spec = new PBEKeySpec(digestAsPassword.toCharArray(), salt, 10000, 256);
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
        byte[] keyMaterial = factory.generateSecret(spec).getEncoded();
        // Split into two 128-bit keys.
        byte[] encryptionKeyBytes = Arrays.copyOfRange(keyMaterial, 0, 16);
        byte[] macKeyBytes = Arrays.copyOfRange(keyMaterial, 16, 32);
        SecretKey encryptionKey = new SecretKeySpec(encryptionKeyBytes, "AES");
        SecretKey macKey = new SecretKeySpec(macKeyBytes, "HmacSHA256");

        // Encrypt sample data using the derived encryption key.
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        cipher.init(Cipher.ENCRYPT_MODE, encryptionKey, new SecureRandom());
        byte[] ciphertext = cipher.doFinal("Further Use Test Data".getBytes());

        // Compute HMAC over the ciphertext using the derived MAC key.
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(macKey);
        byte[] computedMac = mac.doFinal(ciphertext);

        // In production, these outputs would be securely stored or transmitted.
        byte[] output = new byte[ciphertext.length + computedMac.length];
        System.arraycopy(ciphertext, 0, output, 0, ciphertext.length);
        System.arraycopy(computedMac, 0, output, ciphertext.length, computedMac.length);
        storeEncryptedDigest(output);
    }

    /**
     * Encrypts data using AES-GCM and simulates secure transmission or storage.
     * SAST: Uses a securely generated AES key.
     *
     * @param data The data to encrypt.
     * @throws Exception if encryption fails.
     */
    public void encryptAndSend(byte[] data) throws Exception {
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        SecretKey key = generateAESKey();
        cipher.init(Cipher.ENCRYPT_MODE, key, new SecureRandom());
        byte[] encryptedData = cipher.doFinal(data);
        storeEncryptedDigest(encryptedData);
    }

    /**
     * Simulates secure storage or transmission of an encrypted digest.
     * SAST: In production, this method would implement secure storage/transmission.
     *
     * @param encryptedDigest The encrypted digest.
     */
    public void storeEncryptedDigest(byte[] encryptedDigest) {
        // For static analysis purposes, this method represents a secure output
        // mechanism.
        String stored = Base64.getEncoder().encodeToString(encryptedDigest);
    }

    // ---------- Helper Methods ----------

    /**
     * Generates a secure 256-bit AES key.
     * SAST: Key generation uses a strong RNG.
     *
     * @return A SecretKey for AES.
     * @throws NoSuchAlgorithmException if AES is unsupported.
     */
    private SecretKey generateAESKey() throws NoSuchAlgorithmException {
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(256);
        return keyGen.generateKey();
    }

    /**
     * Generates a random salt of the specified length using SecureRandom.
     * SAST: Salting is essential for secure digest computations.
     *
     * @param length The salt length.
     * @return A byte array representing the salt.
     */
    private byte[] generateSalt(int length) {
        byte[] salt = new byte[length];
        new SecureRandom().nextBytes(salt);
        return salt;
    }
}
