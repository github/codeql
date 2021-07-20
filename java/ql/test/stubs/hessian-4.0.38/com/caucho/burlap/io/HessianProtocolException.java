package com.caucho.hessian.io;

import java.io.IOException;

public class HessianProtocolException extends IOException {

    public HessianProtocolException() {
    }

    public HessianProtocolException(String message) { }

    public HessianProtocolException(String message, Throwable rootCause) { }

    public HessianProtocolException(Throwable rootCause) { }

    public Throwable getRootCause() {
        return null;
    }

    public Throwable getCause() {
        return null;
    }
}

