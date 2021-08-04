// Generated automatically from javax.json.JsonReader for testing purposes

package javax.json;

import java.io.Closeable;
import javax.json.JsonArray;
import javax.json.JsonObject;
import javax.json.JsonStructure;
import javax.json.JsonValue;

public interface JsonReader extends Closeable
{
    JsonArray readArray();
    JsonObject readObject();
    JsonStructure read();
    default JsonValue readValue(){ return null; }
    void close();
}
