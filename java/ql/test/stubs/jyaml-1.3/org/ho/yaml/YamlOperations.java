package org.ho.yaml;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.Reader;
import java.util.Iterator;

public interface YamlOperations {
    Object load(InputStream var1);

    Object load(Reader var1);

    Object load(File var1) throws FileNotFoundException;

    Object load(String var1);

    <T> T loadType(InputStream var1, Class<T> var2);

    <T> T loadType(Reader var1, Class<T> var2);

    <T> T loadType(File var1, Class<T> var2) throws FileNotFoundException;

    <T> T loadType(String var1, Class<T> var2);

    YamlStream loadStream(InputStream var1);

    YamlStream loadStream(Reader var1);

    YamlStream loadStream(File var1) throws FileNotFoundException;

    YamlStream loadStream(String var1);

    <T> YamlStream<T> loadStreamOfType(InputStream var1, Class<T> var2);

    <T> YamlStream<T> loadStreamOfType(Reader var1, Class<T> var2);

    <T> YamlStream<T> loadStreamOfType(File var1, Class<T> var2) throws FileNotFoundException;

    <T> YamlStream<T> loadStreamOfType(String var1, Class<T> var2);

    void dump(Object var1, File var2) throws FileNotFoundException;

    void dump(Object var1, File var2, boolean var3) throws FileNotFoundException;

    String dump(Object var1);

    String dump(Object var1, boolean var2);

    void dumpStream(Iterator var1, File var2) throws FileNotFoundException;

    void dumpStream(Iterator var1, File var2, boolean var3) throws FileNotFoundException;

    String dumpStream(Iterator var1);

    String dumpStream(Iterator var1, boolean var2);

    void dump(Object var1, OutputStream var2);

    void dump(Object var1, OutputStream var2, boolean var3);
}

