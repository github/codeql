// Generated automatically from org.apache.hc.client5.http.impl.classic.CloseableHttpClient for testing purposes

package org.apache.hc.client5.http.impl.classic;

import org.apache.hc.client5.http.classic.HttpClient;
import org.apache.hc.client5.http.impl.classic.CloseableHttpResponse;
import org.apache.hc.core5.http.ClassicHttpRequest;
import org.apache.hc.core5.http.HttpHost;
import org.apache.hc.core5.http.io.HttpClientResponseHandler;
import org.apache.hc.core5.http.protocol.HttpContext;
import org.apache.hc.core5.io.ModalCloseable;

abstract public class CloseableHttpClient implements HttpClient, ModalCloseable
{
    protected abstract CloseableHttpResponse doExecute(HttpHost p0, ClassicHttpRequest p1, HttpContext p2);
    public <T> T execute(ClassicHttpRequest p0, HttpContext p1, org.apache.hc.core5.http.io.HttpClientResponseHandler<? extends T> p2){ return null; }
    public <T> T execute(ClassicHttpRequest p0, org.apache.hc.core5.http.io.HttpClientResponseHandler<? extends T> p1){ return null; }
    public <T> T execute(HttpHost p0, ClassicHttpRequest p1, HttpContext p2, org.apache.hc.core5.http.io.HttpClientResponseHandler<? extends T> p3){ return null; }
    public <T> T execute(HttpHost p0, ClassicHttpRequest p1, org.apache.hc.core5.http.io.HttpClientResponseHandler<? extends T> p2){ return null; }
    public CloseableHttpClient(){}
    public CloseableHttpResponse execute(ClassicHttpRequest p0){ return null; }
    public CloseableHttpResponse execute(ClassicHttpRequest p0, HttpContext p1){ return null; }
    public CloseableHttpResponse execute(HttpHost p0, ClassicHttpRequest p1){ return null; }
    public CloseableHttpResponse execute(HttpHost p0, ClassicHttpRequest p1, HttpContext p2){ return null; }
}
