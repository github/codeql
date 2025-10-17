import java.security.*;
public class InsufficientAsymmetricKeySize{
    public static void test() throws Exception{
        KeyPairGenerator keyPairGen1 = KeyPairGenerator.getInstance("RSA");
        keyPairGen1.initialize(1024); // $Alert[java/quantum/examples/weak-asymmetric-key-gen-size]
        keyPairGen1.generateKeyPair();

        KeyPairGenerator keyPairGen2 = KeyPairGenerator.getInstance("DSA");
        keyPairGen2.initialize(1024); // $Alert[java/quantum/examples/weak-asymmetric-key-gen-size]
        keyPairGen2.generateKeyPair();

        KeyPairGenerator keyPairGen3 = KeyPairGenerator.getInstance("DH");
        keyPairGen3.initialize(1024); // $Alert[java/quantum/examples/weak-asymmetric-key-gen-size]
        keyPairGen3.generateKeyPair();

        KeyPairGenerator keyPairGen4 = KeyPairGenerator.getInstance("RSA");
        keyPairGen4.initialize(2048); // GOOD
        keyPairGen4.generateKeyPair();

        KeyPairGenerator keyPairGen5 = KeyPairGenerator.getInstance("DSA");
        keyPairGen5.initialize(2048); // GOOD
        keyPairGen5.generateKeyPair();

        KeyPairGenerator keyPairGen6 = KeyPairGenerator.getInstance("DH");
        keyPairGen6.initialize(2048); // GOOD
        keyPairGen6.generateKeyPair();
    }
}