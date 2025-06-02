package org.bouncycastle.crypto.params;

import org.bouncycastle.asn1.x9.X9ECParameters;
import java.math.BigInteger;

public class ECDomainParameters {
    private final X9ECParameters parameters;
    private final Object curve;
    private final Object g;
    private final BigInteger n;
    private final BigInteger h;

    public ECDomainParameters(X9ECParameters parameters) {
        this.parameters = parameters;
        this.curve = null;
        this.g = null;
        this.n = null;
        this.h = null;
    }

    public ECDomainParameters(Object curve, Object g, BigInteger n, BigInteger h) {
        this.parameters = null;
        this.curve = curve;
        this.g = g;
        this.n = n;
        this.h = h;
    }

    public X9ECParameters getParameters() {
        return parameters;
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
