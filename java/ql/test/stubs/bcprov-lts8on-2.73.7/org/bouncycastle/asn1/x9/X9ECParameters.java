package org.bouncycastle.asn1.x9;

import java.math.BigInteger;

public class X9ECParameters {
    public X9ECParameters() { }

    public Object getCurve() {
        return new Object();
    }

    public Object getG() {
        return new Object();
    }

    public BigInteger getN() {
        return BigInteger.ZERO;
    }

    public BigInteger getH() {
        return BigInteger.ONE;
    }

    public byte[] getSeed() {
        return new byte[0];
    }
}
