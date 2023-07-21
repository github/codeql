// Generated automatically from org.apache.http.HttpConnectionMetrics for testing purposes

package org.apache.http;


public interface HttpConnectionMetrics
{
    Object getMetric(String p0);
    long getReceivedBytesCount();
    long getRequestCount();
    long getResponseCount();
    long getSentBytesCount();
    void reset();
}
