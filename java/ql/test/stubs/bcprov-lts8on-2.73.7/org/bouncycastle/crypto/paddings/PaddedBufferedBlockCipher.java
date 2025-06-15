package org.bouncycastle.crypto.paddings;

public class PaddedBufferedBlockCipher {
    private Object cipher;
    private Object padding;
    
    public PaddedBufferedBlockCipher(Object cipher) {
        this.cipher = cipher;
        this.padding = new PKCS7Padding();
    }
    
    public PaddedBufferedBlockCipher(Object cipher, Object padding) {
        this.cipher = cipher;
        this.padding = padding;
    }
    
    public void init(boolean forEncryption, Object params) { }
    
    public int getBlockSize() {
        return 16;
    }
    
    public int getUpdateOutputSize(int len) {
        return len + getBlockSize();
    }
    
    public int getOutputSize(int len) {
        return len + getBlockSize();
    }
    
    public int processBytes(byte[] in, int inOff, int len, byte[] out, int outOff) {
        return len;
    }
    
    public int doFinal(byte[] out, int outOff) {
        return getBlockSize();
    }
    
    public void reset() { }
}
