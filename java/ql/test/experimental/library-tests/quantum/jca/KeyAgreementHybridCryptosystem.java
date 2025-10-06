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
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;

/**
 * KeyAgreementHybridCryptosystem demonstrates two hybrid cryptosystems:
 *
 * 1. ECDH + AES-GCM: - Secure Flow: Uses ephemeral ECDH key pairs on secp256r1,
 * applies a simple KDF (SHA-256) to derive a 128-bit AES key, and uses AES-GCM
 * with a random 12-byte nonce. - Insecure Flow: Reuses a static key pair, uses
 * raw shared secret truncation, and employs a fixed (zero) IV.
 *
 * 2. X25519 + ChaCha20-Poly1305: - Secure Flow: Uses ephemeral X25519 key
 * pairs, applies a KDF (SHA-256) to derive a 256-bit key, and uses
 * ChaCha20-Poly1305 with a random nonce. - Insecure Flow: Reuses a static key
 * pair, directly truncates the shared secret without a proper KDF, and uses a
 * fixed nonce.
 *
 * SAST/CBOM Notes: - Secure flows use proper ephemeral key generation, a simple
 * KDF, and random nonces. - Insecure flows use static keys, fixed nonces, and
 * raw shared secret truncation.
 */
public class KeyAgreementHybridCryptosystem {

    // static {
    //     Security.addProvider(new BouncyCastleProvider());
    //     Security.addProvider(new BouncyCastlePQCProvider());
    // }
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

    // ===============================================
    // 1. ECDH + AES-GCM Flows
    // ===============================================
    /**
     * Secure hybrid encryption using ECDH and AES-GCM. Uses ephemeral key
     * pairs, applies a simple KDF to derive a 128-bit AES key, and uses AES-GCM
     * with a random 12-byte nonce.
     */
    public byte[] secureECDH_AESGCMEncryption(byte[] plaintext) throws Exception {
        KeyPair aliceKP = generateECDHKeyPair();
        KeyPair bobKP = generateECDHKeyPair();
        byte[] aliceSecret = deriveSharedSecret(aliceKP.getPrivate(), bobKP.getPublic(), "ECDH");
        byte[] aesKeyBytes = simpleKDF(aliceSecret, 16);
        SecretKey aesKey = new SecretKeySpec(aesKeyBytes, "AES");

        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        byte[] iv = new byte[12];
        new SecureRandom().nextBytes(iv);
        GCMParameterSpec spec = new GCMParameterSpec(128, iv);
        cipher.init(Cipher.ENCRYPT_MODE, aesKey, spec);
        byte[] ciphertext = cipher.doFinal(plaintext);

        return concatenate(iv, ciphertext);
    }

    /**
     * Insecure hybrid encryption using ECDH and AES-GCM. Reuses a static key
     * pair, uses raw shared secret truncation without a proper KDF, and employs
     * a fixed IV (all zeros).
     */
    public byte[] insecureECDH_AESGCMEncryption(byte[] plaintext) throws Exception {
        KeyPair staticKP = generateECDHKeyPair();
        byte[] sharedSecret = deriveSharedSecret(staticKP.getPrivate(), staticKP.getPublic(), "ECDH");
        byte[] aesKeyBytes = Arrays.copyOf(sharedSecret, 16);
        SecretKey aesKey = new SecretKeySpec(aesKeyBytes, "AES");

        byte[] fixedIV = new byte[12]; // fixed IV (all zeros)
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        GCMParameterSpec spec = new GCMParameterSpec(128, fixedIV);
        cipher.init(Cipher.ENCRYPT_MODE, aesKey, spec);
        byte[] ciphertext = cipher.doFinal(plaintext);

        return concatenate(fixedIV, ciphertext);
    }

    // ===============================================
    // 2. X25519 + ChaCha20-Poly1305 Flows
    // ===============================================
    /**
     * Secure hybrid encryption using X25519 and ChaCha20-Poly1305. Uses
     * ephemeral key pairs, applies a KDF (SHA-256) to derive a 256-bit key, and
     * uses ChaCha20-Poly1305 with a random 12-byte nonce.
     */
    public byte[] secureX25519_Chacha20Poly1305Encryption(byte[] plaintext) throws Exception {
        KeyPair aliceKP = generateX25519KeyPair();
        KeyPair bobKP = generateX25519KeyPair();
        byte[] sharedSecret = deriveSharedSecret(aliceKP.getPrivate(), bobKP.getPublic(), "X25519");
        byte[] chachaKeyBytes = MessageDigest.getInstance("SHA-256").digest(sharedSecret);
        SecretKey chachaKey = new SecretKeySpec(chachaKeyBytes, "ChaCha20");

        Cipher cipher = Cipher.getInstance("ChaCha20-Poly1305", "BC");
        byte[] nonce = new byte[12];
        new SecureRandom().nextBytes(nonce);
        cipher.init(Cipher.ENCRYPT_MODE, chachaKey, new IvParameterSpec(nonce));
        byte[] ciphertext = cipher.doFinal(plaintext);

        return concatenate(nonce, ciphertext);
    }

    /**
     * Insecure hybrid encryption using X25519 and ChaCha20-Poly1305. Reuses a
     * static key pair, directly truncates the shared secret without a proper
     * KDF, and employs a fixed nonce.
     */
    public byte[] insecureX25519_Chacha20Poly1305Encryption(byte[] plaintext) throws Exception {
        KeyPair staticKP = generateX25519KeyPair();
        byte[] sharedSecret = deriveSharedSecret(staticKP.getPrivate(), staticKP.getPublic(), "X25519");
        byte[] chachaKeyBytes = Arrays.copyOf(sharedSecret, 32);
        SecretKey chachaKey = new SecretKeySpec(chachaKeyBytes, "ChaCha20");

        byte[] fixedNonce = new byte[12]; // fixed nonce (all zeros)
        Cipher cipher = Cipher.getInstance("ChaCha20-Poly1305", "BC");
        cipher.init(Cipher.ENCRYPT_MODE, chachaKey, new IvParameterSpec(fixedNonce));
        byte[] ciphertext = cipher.doFinal(plaintext);

        return concatenate(fixedNonce, ciphertext);
    }

    // ===============================================
    // 3. Dynamic Hybrid Selection
    // ===============================================
    /**
     * Dynamically selects a hybrid encryption flow based on a configuration
     * property. If the config is unknown, defaults to an insecure flow.
     */
    public String dynamicHybridEncryption(String config, byte[] plaintext) throws Exception {
        byte[] result;
        if ("secureECDH".equalsIgnoreCase(config)) {
            result = secureECDH_AESGCMEncryption(plaintext);
        } else if ("insecureECDH".equalsIgnoreCase(config)) {
            result = insecureECDH_AESGCMEncryption(plaintext);
        } else if ("secureX25519".equalsIgnoreCase(config)) {
            result = secureX25519_Chacha20Poly1305Encryption(plaintext);
        } else if ("insecureX25519".equalsIgnoreCase(config)) {
            result = insecureX25519_Chacha20Poly1305Encryption(plaintext);
        } else {
            // Fallback to insecure ECDH flow.
            result = insecureECDH_AESGCMEncryption(plaintext);
        }
        return Base64.getEncoder().encodeToString(result);
    }

    // ===============================================
    // 4. Further Key Derivation from Symmetric Keys
    // ===============================================
    /**
     * Derives two keys from a symmetric key using PBKDF2, then uses one key for
     * AES-GCM encryption and the other for computing a MAC over the ciphertext.
     */
    public byte[] furtherUseSymmetricKeyForKeyDerivation(SecretKey key, byte[] plaintext) throws Exception {
        String keyAsString = Base64.getEncoder().encodeToString(key.getEncoded());
        byte[] salt = generateSalt(16);
        PBEKeySpec spec = new PBEKeySpec(keyAsString.toCharArray(), salt, 10000, 256);
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
        byte[] derived = factory.generateSecret(spec).getEncoded();
        byte[] encKeyBytes = Arrays.copyOfRange(derived, 0, 16);
        byte[] macKeyBytes = Arrays.copyOfRange(derived, 16, 32);
        SecretKey encryptionKey = new SecretKeySpec(encKeyBytes, "AES");
        SecretKey derivedMacKey = new SecretKeySpec(macKeyBytes, "HmacSHA256");

        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        byte[] iv = new byte[12];
        new SecureRandom().nextBytes(iv);
        GCMParameterSpec specGcm = new GCMParameterSpec(128, iv);
        cipher.init(Cipher.ENCRYPT_MODE, encryptionKey, specGcm);
        byte[] ciphertext = cipher.doFinal(plaintext);

        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(derivedMacKey);
        byte[] computedMac = mac.doFinal(ciphertext);

        byte[] output = new byte[ciphertext.length + computedMac.length];
        System.arraycopy(ciphertext, 0, output, 0, ciphertext.length);
        System.arraycopy(computedMac, 0, output, ciphertext.length, computedMac.length);
        storeOutput(output);
        return output;
    }

    // ===============================================
    // 5. Output/Storage Methods
    // ===============================================
    /**
     * Stores the output securely.
     */
    public void storeOutput(byte[] output) {
        String stored = Base64.getEncoder().encodeToString(output);
        // In production, this value would be stored or transmitted securely.
    }

    // ===============================================
    // 6. Helper Methods for Key/Nonce Generation
    // ===============================================
    /**
     * Generates a secure 256-bit AES key.
     */
    public SecretKey generateAESKey() throws Exception {
        KeyGenerator kg = KeyGenerator.getInstance("AES");
        kg.init(256, new SecureRandom());
        return kg.generateKey();
    }

    /**
     * Generates a random salt.
     */
    private byte[] generateSalt(int length) {
        byte[] salt = new byte[length];
        new SecureRandom().nextBytes(salt);
        return salt;
    }
}
