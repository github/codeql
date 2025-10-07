package com.example.crypto.algorithms;

// import org.bouncycastle.jce.provider.BouncyCastleProvider;
import java.security.*;
import java.security.spec.ECGenParameterSpec;
import java.util.Base64;
import java.util.Properties;

/**
 * Demonstrates various digital signature operations:
 *
 * 1) RSA-PSS (modern, safer) - CBOM/SAST: Classified as a Modern Digital
 * Signature scheme using RSA-PSS. RSA-PSS with SHA-256 is recommended.
 *
 * 2) ECDSA with secp256r1 - CBOM/SAST: Classified as an Elliptic Curve Digital
 * Signature Algorithm. Secure when used with a strong curve and proper
 * randomness.
 *
 * 3) Ed25519 (RFC 8032) - CBOM/SAST: Classified as a modern, high-performance
 * signature scheme.
 *
 * 4) SHA1withRSA (deprecated/unsafe example) - CBOM/SAST: Classified as a
 * legacy digital signature scheme. SHA-1 and 1024-bit RSA are deprecated.
 *
 * Additional nuanced examples:
 *
 * - Signing and verifying an empty message. - Signing data with non-ASCII
 * characters. - Demonstrating signature tampering and its detection. - A
 * dynamic (runtime-selected) signature algorithm scenario ("known unknown").
 *
 * Requirements: - BouncyCastle for ECDSA, Ed25519, and RSA-PSS (if needed). -
 * Java 11+ for native Ed25519 support or using BC for older versions.
 */
public class SignatureOperation {

    // static {
    //     // Register the BouncyCastle provider.
    //     Security.addProvider(new BouncyCastleProvider());
    // }
    ///////////////////////////////////////
    // 1. RSA-PSS (Recommended)
    ///////////////////////////////////////

    /**
     * Generate an RSA key pair for RSA-PSS.
     * Uses a 2048-bit key.
     *
     * CBOM/SAST Notes:
     * - Parent: Modern Digital Signature (RSA-PSS).
     */
    public KeyPair generateRSAPSSKeyPair() throws Exception {
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("RSA");
        kpg.initialize(2048);
        return kpg.generateKeyPair();
    }

    /**
     * Sign data using RSA-PSS with SHA-256.
     *
     * CBOM/SAST Notes: - Parent: Modern Digital Signature (RSA-PSS).
     */
    public byte[] signRSAPSS(PrivateKey privateKey, byte[] data) throws Exception {
        Signature signature = Signature.getInstance("SHA256withRSAandMGF1");
        signature.initSign(privateKey);
        signature.update(data);
        return signature.sign();
    }

    /**
     * Verify data using RSA-PSS with SHA-256.
     *
     * CBOM/SAST Notes: - Parent: Modern Digital Signature (RSA-PSS).
     */
    public boolean verifyRSAPSS(PublicKey publicKey, byte[] data, byte[] sigBytes) throws Exception {
        Signature signature = Signature.getInstance("SHA256withRSAandMGF1");
        signature.initVerify(publicKey);
        signature.update(data);
        return signature.verify(sigBytes);
    }

    ///////////////////////////////////////
    // 2. ECDSA (secp256r1)
    ///////////////////////////////////////

    /**
     * Generate an ECDSA key pair on secp256r1.
     *
     * CBOM/SAST Notes:
     * - Parent: Elliptic Curve Digital Signature.
     */
    public KeyPair generateECDSAKeyPair() throws Exception {
        KeyPairGenerator ecKpg = KeyPairGenerator.getInstance("EC", "BC");
        ecKpg.initialize(new ECGenParameterSpec("secp256r1"), new SecureRandom());
        return ecKpg.generateKeyPair();
    }

    /**
     * Sign data using ECDSA with SHA-256.
     *
     * CBOM/SAST Notes: - Parent: Elliptic Curve Digital Signature.
     */
    public byte[] signECDSA(PrivateKey privateKey, byte[] data) throws Exception {
        Signature signature = Signature.getInstance("SHA256withECDSA", "BC");
        signature.initSign(privateKey);
        signature.update(data);
        return signature.sign();
    }

    /**
     * Verify data using ECDSA with SHA-256.
     *
     * CBOM/SAST Notes: - Parent: Elliptic Curve Digital Signature.
     */
    public boolean verifyECDSA(PublicKey publicKey, byte[] data, byte[] sigBytes) throws Exception {
        Signature signature = Signature.getInstance("SHA256withECDSA", "BC");
        signature.initVerify(publicKey);
        signature.update(data);
        return signature.verify(sigBytes);
    }

    ///////////////////////////////////////
    // 3. Ed25519 (RFC 8032)
    ///////////////////////////////////////

    /**
     * Generate an Ed25519 key pair.
     *
     * CBOM/SAST Notes:
     * - Parent: Modern Digital Signature (EdDSA).
     */
    public KeyPair generateEd25519KeyPair() throws Exception {
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("Ed25519", "BC");
        return kpg.generateKeyPair();
    }

    /**
     * Sign data using Ed25519.
     *
     * CBOM/SAST Notes: - Parent: Modern Digital Signature (EdDSA).
     */
    public byte[] signEd25519(PrivateKey privateKey, byte[] data) throws Exception {
        Signature signature = Signature.getInstance("Ed25519", "BC");
        signature.initSign(privateKey);
        signature.update(data);
        return signature.sign();
    }

    /**
     * Verify data using Ed25519.
     *
     * CBOM/SAST Notes: - Parent: Modern Digital Signature (EdDSA).
     */
    public boolean verifyEd25519(PublicKey publicKey, byte[] data, byte[] sigBytes) throws Exception {
        Signature signature = Signature.getInstance("Ed25519", "BC");
        signature.initVerify(publicKey);
        signature.update(data);
        return signature.verify(sigBytes);
    }

    ///////////////////////////////////////
    // 4. SHA1withRSA (Deprecated/Unsafe)
    ///////////////////////////////////////

    /**
     * Generate an RSA key pair for the deprecated/unsafe example.
     * Uses a 1024-bit key.
     *
     * CBOM/SAST Notes:
     * - Parent: Legacy Digital Signature.
     * - RSA with SHA-1 and 1024-bit keys is deprecated and should be avoided.
     */
    public KeyPair generateRSAUnsafeKeyPair() throws Exception {
        KeyPairGenerator kpg = KeyPairGenerator.getInstance("RSA");
        kpg.initialize(1024);
        return kpg.generateKeyPair();
    }

    /**
     * Sign data using SHA1withRSA.
     *
     * CBOM/SAST Notes: - Parent: Legacy Digital Signature. - SHA-1 is
     * deprecated and RSA with 1024 bits is considered weak.
     */
    public byte[] signSHA1withRSA(PrivateKey privateKey, byte[] data) throws Exception {
        Signature signature = Signature.getInstance("SHA1withRSA");
        signature.initSign(privateKey);
        signature.update(data);
        return signature.sign();
    }

    /**
     * Verify data using SHA1withRSA.
     *
     * CBOM/SAST Notes: - Parent: Legacy Digital Signature. - Verification of
     * SHA1withRSA is insecure.
     */
    public boolean verifySHA1withRSA(PublicKey publicKey, byte[] data, byte[] sigBytes) throws Exception {
        Signature signature = Signature.getInstance("SHA1withRSA");
        signature.initVerify(publicKey);
        signature.update(data);
        return signature.verify(sigBytes);
    }

    ///////////////////////////////////////
    // Nuanced Edge-Case Examples
    ///////////////////////////////////////

    /**
     * Demonstrates signing and verifying an empty message.
     *
     * CBOM/SAST Notes:
     * - Edge Case: Signing empty input should be handled correctly but might be
     * unexpected.
     */
    public void signAndVerifyEmptyMessage() throws Exception {
        byte[] emptyMessage = new byte[0];
        KeyPair kp = generateRSAPSSKeyPair();
        byte[] sig = signRSAPSS(kp.getPrivate(), emptyMessage);
        boolean verified = verifyRSAPSS(kp.getPublic(), emptyMessage, sig);
        System.out.println("Empty message signature verified? " + verified);
    }

    /**
     * Demonstrates that even a slight tampering with the signature will cause
     * verification to fail.
     *
     * CBOM/SAST Notes: - Edge Case: Signature integrity is critical. Any
     * change-even a single byte-should invalidate the signature.
     */
    public void tamperSignatureEdgeCase() throws Exception {
        byte[] message = "Important Message".getBytes();
        KeyPair kp = generateECDSAKeyPair();
        byte[] originalSig = signECDSA(kp.getPrivate(), message);
        // Tamper with the signature by flipping one bit.
        byte[] tamperedSig = originalSig.clone();
        tamperedSig[0] ^= 0x01;
        boolean verifiedOriginal = verifyECDSA(kp.getPublic(), message, originalSig);
        boolean verifiedTampered = verifyECDSA(kp.getPublic(), message, tamperedSig);
        System.out.println("Original ECDSA signature verified? " + verifiedOriginal);
        System.out.println("Tampered ECDSA signature verified? " + verifiedTampered);
    }

    /**
     * Demonstrates dynamic signature algorithm selection. This is a "known
     * unknown" scenario where the algorithm is chosen at runtime based on
     * configuration. If the configuration is compromised or misconfigured, an
     * insecure algorithm might be selected.
     *
     * CBOM/SAST Notes: - Known Unknown: Dynamic configuration introduces
     * ambiguity and risk. - Ensure that fallback defaults are secure.
     */
    public void dynamicSignatureSelectionDemo() throws Exception {
        // Simulate loading a configuration.
        Properties config = new Properties();
        // For demonstration, let's assume the config might specify an algorithm.
        // Possible values: "SHA256withRSAandMGF1", "SHA256withECDSA", "Ed25519",
        // "SHA1withRSA"
        // Here we simulate an unknown or insecure algorithm being selected.
        config.setProperty("signature.algorithm", "SHA1withRSA"); // Insecure choice!
        String algorithm = config.getProperty("signature.algorithm", "SHA256withRSAandMGF1");

        KeyPair kp;
        Signature signature;
        if ("SHA256withRSAandMGF1".equalsIgnoreCase(algorithm)) {
            kp = generateRSAPSSKeyPair();
            signature = Signature.getInstance("SHA256withRSAandMGF1");
        } else if ("SHA256withECDSA".equalsIgnoreCase(algorithm)) {
            kp = generateECDSAKeyPair();
            signature = Signature.getInstance("SHA256withECDSA", "BC");
        } else if ("Ed25519".equalsIgnoreCase(algorithm)) {
            kp = generateEd25519KeyPair();
            signature = Signature.getInstance("Ed25519", "BC");
        } else if ("SHA1withRSA".equalsIgnoreCase(algorithm)) {
            kp = generateRSAUnsafeKeyPair();
            signature = Signature.getInstance("SHA1withRSA");
        } else {
            // Fallback to a secure default.
            kp = generateRSAPSSKeyPair();
            signature = Signature.getInstance("SHA256withRSAandMGF1");
        }

        byte[] message = "Dynamic Signature Demo".getBytes();
        signature.initSign(kp.getPrivate());
        signature.update(message);
        byte[] sigBytes = signature.sign();
        // Verify using the same algorithm.
        signature.initVerify(kp.getPublic());
        signature.update(message);
        boolean verified = signature.verify(sigBytes);
        System.out.println("Dynamic algorithm (" + algorithm + ") signature verified? " + verified);
    }

    ///////////////////////////////////////
    // Demo Method: runSignatureDemos
    ///////////////////////////////////////

    /**
     * Demonstrates digital signature operations for various algorithms.
     * It generates key pairs, signs a message, and verifies the signature for:
     * - RSA-PSS
     * - ECDSA (secp256r1)
     * - Ed25519
     * - SHA1withRSA (deprecated/unsafe)
     * Additionally, it runs several edge-case demos.
     *
     * CBOM/SAST Classification:
     * - Shows both modern, secure signature schemes and a deprecated example.
     * - Also demonstrates handling of edge cases and dynamic selection risks.
     */
    public void runSignatureDemos() throws Exception {
        byte[] message = "Hello Signature World!".getBytes();

        // ============ RSA-PSS ============
        KeyPair rsaPssKP = generateRSAPSSKeyPair();
        byte[] rsaPssSig = signRSAPSS(rsaPssKP.getPrivate(), message);
        System.out.println("RSA-PSS Signature: " + Base64.getEncoder().encodeToString(rsaPssSig));
        boolean rsaPssVerified = verifyRSAPSS(rsaPssKP.getPublic(), message, rsaPssSig);
        System.out.println("RSA-PSS Verified? " + rsaPssVerified);

        // ============ ECDSA (secp256r1) ============
        KeyPair ecdsaKP = generateECDSAKeyPair();
        byte[] ecdsaSig = signECDSA(ecdsaKP.getPrivate(), message);
        System.out.println("ECDSA Signature: " + Base64.getEncoder().encodeToString(ecdsaSig));
        boolean ecdsaVerified = verifyECDSA(ecdsaKP.getPublic(), message, ecdsaSig);
        System.out.println("ECDSA Verified? " + ecdsaVerified);

        // ============ Ed25519 ============
        KeyPair ed25519KP = generateEd25519KeyPair();
        byte[] ed25519Sig = signEd25519(ed25519KP.getPrivate(), message);
        System.out.println("Ed25519 Signature: " + Base64.getEncoder().encodeToString(ed25519Sig));
        boolean ed25519Verified = verifyEd25519(ed25519KP.getPublic(), message, ed25519Sig);
        System.out.println("Ed25519 Verified? " + ed25519Verified);

        // ============ SHA1withRSA (Deprecated/Unsafe) ============
        KeyPair rsaUnsafeKP = generateRSAUnsafeKeyPair();
        byte[] rsaUnsafeSig = signSHA1withRSA(rsaUnsafeKP.getPrivate(), message);
        System.out.println("SHA1withRSA Signature (Insecure): " + Base64.getEncoder().encodeToString(rsaUnsafeSig));
        boolean rsaUnsafeVerified = verifySHA1withRSA(rsaUnsafeKP.getPublic(), message, rsaUnsafeSig);
        System.out.println("SHA1withRSA Verified? " + rsaUnsafeVerified);

        // ============ Edge Cases ============
        signAndVerifyEmptyMessage();
        tamperSignatureEdgeCase();
        dynamicSignatureSelectionDemo();
    }
}
