package org.bouncycastle.crypto.modes;

public class GCMBlockCipher {
    private Object engine;
    
    public GCMBlockCipher(Object engine) {
        this.engine = engine;
    }
    
    public void init(boolean forEncryption, Object params) { }
    
    public int getOutputSize(int len) {
        return len + 16; // Add space for authentication tag
    }
    
    public int processBytes(byte[] in, int inOff, int len, byte[] out, int outOff) {
        return len;
    }
    
    public int doFinal(byte[] out, int outOff) {
        return 16; // Return authentication tag size
    }
    
    public void reset() { }
    
    public int getBlockSize() {
        return 16;
    }
}
