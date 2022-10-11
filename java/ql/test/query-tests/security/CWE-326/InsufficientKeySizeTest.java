import javax.crypto.KeyGenerator;
import java.security.KeyPairGenerator;

import java.security.spec.ECGenParameterSpec;
import java.security.spec.RSAKeyGenParameterSpec;
import java.security.spec.DSAGenParameterSpec;
import javax.crypto.spec.DHGenParameterSpec;


public class InsufficientKeySizeTest {
    public void keySizeTesting() throws java.security.NoSuchAlgorithmException, java.security.InvalidAlgorithmParameterException {

        // Test basic key generation for all algos

        // AES (Symmetric)
        {
            // BAD: Key size is less than 128
            KeyGenerator keyGen1 = KeyGenerator.getInstance("AES");
            keyGen1.init(64); // $ hasInsufficientKeySize

            // GOOD: Key size is no less than 128
            KeyGenerator keyGen2 = KeyGenerator.getInstance("AES");
            keyGen2.init(128); // Safe
        }

        // RSA (Asymmetric)
        {
            // BAD: Key size is less than 2048
            KeyPairGenerator keyPairGen1 = KeyPairGenerator.getInstance("RSA");
            keyPairGen1.initialize(1024); // $ hasInsufficientKeySize

            // GOOD: Key size is no less than 2048
            KeyPairGenerator keyPairGen2 = KeyPairGenerator.getInstance("RSA");
            keyPairGen2.initialize(2048); // Safe

            // test with spec
            // BAD: Key size is less than 2048
            KeyPairGenerator keyPairGen3 = KeyPairGenerator.getInstance("RSA");
            RSAKeyGenParameterSpec rsaSpec = new RSAKeyGenParameterSpec(1024, null); // $ hasInsufficientKeySize
            keyPairGen3.initialize(rsaSpec);

            // BAD: Key size is less than 2048
            KeyPairGenerator keyPairGen4 = KeyPairGenerator.getInstance("RSA");
            keyPairGen4.initialize(new RSAKeyGenParameterSpec(1024, null)); // $ hasInsufficientKeySize
        }

        // DSA (Asymmetric)
        {
            // BAD: Key size is less than 2048
            KeyPairGenerator keyPairGen3 = KeyPairGenerator.getInstance("DSA");
            keyPairGen3.initialize(1024); // $ hasInsufficientKeySize

            // GOOD: Key size is no less than 2048
            KeyPairGenerator keyPairGen4 = KeyPairGenerator.getInstance("DSA");
            keyPairGen4.initialize(2048); // Safe

            // test with spec
            // BAD: Key size is less than 2048
            KeyPairGenerator keyPairGen5 = KeyPairGenerator.getInstance("DSA");
            DSAGenParameterSpec dsaSpec = new DSAGenParameterSpec(1024, 0); // $ hasInsufficientKeySize
            keyPairGen5.initialize(dsaSpec);

            // BAD: Key size is less than 2048
            KeyPairGenerator keyPairGen6 = KeyPairGenerator.getInstance("DSA");
            keyPairGen6.initialize(new DSAGenParameterSpec(1024, 0)); // $ hasInsufficientKeySize
        }

        // DH (Asymmetric)
        {
            // BAD: Key size is less than 2048
            KeyPairGenerator keyPairGen16 = KeyPairGenerator.getInstance("dh");
            keyPairGen16.initialize(1024); // $ hasInsufficientKeySize

            // GOOD: Key size is no less than 2048
            KeyPairGenerator keyPairGen17 = KeyPairGenerator.getInstance("DH");
            keyPairGen17.initialize(2048); // Safe

            // test with spec
            // BAD: Key size is less than 2048
            KeyPairGenerator keyPairGen3 = KeyPairGenerator.getInstance("DH");
            DHGenParameterSpec dhSpec = new DHGenParameterSpec(1024, 0); // $ hasInsufficientKeySize
            keyPairGen3.initialize(dhSpec);

            // BAD: Key size is less than 2048
            KeyPairGenerator keyPairGen4 = KeyPairGenerator.getInstance("DH");
            keyPairGen4.initialize(new DHGenParameterSpec(1024, 0)); // $ hasInsufficientKeySize
        }

        // EC (Asymmetric)
        // ! Check if I can re-use the same KeyPairGenerator instance with all of the below?
        {
            // without spec
            // BAD: Key size is less than 256
            KeyPairGenerator keyPairGen4 = KeyPairGenerator.getInstance("EC");
            keyPairGen4.initialize(112); // $ hasInsufficientKeySize


            // with specs
            // BAD: Key size is less than 256
            KeyPairGenerator keyPairGen5 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec1 = new ECGenParameterSpec("secp112r1"); // $ hasInsufficientKeySize
            keyPairGen5.initialize(ecSpec1);

            // BAD: Key size is less than 256
            KeyPairGenerator keyPairGen6 = KeyPairGenerator.getInstance("EC");
            keyPairGen6.initialize(new ECGenParameterSpec("secp112r1")); // $ hasInsufficientKeySize

            // GOOD: Key size is no less than 256
            KeyPairGenerator keyPairGen7 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec2 = new ECGenParameterSpec("secp256r1");
            keyPairGen7.initialize(ecSpec2); // Safe

            // BAD: Key size is less than 256
            KeyPairGenerator keyPairGen8 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec3 = new ECGenParameterSpec("X9.62 prime192v2"); // $ hasInsufficientKeySize
            keyPairGen8.initialize(ecSpec3);

            // BAD: Key size is less than 256
            KeyPairGenerator keyPairGen9 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec4 = new ECGenParameterSpec("X9.62 c2tnb191v3"); // $ hasInsufficientKeySize
            keyPairGen9.initialize(ecSpec4);

            // BAD: Key size is less than 256
            KeyPairGenerator keyPairGen10 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec5 = new ECGenParameterSpec("sect163k1"); // $ hasInsufficientKeySize
            keyPairGen10.initialize(ecSpec5);

            // GOOD: Key size is no less than 256
            KeyPairGenerator keyPairGen11 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec6 = new ECGenParameterSpec("X9.62 c2tnb359v1");
            keyPairGen11.initialize(ecSpec6); // Safe

            // BAD: Key size is less than 256
            KeyPairGenerator keyPairGen12 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec7 = new ECGenParameterSpec("prime192v2"); // $ hasInsufficientKeySize
            keyPairGen12.initialize(ecSpec7);

            // GOOD: Key size is no less than 256
            KeyPairGenerator keyPairGen13 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec8 = new ECGenParameterSpec("prime256v1");
            keyPairGen13.initialize(ecSpec8); // Safe

            // BAD: Key size is less than 256
            KeyPairGenerator keyPairGen14 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec9 = new ECGenParameterSpec("c2tnb191v1"); // $ hasInsufficientKeySize
            keyPairGen14.initialize(ecSpec9);

            // GOOD: Key size is no less than 256
            KeyPairGenerator keyPairGen15 = KeyPairGenerator.getInstance("EC");
            ECGenParameterSpec ecSpec10 = new ECGenParameterSpec("c2tnb431r1");
            keyPairGen15.initialize(ecSpec10); // Safe
        }

        // ! FN Testing Additions:

        // Test local variable usage - Symmetric
        {
            final int size1 = 64; // compile-time constant
            int size2 = 64;       // NOT a compile-time constant

            // BAD: Key size is less than 128
            KeyGenerator keyGen3 = KeyGenerator.getInstance("AES");
            keyGen3.init(size1); // $ hasInsufficientKeySize

            // BAD: Key size is less than 128
            KeyGenerator keyGen4 = KeyGenerator.getInstance("AES");
            keyGen4.init(size2); // $ MISSING: hasInsufficientKeySize
        }

         // Test local variable usage - Asymmetric, Not EC
         {
            final int size1 = 1024; // compile-time constant
            int size2 = 1024;       // NOT a compile-time constant

            // BAD: Key size is less than 2048
            KeyPairGenerator keyPairGen18 = KeyPairGenerator.getInstance("RSA");
            keyPairGen18.initialize(size1); // $ hasInsufficientKeySize

            // BAD: Key size is less than 2048
            KeyPairGenerator keyPairGen19 = KeyPairGenerator.getInstance("RSA");
            keyPairGen19.initialize(size2); // $ MISSING: hasInsufficientKeySize
         }


         // Test variable passed to other method(s) - Symmetric
         {
            int size = 64; // test integer variable
            KeyGenerator keyGen = KeyGenerator.getInstance("AES"); // test KeyGenerator variable
            testSymmetric(size, keyGen); // test with variable as key size
            testSymmetric2(64); // test with int literal as key size
         }


         // Test variables passed to other method(s) - Asymmetric, Not EC
         {
            int size = 1024; // test integer variable
            KeyPairGenerator keyPairGen21 = KeyPairGenerator.getInstance("RSA"); // test KeyPairGenerator variable
            testAsymmetricNonEC(size, keyPairGen21); // test with variable as key size
            testAsymmetricNonEC2(1024); // test with int literal as key size
         }

         // Test variable passed to other method(s) - Asymmetric, EC
         {
            ECGenParameterSpec ecSpec = new ECGenParameterSpec("secp112r1"); // $ hasInsufficientKeySize // test ECGenParameterSpec variable
            KeyPairGenerator keyPairGen22 = KeyPairGenerator.getInstance("EC"); // test KeyPairGenerator variable
            testAsymmetricEC(ecSpec, keyPairGen22);

         }

    }

    public static void testSymmetric(int keySize, KeyGenerator kg) throws java.security.NoSuchAlgorithmException, java.security.InvalidAlgorithmParameterException {
        // BAD: Key size is less than 2048
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(keySize); // $ MISSING: hasInsufficientKeySize

        // BAD: Key size is less than 2048
        kg.init(64); // $ hasInsufficientKeySize
    }

    //! refactor this to use expected-value tag and combine with above method
    public static void testSymmetric2(int keySize) throws java.security.NoSuchAlgorithmException, java.security.InvalidAlgorithmParameterException {
        // BAD: Key size is less than 2048
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(keySize); // $ MISSING: hasInsufficientKeySize
    }

    public static void testAsymmetricNonEC(int keySize, KeyPairGenerator kpg) throws java.security.NoSuchAlgorithmException, java.security.InvalidAlgorithmParameterException {
        // BAD: Key size is less than 2048
        KeyPairGenerator keyPairGen = KeyPairGenerator.getInstance("RSA");
        keyPairGen.initialize(keySize); // $ MISSING: hasInsufficientKeySize

        // BAD: Key size is less than 2048
        kpg.initialize(1024); // $ hasInsufficientKeySize
    }

    //! refactor this to use expected-value tag and combine with above method
    public static void testAsymmetricNonEC2(int keySize) throws java.security.NoSuchAlgorithmException, java.security.InvalidAlgorithmParameterException {
        // BAD: Key size is less than 2048
        KeyPairGenerator keyPairGen = KeyPairGenerator.getInstance("RSA");
        keyPairGen.initialize(keySize); // $ MISSING: hasInsufficientKeySize
    }

    public static void testAsymmetricEC(ECGenParameterSpec spec, KeyPairGenerator kpg) throws java.security.NoSuchAlgorithmException, java.security.InvalidAlgorithmParameterException {
        // BAD: Key size is less than 256
        KeyPairGenerator keyPairGen = KeyPairGenerator.getInstance("EC");
        keyPairGen.initialize(spec); // sink is now at above where `spec` variable is initialized

        // BAD: Key size is less than 256
        ECGenParameterSpec ecSpec = new ECGenParameterSpec("secp112r1"); // $ hasInsufficientKeySize
        kpg.initialize(ecSpec);



    }

    // ToDo testing:
    // ? todo #1: add tests for keysize variable passed to specs - not needed if spec is sink now
    // ? todo #3: add test for retrieving a key from elsewhere?
    // ? todo #4: add barrier-guard tests (see FP from OpenIdentityPlatform/OpenAM)
    // ? todo #5: add tests for updated keysize variable?: e.g. keysize = 1024; keysize += 1024; so when it's used it is correctly 2048. (prbly only student projects would not use constants?)
    // ```
        //int size = 128;
        // use `size` for AES key

        //size += 1920; // size is now 2048
        // use size for RSA key
    // ```
    // ? todo #6: consider if some flow paths for keysize variables will be too hard to track how the keysize is updated (e.g. if calling some other method to get keysize, etc....)
}
