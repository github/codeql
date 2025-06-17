import java.security.SecureRandom;
import java.security.Security;
import java.util.Arrays;
import org.bouncycastle.crypto.engines.AESEngine;
import org.bouncycastle.crypto.modes.CBCBlockCipher;
import org.bouncycastle.crypto.paddings.PKCS7Padding;
import org.bouncycastle.crypto.paddings.PaddedBufferedBlockCipher;
import org.bouncycastle.crypto.params.KeyParameter;
import org.bouncycastle.crypto.params.ParametersWithIV;
import org.bouncycastle.jce.provider.BouncyCastleProvider;

/**
 * Example of AES-CBC encryption and decryption using Bouncy Castle's low-level API.
 */
public class AESCBCEncryption {
    byte[] encrypt(byte[] plaintext, byte[] key, byte[] iv) throws Exception {
        AESEngine engine = new AESEngine();
        CBCBlockCipher mode = new CBCBlockCipher(engine);
        PKCS7Padding padding = new PKCS7Padding();
        PaddedBufferedBlockCipher cipher = new PaddedBufferedBlockCipher(mode, padding);
        
        KeyParameter keyParam = new KeyParameter(key);
        ParametersWithIV params = new ParametersWithIV(keyParam, iv);
        
        cipher.init(true, params); // true for encryption
        byte[] ciphertext = new byte[cipher.getOutputSize(plaintext.length)];
        int outputLen = cipher.processBytes(plaintext, 0, plaintext.length, ciphertext, 0);
        outputLen += cipher.doFinal(ciphertext, outputLen);
        
        if (outputLen != ciphertext.length) {
            ciphertext = Arrays.copyOf(ciphertext, outputLen);
        }
        return ciphertext;
    }
    byte[] decrypt(byte[] ciphertext, byte[] key, byte[] iv) throws Exception {
        AESEngine engine = new AESEngine();
        CBCBlockCipher mode = new CBCBlockCipher(engine);
        PKCS7Padding padding = new PKCS7Padding();
        PaddedBufferedBlockCipher cipher = new PaddedBufferedBlockCipher(mode, padding);
        
        KeyParameter keyParam = new KeyParameter(key);
        ParametersWithIV params = new ParametersWithIV(keyParam, iv);
        
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
            byte[] iv = new byte[16];
            random.nextBytes(iv);
            
            byte[] message = "Hello AES-CBC mode!".getBytes("UTF-8");
            byte[] ciphertext = new AESCBCEncryption().encrypt(message, key, iv);
            byte[] plaintext = new AESCBCEncryption().decrypt(ciphertext, key, iv); 
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
