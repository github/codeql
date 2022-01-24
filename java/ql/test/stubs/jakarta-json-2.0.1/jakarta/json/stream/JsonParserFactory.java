// Generated automatically from jakarta.json.stream.JsonParserFactory for testing purposes

package jakarta.json.stream;

import jakarta.json.JsonArray;
import jakarta.json.JsonObject;
import jakarta.json.stream.JsonParser;
import java.io.InputStream;
import java.io.Reader;
import java.nio.charset.Charset;
import java.util.Map;

public interface JsonParserFactory
{
    JsonParser createParser(InputStream p0);
    JsonParser createParser(InputStream p0, Charset p1);
    JsonParser createParser(JsonArray p0);
    JsonParser createParser(JsonObject p0);
    JsonParser createParser(Reader p0);
    Map<String, ? extends Object> getConfigInUse();
}
