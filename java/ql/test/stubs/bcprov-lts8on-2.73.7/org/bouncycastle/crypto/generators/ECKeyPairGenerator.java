package org.bouncycastle.crypto.generators;

import org.bouncycastle.crypto.AsymmetricCipherKeyPair;
import org.bouncycastle.crypto.params.ECKeyGenerationParameters;

public class ECKeyPairGenerator {
    private ECKeyGenerationParameters parameters;

    public void init(ECKeyGenerationParameters parameters) {
        this.parameters = parameters;
    }

    public AsymmetricCipherKeyPair generateKeyPair() {
        return new AsymmetricCipherKeyPair(null, null);
    }
}
