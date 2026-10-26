package com.example.crypto.algorithms;

// import org.bouncycastle.jce.provider.BouncyCastleProvider;
import java.security.*;
import java.util.Arrays;
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.IvParameterSpec;

public class ChainedEncryptionTest {

    // static {
    //     Security.addProvider(new BouncyCastleProvider());
    // }
    // Encrypts using AES-GCM. Returns IV concatenated with ciphertext.
    public static byte[] encryptAESGCM(SecretKey key, byte[] plaintext) throws Exception {
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        byte[] iv = new byte[12]; // 12-byte nonce for AES-GCM
        new SecureRandom().nextBytes(iv);
        GCMParameterSpec spec = new GCMParameterSpec(128, iv);
        cipher.init(Cipher.ENCRYPT_MODE, key, spec);
        byte[] ciphertext = cipher.doFinal(plaintext);
        return concat(iv, ciphertext);
    }

    // Decrypts AES-GCM ciphertext where IV is prepended.
    public static byte[] decryptAESGCM(SecretKey key, byte[] ivCiphertext) throws Exception {
        byte[] iv = Arrays.copyOfRange(ivCiphertext, 0, 12);
        byte[] ciphertext = Arrays.copyOfRange(ivCiphertext, 12, ivCiphertext.length);
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        GCMParameterSpec spec = new GCMParameterSpec(128, iv);
        cipher.init(Cipher.DECRYPT_MODE, key, spec);
        return cipher.doFinal(ciphertext);
    }

    // Encrypts using ChaCha20-Poly1305. Returns nonce concatenated with ciphertext.
    public static byte[] encryptChaCha20Poly1305(SecretKey key, byte[] plaintext) throws Exception {
        Cipher cipher = Cipher.getInstance("ChaCha20-Poly1305", "BC");
        byte[] nonce = new byte[12]; // 12-byte nonce for ChaCha20-Poly1305
        new SecureRandom().nextBytes(nonce);
        cipher.init(Cipher.ENCRYPT_MODE, key, new IvParameterSpec(nonce));
        byte[] ciphertext = cipher.doFinal(plaintext);
        return concat(nonce, ciphertext);
    }

    // Decrypts ChaCha20-Poly1305 ciphertext where nonce is prepended.
    public static byte[] decryptChaCha20Poly1305(SecretKey key, byte[] nonceCiphertext) throws Exception {
        byte[] nonce = Arrays.copyOfRange(nonceCiphertext, 0, 12);
        byte[] ciphertext = Arrays.copyOfRange(nonceCiphertext, 12, nonceCiphertext.length);
        Cipher cipher = Cipher.getInstance("ChaCha20-Poly1305", "BC");
        cipher.init(Cipher.DECRYPT_MODE, key, new IvParameterSpec(nonce));
        return cipher.doFinal(ciphertext);
    }

    // Helper method to concatenate two byte arrays.
    private static byte[] concat(byte[] a, byte[] b) {
        byte[] result = new byte[a.length + b.length];
        System.arraycopy(a, 0, result, 0, a.length);
        System.arraycopy(b, 0, result, a.length, b.length);
        return result;
    }

    /**
     * Performs chained encryption and decryption in one function. First,
     * plaintext is encrypted with AES-GCM (inner layer), then that ciphertext
     * is encrypted with ChaCha20-Poly1305 (outer layer). The decryption process
     * reverses these steps.
     *
     * @param plaintext The input plaintext.
     * @return The decrypted plaintext as a String.
     * @throws Exception if any cryptographic operation fails.
     */
    public static String chainEncryptDecrypt(String plaintext) throws Exception {
        byte[] plainBytes = plaintext.getBytes("UTF-8");

        // Generate keys for inner and outer encryption.
        KeyGenerator aesGen = KeyGenerator.getInstance("AES");
        aesGen.init(256, new SecureRandom());
        SecretKey innerKey = aesGen.generateKey();

        KeyGenerator chachaGen = KeyGenerator.getInstance("ChaCha20", "BC");
        chachaGen.init(256, new SecureRandom());
        SecretKey outerKey = chachaGen.generateKey();

        // Inner Encryption with AES-GCM.
        byte[] aesIV = new byte[12]; // Random 12-byte IV.
        new SecureRandom().nextBytes(aesIV);
        Cipher aesCipher = Cipher.getInstance("AES/GCM/NoPadding");
        GCMParameterSpec gcmSpec = new GCMParameterSpec(128, aesIV);
        aesCipher.init(Cipher.ENCRYPT_MODE, innerKey, gcmSpec);
        byte[] innerCiphertext = aesCipher.doFinal(plainBytes);

        // Outer Encryption with ChaCha20-Poly1305.
        byte[] chachaNonce = new byte[12]; // Random 12-byte nonce.
        new SecureRandom().nextBytes(chachaNonce);
        Cipher chachaCipher = Cipher.getInstance("ChaCha20-Poly1305", "BC");
        chachaCipher.init(Cipher.ENCRYPT_MODE, outerKey, new IvParameterSpec(chachaNonce));
        byte[] outerCiphertext = chachaCipher.doFinal(innerCiphertext);

        // Outer Decryption.
        Cipher chachaDec = Cipher.getInstance("ChaCha20-Poly1305", "BC");
        chachaDec.init(Cipher.DECRYPT_MODE, outerKey, new IvParameterSpec(chachaNonce));
        byte[] decryptedInnerCiphertext = chachaDec.doFinal(outerCiphertext);

        // Inner Decryption.
        Cipher aesDec = Cipher.getInstance("AES/GCM/NoPadding");
        aesDec.init(Cipher.DECRYPT_MODE, innerKey, new GCMParameterSpec(128, aesIV));
        byte[] decryptedPlaintext = aesDec.doFinal(decryptedInnerCiphertext);

        return new String(decryptedPlaintext, "UTF-8");
    }

    public static void main(String[] args) throws Exception {
        // Generate a 256-bit AES key for the first (inner) encryption.
        KeyGenerator aesGen = KeyGenerator.getInstance("AES");
        aesGen.init(256, new SecureRandom());
        SecretKey aesKey = aesGen.generateKey();

        // Generate a 256-bit key for ChaCha20-Poly1305 (outer encryption).
        KeyGenerator chaChaGen = KeyGenerator.getInstance("ChaCha20");
        chaChaGen.init(256, new SecureRandom());
        SecretKey chaChaKey = chaChaGen.generateKey();

        String originalText = "This is a secret message.";
        byte[] plaintext = originalText.getBytes();

        // Step 1: Encrypt plaintext with AES-GCM.
        byte[] innerCiphertext = encryptAESGCM(aesKey, plaintext);

        // Step 2: Encrypt the AES-GCM ciphertext with ChaCha20-Poly1305.
        byte[] outerCiphertext = encryptChaCha20Poly1305(chaChaKey, innerCiphertext);

        // Now, decrypt in reverse order.
        // Step 3: Decrypt the outer layer (ChaCha20-Poly1305).
        byte[] decryptedInnerCiphertext = decryptChaCha20Poly1305(chaChaKey, outerCiphertext);

        // Step 4: Decrypt the inner layer (AES-GCM).
        byte[] decryptedPlaintext = decryptAESGCM(aesKey, decryptedInnerCiphertext);

        System.out.println("Original: " + originalText);
        System.out.println("Decrypted: " + new String(decryptedPlaintext));
    }

}
