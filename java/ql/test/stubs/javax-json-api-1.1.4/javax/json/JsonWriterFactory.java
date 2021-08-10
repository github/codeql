// Generated automatically from javax.json.JsonWriterFactory for testing purposes

package javax.json;

import java.io.OutputStream;
import java.io.Writer;
import java.nio.charset.Charset;
import java.util.Map;
import javax.json.JsonWriter;

public interface JsonWriterFactory
{
    JsonWriter createWriter(OutputStream p0);
    JsonWriter createWriter(OutputStream p0, Charset p1);
    JsonWriter createWriter(Writer p0);
    Map<String, ? extends Object> getConfigInUse();
}
