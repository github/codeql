package org.bouncycastle.crypto.signers;

import org.bouncycastle.crypto.params.Ed25519PrivateKeyParameters;
import org.bouncycastle.crypto.params.Ed25519PublicKeyParameters;

public class Ed25519Signer {
    public void init(boolean forSigning, Object keyParameter) { }

    public void update(byte[] message, int offset, int length) { }

    public byte[] generateSignature() {
        return new byte[64];
    }

    public boolean verifySignature(byte[] signature) {
        return true;
    }
}