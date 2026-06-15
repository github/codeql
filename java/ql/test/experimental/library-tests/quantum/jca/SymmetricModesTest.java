package com.example.crypto.algorithms;

//import org.bouncycastle.jce.provider.BouncyCastleProvider;
import java.security.SecureRandom;
import java.util.Base64;
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;

/**
 * SymmetricModesTest demonstrates the use of advanced cipher modes for
 * symmetric encryption:
 *
 * 1. AES/KWP/NoPadding: Uses AES Key Wrap with Padding (KWP) to securely wrap
 * (encrypt) a key. - Secure usage: Uses a randomly generated wrapping key.
 *
 * 2. AES/OFB8/NoPadding: Uses AES in Output Feedback mode with an 8-bit
 * feedback size. - Secure usage: Uses a random IV for each encryption. -
 * Insecure usage: Using a fixed IV (or nonce) in OFB mode compromises
 * confidentiality.
 *
 * In production, algorithm parameters (such as mode, padding, and IV
 * generation) should be externalized via configuration files to support crypto
 * agility.
 */
public class SymmetricModesTest {

    // static {
    //     // Register BouncyCastle provider for additional cipher modes.
    //     Security.addProvider(new BouncyCastleProvider());
    // }
    // ---------------------------
    // AES/KWP/NoPadding Example
    // ---------------------------
    /**
     * Securely wraps a target AES key using AES/KWP/NoPadding.
     *
     * Best Practice: - The wrapping key must be generated randomly. - AES/KWP
     * provides key wrapping with padding, suitable for keys whose lengths are
     * not multiples of the block size.
     *
     * @return The Base64-encoded wrapped key.
     * @throws Exception if an error occurs during key wrapping.
     */
    public String secureAESKWPWrap() throws Exception {
        // Generate a random wrapping key (256-bit) for key wrapping.
        KeyGenerator kg = KeyGenerator.getInstance("AES");
        kg.init(256, new SecureRandom());
        SecretKey wrappingKey = kg.generateKey();

        // Generate a target AES key to be wrapped (128-bit).
        kg.init(128, new SecureRandom());
        SecretKey targetKey = kg.generateKey();

        // Use AES/KWP (Key Wrap with Padding) to wrap the target key.
        Cipher cipher = Cipher.getInstance("AES/KWP/NoPadding", "BC");
        cipher.init(Cipher.WRAP_MODE, wrappingKey);
        byte[] wrappedKey = cipher.wrap(targetKey);

        return Base64.getEncoder().encodeToString(wrappedKey);
    }

    // ---------------------------
    // AES/OFB8/NoPadding Examples
    // ---------------------------
    /**
     * Securely encrypts plaintext using AES in OFB mode with an 8-bit feedback
     * size (AES/OFB8/NoPadding).
     *
     * Best Practice: - Use a fresh, random IV for each encryption operation.
     *
     * @param key The AES key.
     * @param plaintext The plaintext to encrypt.
     * @return The ciphertext (Base64-encoded) with the IV prepended.
     * @throws Exception if encryption fails.
     */
    public String secureAesOfb8Encryption(SecretKey key, byte[] plaintext) throws Exception {
        Cipher cipher = Cipher.getInstance("AES/OFB8/NoPadding", "BC");
        byte[] iv = new byte[16]; // IV size for AES block cipher (128-bit) even if feedback is 8-bit.
        new SecureRandom().nextBytes(iv);
        IvParameterSpec ivSpec = new IvParameterSpec(iv);
        cipher.init(Cipher.ENCRYPT_MODE, key, ivSpec);
        byte[] ciphertext = cipher.doFinal(plaintext);
        // Prepend IV to ciphertext (as is common practice)
        byte[] output = new byte[iv.length + ciphertext.length];
        System.arraycopy(iv, 0, output, 0, iv.length);
        System.arraycopy(ciphertext, 0, output, iv.length, ciphertext.length);
        return Base64.getEncoder().encodeToString(output);
    }

    /**
     * Insecurely encrypts plaintext using AES in OFB mode with an 8-bit
     * feedback size (AES/OFB8/NoPadding) by using a fixed IV.
     *
     * Best Practice Violation: - Using a fixed IV (or nonce) with any
     * encryption mode (including OFB) compromises the cipher's security.
     *
     * @param key The AES key.
     * @param plaintext The plaintext to encrypt.
     * @return The ciphertext (Base64-encoded) with the fixed IV prepended.
     * @throws Exception if encryption fails.
     */
    public String insecureAesOfb8Encryption(SecretKey key, byte[] plaintext) throws Exception {
        Cipher cipher = Cipher.getInstance("AES/OFB8/NoPadding", "BC");
        // Fixed IV: Insecure because it causes nonce/IV reuse.
        byte[] fixedIV = new byte[16]; // All zeros.
        IvParameterSpec ivSpec = new IvParameterSpec(fixedIV);
        cipher.init(Cipher.ENCRYPT_MODE, key, ivSpec);
        byte[] ciphertext = cipher.doFinal(plaintext);
        byte[] output = new byte[fixedIV.length + ciphertext.length];
        System.arraycopy(fixedIV, 0, output, 0, fixedIV.length);
        System.arraycopy(ciphertext, 0, output, fixedIV.length, ciphertext.length);
        return Base64.getEncoder().encodeToString(output);
    }

    // ---------------------------
    // Helper Methods
    // ---------------------------
    /**
     * Generates a secure 256-bit AES key.
     *
     * @return A new AES SecretKey.
     * @throws Exception if key generation fails.
     */
    public SecretKey generateAESKey() throws Exception {
        KeyGenerator kg = KeyGenerator.getInstance("AES");
        kg.init(256, new SecureRandom());
        return kg.generateKey();
    }
}
