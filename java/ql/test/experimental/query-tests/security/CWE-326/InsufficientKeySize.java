import java.security.KeyPairGenerator;
import java.security.spec.ECGenParameterSpec;
import javax.crypto.KeyGenerator;

public class InsufficientKeySize {
    public void CryptoMethod() {
        KeyGenerator keyGen1 = KeyGenerator.getInstance("AES");
        // BAD: Key size is less than 128
        keyGen1.init(64);

        KeyGenerator keyGen2 = KeyGenerator.getInstance("AES");
        // GOOD: Key size is no less than 128
        keyGen2.init(128);

        KeyPairGenerator keyPairGen1 = KeyPairGenerator.getInstance("RSA");
        // BAD: Key size is less than 2048
        keyPairGen1.initialize(1024);

        KeyPairGenerator keyPairGen2 = KeyPairGenerator.getInstance("RSA");
        // GOOD: Key size is no less than 2048
        keyPairGen2.initialize(2048);

        KeyPairGenerator keyPairGen3 = KeyPairGenerator.getInstance("DSA");
        // BAD: Key size is less than 2048
        keyPairGen3.initialize(1024);

        KeyPairGenerator keyPairGen4 = KeyPairGenerator.getInstance("DSA");
        // GOOD: Key size is no less than 2048
        keyPairGen4.initialize(2048);

        KeyPairGenerator keyPairGen5 = KeyPairGenerator.getInstance("EC");
        // BAD: Key size is less than 224
        ECGenParameterSpec ecSpec1 = new ECGenParameterSpec("secp112r1");
        keyPairGen5.initialize(ecSpec1);

        KeyPairGenerator keyPairGen6 = KeyPairGenerator.getInstance("EC");
        // BAD: Key size is less than 224
        keyPairGen6.initialize(new ECGenParameterSpec("secp112r1"));

        KeyPairGenerator keyPairGen7 = KeyPairGenerator.getInstance("EC");
        // GOOD: Key size is no less than 224
        ECGenParameterSpec ecSpec2 = new ECGenParameterSpec("secp256r1");
        keyPairGen7.initialize(ecSpec2);

        KeyPairGenerator keyPairGen8 = KeyPairGenerator.getInstance("EC");
        // BAD: Key size is less than 224
        ECGenParameterSpec ecSpec3 = new ECGenParameterSpec("X9.62 prime192v2");
        keyPairGen8.initialize(ecSpec3);

        KeyPairGenerator keyPairGen9 = KeyPairGenerator.getInstance("EC");
        // BAD: Key size is less than 224
        ECGenParameterSpec ecSpec4 = new ECGenParameterSpec("X9.62 c2tnb191v3");
        keyPairGen9.initialize(ecSpec4);

        KeyPairGenerator keyPairGen10 = KeyPairGenerator.getInstance("EC");
        // BAD: Key size is less than 224
        ECGenParameterSpec ecSpec5 = new ECGenParameterSpec("sect163k1");
        keyPairGen10.initialize(ecSpec5);

        KeyPairGenerator keyPairGen11 = KeyPairGenerator.getInstance("EC");
        // GOOD: Key size is no less than 224
        ECGenParameterSpec ecSpec6 = new ECGenParameterSpec("X9.62 c2tnb359v1");
        keyPairGen11.initialize(ecSpec6);
    }
}
