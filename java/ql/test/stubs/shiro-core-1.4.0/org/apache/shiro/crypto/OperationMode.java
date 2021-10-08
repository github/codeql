
package org.apache.shiro.crypto;

public enum OperationMode {
    CBC,
    CCM,
    CFB,
    CTR,
    EAX,
    ECB,
    GCM,
    NONE,
    OCB,
    OFB,
    PCBC;

    private OperationMode() {
    }
}
