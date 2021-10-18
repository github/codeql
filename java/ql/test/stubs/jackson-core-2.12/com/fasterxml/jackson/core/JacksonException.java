package com.fasterxml.jackson.core;

public abstract class JacksonException extends java.io.IOException {
    public abstract String getOriginalMessage();

    public abstract Object getProcessor();

}
