package org.bouncycastle.pqc.crypto.lms;

public class LMSParameters {
    private final LMSigParameters lmSigParameters;
    private final LMOtsParameters lmOtsParameters;

    public LMSParameters(LMSigParameters lmSigParameters, LMOtsParameters lmOtsParameters) {
        this.lmSigParameters = lmSigParameters;
        this.lmOtsParameters = lmOtsParameters;
    }

    public LMSigParameters getLMSigParameters() {
        return lmSigParameters;
    }

    public LMOtsParameters getLMOtsParameters() {
        return lmOtsParameters;
    }
}
