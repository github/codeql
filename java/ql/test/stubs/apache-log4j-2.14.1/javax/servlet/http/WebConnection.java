// Generated automatically from javax.servlet.http.WebConnection for testing purposes

package javax.servlet.http;

import javax.servlet.ServletInputStream;
import javax.servlet.ServletOutputStream;

public interface WebConnection extends AutoCloseable
{
    ServletInputStream getInputStream();
    ServletOutputStream getOutputStream();
}
