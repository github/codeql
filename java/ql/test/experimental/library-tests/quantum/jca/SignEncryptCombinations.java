package com.example.crypto.algorithms;

// import org.bouncycastle.jce.provider.BouncyCastleProvider;
import java.security.*;
import java.security.spec.ECGenParameterSpec;
import java.util.Arrays;
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.Mac;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;

/**
 * This class demonstrates cryptographic flows combining signing, encryption,
 * and MAC.
 *
 * It intentionally includes both safe and unsafe patterns so that a SAST tool
 * can detect:
 *
 * 1. **Sign then Encrypt (Unsafe)** - Signs the plaintext and encrypts only the
 * signature, leaving the plaintext in cleartext. - *Issue:* The message is
 * exposed, which could lead to replay or modification attacks.
 *
 * 2. **Encrypt then Sign (Safe with caveats)** - Encrypts the plaintext and
 * then signs the ciphertext. - *Caveat:* The signature is in the clear;
 * metadata (e.g. ciphertext length) may be exposed.
 *
 * 3. **MAC then Encrypt (Unsafe)** - Computes a MAC on the plaintext and
 * appends it before encryption. - *Issue:* Operating on plaintext for MAC
 * generation can leak information and is discouraged.
 *
 * 4. **Encrypt then MAC (Safe)** - Encrypts the plaintext and computes a MAC
 * over the ciphertext. - *Benefit:* Provides a robust authenticated encryption
 * construction when not using an AEAD cipher.
 *
 * Note: AES/GCM already provides authentication, so adding an external MAC is
 * redundant.
 */
public class SignEncryptCombinations {

    private static final SecureRandom RANDOM = new SecureRandom();

    // static {
    //     Security.addProvider(new BouncyCastleProvider());
    // }
    ///////////////////////////////////////////////
    // Key Generation for ECDSA on secp256r1
    ///////////////////////////////////////////////

    public KeyPair generateECDSAKeyPair() throws Exception {
        KeyPairGenerator ecKpg = KeyPairGenerator.getInstance("EC", "BC");
        ecKpg.initialize(new ECGenParameterSpec("secp256r1"), RANDOM);
        return ecKpg.generateKeyPair();
    }

    ///////////////////////////////////////////////
    // Signing with ECDSA (SHA256withECDSA)
    ///////////////////////////////////////////////

    public byte[] signECDSA(PrivateKey privKey, byte[] data) throws Exception {
        Signature signature = Signature.getInstance("SHA256withECDSA", "BC");
        signature.initSign(privKey, RANDOM);
        signature.update(data);
        return signature.sign();
    }

    public boolean verifyECDSA(PublicKey pubKey, byte[] data, byte[] signatureBytes) throws Exception {
        Signature signature = Signature.getInstance("SHA256withECDSA", "BC");
        signature.initVerify(pubKey);
        signature.update(data);
        return signature.verify(signatureBytes);
    }

    ///////////////////////////////////////////////
    // Symmetric Encryption with AES-GCM
    ///////////////////////////////////////////////

    /**
     * Generates a 256-bit AES key.
     */
    public SecretKey generateAESKey() throws Exception {
        KeyGenerator kg = KeyGenerator.getInstance("AES");
        kg.init(256);
        return kg.generateKey();
    }

    /**
     * Encrypts data using AES-GCM with a 12-byte IV and a 128-bit tag. Returns
     * the concatenation of IV and ciphertext.
     */
    public byte[] encryptAESGCM(SecretKey key, byte[] plaintext) throws Exception {
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        byte[] iv = new byte[12]; // 12-byte IV recommended for GCM
        RANDOM.nextBytes(iv);
        GCMParameterSpec spec = new GCMParameterSpec(128, iv);
        cipher.init(Cipher.ENCRYPT_MODE, key, spec);
        byte[] ciphertext = cipher.doFinal(plaintext);

        byte[] result = new byte[iv.length + ciphertext.length];
        System.arraycopy(iv, 0, result, 0, iv.length);
        System.arraycopy(ciphertext, 0, result, iv.length, ciphertext.length);
        return result;
    }

    /**
     * Decrypts data that was encrypted using encryptAESGCM.
     */
    public byte[] decryptAESGCM(SecretKey key, byte[] ivCiphertext) throws Exception {
        byte[] iv = Arrays.copyOfRange(ivCiphertext, 0, 12);
        byte[] ciphertext = Arrays.copyOfRange(ivCiphertext, 12, ivCiphertext.length);
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        cipher.init(Cipher.DECRYPT_MODE, key, new GCMParameterSpec(128, iv));
        return cipher.doFinal(ciphertext);
    }

    ///////////////////////////////////////////////
    // HMAC Usage with HMAC-SHA256
    ///////////////////////////////////////////////

    public byte[] computeHmacSHA256(SecretKey key, byte[] data) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(key);
        return mac.doFinal(data);
    }

    public boolean verifyHmacSHA256(SecretKey key, byte[] data, byte[] givenMac) throws Exception {
        byte[] computed = computeHmacSHA256(key, data);
        return Arrays.equals(computed, givenMac);
    }

    ///////////////////////////////////////////////
    // 1) SIGN THEN ENCRYPT vs. ENCRYPT THEN SIGN
    ///////////////////////////////////////////////

    /**
     * UNSAFE FLOW: Signs the plaintext and encrypts only the signature.
     *
     * <p>
     * **Issue:** The plaintext message is not encrypted, only the signature is.
     * This exposes the original message to eavesdroppers and negates the purpose of
     * encryption.
     * </p>
     *
     * @param signingKey    ECDSA private key for signing.
     * @param encryptionKey AES key for encryption.
     * @param data          The plaintext message.
     * @return The encrypted signature only.
     */
    public byte[] signThenEncrypt(PrivateKey signingKey, SecretKey encryptionKey, byte[] data) throws Exception {
        // Sign the plaintext message.
        byte[] signature = signECDSA(signingKey, data);
        // **** UNSAFE: Only the signature is encrypted. The plaintext remains in the
        // clear. ****
        return encryptAESGCM(encryptionKey, signature);
    }

    /**
     * Decrypts the signature and verifies it against the original plaintext.
     */
    public boolean decryptThenVerify(SecretKey encryptionKey, PublicKey verifyingKey, byte[] encryptedSig,
            byte[] originalData) throws Exception {
        byte[] decryptedSig = decryptAESGCM(encryptionKey, encryptedSig);
        return verifyECDSA(verifyingKey, originalData, decryptedSig);
    }

    /**
     * SAFE FLOW (with caveats): Encrypts the plaintext and then signs the
     * ciphertext.
     *
     * <p>
     * **Benefit:** The plaintext is fully encrypted and remains confidential.
     * **Caveat:** The signature is transmitted in the clear. Although this does
     * not compromise the message, it might reveal metadata (like ciphertext
     * length).
     * </p>
     *
     * @param encryptionKey AES key for encryption.
     * @param signingKey ECDSA private key for signing.
     * @param data The plaintext message.
     * @return The concatenation of the ciphertext and its signature.
     */
    public byte[] encryptThenSign(SecretKey encryptionKey, PrivateKey signingKey, byte[] data) throws Exception {
        // Encrypt the plaintext.
        byte[] ivCiphertext = encryptAESGCM(encryptionKey, data);
        // Sign the ciphertext.
        byte[] signature = signECDSA(signingKey, ivCiphertext);

        // Combine ciphertext and signature.
        byte[] combined = new byte[ivCiphertext.length + signature.length];
        System.arraycopy(ivCiphertext, 0, combined, 0, ivCiphertext.length);
        System.arraycopy(signature, 0, combined, ivCiphertext.length, signature.length);
        return combined;
    }

    /**
     * Extracts and verifies the signature from the combined
     * ciphertext-signature bundle, then decrypts the ciphertext.
     *
     * <p>
     * **Issue:** Here we assume a fixed signature length (70 bytes). In
     * production, the signature length should be explicitly stored. Hard-coding
     * a length is an unsafe pattern and may trigger SAST warnings.
     * </p>
     *
     * @param verifyingKey ECDSA public key for signature verification.
     * @param encryptionKey AES key for decryption.
     * @param combined The combined ciphertext and signature.
     * @return The decrypted plaintext message.
     */
    public byte[] verifyThenDecrypt(PublicKey verifyingKey, SecretKey encryptionKey, byte[] combined) throws Exception {
        int assumedSignatureLength = 70; // UNSAFE: Hard-coded signature length.
        if (combined.length < assumedSignatureLength) {
            throw new IllegalArgumentException("Combined data too short.");
        }
        int ctLen = combined.length - assumedSignatureLength;
        byte[] ivCiphertext = Arrays.copyOfRange(combined, 0, ctLen);
        byte[] signature = Arrays.copyOfRange(combined, ctLen, combined.length);

        if (!verifyECDSA(verifyingKey, ivCiphertext, signature)) {
            throw new SecurityException("Signature verification failed.");
        }
        return decryptAESGCM(encryptionKey, ivCiphertext);
    }

    ///////////////////////////////////////////////
    // 2) MAC THEN ENCRYPT vs. ENCRYPT THEN MAC
    ///////////////////////////////////////////////

    /**
     * UNSAFE FLOW: Computes a MAC on the plaintext, appends it to the plaintext,
     * and then encrypts the combined data.
     *
     * <p>
     * **Issue:** Operating on unencrypted plaintext to compute the MAC can leak
     * structural
     * information. Additionally, if the encryption scheme does not provide
     * integrity,
     * this construction is vulnerable.
     * </p>
     *
     * @param macKey AES key used as the HMAC key (should be separate from the
     *               encryption key).
     * @param encKey AES key for encryption.
     * @param data   The plaintext message.
     * @return The encrypted (plaintext + MAC) bundle.
     */
    public byte[] macThenEncrypt(SecretKey macKey, SecretKey encKey, byte[] data) throws Exception {
        // Compute MAC over the plaintext.
        byte[] mac = computeHmacSHA256(macKey, data);
        // Combine plaintext and MAC.
        byte[] combined = new byte[data.length + mac.length];
        System.arraycopy(data, 0, combined, 0, data.length);
        System.arraycopy(mac, 0, combined, data.length, mac.length);
        // **** UNSAFE: The MAC is computed on plaintext, which can leak information.
        // ****
        return encryptAESGCM(encKey, combined);
    }

    /**
     * Decrypts the combined data and verifies the MAC.
     *
     * @param macKey AES key used as the HMAC key.
     * @param encKey AES key for decryption.
     * @param ciphertext The encrypted bundle containing plaintext and MAC.
     * @return true if the MAC is valid; false otherwise.
     */
    public boolean decryptThenVerifyMac(SecretKey macKey, SecretKey encKey, byte[] ciphertext) throws Exception {
        byte[] combined = decryptAESGCM(encKey, ciphertext);
        if (combined.length < 32) { // HMAC-SHA256 produces a 32-byte MAC.
            throw new IllegalArgumentException("Combined data too short for MAC verification.");
        }
        int dataLen = combined.length - 32;
        byte[] originalData = Arrays.copyOfRange(combined, 0, dataLen);
        byte[] extractedMac = Arrays.copyOfRange(combined, dataLen, combined.length);
        return verifyHmacSHA256(macKey, originalData, extractedMac);
    }

    /**
     * SAFE FLOW: Encrypts the plaintext and then computes a MAC over the
     * ciphertext.
     *
     * <p>
     * **Benefit:** This "encrypt-then-MAC" construction ensures that the
     * ciphertext is both confidential and tamper-evident.
     * </p>
     *
     * @param encKey AES key for encryption.
     * @param macKey AES key used as the HMAC key.
     * @param data The plaintext message.
     * @return The concatenation of ciphertext and MAC.
     */
    public byte[] encryptThenMac(SecretKey encKey, SecretKey macKey, byte[] data) throws Exception {
        // Encrypt the plaintext.
        byte[] ivCiphertext = encryptAESGCM(encKey, data);
        // Compute MAC over the ciphertext.
        byte[] mac = computeHmacSHA256(macKey, ivCiphertext);
        // Combine ciphertext and MAC.
        byte[] combined = new byte[ivCiphertext.length + mac.length];
        System.arraycopy(ivCiphertext, 0, combined, 0, ivCiphertext.length);
        System.arraycopy(mac, 0, combined, ivCiphertext.length, mac.length);
        return combined;
    }

    /**
     * Verifies the MAC and then decrypts the ciphertext.
     *
     * @param encKey AES key for decryption.
     * @param macKey AES key used as the HMAC key.
     * @param combined The combined ciphertext and MAC.
     * @return The decrypted plaintext message.
     */
    public byte[] verifyMacThenDecrypt(SecretKey encKey, SecretKey macKey, byte[] combined) throws Exception {
        if (combined.length < 32) {
            throw new IllegalArgumentException("Combined data too short for MAC verification.");
        }
        int macOffset = combined.length - 32;
        byte[] ivCiphertext = Arrays.copyOfRange(combined, 0, macOffset);
        byte[] extractedMac = Arrays.copyOfRange(combined, macOffset, combined.length);
        if (!verifyHmacSHA256(macKey, ivCiphertext, extractedMac)) {
            throw new SecurityException("MAC verification failed.");
        }
        return decryptAESGCM(encKey, ivCiphertext);
    }

    ///////////////////////////////////////////////
    // Demo: runAllCombinations
    ///////////////////////////////////////////////

    public void runAllCombinations() throws Exception {
        // Generate keys for signing and for encryption/MAC.
        KeyPair signingKeys = generateECDSAKeyPair();
        SecretKey encKey = generateAESKey();
        SecretKey macKey = generateAESKey(); // Ensure a separate key for MAC operations.

        byte[] message = "Hello, combinations!".getBytes();

        // 1) Sign then Encrypt (Unsafe) vs. Encrypt then Sign (Safe with caveats)
        System.out.println("--Sign Then Encrypt (UNSAFE)");
        byte[] encryptedSig = signThenEncrypt(signingKeys.getPrivate(), encKey, message);
        boolean steVerified = decryptThenVerify(encKey, signingKeys.getPublic(), encryptedSig, message);
        System.out.println("signThenEncrypt -> signature verified? " + steVerified);

        System.out.println("--Encrypt Then Sign (SAFE with caveats)");
        byte[] combinedETS = encryptThenSign(encKey, signingKeys.getPrivate(), message);
        byte[] finalPlain = verifyThenDecrypt(signingKeys.getPublic(), encKey, combinedETS);
        System.out.println("encryptThenSign -> decrypted message: " + new String(finalPlain));

        // 2) MAC then Encrypt (Unsafe) vs. Encrypt then MAC (Safe)
        System.out.println("--MAC Then Encrypt (UNSAFE)");
        byte[] mteCipher = macThenEncrypt(macKey, encKey, message);
        boolean mteVerified = decryptThenVerifyMac(macKey, encKey, mteCipher);
        System.out.println("macThenEncrypt -> MAC verified? " + mteVerified);

        System.out.println("--Encrypt Then MAC (SAFE)");
        byte[] etmCombined = encryptThenMac(encKey, macKey, message);
        byte[] etmPlain = verifyMacThenDecrypt(encKey, macKey, etmCombined);
        System.out.println("encryptThenMac -> decrypted message: " + new String(etmPlain));
    }
}
