package org.bouncycastle.pqc.crypto.lms;

public class LMSSigner {
    private boolean forSigning;
    private Object keyParameter;

    public void init(boolean forSigning, Object keyParameter) {
        this.forSigning = forSigning;
        this.keyParameter = keyParameter;
    }

    public byte[] generateSignature(byte[] message) {
        return new byte[64]; 
    }

    public boolean verifySignature(byte[] message, byte[] signature) {
        return true; 
    }
}
