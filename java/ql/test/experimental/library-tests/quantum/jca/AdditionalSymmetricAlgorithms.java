package com.example.crypto.algorithms;

import java.security.*;
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;

/**
 * Demonstrates symmetric encryption using cipher algorithms beyond the
 * standard JCA defaults, typically available through BouncyCastle.
 *
 * Algorithms covered: Twofish, ARIA, Camellia, Salsa20, SEED, Blowfish.
 */
public class AdditionalSymmetricAlgorithms {

    /**
     * Twofish in CBC mode with PKCS5 padding.
     */
    public byte[] twofishEncrypt(byte[] plaintext) throws Exception {
        KeyGenerator keyGen = KeyGenerator.getInstance("Twofish");
        keyGen.init(256);
        SecretKey key = keyGen.generateKey();
        Cipher cipher = Cipher.getInstance("Twofish/CBC/PKCS5Padding");
        byte[] iv = new byte[16];
        new SecureRandom().nextBytes(iv);
        cipher.init(Cipher.ENCRYPT_MODE, key, new IvParameterSpec(iv));
        return cipher.doFinal(plaintext);
    }

    /**
     * ARIA in CBC mode with PKCS5 padding.
     */
    public byte[] ariaEncrypt(byte[] plaintext) throws Exception {
        KeyGenerator keyGen = KeyGenerator.getInstance("ARIA");
        keyGen.init(256);
        SecretKey key = keyGen.generateKey();
        Cipher cipher = Cipher.getInstance("ARIA/CBC/PKCS5Padding");
        byte[] iv = new byte[16];
        new SecureRandom().nextBytes(iv);
        cipher.init(Cipher.ENCRYPT_MODE, key, new IvParameterSpec(iv));
        return cipher.doFinal(plaintext);
    }

    /**
     * Camellia in CBC mode with no padding.
     */
    public byte[] camelliaEncrypt(byte[] plaintext) throws Exception {
        KeyGenerator keyGen = KeyGenerator.getInstance("Camellia");
        keyGen.init(256);
        SecretKey key = keyGen.generateKey();
        Cipher cipher = Cipher.getInstance("Camellia/CBC/NoPadding");
        byte[] iv = new byte[16];
        new SecureRandom().nextBytes(iv);
        cipher.init(Cipher.ENCRYPT_MODE, key, new IvParameterSpec(iv));
        return cipher.doFinal(plaintext);
    }

    /**
     * Salsa20 stream cipher.
     */
    public byte[] salsa20Encrypt(byte[] plaintext) throws Exception {
        KeyGenerator keyGen = KeyGenerator.getInstance("Salsa20");
        keyGen.init(256);
        SecretKey key = keyGen.generateKey();
        Cipher cipher = Cipher.getInstance("Salsa20");
        cipher.init(Cipher.ENCRYPT_MODE, key);
        return cipher.doFinal(plaintext);
    }

    /**
     * SEED in CBC mode with PKCS5 padding.
     */
    public byte[] seedEncrypt(byte[] plaintext) throws Exception {
        KeyGenerator keyGen = KeyGenerator.getInstance("SEED");
        keyGen.init(128);
        SecretKey key = keyGen.generateKey();
        Cipher cipher = Cipher.getInstance("SEED/CBC/PKCS5Padding");
        byte[] iv = new byte[16];
        new SecureRandom().nextBytes(iv);
        cipher.init(Cipher.ENCRYPT_MODE, key, new IvParameterSpec(iv));
        return cipher.doFinal(plaintext);
    }

    /**
     * Blowfish in CBC mode with PKCS5 padding.
     */
    public byte[] blowfishEncrypt(byte[] plaintext) throws Exception {
        KeyGenerator keyGen = KeyGenerator.getInstance("Blowfish");
        keyGen.init(128);
        SecretKey key = keyGen.generateKey();
        Cipher cipher = Cipher.getInstance("Blowfish/CBC/PKCS5Padding");
        byte[] iv = new byte[8];
        new SecureRandom().nextBytes(iv);
        cipher.init(Cipher.ENCRYPT_MODE, key, new IvParameterSpec(iv));
        return cipher.doFinal(plaintext);
    }
}
