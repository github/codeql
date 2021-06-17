import java.nio.ByteBuffer;
import java.security.Key;
import java.security.MessageDigest;
import java.security.PrivateKey;
import java.security.Signature;
import java.util.Arrays;
import java.util.Objects;
import javax.crypto.Cipher;
import javax.crypto.Mac;

public class NonConstantTimeCryptoComparison {

    // BAD: compare MACs using a non-constant time method
    public boolean unsafeMacCheckWithArrayEquals(byte[] expectedMac, byte[] data) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        byte[] actualMac = mac.doFinal(data);
        return Arrays.equals(expectedMac, actualMac);
    }

    // BAD: compare MACs using a non-constant time method
    public boolean unsafeMacCheckWithArraysDeepEquals(byte[] expectedMac, byte[] data) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        byte[] actualMac = mac.doFinal(data);
        return Arrays.deepEquals(castToObjectArray(expectedMac), castToObjectArray(actualMac));
    }

    // BAD: compare MACs using a non-constant time method
    public boolean unsafeMacCheckWithDoFinalWithOutputArray(byte[] expectedMac, byte[] data) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        byte[] actualMac = new byte[256];
        mac.doFinal(actualMac, 0);
        return Arrays.equals(expectedMac, actualMac);
    }

    // GOOD: compare MACs using a constant time method
    public boolean saferMacCheck(byte[] expectedMac, byte[] data) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        byte[] actualMac = mac.doFinal(data);
        return MessageDigest.isEqual(expectedMac, actualMac);
    }

    // BAD: compare signatures using a non-constant time method
    public boolean unsafeCheckSignatures(byte[] expected, byte[] data, PrivateKey key) throws Exception {
        Signature engine = Signature.getInstance("SHA256withRSA");
        engine.initSign(key);
        engine.update(data);
        byte[] signature = engine.sign();
        return Arrays.equals(expected, signature);
    }

    // BAD: compare signatures using a non-constant time method
    public boolean unsafeCheckSignaturesWithOutputArray(byte[] expected, byte[] data, PrivateKey key) throws Exception {
        Signature engine = Signature.getInstance("SHA256withRSA");
        engine.initSign(key);
        byte[] signature = new byte[1024];
        engine.sign(signature, 0, 1024);
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

    // BAD: compare ciphertexts using a non-constant time method
    public boolean unsafeCheckCiphertext(byte[] expected, byte[] plaintext, Key key) throws Exception {
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.ENCRYPT_MODE, key);
        byte[] tag = cipher.doFinal(plaintext);
        return Objects.deepEquals(expected, tag);
    }

    // BAD: compare ciphertexts using a non-constant time method
    public boolean unsafeCheckCiphertextWithOutputArray(byte[] expected, byte[] plaintext, Key key) throws Exception {
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.ENCRYPT_MODE, key);
        cipher.update(plaintext);
        byte[] tag = new byte[1024];
        cipher.doFinal(tag, 0);
        return Arrays.equals(expected, tag);
    }

    // BAD: compare ciphertexts using a non-constant time method
    public boolean unsafeCheckCiphertextWithByteBuffer(byte[] expected, byte[] plaintext, Key key) throws Exception {
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.ENCRYPT_MODE, key);
        cipher.update(plaintext);
        ByteBuffer tag = ByteBuffer.wrap(new byte[1024]);
        cipher.doFinal(ByteBuffer.wrap(plaintext), tag);
        return Arrays.equals(expected, tag.array());
    }

    // BAD: compare ciphertexts using a non-constant time method
    public boolean unsafeCheckCiphertextWithByteBufferEquals(byte[] expected, byte[] plaintext, Key key) throws Exception {
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.ENCRYPT_MODE, key);
        cipher.update(plaintext);
        ByteBuffer tag = ByteBuffer.wrap(new byte[1024]);
        cipher.doFinal(ByteBuffer.wrap(plaintext), tag);
        return ByteBuffer.wrap(expected).equals(tag);
    }

    // GOOD: compare ciphertexts using a constant time method
    public boolean saferCheckCiphertext(byte[] expected, byte[] plaintext, Key key) throws Exception {
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.ENCRYPT_MODE, key);
        byte[] tag = cipher.doFinal(plaintext);
        return MessageDigest.isEqual(expected, tag);
    }

    private static Object[] castToObjectArray(byte[] array) {
        Object[] result = new Object[array.length];
        for (int i = 0; i < array.length; i++) {
            result[i] = array[i];
        }
        return result;
    }
 
}