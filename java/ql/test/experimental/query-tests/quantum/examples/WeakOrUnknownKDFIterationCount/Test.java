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

public class Test {

    public static byte[] generateSalt(int length) {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[length];
        random.nextBytes(salt);
        return salt;
    }

    /**
     * PBKDF2 derivation with a very low iteration count.
     *
     * SAST/CBOM: - Parent: PBKDF2. - Iteration count is only 10, which is far
     * below acceptable security standards. - Flagged as insecure.
     */
    public void pbkdf2LowIteration(String password) throws Exception {
        byte[] salt = generateSalt(16);
        int iterationCount = 10; // $Source
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, iterationCount, 256); // $Alert[java/quantum/examples/weak-kdf-iteration-count]
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
        byte[] key = factory.generateSecret(spec).getEncoded();
    }

    /**
     * PBKDF2 derivation with a very low iteration count.
     *
     * SAST/CBOM: - Parent: PBKDF2. - Iteration count is only 10, which is far
     * below acceptable security standards. - Flagged as insecure.
     */
    public void pbkdf2LowIteration(String password, int iterationCount) throws Exception { // $Source
        byte[] salt = generateSalt(16);
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, iterationCount, 256); // $Alert[java/quantum/examples/unknown-kdf-iteration-count]
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
        byte[] key = factory.generateSecret(spec).getEncoded();
    }

    /**
     * PBKDF2 derivation with a high iteration count.
     *
     * SAST/CBOM: - Parent: PBKDF2. - Uses 1,000,000 iterations; this is secure
     * but may impact performance.
     */
    public void pbkdf2HighIteration(String password) throws Exception {
        byte[] salt = generateSalt(16);
        int iterationCount = 1_000_000; 
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, iterationCount, 256); 
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
        byte[] key = factory.generateSecret(spec).getEncoded();
    }
}