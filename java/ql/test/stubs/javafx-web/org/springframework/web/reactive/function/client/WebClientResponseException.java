// Generated automatically from org.springframework.web.reactive.function.client.WebClientResponseException for testing purposes

package org.springframework.web.reactive.function.client;

import java.nio.charset.Charset;
import java.util.function.Function;
import org.springframework.core.ParameterizedTypeReference;
import org.springframework.core.ResolvableType;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpRequest;
import org.springframework.http.HttpStatusCode;
import org.springframework.web.reactive.function.client.WebClientException;

public class WebClientResponseException extends WebClientException
{
    protected WebClientResponseException() {}
    public <E> E getResponseBodyAs(ParameterizedTypeReference<E> p0){ return null; }
    public <E> E getResponseBodyAs(java.lang.Class<E> p0){ return null; }
    public HttpHeaders getHeaders(){ return null; }
    public HttpRequest getRequest(){ return null; }
    public HttpStatusCode getStatusCode(){ return null; }
    public String getResponseBodyAsString(){ return null; }
    public String getResponseBodyAsString(Charset p0){ return null; }
    public String getStatusText(){ return null; }
    public WebClientResponseException(HttpStatusCode p0, String p1, HttpHeaders p2, byte[] p3, Charset p4, HttpRequest p5){}
    public WebClientResponseException(String p0, HttpStatusCode p1, String p2, HttpHeaders p3, byte[] p4, Charset p5, HttpRequest p6){}
    public WebClientResponseException(String p0, int p1, String p2, HttpHeaders p3, byte[] p4, Charset p5){}
    public WebClientResponseException(String p0, int p1, String p2, HttpHeaders p3, byte[] p4, Charset p5, HttpRequest p6){}
    public WebClientResponseException(int p0, String p1, HttpHeaders p2, byte[] p3, Charset p4){}
    public WebClientResponseException(int p0, String p1, HttpHeaders p2, byte[] p3, Charset p4, HttpRequest p5){}
    public byte[] getResponseBodyAsByteArray(){ return null; }
    public int getRawStatusCode(){ return 0; }
    public static WebClientResponseException create(HttpStatusCode p0, String p1, HttpHeaders p2, byte[] p3, Charset p4, HttpRequest p5){ return null; }
    public static WebClientResponseException create(int p0, String p1, HttpHeaders p2, byte[] p3, Charset p4){ return null; }
    public static WebClientResponseException create(int p0, String p1, HttpHeaders p2, byte[] p3, Charset p4, HttpRequest p5){ return null; }
    public void setBodyDecodeFunction(Function<ResolvableType, ? extends Object> p0){}
}
