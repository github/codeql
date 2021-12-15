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

public class Test {

    // BAD: compare MACs using a non-constant-time method
    public boolean unsafeMacCheckWithArrayEquals(Socket socket) throws Exception {
        try (InputStream is = socket.getInputStream()) {
            Mac mac = Mac.getInstance("HmacSHA256");
            byte[] data = new byte[1024];
            is.read(data);
            byte[] actualMac = mac.doFinal(data);
            byte[] expectedMac = is.readNBytes(32);
            return Arrays.equals(expectedMac, actualMac);
        }
    }

    // BAD: compare MACs using a non-constant-time method
    public boolean unsafeMacCheckWithDoFinalWithOutputArray(Socket socket) throws Exception {
        try (InputStream is = socket.getInputStream()) {
            byte[] data = is.readNBytes(100);
            Mac mac = Mac.getInstance("HmacSHA256");
            byte[] actualMac = new byte[256];
            mac.update(data);
            mac.doFinal(actualMac, 0);
            byte[] expectedMac = socket.getInputStream().readNBytes(256);
            return Arrays.equals(expectedMac, actualMac);
        }
    }

    // GOOD: compare MACs using a constant-time method
    public boolean saferMacCheck(Socket socket) throws Exception {
        try (InputStream is = socket.getInputStream()) {
            Mac mac = Mac.getInstance("HmacSHA256");
            byte[] data = new byte[1024];
            is.read(data);
            byte[] actualMac = mac.doFinal(data);
            byte[] expectedMac = is.readNBytes(32);
            return MessageDigest.isEqual(expectedMac, actualMac);
        }
    }

    // BAD: compare signatures using a non-constant-time method
    public boolean unsafeCheckSignatures(Socket socket, PrivateKey key) throws Exception {
        try (InputStream is = socket.getInputStream()) {
            Signature engine = Signature.getInstance("SHA256withRSA");
            engine.initSign(key);
            byte[] data = socket.getInputStream().readAllBytes();
            engine.update(data);
            byte[] signature = engine.sign();
            byte[] expected = is.readNBytes(256);
            return Arrays.equals(expected, signature);
        }
    }

    // BAD: compare signatures using a non-constant-time method
    public boolean unsafeCheckSignaturesWithOutputArray(Socket socket, PrivateKey key) throws Exception {
        try (InputStream is = socket.getInputStream()) {
            Signature engine = Signature.getInstance("SHA256withRSA");
            engine.initSign(key);
            byte[] data = socket.getInputStream().readAllBytes();
            engine.update(data);
            byte[] signature = new byte[1024];
            engine.sign(signature, 0, 1024);
            byte[] expected = is.readNBytes(256);
            return Arrays.equals(expected, signature);
        }
    }

    // GOOD: compare signatures using a constant-time method
    public boolean saferCheckSignatures(Socket socket, PrivateKey key) throws Exception {
        try (InputStream is = socket.getInputStream()) {
            Signature engine = Signature.getInstance("SHA256withRSA");
            engine.initSign(key);
            byte[] data = socket.getInputStream().readAllBytes();
            engine.update(data);
            byte[] signature = engine.sign();
            byte[] expected = is.readNBytes(256);
            return MessageDigest.isEqual(expected, signature);
        }
    }

    // BAD: compare ciphertexts (custom MAC) using a non-constant-time method
    public boolean unsafeCheckCiphertext(Socket socket, Key key) throws Exception {
        try (InputStream is = socket.getInputStream()) {
            byte[] plaintext = is.readNBytes(100);
            byte[] hash = MessageDigest.getInstance("SHA-256").digest(plaintext);
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(Cipher.ENCRYPT_MODE, key);
            byte[] tag = cipher.doFinal(hash);
            byte[] expected = socket.getInputStream().readAllBytes();
            return Objects.deepEquals(expected, tag);
        }
    }

    // BAD: compare ciphertexts (custom MAC) using a non-constant-time method
    public boolean unsafeCheckCiphertextWithOutputArray(Socket socket, Key key) throws Exception {
        try (InputStream is = socket.getInputStream()) {
            byte[] plaintext = socket.getInputStream().readAllBytes();
            MessageDigest md = MessageDigest.getInstance("SHA-512");
            md.update(plaintext);
            byte[] hash = md.digest();
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(Cipher.ENCRYPT_MODE, key);
            cipher.update(hash);
            byte[] tag = new byte[1024];
            cipher.doFinal(tag, 0);
            byte[] expected = is.readNBytes(32);
            return Arrays.equals(expected, tag);
        }
    }

    // BAD: compare ciphertexts (custom MAC) using a non-constant-time method
    public boolean unsafeCheckCiphertextWithByteBuffer(Socket socket, Key key) throws Exception {
        try (InputStream is = socket.getInputStream()) {
            byte[] plaintext = is.readNBytes(300);
            MessageDigest md = MessageDigest.getInstance("SHA-512");
            md.update(plaintext);
            byte[] hash = new byte[1024];
            md.digest(hash, 0, hash.length);
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(Cipher.ENCRYPT_MODE, key);
            cipher.update(hash);
            ByteBuffer tag = ByteBuffer.wrap(new byte[1024]);
            cipher.doFinal(ByteBuffer.wrap(plaintext), tag);
            byte[] expected = socket.getInputStream().readNBytes(1024);
            return Arrays.equals(expected, tag.array());
        }
    }

    // BAD: compare ciphertexts (custom MAC) using a non-constant-time method
    public boolean unsafeCheckCiphertextWithByteBufferEquals(Socket socket, Key key) throws Exception {
        try (InputStream is = socket.getInputStream()) {
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(Cipher.ENCRYPT_MODE, key);
            byte[] plaintext = socket.getInputStream().readAllBytes();
            cipher.update(plaintext);
            ByteBuffer tag = ByteBuffer.wrap(new byte[1024]);
            cipher.doFinal(ByteBuffer.wrap(plaintext), tag);
            byte[] expected = is.readNBytes(32);
            return ByteBuffer.wrap(expected).equals(tag);
        }
    }

    // GOOD: compare ciphertexts (custom MAC) using a constant-time method
    public boolean saferCheckCiphertext(Socket socket, Key key) throws Exception {
        try (InputStream is = socket.getInputStream()) {
            byte[] plaintext = is.readNBytes(200);
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(Cipher.ENCRYPT_MODE, key);
            byte[] hash = MessageDigest.getInstance("SHA-256").digest(plaintext);
            byte[] tag = cipher.doFinal(hash);
            byte[] expected = socket.getInputStream().readAllBytes();
            return MessageDigest.isEqual(expected, tag);
        }
    }

    // GOOD: compare ciphertexts using a constant-time method, but no user input
    //       but NonConstantTimeCheckOnSignature.ql still detects it
    public boolean noUserInputWhenCheckingCiphertext(Socket socket, Key key) throws Exception {
        try (InputStream is = socket.getInputStream()) {
            byte[] plaintext = is.readNBytes(100);
            Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
            cipher.init(Cipher.ENCRYPT_MODE, key);
            byte[] tag = cipher.doFinal(plaintext);
            byte[] expected = is.readNBytes(32);
            return Arrays.equals(expected, tag);
        }
    }

    // GOOD: compare MAC with constant using a constant-time method
    public boolean compareMacWithConstant(Socket socket) throws Exception {
        try (InputStream is = socket.getInputStream()) {
            Mac mac = Mac.getInstance("HmacSHA256");
            byte[] data = new byte[1024];
            socket.getInputStream().read(data);
            byte[] actualMac = mac.doFinal(data);
            return "constant".equals(new String(actualMac));
        }
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