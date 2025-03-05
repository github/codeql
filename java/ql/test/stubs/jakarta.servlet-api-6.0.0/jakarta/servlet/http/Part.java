// Generated automatically from jakarta.servlet.http.Part for testing purposes

package jakarta.servlet.http;

import java.io.InputStream;
import java.util.Collection;

public interface Part
{
    Collection<String> getHeaderNames();
    Collection<String> getHeaders(String p0);
    InputStream getInputStream();
    String getContentType();
    String getHeader(String p0);
    String getName();
    String getSubmittedFileName();
    long getSize();
    void delete();
    void write(String p0);
}
