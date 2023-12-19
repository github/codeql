package test.cwe327.semmle.tests;

import java.util.Properties;
import java.io.FileInputStream;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class WeakHashing {
    void hashing() throws NoSuchAlgorithmException, IOException {
        java.util.Properties props = new java.util.Properties();
        props.load(new FileInputStream("example.properties"));

        // BAD: Using a weak hashing algorithm
        MessageDigest bad = MessageDigest.getInstance(props.getProperty("hashAlg1"));

        // GOOD: Using a strong hashing algorithm
        MessageDigest ok = MessageDigest.getInstance(props.getProperty("hashAlg2"));
    }
}