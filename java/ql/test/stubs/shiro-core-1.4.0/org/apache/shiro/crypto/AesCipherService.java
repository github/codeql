package org.apache.shiro.crypto;

public class AesCipherService extends DefaultBlockCipherService {
    private static final String ALGORITHM_NAME = "AES";

    public AesCipherService() {
        super("AES");
    }
}