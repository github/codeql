package org.apache.shiro.crypto;

import java.security.Key;
import java.security.NoSuchAlgorithmException;
import javax.crypto.KeyGenerator;

public abstract class AbstractSymmetricCipherService extends JcaCipherService {
    protected AbstractSymmetricCipherService(String algorithmName) {
        super(algorithmName);
    }

    public Key generateNewKey() {
        return this.generateNewKey(this.getKeySize());
    }

    public Key generateNewKey(int keyBitSize) {
        KeyGenerator kg;
        try {
            kg = KeyGenerator.getInstance(this.getAlgorithmName());
        } catch (NoSuchAlgorithmException var5) {
            String msg = "Unable to acquire " + this.getAlgorithmName() + " algorithm.  This is required to function.";
            throw new IllegalStateException(msg, var5);
        }

        kg.init(keyBitSize);
        return kg.generateKey();
    }
}