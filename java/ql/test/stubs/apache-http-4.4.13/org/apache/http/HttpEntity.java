// Generated automatically from org.apache.http.HttpEntity for testing purposes

package org.apache.http;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public interface HttpEntity
{
    Header getContentEncoding();
    Header getContentType();
    InputStream getContent() throws IOException, IllegalStateException;
    boolean isChunked();
    boolean isRepeatable();
    boolean isStreaming();
    long getContentLength();
    void consumeContent() throws IOException;
    void writeTo(OutputStream outstream) throws IOException;
}
