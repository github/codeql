package org.bouncycastle.crypto.engines;

public class AESEngine {
    public AESEngine() { }
    
    public void init(boolean forEncryption, Object params) { }
    
    public int getBlockSize() {
        return 16; // AES block size is 16 bytes
    }
    
    public int processBlock(byte[] in, int inOff, byte[] out, int outOff) {
        return getBlockSize();
    }
    
    public void reset() { }
}
