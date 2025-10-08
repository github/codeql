package com.example.crypto.algorithms;

//import org.bouncycastle.jce.provider.BouncyCastleProvider;
import java.security.*;
import java.util.Base64;
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;

/**
 * This class demonstrates several encryption schemes along with SAST/CBOM
 * classification notes.
 *
 * Methods include:
 *
 * 1. simpleAESEncryption: Uses AES in GCM mode.
 * - CBOM: AES-GCM is classified as secure (Parent: AEAD).
 * - SAST: Secure symmetric encryption pattern; safe when used properly.
 *
 * 2. insecureAESWithECB: Uses AES in ECB mode.
 * - CBOM: AES-ECB is classified as insecure (Parent: SymmetricEncryption).
 * - SAST: Insecure encryption pattern; flagged as vulnerable due to lack of IV
 * and predictable structure.
 *
 * 3. rsaOaepEncryption / rsaOaepDecryption: Use RSA with OAEP padding.
 * - CBOM: RSA-OAEP is classified as secure for public-key encryption (Parent:
 * Hybrid Cryptosystem).
 * - SAST: Secure for small payloads/key encapsulation; must only encrypt small
 * data blocks.
 *
 * 4. rsaKemEncryption: Demonstrates a key encapsulation mechanism (KEM) using
 * RSA-OAEP.
 * - CBOM: RSA-KEM is recognized as secure (Parent: RSA-OAEP based KEM).
 * - SAST: Secure when used to encapsulate symmetric keys in a hybrid system.
 *
 * 5. hybridEncryption: Combines RSA-OAEP for key encapsulation with AES-GCM for
 * data encryption.
 * - CBOM: Hybrid encryption (Parent: RSA-OAEP + AES-GCM) is classified as
 * secure.
 * - SAST: Secure hybrid encryption pattern; recommended for large data
 * encryption.
 */
public class Encryption1 {

    // static {
    //     Security.addProvider(new BouncyCastleProvider());
    // }

    /**
     * Simple AES-GCM encryption.
     *
     * SAST/CBOM Notes:
     * - Algorithm: AES/GCM/NoPadding with a 256-bit key.
     * - Parent Classification: AEAD (Authenticated Encryption with Associated
     * Data).
     * - SAST: Considered safe when properly implemented (uses IV and tag).
     */
    public void simpleAESEncryption() throws Exception {
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(256); // 256-bit AES key.
        SecretKey key = keyGen.generateKey();
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        byte[] iv = new byte[12]; // 12-byte IV recommended for GCM.
        new SecureRandom().nextBytes(iv);
        GCMParameterSpec gcmSpec = new GCMParameterSpec(128, iv); // 128-bit authentication tag.
        cipher.init(Cipher.ENCRYPT_MODE, key, gcmSpec);
        byte[] encryptedData = cipher.doFinal("Sensitive Data".getBytes());
        System.out.println("AES-GCM Encrypted Data: " + Base64.getEncoder().encodeToString(encryptedData));
    }

    /**
     * Insecure AES encryption using ECB mode.
     *
     * SAST/CBOM Notes:
     * - Algorithm: AES/ECB/NoPadding with a 256-bit key.
     * - Parent Classification: SymmetricEncryption (ECB mode is inherently
     * insecure).
     * - SAST: Flagged as vulnerable; ECB mode does not use an IV and reveals data
     * patterns.
     */
    public void insecureAESWithECB() throws Exception {
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(256); // 256-bit AES key.
        SecretKey key = keyGen.generateKey();
        // AES/ECB mode is insecure due to the deterministic nature of the block cipher
        // without an IV.
        Cipher cipher = Cipher.getInstance("AES/ECB/NoPadding");
        cipher.init(Cipher.ENCRYPT_MODE, key);
        byte[] encryptedData = cipher.doFinal("Sensitive Data".getBytes());
        System.out.println("AES-ECB Encrypted Data (Insecure): " + Base64.getEncoder().encodeToString(encryptedData));
    }

    /**
     * RSA encryption using OAEP with SHA-256 and MGF1 padding.
     *
     * SAST/CBOM Notes:
     * - Algorithm: RSA/ECB/OAEPWithSHA-256AndMGF1Padding.
     * - Parent Classification: Hybrid Cryptosystem. RSA-OAEP is commonly used in
     * hybrid schemes.
     * - SAST: Secure for encrypting small payloads or for key encapsulation;
     * caution when encrypting large data.
     */
    public void rsaOaepEncryption(PublicKey publicKey, String data) throws Exception {
        Cipher cipher = Cipher.getInstance("RSA/ECB/OAEPWithSHA-256AndMGF1Padding");
        cipher.init(Cipher.ENCRYPT_MODE, publicKey);
        byte[] encryptedData = cipher.doFinal(data.getBytes());
        System.out.println("RSA-OAEP Encrypted Data: " + Base64.getEncoder().encodeToString(encryptedData));
    }

    /**
     * RSA decryption using OAEP with SHA-256 and MGF1 padding.
     *
     * SAST/CBOM Notes:
     * - Algorithm: RSA/ECB/OAEPWithSHA-256AndMGF1Padding.
     * - Parent Classification: Hybrid Cryptosystem.
     * - SAST: Secure when used with the correct corresponding private key.
     */
    public void rsaOaepDecryption(PrivateKey privateKey, byte[] encryptedData) throws Exception {
        Cipher cipher = Cipher.getInstance("RSA/ECB/OAEPWithSHA-256AndMGF1Padding");
        cipher.init(Cipher.DECRYPT_MODE, privateKey);
        byte[] decryptedData = cipher.doFinal(encryptedData);
        System.out.println("Decrypted RSA-OAEP Data: " + new String(decryptedData));
    }

    /**
     * RSA-KEM encryption: encapsulates an AES key using RSA-OAEP.
     *
     * SAST/CBOM Notes:
     * - Algorithm: RSA-OAEP used as a Key Encapsulation Mechanism (KEM) for an AES
     * key.
     * - Parent Classification: RSA-OAEP based KEM.
     * - SAST: Recognized as a secure key encapsulation pattern; used as part of
     * hybrid encryption schemes.
     */
    public void rsaKemEncryption(PublicKey rsaPublicKey) throws Exception {
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(256); // 256-bit AES key.
        SecretKey aesKey = keyGen.generateKey();

        Cipher rsaCipher = Cipher.getInstance("RSA/ECB/OAEPWithSHA-256AndMGF1Padding");
        rsaCipher.init(Cipher.ENCRYPT_MODE, rsaPublicKey);
        byte[] encryptedAesKey = rsaCipher.doFinal(aesKey.getEncoded());

        System.out.println("RSA-KEM Encrypted AES Key: " + Base64.getEncoder().encodeToString(encryptedAesKey));
    }

    /**
     * Hybrid encryption: combines RSA-OAEP for key encapsulation with AES-GCM for
     * data encryption.
     *
     * SAST/CBOM Notes:
     * - Algorithms: RSA-OAEP (for encrypting the AES key) and AES-GCM (for
     * encrypting the data).
     * - Parent Classification: Hybrid Cryptosystem (RSA-OAEP + AES-GCM).
     * - SAST: This pattern is considered secure when implemented correctly;
     * recommended for large data encryption.
     */
    public void hybridEncryption(PublicKey rsaPublicKey, String data) throws Exception {
        // Generate a 256-bit AES key for symmetric encryption.
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(256);
        SecretKey aesKey = keyGen.generateKey();

        // Encrypt the AES key using RSA-OAEP.
        Cipher rsaCipher = Cipher.getInstance("RSA/ECB/OAEPWithSHA-256AndMGF1Padding");
        rsaCipher.init(Cipher.ENCRYPT_MODE, rsaPublicKey);
        byte[] encryptedAesKey = rsaCipher.doFinal(aesKey.getEncoded());

        // Encrypt the actual data using AES-GCM.
        Cipher aesCipher = Cipher.getInstance("AES/GCM/NoPadding");
        byte[] iv = new byte[12]; // 12-byte IV recommended for GCM.
        new SecureRandom().nextBytes(iv);
        GCMParameterSpec gcmSpec = new GCMParameterSpec(128, iv);
        aesCipher.init(Cipher.ENCRYPT_MODE, aesKey, gcmSpec);
        byte[] encryptedData = aesCipher.doFinal(data.getBytes());

        System.out.println(
                "Hybrid Encryption - Encrypted AES Key: " + Base64.getEncoder().encodeToString(encryptedAesKey));
        System.out.println("Hybrid Encryption - Encrypted Data: " + Base64.getEncoder().encodeToString(encryptedData));
    }
}
