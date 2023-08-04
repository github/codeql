// Generated automatically from org.apache.hc.core5.http.HttpEntity for testing purposes

package org.apache.hc.core5.http;

import java.io.Closeable;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;
import org.apache.hc.core5.function.Supplier;
import org.apache.hc.core5.http.EntityDetails;
import org.apache.hc.core5.http.Header;

public interface HttpEntity extends Closeable, EntityDetails
{
    InputStream getContent() throws IOException, UnsupportedOperationException;
    Supplier<List<? extends Header>> getTrailers();
    boolean isRepeatable();
    boolean isStreaming();
    void writeTo(OutputStream p0) throws IOException;
}
