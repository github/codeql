import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import java.security.Key;
import java.security.NoSuchAlgorithmException;
import javax.crypto.SecretKeyFactory;

public class Test {
    public static void main(String[] args) throws Exception {
        byte[] data = "Sensitive Data".getBytes();

        // BAD: DES (unsafe)
        KeyGenerator desKeyGen = KeyGenerator.getInstance("DES"); // $Alert
        SecretKey desKey = desKeyGen.generateKey();
        Cipher desCipher = Cipher.getInstance("DES"); // $Alert
        desCipher.init(Cipher.ENCRYPT_MODE, desKey);
        byte[] desEncrypted = desCipher.doFinal(data);

        // BAD: DESede (Triple DES, considered weak)
        KeyGenerator desedeKeyGen = KeyGenerator.getInstance("DESede"); // $Alert
        SecretKey desedeKey = desedeKeyGen.generateKey();
        Cipher desedeCipher = Cipher.getInstance("DESede"); // $Alert
        desedeCipher.init(Cipher.ENCRYPT_MODE, desedeKey);
        byte[] desedeEncrypted = desedeCipher.doFinal(data);

        // BAD: Blowfish (considered weak)
        KeyGenerator blowfishKeyGen = KeyGenerator.getInstance("Blowfish"); // $Alert
        SecretKey blowfishKey = blowfishKeyGen.generateKey();
        Cipher blowfishCipher = Cipher.getInstance("Blowfish"); // $Alert
        blowfishCipher.init(Cipher.ENCRYPT_MODE, blowfishKey);
        byte[] blowfishEncrypted = blowfishCipher.doFinal(data);

        // BAD: RC2 (unsafe)
        KeyGenerator rc2KeyGen = KeyGenerator.getInstance("RC2"); // $Alert
        SecretKey rc2Key = rc2KeyGen.generateKey();
        Cipher rc2Cipher = Cipher.getInstance("RC2"); // $Alert
        rc2Cipher.init(Cipher.ENCRYPT_MODE, rc2Key);
        byte[] rc2Encrypted = rc2Cipher.doFinal(data);

        // BAD: RC4 (stream cipher, unsafe)
        KeyGenerator rc4KeyGen = KeyGenerator.getInstance("RC4"); // $Alert
        SecretKey rc4Key = rc4KeyGen.generateKey();
        Cipher rc4Cipher = Cipher.getInstance("RC4"); // $Alert
        rc4Cipher.init(Cipher.ENCRYPT_MODE, rc4Key);
        byte[] rc4Encrypted = rc4Cipher.doFinal(data);

        // BAD: IDEA (considered weak)
        KeyGenerator ideaKeyGen = KeyGenerator.getInstance("IDEA"); // $Alert
        SecretKey ideaKey = ideaKeyGen.generateKey();
        Cipher ideaCipher = Cipher.getInstance("IDEA"); // $Alert
        ideaCipher.init(Cipher.ENCRYPT_MODE, ideaKey);
        byte[] ideaEncrypted = ideaCipher.doFinal(data);

        // BAD: Skipjack (unsafe)
        KeyGenerator skipjackKeyGen = KeyGenerator.getInstance("Skipjack"); // $Alert
        SecretKey skipjackKey = skipjackKeyGen.generateKey();
        Cipher skipjackCipher = Cipher.getInstance("Skipjack"); // $Alert
        skipjackCipher.init(Cipher.ENCRYPT_MODE, skipjackKey);
        byte[] skipjackEncrypted = skipjackCipher.doFinal(data);

        // GOOD: AES (safe)
        KeyGenerator aesKeyGen = KeyGenerator.getInstance("AES");
        SecretKey aesKey = aesKeyGen.generateKey();
        Cipher aesCipher = Cipher.getInstance("AES");
        aesCipher.init(Cipher.ENCRYPT_MODE, aesKey);
        byte[] aesEncrypted = aesCipher.doFinal(data);

        // GOOD: AES with CBC mode and PKCS5Padding
        Cipher aesCbcCipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        aesCbcCipher.init(Cipher.ENCRYPT_MODE, aesKey);
        byte[] aesCbcEncrypted = aesCbcCipher.doFinal(data);

        // GOOD: AES with GCM mode (authenticated encryption)
        Cipher aesGcmCipher = Cipher.getInstance("AES/GCM/NoPadding");
        aesGcmCipher.init(Cipher.ENCRYPT_MODE, aesKey);
        byte[] aesGcmEncrypted = aesGcmCipher.doFinal(data);

        // GOOD: not a symmetric cipher (Sanity check)
        SecretKeyFactory factory = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256");
    }
}