package org.bouncycastle.crypto.params;

import java.math.BigInteger;

public class ECPrivateKeyParameters {
    private final BigInteger d;
    private final ECDomainParameters parameters;

    public ECPrivateKeyParameters(BigInteger d, ECDomainParameters parameters) {
        this.d = d;
        this.parameters = parameters;
    }

    public BigInteger getD() {
        return d;
    }

    public ECDomainParameters getParameters() {
        return parameters;
    }
}
