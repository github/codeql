    KeyPairGenerator keyPairGen1 = KeyPairGenerator.getInstance("RSA");
    // BAD: Key size is less than 2048
    keyPairGen1.initialize(1024);

    KeyPairGenerator keyPairGen2 = KeyPairGenerator.getInstance("DSA");
    // BAD: Key size is less than 2048
    keyPairGen2.initialize(1024);

    KeyPairGenerator keyPairGen3 = KeyPairGenerator.getInstance("EC");
    // BAD: Key size is less than 256
    ECGenParameterSpec ecSpec1 = new ECGenParameterSpec("secp112r1");
    keyPairGen3.initialize(ecSpec1);

    KeyGenerator keyGen = KeyGenerator.getInstance("AES");
    // BAD: Key size is less than 128
    keyGen.init(64);
