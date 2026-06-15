package com.example.crypto.algorithms;

// import org.bouncycastle.jce.provider.BouncyCastleProvider;
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.GCMParameterSpec;
import java.security.*;
import java.util.Base64;
import java.util.Random;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.Files;
import java.io.IOException;

public class UniversalFlowTest {

    public void simpleAESEncryption() throws Exception {
        String algorithm = "AES";
        String otherAlgorithm = loadAlgorithmFromDisk();

        // Randomly select between the known algorithm and the one loaded from disk
        String selectedAlgorithm = (new Random().nextInt(2) == 0) ? algorithm : otherAlgorithm;

        KeyGenerator keyGen = KeyGenerator.getInstance(selectedAlgorithm);
        keyGen.init(256); // 256-bit AES key.
        SecretKey key = keyGen.generateKey();
        String algorithm2 = "AES/GCM/NoPadding";
        Cipher cipher = Cipher.getInstance(algorithm2);
        byte[] iv = new byte[12]; // 12-byte IV recommended for GCM.
        new SecureRandom().nextBytes(iv);
        GCMParameterSpec gcmSpec = new GCMParameterSpec(128, iv); // 128-bit authentication tag.
        cipher.init(Cipher.ENCRYPT_MODE, key, gcmSpec);
        byte[] encryptedData = cipher.doFinal("Sensitive Data".getBytes());
    }

// Method to load algorithm from disk
    private String loadAlgorithmFromDisk() {
        try {
            // Implementation to load algorithm name from a file
            Path path = Paths.get("algorithm.txt");
            return Files.readString(path).trim();
        } catch (IOException e) {
            // Fallback to default algorithm if loading fails
            System.err.println("Failed to load algorithm from disk: " + e.getMessage());
            return "AES";
        }
    }
}
