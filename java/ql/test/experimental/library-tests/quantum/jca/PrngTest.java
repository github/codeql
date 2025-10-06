package com.example.crypto.algorithms;

import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Random;
import javax.crypto.SecretKey;
import javax.crypto.KeyGenerator;

/**
 * PrngTest demonstrates various approaches for generating random data using
 * PRNG/RNG APIs.
 *
 * It covers: 1) Secure random generation using SecureRandom (default and
 * getInstanceStrong). 2) Insecure random generation using java.util.Random. 3)
 * Flawed PRNG usage by setting a fixed seed. 4) Dynamic PRNG selection based on
 * configuration. 5) Usage of random data as nonces/IVs in symmetric encryption.
 *
 * SAST/CBOM Notes: - SecureRandom (and SecureRandom.getInstanceStrong) are
 * recommended. - java.util.Random is not suitable for cryptographic purposes. -
 * Re-seeding or using a fixed seed with SecureRandom makes it predictable. -
 * IVs and nonces must be unique for each operation; reusing fixed values is
 * insecure.
 */
public class PrngTest {

    // ---------- Secure Random Generation ----------
    /**
     * Generates random bytes using the default SecureRandom. SAST: SecureRandom
     * is recommended for cryptographically secure random data.
     *
     * @param numBytes Number of bytes to generate.
     * @return A byte array of random data.
     */
    public byte[] generateSecureRandomBytes(int numBytes) {
        SecureRandom secureRandom = new SecureRandom();
        byte[] bytes = new byte[numBytes];
        secureRandom.nextBytes(bytes);
        return bytes;
    }

    /**
     * Generates random bytes using SecureRandom.getInstanceStrong(). SAST:
     * getInstanceStrong() returns a strong RNG (may block in some
     * environments).
     *
     * @param numBytes Number of bytes to generate.
     * @return A byte array of random data.
     * @throws NoSuchAlgorithmException if a strong RNG is not available.
     */
    public byte[] generateSecureRandomBytesStrong(int numBytes) throws NoSuchAlgorithmException {
        SecureRandom secureRandom = SecureRandom.getInstanceStrong();
        byte[] bytes = new byte[numBytes];
        secureRandom.nextBytes(bytes);
        return bytes;
    }

    // ---------- Insecure Random Generation ----------
    /**
     * Generates random bytes using java.util.Random. SAST: java.util.Random is
     * predictable and insecure for cryptographic purposes.
     *
     * @param numBytes Number of bytes to generate.
     * @return A byte array of random data.
     */
    public byte[] generateInsecureRandomBytes(int numBytes) {
        Random random = new Random();
        byte[] bytes = new byte[numBytes];
        random.nextBytes(bytes);
        return bytes;
    }

    /**
     * Generates random bytes using SecureRandom with a fixed seed. SAST: Fixed
     * seeding makes SecureRandom predictable and insecure.
     *
     * @param numBytes Number of bytes to generate.
     * @return A byte array of predictable random data.
     */
    public byte[] generatePredictableRandomBytes(int numBytes) {
        SecureRandom secureRandom = new SecureRandom();
        // Fixed seed (predictable and insecure)
        secureRandom.setSeed(0xDEADBEEF);
        byte[] bytes = new byte[numBytes];
        secureRandom.nextBytes(bytes);
        return bytes;
    }

    // ---------- Dynamic PRNG Selection ----------
    /**
     * Dynamically selects a PRNG algorithm based on a configuration property.
     * If the algorithm is unknown, falls back to java.util.Random (insecure).
     * SAST: Dynamic selection may introduce risk if an insecure RNG is chosen.
     *
     * @param algorithmName The PRNG algorithm name (e.g. "SHA1PRNG",
     * "NativePRNGNonBlocking", "getInstanceStrong").
     * @param numBytes Number of bytes to generate.
     * @return A byte array of random data.
     * @throws NoSuchAlgorithmException if the algorithm is not available.
     */
    public byte[] dynamicRandomGeneration(String algorithmName, int numBytes) throws NoSuchAlgorithmException {
        SecureRandom secureRandom;
        if ("SHA1PRNG".equalsIgnoreCase(algorithmName)) {
            // SHA1PRNG is older and less preferred.
            secureRandom = SecureRandom.getInstance("SHA1PRNG");
        } else if ("NativePRNGNonBlocking".equalsIgnoreCase(algorithmName)) {
            secureRandom = SecureRandom.getInstance("NativePRNGNonBlocking");
        } else if ("getInstanceStrong".equalsIgnoreCase(algorithmName)) {
            secureRandom = SecureRandom.getInstanceStrong();
        } else {
            // Fallback to insecure java.util.Random.
            Random random = new Random();
            byte[] bytes = new byte[numBytes];
            random.nextBytes(bytes);
            return bytes;
        }
        byte[] bytes = new byte[numBytes];
        secureRandom.nextBytes(bytes);
        return bytes;
    }

    // ---------- Usage Examples: Nonce/IV Generation for Symmetric Encryption
    // ----------
    /**
     * Demonstrates secure generation of an IV for AES-GCM encryption. SAST: A
     * unique, random IV is required for each encryption operation.
     *
     * @return A 12-byte IV.
     */
    public byte[] generateRandomIVForGCM() {
        return generateSecureRandomBytes(12);
    }

    /**
     * Demonstrates insecure use of a fixed IV for AES-GCM encryption. SAST:
     * Reusing a fixed IV in AES-GCM compromises security.
     *
     * @return A fixed 12-byte IV (all zeros).
     */
    public byte[] generateFixedIVForGCM() {
        return new byte[12]; // 12 bytes of zeros.
    }

    // ---------- Example: Using PRNG for Key Generation ----------
    /**
     * Generates a secure 256-bit AES key using SecureRandom. SAST: Strong key
     * generation is critical for symmetric cryptography.
     *
     * @return A new AES SecretKey.
     * @throws Exception if key generation fails.
     */
    public SecretKey generateAESKey() throws Exception {
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(256, new SecureRandom());
        return keyGen.generateKey();
    }
}
