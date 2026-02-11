package com.example.crypto.artifacts;

import java.security.*;
import javax.crypto.Cipher;
import javax.crypto.KeyGenerator;
import javax.crypto.SecretKey;
import javax.crypto.spec.IvParameterSpec;

public class Test {

    public static SecretKey generateAESKey() throws Exception {
        KeyGenerator keyGen = KeyGenerator.getInstance("AES");
        keyGen.init(256);
        return keyGen.generateKey();
    }

    private static byte[] getRandomWrapper1() throws Exception {
        byte[] val = new byte[16];
        new SecureRandom().nextBytes(val);
        return val;
    }

    private static byte[] getRandomWrapper2A() throws Exception {
        byte[] val;
        val = getRandomWrapper1();
        funcA1(val);
        return val;
    }

    private static byte[] getRandomWrapper2b() throws Exception {
        byte[] val;
        val = getRandomWrapper1();
        return val;
    }

    private static void funcA1(byte[] iv) throws Exception {
        IvParameterSpec ivSpec = new IvParameterSpec(iv);
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        SecretKey key = generateAESKey();
        cipher.init(Cipher.ENCRYPT_MODE, key, ivSpec); // BAD: Reuse of `iv` in funcB1
        byte[] ciphertext = cipher.doFinal("Simple Test Data".getBytes());
    }

    private static void funcB1() throws Exception {
        byte[] iv = getRandomWrapper2A();
        IvParameterSpec ivSpec = new IvParameterSpec(iv);
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        SecretKey key = generateAESKey();
        cipher.init(Cipher.ENCRYPT_MODE, key, ivSpec); // BAD: Reuse of `iv` in funcA1
        byte[] ciphertext = cipher.doFinal("Simple Test Data".getBytes());
    }

    private static void funcA2() throws Exception {
        byte[] iv = getRandomWrapper2b();
        IvParameterSpec ivSpec = new IvParameterSpec(iv);
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        SecretKey key = generateAESKey();
        cipher.init(Cipher.ENCRYPT_MODE, key, ivSpec); // GOOD
        byte[] ciphertext = cipher.doFinal("Simple Test Data".getBytes());
    }

    private static void funcB2() throws Exception {
        byte[] iv = getRandomWrapper2b();
        IvParameterSpec ivSpec = new IvParameterSpec(iv);
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        SecretKey key = generateAESKey();
        cipher.init(Cipher.ENCRYPT_MODE, key, ivSpec); // GOOD
        byte[] ciphertext = cipher.doFinal("Simple Test Data".getBytes());
    }

    private static void funcA3() throws Exception {
        byte[] iv = getRandomWrapper2b();
        IvParameterSpec ivSpec1 = new IvParameterSpec(iv);
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        SecretKey key1 = generateAESKey();
        cipher.init(Cipher.ENCRYPT_MODE, key1, ivSpec1); // BAD: reuse of `iv` below
        byte[] ciphertext = cipher.doFinal("Simple Test Data".getBytes());

        IvParameterSpec ivSpec2 = new IvParameterSpec(iv);
        Cipher cipher2 = Cipher.getInstance("AES/CBC/PKCS5Padding");
        SecretKey key2 = generateAESKey();
        cipher2.init(Cipher.ENCRYPT_MODE, key2, ivSpec2); // BAD: Reuse of `iv` above
        byte[] ciphertext2 = cipher2.doFinal("Simple Test Data".getBytes());
    }

    public void falsePositive1() throws Exception {
        byte[] iv = null;
        new SecureRandom().nextBytes(iv);
        IvParameterSpec ivSpec = new IvParameterSpec(iv);
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        SecretKey key = generateAESKey();
        if (iv != null) {
            cipher.init(Cipher.ENCRYPT_MODE, key, ivSpec); // GOOD
            byte[] ciphertext = cipher.doFinal("Simple Test Data".getBytes());
        } else if(iv.length > 0) {
            cipher.init(Cipher.ENCRYPT_MODE, key, ivSpec); // GOOD
            byte[] ciphertext = cipher.doFinal("Simple Test Data".getBytes());
        }
    }

    public void falsePositive2() throws Exception {
        byte[] iv = null;
        new SecureRandom().nextBytes(iv);
        IvParameterSpec ivSpec = new IvParameterSpec(iv);
        Cipher cipher = Cipher.getInstance("AES/CBC/PKCS5Padding");
        SecretKey key = generateAESKey();
        cipher.init(Cipher.ENCRYPT_MODE, key, ivSpec); // GOOD
        byte[] ciphertext = cipher.doFinal("Simple Test Data".getBytes());

        cipher.init(Cipher.DECRYPT_MODE, key, ivSpec); // GOOD
        byte[] decryptedData = cipher.doFinal(ciphertext);
    }

    public static void main(String[] args) {
        try {
            funcA2();
            funcB1();
            funcB2();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
