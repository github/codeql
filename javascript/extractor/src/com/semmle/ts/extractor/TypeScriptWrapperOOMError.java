package com.semmle.ts.extractor;

import com.semmle.util.exception.ResourceError;

public class TypeScriptWrapperOOMError extends ResourceError {
    public TypeScriptWrapperOOMError(String message, Throwable throwable) {
        super(message,throwable);
    }
}
