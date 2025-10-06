package com.example.crypto.algorithms;

//import org.bouncycastle.jce.provider.BouncyCastleProvider;
import java.security.*;
import java.security.spec.ECGenParameterSpec;
import java.util.Arrays;
import java.util.Base64;
import javax.crypto.Cipher;
import javax.crypto.KeyAgreement;
import javax.crypto.Mac;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;

/**
 * This class demonstrates encryption schemes using elliptic-curve
 * Diffie-Hellman (ECDH) and hybrid encryption methods, including a post-quantum
 * hybrid scheme.
 *
 * SAST/CBOM Classification:
 *
 * 1. EC Key Generation & ECDH Key Agreement: - Parent Classification:
 * Asymmetric Key Generation / Key Agreement. - SAST: Secure when using
 * established curves (secp256r1) and reputable providers (BouncyCastle).
 *
 * 2. ECDH Hybrid Encryption: - Parent Classification: Hybrid Cryptosystem (ECDH
 * + AEAD). - SAST: Uses ECDH for key agreement and AES/GCM for encryption.
 * However, the derivation of an AES key by applying a single SHA-256 hash to
 * the shared secret may be flagged as a weak key derivation method. A dedicated
 * KDF (e.g., HKDF) is recommended.
 *
 * 3. Post-Quantum Hybrid Encryption: - Parent Classification: Hybrid
 * Cryptosystem (Classical ECDH + Post-Quantum Secret + KDF + AEAD). - SAST:
 * Combining classical and post-quantum components is advanced and secure if
 * implemented properly. The custom HKDF expand function provided here is
 * simplistic and may be flagged in a CBOM analysis; a standard HKDF library
 * should be used in production.
 */
public class Encryption2 {

    // static {
    //     Security.addProvider(new BouncyCastleProvider());
    // }
    /**
     * Generates an Elliptic Curve (EC) key pair using the secp256r1 curve.
     *
     * SAST/CBOM Notes: - Algorithm: EC key pair generation. - Parent
     * Classification: Asymmetric Key Generation. - SAST: Considered secure when
     * using strong randomness and a reputable provider.
     *
     * @return an EC KeyPair.
     */
    public KeyPair generateECKeyPair() throws Exception {
        KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance("EC", "BC");
        keyPairGenerator.initialize(new ECGenParameterSpec("secp256r1"), new SecureRandom());
        return keyPairGenerator.generateKeyPair();
    }

    /**
     * Derives a shared secret using Elliptic Curve Diffie-Hellman (ECDH).
     *
     * SAST/CBOM Notes: - Algorithm: ECDH key agreement. - Parent
     * Classification: Asymmetric Key Agreement. - SAST: Secure when both
     * parties use strong EC keys and proper randomness.
     *
     * @param privateKey the private key of one party.
     * @param publicKey the public key of the other party.
     * @return the derived shared secret as a byte array.
     */
    public byte[] deriveSharedSecret(PrivateKey privateKey, PublicKey publicKey) throws Exception {
        KeyAgreement keyAgreement = KeyAgreement.getInstance("ECDH", "BC");
        keyAgreement.init(privateKey);
        keyAgreement.doPhase(publicKey, true);
        return keyAgreement.generateSecret();
    }

    /**
     * Performs hybrid encryption using ECDH to derive a shared secret, then
     * derives an AES key by hashing the shared secret with SHA-256, and finally
     * encrypts the data with AES-GCM.
     *
     * SAST/CBOM Notes: - Parent Classification: Hybrid Cryptosystem (ECDH +
     * AES-GCM). - SAST: While ECDH and AES-GCM are secure, the key derivation
     * method here (a single SHA-256 hash) is not as robust as using a dedicated
     * KDF. This approach may be flagged and is recommended for improvement.
     *
     * @param recipientPublicKey the recipient's public EC key.
     * @param data the plaintext data to encrypt.
     */
    public void ecdhHybridEncryption(PublicKey recipientPublicKey, String data) throws Exception {
        // Generate an ephemeral EC key pair for the sender.
        KeyPair senderKeyPair = generateECKeyPair();
        // Derive the shared secret using ECDH.
        byte[] sharedSecret = deriveSharedSecret(senderKeyPair.getPrivate(), recipientPublicKey);

        // Derive an AES key by hashing the shared secret with SHA-256.
        // SAST Note: Using a direct hash for key derivation is simplistic and may be
        // flagged.
        MessageDigest sha256 = MessageDigest.getInstance("SHA-256");
        byte[] aesKeyBytes = sha256.digest(sharedSecret);
        // Use the first 16 bytes (128 bits) as the AES key.
        SecretKey aesKey = new SecretKeySpec(aesKeyBytes, 0, 16, "AES");

        // Encrypt the data using AES-GCM.
        Cipher aesCipher = Cipher.getInstance("AES/GCM/NoPadding");
        byte[] iv = new byte[12]; // 12-byte IV recommended for GCM.
        new SecureRandom().nextBytes(iv);
        GCMParameterSpec gcmSpec = new GCMParameterSpec(128, iv); // 128-bit authentication tag.
        aesCipher.init(Cipher.ENCRYPT_MODE, aesKey, gcmSpec);
        byte[] encryptedData = aesCipher.doFinal(data.getBytes());

        System.out.println(
                "ECDH Hybrid Encryption - Encrypted Data: " + Base64.getEncoder().encodeToString(encryptedData));
    }

    /**
     * Performs post-quantum hybrid encryption by combining a classical
     * ECDH-derived secret with a post-quantum shared secret. The two secrets
     * are combined using a custom HKDF expansion, and the derived key is used
     * to encrypt data with AES-GCM.
     *
     * SAST/CBOM Notes: - Parent Classification: Hybrid Cryptosystem (Classical
     * ECDH + Post-Quantum Secret + KDF + AES-GCM). - SAST: The combination of
     * classical and post-quantum secrets is a modern approach. However, the
     * custom HKDF expand function is simplistic and may be flagged as insecure.
     * Use a standard HKDF implementation in production.
     *
     * @param ecPublicKey the recipient's EC public key.
     * @param pqSharedSecret the post-quantum shared secret from a separate
     * algorithm.
     */
    public void postQuantumHybridEncryption(PublicKey ecPublicKey, byte[] pqSharedSecret) throws Exception {
        // Step 1: Perform classical ECDH key agreement to derive a shared secret.
        byte[] ecdhSharedSecret = deriveSharedSecret(generateECKeyPair().getPrivate(), ecPublicKey);

        // Step 2: Combine the ECDH secret and the post-quantum secret using a
        // simplified HKDF expansion.
        // SAST Note: This custom HKDF implementation is minimal and does not follow the
        // full HKDF spec.
        byte[] combinedSecret = hkdfExpand(ecdhSharedSecret, pqSharedSecret, 32);
        // Use the first 16 bytes as the AES key (128-bit key).
        SecretKey aesKey = new SecretKeySpec(combinedSecret, 0, 16, "AES");

        // Step 3: Encrypt the data using AES-GCM.
        Cipher aesCipher = Cipher.getInstance("AES/GCM/NoPadding");
        byte[] iv = new byte[12]; // 12-byte IV recommended for GCM.
        new SecureRandom().nextBytes(iv);
        GCMParameterSpec gcmSpec = new GCMParameterSpec(128, iv);
        aesCipher.init(Cipher.ENCRYPT_MODE, aesKey, gcmSpec);
        byte[] encryptedData = aesCipher.doFinal("Post-Quantum Hybrid Encryption Data".getBytes());

        System.out.println("Post-Quantum Hybrid Encryption - Encrypted Data: "
                + Base64.getEncoder().encodeToString(encryptedData));
    }

    /**
     * A simplified HKDF expansion function that uses HMAC-SHA256 to derive a
     * key of a desired length.
     *
     * SAST/CBOM Notes: - Parent Classification: Key Derivation Function (KDF).
     * - SAST: Custom KDF implementations are risky if not thoroughly vetted.
     * This simple HKDF expand function lacks the full HKDF mechanism (e.g.,
     * multiple iterations, info, and context parameters) and may be flagged. It
     * is recommended to use a standardized HKDF library.
     *
     * @param inputKey the input key material.
     * @param salt a salt value (here, the post-quantum shared secret is used as
     * the salt).
     * @param length the desired length of the derived key.
     * @return a derived key of the specified length.
     */
    private byte[] hkdfExpand(byte[] inputKey, byte[] salt, int length) throws Exception {
        Mac hmac = Mac.getInstance("HmacSHA256");
        SecretKey secretKey = new SecretKeySpec(salt, "HmacSHA256");
        hmac.init(secretKey);
        byte[] extractedKey = hmac.doFinal(inputKey);
        return Arrays.copyOf(extractedKey, length);
    }
}
