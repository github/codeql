// Generated automatically from jakarta.json.stream.JsonGeneratorFactory for testing purposes

package jakarta.json.stream;

import jakarta.json.stream.JsonGenerator;
import java.io.OutputStream;
import java.io.Writer;
import java.nio.charset.Charset;
import java.util.Map;

public interface JsonGeneratorFactory
{
    JsonGenerator createGenerator(OutputStream p0);
    JsonGenerator createGenerator(OutputStream p0, Charset p1);
    JsonGenerator createGenerator(Writer p0);
    Map<String, ? extends Object> getConfigInUse();
}
