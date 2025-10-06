package com.example.crypto.algorithms;

// import org.bouncycastle.jce.provider.BouncyCastleProvider;
import java.security.*;
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
 * MACOperation demonstrates various Message Authentication Code (MAC)
 * operations and further use of MAC outputs as inputs into higher-level
 * cryptosystems.
 *
 * Flows include:
 *
 * 1. Secure HMAC-SHA2 (HMAC-SHA256) - a widely accepted MAC. 2. Secure
 * HMAC-SHA3 (HMAC-SHA3-256) - an alternative using the SHA-3 family. 3. Secure
 * Poly1305 MAC - using BouncyCastle's implementation. 4. Secure GMAC - using
 * AES-GCM's authentication tag in a dedicated MAC mode. 5. Secure KMAC - using
 * KMAC128 (from the SHA-3 family).
 *
 * Insecure examples include:
 *
 * 6. Insecure HMAC-SHA1 - which is deprecated.
 *
 * Further flows:
 *
 * A. processMACOutput: Uses the MAC output directly as key material for AES
 * encryption. (Note: This is acceptable only if the MAC is produced by a secure
 * function.)
 *
 * B. alternativeMACFlow: Uses the MAC output as an identifier that is then
 * encrypted.
 *
 * C. furtherUseMACForKeyDerivation: Uses PBKDF2 to split a MAC output into two
 * keys, one for encryption and one for MACing ciphertext.
 *
 * SAST/CBOM Notes: - Secure MAC algorithms (HMAC-SHA256, HMAC-SHA3-256,
 * Poly1305, GMAC, KMAC128) are acceptable if used correctly. - HMAC-SHA1 is
 * flagged as insecure. - Using a raw MAC output directly as key material is
 * ambiguous unless the MAC is produced by a secure KDF.
 */
public class MACOperation {

    // static {
    //     Security.addProvider(new BouncyCastleProvider());
    // }
    // ---------- MAC Operations ----------
    /**
     * Secure MAC using HMAC-SHA256. SAST: HMAC-SHA256 is widely considered
     * secure.
     */
    public byte[] secureHMACSHA256(String message, byte[] key) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256", "BC");
        SecretKey secretKey = new SecretKeySpec(key, "HmacSHA256");
        mac.init(secretKey);
        return mac.doFinal(message.getBytes());
    }

    /**
     * Secure MAC using HMAC-SHA3-256. SAST: HMAC-SHA3 is a modern alternative
     * from the SHA-3 family.
     */
    public byte[] secureHMACSHA3(String message, byte[] key) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA3-256", "BC");
        SecretKey secretKey = new SecretKeySpec(key, "HmacSHA3-256");
        mac.init(secretKey);
        return mac.doFinal(message.getBytes());
    }

    /**
     * Secure MAC using Poly1305. SAST: Poly1305 is secure when used with a
     * one-time key from a cipher (e.g. ChaCha20).
     */
    public byte[] securePoly1305(String message, byte[] key) throws Exception {
        Mac mac = Mac.getInstance("Poly1305", "BC");
        SecretKey secretKey = new SecretKeySpec(key, "Poly1305");
        mac.init(secretKey);
        return mac.doFinal(message.getBytes());
    }

    /**
     * Secure MAC using GMAC. SAST: GMAC (the MAC part of AES-GCM) is secure
     * when used correctly.
     */
    public byte[] secureGMAC(String message, byte[] key) throws Exception {
        // For GMAC, we use the GMac algorithm as provided by BC.
        Mac mac = Mac.getInstance("GMac", "BC");
        // Initialize the key for GMAC; key should be appropriate for the underlying
        // block cipher.
        SecretKey secretKey = new SecretKeySpec(key, "AES");
        mac.init(secretKey);
        return mac.doFinal(message.getBytes());
    }

    /**
     * Secure MAC using KMAC128. SAST: KMAC128 is part of the SHA-3 family and
     * is secure when used properly.
     */
    public byte[] secureKMAC(String message, byte[] key) throws Exception {
        Mac mac = Mac.getInstance("KMAC128", "BC");
        SecretKey secretKey = new SecretKeySpec(key, "KMAC128");
        mac.init(secretKey);
        return mac.doFinal(message.getBytes());
    }

    /**
     * Insecure MAC using HMAC-SHA1. SAST: HMAC-SHA1 is considered deprecated
     * and weak.
     */
    public byte[] insecureHMACSHA1(String message, byte[] key) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA1", "BC");
        SecretKey secretKey = new SecretKeySpec(key, "HmacSHA1");
        mac.init(secretKey);
        return mac.doFinal(message.getBytes());
    }

    // ---------- Further Use of MAC Outputs ----------
    /**
     * Processes the MAC output by using it as key material for AES encryption.
     * SAST: Using a raw MAC output as key material is acceptable only if the
     * MAC was produced by a secure function; otherwise, this is ambiguous.
     *
     * @param macOutput The computed MAC output.
     * @throws Exception if encryption fails.
     */
    public void processMACOutput(byte[] macOutput) throws Exception {
        // Derive a 128-bit AES key from the MAC output.
        SecretKey key = new SecretKeySpec(macOutput, 0, 16, "AES");
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        cipher.init(Cipher.ENCRYPT_MODE, key, new SecureRandom());
        byte[] encryptedData = cipher.doFinal("Sensitive Data".getBytes());
        storeEncryptedMAC(encryptedData);
    }

    /**
     * Alternative flow: Uses the MAC output as an identifier and then encrypts
     * it. SAST: Using a MAC as an identifier is common; subsequent encryption
     * must be secure.
     *
     * @param macOutput The computed MAC output.
     * @throws Exception if encryption fails.
     */
    public void alternativeMACFlow(byte[] macOutput) throws Exception {
        byte[] identifier = Base64.getEncoder().encode(macOutput);
        encryptAndSend(identifier);
    }

    /**
     * Further use: Derives two separate keys from the MAC output using PBKDF2,
     * then uses one key for encryption and one for computing an additional MAC
     * over the ciphertext.
     *
     * SAST: This key-splitting technique is acceptable if PBKDF2 is used
     * securely.
     *
     * @param macOutput The MAC output to derive keys from.
     * @throws Exception if key derivation or encryption fails.
     */
    public void furtherUseMACForKeyDerivation(byte[] macOutput) throws Exception {
        // Use the Base64 representation of the MAC as the password input to PBKDF2.
        String macAsPassword = Base64.getEncoder().encodeToString(macOutput);
        byte[] salt = generateSalt(16);
        PBEKeySpec spec = new PBEKeySpec(macAsPassword.toCharArray(), salt, 10000, 256);
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
        byte[] keyMaterial = factory.generateSecret(spec).getEncoded();
        // Split into two 128-bit keys.
        byte[] encryptionKeyBytes = Arrays.copyOfRange(keyMaterial, 0, 16);
        byte[] macKeyBytes = Arrays.copyOfRange(keyMaterial, 16, 32);
        SecretKey encryptionKey = new SecretKeySpec(encryptionKeyBytes, "AES");
        SecretKey derivedMacKey = new SecretKeySpec(macKeyBytes, "HmacSHA256");

        // Encrypt some sample data using the derived encryption key.
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        cipher.init(Cipher.ENCRYPT_MODE, encryptionKey, new SecureRandom());
        byte[] ciphertext = cipher.doFinal("Further Use Test Data".getBytes());

        // Compute HMAC over the ciphertext using the derived MAC key.
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(derivedMacKey);
        byte[] computedMac = mac.doFinal(ciphertext);

        // Concatenate the ciphertext and MAC for further use.
        byte[] output = new byte[ciphertext.length + computedMac.length];
        System.arraycopy(ciphertext, 0, output, 0, ciphertext.length);
        System.arraycopy(computedMac, 0, output, ciphertext.length, computedMac.length);
        storeEncryptedMAC(output);
    }

    // ---------- Output/Storage Methods ----------
    /**
     * Simulates secure storage or transmission of an encrypted MAC output.
     * SAST: In production, storage and transmission must be protected.
     *
     * @param encryptedMAC The encrypted MAC output.
     */
    public void storeEncryptedMAC(byte[] encryptedMAC) {
        String stored = Base64.getEncoder().encodeToString(encryptedMAC);
        // In production, this string would be securely stored or transmitted.
    }

    /**
     * Encrypts data using AES-GCM and simulates secure transmission. SAST: Uses
     * a securely generated AES key.
     *
     * @param data The data to encrypt.
     * @throws Exception if encryption fails.
     */
    public void encryptAndSend(byte[] data) throws Exception {
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        SecretKey key = generateAESKey();
        cipher.init(Cipher.ENCRYPT_MODE, key, new SecureRandom());
        byte[] encryptedData = cipher.doFinal(data);
        storeEncryptedMAC(encryptedData);
    }

    // ---------- Helper Methods ----------
    /**
     * Generates a secure 256-bit AES key. SAST: Uses a strong RNG for key
     * generation.
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
     * Generates a random salt of the specified length using SecureRandom. SAST:
     * Salting is essential for secure key derivation.
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
