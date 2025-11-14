package com.example.crypto.algorithms;

// import org.bouncycastle.jce.provider.BouncyCastleProvider;
// import org.bouncycastle.pqc.jcajce.provider.BouncyCastlePQCProvider;
// import org.bouncycastle.pqc.jcajce.spec.KyberParameterSpec;
// import org.bouncycastle.util.Strings;
import java.security.*;
import java.security.spec.ECGenParameterSpec;
import java.util.Base64;
import javax.crypto.Cipher;
import javax.crypto.KeyAgreement;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;

/**
 * Demonstrates various Key Encapsulation Mechanisms (KEMs), including:
 *
 * 1) RSA-KEM (emulated using RSA-OAEP for ephemeral key wrapping) - CBOM/SAST:
 * Classified as a Hybrid Cryptosystem (public-key based key encapsulation).
 * While RSA-OAEP is secure, using it to emulate KEM (without a standard scheme)
 * may be flagged.
 *
 * 2) ECIES (Elliptic Curve Integrated Encryption Scheme) - CBOM/SAST:
 * Classified as a Hybrid Cryptosystem (KEM+DEM) based on ECDH and AES. Note:
 * Directly using the raw ECDH shared secret as key material is insecure in
 * production.
 *
 * 3) Kyber (Post-Quantum KEM using BouncyCastle PQC) - CBOM/SAST: Classified as
 * a Post-Quantum Key Encapsulation mechanism. This is modern and secure when
 * using standardized parameters.
 *
 * 4) Basic ephemeral flows that mimic KEM logic using ephemeral ECDH. -
 * CBOM/SAST: Classified as a simple KEM mimic based on ephemeral ECDH.
 */
public class KeyEncapsulation {

    // static {
    //     // Adding both classical and PQC providers.
    //     Security.addProvider(new BouncyCastleProvider());
    //     Security.addProvider(new BouncyCastlePQCProvider());
    // }
    //////////////////////////////////////
    // 1. RSA-KEM-Like Flow
    //////////////////////////////////////

    /**
     * Emulates RSA-KEM by using RSA-OAEP to wrap a random AES key.
     *
     * SAST/CBOM Classification:
     * - Parent: Hybrid Cryptosystem (RSA-OAEP based key encapsulation).
     * - Note: Although RSA-OAEP is secure, using it to "wrap" an ephemeral key is a
     * non-standard KEM pattern.
     *
     * @param rsaPub The RSA public key of the recipient.
     */
    public void rsaKEMEncapsulation(PublicKey rsaPub) throws Exception {
        // 1) Generate an ephemeral AES key (symmetric key for data encryption)
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(256); // 256-bit AES key.
        SecretKey aesKey = keyGen.generateKey();
        System.out.println("Ephemeral AES Key: " + Base64.getEncoder().encodeToString(aesKey.getEncoded()));

        // 2) Encrypt (wrap) the ephemeral AES key with RSA-OAEP.
        // SAST Note: This RSA-OAEP wrapping is used to encapsulate the AES key.
        Cipher rsaCipher = Cipher.getInstance("RSA/ECB/OAEPWithSHA-256AndMGF1Padding");
        rsaCipher.init(Cipher.ENCRYPT_MODE, rsaPub);
        byte[] wrappedKey = rsaCipher.doFinal(aesKey.getEncoded());
        System.out.println("RSA-KEM Encapsulated AES Key: " + Base64.getEncoder().encodeToString(wrappedKey));

        // 3) Example usage: Encrypt data with the ephemeral AES key using AES-GCM.
        Cipher aesCipher = Cipher.getInstance("AES/GCM/NoPadding");
        byte[] iv = new byte[12]; // Standard IV length for GCM.
        new SecureRandom().nextBytes(iv);
        GCMParameterSpec gcmSpec = new GCMParameterSpec(128, iv);
        aesCipher.init(Cipher.ENCRYPT_MODE, aesKey, gcmSpec);
        byte[] ciphertext = aesCipher.doFinal("KEM-based encryption".getBytes());
        System.out.println("AES-GCM ciphertext: " + Base64.getEncoder().encodeToString(ciphertext));
    }

    /**
     * Performs RSA decapsulation by decrypting the wrapped AES key.
     *
     * SAST/CBOM Classification: - Parent: Hybrid Cryptosystem (RSA-OAEP based
     * key decapsulation). - Note: Secure when used with matching RSA key pairs.
     *
     * @param rsaPriv The RSA private key corresponding to the public key used.
     * @param wrappedKey The RSA-wrapped ephemeral AES key.
     */
    public void rsaKEMDecapsulation(PrivateKey rsaPriv, byte[] wrappedKey) throws Exception {
        Cipher rsaCipher = Cipher.getInstance("RSA/ECB/OAEPWithSHA-256AndMGF1Padding");
        rsaCipher.init(Cipher.DECRYPT_MODE, rsaPriv);
        byte[] aesKeyBytes = rsaCipher.doFinal(wrappedKey);
        SecretKey aesKey = new SecretKeySpec(aesKeyBytes, "AES");
        System.out.println("RSA-KEM Decapsulated AES Key: " + Base64.getEncoder().encodeToString(aesKey.getEncoded()));
    }

    //////////////////////////////////////
    // 2. ECIES Example
    //////////////////////////////////////

    /**
     * Implements a simplified ECIES flow using ephemeral ECDH and AES-GCM.
     *
     * SAST/CBOM Classification:
     * - Parent: Hybrid Cryptosystem (ECIES: ECDH-based key encapsulation + DEM).
     * - Note: Directly using the raw ECDH shared secret as key material is
     * insecure.
     * In practice, a proper KDF must be applied.
     *
     * @param ecPub The recipient's EC public key.
     */
    public void eciesEncapsulation(PublicKey ecPub) throws Exception {
        // Generate an ephemeral EC key pair.
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("EC");
        kpg.initialize(new ECGenParameterSpec("secp256r1"), new SecureRandom());
        KeyPair ephemeralEC = kpg.generateKeyPair();

        // Perform ECDH key agreement to derive the shared secret.
        KeyAgreement ka = KeyAgreement.getInstance("ECDH");
        ka.init(ephemeralEC.getPrivate());
        ka.doPhase(ecPub, true);
        byte[] sharedSecret = ka.generateSecret();
        System.out.println("ECIES ephemeral ECDH Secret: " + Base64.getEncoder().encodeToString(sharedSecret));

        // For demonstration only: directly use part of the shared secret as an AES key.
        // SAST Note: This is insecure; a proper key derivation function (KDF) must be
        // used.
        SecretKey aesKey = new SecretKeySpec(sharedSecret, 0, 16, "AES");

        // Encrypt the message using AES-GCM.
        Cipher aesCipher = Cipher.getInstance("AES/GCM/NoPadding");
        byte[] iv = new byte[12];
        new SecureRandom().nextBytes(iv);
        aesCipher.init(Cipher.ENCRYPT_MODE, aesKey, new GCMParameterSpec(128, iv));
        byte[] ciphertext = aesCipher.doFinal("ECIES message".getBytes());

        // The ephemeral public key (ephemeralEC.getPublic()) is transmitted as part of
        // the output.
        System.out.println(
                "ECIES ephemeral public: " + Base64.getEncoder().encodeToString(ephemeralEC.getPublic().getEncoded()));
        System.out.println("ECIES ciphertext: " + Base64.getEncoder().encodeToString(ciphertext));
    }

    //////////////////////////////////////
    // 3. Kyber Example (Post-Quantum KEM)
    //////////////////////////////////////

    // /**
    //  * Demonstrates a Kyber-based encapsulation using BouncyCastle's PQC provider.
    //  *
    //  * SAST/CBOM Classification:
    //  * - Parent: Post-Quantum KEM.
    //  * - Note: Kyber is a modern, post-quantum secure KEM. This example uses
    //  * Kyber-512.
    //  *
    //  * @param kyberRecipientKP The recipient's Kyber key pair.
    //  */
    // public void kyberEncapsulate(KeyPair kyberRecipientKP) throws Exception {
    //     // Use an ephemeral label for demonstration.
    //     byte[] ephemeralLabel = Strings.toByteArray("Kyber-KEM-Label");
    //     Cipher kemCipher = Cipher.getInstance("Kyber", "BCPQC");
    //     kemCipher.init(Cipher.ENCRYPT_MODE, kyberRecipientKP.getPublic(), new SecureRandom());
    //     byte[] ciphertext = kemCipher.doFinal(ephemeralLabel);
    //     System.out.println("Kyber ciphertext: " + Base64.getEncoder().encodeToString(ciphertext));
    // }

    //////////////////////////////////////
    // 4. Basic Ephemeral Flows That Mimic KEM
    //////////////////////////////////////

    /**
     * Uses ephemeral ECDH to derive a shared secret that mimics a KEM.
     *
     * SAST/CBOM Classification:
     * - Parent: Ephemeral Key Agreement (mimicking KEM).
     * - Note: This simple approach demonstrates the concept of using ephemeral keys
     * to derive a secret.
     * In a full scheme, the ephemeral public key would also be transmitted.
     *
     * @param recipientPubKey The recipient's public key.
     */
    public void ephemeralECDHMimicKEM(PublicKey recipientPubKey) throws Exception {
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("EC");
        kpg.initialize(new ECGenParameterSpec("secp256r1"));
        KeyPair ephemeralKP = kpg.generateKeyPair();
        KeyAgreement ka = KeyAgreement.getInstance("ECDH");
        ka.init(ephemeralKP.getPrivate());
        ka.doPhase(recipientPubKey, true);
        byte[] sharedSecret = ka.generateSecret();
        System.out.println(
                "Ephemeral ECDH shared secret (mimics KEM): " + Base64.getEncoder().encodeToString(sharedSecret));
        // In a full implementation, the ephemeral public key and the shared secret are
        // used together.
    }

    //////////////////////////////////////
    // Test / Demo Method
    //////////////////////////////////////

    /**
     * Demonstrates each of the key encapsulation flows.
     */
    public void runKeyEncapsulationDemos() throws Exception {
        // 1) RSA-KEM-like Flow:
        KeyPairGenerator rsaKpg = KeyPairGenerator.getInstance("RSA");
        rsaKpg.initialize(2048);
        KeyPair rsaKP = rsaKpg.generateKeyPair();
        rsaKEMEncapsulation(rsaKP.getPublic());

        // 2) ECIES Example:
        KeyPairGenerator ecKpg = KeyPairGenerator.getInstance("EC");
        ecKpg.initialize(new ECGenParameterSpec("secp256r1"));
        KeyPair ecKP = ecKpg.generateKeyPair();
        eciesEncapsulation(ecKP.getPublic());

        // // 3) Kyber Example (Post-Quantum KEM):
        // KeyPairGenerator kyberKpg = KeyPairGenerator.getInstance("Kyber", "BCPQC");
        // kyberKpg.initialize(KyberParameterSpec.kyber512);
        // KeyPair kyberKP = kyberKpg.generateKeyPair();
        // kyberEncapsulate(kyberKP);
        // 4) Ephemeral ECDH Mimic KEM:
        // For demonstration, we use an EC key pair and mimic KEM by deriving a shared
        // secret.
        KeyPair ephemeralEC = ecKpg.generateKeyPair();
        ephemeralECDHMimicKEM(ephemeralEC.getPublic());
    }
}
