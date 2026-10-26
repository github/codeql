// Generated automatically from org.springframework.http.client.ClientHttpResponse for testing purposes

package org.springframework.http.client;

import java.io.Closeable;
import org.springframework.http.HttpInputMessage;
import org.springframework.http.HttpStatus;

public interface ClientHttpResponse extends Closeable, HttpInputMessage
{
    HttpStatus getStatusCode();
    String getStatusText();
    int getRawStatusCode();
    void close();
}
