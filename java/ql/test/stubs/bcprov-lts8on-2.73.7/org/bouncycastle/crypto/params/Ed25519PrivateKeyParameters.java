package org.bouncycastle.crypto.params;

import java.security.SecureRandom;

public class Ed25519PrivateKeyParameters {

    public Ed25519PrivateKeyParameters(SecureRandom random) { }

    public Ed25519PrivateKeyParameters(byte[] privateKey) { }

    public Ed25519PublicKeyParameters generatePublicKey() {
        return new Ed25519PublicKeyParameters(new byte[32]);
    }

    public byte[] getEncoded() {
        return new byte[32];
    }
}