// Generated automatically from javax.json.JsonValue for testing purposes

package javax.json;

import javax.json.JsonArray;
import javax.json.JsonObject;

public interface JsonValue
{
    JsonValue.ValueType getValueType();
    String toString();
    default JsonArray asJsonArray(){ return null; }
    default JsonObject asJsonObject(){ return null; }
    static JsonArray EMPTY_JSON_ARRAY = null;
    static JsonObject EMPTY_JSON_OBJECT = null;
    static JsonValue FALSE = null;
    static JsonValue NULL = null;
    static JsonValue TRUE = null;
    static public enum ValueType
    {
        ARRAY, FALSE, NULL, NUMBER, OBJECT, STRING, TRUE;
        private ValueType() {}
    }
}
