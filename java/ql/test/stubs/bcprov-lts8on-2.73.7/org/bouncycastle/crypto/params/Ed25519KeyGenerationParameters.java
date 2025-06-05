package org.bouncycastle.crypto.params;

import java.security.SecureRandom;

public class Ed25519KeyGenerationParameters {
    private final SecureRandom random;

    public Ed25519KeyGenerationParameters(SecureRandom random) {
        this.random = random;
    }

    public SecureRandom getRandom() {
        return random;
    }
}