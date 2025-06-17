package org.bouncycastle.math.ec;

import java.math.BigInteger;

public class ECPoint {
    public ECPoint() { }

    public ECPoint add(ECPoint other) {
        return new ECPoint();
    }

    public ECPoint multiply(BigInteger k) {
        return new ECPoint();
    }

    public ECPoint negate() {
        return new ECPoint();
    }

    public boolean isInfinity() {
        return false;
    }

    public ECPoint normalize() {
        return this;
    }

    public BigInteger getAffineXCoord() {
        return BigInteger.ZERO;
    }

    public BigInteger getAffineYCoord() {
        return BigInteger.ZERO;
    }
}
