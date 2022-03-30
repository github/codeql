// Generated automatically from javax.json.JsonBuilderFactory for testing purposes

package javax.json;

import java.util.Collection;
import java.util.Map;
import javax.json.JsonArray;
import javax.json.JsonArrayBuilder;
import javax.json.JsonObject;
import javax.json.JsonObjectBuilder;

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
