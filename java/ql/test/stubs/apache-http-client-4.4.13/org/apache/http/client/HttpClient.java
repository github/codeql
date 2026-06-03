// Generated automatically from org.apache.http.client.HttpClient for testing purposes

package org.apache.http.client;

import java.io.IOException;
import org.apache.http.HttpHost;
import org.apache.http.HttpRequest;
import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.protocol.HttpContext;

public interface HttpClient {
    HttpResponse execute(HttpHost target, HttpRequest request) throws IOException;
    HttpResponse execute(HttpHost target, HttpRequest request, HttpContext context) throws IOException;
    <T> T execute(HttpHost target, HttpRequest request, ResponseHandler<? extends T> responseHandler) throws IOException;
    <T> T execute(HttpHost target, HttpRequest request, ResponseHandler<? extends T> responseHandler, HttpContext context)
            throws IOException;
    HttpResponse execute(HttpUriRequest request) throws IOException;
    HttpResponse execute(HttpUriRequest request, HttpContext context) throws IOException;
    <T> T execute(HttpUriRequest request, ResponseHandler<? extends T> responseHandler) throws IOException;
    <T> T execute(HttpUriRequest request, ResponseHandler<? extends T> responseHandler, HttpContext context)
            throws IOException;
}
