import javax.crypto.KeyGenerator;
import java.security.KeyPairGenerator;

import java.security.spec.ECGenParameterSpec;
import java.security.spec.RSAKeyGenParameterSpec;
import java.security.spec.DSAGenParameterSpec;
import javax.crypto.spec.DHGenParameterSpec;


public class InsufficientKeySizeTest {
    public void keySizeTesting() throws java.security.NoSuchAlgorithmException, java.security.InvalidAlgorithmParameterException {

        /* AES (Symmetric): minimum recommended key size is 128 */
        {
            /* Test with keysize as int */
            KeyGenerator keyGen1 = KeyGenerator.getInstance("AES");
            keyGen1.init(64); // $ hasInsufficientKeySize

            KeyGenerator keyGen2 = KeyGenerator.getInstance("AES");
            keyGen2.init(128); // Safe: Key size is no less than 128

            /* Test with local variable as keysize */
            final int size1 = 64; // compile-time constant
            int size2 = 64;       // not a compile-time constant

            KeyGenerator keyGen3 = KeyGenerator.getInstance("AES");
            keyGen3.init(size1); // $ hasInsufficientKeySize

            KeyGenerator keyGen4 = KeyGenerator.getInstance("AES");
            keyGen4.init(size2); // $ hasInsufficientKeySize

            /* Test variables passed to another method */
            KeyGenerator keyGen = KeyGenerator.getInstance("AES"); // MISSING: test KeyGenerator variable as argument
            testSymmetricVariable(size2, keyGen); // test with variable as key size
            testSymmetricInt(64); // test with int literal as key size
        }

        // RSA (Asymmetric): minimum recommended key size is 2048
        {
            /* Test with keysize as int */
            KeyPairGenerator keyPairGen1 = KeyPairGenerator.getInstance("RSA");
            keyPairGen1.initialize(1024); // $ hasInsufficientKeySize

            KeyPairGenerator keyPairGen2 = KeyPairGenerator.getInstance("RSA");
            keyPairGen2.initialize(2048); // Safe: Key size is no less than 2048

            KeyPairGenerator keyPairGen3 = KeyPairGenerator.getInstance("RSA");
            RSAKeyGenParameterSpec rsaSpec = new RSAKeyGenParameterSpec(1024, null); // $ hasInsufficientKeySize
            keyPairGen3.initialize(rsaSpec);

            KeyPairGenerator keyPairGen4 = KeyPairGenerator.getInstance("RSA");
            keyPairGen4.initialize(new RSAKeyGenParameterSpec(1024, null)); // $ hasInsufficientKeySize

            /* Test with local variable as keysize */
            final int size1 = 1024; // compile-time constant
            int size2 = 1024;       // not a compile-time constant

            KeyPairGenerator keyPairGen5 = KeyPairGenerator.getInstance("RSA");
            keyPairGen5.initialize(size1); // $ hasInsufficientKeySize

            KeyPairGenerator keyPairGen6 = KeyPairGenerator.getInstance("RSA");
            keyPairGen6.initialize(size2); // $ hasInsufficientKeySize

            /* Test variables passed to another method */
            KeyPairGenerator keyPairGen = KeyPairGenerator.getInstance("RSA"); // MISSING: test KeyGenerator variable as argument
            testAsymmetricNonEcVariable(size2, keyPairGen); // test with variable as key size
            testAsymmetricNonEcInt(1024); // test with int literal as key size
        }

        // DSA (Asymmetric): minimum recommended key size is 2048
        {
            /* Test with keysize as int */
            KeyPairGenerator keyPairGen1 = KeyPairGenerator.getInstance("DSA");
            keyPairGen1.initialize(1024); // $ hasInsufficientKeySize

            KeyPairGenerator keyPairGen2 = KeyPairGenerator.getInstance("DSA");
            keyPairGen2.initialize(2048); // Safe: Key size is no less than 2048

            KeyPairGenerator keyPairGen3 = KeyPairGenerator.getInstance("DSA");
            DSAGenParameterSpec dsaSpec = new DSAGenParameterSpec(1024, 0); // $ hasInsufficientKeySize
            keyPairGen3.initialize(dsaSpec);

            KeyPairGenerator keyPairGen4 = KeyPairGenerator.getInstance("DSA");
            keyPairGen4.initialize(new DSAGenParameterSpec(1024, 0)); // $ hasInsufficientKeySize
        }

        // DH (Asymmetric): minimum recommended key size is 2048
        {
            /* Test with keysize as int */
            KeyPairGenerator keyPairGen1 = KeyPairGenerator.getInstance("dh");
            keyPairGen1.initialize(1024); // $ hasInsufficientKeySize

            KeyPairGenerator keyPairGen2 = KeyPairGenerator.getInstance("DH");
            keyPairGen2.initialize(2048); // Safe: Key size is no less than 2048

            KeyPairGenerator keyPairGen3 = KeyPairGenerator.getInstance("DH");
            DHGenParameterSpec dhSpec = new DHGenParameterSpec(1024, 0); // $ hasInsufficientKeySize
            keyPairGen3.initialize(dhSpec);

            KeyPairGenerator keyPairGen4 = KeyPairGenerator.getInstance("DH");
            keyPairGen4.initialize(new DHGenParameterSpec(1024, 0)); // $ hasInsufficientKeySize
        }

        // EC (Asymmetric): minimum recommended key size is 256
        {
            /* Test with keysize as int */
            KeyPairGenerator keyPairGen1 = KeyPairGenerator.getInstance("EC");
            keyPairGen1.initialize(128); // $ hasInsufficientKeySize

            /* Test with keysize as curve name in spec */
            KeyPairGenerator keyPairGen2 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec1 = new ECGenParameterSpec("secp112r1"); // $ hasInsufficientKeySize
            keyPairGen2.initialize(ecSpec1);

            KeyPairGenerator keyPairGen3 = KeyPairGenerator.getInstance("EC");
            keyPairGen3.initialize(new ECGenParameterSpec("secp112r1")); // $ hasInsufficientKeySize

            KeyPairGenerator keyPairGen4 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec2 = new ECGenParameterSpec("secp256r1"); // Safe: Key size is no less than 256
            keyPairGen4.initialize(ecSpec2);

            KeyPairGenerator keyPairGen5 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec3 = new ECGenParameterSpec("X9.62 prime192v2"); // $ hasInsufficientKeySize
            keyPairGen5.initialize(ecSpec3);

            KeyPairGenerator keyPairGen6 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec4 = new ECGenParameterSpec("X9.62 c2tnb191v3"); // $ hasInsufficientKeySize
            keyPairGen6.initialize(ecSpec4);

            KeyPairGenerator keyPairGen7 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec5 = new ECGenParameterSpec("sect163k1"); // $ hasInsufficientKeySize
            keyPairGen7.initialize(ecSpec5);

            KeyPairGenerator keyPairGen8 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec6 = new ECGenParameterSpec("X9.62 c2tnb359v1"); // Safe: Key size is no less than 256
            keyPairGen8.initialize(ecSpec6);

            KeyPairGenerator keyPairGen9 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec7 = new ECGenParameterSpec("prime192v2"); // $ hasInsufficientKeySize
            keyPairGen9.initialize(ecSpec7);

            KeyPairGenerator keyPairGen10 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec8 = new ECGenParameterSpec("prime256v1"); // Safe: Key size is no less than 256
            keyPairGen10.initialize(ecSpec8);

            KeyPairGenerator keyPairGen14 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec9 = new ECGenParameterSpec("c2tnb191v1"); // $ hasInsufficientKeySize
            keyPairGen14.initialize(ecSpec9);

            KeyPairGenerator keyPairGen15 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec10 = new ECGenParameterSpec("c2tnb431r1");
            keyPairGen15.initialize(ecSpec10); // Safe: Key size is no less than 256

            /* Test variables passed to another method */
            ECGenParameterSpec ecSpec = new ECGenParameterSpec("secp112r1"); // $ hasInsufficientKeySize
            KeyPairGenerator keyPairGen = KeyPairGenerator.getInstance("EC"); // MISSING: test KeyGenerator variable as argument
            testAsymmetricEC(ecSpec, keyPairGen); // test spec as an argument
        }
    }

    public static void testSymmetricVariable(int keySize, KeyGenerator kg) throws java.security.NoSuchAlgorithmException, java.security.InvalidAlgorithmParameterException {
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(keySize); // $ hasInsufficientKeySize
        kg.init(64); // $ MISSING: hasInsufficientKeySize
    }

    public static void testSymmetricInt(int keySize) throws java.security.NoSuchAlgorithmException, java.security.InvalidAlgorithmParameterException {
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(keySize); // $ hasInsufficientKeySize
    }

    public static void testAsymmetricNonEcVariable(int keySize, KeyPairGenerator kpg) throws java.security.NoSuchAlgorithmException, java.security.InvalidAlgorithmParameterException {
        KeyPairGenerator keyPairGen = KeyPairGenerator.getInstance("RSA");
        keyPairGen.initialize(keySize); // $ hasInsufficientKeySize
        kpg.initialize(1024); // $ MISSING: hasInsufficientKeySize
    }

    public static void testAsymmetricNonEcInt(int keySize) throws java.security.NoSuchAlgorithmException, java.security.InvalidAlgorithmParameterException {
        KeyPairGenerator keyPairGen = KeyPairGenerator.getInstance("RSA");
        keyPairGen.initialize(keySize); // $ hasInsufficientKeySize
    }

    public static void testAsymmetricEcVariable(ECGenParameterSpec spec, KeyPairGenerator kpg) throws java.security.NoSuchAlgorithmException, java.security.InvalidAlgorithmParameterException {
        KeyPairGenerator keyPairGen = KeyPairGenerator.getInstance("EC");
        keyPairGen.initialize(spec); // sink is above where `spec` variable is initialized

        ECGenParameterSpec ecSpec = new ECGenParameterSpec("secp112r1"); // $ hasInsufficientKeySize
        kpg.initialize(ecSpec); // MISSING: test KeyGenerator variable as argument
    }

    public static void testAsymmetricEcInt(int keySize) throws java.security.NoSuchAlgorithmException, java.security.InvalidAlgorithmParameterException {
        KeyPairGenerator keyPairGen = KeyPairGenerator.getInstance("EC");
        keyPairGen.initialize(keySize); // $ hasInsufficientKeySize
    }

    // public static void testVariable(int keySize, KeyGenerator kg) throws java.security.NoSuchAlgorithmException, java.security.InvalidAlgorithmParameterException {
    //     KeyGenerator keyGen = KeyGenerator.getInstance("AES");
    //     keyGen.init(keySize); // $ hasInsufficientKeySize

    //     // BAD: Key size is less than 2048
    //     kg.init(64); // $ MISSING: hasInsufficientKeySize
    // }

    // public static void testInt(int keySize, KeyGenerator kg) throws java.security.NoSuchAlgorithmException, java.security.InvalidAlgorithmParameterException {
    // }
}
