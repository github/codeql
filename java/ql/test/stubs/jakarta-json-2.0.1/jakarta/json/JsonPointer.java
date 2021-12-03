// Generated automatically from jakarta.json.JsonPointer for testing purposes

package jakarta.json;

import jakarta.json.JsonStructure;
import jakarta.json.JsonValue;

public interface JsonPointer
{
    <T extends JsonStructure> T add(T p0, JsonValue p1);
    <T extends JsonStructure> T remove(T p0);
    <T extends JsonStructure> T replace(T p0, JsonValue p1);
    JsonValue getValue(JsonStructure p0);
    String toString();
    boolean containsValue(JsonStructure p0);
}
