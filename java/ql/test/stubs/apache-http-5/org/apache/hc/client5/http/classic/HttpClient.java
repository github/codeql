// Generated automatically from org.apache.hc.client5.http.classic.HttpClient for testing purposes

package org.apache.hc.client5.http.classic;

import org.apache.hc.core5.http.ClassicHttpRequest;
import org.apache.hc.core5.http.ClassicHttpResponse;
import org.apache.hc.core5.http.HttpHost;
import org.apache.hc.core5.http.HttpResponse;
import org.apache.hc.core5.http.io.HttpClientResponseHandler;
import org.apache.hc.core5.http.protocol.HttpContext;

public interface HttpClient
{
    <T> T execute(ClassicHttpRequest p0, HttpContext p1, org.apache.hc.core5.http.io.HttpClientResponseHandler<? extends T> p2);
    <T> T execute(ClassicHttpRequest p0, org.apache.hc.core5.http.io.HttpClientResponseHandler<? extends T> p1);
    <T> T execute(HttpHost p0, ClassicHttpRequest p1, HttpContext p2, org.apache.hc.core5.http.io.HttpClientResponseHandler<? extends T> p3);
    <T> T execute(HttpHost p0, ClassicHttpRequest p1, org.apache.hc.core5.http.io.HttpClientResponseHandler<? extends T> p2);
    ClassicHttpResponse execute(HttpHost p0, ClassicHttpRequest p1);
    HttpResponse execute(ClassicHttpRequest p0);
    HttpResponse execute(ClassicHttpRequest p0, HttpContext p1);
    HttpResponse execute(HttpHost p0, ClassicHttpRequest p1, HttpContext p2);
}
