package org.bouncycastle.crypto.paddings;

public class PKCS7Padding {
    public PKCS7Padding() { }
    
    public void init(Object random) { }
    
    public String getPaddingName() {
        return "PKCS7";
    }
    
    public int addPadding(byte[] in, int inOff) {
        return 0; // Dummy implementation
    }
    
    public int padCount(byte[] in) {
        return 0; // Dummy implementation
    }
}
