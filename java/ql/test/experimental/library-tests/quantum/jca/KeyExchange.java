package com.example.crypto.algorithms;

// import org.bouncycastle.jce.provider.BouncyCastleProvider;
import java.security.*;
import java.security.spec.ECGenParameterSpec;
import java.util.Arrays;
import java.util.Base64;
import javax.crypto.KeyAgreement;

/**
 * Demonstrates various Key Exchange mechanisms using standard Java and
 * BouncyCastle:
 *
 * 1) Classic DH (Diffie-Hellman) with multiple key sizes: - 512-bit:
 * Insecure/deprecated (flagged as unsafe by SAST). - 2048-bit: Standard secure
 * level. - 4096-bit: High-security (but can be slow).
 *
 * 2) ECDH (using secp256r1): - Classified as a secure elliptic-curve key
 * exchange.
 *
 * 3) X25519: - A modern and efficient elliptic-curve key exchange protocol.
 *
 * 4) X448: - Provides a higher security level for key exchange.
 *
 * In addition, the class now includes a nuanced insecure example that
 * demonstrates: - Reusing static key pairs instead of generating fresh
 * ephemeral keys. - Using weak parameters (512-bit DH) in a key exchange.
 *
 * The runAllExchanges() method demonstrates generating keys for each algorithm,
 * deriving shared secrets, and comparing safe vs. insecure practices.
 */
public class KeyExchange {

    // static {
    //     // Add the BouncyCastle provider to support additional algorithms.
    //     Security.addProvider(new BouncyCastleProvider());
    // }
    //////////////////////////////////////////
    // 1. Classic DH (Diffie-Hellman)
    //////////////////////////////////////////

    /**
     * Generates a standard Diffie-Hellman key pair using a 2048-bit modulus.
     *
     * CBOM/SAST Classification:
     * - Parent: Classic Diffie-Hellman Key Exchange.
     * - 2048-bit is considered secure and is widely accepted.
     *
     * @return A 2048-bit DH KeyPair.
     */
    public KeyPair generateDHKeyPair() throws Exception {
        KeyPairGenerator dhKpg = KeyPairGenerator.getInstance("DH");
        dhKpg.initialize(2048);
        return dhKpg.generateKeyPair();
    }

    /**
     * Generates a deprecated/unsafe Diffie-Hellman key pair using a 512-bit
     * modulus.
     *
     * CBOM/SAST Classification: - Parent: Classic Diffie-Hellman Key Exchange.
     * - 512-bit DH is considered insecure and should be flagged by SAST tools.
     *
     * @return A 512-bit (insecure) DH KeyPair.
     */
    public KeyPair generateDHDeprecated() throws Exception {
        KeyPairGenerator dhKpg = KeyPairGenerator.getInstance("DH");
        // 512 bits is considered insecure/deprecated.
        dhKpg.initialize(512);
        return dhKpg.generateKeyPair();
    }

    /**
     * Generates a high-security Diffie-Hellman key pair using a 4096-bit
     * modulus.
     *
     * CBOM/SAST Classification: - Parent: Classic Diffie-Hellman Key Exchange.
     * - 4096-bit DH offers high security, though it may be slower in practice.
     *
     * @return A 4096-bit DH KeyPair.
     */
    public KeyPair generateDHHighSecurity() throws Exception {
        KeyPairGenerator dhKpg = KeyPairGenerator.getInstance("DH");
        dhKpg.initialize(4096);
        return dhKpg.generateKeyPair();
    }

    /**
     * Derives a shared secret from a DH key pair.
     *
     * CBOM/SAST Classification: - Parent: Classic Diffie-Hellman Key Exchange.
     * - Properly deriving the shared secret is secure if using a safe key size.
     *
     * @param privateKey The private key of one party.
     * @param publicKey The public key of the other party.
     * @return The derived shared secret as a byte array.
     */
    public byte[] deriveDHSecret(PrivateKey privateKey, PublicKey publicKey) throws Exception {
        KeyAgreement ka = KeyAgreement.getInstance("DH");
        ka.init(privateKey);
        ka.doPhase(publicKey, true);
        return ka.generateSecret();
    }

    //////////////////////////////////////////
    // 2. ECDH (secp256r1)
    //////////////////////////////////////////

    /**
     * Generates an Elliptic Curve Diffie-Hellman key pair using the secp256r1
     * curve.
     *
     * CBOM/SAST Classification:
     * - Parent: Elliptic Curve Diffie-Hellman (ECDH).
     * - secp256r1 is widely regarded as secure and efficient.
     *
     * @return An ECDH KeyPair on secp256r1.
     */
    public KeyPair generateECDHKeyPair() throws Exception {
        KeyPairGenerator ecKpg = KeyPairGenerator.getInstance("EC", "BC");
        ecKpg.initialize(new ECGenParameterSpec("secp256r1"), new SecureRandom());
        return ecKpg.generateKeyPair();
    }

    /**
     * Derives a shared secret using ECDH.
     *
     * CBOM/SAST Classification: - Parent: Elliptic Curve Diffie-Hellman (ECDH).
     * - Secure when using appropriate curves and proper randomness.
     *
     * @param privateKey The ECDH private key.
     * @param publicKey The corresponding public key.
     * @return The derived ECDH shared secret.
     */
    public byte[] deriveECDHSecret(PrivateKey privateKey, PublicKey publicKey) throws Exception {
        KeyAgreement ka = KeyAgreement.getInstance("ECDH", "BC");
        ka.init(privateKey);
        ka.doPhase(publicKey, true);
        return ka.generateSecret();
    }

    //////////////////////////////////////////
    // 3. X25519
    //////////////////////////////////////////

    /**
     * Generates an ephemeral X25519 key pair.
     *
     * CBOM/SAST Classification:
     * - Parent: Modern Elliptic-Curve Key Exchange.
     * - X25519 is considered secure and efficient.
     *
     * @return An X25519 KeyPair.
     */
    public KeyPair generateX25519KeyPair() throws Exception {
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("X25519", "BC");
        // X25519 key size is fixed; the parameter (255) is a reference value.
        kpg.initialize(255, new SecureRandom());
        return kpg.generateKeyPair();
    }

    /**
     * Derives a shared secret using the X25519 key agreement.
     *
     * CBOM/SAST Classification: - Parent: Modern Elliptic-Curve Key Exchange. -
     * X25519 is highly recommended for its security and efficiency.
     *
     * @param privateKey The X25519 private key.
     * @param publicKey The corresponding public key.
     * @return The derived X25519 shared secret.
     */
    public byte[] deriveX25519Secret(PrivateKey privateKey, PublicKey publicKey) throws Exception {
        KeyAgreement ka = KeyAgreement.getInstance("X25519", "BC");
        ka.init(privateKey);
        ka.doPhase(publicKey, true);
        return ka.generateSecret();
    }

    //////////////////////////////////////////
    // 4. X448
    //////////////////////////////////////////

    /**
     * Generates an ephemeral X448 key pair.
     *
     * CBOM/SAST Classification:
     * - Parent: Modern Elliptic-Curve Key Exchange.
     * - X448 provides a higher security margin than X25519.
     *
     * @return An X448 KeyPair.
     */
    public KeyPair generateX448KeyPair() throws Exception {
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("X448", "BC");
        // X448 key size is fixed; the parameter (448) is the curve parameter.
        kpg.initialize(448, new SecureRandom());
        return kpg.generateKeyPair();
    }

    /**
     * Derives a shared secret using the X448 key agreement.
     *
     * CBOM/SAST Classification: - Parent: Modern Elliptic-Curve Key Exchange. -
     * X448 is considered secure and suitable for high-security applications.
     *
     * @param privateKey The X448 private key.
     * @param publicKey The corresponding public key.
     * @return The derived X448 shared secret.
     */
    public byte[] deriveX448Secret(PrivateKey privateKey, PublicKey publicKey) throws Exception {
        KeyAgreement ka = KeyAgreement.getInstance("X448", "BC");
        ka.init(privateKey);
        ka.doPhase(publicKey, true);
        return ka.generateSecret();
    }

    //////////////////////////////////////////
    // 5. Nuanced Insecure Key Exchange Example
    //////////////////////////////////////////

    /**
     * Demonstrates a nuanced example of insecure key exchange by:
     * - Using deprecated DH parameters (512-bit).
     * - Reusing static (non-ephemeral) keys.
     *
     * SAST/CBOM Classification:
     * - Parent: Insecure Key Exchange Patterns.
     * - Issues:
     * * 512-bit DH is weak and vulnerable to attacks.
     * * Reusing a static key pair across sessions eliminates forward secrecy.
     * * Reusing an ECDH key pair for both sides results in predictable shared
     * secrets.
     */
    public void insecureKeyExchangeExample() throws Exception {
        System.out.println("\n--- Insecure Key Exchange Example ---");

        // Example 1: Using weak 512-bit DH with static key reuse.
        KeyPair staticDHKeyPair = generateDHDeprecated();
        // Reusing the same static DH key pair for both parties.
        byte[] staticDHSecret = deriveDHSecret(staticDHKeyPair.getPrivate(), staticDHKeyPair.getPublic());
        System.out.println("Static DH (512-bit) shared secret (reused): "
                + Base64.getEncoder().encodeToString(staticDHSecret));
        // SAST Note: 512-bit DH is considered insecure and static key reuse prevents
        // forward secrecy.

        // Example 2: Reusing an ECDH key pair instead of generating fresh ephemeral
        // keys.
        KeyPair reusedECDHKeyPair = generateECDHKeyPair();
        // Using the same key pair for both sides leads to a shared secret that is
        // easily derived.
        byte[] reusedECDHSecret = deriveECDHSecret(reusedECDHKeyPair.getPrivate(), reusedECDHKeyPair.getPublic());
        System.out.println("Reused ECDH shared secret: "
                + Base64.getEncoder().encodeToString(reusedECDHSecret));
        // SAST Note: Proper key exchange requires fresh ephemeral keys for each session
        // to ensure forward secrecy.
    }

    //////////////////////////////////////////
    // 6. runAllExchanges() Demo Method
    //////////////////////////////////////////

    /**
     * Demonstrates key exchange flows for various algorithms, including both secure
     * and insecure examples.
     *
     * CBOM/SAST Classification:
     * - Exercises both safe configurations (e.g., DH with 2048/4096-bit, ECDH,
     * X25519, X448)
     * and insecure configurations (e.g., DH with 512-bit, static key reuse).
     */
    public void runAllExchanges() throws Exception {
        System.out.println("--- Running Secure Key Exchanges ---");

        // ============ DEPRECATED / UNSAFE DH (512 bits) ============
        KeyPair dhDep1 = generateDHDeprecated();
        KeyPair dhDep2 = generateDHDeprecated();
        byte[] dhDepSecret1 = deriveDHSecret(dhDep1.getPrivate(), dhDep2.getPublic());
        byte[] dhDepSecret2 = deriveDHSecret(dhDep2.getPrivate(), dhDep1.getPublic());
        System.out.println("DH(512) K1->K2: " + Base64.getEncoder().encodeToString(dhDepSecret1));
        System.out.println("DH(512) K2->K1: " + Base64.getEncoder().encodeToString(dhDepSecret2));
        System.out.println("DH(512) match? " + Arrays.equals(dhDepSecret1, dhDepSecret2));

        // ============ DH (2048 bits) Standard ============
        KeyPair dhKP1 = generateDHKeyPair();
        KeyPair dhKP2 = generateDHKeyPair();
        byte[] dhSecret1 = deriveDHSecret(dhKP1.getPrivate(), dhKP2.getPublic());
        byte[] dhSecret2 = deriveDHSecret(dhKP2.getPrivate(), dhKP1.getPublic());
        System.out.println("DH(2048) K1->K2: " + Base64.getEncoder().encodeToString(dhSecret1));
        System.out.println("DH(2048) K2->K1: " + Base64.getEncoder().encodeToString(dhSecret2));
        System.out.println("DH(2048) match? " + Arrays.equals(dhSecret1, dhSecret2));

        // ============ DH (4096 bits) High-Security ============
        KeyPair dhHigh1 = generateDHHighSecurity();
        KeyPair dhHigh2 = generateDHHighSecurity();
        byte[] dhHighSecret1 = deriveDHSecret(dhHigh1.getPrivate(), dhHigh2.getPublic());
        byte[] dhHighSecret2 = deriveDHSecret(dhHigh2.getPrivate(), dhHigh1.getPublic());
        System.out.println("DH(4096) K1->K2: " + Base64.getEncoder().encodeToString(dhHighSecret1));
        System.out.println("DH(4096) K2->K1: " + Base64.getEncoder().encodeToString(dhHighSecret2));
        System.out.println("DH(4096) match? " + Arrays.equals(dhHighSecret1, dhHighSecret2));

        // ============ ECDH (secp256r1) ============
        KeyPair ecKP1 = generateECDHKeyPair();
        KeyPair ecKP2 = generateECDHKeyPair();
        byte[] ecdhSecret1 = deriveECDHSecret(ecKP1.getPrivate(), ecKP2.getPublic());
        byte[] ecdhSecret2 = deriveECDHSecret(ecKP2.getPrivate(), ecKP1.getPublic());
        System.out.println("ECDH K1->K2: " + Base64.getEncoder().encodeToString(ecdhSecret1));
        System.out.println("ECDH K2->K1: " + Base64.getEncoder().encodeToString(ecdhSecret2));
        System.out.println("ECDH match? " + Arrays.equals(ecdhSecret1, ecdhSecret2));

        // ============ X25519 ============
        KeyPair x25519KP1 = generateX25519KeyPair();
        KeyPair x25519KP2 = generateX25519KeyPair();
        byte[] x25519Secret1 = deriveX25519Secret(x25519KP1.getPrivate(), x25519KP2.getPublic());
        byte[] x25519Secret2 = deriveX25519Secret(x25519KP2.getPrivate(), x25519KP1.getPublic());
        System.out.println("X25519 K1->K2: " + Base64.getEncoder().encodeToString(x25519Secret1));
        System.out.println("X25519 K2->K1: " + Base64.getEncoder().encodeToString(x25519Secret2));
        System.out.println("X25519 match? " + Arrays.equals(x25519Secret1, x25519Secret2));

        // ============ X448 ============
        KeyPair x448KP1 = generateX448KeyPair();
        KeyPair x448KP2 = generateX448KeyPair();
        byte[] x448Secret1 = deriveX448Secret(x448KP1.getPrivate(), x448KP2.getPublic());
        byte[] x448Secret2 = deriveX448Secret(x448KP2.getPrivate(), x448KP1.getPublic());
        System.out.println("X448 K1->K2: " + Base64.getEncoder().encodeToString(x448Secret1));
        System.out.println("X448 K2->K1: " + Base64.getEncoder().encodeToString(x448Secret2));
        System.out.println("X448 match? " + Arrays.equals(x448Secret1, x448Secret2));

        // ============ Insecure Key Exchange Example ============
        insecureKeyExchangeExample();
    }
}
