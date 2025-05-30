package org.bouncycastle.asn1.sec;

import org.bouncycastle.asn1.x9.X9ECParameters;

public class SECNamedCurves {
    public static X9ECParameters getByName(String name) {
        return new X9ECParameters();
    }

    public static String getName(Object oid) {
        return "secp256r1";
    }
}
