// Generated automatically from org.apache.logging.log4j.spi.ReadOnlyThreadContextMap for testing purposes

package org.apache.logging.log4j.spi;

import java.util.Map;
import org.apache.logging.log4j.util.StringMap;

public interface ReadOnlyThreadContextMap
{
    Map<String, String> getCopy();
    Map<String, String> getImmutableMapOrNull();
    String get(String p0);
    StringMap getReadOnlyContextData();
    boolean containsKey(String p0);
    boolean isEmpty();
    void clear();
}
