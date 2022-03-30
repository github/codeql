package org.ho.yaml;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.Reader;
import java.util.Iterator;

public class YamlConfig implements YamlOperations, Cloneable {

    public YamlConfig() { }

    public Object load(YamlDecoder var1) {
        return null;
    }

    public Object load(InputStream var1) {
        return null;
    }

    public Object load(Reader var1) {
        return null;
    }

    public Object load(File var1) throws FileNotFoundException {
        return null;
    }

    public Object load(String var1) {
        return null;
    }

    public <T> T loadType(YamlDecoder var1, Class<T> var2) {
        return null;
    }

    public <T> T loadType(InputStream var1, Class<T> var2) {
        return null;
    }

    public <T> T loadType(Reader var1, Class<T> var2) {
        return null;
    }

    public <T> T loadType(File var1, Class<T> var2) throws FileNotFoundException {
        return null;
    }

    public <T> T loadType(String var1, Class<T> var2) {
        return null;
    }

    public YamlStream loadStream(YamlDecoder var1) {
        return null;
    }

    public YamlStream loadStream(Reader var1) {
        return null;
    }

    public YamlStream loadStream(InputStream var1) {
        return null;
    }

    public YamlStream loadStream(File var1) throws FileNotFoundException {
        return null;
    }

    public YamlStream loadStream(String var1) {
        return null;
    }

    public <T> YamlStream<T> loadStreamOfType(YamlDecoder var1, Class<T> var2) {
        return null;
    }

    public <T> YamlStream<T> loadStreamOfType(Reader var1, Class<T> var2) {
        return null;
    }

    public <T> YamlStream<T> loadStreamOfType(InputStream var1, Class<T> var2) {
        return null;
    }

    public <T> YamlStream<T> loadStreamOfType(File var1, Class<T> var2) throws FileNotFoundException {
        return null;
    }

    public <T> YamlStream<T> loadStreamOfType(String var1, Class<T> var2) {
        return null;
    }

    public void dump(Object var1, File var2) throws FileNotFoundException { }

    public void dump(Object var1, File var2, boolean var3) throws FileNotFoundException { }

    public String dump(Object var1) {
        return null;
    }

    public String dump(Object var1, boolean var2) {
        return null;
    }

    public void dump(Object var1, OutputStream var2, boolean var3) { }

    public void dump(Object var1, OutputStream var2) { }

    public void dumpStream(Iterator var1, File var2, boolean var3) throws FileNotFoundException { }

    public void dumpStream(Iterator var1, File var2) throws FileNotFoundException { }

    public String dumpStream(Iterator var1) {
        return null;
    }

    public String dumpStream(Iterator var1, boolean var2) {
        return null;
    }
}

