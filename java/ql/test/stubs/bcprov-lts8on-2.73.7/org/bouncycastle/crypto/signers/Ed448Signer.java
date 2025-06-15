package org.bouncycastle.crypto.signers;

import org.bouncycastle.crypto.params.Ed448PrivateKeyParameters;
import org.bouncycastle.crypto.params.Ed448PublicKeyParameters;

public class Ed448Signer {
    public Ed448Signer(byte[] context) { }
    
    public void init(boolean forSigning, Object keyParameter) { }
    
    public void update(byte[] message, int offset, int length) { }
    
    public byte[] generateSignature() {
        return new byte[114];
    }
    
    public boolean verifySignature(byte[] signature) {
        return true;
    }
}