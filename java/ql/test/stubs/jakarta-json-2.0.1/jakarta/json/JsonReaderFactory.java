// Generated automatically from jakarta.json.JsonReaderFactory for testing purposes

package jakarta.json;

import jakarta.json.JsonReader;
import java.io.InputStream;
import java.io.Reader;
import java.nio.charset.Charset;
import java.util.Map;

public interface JsonReaderFactory
{
    JsonReader createReader(InputStream p0);
    JsonReader createReader(InputStream p0, Charset p1);
    JsonReader createReader(Reader p0);
    Map<String, ? extends Object> getConfigInUse();
}
