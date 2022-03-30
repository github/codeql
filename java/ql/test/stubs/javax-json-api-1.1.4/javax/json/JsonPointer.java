// Generated automatically from javax.json.JsonPointer for testing purposes

package javax.json;

import javax.json.JsonStructure;
import javax.json.JsonValue;

public interface JsonPointer
{
    <T extends JsonStructure> T add(T p0, JsonValue p1);
    <T extends JsonStructure> T remove(T p0);
    <T extends JsonStructure> T replace(T p0, JsonValue p1);
    JsonValue getValue(JsonStructure p0);
    boolean containsValue(JsonStructure p0);
}
