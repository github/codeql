package com.example.crypto.algorithms;

// import org.bouncycastle.crypto.digests.SHA3Digest;
// import org.bouncycastle.crypto.digests.Blake2bDigest;
// import org.bouncycastle.jce.provider.BouncyCastleProvider;
import java.io.FileInputStream;
import java.io.IOException;
import java.security.*;
import java.util.Base64;
import java.util.Properties;
import javax.crypto.Mac;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.SecretKeySpec;
import javax.crypto.spec.PBEKeySpec;

/**
 * This class demonstrates various hashing, HMAC, and password hashing
 * techniques.
 *
 * SAST/CBOM Classification Notes:
 *
 * 1. simpleSHA256Hash: - Parent Classification: Cryptographic Hash Function. -
 * SAST: Uses SHA-256, which is widely regarded as secure.
 *
 * 2. insecureMD5Hash: - Parent Classification: Cryptographic Hash Function. -
 * SAST: MD5 is cryptographically broken and should be flagged as insecure.
 *
 * 3. hashWithBouncyCastleSHA3: - Parent Classification: Cryptographic Hash
 * Function (SHA3). - SAST: Uses SHA3-256 from BouncyCastle; considered secure.
 *
 * 4. hashWithBouncyCastleBlake2b: - Parent Classification: Cryptographic Hash
 * Function (BLAKE2). - SAST: Uses BLAKE2b-512; considered secure if used
 * correctly.
 *
 * 5. hashAndSign & verifyHashSignature: - Parent Classification: Digital
 * Signature (RSA-based). - SAST: Uses SHA256withRSA for signing and
 * verification; secure if key management is proper.
 *
 * 6. hashForDataIntegrityCheck: - Parent Classification: Data Integrity Check.
 * - SAST: Uses SHA-256 to verify integrity; considered secure.
 *
 * 7. hashWithVariousAlgorithms: - Parent Classification: Cryptographic Hash
 * Function. - SAST: Iterates through multiple algorithms; insecure algorithms
 * (MD5, SHA-1) may be flagged.
 *
 * 8. hmacWithVariousAlgorithms: - Parent Classification: Message Authentication
 * Code (MAC). - SAST: Iterates through various HMAC algorithms; HmacSHA1 is
 * considered weaker than SHA256 and above.
 *
 * 9. hashForPasswordStorage: - Parent Classification: Password-Based Key
 * Derivation Function (PBKDF). - SAST: Uses PBKDF2WithHmacSHA256 with salt and
 * iteration count; considered secure, though iteration counts should be
 * reviewed against current standards.
 *
 * 10. hashFromUnknownConfig: - Parent Classification: Dynamic Cryptographic
 * Hash Function. - SAST: Loading the hash algorithm from an external
 * configuration introduces risk of misconfiguration.
 *
 * 11. insecureHashBasedRNG: - Parent Classification: Pseudo-Random Number
 * Generator (PRNG) using hash. - SAST: Uses a fixed seed with various hash
 * algorithms; flagged as insecure due to predictability.
 */
public class Hash {

    // static {
    //     Security.addProvider(new BouncyCastleProvider());
    // }
    /**
     * Computes a SHA-256 hash of static test data.
     *
     * CBOM/SAST Classification: - Uses SHA-256: Classified as secure.
     */
    public void simpleSHA256Hash() throws Exception {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hash = digest.digest("Simple Test Data".getBytes());
        System.out.println("SHA-256 Hash: " + Base64.getEncoder().encodeToString(hash));
    }

    /**
     * Computes an MD5 hash of static data.
     *
     * CBOM/SAST Classification: - Uses MD5: Classified as insecure. - SAST: MD5
     * is deprecated for cryptographic purposes due to collision
     * vulnerabilities.
     */
    public void insecureMD5Hash() throws Exception {
        MessageDigest md5Digest = MessageDigest.getInstance("MD5");
        byte[] hash = md5Digest.digest("Weak Hash Example".getBytes());
        System.out.println("MD5 Hash (Insecure): " + Base64.getEncoder().encodeToString(hash));
    }

    // /**
    //  * Computes a SHA3-256 hash using BouncyCastle's SHA3Digest.
    //  *
    //  * CBOM/SAST Classification:
    //  * - Uses SHA3-256: Classified as secure.
    //  * - SAST: BouncyCastle's implementation is considered reliable.
    //  */
    // public void hashWithBouncyCastleSHA3(String input) {
    //     SHA3Digest digest = new SHA3Digest(256);
    //     byte[] inputBytes = input.getBytes();
    //     digest.update(inputBytes, 0, inputBytes.length);
    //     byte[] hash = new byte[digest.getDigestSize()];
    //     digest.doFinal(hash, 0);
    //     System.out.println("SHA3-256 (BC) Hash: " + Base64.getEncoder().encodeToString(hash));
    // }
    // /**
    //  * Computes a BLAKE2b-512 hash using BouncyCastle's Blake2bDigest.
    //  *
    //  * CBOM/SAST Classification:
    //  * - Uses BLAKE2b-512: Classified as secure.
    //  * - SAST: BLAKE2b is modern and fast, considered secure when used correctly.
    //  */
    // public void hashWithBouncyCastleBlake2b(String input) {
    //     Blake2bDigest digest = new Blake2bDigest(512);
    //     byte[] inputBytes = input.getBytes();
    //     digest.update(inputBytes, 0, inputBytes.length);
    //     byte[] hash = new byte[digest.getDigestSize()];
    //     digest.doFinal(hash, 0);
    //     System.out.println("BLAKE2b-512 (BC) Hash: " + Base64.getEncoder().encodeToString(hash));
    // }
    /**
     * Signs the hash of the input using SHA256withRSA.
     *
     * CBOM/SAST Classification: - Digital Signature (RSA): Classified as secure
     * if keys are managed correctly. - SAST: The combination of SHA256 and RSA
     * is a standard and secure pattern.
     *
     * @param input The input data to be signed.
     * @param privateKey The RSA private key used for signing.
     */
    public void hashAndSign(String input, PrivateKey privateKey) throws Exception {
        Signature signature = Signature.getInstance("SHA256withRSA");
        signature.initSign(privateKey);
        signature.update(input.getBytes());
        byte[] signedData = signature.sign();
        System.out.println("Signed Hash: " + Base64.getEncoder().encodeToString(signedData));
    }

    /**
     * Verifies the signature of the input data.
     *
     * CBOM/SAST Classification: - Digital Signature Verification: Classified as
     * secure when using SHA256withRSA. - SAST: Should correctly verify that the
     * signed hash matches the input.
     *
     * @param input The original input data.
     * @param signedHash The signed hash to verify.
     * @param publicKey The RSA public key corresponding to the private key that
     * signed the data.
     * @return true if the signature is valid, false otherwise.
     */
    public boolean verifyHashSignature(String input, byte[] signedHash, PublicKey publicKey) throws Exception {
        Signature signature = Signature.getInstance("SHA256withRSA");
        signature.initVerify(publicKey);
        signature.update(input.getBytes());
        return signature.verify(signedHash);
    }

    /**
     * Computes a SHA-256 hash for data integrity checking and compares it with
     * an expected hash.
     *
     * CBOM/SAST Classification: - Data Integrity: Uses SHA-256 for integrity
     * checks, which is secure. - SAST: A correct implementation for verifying
     * data has not been tampered with.
     *
     * @param data The input data.
     * @param expectedHash The expected Base64-encoded hash.
     */
    public void hashForDataIntegrityCheck(String data, String expectedHash) throws Exception {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] hash = digest.digest(data.getBytes());
        String computedHash = Base64.getEncoder().encodeToString(hash);
        System.out.println("Computed Hash: " + computedHash);
        System.out.println("Validation: " + (computedHash.equals(expectedHash) ? "Pass" : "Fail"));
    }

    /**
     * Computes hashes of the input data using various algorithms.
     *
     * CBOM/SAST Classification: - Cryptographic Hash Functions: Iterates
     * through multiple hash functions. - SAST: While many are secure (e.g.,
     * SHA-256, SHA-512, SHA3), MD5 and SHA-1 are insecure and should be flagged
     * if used in security-critical contexts.
     *
     * @param input The input data to hash.
     */
    public void hashWithVariousAlgorithms(String input) throws Exception {
        String[] algorithms = {"SHA-1", "SHA-224", "SHA-256", "SHA-384", "SHA-512", "SHA3-256", "SHA3-512",
            "BLAKE2B-512", "BLAKE2S-256", "MD5"};
        for (String algorithm : algorithms) {
            MessageDigest digest = MessageDigest.getInstance(algorithm);
            byte[] hash = digest.digest(input.getBytes());
            System.out.println(algorithm + " Hash: " + Base64.getEncoder().encodeToString(hash));
        }
    }

    /**
     * Computes HMACs of the input data using various algorithms.
     *
     * CBOM/SAST Classification: - Message Authentication Code (MAC): Iterates
     * through different HMAC algorithms. - SAST: HmacSHA256, HmacSHA384,
     * HmacSHA512, HmacSHA3-256, and HmacSHA3-512 are secure; HmacSHA1 is
     * considered less secure and may be flagged.
     *
     * @param input The input data.
     * @param key The secret key used for HMAC computation.
     */
    public void hmacWithVariousAlgorithms(String input, byte[] key) throws Exception {
        String[] algorithms = {"HmacSHA1", "HmacSHA256", "HmacSHA384", "HmacSHA512", "HmacSHA3-256", "HmacSHA3-512"};
        for (String algorithm : algorithms) {
            Mac mac = Mac.getInstance(algorithm);
            SecretKey secretKey = new SecretKeySpec(key, algorithm);
            mac.init(secretKey);
            byte[] hmac = mac.doFinal(input.getBytes());
            System.out.println(algorithm + " HMAC: " + Base64.getEncoder().encodeToString(hmac));
        }
    }

    /**
     * Computes a PBKDF2 hash for password storage.
     *
     * CBOM/SAST Classification: - Password-Based Key Derivation Function
     * (PBKDF): Uses PBKDF2WithHmacSHA256. - SAST: Considered secure when using
     * a strong salt and an appropriate iteration count. Note: The iteration
     * count (10000) should be reviewed against current security standards.
     *
     * @param password The password to hash.
     */
    public void hashForPasswordStorage(String password) throws Exception {
        byte[] salt = generateSecureSalt(16);
        // 10,000 iterations and a 256-bit derived key.
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, 10000, 256);
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
        byte[] hash = factory.generateSecret(spec).getEncoded();
        System.out.println("PBKDF2 Hash: " + Base64.getEncoder().encodeToString(hash));
    }

    /**
     * Dynamically loads a hash algorithm from configuration and computes a
     * hash.
     *
     * CBOM/SAST Classification: - Dynamic Cryptographic Hash Selection:
     * Algorithm is loaded from a config file. - SAST: May be flagged as risky
     * because an insecure or unintended algorithm might be chosen.
     */
    public void hashFromUnknownConfig() throws Exception {
        String algorithm = loadHashAlgorithmFromConfig("config.properties");
        MessageDigest digest = MessageDigest.getInstance(algorithm);
        byte[] hash = digest.digest("Config-based Hashing".getBytes());
        System.out.println("Dynamically Loaded Hash Algorithm (" + algorithm + "): "
                + Base64.getEncoder().encodeToString(hash));
    }

    /**
     * Demonstrates an insecure method for generating pseudo-random bytes by
     * using a fixed seed with hash algorithms.
     *
     * CBOM/SAST Classification: - Insecure RNG: Uses a fixed seed with various
     * hash algorithms. - SAST: This approach is insecure because it produces
     * predictable output and should be flagged.
     */
    public void insecureHashBasedRNG() throws Exception {
        String[] algorithms = {"SHA-256", "SHA-512", "SHA3-256", "SHA3-512"};
        for (String algorithm : algorithms) {
            MessageDigest digest = MessageDigest.getInstance(algorithm);
            byte[] seed = "fixed-seed".getBytes(); // Fixed seed: insecure and predictable.
            digest.update(seed);
            byte[] pseudoRandomBytes = digest.digest();
            System.out.println("Insecure RNG using " + algorithm + ": "
                    + Base64.getEncoder().encodeToString(pseudoRandomBytes));
        }
    }

    /**
     * Loads the hash algorithm from an external configuration file.
     *
     * CBOM/SAST Classification: - Dynamic Configuration: External config
     * loading. - SAST: The use of external configuration may introduce risks if
     * the config file is compromised.
     *
     * @param configPath Path to the configuration file.
     * @return The hash algorithm to be used (default is SHA-256).
     */
    private String loadHashAlgorithmFromConfig(String configPath) {
        Properties properties = new Properties();
        try (FileInputStream fis = new FileInputStream(configPath)) {
            properties.load(fis);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return properties.getProperty("hash.algorithm", "SHA-256");
    }

    /**
     * Generates a secure salt using a cryptographically strong random number
     * generator.
     *
     * CBOM/SAST Classification: - Secure Salt Generation: Uses SecureRandom. -
     * SAST: This is a best-practice approach for generating salts for password
     * hashing.
     *
     * @param length The desired salt length.
     * @return A byte array representing the salt.
     */
    private byte[] generateSecureSalt(int length) {
        byte[] salt = new byte[length];
        new SecureRandom().nextBytes(salt);
        return salt;
    }
}
