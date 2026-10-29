// Generated automatically from org.apache.htrace.core.HTraceConfiguration for testing purposes

package org.apache.htrace.core;

import java.util.Map;

abstract public class HTraceConfiguration
{
    public HTraceConfiguration(){}
    public abstract String get(String p0);
    public abstract String get(String p0, String p1);
    public boolean getBoolean(String p0, boolean p1){ return false; }
    public int getInt(String p0, int p1){ return 0; }
    public static HTraceConfiguration EMPTY = null;
    public static HTraceConfiguration fromKeyValuePairs(String... p0){ return null; }
    public static HTraceConfiguration fromMap(Map<String, String> p0){ return null; }
}
