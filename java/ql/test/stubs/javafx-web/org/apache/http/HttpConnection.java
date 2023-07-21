// Generated automatically from org.apache.http.HttpConnection for testing purposes

package org.apache.http;

import java.io.Closeable;
import org.apache.http.HttpConnectionMetrics;

public interface HttpConnection extends Closeable
{
    HttpConnectionMetrics getMetrics();
    boolean isOpen();
    boolean isStale();
    int getSocketTimeout();
    void close();
    void setSocketTimeout(int p0);
    void shutdown();
}
