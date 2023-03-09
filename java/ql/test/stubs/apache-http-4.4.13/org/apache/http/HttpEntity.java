// Generated automatically from org.apache.http.HttpEntity for testing purposes

package org.apache.http;

import java.io.InputStream;
import java.io.OutputStream;
import org.apache.http.Header;

public interface HttpEntity
{
    Header getContentEncoding();
    Header getContentType();
    InputStream getContent();
    boolean isChunked();
    boolean isRepeatable();
    boolean isStreaming();
    long getContentLength();
    void consumeContent();
    void writeTo(OutputStream p0);
}
