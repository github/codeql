// Generated automatically from javax.json.stream.JsonGeneratorFactory for testing purposes

package javax.json.stream;

import java.io.OutputStream;
import java.io.Writer;
import java.nio.charset.Charset;
import java.util.Map;
import javax.json.stream.JsonGenerator;

public interface JsonGeneratorFactory
{
    JsonGenerator createGenerator(OutputStream p0);
    JsonGenerator createGenerator(OutputStream p0, Charset p1);
    JsonGenerator createGenerator(Writer p0);
    Map<String, ? extends Object> getConfigInUse();
}
