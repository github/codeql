// Generated automatically from javax.json.JsonWriter for testing purposes

package javax.json;

import java.io.Closeable;
import javax.json.JsonArray;
import javax.json.JsonObject;
import javax.json.JsonStructure;
import javax.json.JsonValue;

public interface JsonWriter extends Closeable
{
    default void write(JsonValue p0){}
    void close();
    void write(JsonStructure p0);
    void writeArray(JsonArray p0);
    void writeObject(JsonObject p0);
}
