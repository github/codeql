package com.example.crypto.algorithms;

//import org.bouncycastle.jce.provider.BouncyCastleProvider;
import java.security.*;
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;
import java.security.SecureRandom;
import java.util.Arrays;
import java.util.Base64;

/**
 * AesWrapAndPBEWithTest demonstrates key wrapping and password-based encryption
 * using various transformations.
 *
 * This file includes:
 *
 * 1. AESWrap Examples: - secureAESWrap(): Uses a randomly generated wrapping
 * key. - insecureAESWrap(): Uses a fixed, hard-coded wrapping key.
 *
 * 2. PBEWith Examples: - insecurePBEExample(): Uses the legacy
 * PBEWithMD5AndDES. - securePBEExample(): Uses PBKDF2WithHmacSHA256. -
 * additionalPBEExample(): Uses PBEWithSHA256And128BitAES-CBC-BC. -
 * additionalPBEExample2(): Uses PBEWithSHA1And128BitAES-CBC-BC.
 *
 * 3. Dynamic PBE Encryption: - dynamicPBEEncryption(): Chooses the PBE
 * transformation based on a configuration string.
 *
 * Best Practices: - Use secure random keys and salts. - Avoid legacy algorithms
 * like PBEWithMD5AndDES. - Prefer modern KDFs (PBKDF2WithHmacSHA256) and secure
 * provider-specific PBE transformations.
 *
 * SAST/CBOM Notes: - Insecure examples (PBEWithMD5AndDES, fixed keys) should be
 * flagged. - Secure examples use random salt, high iteration counts, and strong
 * algorithms.
 */
public class AesWrapAndPBEWith {

    // static {
    //     // Register BouncyCastle as a provider.
    //     Security.addProvider(new BouncyCastleProvider());
    // }
    // ===========================
    // 1. AESWrap Examples
    // ===========================
    /**
     * Secure AES key wrapping. Generates a random 256-bit wrapping key to wrap
     * a target AES key.
     *
     * @return The wrapped key (Base64-encoded).
     * @throws Exception if an error occurs.
     */
    public String secureAESWrap() throws Exception {
        KeyGenerator kg = KeyGenerator.getInstance("AES");
        kg.init(256, new SecureRandom());
        SecretKey wrappingKey = kg.generateKey();

        kg.init(128, new SecureRandom());
        SecretKey targetKey = kg.generateKey();

        Cipher cipher = Cipher.getInstance("AESWrap");
        cipher.init(Cipher.WRAP_MODE, wrappingKey);
        byte[] wrappedKey = cipher.wrap(targetKey);

        return Base64.getEncoder().encodeToString(wrappedKey);
    }

    /**
     * Insecure AES key wrapping. Uses a fixed (hard-coded) wrapping key.
     *
     * @return The wrapped key (Base64-encoded).
     * @throws Exception if an error occurs.
     */
    public String insecureAESWrap() throws Exception {
        byte[] fixedKeyBytes = new byte[32];
        Arrays.fill(fixedKeyBytes, (byte) 0x01);
        SecretKey wrappingKey = new SecretKeySpec(fixedKeyBytes, "AES");

        KeyGenerator kg = KeyGenerator.getInstance("AES");
        kg.init(128, new SecureRandom());
        SecretKey targetKey = kg.generateKey();

        Cipher cipher = Cipher.getInstance("AESWrap");
        cipher.init(Cipher.WRAP_MODE, wrappingKey);
        byte[] wrappedKey = cipher.wrap(targetKey);

        return Base64.getEncoder().encodeToString(wrappedKey);
    }

    // ===========================
    // 2. PBEWith Examples
    // ===========================
    /**
     * Insecure PBE example using PBEWithMD5AndDES.
     *
     * @param password The input password.
     * @return The derived key (Base64-encoded).
     * @throws Exception if key derivation fails.
     */
    public String insecurePBEExample(String password) throws Exception {
        byte[] salt = new byte[8];
        Arrays.fill(salt, (byte) 0x00); // Fixed salt (insecure)
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, 1000, 64);
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBEWithMD5AndDES");
        byte[] keyBytes = factory.generateSecret(spec).getEncoded();
        return Base64.getEncoder().encodeToString(keyBytes);
    }

    /**
     * Secure PBE example using PBKDF2WithHmacSHA256.
     *
     * @param password The input password.
     * @return The derived 256-bit AES key (Base64-encoded).
     * @throws Exception if key derivation fails.
     */
    public String securePBEExample(String password) throws Exception {
        byte[] salt = new byte[16];
        new SecureRandom().nextBytes(salt);
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, 10000, 256);
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
        byte[] keyBytes = factory.generateSecret(spec).getEncoded();
        SecretKey aesKey = new SecretKeySpec(keyBytes, "AES");
        return Base64.getEncoder().encodeToString(aesKey.getEncoded());
    }

    /**
     * Additional PBE example using PBEWithSHA256And128BitAES-CBC-BC.
     *
     * @param password The input password.
     * @param plaintext The plaintext to encrypt.
     * @return The IV concatenated with ciphertext (Base64-encoded).
     * @throws Exception if key derivation or encryption fails.
     */
    public String additionalPBEExample(String password, String plaintext) throws Exception {
        byte[] salt = new byte[16];
        new SecureRandom().nextBytes(salt);
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, 10000, 128);
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBEWithSHA256And128BitAES-CBC-BC");
        SecretKey pbeKey = factory.generateSecret(spec);
        SecretKey aesKey = new SecretKeySpec(pbeKey.getEncoded(), "AES");

        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        byte[] iv = new byte[16];
        new SecureRandom().nextBytes(iv);
        IvParameterSpec ivSpec = new IvParameterSpec(iv);
        cipher.init(Cipher.ENCRYPT_MODE, aesKey, ivSpec);
        byte[] ciphertext = cipher.doFinal(plaintext.getBytes());
        byte[] output = concatenate(iv, ciphertext);
        return Base64.getEncoder().encodeToString(output);
    }

    /**
     * Additional PBE example using PBEWithSHA1And128BitAES-CBC-BC. This is less
     * preferred than PBKDF2WithHmacSHA256 but demonstrates another variant.
     *
     * @param password The input password.
     * @param plaintext The plaintext to encrypt.
     * @return The IV concatenated with ciphertext (Base64-encoded).
     * @throws Exception if key derivation or encryption fails.
     */
    public String additionalPBEExample2(String password, String plaintext) throws Exception {
        byte[] salt = new byte[16];
        new SecureRandom().nextBytes(salt);
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, 10000, 128);
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBEWithSHA1And128BitAES-CBC-BC");
        SecretKey pbeKey = factory.generateSecret(spec);
        SecretKey aesKey = new SecretKeySpec(pbeKey.getEncoded(), "AES");

        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        byte[] iv = new byte[16];
        new SecureRandom().nextBytes(iv);
        IvParameterSpec ivSpec = new IvParameterSpec(iv);
        cipher.init(Cipher.ENCRYPT_MODE, aesKey, ivSpec);
        byte[] ciphertext = cipher.doFinal(plaintext.getBytes());
        byte[] output = concatenate(iv, ciphertext);
        return Base64.getEncoder().encodeToString(output);
    }

    // ===========================
    // 3. Dynamic PBE Encryption
    // ===========================
    /**
     * Dynamically selects a PBE transformation based on a configuration string.
     *
     * Acceptable values: - "PBKDF2": Uses PBKDF2WithHmacSHA256. - "SHA256AES":
     * Uses PBEWithSHA256And128BitAES-CBC-BC. - "SHA1AES": Uses
     * PBEWithSHA1And128BitAES-CBC-BC. - Otherwise, falls back to insecure
     * PBEWithMD5AndDES.
     *
     * @param config The configuration string.
     * @param password The input password.
     * @param plaintext The plaintext to encrypt.
     * @return The Base64-encoded encrypted output.
     * @throws Exception if an error occurs.
     */
    public String dynamicPBEEncryption(String config, String password, String plaintext) throws Exception {
        if ("PBKDF2".equalsIgnoreCase(config)) {
            return securePBEExample(password);
        } else if ("SHA256AES".equalsIgnoreCase(config)) {
            return additionalPBEExample(password, plaintext);
        } else if ("SHA1AES".equalsIgnoreCase(config)) {
            return additionalPBEExample2(password, plaintext);
        } else {
            // Fallback insecure option.
            return insecurePBEExample(password);
        }
    }

    // ===========================
    // Helper Methods
    // ===========================
    /**
     * Concatenates two byte arrays.
     */
    private byte[] concatenate(byte[] a, byte[] b) {
        byte[] result = new byte[a.length + b.length];
        System.arraycopy(a, 0, result, 0, a.length);
        System.arraycopy(b, 0, result, a.length, b.length);
        return result;
    }

}
