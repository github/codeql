package org.bouncycastle.asn1.x9;

import java.math.BigInteger;
import org.bouncycastle.math.ec.ECCurve;
import org.bouncycastle.math.ec.ECPoint;

public class X9ECParameters {
    public X9ECParameters() { }

    public ECCurve getCurve() {
        return new ECCurve();
    }

    public ECPoint getG() {
        return new ECPoint();
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
