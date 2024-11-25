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

        // BAD: Using a weak hashing algorithm even with a secure default
        MessageDigest bad2 = MessageDigest.getInstance(props.getProperty("hashAlg1", "SHA-256"));

        // BAD: Using a strong hashing algorithm but with a weak default
        MessageDigest bad3 = MessageDigest.getInstance(props.getProperty("hashAlg2", "MD5"));

        // GOOD: Using a strong hashing algorithm
        MessageDigest ok = MessageDigest.getInstance(props.getProperty("hashAlg2"));

        // OK: Property does not exist and default is secure
        MessageDigest ok2 = MessageDigest.getInstance(props.getProperty("hashAlg3", "SHA-256"));

        // GOOD: Using a strong hashing algorithm
        MessageDigest ok3 = MessageDigest.getInstance("SHA3-512");

         // GOOD: Using a strong hashing algorithm
        MessageDigest ok4 = MessageDigest.getInstance("SHA384");
    }
}
