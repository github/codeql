import java.security.SecureRandom;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public class Test {

    public static byte[] generateSalt(int length) {
        SecureRandom random = new SecureRandom();
        byte[] salt = new byte[length];
        random.nextBytes(salt);
        return salt;
    }

    /**
     * PBKDF2 derivation with a weak key size.
     *
     * SAST/CBOM: - Parent: PBKDF2. - Key size is only 64 bits, which is far below acceptable security standards.
     * - Flagged as insecure.
     */
    public void pbkdf2WeakKeySize(String password) throws Exception {
        byte[] salt = generateSalt(16);
        int iterationCount = 100_000;
        int keySize = 64; // $Source
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, iterationCount, keySize); // $Alert[java/quantum/examples/weak-kdf-key-size]
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
        byte[] key = factory.generateSecret(spec).getEncoded();
    }

    /**
     * PBKDF2 derivation with a secure key size.
     *
     * SAST/CBOM: - Parent: PBKDF2. - Key size is 256 bits, which meets modern security standards.
     */
    public void pbkdf2SecureKeySize(String password) throws Exception {
        byte[] salt = generateSalt(16);
        int iterationCount = 100_000;
        int keySize = 256;
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, iterationCount, keySize);
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
        byte[] key = factory.generateSecret(spec).getEncoded();
    }
}