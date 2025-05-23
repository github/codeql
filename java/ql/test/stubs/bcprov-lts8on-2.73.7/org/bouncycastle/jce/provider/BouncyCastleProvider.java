package org.bouncycastle.jce.provider;

import java.security.Provider;

public class BouncyCastleProvider extends Provider {
    public BouncyCastleProvider() {
        super("BC", 1.0, "Bouncy Castle Security Provider v2.73.7");
    }
}