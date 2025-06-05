package org.bouncycastle.pqc.crypto.lms;

import java.security.SecureRandom;

public class LMSKeyGenerationParameters {
    private final LMSParameters lmsParameters;
    private final SecureRandom random;

    public LMSKeyGenerationParameters(LMSParameters lmsParameters, SecureRandom random) {
        this.lmsParameters = lmsParameters;
        this.random = random;
    }

    public LMSParameters getLMSParameters() {
        return lmsParameters;
    }

    public SecureRandom getRandom() {
        return random;
    }
}
