package org.bouncycastle.jcajce.provider.asymmetric.ec;

import java.security.interfaces.ECPrivateKey;
import java.math.BigInteger;

public class BCECPrivateKey implements ECPrivateKey {
    private final BigInteger d;

    public BCECPrivateKey(BigInteger d) {
        this.d = d;
    }

    public BigInteger getD() {
        return d;
    }

    @Override
    public String getAlgorithm() {
        return "EC";
    }

    @Override
    public String getFormat() {
        return "PKCS#8";
    }

    @Override
    public byte[] getEncoded() {
        return new byte[0];
    }

    @Override
    public java.security.spec.ECParameterSpec getParams() {
        return null;
    }

    @Override
    public BigInteger getS() {
        return d;
    }
}
