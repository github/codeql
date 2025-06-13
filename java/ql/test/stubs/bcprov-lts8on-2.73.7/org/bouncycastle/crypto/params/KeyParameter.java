package org.bouncycastle.crypto.params;

public class KeyParameter {
    private final byte[] key;
    
    public KeyParameter(byte[] key) {
        this.key = key.clone();
    }
    
    public byte[] getKey() {
        return key.clone();
    }
}
