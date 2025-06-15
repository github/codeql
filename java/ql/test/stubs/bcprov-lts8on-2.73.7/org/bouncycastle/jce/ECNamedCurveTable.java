package org.bouncycastle.jce;

import org.bouncycastle.jce.spec.ECNamedCurveParameterSpec;

public class ECNamedCurveTable {
    public static ECNamedCurveParameterSpec getParameterSpec(String name) {
        return new ECNamedCurveParameterSpec(name, null, null, null, null);
    }

    public static String[] getNames() {
        return new String[] { "secp256r1", "secp256k1", "secp384r1" };
    }
}
