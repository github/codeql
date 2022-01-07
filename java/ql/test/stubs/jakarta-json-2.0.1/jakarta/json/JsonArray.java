// Generated automatically from jakarta.json.JsonArray for testing purposes

package jakarta.json;

import jakarta.json.JsonNumber;
import jakarta.json.JsonObject;
import jakarta.json.JsonString;
import jakarta.json.JsonStructure;
import jakarta.json.JsonValue;
import java.util.List;
import java.util.function.Function;

public interface JsonArray extends JsonStructure, List<JsonValue>
{
    <T extends JsonValue> List<T> getValuesAs(Class<T> p0);
    JsonArray getJsonArray(int p0);
    JsonNumber getJsonNumber(int p0);
    JsonObject getJsonObject(int p0);
    JsonString getJsonString(int p0);
    String getString(int p0);
    String getString(int p0, String p1);
    boolean getBoolean(int p0);
    boolean getBoolean(int p0, boolean p1);
    boolean isNull(int p0);
    default <T, K extends JsonValue> List<T> getValuesAs(Function<K, T> p0){ return null; }
    int getInt(int p0);
    int getInt(int p0, int p1);
}
