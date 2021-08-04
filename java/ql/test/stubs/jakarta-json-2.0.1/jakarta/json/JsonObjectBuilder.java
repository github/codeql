// Generated automatically from jakarta.json.JsonObjectBuilder for testing purposes

package jakarta.json;

import jakarta.json.JsonArrayBuilder;
import jakarta.json.JsonObject;
import jakarta.json.JsonValue;
import java.math.BigDecimal;
import java.math.BigInteger;

public interface JsonObjectBuilder
{
    JsonObject build();
    JsonObjectBuilder add(String p0, BigDecimal p1);
    JsonObjectBuilder add(String p0, BigInteger p1);
    JsonObjectBuilder add(String p0, JsonArrayBuilder p1);
    JsonObjectBuilder add(String p0, JsonObjectBuilder p1);
    JsonObjectBuilder add(String p0, JsonValue p1);
    JsonObjectBuilder add(String p0, String p1);
    JsonObjectBuilder add(String p0, boolean p1);
    JsonObjectBuilder add(String p0, double p1);
    JsonObjectBuilder add(String p0, int p1);
    JsonObjectBuilder add(String p0, long p1);
    JsonObjectBuilder addNull(String p0);
    default JsonObjectBuilder addAll(JsonObjectBuilder p0){ return null; }
    default JsonObjectBuilder remove(String p0){ return null; }
}
