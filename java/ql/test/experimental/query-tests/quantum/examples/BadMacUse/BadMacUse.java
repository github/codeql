import java.security.*;
import java.util.Arrays;
import java.util.Base64;
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.Mac;
import javax.crypto.SecretKey;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;
import javax.crypto.spec.SecretKeySpec;


class BadMacUse {

    private byte[] generateSalt(int length) {
        byte[] salt = new byte[length];
        new SecureRandom().nextBytes(salt);
        return salt;
    }
   
    public void CipherThenMac(byte[] encryptionKeyBytes, byte[] macKeyBytes) throws Exception {
        // Create keys directly from provided byte arrays
        SecretKey encryptionKey = new SecretKeySpec(encryptionKeyBytes, "AES");
        SecretKey macKey = new SecretKeySpec(macKeyBytes, "HmacSHA256");

        // Encrypt some sample data using the encryption key
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        cipher.init(Cipher.ENCRYPT_MODE, encryptionKey, new SecureRandom());
        byte[] plaintext = "Further Use Test Data".getBytes();
        byte[] ciphertext = cipher.doFinal(plaintext);

        // Compute HMAC over the ciphertext using the MAC key
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(macKey);
        byte[] computedMac = mac.doFinal(ciphertext);

        // Concatenate ciphertext and MAC
        byte[] output = new byte[ciphertext.length + computedMac.length];
        System.arraycopy(ciphertext, 0, output, 0, ciphertext.length);
        System.arraycopy(computedMac, 0, output, ciphertext.length, computedMac.length);
    }


    public void BadDecryptThenMacOnPlaintextVerify(byte[] encryptionKeyBytes, byte[] macKeyBytes, byte[] input) throws Exception {
        // Split input into ciphertext and MAC
        int macLength = 32; // HMAC-SHA256 output length
        byte[] ciphertext = Arrays.copyOfRange(input, 0, input.length - macLength);
        byte[] receivedMac = Arrays.copyOfRange(input, input.length - macLength, input.length);

        // Decrypt first (unsafe)
        SecretKey encryptionKey = new SecretKeySpec(encryptionKeyBytes, "AES");
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        cipher.init(Cipher.DECRYPT_MODE, encryptionKey, new SecureRandom());
        byte[] plaintext = cipher.doFinal(ciphertext); // $Source

        // Now verify MAC (too late)
        SecretKey macKey = new SecretKeySpec(macKeyBytes, "HmacSHA256");
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(macKey);
        byte[] computedMac = mac.doFinal(plaintext); // $Alert[java/quantum/bad-mac-order-decrypt-to-mac]

        if (!MessageDigest.isEqual(receivedMac, computedMac)) {
            throw new SecurityException("MAC verification failed");
        }
    }

    public void BadMacOnPlaintext(byte[] encryptionKeyBytes, byte[] macKeyBytes, byte[] plaintext) throws Exception {// $Source
        // Create keys directly from provided byte arrays
        SecretKey encryptionKey = new SecretKeySpec(encryptionKeyBytes, "AES");
        SecretKey macKey = new SecretKeySpec(macKeyBytes, "HmacSHA256");

        // BAD Compute MAC over plaintext (not ciphertext)
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(macKey);
        byte[] computedMac = mac.doFinal(plaintext); // Integrity not tied to encrypted data

        // Encrypt the plaintext
        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        cipher.init(Cipher.ENCRYPT_MODE, encryptionKey, new SecureRandom());
        byte[] ciphertext = cipher.doFinal(plaintext); // $Alert[java/quantum/bad-mac-order-encrypt-plaintext-also-in-mac]

        // Concatenate ciphertext and MAC
        byte[] output = new byte[ciphertext.length + computedMac.length];
        System.arraycopy(ciphertext, 0, output, 0, ciphertext.length);
        System.arraycopy(computedMac, 0, output, ciphertext.length, computedMac.length);
    }
}