package org.bouncycastle.jcajce.provider.asymmetric.ec;

import java.security.interfaces.ECPublicKey;
import java.security.spec.ECPoint;

public class BCECPublicKey implements ECPublicKey {
    private final ECPoint w;

    public BCECPublicKey(ECPoint w) {
        this.w = w;
    }

    @Override
    public String getAlgorithm() {
        return "EC";
    }

    @Override
    public String getFormat() {
        return "X.509";
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
    public ECPoint getW() {
        return w;
    }
}
