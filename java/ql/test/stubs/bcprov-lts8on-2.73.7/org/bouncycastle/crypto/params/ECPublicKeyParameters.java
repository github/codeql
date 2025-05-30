package org.bouncycastle.crypto.params;

public class ECPublicKeyParameters {
    private final Object q;
    private final ECDomainParameters parameters;

    public ECPublicKeyParameters(Object q, ECDomainParameters parameters) {
        this.q = q;
        this.parameters = parameters;
    }

    public Object getQ() {
        return q;
    }

    public ECDomainParameters getParameters() {
        return parameters;
    }
}
