// Generated automatically from jakarta.json.JsonObject for testing purposes

package jakarta.json;

import jakarta.json.JsonArray;
import jakarta.json.JsonNumber;
import jakarta.json.JsonString;
import jakarta.json.JsonStructure;
import jakarta.json.JsonValue;
import java.util.Map;

public interface JsonObject extends JsonStructure, Map<String, JsonValue>
{
    JsonArray getJsonArray(String p0);
    JsonNumber getJsonNumber(String p0);
    JsonObject getJsonObject(String p0);
    JsonString getJsonString(String p0);
    String getString(String p0);
    String getString(String p0, String p1);
    boolean getBoolean(String p0);
    boolean getBoolean(String p0, boolean p1);
    boolean isNull(String p0);
    int getInt(String p0);
    int getInt(String p0, int p1);
}
