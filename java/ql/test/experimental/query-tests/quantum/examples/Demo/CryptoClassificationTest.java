import java.security.*;
import java.security.spec.ECGenParameterSpec;
import java.security.spec.PSSParameterSpec;
import java.security.spec.MGF1ParameterSpec;
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.KeyAgreement;
import javax.servlet.http.HttpServletRequest;

/**
 * Comprehensive test source exercising ALL crypto algorithm/mode/padding/hash/curve/key-size
 * classifications defined in QuantumCryptoClassification.qll.
 *
 * Each JCA API call is annotated with expected query alerts via inline expectations.
 */
public class CryptoClassificationTest {

    // ================================================================
    // QUANTUM-VULNERABLE ALGORITHMS
    // ================================================================

    public void quantumVulnerableAlgorithms() throws Exception {
        byte[] data = "Sensitive Data".getBytes();

        // RSA cipher with PKCS1Padding (quantum-vulnerable algorithm + padding + protocol)
        Cipher rsaCipher = Cipher.getInstance("RSA/ECB/PKCS1Padding"); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/quantum-vulnerable-padding] Alert[java/quantum/examples/demo/protocol-rsa-pkcs1v15] Alert[java/quantum/examples/demo/insecure-block-mode] Alert[java/quantum/examples/demo/inventory-algorithms] Alert[java/quantum/examples/demo/inventory-modes] Alert[java/quantum/examples/demo/inventory-padding]
        rsaCipher.init(Cipher.ENCRYPT_MODE, KeyPairGenerator.getInstance("RSA").generateKeyPair().getPublic()); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/inventory-algorithms]
        byte[] rsaEncrypted = rsaCipher.doFinal(data);

        // RSA-OAEP cipher (quantum-vulnerable algorithm + padding + protocol)
        Cipher rsaOaepCipher = Cipher.getInstance("RSA/ECB/OAEPWithSHA-256AndMGF1Padding"); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/quantum-vulnerable-padding] Alert[java/quantum/examples/demo/protocol-rsa-oaep] Alert[java/quantum/examples/demo/insecure-block-mode] Alert[java/quantum/examples/demo/inventory-algorithms] Alert[java/quantum/examples/demo/inventory-hashes] Alert[java/quantum/examples/demo/inventory-modes] Alert[java/quantum/examples/demo/inventory-padding] Alert[java/quantum/examples/demo/secure-hash]
        rsaOaepCipher.init(Cipher.ENCRYPT_MODE, KeyPairGenerator.getInstance("RSA").generateKeyPair().getPublic()); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/inventory-algorithms]
        byte[] rsaOaepEncrypted = rsaOaepCipher.doFinal(data);

        // DSA signature (quantum-vulnerable)
        Signature dsaSig = Signature.getInstance("SHA256withDSA"); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/inventory-algorithms] Alert[java/quantum/examples/demo/inventory-hashes] Alert[java/quantum/examples/demo/secure-hash]
        dsaSig.initSign(KeyPairGenerator.getInstance("DSA").generateKeyPair().getPrivate()); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/inventory-algorithms]
        dsaSig.update(data);
        byte[] dsaSignature = dsaSig.sign();

        // ECDSA signature (quantum-vulnerable)
        Signature ecdsaSig = Signature.getInstance("SHA256withECDSA"); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/inventory-algorithms] Alert[java/quantum/examples/demo/inventory-hashes] Alert[java/quantum/examples/demo/secure-hash]
        ecdsaSig.initSign(KeyPairGenerator.getInstance("EC").generateKeyPair().getPrivate());
        ecdsaSig.update(data);
        byte[] ecdsaSignature = ecdsaSig.sign();

        // EdDSA Ed25519 signature (quantum-vulnerable)
        Signature ed25519Sig = Signature.getInstance("Ed25519"); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/inventory-algorithms]
        ed25519Sig.initSign(KeyPairGenerator.getInstance("Ed25519").generateKeyPair().getPrivate()); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/inventory-algorithms] Alert[java/quantum/examples/demo/quantum-vulnerable-curve] Alert[java/quantum/examples/demo/inventory-curves]
        ed25519Sig.update(data);
        byte[] ed25519Signature = ed25519Sig.sign();

        // EdDSA Ed448 signature (quantum-vulnerable)
        Signature ed448Sig = Signature.getInstance("Ed448"); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/inventory-algorithms]
        ed448Sig.initSign(KeyPairGenerator.getInstance("Ed448").generateKeyPair().getPrivate()); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/inventory-algorithms] Alert[java/quantum/examples/demo/quantum-vulnerable-curve] Alert[java/quantum/examples/demo/inventory-curves]
        ed448Sig.update(data);
        byte[] ed448Signature = ed448Sig.sign();
    }

    // ================================================================
    // QUANTUM-VULNERABLE PROTOCOLS — RSA-PSS (RSASSA-PSS)
    // ================================================================

    public void rsaPssProtocol() throws Exception {
        byte[] data = "Sensitive Data".getBytes();

        // RSA-PSS with explicit PSSParameterSpec
        Signature rsaPssSig = Signature.getInstance("RSASSA-PSS"); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/quantum-vulnerable-padding] Alert[java/quantum/examples/demo/protocol-rsa-pss] Alert[java/quantum/examples/demo/protocol-jws-ps] Alert[java/quantum/examples/demo/inventory-algorithms] Alert[java/quantum/examples/demo/inventory-padding]
        PSSParameterSpec pssSpec = new PSSParameterSpec(
                "SHA-256", "MGF1", MGF1ParameterSpec.SHA256, 32, 1); // $ Alert[java/quantum/examples/demo/inventory-hashes] Alert[java/quantum/examples/demo/inventory-hashes] Alert[java/quantum/examples/demo/secure-hash] Alert[java/quantum/examples/demo/secure-hash]
        rsaPssSig.setParameter(pssSpec);
        KeyPairGenerator rsaKpg = KeyPairGenerator.getInstance("RSA"); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/inventory-algorithms]
        rsaKpg.initialize(2048);
        rsaPssSig.initSign(rsaKpg.generateKeyPair().getPrivate()); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-key-size] Alert[java/quantum/examples/demo/inventory-key-sizes]
        rsaPssSig.update(data);
        byte[] pssSigBytes = rsaPssSig.sign();
    }

    // ================================================================
    // QUANTUM-VULNERABLE PROTOCOLS — RSA PKCS#1 v1.5 signing (JWS RS)
    // ================================================================

    public void rsaPkcs1v15SigningProtocol() throws Exception {
        byte[] data = "Sensitive Data".getBytes();

        // RS256: RSA PKCS#1 v1.5 + SHA-256
        Signature rs256 = Signature.getInstance("SHA256withRSA"); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/inventory-algorithms] Alert[java/quantum/examples/demo/inventory-hashes] Alert[java/quantum/examples/demo/secure-hash]

        // RS384: RSA PKCS#1 v1.5 + SHA-384
        Signature rs384 = Signature.getInstance("SHA384withRSA"); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/inventory-algorithms] Alert[java/quantum/examples/demo/inventory-hashes] Alert[java/quantum/examples/demo/secure-hash]

        // RS512: RSA PKCS#1 v1.5 + SHA-512
        Signature rs512 = Signature.getInstance("SHA512withRSA"); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/inventory-algorithms] Alert[java/quantum/examples/demo/inventory-hashes] Alert[java/quantum/examples/demo/secure-hash]
    }

    // ================================================================
    // QUANTUM-VULNERABLE PROTOCOLS — RSA-PSS signing (JWS PS)
    // ================================================================

    public void rsaPssSigningProtocol() throws Exception {
        byte[] data = "Sensitive Data".getBytes();

        // PS256: RSA-PSS + SHA-256
        Signature ps256 = Signature.getInstance("SHA256withRSAandMGF1"); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/quantum-vulnerable-padding] Alert[java/quantum/examples/demo/protocol-rsa-pss] Alert[java/quantum/examples/demo/inventory-algorithms] Alert[java/quantum/examples/demo/inventory-hashes] Alert[java/quantum/examples/demo/inventory-padding] Alert[java/quantum/examples/demo/secure-hash]

        // PS384: RSA-PSS + SHA-384
        Signature ps384 = Signature.getInstance("SHA384withRSAandMGF1"); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/quantum-vulnerable-padding] Alert[java/quantum/examples/demo/protocol-rsa-pss] Alert[java/quantum/examples/demo/inventory-algorithms] Alert[java/quantum/examples/demo/inventory-hashes] Alert[java/quantum/examples/demo/inventory-padding] Alert[java/quantum/examples/demo/secure-hash]

        // PS512: RSA-PSS + SHA-512
        Signature ps512 = Signature.getInstance("SHA512withRSAandMGF1"); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/quantum-vulnerable-padding] Alert[java/quantum/examples/demo/protocol-rsa-pss] Alert[java/quantum/examples/demo/inventory-algorithms] Alert[java/quantum/examples/demo/inventory-hashes] Alert[java/quantum/examples/demo/inventory-padding] Alert[java/quantum/examples/demo/secure-hash]
    }

    // ================================================================
    // QUANTUM-VULNERABLE KEY AGREEMENTS
    // ================================================================

    public void quantumVulnerableKeyAgreements() throws Exception {
        // DH key agreement (quantum-vulnerable)
        KeyAgreement dhKA = KeyAgreement.getInstance("DH"); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/inventory-algorithms]

        // ECDH key agreement (quantum-vulnerable)
        KeyAgreement ecdhKA = KeyAgreement.getInstance("ECDH"); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/inventory-algorithms]

        // ECMQV key agreement (quantum-vulnerable)
        KeyAgreement ecmqvKA = KeyAgreement.getInstance("ECMQV"); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/inventory-algorithms]
    }

    // ================================================================
    // QUANTUM-VULNERABLE KEY SIZES
    // ================================================================

    public void quantumVulnerableKeySizes() throws Exception {
        // RSA key sizes
        KeyPairGenerator rsaKpg1 = KeyPairGenerator.getInstance("RSA"); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/inventory-algorithms]
        rsaKpg1.initialize(1024);
        rsaKpg1.generateKeyPair(); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-key-size] Alert[java/quantum/examples/demo/inventory-key-sizes]

        KeyPairGenerator rsaKpg2 = KeyPairGenerator.getInstance("RSA"); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/inventory-algorithms]
        rsaKpg2.initialize(2048);
        rsaKpg2.generateKeyPair(); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-key-size] Alert[java/quantum/examples/demo/inventory-key-sizes]

        KeyPairGenerator rsaKpg3 = KeyPairGenerator.getInstance("RSA"); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/inventory-algorithms]
        rsaKpg3.initialize(3072);
        rsaKpg3.generateKeyPair(); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-key-size] Alert[java/quantum/examples/demo/inventory-key-sizes]

        KeyPairGenerator rsaKpg4 = KeyPairGenerator.getInstance("RSA"); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/inventory-algorithms]
        rsaKpg4.initialize(4096);
        rsaKpg4.generateKeyPair(); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-key-size] Alert[java/quantum/examples/demo/inventory-key-sizes]

        // DSA key sizes
        KeyPairGenerator dsaKpg1 = KeyPairGenerator.getInstance("DSA"); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/inventory-algorithms]
        dsaKpg1.initialize(1024);
        dsaKpg1.generateKeyPair(); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-key-size] Alert[java/quantum/examples/demo/inventory-key-sizes]

        KeyPairGenerator dsaKpg2 = KeyPairGenerator.getInstance("DSA"); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/inventory-algorithms]
        dsaKpg2.initialize(2048);
        dsaKpg2.generateKeyPair(); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-key-size] Alert[java/quantum/examples/demo/inventory-key-sizes]

        // DH key sizes
        KeyPairGenerator dhKpg1 = KeyPairGenerator.getInstance("DH"); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/inventory-algorithms]
        dhKpg1.initialize(1024);
        dhKpg1.generateKeyPair(); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-key-size] Alert[java/quantum/examples/demo/inventory-key-sizes]

        KeyPairGenerator dhKpg2 = KeyPairGenerator.getInstance("DH"); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/inventory-algorithms]
        dhKpg2.initialize(2048);
        dhKpg2.generateKeyPair(); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-key-size] Alert[java/quantum/examples/demo/inventory-key-sizes]

        KeyPairGenerator dhKpg3 = KeyPairGenerator.getInstance("DH"); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/inventory-algorithms]
        dhKpg3.initialize(4096);
        dhKpg3.generateKeyPair(); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-key-size] Alert[java/quantum/examples/demo/inventory-key-sizes]
    }

    // ================================================================
    // QUANTUM-VULNERABLE CURVES
    // ================================================================

    public void quantumVulnerableCurves() throws Exception {
        // NIST/SEC curves
        KeyPairGenerator ecKpg1 = KeyPairGenerator.getInstance("EC");
        ecKpg1.initialize(new ECGenParameterSpec("secp256r1")); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-curve] Alert[java/quantum/examples/demo/inventory-curves]
        ecKpg1.generateKeyPair();

        KeyPairGenerator ecKpg2 = KeyPairGenerator.getInstance("EC");
        ecKpg2.initialize(new ECGenParameterSpec("secp384r1")); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-curve] Alert[java/quantum/examples/demo/inventory-curves]
        ecKpg2.generateKeyPair();

        KeyPairGenerator ecKpg3 = KeyPairGenerator.getInstance("EC");
        ecKpg3.initialize(new ECGenParameterSpec("secp521r1")); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-curve] Alert[java/quantum/examples/demo/inventory-curves]
        ecKpg3.generateKeyPair();

        KeyPairGenerator ecKpg4 = KeyPairGenerator.getInstance("EC");
        ecKpg4.initialize(new ECGenParameterSpec("secp256k1")); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-curve] Alert[java/quantum/examples/demo/inventory-curves]
        ecKpg4.generateKeyPair();

        // Curve25519/448 via KeyPairGenerator
        KeyPairGenerator x25519Kpg = KeyPairGenerator.getInstance("X25519"); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-curve] Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/inventory-algorithms] Alert[java/quantum/examples/demo/inventory-curves]
        x25519Kpg.generateKeyPair();

        KeyPairGenerator x448Kpg = KeyPairGenerator.getInstance("X448"); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-curve] Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/inventory-algorithms] Alert[java/quantum/examples/demo/inventory-curves]
        x448Kpg.generateKeyPair();

        // Ed25519/Ed448 curves
        KeyPairGenerator ed25519Kpg = KeyPairGenerator.getInstance("Ed25519"); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-curve] Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/inventory-algorithms] Alert[java/quantum/examples/demo/inventory-curves]
        ed25519Kpg.generateKeyPair();

        KeyPairGenerator ed448Kpg = KeyPairGenerator.getInstance("Ed448"); // $ Alert[java/quantum/examples/demo/quantum-vulnerable-curve] Alert[java/quantum/examples/demo/quantum-vulnerable-algorithm] Alert[java/quantum/examples/demo/inventory-algorithms] Alert[java/quantum/examples/demo/inventory-curves]
        ed448Kpg.generateKeyPair();
    }

    // ================================================================
    // INSECURE CIPHERS
    // ================================================================

    public void insecureCiphers() throws Exception {
        byte[] data = "Sensitive Data".getBytes();

        // DES (insecure)
        Cipher desCipher = Cipher.getInstance("DES"); // $ Alert[java/quantum/examples/demo/insecure-cipher] Alert[java/quantum/examples/demo/inventory-algorithms]
        KeyGenerator desKg = KeyGenerator.getInstance("DES"); // $ Alert[java/quantum/examples/demo/insecure-cipher] Alert[java/quantum/examples/demo/inventory-algorithms]
        SecretKey desKey = desKg.generateKey();
        desCipher.init(Cipher.ENCRYPT_MODE, desKey);
        byte[] desEncrypted = desCipher.doFinal(data);

        // DESede / Triple DES (insecure)
        Cipher desedeCipher = Cipher.getInstance("DESede"); // $ Alert[java/quantum/examples/demo/insecure-cipher] Alert[java/quantum/examples/demo/inventory-algorithms]
        KeyGenerator desedeKg = KeyGenerator.getInstance("DESede"); // $ Alert[java/quantum/examples/demo/insecure-cipher] Alert[java/quantum/examples/demo/inventory-algorithms]
        SecretKey desedeKey = desedeKg.generateKey();
        desedeCipher.init(Cipher.ENCRYPT_MODE, desedeKey);
        byte[] desedeEncrypted = desedeCipher.doFinal(data);

        // Blowfish (insecure)
        Cipher blowfishCipher = Cipher.getInstance("Blowfish"); // $ Alert[java/quantum/examples/demo/insecure-cipher] Alert[java/quantum/examples/demo/inventory-algorithms]
        KeyGenerator blowfishKg = KeyGenerator.getInstance("Blowfish"); // $ Alert[java/quantum/examples/demo/insecure-cipher] Alert[java/quantum/examples/demo/inventory-algorithms]
        SecretKey blowfishKey = blowfishKg.generateKey();
        blowfishCipher.init(Cipher.ENCRYPT_MODE, blowfishKey);
        byte[] blowfishEncrypted = blowfishCipher.doFinal(data);

        // IDEA (insecure)
        Cipher ideaCipher = Cipher.getInstance("IDEA"); // $ Alert[java/quantum/examples/demo/insecure-cipher] Alert[java/quantum/examples/demo/inventory-algorithms]
        KeyGenerator ideaKg = KeyGenerator.getInstance("IDEA"); // $ Alert[java/quantum/examples/demo/insecure-cipher] Alert[java/quantum/examples/demo/inventory-algorithms]
        SecretKey ideaKey = ideaKg.generateKey();
        ideaCipher.init(Cipher.ENCRYPT_MODE, ideaKey);
        byte[] ideaEncrypted = ideaCipher.doFinal(data);

        // SEED (insecure)
        Cipher seedCipher = Cipher.getInstance("SEED"); // $ Alert[java/quantum/examples/demo/insecure-cipher] Alert[java/quantum/examples/demo/inventory-algorithms]
        KeyGenerator seedKg = KeyGenerator.getInstance("SEED"); // $ Alert[java/quantum/examples/demo/insecure-cipher] Alert[java/quantum/examples/demo/inventory-algorithms]
        SecretKey seedKey = seedKg.generateKey();
        seedCipher.init(Cipher.ENCRYPT_MODE, seedKey);
        byte[] seedEncrypted = seedCipher.doFinal(data);
    }

    // ================================================================
    // INSECURE BLOCK MODES
    // ================================================================

    public void insecureBlockModes() throws Exception {
        SecretKey aesKey = KeyGenerator.getInstance("AES").generateKey(); // $ Alert[java/quantum/examples/demo/secure-cipher] Alert[java/quantum/examples/demo/inventory-algorithms]
        byte[] data = "Sensitive Data".getBytes();

        // ECB mode (insecure)
        Cipher ecbCipher = Cipher.getInstance("AES/ECB/PKCS5Padding"); // $ Alert[java/quantum/examples/demo/insecure-block-mode] Alert[java/quantum/examples/demo/secure-cipher] Alert[java/quantum/examples/demo/inventory-algorithms] Alert[java/quantum/examples/demo/inventory-modes] Alert[java/quantum/examples/demo/inventory-padding]
        ecbCipher.init(Cipher.ENCRYPT_MODE, aesKey);
        byte[] ecbEncrypted = ecbCipher.doFinal(data);

        // CFB mode (insecure)
        Cipher cfbCipher = Cipher.getInstance("AES/CFB/NoPadding"); // $ Alert[java/quantum/examples/demo/insecure-block-mode] Alert[java/quantum/examples/demo/secure-cipher] Alert[java/quantum/examples/demo/inventory-algorithms] Alert[java/quantum/examples/demo/inventory-modes] Alert[java/quantum/examples/demo/inventory-padding]
        cfbCipher.init(Cipher.ENCRYPT_MODE, aesKey);
        byte[] cfbEncrypted = cfbCipher.doFinal(data);

        // OFB mode (insecure)
        Cipher ofbCipher = Cipher.getInstance("AES/OFB/NoPadding"); // $ Alert[java/quantum/examples/demo/insecure-block-mode] Alert[java/quantum/examples/demo/secure-cipher] Alert[java/quantum/examples/demo/inventory-algorithms] Alert[java/quantum/examples/demo/inventory-modes] Alert[java/quantum/examples/demo/inventory-padding]
        ofbCipher.init(Cipher.ENCRYPT_MODE, aesKey);
        byte[] ofbEncrypted = ofbCipher.doFinal(data);
    }

    // ================================================================
    // INSECURE HASH
    // ================================================================

    public void insecureHash() throws Exception {
        // SHA-1 (insecure)
        MessageDigest sha1 = MessageDigest.getInstance("SHA-1"); // $ Alert[java/quantum/examples/demo/insecure-hash] Alert[java/quantum/examples/demo/inventory-hashes]
        byte[] sha1Digest = sha1.digest("data".getBytes());
    }

    // ================================================================
    // SECURE & QUANTUM-PROOF CIPHERS (should NOT trigger insecure/QV alerts)
    // ================================================================

    public void secureCiphers() throws Exception {
        byte[] data = "Sensitive Data".getBytes();

        // AES-128 GCM (secure)
        KeyGenerator aesKg128 = KeyGenerator.getInstance("AES"); // $ Alert[java/quantum/examples/demo/secure-cipher] Alert[java/quantum/examples/demo/inventory-algorithms]
        aesKg128.init(128);
        SecretKey aes128Key = aesKg128.generateKey(); // $ Alert[java/quantum/examples/demo/inventory-key-sizes]
        Cipher aes128Gcm = Cipher.getInstance("AES/GCM/NoPadding"); // $ Alert[java/quantum/examples/demo/secure-cipher] Alert[java/quantum/examples/demo/inventory-algorithms] Alert[java/quantum/examples/demo/inventory-modes] Alert[java/quantum/examples/demo/inventory-padding]
        aes128Gcm.init(Cipher.ENCRYPT_MODE, aes128Key);
        byte[] aes128Encrypted = aes128Gcm.doFinal(data);

        // AES-192 GCM (secure)
        KeyGenerator aesKg192 = KeyGenerator.getInstance("AES"); // $ Alert[java/quantum/examples/demo/secure-cipher] Alert[java/quantum/examples/demo/inventory-algorithms]
        aesKg192.init(192);
        SecretKey aes192Key = aesKg192.generateKey(); // $ Alert[java/quantum/examples/demo/inventory-key-sizes]
        Cipher aes192Gcm = Cipher.getInstance("AES/GCM/NoPadding"); // $ Alert[java/quantum/examples/demo/secure-cipher] Alert[java/quantum/examples/demo/inventory-algorithms] Alert[java/quantum/examples/demo/inventory-modes] Alert[java/quantum/examples/demo/inventory-padding]
        aes192Gcm.init(Cipher.ENCRYPT_MODE, aes192Key);
        byte[] aes192Encrypted = aes192Gcm.doFinal(data);

        // AES-256 GCM (secure)
        KeyGenerator aesKg256 = KeyGenerator.getInstance("AES"); // $ Alert[java/quantum/examples/demo/secure-cipher] Alert[java/quantum/examples/demo/inventory-algorithms]
        aesKg256.init(256);
        SecretKey aes256Key = aesKg256.generateKey(); // $ Alert[java/quantum/examples/demo/inventory-key-sizes]
        Cipher aes256Gcm = Cipher.getInstance("AES/GCM/NoPadding"); // $ Alert[java/quantum/examples/demo/secure-cipher] Alert[java/quantum/examples/demo/inventory-algorithms] Alert[java/quantum/examples/demo/inventory-modes] Alert[java/quantum/examples/demo/inventory-padding]
        aes256Gcm.init(Cipher.ENCRYPT_MODE, aes256Key);
        byte[] aes256Encrypted = aes256Gcm.doFinal(data);

        // ChaCha20 (secure)
        Cipher chacha20 = Cipher.getInstance("ChaCha20"); // $ Alert[java/quantum/examples/demo/secure-cipher] Alert[java/quantum/examples/demo/inventory-algorithms]
        // ChaCha20 key is always 256 bits

        // AES CBC (secure cipher, but mode/padding is separate concern)
        Cipher aesCbc = Cipher.getInstance("AES/CBC/PKCS5Padding"); // $ Alert[java/quantum/examples/demo/secure-cipher] Alert[java/quantum/examples/demo/inventory-algorithms] Alert[java/quantum/examples/demo/inventory-modes] Alert[java/quantum/examples/demo/inventory-padding]
        aesCbc.init(Cipher.ENCRYPT_MODE, aes128Key);
        byte[] aesCbcEncrypted = aesCbc.doFinal(data);
    }

    // ================================================================
    // SECURE & QUANTUM-PROOF HASHES (should NOT trigger insecure alerts)
    // ================================================================

    public void secureHashes() throws Exception {
        // SHA-256 (secure)
        MessageDigest sha256 = MessageDigest.getInstance("SHA-256"); // $ Alert[java/quantum/examples/demo/secure-hash] Alert[java/quantum/examples/demo/inventory-hashes]
        byte[] sha256Digest = sha256.digest("data".getBytes());

        // SHA-384 (secure)
        MessageDigest sha384 = MessageDigest.getInstance("SHA-384"); // $ Alert[java/quantum/examples/demo/secure-hash] Alert[java/quantum/examples/demo/inventory-hashes]
        byte[] sha384Digest = sha384.digest("data".getBytes());

        // SHA-512 (secure)
        MessageDigest sha512 = MessageDigest.getInstance("SHA-512"); // $ Alert[java/quantum/examples/demo/secure-hash] Alert[java/quantum/examples/demo/inventory-hashes]
        byte[] sha512Digest = sha512.digest("data".getBytes());

        // SHA3-256 (secure)
        MessageDigest sha3_256 = MessageDigest.getInstance("SHA3-256"); // $ Alert[java/quantum/examples/demo/secure-hash] Alert[java/quantum/examples/demo/inventory-hashes]
        byte[] sha3_256Digest = sha3_256.digest("data".getBytes());

        // SHA3-512 (secure)
        MessageDigest sha3_512 = MessageDigest.getInstance("SHA3-512"); // $ Alert[java/quantum/examples/demo/secure-hash] Alert[java/quantum/examples/demo/inventory-hashes]
        byte[] sha3_512Digest = sha3_512.digest("data".getBytes());
    }

    // ================================================================
    // KNOWN UNKNOWNS — Algorithm from remote/external source
    // ================================================================

    public void unknownAlgorithmFromRemoteSource(HttpServletRequest request) throws Exception {
        // Remote source: algorithm from HTTP request parameter
        String algo = request.getParameter("algo");
        Cipher remoteCipher = Cipher.getInstance(algo);
    }

    public void unknownAlgorithmFromParameter(String algo) throws Exception {
        // Parameter source: algorithm from method parameter
        Cipher paramCipher = Cipher.getInstance(algo);
    }
}
