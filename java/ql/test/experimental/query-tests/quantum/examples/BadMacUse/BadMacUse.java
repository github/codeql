
import java.security.*;
import java.util.Arrays;
import javax.crypto.Cipher;
import javax.crypto.Mac;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;
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
        byte[] computedMac = mac.doFinal(plaintext); // $Alert[java/quantum/examples/bad-mac-order-decrypt-to-mac] 

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
        byte[] ciphertext = cipher.doFinal(plaintext); // $Alert[java/quantum/examples/bad-mac-order-encrypt-plaintext-also-in-mac]

        // Concatenate ciphertext and MAC
        byte[] output = new byte[ciphertext.length + computedMac.length];
        System.arraycopy(ciphertext, 0, output, 0, ciphertext.length);
        System.arraycopy(computedMac, 0, output, ciphertext.length, computedMac.length);
    }

    public byte[] cipherOperationWrapper(byte[] bytes, byte[] encryptionKeyBytes, byte[] iv, int mode)
            throws Exception {

        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        SecretKeySpec secretKeySpec = new SecretKeySpec(encryptionKeyBytes, "AES");

        IvParameterSpec ivParameterSpec = new IvParameterSpec(iv);
        cipher.init(mode, secretKeySpec, ivParameterSpec);
        return cipher.doFinal(bytes);
    }

    /**
     * A use of the cipher operation wrapper for decryption to throw off the
     * analysis
     */
    public byte[] decryptUsingWrapper(byte[] ciphertext, byte[] encryptionKeyBytes, byte[] iv) throws Exception {
        return cipherOperationWrapper(ciphertext, encryptionKeyBytes, iv, Cipher.DECRYPT_MODE);
    }

    /**
     * A use of the cipher operation wrapper for encryption to throw off the
     * analysis
     */
    public byte[] encryptUsingWrapper(byte[] plaintext, byte[] encryptionKeyBytes, byte[] iv) throws Exception {
        return cipherOperationWrapper(plaintext, encryptionKeyBytes, iv, Cipher.ENCRYPT_MODE);
    }

    /**
     * Encrypt then mac using the wrapper function
     */
    public byte[] falsePositiveDecryptToMac(byte[] encryptionKeyBytes, byte[] macKeyBytes, byte[] plaintext) throws Exception {
        // Encrypt the plaintext
        byte[] iv = new byte[16];
        new SecureRandom().nextBytes(iv);
        byte[] ciphertext = cipherOperationWrapper(plaintext, encryptionKeyBytes, iv, Cipher.ENCRYPT_MODE);

        // Compute HMAC over the ciphertext using the MAC key
        SecretKey macKey = new SecretKeySpec(macKeyBytes, "HmacSHA256");
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(macKey);
        byte[] computedMac = mac.doFinal(ciphertext); // False Positive

        // Concatenate ciphertext and MAC
        byte[] output = new byte[ciphertext.length + computedMac.length];
        System.arraycopy(ciphertext, 0, output, 0, ciphertext.length);
        System.arraycopy(computedMac, 0, output, ciphertext.length, computedMac.length);
        return output;
    }


    /**
     * Correct inputs to a decrypt and MAC operation, but the ordering is unsafe. 
     * The function decrypts THEN computes the MAC on the plaintext.
     * It should have the MAC computed on the ciphertext first.
     */
    public void decryptThenMac(byte[] encryptionKeyBytes, byte[] macKeyBytes, byte[] input) throws Exception {
        // Split input into ciphertext and MAC
        int macLength = 32; // HMAC-SHA256 output length
        byte[] ciphertext = Arrays.copyOfRange(input, 0, input.length - macLength);
        byte[] receivedMac = Arrays.copyOfRange(input, input.length - macLength, input.length);

        // Decrypt first (unsafe)
        byte[] plaintext = decryptUsingWrapper(ciphertext, encryptionKeyBytes, new byte[16]); // $Source

        // Now verify MAC (too late)
        SecretKey macKey = new SecretKeySpec(macKeyBytes, "HmacSHA256");
        Mac mac = Mac.getInstance("HmacSHA256");
        mac.init(macKey);
        byte[] computedMac = mac.doFinal(ciphertext); // $Alert[java/quantum/examples/bad-mac-order-decrypt-then-mac], False positive for Plaintext reuse

        if (!MessageDigest.isEqual(receivedMac, computedMac)) {
            throw new SecurityException("MAC verification failed");
        }
    }
}
