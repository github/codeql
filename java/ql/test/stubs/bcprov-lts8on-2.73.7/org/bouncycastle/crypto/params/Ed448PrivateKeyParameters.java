package org.bouncycastle.crypto.params;

import java.security.SecureRandom;

public class Ed448PrivateKeyParameters {
    
    public Ed448PrivateKeyParameters(SecureRandom random) { }
    
    public Ed448PrivateKeyParameters(byte[] privateKey) { }
    
    public Ed448PublicKeyParameters generatePublicKey() {
        return new Ed448PublicKeyParameters(new byte[57]); // Ed448 public keys are 57 bytes
    }
    
    public byte[] getEncoded() {
        return new byte[57]; // Ed448 private keys are also 57 bytes
    }
}