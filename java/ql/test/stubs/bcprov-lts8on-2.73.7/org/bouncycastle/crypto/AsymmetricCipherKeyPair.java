package org.bouncycastle.crypto;

public class AsymmetricCipherKeyPair {
    private final Object privateKey;
    private final Object publicKey;

    public AsymmetricCipherKeyPair(Object publicKey, Object privateKey) {
        this.publicKey = publicKey;
        this.privateKey = privateKey;
    }

    public Object getPrivate() {
        return privateKey;
    }

    public Object getPublic() {
        return publicKey;
    }
}