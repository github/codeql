import java.security.SecureRandom;
import org.bouncycastle.crypto.engines.AESEngine;
import org.bouncycastle.crypto.modes.GCMBlockCipher;
import org.bouncycastle.crypto.params.AEADParameters;
import org.bouncycastle.crypto.params.KeyParameter;
import org.bouncycastle.jce.provider.BouncyCastleProvider;
import java.security.Security;
import java.util.Arrays;

/**
 * Example of AES-GCM encryption and decryption using Bouncy Castle's low-level API.
 */
public class AESGCMEncryption {
        byte[] encrypt(byte[] plaintext, byte[] key, byte[] nonce, byte[] aad) throws Exception {
        AESEngine engine = new AESEngine();
        GCMBlockCipher cipher = new GCMBlockCipher(engine);
        AEADParameters params = new AEADParameters(
                new KeyParameter(key),
                128, // Authentication tag size in bits
                nonce,
                aad);
        
        cipher.init(true, params); // true for encryption
        byte[] ciphertext = new byte[cipher.getOutputSize(plaintext.length)];
        int outputLen = cipher.processBytes(plaintext, 0, plaintext.length, ciphertext, 0);
        outputLen += cipher.doFinal(ciphertext, outputLen);
        
        if (outputLen != ciphertext.length) {
            ciphertext = Arrays.copyOf(ciphertext, outputLen);
        }
        return ciphertext;
    }
    byte[] decrypt(byte[] ciphertext, byte[] key, byte[] nonce, byte[] aad) throws Exception {
        AESEngine engine = new AESEngine();
        GCMBlockCipher cipher = new GCMBlockCipher(engine);
        AEADParameters params = new AEADParameters(
                new KeyParameter(key),
                128, // Authentication tag size in bits
                nonce,
                aad);
        
        cipher.init(false, params); // false for decryption
        byte[] plaintext = new byte[cipher.getOutputSize(ciphertext.length)];
        int outputLen = cipher.processBytes(ciphertext, 0, ciphertext.length, plaintext, 0);
        outputLen += cipher.doFinal(plaintext, outputLen);
        
        if (outputLen != plaintext.length) {
            plaintext = Arrays.copyOf(plaintext, outputLen);
        }
        return plaintext;
    }
    public static void main(String[] args) {
        Security.addProvider(new BouncyCastleProvider());
        
        try {
            SecureRandom random = new SecureRandom();
            byte[] key = new byte[32];
            random.nextBytes(key);
            byte[] nonce = new byte[12];
            random.nextBytes(nonce);
            
            byte[] message = "This is a message to be encrypted.".getBytes("UTF-8");
            byte[] aad = "This is additional authenticated data".getBytes("UTF-8");
            byte[] ciphertext = new AESGCMEncryption().encrypt(message, key, nonce, aad);
            byte[] plaintext = new AESGCMEncryption().decrypt(ciphertext, key, nonce, aad); 
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}