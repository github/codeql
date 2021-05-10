package com.cedarsoftware.util.io;

import java.io.Closeable;
import java.io.InputStream;
import java.util.Map;

public class JsonReader implements Closeable {

    public static Object jsonToJava(String json) {
        return null;
    }

    public static Object jsonToJava(String json, Map<String, Object> optionalArgs) {
        return null;
    }

    public static Object jsonToJava(InputStream inputStream, Map<String, Object> optionalArgs) {
        return null;
    }

    public JsonReader() { }

    public JsonReader(InputStream inp) { }

    public JsonReader(Map<String, Object> optionalArgs) { }

    public JsonReader(InputStream inp, boolean useMaps) { }

    public JsonReader(InputStream inp, Map<String, Object> optionalArgs) { }

    public JsonReader(String inp, Map<String, Object> optionalArgs) { }

    public JsonReader(byte[] inp, Map<String, Object> optionalArgs) { }

    public Object readObject() {
        return null;
    }

    public void close() { }
}

