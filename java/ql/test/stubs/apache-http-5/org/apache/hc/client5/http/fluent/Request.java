// Generated automatically from org.apache.hc.client5.http.fluent.Request for testing purposes

package org.apache.hc.client5.http.fluent;

import java.io.File;
import java.io.InputStream;
import java.net.URI;
import java.nio.charset.Charset;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;
import org.apache.hc.client5.http.fluent.Response;
import org.apache.hc.client5.http.impl.classic.CloseableHttpClient;
import org.apache.hc.core5.http.ContentType;
import org.apache.hc.core5.http.Header;
import org.apache.hc.core5.http.HttpEntity;
import org.apache.hc.core5.http.HttpHost;
import org.apache.hc.core5.http.HttpVersion;
import org.apache.hc.core5.http.Method;
import org.apache.hc.core5.http.NameValuePair;
import org.apache.hc.core5.util.Timeout;

public class Request
{
    protected Request() {}
    public Request addHeader(Header p0){ return null; }
    public Request addHeader(String p0, String p1){ return null; }
    public Request body(HttpEntity p0){ return null; }
    public Request bodyByteArray(byte[] p0){ return null; }
    public Request bodyByteArray(byte[] p0, ContentType p1){ return null; }
    public Request bodyByteArray(byte[] p0, int p1, int p2){ return null; }
    public Request bodyByteArray(byte[] p0, int p1, int p2, ContentType p3){ return null; }
    public Request bodyFile(File p0, ContentType p1){ return null; }
    public Request bodyForm(Iterable<? extends NameValuePair> p0){ return null; }
    public Request bodyForm(Iterable<? extends NameValuePair> p0, Charset p1){ return null; }
    public Request bodyForm(NameValuePair... p0){ return null; }
    public Request bodyStream(InputStream p0){ return null; }
    public Request bodyStream(InputStream p0, ContentType p1){ return null; }
    public Request bodyString(String p0, ContentType p1){ return null; }
    public Request connectTimeout(Timeout p0){ return null; }
    public Request removeHeader(Header p0){ return null; }
    public Request removeHeaders(String p0){ return null; }
    public Request responseTimeout(Timeout p0){ return null; }
    public Request setCacheControl(String p0){ return null; }
    public Request setDate(Date p0){ return null; }
    public Request setHeader(Header p0){ return null; }
    public Request setHeader(String p0, String p1){ return null; }
    public Request setHeaders(Header... p0){ return null; }
    public Request setIfModifiedSince(Date p0){ return null; }
    public Request setIfUnmodifiedSince(Date p0){ return null; }
    public Request useExpectContinue(){ return null; }
    public Request userAgent(String p0){ return null; }
    public Request version(HttpVersion p0){ return null; }
    public Request viaProxy(HttpHost p0){ return null; }
    public Request viaProxy(String p0){ return null; }
    public Response execute(){ return null; }
    public Response execute(CloseableHttpClient p0){ return null; }
    public String toString(){ return null; }
    public static Locale DATE_LOCALE = null;
    public static Request create(Method p0, URI p1){ return null; }
    public static Request create(String p0, String p1){ return null; }
    public static Request create(String p0, URI p1){ return null; }
    public static Request delete(String p0){ return null; }
    public static Request delete(URI p0){ return null; }
    public static Request get(String p0){ return null; }
    public static Request get(URI p0){ return null; }
    public static Request head(String p0){ return null; }
    public static Request head(URI p0){ return null; }
    public static Request options(String p0){ return null; }
    public static Request options(URI p0){ return null; }
    public static Request patch(String p0){ return null; }
    public static Request patch(URI p0){ return null; }
    public static Request post(String p0){ return null; }
    public static Request post(URI p0){ return null; }
    public static Request put(String p0){ return null; }
    public static Request put(URI p0){ return null; }
    public static Request trace(String p0){ return null; }
    public static Request trace(URI p0){ return null; }
    public static String DATE_FORMAT = null;
    public static TimeZone TIME_ZONE = null;
}
