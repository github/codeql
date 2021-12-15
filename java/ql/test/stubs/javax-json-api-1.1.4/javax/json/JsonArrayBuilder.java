// Generated automatically from javax.json.JsonArrayBuilder for testing purposes

package javax.json;

import java.math.BigDecimal;
import java.math.BigInteger;
import javax.json.JsonArray;
import javax.json.JsonObjectBuilder;
import javax.json.JsonValue;

public interface JsonArrayBuilder
{
    JsonArray build();
    JsonArrayBuilder add(BigDecimal p0);
    JsonArrayBuilder add(BigInteger p0);
    JsonArrayBuilder add(JsonArrayBuilder p0);
    JsonArrayBuilder add(JsonObjectBuilder p0);
    JsonArrayBuilder add(JsonValue p0);
    JsonArrayBuilder add(String p0);
    JsonArrayBuilder add(boolean p0);
    JsonArrayBuilder add(double p0);
    JsonArrayBuilder add(int p0);
    JsonArrayBuilder add(long p0);
    JsonArrayBuilder addNull();
    default JsonArrayBuilder add(int p0, BigDecimal p1){ return null; }
    default JsonArrayBuilder add(int p0, BigInteger p1){ return null; }
    default JsonArrayBuilder add(int p0, JsonArrayBuilder p1){ return null; }
    default JsonArrayBuilder add(int p0, JsonObjectBuilder p1){ return null; }
    default JsonArrayBuilder add(int p0, JsonValue p1){ return null; }
    default JsonArrayBuilder add(int p0, String p1){ return null; }
    default JsonArrayBuilder add(int p0, boolean p1){ return null; }
    default JsonArrayBuilder add(int p0, double p1){ return null; }
    default JsonArrayBuilder add(int p0, int p1){ return null; }
    default JsonArrayBuilder add(int p0, long p1){ return null; }
    default JsonArrayBuilder addAll(JsonArrayBuilder p0){ return null; }
    default JsonArrayBuilder addNull(int p0){ return null; }
    default JsonArrayBuilder remove(int p0){ return null; }
    default JsonArrayBuilder set(int p0, BigDecimal p1){ return null; }
    default JsonArrayBuilder set(int p0, BigInteger p1){ return null; }
    default JsonArrayBuilder set(int p0, JsonArrayBuilder p1){ return null; }
    default JsonArrayBuilder set(int p0, JsonObjectBuilder p1){ return null; }
    default JsonArrayBuilder set(int p0, JsonValue p1){ return null; }
    default JsonArrayBuilder set(int p0, String p1){ return null; }
    default JsonArrayBuilder set(int p0, boolean p1){ return null; }
    default JsonArrayBuilder set(int p0, double p1){ return null; }
    default JsonArrayBuilder set(int p0, int p1){ return null; }
    default JsonArrayBuilder set(int p0, long p1){ return null; }
    default JsonArrayBuilder setNull(int p0){ return null; }
}
