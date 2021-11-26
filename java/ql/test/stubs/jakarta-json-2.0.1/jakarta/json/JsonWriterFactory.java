// Generated automatically from jakarta.json.JsonWriterFactory for testing purposes

package jakarta.json;

import jakarta.json.JsonWriter;
import java.io.OutputStream;
import java.io.Writer;
import java.nio.charset.Charset;
import java.util.Map;

public interface JsonWriterFactory
{
    JsonWriter createWriter(OutputStream p0);
    JsonWriter createWriter(OutputStream p0, Charset p1);
    JsonWriter createWriter(Writer p0);
    Map<String, ? extends Object> getConfigInUse();
}
