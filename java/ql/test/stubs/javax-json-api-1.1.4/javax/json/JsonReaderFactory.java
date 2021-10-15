// Generated automatically from javax.json.JsonReaderFactory for testing purposes

package javax.json;

import java.io.InputStream;
import java.io.Reader;
import java.nio.charset.Charset;
import java.util.Map;
import javax.json.JsonReader;

public interface JsonReaderFactory
{
    JsonReader createReader(InputStream p0);
    JsonReader createReader(InputStream p0, Charset p1);
    JsonReader createReader(Reader p0);
    Map<String, ? extends Object> getConfigInUse();
}
