package org.bouncycastle.pqc.crypto.lms;

import org.bouncycastle.crypto.AsymmetricCipherKeyPair;

public class LMSKeyPairGenerator {
    private LMSKeyGenerationParameters parameters;

    public void init(LMSKeyGenerationParameters parameters) {
        this.parameters = parameters;
    }

    public AsymmetricCipherKeyPair generateKeyPair() {
        byte[] privateKeyData = new byte[32];
        byte[] publicKeyData = new byte[32];
        
        LMSPrivateKeyParameters privateKey = new LMSPrivateKeyParameters(privateKeyData);
        LMSPublicKeyParameters publicKey = new LMSPublicKeyParameters(publicKeyData);
        
        return new AsymmetricCipherKeyPair(publicKey, privateKey);
    }
}
