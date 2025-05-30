package org.bouncycastle.crypto.params;

import java.security.SecureRandom;

public class Ed448KeyGenerationParameters {
    private final SecureRandom random;

    public Ed448KeyGenerationParameters(SecureRandom random) {
        this.random = random;
    }

    public SecureRandom getRandom() {
        return random;
    }
}