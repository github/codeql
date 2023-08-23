package com.example;

import java.util.Properties;
import java.io.FileInputStream;
import java.io.IOException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class WeakHashing {
    void hashing() throws NoSuchAlgorithmException, IOException {
        java.util.Properties props = new java.util.Properties();
        props.load(new FileInputStream("example.properties"));

        MessageDigest bad = MessageDigest.getInstance(props.getProperty("hashAlg1"));

        MessageDigest ok = MessageDigest.getInstance(props.getProperty("hashAlg2"));
    }
}
