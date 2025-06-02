package org.bouncycastle.math.ec;

import java.math.BigInteger;

public class ECCurve {
    public ECCurve() { }

    public ECPoint createPoint(BigInteger x, BigInteger y) {
        return new ECPoint();
    }

    public ECPoint getInfinity() {
        return new ECPoint();
    }

    public int getFieldSize() {
        return 256;
    }
}
