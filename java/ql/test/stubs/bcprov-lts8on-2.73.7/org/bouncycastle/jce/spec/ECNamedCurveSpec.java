package org.bouncycastle.jce.spec;

import java.security.spec.ECParameterSpec;

public class ECNamedCurveSpec extends ECParameterSpec {
    private final String name;

    public ECNamedCurveSpec(String name, Object curve, Object generator, Object order) {
        super(null, null, null, 0);
        this.name = name;
    }

    public String getName() {
        return name;
    }
}
