// Generated automatically from jakarta.json.JsonReader for testing purposes

package jakarta.json;

import jakarta.json.JsonArray;
import jakarta.json.JsonObject;
import jakarta.json.JsonStructure;
import jakarta.json.JsonValue;
import java.io.Closeable;

public interface JsonReader extends Closeable
{
    JsonArray readArray();
    JsonObject readObject();
    JsonStructure read();
    default JsonValue readValue(){ return null; }
    void close();
}
