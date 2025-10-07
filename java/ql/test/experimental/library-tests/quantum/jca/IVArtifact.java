package com.example.crypto.artifacts;

// import org.bouncycastle.jce.provider.BouncyCastleProvider;
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.GCMParameterSpec;
import java.security.*;
import java.util.Base64;
import java.util.random.*;
import java.util.Properties;
import java.util.Random;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Arrays;

public class IVArtifact {

    // static {
    //     Security.addProvider(new BouncyCastleProvider()); // Ensure BouncyCastle is available
    // }
    /**
     * Simple Case: Generates a secure IV and encrypts with
     * AES/CBC/PKCS5Padding.
     */
    public void simpleIVEncryption() throws Exception {
        SecretKey key = generateAESKey();
        IvParameterSpec ivSpec = new IvParameterSpec(secureIV(16));
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.ENCRYPT_MODE, key, ivSpec);
        byte[] ciphertext = cipher.doFinal("Simple Test Data".getBytes());
    }

    public void encryptWithIV(byte[] plaintext, SecretKey key, IvParameterSpec ivSpec, String cipherAlgorithm)
            throws Exception {
        Cipher cipher = Cipher.getInstance(cipherAlgorithm);
        cipher.init(Cipher.ENCRYPT_MODE, key, ivSpec);
        byte[] ciphertext = cipher.doFinal(plaintext);
    }

    public void complexIVFlow() {
        IvParameterSpec ivSpec = new IvParameterSpec(useSecureMethod() ? secureIV(16) : insecureIV(16));
        processIV(ivSpec);

        // Example dynamic cipher selection with IV usage
        String cipherAlgorithm = loadCipherAlgorithm();
        try {
            encryptWithIV("Sensitive Data".getBytes(), generateAESKey(), ivSpec, cipherAlgorithm);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private boolean useSecureMethod() {
        return System.currentTimeMillis() % 2 == 0;
    }

    private void processIV(IvParameterSpec ivSpec) {
        String ivBase64 = Base64.getEncoder().encodeToString(ivSpec.getIV());
    }

    private String loadCipherAlgorithm() {
        Properties properties = new Properties();
        try {
            properties.load(new FileInputStream("crypto-config.properties"));
        } catch (IOException e) {
            e.printStackTrace();
        }
        return properties.getProperty("cipher.algorithm", "AES/CBC/PKCS5Padding");
    }

    private SecretKey generateAESKey() throws NoSuchAlgorithmException {
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(256);
        return keyGen.generateKey();
    }

    private byte[] secureIV(int length) {
        byte[] iv = new byte[length];
        new SecureRandom().nextBytes(iv);
        return iv;
    }

    private byte[] insecureIV(int length) {
        byte[] iv = new byte[length];
        new Random().nextBytes(iv);
        return iv;
    }

    // -------------------------------
    // 1. Direct Fixed IV Usage
    // -------------------------------
    /**
     * Encrypts plaintext using AES-GCM with a fixed IV (all zeros). This is an
     * insecure practice as IV reuse in AES-GCM undermines confidentiality and
     * integrity.
     *
     * @param key The AES key.
     * @param plaintext The plaintext to encrypt.
     * @return The ciphertext.
     * @throws Exception if encryption fails.
     */
    public byte[] encryptWithFixedIV(SecretKey key, byte[] plaintext) throws Exception {
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        byte[] fixedIV = new byte[12]; // 12-byte fixed IV (all zeros)
        GCMParameterSpec spec = new GCMParameterSpec(128, fixedIV);
        cipher.init(Cipher.ENCRYPT_MODE, key, spec);
        return cipher.doFinal(plaintext);
    }

    // -------------------------------
    // 2. Cached IV Usage
    // -------------------------------
    // Cache an IV for reuse in multiple encryptions (insecure)
    private byte[] cachedIV = null;

    /**
     * Encrypts plaintext using AES-GCM with an IV cached from the first call.
     * Reusing the same IV across multiple encryptions is insecure.
     *
     * @param key The AES key.
     * @param plaintext The plaintext to encrypt.
     * @return The ciphertext.
     * @throws Exception if encryption fails.
     */
    public byte[] encryptWithCachedIV(SecretKey key, byte[] plaintext) throws Exception {
        if (cachedIV == null) {
            cachedIV = new byte[12];
            new SecureRandom().nextBytes(cachedIV);
        }
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        GCMParameterSpec spec = new GCMParameterSpec(128, cachedIV);
        cipher.init(Cipher.ENCRYPT_MODE, key, spec);
        return cipher.doFinal(plaintext);
    }

    // -------------------------------
    // 3. Indirect IV Reuse via Deterministic Derivation
    // -------------------------------
    /**
     * Encrypts plaintext using AES-GCM with an IV derived deterministically
     * from a constant. This method computes a SHA-256 hash of a constant string
     * and uses the first 12 bytes as the IV. Such derived IVs are fixed and
     * must not be reused.
     *
     * @param key The AES key.
     * @param plaintext The plaintext to encrypt.
     * @return The ciphertext.
     * @throws Exception if encryption fails.
     */
    public byte[] encryptWithDerivedIV(SecretKey key, byte[] plaintext) throws Exception {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] constantHash = digest.digest("fixedConstant".getBytes("UTF-8"));
        byte[] derivedIV = Arrays.copyOf(constantHash, 12); // Deterministically derived IV
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        GCMParameterSpec spec = new GCMParameterSpec(128, derivedIV);
        cipher.init(Cipher.ENCRYPT_MODE, key, spec);
        return cipher.doFinal(plaintext);
    }

    // -------------------------------
    // 4. Reusing a Single IV Across Multiple Messages
    // -------------------------------
    /**
     * Encrypts an array of plaintext messages using AES-GCM with the same IV
     * for every message. Reusing an IV across messages is insecure in
     * authenticated encryption schemes.
     *
     * @param key The AES key.
     * @param plaintexts An array of plaintext messages.
     * @return An array of ciphertexts.
     * @throws Exception if encryption fails.
     */
    public byte[][] encryptMultipleMessagesWithSameIV(SecretKey key, byte[][] plaintexts) throws Exception {
        byte[] iv = new byte[12];
        new SecureRandom().nextBytes(iv); // Generate once and reuse
        byte[][] ciphertexts = new byte[plaintexts.length][];
        for (int i = 0; i < plaintexts.length; i++) {
            Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
            GCMParameterSpec spec = new GCMParameterSpec(128, iv);
            cipher.init(Cipher.ENCRYPT_MODE, key, spec);
            ciphertexts[i] = cipher.doFinal(plaintexts[i]);
        }
        return ciphertexts;
    }

    /**
     * Encrypts the given plaintext using AES-GCM with the provided key and IV.
     *
     * @param key The AES key.
     * @param ivSpec The IV specification.
     * @param plaintext The plaintext to encrypt.
     * @return The ciphertext (IV is not prepended here for clarity).
     * @throws Exception if encryption fails.
     */
    public byte[] encrypt(SecretKey key, IvParameterSpec ivSpec, byte[] plaintext) throws Exception {
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        // Use 128-bit authentication tag length.
        GCMParameterSpec spec = new GCMParameterSpec(128, ivSpec.getIV());
        cipher.init(Cipher.ENCRYPT_MODE, key, spec);
        return cipher.doFinal(plaintext);
    }

    /**
     * Example 1: Reuses the same IvParameterSpec object across two encryption
     * calls.
     *
     * @param key The AES key.
     * @param plaintext The plaintext to encrypt.
     * @return An array containing two ciphertexts generated with the same
     * IvParameterSpec.
     * @throws Exception if encryption fails.
     */
    public byte[][] encryptUsingSameIvParameterSpec(SecretKey key, byte[] plaintext) throws Exception {
        // Fixed IV (all zeros for demonstration purposes; insecure in production)
        byte[] fixedIV = new byte[12];
        IvParameterSpec fixedIvSpec = new IvParameterSpec(fixedIV);
        // Encrypt the plaintext twice using the same IvParameterSpec.
        byte[] ciphertext1 = encrypt(key, fixedIvSpec, plaintext);
        byte[] ciphertext2 = encrypt(key, fixedIvSpec, plaintext);
        return new byte[][]{ciphertext1, ciphertext2};
    }

    /**
     * Example 2: Creates two different IvParameterSpec objects that share the
     * same underlying IV array.
     *
     * @param key The AES key.
     * @param plaintext The plaintext to encrypt.
     * @return An array containing two ciphertexts generated with two
     * IvParameterSpec objects constructed from the same IV array.
     * @throws Exception if encryption fails.
     */
    public byte[][] encryptUsingDifferentIvSpecSameIVArray(SecretKey key, byte[] plaintext) throws Exception {
        // Create a fixed IV array (all zeros for demonstration; insecure in production)
        byte[] fixedIV = new byte[12];
        // Create two distinct IvParameterSpec objects from the same IV array reference.
        IvParameterSpec ivSpec1 = new IvParameterSpec(fixedIV);
        IvParameterSpec ivSpec2 = new IvParameterSpec(fixedIV);
        // Encrypt the plaintext twice.
        byte[] ciphertext1 = encrypt(key, ivSpec1, plaintext);
        byte[] ciphertext2 = encrypt(key, ivSpec2, plaintext);
        return new byte[][]{ciphertext1, ciphertext2};
    }

    // -------------------------------
    // Main Method for Demonstration
    // -------------------------------
    public static void main(String[] args) {
        try {
            IVArtifact test = new IVArtifact();
            KeyGenerator kg = KeyGenerator.getInstance("AES");
            kg.init(256, new SecureRandom());
            SecretKey key = kg.generateKey();
            byte[] plaintext = "Sensitive Data".getBytes();

            // Example 1: Fixed IV usage
            byte[] fixedIVCipher1 = test.encryptWithFixedIV(key, plaintext);
            byte[] fixedIVCipher2 = test.encryptWithFixedIV(key, plaintext);
            System.out.println("Fixed IV Encryption 1: " + Base64.getEncoder().encodeToString(fixedIVCipher1));
            System.out.println("Fixed IV Encryption 2: " + Base64.getEncoder().encodeToString(fixedIVCipher2));

            // Example 2: Cached IV usage
            byte[] cachedIVCipher1 = test.encryptWithCachedIV(key, plaintext);
            byte[] cachedIVCipher2 = test.encryptWithCachedIV(key, plaintext);
            System.out.println("Cached IV Encryption 1: " + Base64.getEncoder().encodeToString(cachedIVCipher1));
            System.out.println("Cached IV Encryption 2: " + Base64.getEncoder().encodeToString(cachedIVCipher2));

            // Example 3: Indirect IV (derived)
            byte[] derivedIVCipher = test.encryptWithDerivedIV(key, plaintext);
            System.out.println("Derived IV Encryption: " + Base64.getEncoder().encodeToString(derivedIVCipher));

            // Example 4: Reusing the same IV across multiple messages
            byte[][] messages = {"Message One".getBytes(), "Message Two".getBytes(), "Message Three".getBytes()};
            byte[][] multiCiphers = test.encryptMultipleMessagesWithSameIV(key, messages);
            for (int i = 0; i < multiCiphers.length; i++) {
                System.out.println("Multi-message Encryption " + (i + 1) + ": "
                        + Base64.getEncoder().encodeToString(multiCiphers[i]));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
