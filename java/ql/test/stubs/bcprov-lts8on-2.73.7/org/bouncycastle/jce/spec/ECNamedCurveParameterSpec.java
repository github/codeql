package org.bouncycastle.jce.spec;

import java.math.BigInteger;

public class ECNamedCurveParameterSpec {
    private final String name;
    private final Object curve;
    private final Object g;
    private final BigInteger n;
    private final BigInteger h;

    public ECNamedCurveParameterSpec(String name, Object curve, Object g, BigInteger n, BigInteger h) {
        this.name = name;
        this.curve = curve;
        this.g = g;
        this.n = n;
        this.h = h;
    }

    public String getName() {
        return name;
    }

    public Object getCurve() {
        return curve;
    }

    public Object getG() {
        return g;
    }

    public BigInteger getN() {
        return n;
    }

    public BigInteger getH() {
        return h;
    }
}
