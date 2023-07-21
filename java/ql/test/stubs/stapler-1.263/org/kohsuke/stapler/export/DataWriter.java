// Generated automatically from org.kohsuke.stapler.export.DataWriter for testing purposes

package org.kohsuke.stapler.export;

import java.lang.reflect.Type;
import org.kohsuke.stapler.export.ExportConfig;

public interface DataWriter
{
    default ExportConfig getExportConfig(){ return null; }
    default void type(Type p0, Class p1){}
    static String CLASS_PROPERTY_NAME = null;
    void endArray();
    void endObject();
    void name(String p0);
    void startArray();
    void startObject();
    void value(String p0);
    void valueNull();
    void valuePrimitive(Object p0);
}
