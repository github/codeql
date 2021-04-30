package com.fasterxml.jackson.databind;

import java.io.*;

public class ObjectReader {
    public ObjectReader forType(Class<?> valueType) {
        return null;
    }

    public <T> T readValue(String src) {
        return null;
    }

    public <T> T readValue(String src, Class<T> valueType) throws IOException {
        return null;
    }

    public <T> T readValue(byte[] content) throws IOException {
        return null;
    }

    public <T> T readValue(byte[] content, Class<T> valueType) throws IOException {
        return null;
    }

    public <T> T readValue(File src) throws IOException {
        return null;
    }

    public <T> T readValue(InputStream src) throws IOException {
        return null;
    }

    public <T> T readValue(InputStream src, Class<T> valueType) throws IOException {
        return null;
    }

    public <T> T readValue(Reader src) throws IOException {
        return null;
    }

    public <T> T readValue(Reader src, Class<T> valueType) throws IOException {
        return null;
    }
}