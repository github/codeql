// Generated automatically from jakarta.json.JsonBuilderFactory for testing purposes

package jakarta.json;

import jakarta.json.JsonArray;
import jakarta.json.JsonArrayBuilder;
import jakarta.json.JsonObject;
import jakarta.json.JsonObjectBuilder;
import java.util.Collection;
import java.util.Map;

public interface JsonBuilderFactory
{
    JsonArrayBuilder createArrayBuilder();
    JsonObjectBuilder createObjectBuilder();
    Map<String, ? extends Object> getConfigInUse();
    default JsonArrayBuilder createArrayBuilder(Collection<? extends Object> p0){ return null; }
    default JsonArrayBuilder createArrayBuilder(JsonArray p0){ return null; }
    default JsonObjectBuilder createObjectBuilder(JsonObject p0){ return null; }
    default JsonObjectBuilder createObjectBuilder(Map<String, Object> p0){ return null; }
}
