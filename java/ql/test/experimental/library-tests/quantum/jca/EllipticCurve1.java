package com.example.crypto.algorithms;

// import org.bouncycastle.jce.provider.BouncyCastleProvider;

import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.util.Base64;

/**
 * EllipticCurve1 demonstrates generating EC key pairs for various curve
 * categories.
 *
 * Curve categories covered:
 * - NIST: e.g., secp256r1, secp384r1, secp521r1.
 * - SEC: e.g., secp256k1 (from the Standards for Efficient Cryptography, SEC2).
 * - BRAINPOOL: e.g., brainpoolP256r1.
 * - CURVE25519: for key agreement (X25519) or signatures (Ed25519).
 * - CURVE448: for key agreement (X448).
 * - C2: Binary curves; for example, sect163r2 (if available).
 * - SM2: Chinese SM2 curve, often named sm2p256v1.
 * - ES: Elliptic curve signature based on EdDSA, here using Ed25519.
 * - OtherEllipticCurveType: A fallback (using secp256r1).
 *
 * Best practices:
 * - Use ephemeral key generation with a strong RNG.
 * - Select curves from secure families (e.g., NIST, Brainpool, Curve25519/448,
 * SM2).
 * - Use a crypto provider (e.g., BouncyCastle) that supports the desired
 * curves.
 *
 * In a production environment, the curve type may be externally configured.
 */
public class EllipticCurve1 {

    // static {
    //     // Register the BouncyCastle provider to access a wide range of curves.
    //     Security.addProvider(new BouncyCastleProvider());
    // }

    /**
     * Generates a key pair using a NIST curve (e.g., secp256r1).
     */
    public KeyPair generateNISTKeyPair() throws Exception {
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("EC", "BC");
        // secp256r1 is widely used (also known as P-256)
        kpg.initialize(new java.security.spec.ECGenParameterSpec("secp256r1"));
        return kpg.generateKeyPair();
    }

    /**
     * Generates a key pair using a SEC curve (e.g., secp256k1).
     */
    public KeyPair generateSECCurveKeyPair() throws Exception {
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("EC", "BC");
        // secp256k1 is commonly used in Bitcoin and other blockchain applications.
        kpg.initialize(new java.security.spec.ECGenParameterSpec("secp256k1"));
        return kpg.generateKeyPair();
    }

    /**
     * Generates a key pair using a Brainpool curve (e.g., brainpoolP256r1).
     */
    public KeyPair generateBrainpoolKeyPair() throws Exception {
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("EC", "BC");
        // "brainpoolP256r1" is a commonly recommended Brainpool curve.
        kpg.initialize(new java.security.spec.ECGenParameterSpec("brainpoolP256r1"));
        return kpg.generateKeyPair();
    }

    /**
     * Generates an X25519 key pair (for key agreement).
     */
    public KeyPair generateCurve25519KeyPair() throws Exception {
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("X25519", "BC");
        // No further parameters are needed for X25519.
        return kpg.generateKeyPair();
    }

    /**
     * Generates an X448 key pair (for key agreement).
     */
    public KeyPair generateCurve448KeyPair() throws Exception {
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("X448", "BC");
        return kpg.generateKeyPair();
    }

    /**
     * Generates a key pair for a binary (C2) curve.
     * Example: sect163r2 is a binary field curve.
     */
    public KeyPair generateC2CurveKeyPair() throws Exception {
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("EC", "BC");
        // "sect163r2" is one of the binary field curves supported by BouncyCastle.
        kpg.initialize(new java.security.spec.ECGenParameterSpec("sect163r2"));
        return kpg.generateKeyPair();
    }

    /**
     * Generates a key pair for the SM2 curve.
     * SM2 is a Chinese cryptographic standard.
     */
    public KeyPair generateSM2KeyPair() throws Exception {
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("EC", "BC");
        // "sm2p256v1" is the standard SM2 curve.
        kpg.initialize(new java.security.spec.ECGenParameterSpec("sm2p256v1"));
        return kpg.generateKeyPair();
    }

    /**
     * Generates a key pair for ES (Elliptic curve signature using EdDSA).
     * This example uses Ed25519.
     */
    public KeyPair generateESKeyPair() throws Exception {
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("Ed25519", "BC");
        return kpg.generateKeyPair();
    }

    /**
     * Generates a key pair for an "Other" elliptic curve type.
     * This serves as a fallback example (using secp256r1).
     */
    public KeyPair generateOtherEllipticCurveKeyPair() throws Exception {
        return generateNISTKeyPair(); // Fallback to secp256r1
    }

    /**
     * Main method demonstrating key pair generation for various curve types.
     */
    public static void main(String[] args) {
        try {
            EllipticCurve1 examples = new EllipticCurve1();
            System.out.println("NIST (secp256r1): " +
                    Base64.getEncoder().encodeToString(examples.generateNISTKeyPair().getPublic().getEncoded()));
            System.out.println("SEC (secp256k1): " +
                    Base64.getEncoder().encodeToString(examples.generateSECCurveKeyPair().getPublic().getEncoded()));
            System.out.println("Brainpool (brainpoolP256r1): " +
                    Base64.getEncoder().encodeToString(examples.generateBrainpoolKeyPair().getPublic().getEncoded()));
            System.out.println("Curve25519 (X25519): " +
                    Base64.getEncoder().encodeToString(examples.generateCurve25519KeyPair().getPublic().getEncoded()));
            System.out.println("Curve448 (X448): " +
                    Base64.getEncoder().encodeToString(examples.generateCurve448KeyPair().getPublic().getEncoded()));
            System.out.println("C2 (sect163r2): " +
                    Base64.getEncoder().encodeToString(examples.generateC2CurveKeyPair().getPublic().getEncoded()));
            System.out.println("SM2 (sm2p256v1): " +
                    Base64.getEncoder().encodeToString(examples.generateSM2KeyPair().getPublic().getEncoded()));
            System.out.println("ES (Ed25519): " +
                    Base64.getEncoder().encodeToString(examples.generateESKeyPair().getPublic().getEncoded()));
            System.out.println("Other (Fallback, secp256r1): " +
                    Base64.getEncoder()
                            .encodeToString(examples.generateOtherEllipticCurveKeyPair().getPublic().getEncoded()));
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
