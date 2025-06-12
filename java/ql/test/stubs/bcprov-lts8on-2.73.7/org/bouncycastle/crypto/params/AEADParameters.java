package org.bouncycastle.crypto.params;

public class AEADParameters {
    private final KeyParameter key;
    private final int macSize;
    private final byte[] nonce;
    private final byte[] associatedText;
    
    public AEADParameters(KeyParameter key, int macSize, byte[] nonce) {
        this(key, macSize, nonce, null);
    }
    
    public AEADParameters(KeyParameter key, int macSize, byte[] nonce, byte[] associatedText) {
        this.key = key;
        this.macSize = macSize;
        this.nonce = nonce.clone();
        this.associatedText = associatedText != null ? associatedText.clone() : null;
    }
    
    public KeyParameter getKey() {
        return key;
    }
    
    public int getMacSize() {
        return macSize;
    }
    
    public byte[] getNonce() {
        return nonce.clone();
    }
    
    public byte[] getAssociatedText() {
        return associatedText != null ? associatedText.clone() : null;
    }
}
