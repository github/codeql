package com.example.crypto.algorithms;

// import org.bouncycastle.jce.provider.BouncyCastleProvider;
import java.security.*;

import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.Mac;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import java.security.SecureRandom;
import java.util.Arrays;
import java.util.Base64;

/**
 * SymmetricAlgorithmTest demonstrates various symmetric encryption flows and
 * key derivation scenarios that can be analyzed by SAST tools.
 *
 * It includes: 1) AES-GCM encryption with random nonce (secure). 2) AES-GCM
 * encryption with fixed nonce (insecure). 3) AES-CBC encryption with random IV
 * (secure). 4) AES-ECB encryption (insecure). 5) RC4 encryption (insecure). 6)
 * DES and TripleDES encryption (insecure/weak). 7) ChaCha20 encryption (secure,
 * if available). 8) KMAC-based key derivation used to derive a key for AES
 * encryption. 9) Dynamic symmetric encryption selection based on configuration.
 * 10) Further use: deriving two keys from symmetric key material via PBKDF2.
 *
 * SAST/CBOM notes: - Nonce/IV reuse (e.g., fixed nonce) must be flagged. -
 * Insecure algorithms (RC4, DES, TripleDES, AES/ECB) are marked as unsafe. -
 * Dynamic selection may lead to insecure fallback if misconfigured.
 */
public class SymmetricAlgorithm {

    // static {
    //     Security.addProvider(new BouncyCastleProvider());
    // }
    // ---------- Secure Symmetric Encryption Flows ----------
    /**
     * AES-GCM encryption using a 12-byte random nonce. SAST: AES-GCM is secure
     * when a unique nonce is used per encryption.
     *
     * @param key The AES key.
     * @param plaintext The plaintext to encrypt.
     * @return The IV prepended to the ciphertext.
     * @throws Exception if encryption fails.
     */
    public byte[] aesGcmEncryptSafe(SecretKey key, byte[] plaintext) throws Exception {
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        byte[] iv = new byte[12]; // Recommended 12-byte nonce for GCM.
        new SecureRandom().nextBytes(iv);
        GCMParameterSpec spec = new GCMParameterSpec(128, iv);
        cipher.init(Cipher.ENCRYPT_MODE, key, spec);
        byte[] ciphertext = cipher.doFinal(plaintext);
        byte[] output = new byte[iv.length + ciphertext.length];
        System.arraycopy(iv, 0, output, 0, iv.length);
        System.arraycopy(ciphertext, 0, output, iv.length, ciphertext.length);
        return output;
    }

    /**
     * AES-GCM encryption using a fixed (constant) nonce. SAST: Fixed nonce
     * reuse in AES-GCM is insecure as it destroys confidentiality.
     *
     * @param key The AES key.
     * @param plaintext The plaintext to encrypt.
     * @return The fixed IV prepended to the ciphertext.
     * @throws Exception if encryption fails.
     */
    public byte[] aesGcmEncryptUnsafe(SecretKey key, byte[] plaintext) throws Exception {
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        byte[] iv = new byte[12]; // Fixed IV (all zeros by default) - insecure.
        GCMParameterSpec spec = new GCMParameterSpec(128, iv);
        cipher.init(Cipher.ENCRYPT_MODE, key, spec);
        byte[] ciphertext = cipher.doFinal(plaintext);
        byte[] output = new byte[iv.length + ciphertext.length];
        System.arraycopy(iv, 0, output, 0, iv.length);
        System.arraycopy(ciphertext, 0, output, iv.length, ciphertext.length);
        return output;
    }

    /**
     * AES-CBC encryption using a random IV. SAST: AES-CBC is secure if IVs are
     * random and not reused.
     *
     * @param key The AES key.
     * @param plaintext The plaintext to encrypt.
     * @return The IV prepended to the ciphertext.
     * @throws Exception if encryption fails.
     */
    public byte[] aesCbcEncryptSafe(SecretKey key, byte[] plaintext) throws Exception {
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        byte[] iv = new byte[16]; // 16-byte IV for AES block size.
        new SecureRandom().nextBytes(iv);
        IvParameterSpec ivSpec = new IvParameterSpec(iv);
        cipher.init(Cipher.ENCRYPT_MODE, key, ivSpec);
        byte[] ciphertext = cipher.doFinal(plaintext);
        byte[] output = new byte[iv.length + ciphertext.length];
        System.arraycopy(iv, 0, output, 0, iv.length);
        System.arraycopy(ciphertext, 0, output, iv.length, ciphertext.length);
        return output;
    }

    /**
     * AES-ECB encryption. SAST: ECB mode is insecure as it does not use an IV,
     * revealing data patterns.
     *
     * @param key The AES key.
     * @param plaintext The plaintext to encrypt.
     * @return The ciphertext.
     * @throws Exception if encryption fails.
     */
    public byte[] aesEcbEncryptUnsafe(SecretKey key, byte[] plaintext) throws Exception {
        Cipher cipher = Cipher.getInstance("AES/ECB/PKCS5Padding");
        cipher.init(Cipher.ENCRYPT_MODE, key);
        return cipher.doFinal(plaintext);
    }

    // ---------- Other Symmetric Algorithms ----------
    /**
     * RC4 encryption. SAST: RC4 is deprecated due to vulnerabilities.
     *
     * @param key The RC4 key.
     * @param plaintext The plaintext to encrypt.
     * @return The ciphertext.
     * @throws Exception if encryption fails.
     */
    public byte[] rc4EncryptUnsafe(SecretKey key, byte[] plaintext) throws Exception {
        Cipher cipher = Cipher.getInstance("RC4");
        cipher.init(Cipher.ENCRYPT_MODE, key);
        return cipher.doFinal(plaintext);
    }

    /**
     * DES encryption. SAST: DES is insecure due to its 56-bit effective key
     * size.
     *
     * @param key The DES key.
     * @param plaintext The plaintext to encrypt.
     * @return The IV prepended to the ciphertext.
     * @throws Exception if encryption fails.
     */
    public byte[] desEncryptUnsafe(SecretKey key, byte[] plaintext) throws Exception {
        Cipher cipher = Cipher.getInstance("DES/CBC/PKCS5Padding");
        byte[] iv = new byte[8];
        new SecureRandom().nextBytes(iv);
        IvParameterSpec ivSpec = new IvParameterSpec(iv);
        cipher.init(Cipher.ENCRYPT_MODE, key, ivSpec);
        byte[] ciphertext = cipher.doFinal(plaintext);
        byte[] output = new byte[iv.length + ciphertext.length];
        System.arraycopy(iv, 0, output, 0, iv.length);
        System.arraycopy(ciphertext, 0, output, iv.length, ciphertext.length);
        return output;
    }

    /**
     * TripleDES (DESede) encryption. SAST: TripleDES is weak by modern
     * standards and is deprecated.
     *
     * @param key The TripleDES key.
     * @param plaintext The plaintext to encrypt.
     * @return The IV prepended to the ciphertext.
     * @throws Exception if encryption fails.
     */
    public byte[] tripleDesEncryptUnsafe(SecretKey key, byte[] plaintext) throws Exception {
        Cipher cipher = Cipher.getInstance("DESede/CBC/PKCS5Padding");
        byte[] iv = new byte[8];
        new SecureRandom().nextBytes(iv);
        IvParameterSpec ivSpec = new IvParameterSpec(iv);
        cipher.init(Cipher.ENCRYPT_MODE, key, ivSpec);
        byte[] ciphertext = cipher.doFinal(plaintext);
        byte[] output = new byte[iv.length + ciphertext.length];
        System.arraycopy(iv, 0, output, 0, iv.length);
        System.arraycopy(ciphertext, 0, output, iv.length, ciphertext.length);
        return output;
    }

    /**
     * ChaCha20 encryption. SAST: ChaCha20 is considered secure and is a modern
     * alternative to AES.
     *
     * @param key The ChaCha20 key.
     * @param plaintext The plaintext to encrypt.
     * @return The nonce prepended to the ciphertext.
     * @throws Exception if encryption fails.
     */
    public byte[] chacha20EncryptSafe(SecretKey key, byte[] plaintext) throws Exception {
        Cipher cipher = Cipher.getInstance("ChaCha20", "BC");
        byte[] nonce = new byte[12]; // ChaCha20 typically uses a 12-byte nonce.
        new SecureRandom().nextBytes(nonce);
        // ChaCha20 may require an IvParameterSpec for the nonce.
        cipher.init(Cipher.ENCRYPT_MODE, key, new IvParameterSpec(nonce));
        byte[] ciphertext = cipher.doFinal(plaintext);
        byte[] output = new byte[nonce.length + ciphertext.length];
        System.arraycopy(nonce, 0, output, 0, nonce.length);
        System.arraycopy(ciphertext, 0, output, nonce.length, ciphertext.length);
        return output;
    }

    /**
     * KMAC-based flow: Uses KMAC128 to derive key material for AES encryption.
     * SAST: KMAC128 is secure as part of the SHA-3 family when used correctly.
     *
     * @param key The KMAC key.
     * @param plaintext The plaintext to encrypt.
     * @return The ciphertext (with IV) resulting from encryption with a derived
     * key.
     * @throws Exception if encryption fails.
     */
    public byte[] kmacEncryptFlow(SecretKey key, byte[] plaintext) throws Exception {
        Mac kmac = Mac.getInstance("KMAC128", "BC");
        kmac.init(key);
        byte[] kmacOutput = kmac.doFinal(plaintext);
        // Use the first 16 bytes of KMAC output as an AES key.
        SecretKey derivedKey = new SecretKeySpec(kmacOutput, 0, 16, "AES");
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        byte[] iv = new byte[12];
        new SecureRandom().nextBytes(iv);
        GCMParameterSpec spec = new GCMParameterSpec(128, iv);
        cipher.init(Cipher.ENCRYPT_MODE, derivedKey, spec);
        byte[] ciphertext = cipher.doFinal(plaintext);
        byte[] output = new byte[iv.length + ciphertext.length];
        System.arraycopy(iv, 0, output, 0, iv.length);
        System.arraycopy(ciphertext, 0, output, iv.length, ciphertext.length);
        return output;
    }

    // ---------- Dynamic Algorithm Selection ----------
    /**
     * Dynamically selects a symmetric encryption algorithm based on a
     * configuration property. If the algorithm is unknown or ambiguous, falls
     * back to an insecure default (AES/ECB).
     *
     * SAST: Dynamic selection introduces a known unknown risk.
     *
     * @param algorithm The algorithm name from configuration.
     * @param key The symmetric key.
     * @param plaintext The plaintext to encrypt.
     * @return The ciphertext.
     * @throws Exception if encryption fails.
     */
    public byte[] dynamicSymmetricEncryption(String algorithm, SecretKey key, byte[] plaintext) throws Exception {
        if ("AES/GCM/NoPadding".equalsIgnoreCase(algorithm)) {
            return aesGcmEncryptSafe(key, plaintext);
        } else if ("AES/CBC/PKCS5Padding".equalsIgnoreCase(algorithm)) {
            return aesCbcEncryptSafe(key, plaintext);
        } else if ("AES/ECB/PKCS5Padding".equalsIgnoreCase(algorithm)) {
            return aesEcbEncryptUnsafe(key, plaintext);
        } else if ("RC4".equalsIgnoreCase(algorithm)) {
            return rc4EncryptUnsafe(key, plaintext);
        } else if ("ChaCha20".equalsIgnoreCase(algorithm)) {
            return chacha20EncryptSafe(key, plaintext);
        } else {
            // Unknown algorithm: fallback to insecure AES/ECB.
            return aesEcbEncryptUnsafe(key, plaintext);
        }
    }

    // ---------- Further Use of Symmetric Keys ----------
    /**
     * Derives a key from an input key by simple truncation. SAST: This approach
     * is ambiguous; a proper KDF should be used.
     *
     * @param key The input symmetric key.
     * @return A derived 128-bit key.
     */
    public byte[] deriveKeyFromKey(SecretKey key) {
        byte[] keyBytes = key.getEncoded();
        return Arrays.copyOf(keyBytes, 16);
    }

    /**
     * Further use: Derives two separate keys from a symmetric key using PBKDF2,
     * then uses one key for encryption and one for MACing ciphertext. SAST:
     * This key-splitting approach is acceptable if PBKDF2 is used securely.
     *
     * @param key The input key material.
     * @param plaintext The plaintext to encrypt.
     * @return The concatenated ciphertext and its MAC.
     * @throws Exception if key derivation or encryption fails.
     */
    public byte[] furtherUseSymmetricKeyForKeyDerivation(SecretKey key, byte[] plaintext) throws Exception {
        String keyAsString = Base64.getEncoder().encodeToString(key.getEncoded());
        byte[] salt = generateSalt(16);
        PBEKeySpec spec = new PBEKeySpec(keyAsString.toCharArray(), salt, 10000, 256);
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
        byte[] derived = factory.generateSecret(spec).getEncoded();
        byte[] encKeyBytes = Arrays.copyOfRange(derived, 0, 16);
        byte[] macKeyBytes = Arrays.copyOfRange(derived, 16, 32);
        SecretKey encKey = new SecretKeySpec(encKeyBytes, "AES");
        SecretKey derivedMacKey = new SecretKeySpec(macKeyBytes, "HmacSHA256");

        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        byte[] iv = new byte[12];
        new SecureRandom().nextBytes(iv);
        cipher.init(Cipher.ENCRYPT_MODE, encKey, new GCMParameterSpec(128, iv));
        byte[] ciphertext = cipher.doFinal(plaintext);

        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(derivedMacKey);
        byte[] computedMac = mac.doFinal(ciphertext);

        byte[] output = new byte[ciphertext.length + computedMac.length];
        System.arraycopy(ciphertext, 0, output, 0, ciphertext.length);
        System.arraycopy(computedMac, 0, output, ciphertext.length, computedMac.length);
        storeEncryptedOutput(output);
        return output;
    }

    /**
     * Stores the encrypted output. SAST: In production, secure
     * storage/transmission is required.
     *
     * @param output The output to store.
     */
    public void storeEncryptedOutput(byte[] output) {
        String stored = Base64.getEncoder().encodeToString(output);
    }

    // ---------- Helper Methods ----------
    /**
     * Generates a secure 256-bit AES key. SAST: Uses a strong RNG for key
     * generation.
     *
     * @return A new AES SecretKey.
     * @throws Exception if key generation fails.
     */
    public SecretKey generateAESKey() throws Exception {
        KeyGenerator kg = KeyGenerator.getInstance("AES");
        kg.init(256);
        return kg.generateKey();
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
