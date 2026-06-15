package com.example.crypto.algorithms;

// import org.bouncycastle.jce.provider.BouncyCastleProvider;
// import org.bouncycastle.pqc.jcajce.provider.BouncyCastlePQCProvider;
import java.security.*;
import java.security.spec.ECGenParameterSpec;
import java.util.Arrays;
import java.util.Base64;
import javax.crypto.Cipher;
import javax.crypto.KeyAgreement;
import javax.crypto.KeyGenerator;
import javax.crypto.Mac;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;

/**
 * AsymmetricEncryptionMacHybridCryptosystem demonstrates hybrid cryptosystems
 * that combine asymmetric encryption with a MAC.
 *
 * Flows: 1. RSA-OAEP + HMAC: - Secure Flow: Uses 2048-bit RSA-OAEP (with
 * SHA256andMGF1Padding) to encapsulate a freshly generated AES key; then
 * encrypts using AES-GCM with a random nonce and computes HMAC-SHA256 over the
 * ciphertext. - Insecure Flow: Uses 1024-bit RSA (RSA/ECB/PKCS1Padding),
 * AES-GCM with a fixed IV, and HMAC-SHA1.
 *
 * 2. ECIES + HMAC: - Secure Flow: Uses ephemeral ECDH key pairs (secp256r1);
 * derives a shared secret and applies a simple KDF (SHA-256) to derive a
 * 128-bit AES key; then uses AES-GCM with a random nonce and computes
 * HMAC-SHA256. - Insecure Flow: Reuses a static EC key pair, directly truncates
 * the shared secret without a proper KDF, uses a fixed IV, and computes
 * HMAC-SHA1.
 *
 * 3. Dynamic Hybrid Selection: - Chooses between flows based on a configuration
 * string.
 *
 * SAST/CBOM Notes: - Secure flows use proper ephemeral key generation, secure
 * key sizes, KDF usage, and random nonces/IVs. - Insecure flows (static key
 * reuse, fixed nonces, weak key sizes, raw shared secret truncation, and
 * deprecated algorithms) should be flagged.
 */
public class AsymmetricEncryptionMacHybridCryptosystem {

    // static {
    //     Security.addProvider(new BouncyCastleProvider());
    //     Security.addProvider(new BouncyCastlePQCProvider());
    // }
    // ---------- Result Class ----------
    public static class HybridResult {

        private final byte[] encapsulatedKey;
        private final byte[] ciphertext;
        private final byte[] mac;

        public HybridResult(byte[] encapsulatedKey, byte[] ciphertext, byte[] mac) {
            this.encapsulatedKey = encapsulatedKey;
            this.ciphertext = ciphertext;
            this.mac = mac;
        }

        public byte[] getEncapsulatedKey() {
            return encapsulatedKey;
        }

        public byte[] getCiphertext() {
            return ciphertext;
        }

        public byte[] getMac() {
            return mac;
        }

        public String toBase64String() {
            return "EncapsulatedKey: " + Base64.getEncoder().encodeToString(encapsulatedKey)
                    + "\nCiphertext: " + Base64.getEncoder().encodeToString(ciphertext)
                    + "\nMAC: " + Base64.getEncoder().encodeToString(mac);
        }
    }

    // ---------- Helper Methods ----------
    /**
     * Generates an ephemeral ECDH key pair on secp256r1.
     */
    public KeyPair generateECDHKeyPair() throws Exception {
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("EC", "BC");
        kpg.initialize(new ECGenParameterSpec("secp256r1"), new SecureRandom());
        return kpg.generateKeyPair();
    }

    /**
     * Generates an ephemeral X25519 key pair.
     */
    public KeyPair generateX25519KeyPair() throws Exception {
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("X25519", "BC");
        kpg.initialize(255, new SecureRandom());
        return kpg.generateKeyPair();
    }

    /**
     * Derives a shared secret using the provided key agreement algorithm.
     *
     * @param privateKey The private key.
     * @param publicKey The corresponding public key.
     * @param algorithm The key agreement algorithm (e.g., "ECDH" or "X25519").
     * @return The shared secret.
     */
    public byte[] deriveSharedSecret(PrivateKey privateKey, PublicKey publicKey, String algorithm) throws Exception {
        KeyAgreement ka = KeyAgreement.getInstance(algorithm, "BC");
        ka.init(privateKey);
        ka.doPhase(publicKey, true);
        return ka.generateSecret();
    }

    /**
     * A simple KDF that hashes the input with SHA-256 and returns the first
     * numBytes.
     *
     * @param input The input byte array.
     * @param numBytes The desired number of output bytes.
     * @return The derived key material.
     */
    public byte[] simpleKDF(byte[] input, int numBytes) throws Exception {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hash = digest.digest(input);
        return Arrays.copyOf(hash, numBytes);
    }

    /**
     * Concatenates two byte arrays.
     */
    public byte[] concatenate(byte[] a, byte[] b) {
        byte[] result = new byte[a.length + b.length];
        System.arraycopy(a, 0, result, 0, a.length);
        System.arraycopy(b, 0, result, a.length, b.length);
        return result;
    }

    // =====================================================
    // 1. RSA-OAEP + HMAC Hybrid Cryptosystem
    // =====================================================
    /**
     * Generates a secure 2048-bit RSA key pair.
     */
    public KeyPair generateRSAKeyPairGood() throws Exception {
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("RSA");
        kpg.initialize(2048);
        return kpg.generateKeyPair();
    }

    /**
     * Generates an insecure 1024-bit RSA key pair.
     */
    public KeyPair generateRSAKeyPairBad() throws Exception {
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("RSA");
        kpg.initialize(1024);
        return kpg.generateKeyPair();
    }

    /**
     * Secure hybrid encryption using RSA-OAEP + HMAC-SHA256.
     */
    public HybridResult secureRSAHybridEncryption(byte[] plaintext) throws Exception {
        KeyPair rsaKP = generateRSAKeyPairGood();
        SecretKey aesKey = generateAESKey();

        Cipher rsaCipher = Cipher.getInstance("RSA/ECB/OAEPWithSHA-256AndMGF1Padding");
        rsaCipher.init(Cipher.WRAP_MODE, rsaKP.getPublic());
        byte[] encapsulatedKey = rsaCipher.wrap(aesKey);

        byte[] iv = new byte[12];
        new SecureRandom().nextBytes(iv);
        Cipher aesCipher = Cipher.getInstance("AES/GCM/NoPadding");
        aesCipher.init(Cipher.ENCRYPT_MODE, aesKey, new GCMParameterSpec(128, iv));
        byte[] ciphertext = aesCipher.doFinal(plaintext);
        byte[] fullCiphertext = concatenate(iv, ciphertext);

        byte[] macKey = generateAESKey().getEncoded();
        byte[] mac = secureHMACSHA256(new String(fullCiphertext), macKey);

        return new HybridResult(encapsulatedKey, fullCiphertext, mac);
    }

    /**
     * Insecure hybrid encryption using RSA/ECB/PKCS1Padding + HMAC-SHA1.
     */
    public HybridResult insecureRSAHybridEncryption(byte[] plaintext) throws Exception {
        KeyPair rsaKP = generateRSAKeyPairBad();
        SecretKey aesKey = generateAESKey();

        Cipher rsaCipher = Cipher.getInstance("RSA/ECB/PKCS1Padding");
        rsaCipher.init(Cipher.WRAP_MODE, rsaKP.getPublic());
        byte[] encapsulatedKey = rsaCipher.wrap(aesKey);

        byte[] fixedIV = new byte[12]; // All zeros
        Cipher aesCipher = Cipher.getInstance("AES/GCM/NoPadding");
        aesCipher.init(Cipher.ENCRYPT_MODE, aesKey, new GCMParameterSpec(128, fixedIV));
        byte[] ciphertext = aesCipher.doFinal(plaintext);
        byte[] fullCiphertext = concatenate(fixedIV, ciphertext);

        byte[] macKey = generateAESKey().getEncoded();
        byte[] mac = insecureHMACSHA1(new String(fullCiphertext), macKey);

        return new HybridResult(encapsulatedKey, fullCiphertext, mac);
    }

    // =====================================================
    // 2. ECIES + HMAC Hybrid Cryptosystem
    // =====================================================
    /**
     * Secure hybrid encryption using ECIES (via ECDH) + HMAC-SHA256.
     */
    public HybridResult secureECIESHybridEncryption(byte[] plaintext) throws Exception {
        KeyPair aliceKP = generateECDHKeyPair();
        KeyPair bobKP = generateECDHKeyPair();
        byte[] sharedSecret = deriveSharedSecret(aliceKP.getPrivate(), bobKP.getPublic(), "ECDH");
        byte[] aesKeyBytes = simpleKDF(sharedSecret, 16);
        SecretKey aesKey = new SecretKeySpec(aesKeyBytes, "AES");

        byte[] iv = new byte[12];
        new SecureRandom().nextBytes(iv);
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        cipher.init(Cipher.ENCRYPT_MODE, aesKey, new GCMParameterSpec(128, iv));
        byte[] ciphertext = cipher.doFinal(plaintext);
        byte[] fullCiphertext = concatenate(iv, ciphertext);

        byte[] macKey = generateAESKey().getEncoded();
        byte[] mac = secureHMACSHA256(new String(fullCiphertext), macKey);

        byte[] ephemeralPubKey = aliceKP.getPublic().getEncoded();

        return new HybridResult(ephemeralPubKey, fullCiphertext, mac);
    }

    /**
     * Insecure hybrid encryption using ECIES (via ECDH) + HMAC-SHA1.
     */
    public HybridResult insecureECIESHybridEncryption(byte[] plaintext) throws Exception {
        KeyPair staticKP = generateECDHKeyPair();
        byte[] sharedSecret = deriveSharedSecret(staticKP.getPrivate(), staticKP.getPublic(), "ECDH");
        byte[] aesKeyBytes = Arrays.copyOf(sharedSecret, 16);
        SecretKey aesKey = new SecretKeySpec(aesKeyBytes, "AES");

        byte[] fixedIV = new byte[12]; // Fixed IV
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        cipher.init(Cipher.ENCRYPT_MODE, aesKey, new GCMParameterSpec(128, fixedIV));
        byte[] ciphertext = cipher.doFinal(plaintext);
        byte[] fullCiphertext = concatenate(fixedIV, ciphertext);

        byte[] macKey = generateAESKey().getEncoded();
        byte[] mac = insecureHMACSHA1(new String(fullCiphertext), macKey);

        byte[] staticPubKey = staticKP.getPublic().getEncoded();

        return new HybridResult(staticPubKey, fullCiphertext, mac);
    }

    // =====================================================
    // 3. Dynamic Hybrid Selection
    // =====================================================
    /**
     * Dynamically selects a hybrid encryption flow based on configuration.
     * SAST: Dynamic selection introduces risk if insecure defaults are chosen.
     *
     * @param config The configuration string ("secureRSA", "insecureRSA",
     * "secureECIES", "insecureECIES").
     * @param plaintext The plaintext to encrypt.
     * @return A Base64-encoded string representation of the hybrid encryption
     * result.
     * @throws Exception if an error occurs.
     */
    public String dynamicHybridEncryption(String config, byte[] plaintext) throws Exception {
        HybridResult result;
        if ("secureRSA".equalsIgnoreCase(config)) {
            result = secureRSAHybridEncryption(plaintext);
        } else if ("insecureRSA".equalsIgnoreCase(config)) {
            result = insecureRSAHybridEncryption(plaintext);
        } else if ("secureECIES".equalsIgnoreCase(config)) {
            result = secureECIESHybridEncryption(plaintext);
        } else if ("insecureECIES".equalsIgnoreCase(config)) {
            result = insecureECIESHybridEncryption(plaintext);
        } else {
            // Fallback to insecure RSA hybrid encryption.
            result = insecureRSAHybridEncryption(plaintext);
        }
        return result.toBase64String();
    }

    // =====================================================
    // 4. Helper Methods for HMAC and Symmetric Encryption
    // =====================================================
    /**
     * Secure HMAC using HMAC-SHA256. SAST: HMAC-SHA256 is secure.
     */
    public byte[] secureHMACSHA256(String message, byte[] key) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256", "BC");
        SecretKey secretKey = new SecretKeySpec(key, "HmacSHA256");
        mac.init(secretKey);
        return mac.doFinal(message.getBytes());
    }

    /**
     * Insecure HMAC using HMAC-SHA1. SAST: HMAC-SHA1 is deprecated and
     * insecure.
     */
    public byte[] insecureHMACSHA1(String message, byte[] key) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA1", "BC");
        SecretKey secretKey = new SecretKeySpec(key, "HmacSHA1");
        mac.init(secretKey);
        return mac.doFinal(message.getBytes());
    }

    // =====================================================
    // 5. Helper Methods for Key/Nonce Generation
    // =====================================================
    /**
     * Generates a secure 256-bit AES key. SAST: Uses SecureRandom for key
     * generation.
     */
    public SecretKey generateAESKey() throws Exception {
        KeyGenerator kg = KeyGenerator.getInstance("AES");
        kg.init(256, new SecureRandom());
        return kg.generateKey();
    }
}
