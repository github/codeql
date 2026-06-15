package com.example.crypto.artifacts;

// import org.bouncycastle.jce.provider.BouncyCastleProvider;
import java.io.FileInputStream;
import java.security.*;
import java.security.spec.*;
import java.util.Properties;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;

public class KeyArtifact {

    // static {
    //     Security.addProvider(new BouncyCastleProvider());
    // }
    public void generateSymmetricKeys() throws NoSuchAlgorithmException {
        // AES Key Generation (Default Provider)
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(256);
        SecretKey aesKeyJDK = keyGen.generateKey();

        // AES Key Generation (BouncyCastle)
        keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(256);
        SecretKey aesKeyBC = keyGen.generateKey();
    }

    public void generateAsymmetricKeys() throws NoSuchAlgorithmException {
        // RSA Key Generation (JDK Default)
        KeyPairGenerator keyPairGen = KeyPairGenerator.getInstance("RSA");
        keyPairGen.initialize(2048);
        KeyPair rsaPairJDK = keyPairGen.generateKeyPair();

        // RSA Key Generation (BouncyCastle)
        keyPairGen = KeyPairGenerator.getInstance("RSA");
        keyPairGen.initialize(2048);
        KeyPair rsaPairBC = keyPairGen.generateKeyPair();

        // EC Key Generation
        keyPairGen = KeyPairGenerator.getInstance("EC");
        keyPairGen.initialize(256);
        KeyPair ecPair = keyPairGen.generateKeyPair();
    }

    public void importExportRSAKeys(KeyPair keyPair) throws NoSuchAlgorithmException, InvalidKeySpecException {
        // Export Public Key
        byte[] pubKeyBytes = keyPair.getPublic().getEncoded();
        X509EncodedKeySpec pubKeySpec = new X509EncodedKeySpec(pubKeyBytes);
        KeyFactory keyFactory = KeyFactory.getInstance("RSA");
        PublicKey importedPubKey = keyFactory.generatePublic(pubKeySpec);

        // Export Private Key
        byte[] privKeyBytes = keyPair.getPrivate().getEncoded();
        PKCS8EncodedKeySpec privKeySpec = new PKCS8EncodedKeySpec(privKeyBytes);
        PrivateKey importedPrivKey = keyFactory.generatePrivate(privKeySpec);
    }

    public void dynamicAlgorithmSelection() throws Exception {
        // Load algorithm from configuration
        Properties properties = new Properties();
        properties.load(new FileInputStream("crypto-config.properties"));
        String algorithm = properties.getProperty("key.algorithm", "AES");

        KeyGenerator keyGen = KeyGenerator.getInstance(algorithm);
        keyGen.init(256);
        SecretKey dynamicKey = keyGen.generateKey();
    }

    public KeyPair generateKeyPair(String algorithm) throws NoSuchAlgorithmException {
        // Wrapper for Key Generation
        KeyPairGenerator keyPairGen = KeyPairGenerator.getInstance(algorithm);
        keyPairGen.initialize(2048);
        return keyPairGen.generateKeyPair();
    }

    public void keySelectionFromArray() throws NoSuchAlgorithmException {
        // Selecting Algorithm Dynamically from an Array
        String[] algorithms = {"RSA", "EC", "Ed25519"};
        KeyPair[] keyPairs = new KeyPair[algorithms.length];

        for (int i = 0; i < algorithms.length; i++) {
            keyPairs[i] = generateKeyPair(algorithms[i]);
        }
    }
}
