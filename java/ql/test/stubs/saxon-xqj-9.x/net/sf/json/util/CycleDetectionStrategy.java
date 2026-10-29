// Generated automatically from net.sf.json.util.CycleDetectionStrategy for testing purposes

package net.sf.json.util;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

abstract public class CycleDetectionStrategy
{
    public CycleDetectionStrategy(){}
    public abstract JSONArray handleRepeatedReferenceAsArray(Object p0);
    public abstract JSONObject handleRepeatedReferenceAsObject(Object p0);
    public static CycleDetectionStrategy LENIENT = null;
    public static CycleDetectionStrategy NOPROP = null;
    public static CycleDetectionStrategy STRICT = null;
    public static JSONArray IGNORE_PROPERTY_ARR = null;
    public static JSONObject IGNORE_PROPERTY_OBJ = null;
}
