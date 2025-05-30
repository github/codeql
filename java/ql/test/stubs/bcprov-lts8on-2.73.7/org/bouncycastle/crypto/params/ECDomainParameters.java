package org.bouncycastle.crypto.params;

import org.bouncycastle.asn1.x9.X9ECParameters;

public class ECDomainParameters {
    private final X9ECParameters parameters;

    public ECDomainParameters(X9ECParameters parameters) {
        this.parameters = parameters;
    }

    public X9ECParameters getParameters() {
        return parameters;
    }
}
