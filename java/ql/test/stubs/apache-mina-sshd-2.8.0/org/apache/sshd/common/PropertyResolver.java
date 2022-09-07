// Generated automatically from org.apache.sshd.common.PropertyResolver for testing purposes

package org.apache.sshd.common;

import java.nio.charset.Charset;
import java.util.Map;

public interface PropertyResolver
{
    Map<String, Object> getProperties();
    PropertyResolver getParentPropertyResolver();
    default Boolean getBoolean(String p0){ return null; }
    default Charset getCharset(String p0, Charset p1){ return null; }
    default Integer getInteger(String p0){ return null; }
    default Long getLong(String p0){ return null; }
    default Object getObject(String p0){ return null; }
    default String getString(String p0){ return null; }
    default String getStringProperty(String p0, String p1){ return null; }
    default boolean getBooleanProperty(String p0, boolean p1){ return false; }
    default boolean isEmpty(){ return false; }
    default int getIntProperty(String p0, int p1){ return 0; }
    default long getLongProperty(String p0, long p1){ return 0; }
    static PropertyResolver EMPTY = null;
    static boolean isEmpty(PropertyResolver p0){ return false; }
}
