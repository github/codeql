import javax.crypto.KeyGenerator;
import java.security.KeyPairGenerator;
import java.security.AlgorithmParameterGenerator;
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
            keyGen1.init(64); // $ Alert

            KeyGenerator keyGen2 = KeyGenerator.getInstance("AES");
            keyGen2.init(128); // Safe: Key size is no less than 128

            /* Test with local variable as keysize */
            final int size1 = 64; // $ Source// compile-time constant
            int size2 = 64;       // $ Source// not a compile-time constant

            KeyGenerator keyGen3 = KeyGenerator.getInstance("AES");
            keyGen3.init(size1); // $ Alert

            KeyGenerator keyGen4 = KeyGenerator.getInstance("AES");
            keyGen4.init(size2); // $ Alert

            /* Test variables passed to another method */
            KeyGenerator keyGen5 = KeyGenerator.getInstance("AES"); // MISSING: test KeyGenerator variable as argument
            testSymmetricVariable(size2, keyGen5); // test with variable as key size
            testSymmetricInt(64); // $ Source // test with int literal as key size

            /* Test with variable as algo name argument in `getInstance` method. */
            final String algoName1 = "AES"; // compile-time constant
            KeyGenerator keyGen6 = KeyGenerator.getInstance(algoName1);
            keyGen6.init(64); // $ Alert

            String algoName2 = "AES"; // not a compile-time constant
            KeyGenerator keyGen7 = KeyGenerator.getInstance(algoName2);
            keyGen7.init(64); // $ MISSING: hasInsufficientKeySize
        }

        // RSA (Asymmetric): minimum recommended key size is 2048
        {
            /* Test with keysize as int */
            KeyPairGenerator keyPairGen1 = KeyPairGenerator.getInstance("RSA");
            keyPairGen1.initialize(1024); // $ Alert

            KeyPairGenerator keyPairGen2 = KeyPairGenerator.getInstance("RSA");
            keyPairGen2.initialize(2048); // Safe: Key size is no less than 2048

            /* Test spec */
            KeyPairGenerator keyPairGen3 = KeyPairGenerator.getInstance("RSA");
            RSAKeyGenParameterSpec rsaSpec = new RSAKeyGenParameterSpec(1024, null); // $ Alert
            keyPairGen3.initialize(rsaSpec);

            KeyPairGenerator keyPairGen4 = KeyPairGenerator.getInstance("RSA");
            keyPairGen4.initialize(new RSAKeyGenParameterSpec(1024, null)); // $ Alert

            /* Test with local variable as keysize */
            final int size1 = 1024; // $ Source // compile-time constant
            int size2 = 1024;       // $ Source // not a compile-time constant

            KeyPairGenerator keyPairGen5 = KeyPairGenerator.getInstance("RSA");
            keyPairGen5.initialize(size1); // $ Alert

            KeyPairGenerator keyPairGen6 = KeyPairGenerator.getInstance("RSA");
            keyPairGen6.initialize(size2); // $ Alert

            /* Test variables passed to another method */
            KeyPairGenerator keyPairGen7 = KeyPairGenerator.getInstance("RSA"); // MISSING: test KeyGenerator variable as argument
            testAsymmetricNonEcVariable(size2, keyPairGen7); // test with variable as key size
            testAsymmetricNonEcInt(1024); // $ Source // test with int literal as key size

            /* Test getting key size as return value of another method */
            KeyPairGenerator keyPairGen8 = KeyPairGenerator.getInstance("RSA");
            keyPairGen8.initialize(getRSAKeySize()); // $ Alert

            /* Test with variable as algo name argument in `getInstance` method. */
            final String algoName1 = "RSA"; // compile-time constant
            KeyPairGenerator keyPairGen9 = KeyPairGenerator.getInstance(algoName1);
            keyPairGen9.initialize(1024); // $ Alert

            String algoName2 = "RSA"; // not a compile-time constant
            KeyPairGenerator keyPairGen10 = KeyPairGenerator.getInstance(algoName2);
            keyPairGen10.initialize(1024); // $ MISSING: hasInsufficientKeySize
        }

        // DSA (Asymmetric): minimum recommended key size is 2048
        {
            /* Test with keysize as int */
            KeyPairGenerator keyPairGen1 = KeyPairGenerator.getInstance("DSA");
            keyPairGen1.initialize(1024); // $ Alert

            KeyPairGenerator keyPairGen2 = KeyPairGenerator.getInstance("DSA");
            keyPairGen2.initialize(2048); // Safe: Key size is no less than 2048

            /* Test spec */
            KeyPairGenerator keyPairGen3 = KeyPairGenerator.getInstance("DSA");
            DSAGenParameterSpec dsaSpec = new DSAGenParameterSpec(1024, 0); // $ Alert
            keyPairGen3.initialize(dsaSpec);

            KeyPairGenerator keyPairGen4 = KeyPairGenerator.getInstance("DSA");
            keyPairGen4.initialize(new DSAGenParameterSpec(1024, 0)); // $ Alert

            /* Test `AlgorithmParameterGenerator` */
            AlgorithmParameterGenerator paramGen = AlgorithmParameterGenerator.getInstance("DSA");
            paramGen.init(1024); // $ Alert

            /* Test with variable as algo name argument in `getInstance` method. */
            final String algoName1 = "DSA"; // compile-time constant
            AlgorithmParameterGenerator paramGen1 = AlgorithmParameterGenerator.getInstance(algoName1);
            paramGen1.init(1024); // $ Alert

            String algoName2 = "DSA"; // not a compile-time constant
            AlgorithmParameterGenerator paramGen2 = AlgorithmParameterGenerator.getInstance(algoName2);
            paramGen2.init(1024); // $ MISSING: hasInsufficientKeySize
        }

        // DH (Asymmetric): minimum recommended key size is 2048
        {
            /* Test with keysize as int */
            KeyPairGenerator keyPairGen1 = KeyPairGenerator.getInstance("dh");
            keyPairGen1.initialize(1024); // $ Alert

            KeyPairGenerator keyPairGen2 = KeyPairGenerator.getInstance("DH");
            keyPairGen2.initialize(2048); // Safe: Key size is no less than 2048

            /* Test spec */
            KeyPairGenerator keyPairGen3 = KeyPairGenerator.getInstance("DH");
            DHGenParameterSpec dhSpec = new DHGenParameterSpec(1024, 0); // $ Alert
            keyPairGen3.initialize(dhSpec);

            KeyPairGenerator keyPairGen4 = KeyPairGenerator.getInstance("DH");
            keyPairGen4.initialize(new DHGenParameterSpec(1024, 0)); // $ Alert

            /* Test `AlgorithmParameterGenerator` */
            AlgorithmParameterGenerator paramGen = AlgorithmParameterGenerator.getInstance("DH");
            paramGen.init(1024); // $ Alert
        }

        // EC (Asymmetric): minimum recommended key size is 256
        {
            /* Test with keysize as int */
            KeyPairGenerator keyPairGen1 = KeyPairGenerator.getInstance("EC");
            keyPairGen1.initialize(128); // $ Alert

            /* Test with keysize as curve name in spec */
            KeyPairGenerator keyPairGen2 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec1 = new ECGenParameterSpec("secp112r1"); // $ Alert
            keyPairGen2.initialize(ecSpec1);

            KeyPairGenerator keyPairGen3 = KeyPairGenerator.getInstance("EC");
            keyPairGen3.initialize(new ECGenParameterSpec("secp112r1")); // $ Alert

            KeyPairGenerator keyPairGen4 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec2 = new ECGenParameterSpec("secp256r1"); // Safe: Key size is no less than 256
            keyPairGen4.initialize(ecSpec2);

            KeyPairGenerator keyPairGen5 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec3 = new ECGenParameterSpec("X9.62 prime192v2"); // $ Alert
            keyPairGen5.initialize(ecSpec3);

            KeyPairGenerator keyPairGen6 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec4 = new ECGenParameterSpec("X9.62 c2tnb191v3"); // $ Alert
            keyPairGen6.initialize(ecSpec4);

            KeyPairGenerator keyPairGen7 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec5 = new ECGenParameterSpec("sect163k1"); // $ Alert
            keyPairGen7.initialize(ecSpec5);

            KeyPairGenerator keyPairGen8 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec6 = new ECGenParameterSpec("X9.62 c2tnb359v1"); // Safe: Key size is no less than 256
            keyPairGen8.initialize(ecSpec6);

            KeyPairGenerator keyPairGen9 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec7 = new ECGenParameterSpec("prime192v2"); // $ Alert
            keyPairGen9.initialize(ecSpec7);

            KeyPairGenerator keyPairGen10 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec8 = new ECGenParameterSpec("prime256v1"); // Safe: Key size is no less than 256
            keyPairGen10.initialize(ecSpec8);

            KeyPairGenerator keyPairGen14 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec9 = new ECGenParameterSpec("c2tnb191v1"); // $ Alert
            keyPairGen14.initialize(ecSpec9);

            KeyPairGenerator keyPairGen15 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec10 = new ECGenParameterSpec("c2tnb431r1");
            keyPairGen15.initialize(ecSpec10); // Safe: Key size is no less than 256

            /* Test variables passed to another method */
            ECGenParameterSpec ecSpec = new ECGenParameterSpec("secp112r1"); // $ Alert
            testAsymmetricEcSpecVariable(ecSpec); // test spec as an argument
            int size = 128; // $ Source
            KeyPairGenerator keyPairGen = KeyPairGenerator.getInstance("EC"); // MISSING: test KeyGenerator variable as argument
            testAsymmetricEcIntVariable(size, keyPairGen); // test with variable as key size
            testAsymmetricEcIntLiteral(128); // $ Source // test with int literal as key size

            /* Test with variable as curve name argument in `ECGenParameterSpec` constructor. */
            final String curveName1 = "secp112r1"; // $ Source // compile-time constant
            KeyPairGenerator keyPairGen16 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec11 = new ECGenParameterSpec(curveName1); // $ Alert
            keyPairGen16.initialize(ecSpec11);

            String curveName2 = "secp112r1"; // $ Source // not a compile-time constant
            KeyPairGenerator keyPairGen17 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec12 = new ECGenParameterSpec(curveName2); // $ Alert
            keyPairGen17.initialize(ecSpec12);
        }
    }

    public static void testSymmetricVariable(int keySize, KeyGenerator kg) throws java.security.NoSuchAlgorithmException, java.security.InvalidAlgorithmParameterException {
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(keySize); // $ Alert
        kg.init(64); // $ MISSING: hasInsufficientKeySize
    }

    public static void testSymmetricInt(int keySize) throws java.security.NoSuchAlgorithmException, java.security.InvalidAlgorithmParameterException {
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(keySize); // $ Alert
    }

    public static void testAsymmetricNonEcVariable(int keySize, KeyPairGenerator kpg) throws java.security.NoSuchAlgorithmException, java.security.InvalidAlgorithmParameterException {
        KeyPairGenerator keyPairGen = KeyPairGenerator.getInstance("RSA");
        keyPairGen.initialize(keySize); // $ Alert
        kpg.initialize(1024); // $ MISSING: hasInsufficientKeySize
    }

    public static void testAsymmetricNonEcInt(int keySize) throws java.security.NoSuchAlgorithmException, java.security.InvalidAlgorithmParameterException {
        KeyPairGenerator keyPairGen = KeyPairGenerator.getInstance("RSA");
        keyPairGen.initialize(keySize); // $ Alert
    }

    public static void testAsymmetricEcSpecVariable(ECGenParameterSpec spec) throws java.security.NoSuchAlgorithmException, java.security.InvalidAlgorithmParameterException {
        KeyPairGenerator keyPairGen = KeyPairGenerator.getInstance("EC");
        keyPairGen.initialize(spec); // sink is above where `spec` variable is initialized
    }

    public static void testAsymmetricEcIntVariable(int keySize, KeyPairGenerator kpg) throws java.security.NoSuchAlgorithmException, java.security.InvalidAlgorithmParameterException {
        KeyPairGenerator keyPairGen = KeyPairGenerator.getInstance("EC");
        keyPairGen.initialize(keySize); // $ Alert
        kpg.initialize(128); // $ MISSING: hasInsufficientKeySize
    }

    public static void testAsymmetricEcIntLiteral(int keySize) throws java.security.NoSuchAlgorithmException, java.security.InvalidAlgorithmParameterException {
        KeyPairGenerator keyPairGen = KeyPairGenerator.getInstance("EC");
        keyPairGen.initialize(keySize); // $ Alert
    }

    public int getRSAKeySize(){ return 1024; } // $ Source
}
