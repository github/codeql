package org.bouncycastle.crypto.params;

public class Ed448PublicKeyParameters {
    private byte[] publicKey = new byte[57]; // Ed448 public keys are 57 bytes
    
    public Ed448PublicKeyParameters(byte[] publicKey) { }
    
    public byte[] getEncoded() {
        return publicKey;
    }
}