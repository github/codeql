// Generated automatically from org.springframework.util.PropertiesPersister for testing purposes

package org.springframework.util;

import java.io.InputStream;
import java.io.OutputStream;
import java.io.Reader;
import java.io.Writer;
import java.util.Properties;

public interface PropertiesPersister
{
    void load(Properties p0, InputStream p1);
    void load(Properties p0, Reader p1);
    void loadFromXml(Properties p0, InputStream p1);
    void store(Properties p0, OutputStream p1, String p2);
    void store(Properties p0, Writer p1, String p2);
    void storeToXml(Properties p0, OutputStream p1, String p2);
    void storeToXml(Properties p0, OutputStream p1, String p2, String p3);
}
