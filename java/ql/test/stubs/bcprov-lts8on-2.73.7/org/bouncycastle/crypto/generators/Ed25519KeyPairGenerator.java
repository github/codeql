package org.bouncycastle.crypto.generators;

import org.bouncycastle.crypto.AsymmetricCipherKeyPair;
import org.bouncycastle.crypto.params.Ed25519KeyGenerationParameters;
import org.bouncycastle.crypto.params.Ed25519PrivateKeyParameters;
import org.bouncycastle.crypto.params.Ed25519PublicKeyParameters;

public class Ed25519KeyPairGenerator {
    private Ed25519KeyGenerationParameters parameters;

    public void init(Ed25519KeyGenerationParameters parameters) {
        this.parameters = parameters;
    }

    public AsymmetricCipherKeyPair generateKeyPair() {
        Ed25519PrivateKeyParameters privateKey = new Ed25519PrivateKeyParameters(parameters.getRandom());
        Ed25519PublicKeyParameters publicKey = privateKey.generatePublicKey();
        return new AsymmetricCipherKeyPair(publicKey, privateKey);
    }
}