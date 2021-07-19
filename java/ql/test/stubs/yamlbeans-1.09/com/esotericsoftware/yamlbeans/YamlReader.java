package com.esotericsoftware.yamlbeans;


import java.io.Reader;

public class YamlReader {

    public YamlReader(Reader reader) { }

    public YamlReader(Reader reader, YamlConfig config) { }

    public YamlReader(String yaml) { }

    public YamlReader(String yaml, YamlConfig config) { }

    public Object read() throws YamlException {
        return null;
    }

    public <T> T read(Class<T> type) throws YamlException {
        return null;
    }

    public <T> T read(Class<T> type, Class elementType) throws YamlException {
        return null;
    }
}

