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
        // BAD: Key size is less than 256
        ECGenParameterSpec ecSpec1 = new ECGenParameterSpec("secp112r1");
        keyPairGen5.initialize(ecSpec1);

        KeyPairGenerator keyPairGen6 = KeyPairGenerator.getInstance("EC");
        // GOOD: Key size is no less than 256
        ECGenParameterSpec ecSpec2 = new ECGenParameterSpec("secp256r1");
        keyPairGen6.initialize(ecSpec2);
    }
}
