// Generated automatically from jakarta.json.JsonPatchBuilder for testing purposes

package jakarta.json;

import jakarta.json.JsonPatch;
import jakarta.json.JsonValue;

public interface JsonPatchBuilder
{
    JsonPatch build();
    JsonPatchBuilder add(String p0, JsonValue p1);
    JsonPatchBuilder add(String p0, String p1);
    JsonPatchBuilder add(String p0, boolean p1);
    JsonPatchBuilder add(String p0, int p1);
    JsonPatchBuilder copy(String p0, String p1);
    JsonPatchBuilder move(String p0, String p1);
    JsonPatchBuilder remove(String p0);
    JsonPatchBuilder replace(String p0, JsonValue p1);
    JsonPatchBuilder replace(String p0, String p1);
    JsonPatchBuilder replace(String p0, boolean p1);
    JsonPatchBuilder replace(String p0, int p1);
    JsonPatchBuilder test(String p0, JsonValue p1);
    JsonPatchBuilder test(String p0, String p1);
    JsonPatchBuilder test(String p0, boolean p1);
    JsonPatchBuilder test(String p0, int p1);
}
