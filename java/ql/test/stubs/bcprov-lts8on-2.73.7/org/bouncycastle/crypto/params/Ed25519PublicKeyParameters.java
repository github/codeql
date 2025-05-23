package org.bouncycastle.crypto.params;

public class Ed25519PublicKeyParameters {
    private byte[] publicKey = new byte[32];

    public Ed25519PublicKeyParameters(byte[] publicKey) { }

    public byte[] getEncoded() {
        return publicKey;
    }
}