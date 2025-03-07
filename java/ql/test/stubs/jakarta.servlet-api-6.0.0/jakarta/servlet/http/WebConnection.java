// Generated automatically from jakarta.servlet.http.WebConnection for testing purposes

package jakarta.servlet.http;

import jakarta.servlet.ServletInputStream;
import jakarta.servlet.ServletOutputStream;

public interface WebConnection extends AutoCloseable
{
    ServletInputStream getInputStream();
    ServletOutputStream getOutputStream();
}
