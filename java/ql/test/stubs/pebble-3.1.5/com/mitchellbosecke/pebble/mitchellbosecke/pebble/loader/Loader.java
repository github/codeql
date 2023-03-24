// Generated automatically from com.mitchellbosecke.pebble.loader.Loader for testing purposes

package com.mitchellbosecke.pebble.loader;

import java.io.Reader;

public interface Loader<T>
{
    Reader getReader(T p0);
    String resolveRelativePath(String p0, String p1);
    T createCacheKey(String p0);
    boolean resourceExists(String p0);
    void setCharset(String p0);
    void setPrefix(String p0);
    void setSuffix(String p0);
}
