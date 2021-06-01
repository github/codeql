import java.security.Key;
import java.security.MessageDigest;
import java.security.PrivateKey;
import java.security.Signature;
import java.util.Arrays;
import javax.crypto.Cipher;
import javax.crypto.Mac;

public class NotConstantTimeCryptoComparison {

    // BAD: compare MACs using a not-constant time method
    public boolean unsafeMacCheck(byte[] expectedMac, byte[] data) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        byte[] actualMac = mac.doFinal(data);
        return Arrays.equals(expectedMac, actualMac);
    }

    // GOOD: compare MACs using a constant time method
    public boolean saferMacCheck(byte[] expectedMac, byte[] data) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        byte[] actualMac = mac.doFinal(data);
        return MessageDigest.isEqual(expectedMac, actualMac);
    }

    // BAD: compare hashes using a not-constant time method
    public boolean unsafeCheckMessageDigest(String expectedHash, byte[] data) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        String actual = new String(md.digest(data));
        return actual.equals(expectedHash);
    }

    // GOOD: compare hashes using a constant time method
    public boolean saferCheckMessageDigest(byte[] expected, byte[] data) throws Exception {
        MessageDigest md = MessageDigest.getInstance("SHA-256");
        byte[] actual = md.digest(data);
        return MessageDigest.isEqual(expected, actual);
    }

    // BAD: compare signatures using a not-constant time method
    public boolean unsafeCheckSignatures(byte[] expected, byte[] data, PrivateKey key) throws Exception {
        Signature engine = Signature.getInstance("SHA256withRSA");
        engine.initSign(key);
        engine.update(data);
        byte[] signature = engine.sign();
        return Arrays.equals(expected, signature);
    }

    // GOOD: compare signatures using a constant time method
    public boolean saferCheckSignatures(byte[] expected, byte[] data, PrivateKey key) throws Exception {
        Signature engine = Signature.getInstance("SHA256withRSA");
        engine.initSign(key);
        engine.update(data);
        byte[] signature = engine.sign();
        return MessageDigest.isEqual(expected, signature);
    }

    // BAD: compare ciphertexts using a not-constant time method
    public boolean unsafeCheckCustomMac(byte[] expected, byte[] plaintext, Key key) throws Exception {
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.ENCRYPT_MODE, key);
        byte[] tag = cipher.doFinal(plaintext);
        return Arrays.equals(expected, tag);
    }

    // GOOD: compare ciphertexts using a constant time method
    public boolean saferCheckCustomMac(byte[] expected, byte[] plaintext, Key key) throws Exception {
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.ENCRYPT_MODE, key);
        byte[] tag = cipher.doFinal(plaintext);
        return MessageDigest.isEqual(expected, tag);
    }
 
}