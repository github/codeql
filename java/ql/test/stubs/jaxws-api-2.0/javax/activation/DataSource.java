package javax.activation;

import java.io.InputStream;
import java.io.OutputStream;

public interface DataSource {
    String getContentType();

    InputStream getInputStream();

    String getName();

    OutputStream getOutputStream();
}
