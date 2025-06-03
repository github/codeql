package org.bouncycastle.pqc.crypto.lms;

public class LMSPrivateKeyParameters {
    private final byte[] keyData;

    public LMSPrivateKeyParameters(byte[] keyData) {
        this.keyData = keyData.clone();
    }

    public byte[] getEncoded() {
        return keyData.clone();
    }
}
