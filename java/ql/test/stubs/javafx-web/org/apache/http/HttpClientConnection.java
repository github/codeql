// Generated automatically from org.apache.http.HttpClientConnection for testing purposes

package org.apache.http;

import org.apache.http.HttpConnection;
import org.apache.http.HttpEntityEnclosingRequest;
import org.apache.http.HttpRequest;
import org.apache.http.HttpResponse;

public interface HttpClientConnection extends HttpConnection
{
    HttpResponse receiveResponseHeader();
    boolean isResponseAvailable(int p0);
    void flush();
    void receiveResponseEntity(HttpResponse p0);
    void sendRequestEntity(HttpEntityEnclosingRequest p0);
    void sendRequestHeader(HttpRequest p0);
}
