package com.example.crypto.artifacts;

// import org.bouncycastle.jce.provider.BouncyCastleProvider;
import javax.crypto.KeyGenerator;
import javax.crypto.Mac;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.Cipher;
import java.security.*;
import java.util.Base64;
import java.util.Random;

public class Nonce {

    // static {
    //     Security.addProvider(new BouncyCastleProvider()); // Ensure BouncyCastle is available
    // }
    /**
     * Simple Case: Generates a secure nonce and uses it in HMAC.
     */
    public void simpleNonceUsage() throws Exception {
        byte[] nonce = secureNonce(16);
        SecretKey key = generateHmacKey();
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(key);
        mac.update(nonce);
        byte[] macResult = mac.doFinal("Simple Test Data".getBytes());
    }

    /**
     * Incorrect: Hardcoded, reused nonce in encryption, leading to predictable
     * output.
     */
    public void hardcodedNonceReuse() throws Exception {
        byte[] nonce = "BADNONCEBADNONCE".getBytes(); // HARDCODED NONCE REUSED!
        SecretKey key = generateHmacKey();
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(key);
        mac.update(nonce);
        byte[] macResult = mac.doFinal("Sensitive Data".getBytes());
    }

    /**
     * Incorrect: Reusing a nonce with AES-GCM, which can lead to catastrophic
     * security failures.
     */
    public void insecureNonceReuseGCM(SecretKey key, byte[] plaintext) throws Exception {
        byte[] nonce = getReusedNonce(12); // SAME NONCE REUSED!
        GCMParameterSpec gcmSpec = new GCMParameterSpec(128, nonce);
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        cipher.init(Cipher.ENCRYPT_MODE, key, gcmSpec);
        byte[] ciphertext = cipher.doFinal(plaintext);
    }

    /**
     * Secure Case: Proper unique nonce usage in AES-GCM.
     */
    public void secureNonceUsageGCM(SecretKey key, byte[] plaintext) throws Exception {
        byte[] nonce = secureNonce(12);
        GCMParameterSpec gcmSpec = new GCMParameterSpec(128, nonce);
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        cipher.init(Cipher.ENCRYPT_MODE, key, gcmSpec);
        byte[] ciphertext = cipher.doFinal(plaintext);
    }

    public void complexNonceFlow() {
        byte[] nonce = useSecureMethod() ? secureNonce(16) : insecureNonce(16);
        processNonce(nonce);
        try {
            useNonceInMac(nonce, generateHmacKey(), "HmacSHA256");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void useNonceInMac(byte[] nonce, SecretKey key, String macAlgorithm) throws Exception {
        Mac mac = Mac.getInstance(macAlgorithm);
        mac.init(key);
        mac.update(nonce);
        byte[] macResult = mac.doFinal("Sensitive Data".getBytes());
    }

    private boolean useSecureMethod() {
        return System.currentTimeMillis() % 2 == 0;
    }

    private void processNonce(byte[] nonce) {
        String nonceBase64 = Base64.getEncoder().encodeToString(nonce);
    }

    private SecretKey generateHmacKey() throws NoSuchAlgorithmException {
        KeyGenerator keyGen = KeyGenerator.getInstance("HmacSHA256");
        return keyGen.generateKey();
    }

    private byte[] secureNonce(int length) {
        byte[] nonce = new byte[length];
        new SecureRandom().nextBytes(nonce);
        return nonce;
    }

    private byte[] insecureNonce(int length) {
        byte[] nonce = new byte[length];
        new Random().nextBytes(nonce);
        return nonce;
    }

    /**
     * Incorrect: A nonce that is stored and reused across multiple encryptions.
     */
    private byte[] getReusedNonce(int length) {
        return "BADNONCEBADNONCE".getBytes(); // Fixed nonce reuse across calls
    }
}
