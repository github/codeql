// Generated automatically from com.hubspot.jinjava.lib.filter.Filter for testing purposes

package com.hubspot.jinjava.lib.filter;

import com.hubspot.jinjava.interpret.JinjavaInterpreter;
import com.hubspot.jinjava.lib.Importable;
import com.hubspot.jinjava.objects.SafeString;
import java.util.Map;

public interface Filter extends Importable
{
    Object filter(Object p0, JinjavaInterpreter p1, String... p2);
    default Object filter(Object p0, JinjavaInterpreter p1, Object[] p2, Map<String, Object> p3){ return null; }
    default Object filter(SafeString p0, JinjavaInterpreter p1, String... p2){ return null; }
    default boolean preserveSafeString(){ return false; }
}
