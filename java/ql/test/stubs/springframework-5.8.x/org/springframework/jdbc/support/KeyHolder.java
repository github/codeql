// Generated automatically from org.springframework.jdbc.support.KeyHolder for testing purposes

package org.springframework.jdbc.support;

import java.util.List;
import java.util.Map;

public interface KeyHolder
{
    <T> T getKeyAs(java.lang.Class<T> p0);
    List<Map<String, Object>> getKeyList();
    Map<String, Object> getKeys();
    Number getKey();
}
