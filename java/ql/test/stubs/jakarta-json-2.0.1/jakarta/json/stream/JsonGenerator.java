// Generated automatically from jakarta.json.stream.JsonGenerator for testing purposes

package jakarta.json.stream;

import jakarta.json.JsonValue;
import java.io.Closeable;
import java.io.Flushable;
import java.math.BigDecimal;
import java.math.BigInteger;

public interface JsonGenerator extends Closeable, Flushable
{
    JsonGenerator write(BigDecimal p0);
    JsonGenerator write(BigInteger p0);
    JsonGenerator write(JsonValue p0);
    JsonGenerator write(String p0);
    JsonGenerator write(String p0, BigDecimal p1);
    JsonGenerator write(String p0, BigInteger p1);
    JsonGenerator write(String p0, JsonValue p1);
    JsonGenerator write(String p0, String p1);
    JsonGenerator write(String p0, boolean p1);
    JsonGenerator write(String p0, double p1);
    JsonGenerator write(String p0, int p1);
    JsonGenerator write(String p0, long p1);
    JsonGenerator write(boolean p0);
    JsonGenerator write(double p0);
    JsonGenerator write(int p0);
    JsonGenerator write(long p0);
    JsonGenerator writeEnd();
    JsonGenerator writeKey(String p0);
    JsonGenerator writeNull();
    JsonGenerator writeNull(String p0);
    JsonGenerator writeStartArray();
    JsonGenerator writeStartArray(String p0);
    JsonGenerator writeStartObject();
    JsonGenerator writeStartObject(String p0);
    static String PRETTY_PRINTING = null;
    void close();
    void flush();
}
