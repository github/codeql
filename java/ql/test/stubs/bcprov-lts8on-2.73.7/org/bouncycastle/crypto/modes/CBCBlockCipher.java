package org.bouncycastle.crypto.modes;

public class CBCBlockCipher {
    private Object cipher;
    
    public CBCBlockCipher(Object cipher) {
        this.cipher = cipher;
    }
    
    public void init(boolean forEncryption, Object params) { }
    
    public int getBlockSize() {
        return 16; // AES block size
    }
    
    public int processBlock(byte[] in, int inOff, byte[] out, int outOff) {
        return getBlockSize();
    }
    
    public void reset() { }
}
