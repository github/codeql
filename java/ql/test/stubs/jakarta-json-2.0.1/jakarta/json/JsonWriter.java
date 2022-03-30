// Generated automatically from jakarta.json.JsonWriter for testing purposes

package jakarta.json;

import jakarta.json.JsonArray;
import jakarta.json.JsonObject;
import jakarta.json.JsonStructure;
import jakarta.json.JsonValue;
import java.io.Closeable;

public interface JsonWriter extends Closeable
{
    default void write(JsonValue p0){}
    void close();
    void write(JsonStructure p0);
    void writeArray(JsonArray p0);
    void writeObject(JsonObject p0);
}
