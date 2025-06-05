package org.bouncycastle.crypto.signers;

import java.math.BigInteger;

public class ECDSASigner {
    private boolean forSigning;
    private Object keyParameter;

    public void init(boolean forSigning, Object keyParameter) {
        this.forSigning = forSigning;
        this.keyParameter = keyParameter;
    }

    public void update(byte[] message, int offset, int length) { }

    public BigInteger[] generateSignature(byte[] message) {
        return new BigInteger[] { BigInteger.ZERO, BigInteger.ZERO };
    }

    public boolean verifySignature(byte[] message, BigInteger r, BigInteger s) {
        return true;
    }
}
