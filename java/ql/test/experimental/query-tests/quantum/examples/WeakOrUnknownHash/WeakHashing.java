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

        // BAD: Using a weak hashing algorithm even with a secure default
        MessageDigest bad = MessageDigest.getInstance(props.getProperty("hashAlg1"));

        // BAD: Using a weak hashing algorithm even with a secure default
        MessageDigest bad2 = MessageDigest.getInstance(props.getProperty("hashAlg1", "SHA-256"));

        // BAD: Using a strong hashing algorithm but with a weak default
        MessageDigest bad3 = MessageDigest.getInstance(props.getProperty("hashAlg2", "MD5"));

        // BAD: Property does not exist and default (used value) is unknown
        MessageDigest bad4 = MessageDigest.getInstance(props.getProperty("non-existent_property", "non-existent_default"));

        // GOOD: Using a strong hashing algorithm
        MessageDigest ok = MessageDigest.getInstance(props.getProperty("hashAlg2"));

        // BAD?: Property does not exist (considered unknown) and but default is secure
        MessageDigest ok2 = MessageDigest.getInstance(props.getProperty("non-existent-property", "SHA-256"));

        // GOOD: Using a strong hashing algorithm
        MessageDigest ok3 = MessageDigest.getInstance("SHA3-512");

         // GOOD: Using a strong hashing algorithm
        MessageDigest ok4 = MessageDigest.getInstance("SHA384");

        props.load(new FileInputStream("unobserved-file.properties"));

        // BAD: "hashalg1" is not visible since the file isn't known, this is an 'unknown' hash
        // False positive/negative
        MessageDigest bad5 = MessageDigest.getInstance(props.getProperty("hashAlg1", "SHA-256"));
    }
}
