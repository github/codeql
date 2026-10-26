// Generated automatically from jakarta.json.stream.JsonParser for testing purposes

package jakarta.json.stream;

import jakarta.json.JsonArray;
import jakarta.json.JsonObject;
import jakarta.json.JsonValue;
import jakarta.json.stream.JsonLocation;
import java.io.Closeable;
import java.math.BigDecimal;
import java.util.Map;
import java.util.stream.Stream;

public interface JsonParser extends Closeable
{
    BigDecimal getBigDecimal();
    JsonLocation getLocation();
    JsonParser.Event next();
    String getString();
    boolean hasNext();
    boolean isIntegralNumber();
    default JsonArray getArray(){ return null; }
    default JsonObject getObject(){ return null; }
    default JsonValue getValue(){ return null; }
    default Stream<JsonValue> getArrayStream(){ return null; }
    default Stream<JsonValue> getValueStream(){ return null; }
    default Stream<Map.Entry<String, JsonValue>> getObjectStream(){ return null; }
    default void skipArray(){}
    default void skipObject(){}
    int getInt();
    long getLong();
    static public enum Event
    {
        END_ARRAY, END_OBJECT, KEY_NAME, START_ARRAY, START_OBJECT, VALUE_FALSE, VALUE_NULL, VALUE_NUMBER, VALUE_STRING, VALUE_TRUE;
        private Event() {}
    }
    void close();
}
