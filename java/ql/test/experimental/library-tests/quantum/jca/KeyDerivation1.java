package com.example.crypto.algorithms;

// import org.bouncycastle.crypto.generators.Argon2BytesGenerator;
// import org.bouncycastle.crypto.params.Argon2Parameters;
// import org.bouncycastle.jce.provider.BouncyCastleProvider;
import java.io.FileInputStream;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Arrays;
import java.util.Base64;
import java.util.Properties;
import javax.crypto.Mac;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;

/**
 * This class demonstrates multiple key derivation functions (KDFs) including
 * PBKDF2, scrypt, Argon2, raw hash derivation, HKDF, and dynamic algorithm
 * selection.
 *
 * SAST/CBOM Classification Notes:
 *
 * 1. PBKDF2 Examples: - Parent Classification: Password-Based Key Derivation
 * Function (PBKDF). - SAST: * pbkdf2DerivationBasic: Uses PBKDF2WithHmacSHA256
 * with 10,000 iterations - acceptable if parameters meet current standards. *
 * pbkdf2LowIteration: Uses only 10 iterations, flagged as insecure due to
 * insufficient iteration count. * pbkdf2HighIteration: Uses 1,000,000
 * iterations - secure (though performance may be impacted). * pbkdf2HmacSHA1:
 * Uses PBKDF2WithHmacSHA1 - flagged as weaker compared to SHA-256, though
 * sometimes seen in legacy systems. * pbkdf2HmacSHA512: Uses
 * PBKDF2WithHmacSHA512 - classified as secure.
 *
 * 2. Scrypt Examples: - Parent Classification: Memory-Hard Key Derivation
 * Function. - SAST: * scryptWeak: Uses weak parameters (n=1024, r=1, p=1) -
 * flagged as insecure. * scryptStrong: Uses stronger parameters (n=16384, r=8,
 * p=1) - considered secure.
 *
 * 3. Argon2 Examples: - Parent Classification: Memory-Hard Key Derivation
 * Function (Argon2id). - SAST: * argon2Derivation: Uses moderate memory and
 * iterations - considered secure. * argon2HighMemory: Uses high memory (128MB)
 * and more iterations - secure, though resource intensive.
 *
 * 4. Insecure Raw Hash Derivation: - Parent Classification: Raw Hash Usage for
 * Key Derivation. - SAST: Using a single SHA-256 hash as a key and then using
 * it with insecure AES/ECB mode is highly discouraged.
 *
 * 5. HKDF Examples: - Parent Classification: Key Derivation Function (HKDF). -
 * SAST: The provided HKDF implementation is simplistic (single-block expansion)
 * and may be flagged.
 *
 * 6. Multi-Step Hybrid Derivation: - Parent Classification: Composite KDF
 * (PBKDF2 followed by HKDF). - SAST: Combining two KDFs is acceptable if done
 * carefully; however, custom implementations should be reviewed.
 *
 * 7. Dynamic KDF Selection: - Parent Classification: Dynamic/Configurable Key
 * Derivation. - SAST: Loading KDF parameters from configuration introduces
 * ambiguity and risk if misconfigured.
 */
public class KeyDerivation1 {

    // static {
    //     Security.addProvider(new BouncyCastleProvider());
    // }
    //////////////////////////////////////
    // 1. PBKDF2 EXAMPLES
    //////////////////////////////////////

    /**
     * Basic PBKDF2 derivation using PBKDF2WithHmacSHA256.
     *
     * SAST/CBOM:
     * - Parent: PBKDF2.
     * - Uses 10,000 iterations with a 256-bit key; generally acceptable.
     */
    public void pbkdf2DerivationBasic(String password) throws Exception {
        byte[] salt = generateSalt(16);
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, 10000, 256);
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
        byte[] key = factory.generateSecret(spec).getEncoded();
        System.out.println("PBKDF2 (Basic) Key: " + Base64.getEncoder().encodeToString(key));
    }

    /**
     * PBKDF2 derivation with a very low iteration count.
     *
     * SAST/CBOM: - Parent: PBKDF2. - Iteration count is only 10, which is far
     * below acceptable security standards. - Flagged as insecure.
     */
    public void pbkdf2LowIteration(String password) throws Exception {
        byte[] salt = generateSalt(16);
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, 10, 256); // Very low iteration count.
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
        byte[] key = factory.generateSecret(spec).getEncoded();
        System.out.println("PBKDF2 (Low Iteration) Key (Insecure): " + Base64.getEncoder().encodeToString(key));
    }

    /**
     * PBKDF2 derivation with a high iteration count.
     *
     * SAST/CBOM: - Parent: PBKDF2. - Uses 1,000,000 iterations; this is secure
     * but may impact performance.
     */
    public void pbkdf2HighIteration(String password) throws Exception {
        byte[] salt = generateSalt(16);
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, 1_000_000, 256);
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
        byte[] key = factory.generateSecret(spec).getEncoded();
        System.out.println("PBKDF2 (High Iteration) Key: " + Base64.getEncoder().encodeToString(key));
    }

    /**
     * PBKDF2 derivation using HmacSHA1.
     *
     * SAST/CBOM: - Parent: PBKDF2. - Uses HMAC-SHA1, which is considered weaker
     * than SHA-256; may be acceptable only for legacy systems.
     */
    public void pbkdf2HmacSHA1(String password) throws Exception {
        byte[] salt = generateSalt(16);
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, 80000, 256);
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA1");
        byte[] key = factory.generateSecret(spec).getEncoded();
        System.out.println("PBKDF2 (HmacSHA1) Key: " + Base64.getEncoder().encodeToString(key));
    }

    /**
     * PBKDF2 derivation using HmacSHA512.
     *
     * SAST/CBOM: - Parent: PBKDF2. - Uses HMAC-SHA512 with 160,000 iterations;
     * classified as secure.
     */
    public void pbkdf2HmacSHA512(String password) throws Exception {
        byte[] salt = generateSalt(16);
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, 160000, 256);
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA512");
        byte[] key = factory.generateSecret(spec).getEncoded();
        System.out.println("PBKDF2 (HmacSHA512) Key: " + Base64.getEncoder().encodeToString(key));
    }

    //////////////////////////////////////
    // 2. SCRYPT EXAMPLES
    //////////////////////////////////////

    /**
     * Scrypt derivation with weak parameters.
     *
     * SAST/CBOM:
     * - Parent: Scrypt.
     * - Parameters (n=1024, r=1, p=1) are too weak and should be flagged as
     * insecure.
     */
    public void scryptWeak(String password) throws Exception {
        byte[] salt = generateSalt(16);
        // Weak parameters: low work factor.
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, 1024, 128);
        SecretKeyFactory factory = SecretKeyFactory.getInstance("SCRYPT");
        byte[] key = factory.generateSecret(spec).getEncoded();
        System.out.println("scrypt (Weak) Key: " + Base64.getEncoder().encodeToString(key));
    }

    /**
     * Scrypt derivation with stronger parameters.
     *
     * SAST/CBOM: - Parent: Scrypt. - Parameters (n=16384, r=8, p=1) provide a
     * secure work factor.
     */
    public void scryptStrong(String password) throws Exception {
        byte[] salt = generateSalt(16);
        // Strong parameters for scrypt.
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, 16384, 256);
        SecretKeyFactory factory = SecretKeyFactory.getInstance("SCRYPT");
        byte[] key = factory.generateSecret(spec).getEncoded();
        System.out.println("scrypt (Strong) Key: " + Base64.getEncoder().encodeToString(key));
    }

    //////////////////////////////////////
    // 3. ARGON2 EXAMPLES
    //////////////////////////////////////

    // /**
    //  * Argon2 derivation using Argon2id with moderate memory and iterations.
    //  *
    //  * SAST/CBOM:
    //  * - Parent: Argon2 (Memory-Hard KDF).
    //  * - Parameters: memory=65536 KB, iterations=2, parallelism=2; considered
    //  * secure.
    //  */
    // public void argon2Derivation(String password) throws Exception {
    //     byte[] salt = generateSalt(16);
    //     Argon2Parameters.Builder builder = new Argon2Parameters.Builder(Argon2Parameters.ARGON2_id)
    //             .withSalt(salt)
    //             .withParallelism(2)
    //             .withMemoryAsKB(65536)
    //             .withIterations(2);

    //     Argon2BytesGenerator gen = new Argon2BytesGenerator();
    //     gen.init(builder.build());
    //     byte[] hash = new byte[32];
    //     gen.generateBytes(password.getBytes(), hash, 0, hash.length);
    //     System.out.println("Argon2 Key: " + Base64.getEncoder().encodeToString(hash));
    // }

    // /**
    //  * Argon2 derivation with high memory and more iterations.
    //  *
    //  * SAST/CBOM:
    //  * - Parent: Argon2.
    //  * - Uses high memory (131072 KB = 128MB) and 5 iterations; secure but resource
    //  * intensive.
    //  */
    // public void argon2HighMemory(String password) throws Exception {
    //     byte[] salt = generateSalt(16);
    //     Argon2Parameters.Builder builder = new Argon2Parameters.Builder(Argon2Parameters.ARGON2_id)
    //             .withSalt(salt)
    //             .withParallelism(4)
    //             .withMemoryAsKB(131072) // 128MB of memory.
    //             .withIterations(5);

    //     Argon2BytesGenerator gen = new Argon2BytesGenerator();
    //     gen.init(builder.build());
    //     byte[] hash = new byte[64];
    //     gen.generateBytes(password.getBytes(), hash, 0, hash.length);
    //     System.out.println("Argon2 (High Memory) Key: " + Base64.getEncoder().encodeToString(hash));
    // }

    //////////////////////////////////////
    // 4. INSECURE RAW HASH EXAMPLES
    //////////////////////////////////////

    /**
     * Derives a key by directly hashing input with SHA-256 and uses it for
     * encryption.
     *
     * SAST/CBOM:
     * - Parent: Raw Hash-Based Key Derivation.
     * - This approach is insecure since it uses a raw hash as a key and then uses
     * AES in ECB mode,
     * which is vulnerable to pattern analysis.
     */
    public void insecureRawSHA256Derivation(String input) throws Exception {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        byte[] derivedKey = digest.digest(input.getBytes());
        System.out.println("Insecure Raw SHA-256 Key: " + Base64.getEncoder().encodeToString(derivedKey));

        // Insecure usage: AES/ECB mode is used with a key derived from a raw hash.
        SecretKey key = new SecretKeySpec(derivedKey, 0, 16, "AES");
        javax.crypto.Cipher cipher = javax.crypto.Cipher.getInstance("AES/ECB/NoPadding");
        cipher.init(javax.crypto.Cipher.ENCRYPT_MODE, key);
        byte[] ciphertext = cipher.doFinal("SampleData16Bytes".getBytes());
        System.out.println("Insecurely Encrypted Data with Raw-SHA256 Key: "
                + Base64.getEncoder().encodeToString(ciphertext));
    }

    //////////////////////////////////////
    // 5. HKDF EXAMPLES
    //////////////////////////////////////

    /**
     * Derives a key using a simple HKDF expansion based on HMAC-SHA256.
     *
     * SAST/CBOM:
     * - Parent: HKDF.
     * - The implementation uses a single-block (simplistic) expansion and may be
     * flagged.
     * A full, standard HKDF implementation is recommended.
     */
    public void hkdfDerivation(byte[] ikm) throws Exception {
        byte[] salt = generateSalt(32);
        byte[] derivedKey = hkdfExpand(ikm, salt, 32);
        System.out.println("HKDF Derived Key: " + Base64.getEncoder().encodeToString(derivedKey));
    }

    /**
     * Multi-step hybrid derivation: first using PBKDF2, then applying HKDF
     * expansion.
     *
     * SAST/CBOM: - Parent: Composite KDF. - Combining PBKDF2 and HKDF is a
     * non-standard approach and may be flagged; ensure that each step meets
     * security requirements.
     */
    public void multiStepHybridDerivation(String password, byte[] sharedSecret) throws Exception {
        byte[] pbkdf2Key = derivePBKDF2Key(password);
        byte[] finalKey = hkdfExpand(sharedSecret, pbkdf2Key, 32);
        System.out.println("Multi-Step Hybrid Key: " + Base64.getEncoder().encodeToString(finalKey));
    }

    //////////////////////////////////////
    // 6. DYNAMIC ALGORITHM SELECTION (AMBIGUOUS CASE)
    //////////////////////////////////////

    /**
     * Dynamically selects a KDF algorithm based on external configuration.
     *
     * SAST/CBOM:
     * - Parent: Dynamic/Configurable Key Derivation.
     * - Loading the algorithm and parameters from a config file introduces risk if
     * the configuration is compromised
     * or misconfigured.
     */
    public void dynamicKDFSelection(String password, String configPath) throws Exception {
        Properties props = new Properties();
        try (FileInputStream fis = new FileInputStream(configPath)) {
            props.load(fis);
        } catch (IOException e) {
            e.printStackTrace();
        }
        String kdfAlg = props.getProperty("kdf.alg", "PBKDF2WithHmacSHA256");
        int iterations = Integer.parseInt(props.getProperty("kdf.iterations", "10000"));
        int keySize = Integer.parseInt(props.getProperty("kdf.keySize", "256"));

        byte[] salt = generateSalt(16);
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, iterations, keySize);
        SecretKeyFactory factory = SecretKeyFactory.getInstance(kdfAlg);
        byte[] derived = factory.generateSecret(spec).getEncoded();
        System.out.println("Dynamically Selected KDF (" + kdfAlg + ") Key: "
                + Base64.getEncoder().encodeToString(derived));
    }

    //////////////////////////////////////
    // HELPER METHODS
    //////////////////////////////////////

    /**
     * Helper method to derive a PBKDF2 key with PBKDF2WithHmacSHA256.
     *
     * SAST/CBOM:
     * - Parent: PBKDF2 helper.
     */
    private byte[] derivePBKDF2Key(String password) throws Exception {
        byte[] salt = generateSalt(16);
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, 10000, 256);
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
        return factory.generateSecret(spec).getEncoded();
    }

    /**
     * A simplistic HKDF expansion function using HMAC-SHA256.
     *
     * SAST/CBOM: - Parent: HKDF. - Uses a single-block expansion
     * ("hkdf-expansion") which is non-standard and may be flagged.
     */
    private byte[] hkdfExpand(byte[] ikm, byte[] salt, int length) throws Exception {
        Mac hmac = Mac.getInstance("HmacSHA256");
        SecretKey secretKey = new SecretKeySpec(salt, "HmacSHA256");
        hmac.init(secretKey);
        byte[] prk = hmac.doFinal(ikm); // Extraction step.

        // Single-block expansion (non-standard; for full HKDF, multiple iterations may
        // be necessary)
        hmac.init(new SecretKeySpec(prk, "HmacSHA256"));
        byte[] okm = hmac.doFinal("hkdf-expansion".getBytes());
        return Arrays.copyOf(okm, length);
    }

    /**
     * Generates a secure random salt of the specified length.
     *
     * SAST/CBOM: - Parent: Secure Random Salt Generation. - Uses SecureRandom;
     * considered best practice.
     */
    private byte[] generateSalt(int length) {
        byte[] salt = new byte[length];
        new SecureRandom().nextBytes(salt);
        return salt;
    }
}
