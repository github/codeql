package org.bouncycastle.crypto.generators;

import org.bouncycastle.crypto.AsymmetricCipherKeyPair;
import org.bouncycastle.crypto.params.Ed448KeyGenerationParameters;
import org.bouncycastle.crypto.params.Ed448PrivateKeyParameters;
import org.bouncycastle.crypto.params.Ed448PublicKeyParameters;

public class Ed448KeyPairGenerator {
    private Ed448KeyGenerationParameters parameters;

    public void init(Ed448KeyGenerationParameters parameters) {
        this.parameters = parameters;
    }

    public AsymmetricCipherKeyPair generateKeyPair() {
        Ed448PrivateKeyParameters privateKey = new Ed448PrivateKeyParameters(parameters.getRandom());
        Ed448PublicKeyParameters publicKey = privateKey.generatePublicKey();
        return new AsymmetricCipherKeyPair(publicKey, privateKey);
    }
}