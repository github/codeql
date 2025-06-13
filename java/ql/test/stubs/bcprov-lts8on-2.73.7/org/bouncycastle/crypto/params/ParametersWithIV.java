package org.bouncycastle.crypto.params;

public class ParametersWithIV {
    private final Object parameters;
    private final byte[] iv;
    
    public ParametersWithIV(Object parameters, byte[] iv) {
        this.parameters = parameters;
        this.iv = iv.clone();
    }
    
    public Object getParameters() {
        return parameters;
    }
    
    public byte[] getIV() {
        return iv.clone();
    }
}
