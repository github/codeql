package org.bouncycastle.pqc.crypto.lms;

public class LMSPublicKeyParameters {
    private final byte[] keyData;

    public LMSPublicKeyParameters(byte[] keyData) {
        this.keyData = keyData.clone();
    }

    public byte[] getEncoded() {
        return keyData.clone();
    }
}
