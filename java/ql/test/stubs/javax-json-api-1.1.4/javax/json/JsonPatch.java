// Generated automatically from javax.json.JsonPatch for testing purposes

package javax.json;

import javax.json.JsonArray;
import javax.json.JsonStructure;

public interface JsonPatch
{
    <T extends JsonStructure> T apply(T p0);
    JsonArray toJsonArray();
}
