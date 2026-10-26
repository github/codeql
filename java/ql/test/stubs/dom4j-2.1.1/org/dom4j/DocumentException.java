package org.dom4j;

public class DocumentException extends Exception {
    public DocumentException() {
    }

    public DocumentException(String message) {
        super(message);
    }

    public DocumentException(String message, Throwable cause) {
        super(message, cause);
    }

    public DocumentException(Throwable cause) {
        super(cause);
    }

    /** @deprecated */
    @Deprecated
    public Throwable getNestedException() {
        return null;
    }
}
