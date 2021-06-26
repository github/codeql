import java.io.InputStream;
import java.net.Socket;
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

    // BAD: compare MACs using a non-constant-time method
    public boolean unsafeMacCheckWithArrayEquals(byte[] expectedMac, Socket socket) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        byte[] data = new byte[1024];
        socket.getInputStream().read(data);
        byte[] actualMac = mac.doFinal(data);
        return Arrays.equals(expectedMac, actualMac);
    }

    // BAD: compare MACs using a non-constant-time method
    public boolean unsafeMacCheckWithArraysDeepEquals(byte[] expectedMac, Socket socket) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        byte[] data = socket.getInputStream().readAllBytes();
        mac.update(data);
        byte[] actualMac = mac.doFinal();
        return Arrays.deepEquals(castToObjectArray(expectedMac), castToObjectArray(actualMac));
    }

    // BAD: compare MACs using a non-constant-time method
    public boolean unsafeMacCheckWithDoFinalWithOutputArray(byte[] data, Socket socket) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        byte[] actualMac = new byte[256];
        mac.doFinal(actualMac, 0);
        byte[] expectedMac = socket.getInputStream().readNBytes(256);
        return Arrays.equals(expectedMac, actualMac);
    }

    // GOOD: compare MACs using a constant-time method
    public boolean saferMacCheck(byte[] expectedMac, Socket socket) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        byte[] data = new byte[1024];
        socket.getInputStream().read(data);
        byte[] actualMac = mac.doFinal(data);
        return MessageDigest.isEqual(expectedMac, actualMac);
    }

    // BAD: compare signatures using a non-constant-time method
    public boolean unsafeCheckSignatures(byte[] expected, Socket socket, PrivateKey key) throws Exception {
        Signature engine = Signature.getInstance("SHA256withRSA");
        engine.initSign(key);
        byte[] data = socket.getInputStream().readAllBytes();
        engine.update(data);
        byte[] signature = engine.sign();
        return Arrays.equals(expected, signature);
    }

    // BAD: compare signatures using a non-constant-time method
    public boolean unsafeCheckSignaturesWithOutputArray(byte[] expected, Socket socket, PrivateKey key) throws Exception {
        Signature engine = Signature.getInstance("SHA256withRSA");
        engine.initSign(key);
        byte[] data = socket.getInputStream().readAllBytes();
        engine.update(data);
        byte[] signature = new byte[1024];
        engine.sign(signature, 0, 1024);
        return Arrays.equals(expected, signature);
    }

    // GOOD: compare signatures using a constant-time method
    public boolean saferCheckSignatures(byte[] expected, Socket socket, PrivateKey key) throws Exception {
        Signature engine = Signature.getInstance("SHA256withRSA");
        engine.initSign(key);
        byte[] data = socket.getInputStream().readAllBytes();
        engine.update(data);
        byte[] signature = engine.sign();
        return MessageDigest.isEqual(expected, signature);
    }

    // BAD: compare ciphertexts using a non-constant-time method
    public boolean unsafeCheckCiphertext(Socket socket, byte[] plaintext, Key key) throws Exception {
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.ENCRYPT_MODE, key);
        byte[] tag = cipher.doFinal(plaintext);
        byte[] expected = socket.getInputStream().readAllBytes();
        return Objects.deepEquals(expected, tag);
    }

    // BAD: compare ciphertexts using a non-constant-time method
    public boolean unsafeCheckCiphertextWithOutputArray(byte[] expected, Socket socket, Key key) throws Exception {
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.ENCRYPT_MODE, key);
        byte[] plaintext = socket.getInputStream().readAllBytes();
        cipher.update(plaintext);
        byte[] tag = new byte[1024];
        cipher.doFinal(tag, 0);
        return Arrays.equals(expected, tag);
    }

    // BAD: compare ciphertexts using a non-constant-time method
    public boolean unsafeCheckCiphertextWithByteBuffer(Socket socket, byte[] plaintext, Key key) throws Exception {
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.ENCRYPT_MODE, key);
        cipher.update(plaintext);
        ByteBuffer tag = ByteBuffer.wrap(new byte[1024]);
        cipher.doFinal(ByteBuffer.wrap(plaintext), tag);
        byte[] expected = socket.getInputStream().readNBytes(1024);
        return Arrays.equals(expected, tag.array());
    }

    // BAD: compare ciphertexts using a non-constant-time method
    public boolean unsafeCheckCiphertextWithByteBufferEquals(byte[] expected, Socket socket, Key key) throws Exception {
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.ENCRYPT_MODE, key);
        byte[] plaintext = socket.getInputStream().readAllBytes();
        cipher.update(plaintext);
        ByteBuffer tag = ByteBuffer.wrap(new byte[1024]);
        cipher.doFinal(ByteBuffer.wrap(plaintext), tag);
        return ByteBuffer.wrap(expected).equals(tag);
    }

    // GOOD: compare ciphertexts using a constant-time method
    public boolean saferCheckCiphertext(Socket socket, byte[] plaintext, Key key) throws Exception {
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.ENCRYPT_MODE, key);
        byte[] tag = cipher.doFinal(plaintext);
        byte[] expected = socket.getInputStream().readAllBytes();
        return MessageDigest.isEqual(expected, tag);
    }

    // GOOD: compare ciphertexts using a constant-time method, but no user input
    public boolean noUserInputWhenCheckingCiphertext(byte[] expected, byte[] plaintext, Key key) throws Exception {
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        cipher.init(Cipher.ENCRYPT_MODE, key);
        byte[] tag = cipher.doFinal(plaintext);
        return Arrays.equals(expected, tag);
    }

    // GOOD: compare MAC with constant using a constant-time method
    public boolean compareMacWithConstant(Socket socket) throws Exception {
        Mac mac = Mac.getInstance("HmacSHA256");
        byte[] data = new byte[1024];
        socket.getInputStream().read(data);
        byte[] actualMac = mac.doFinal(data);
        return "constant".equals(new String(actualMac));
    }

    private static Object[] castToObjectArray(byte[] array) {
        Object[] result = new Object[array.length];
        for (int i = 0; i < array.length; i++) {
            result[i] = array[i];
        }
        return result;
    }

    // BAD: compare MAC using a non-constant-time loop
    public boolean unsafeMacCheckWithLoop(Socket socket) throws Exception {
        try (InputStream is = socket.getInputStream()) {
            byte[] data = new byte[256];
            byte[] tag = new byte[32];

            is.read(data);
            is.read(tag);

            Mac mac = Mac.getInstance("Hmac256");
            byte[] computedTag = mac.doFinal(data);

            for (int i = 0; i < computedTag.length; i++) {
                byte a = computedTag[i];
                byte b = tag[i];
                if (a != b) {
                    return false;
                }
            }

            return true;
        }
    }

    // GOOD: compare MAC using a constant-time loop
    public boolean safeMacCheckWithLoop(Socket socket) throws Exception {
        try (InputStream is = socket.getInputStream()) {
            byte[] data = new byte[256];
            byte[] tag = new byte[32];

            is.read(data);
            is.read(tag);

            Mac mac = Mac.getInstance("Hmac256");
            byte[] computedTag = mac.doFinal(data);

            int result = 0;
            for (int i = 0; i < computedTag.length; i++) {
                result |= computedTag[i] ^ tag[i];
            }

            return result == 0;
        }
    }
 
}