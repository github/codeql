    KeyPairGenerator keyPairGen1 = KeyPairGenerator.getInstance("RSA");
    // GOOD: Key size is no less than 2048
    keyPairGen1.initialize(2048);

    KeyPairGenerator keyPairGen2 = KeyPairGenerator.getInstance("DSA");
    // GOOD: Key size is no less than 2048
    keyPairGen2.initialize(2048);

    KeyPairGenerator keyPairGen3 = KeyPairGenerator.getInstance("EC");
    // GOOD: Key size is no less than 256
    ECGenParameterSpec ecSpec = new ECGenParameterSpec("secp256r1");
    keyPairGen3.initialize(ecSpec);

    KeyGenerator keyGen = KeyGenerator.getInstance("AES");
    // GOOD: Key size is no less than 128
    keyGen.init(128);
