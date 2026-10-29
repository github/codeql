package org.apache.shiro.crypto;

public enum PaddingScheme {
    NONE("NoPadding"),
    ISO10126("ISO10126Padding"),
    OAEP("OAEPPadding"),
    OAEPWithMd5AndMgf1("OAEPWithMD5AndMGF1Padding"),
    OAEPWithSha1AndMgf1("OAEPWithSHA-1AndMGF1Padding"),
    OAEPWithSha256AndMgf1("OAEPWithSHA-256AndMGF1Padding"),
    OAEPWithSha384AndMgf1("OAEPWithSHA-384AndMGF1Padding"),
    OAEPWithSha512AndMgf1("OAEPWithSHA-512AndMGF1Padding"),
    PKCS1("PKCS1Padding"),
    PKCS5("PKCS5Padding"),
    SSL3("SSL3Padding");

    private final String transformationName;

    private PaddingScheme(String transformationName) {
        this.transformationName = transformationName;
    }

    public String getTransformationName() {
        return this.transformationName;
    }
}