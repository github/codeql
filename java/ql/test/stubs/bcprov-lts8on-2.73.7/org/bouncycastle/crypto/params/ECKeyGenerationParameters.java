package org.bouncycastle.crypto.params;

import java.security.SecureRandom;

public class ECKeyGenerationParameters {
    private final ECDomainParameters domainParameters;
    private final SecureRandom random;

    public ECKeyGenerationParameters(ECDomainParameters domainParameters, SecureRandom random) {
        this.domainParameters = domainParameters;
        this.random = random;
    }

    public ECDomainParameters getDomainParameters() {
        return domainParameters;
    }

    public SecureRandom getRandom() {
        return random;
    }
}
