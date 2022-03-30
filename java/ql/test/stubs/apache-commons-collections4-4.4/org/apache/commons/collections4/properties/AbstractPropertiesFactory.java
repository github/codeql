// Generated automatically from org.apache.commons.collections4.properties.AbstractPropertiesFactory for testing purposes

package org.apache.commons.collections4.properties;

import java.io.File;
import java.io.InputStream;
import java.io.Reader;
import java.net.URI;
import java.net.URL;
import java.nio.file.Path;
import java.util.Properties;

abstract public class AbstractPropertiesFactory<T extends Properties>
{
    protected AbstractPropertiesFactory(){}
    protected abstract T createProperties();
    public T load(ClassLoader p0, String p1){ return null; }
    public T load(File p0){ return null; }
    public T load(InputStream p0){ return null; }
    public T load(Path p0){ return null; }
    public T load(Reader p0){ return null; }
    public T load(String p0){ return null; }
    public T load(URI p0){ return null; }
    public T load(URL p0){ return null; }
}
