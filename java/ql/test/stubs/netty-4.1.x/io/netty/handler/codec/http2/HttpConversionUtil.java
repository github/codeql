// Generated automatically from io.netty.handler.codec.http2.HttpConversionUtil for testing purposes

package io.netty.handler.codec.http2;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.ByteBufAllocator;
import io.netty.handler.codec.http.FullHttpMessage;
import io.netty.handler.codec.http.FullHttpRequest;
import io.netty.handler.codec.http.FullHttpResponse;
import io.netty.handler.codec.http.HttpHeaders;
import io.netty.handler.codec.http.HttpMessage;
import io.netty.handler.codec.http.HttpMethod;
import io.netty.handler.codec.http.HttpRequest;
import io.netty.handler.codec.http.HttpResponse;
import io.netty.handler.codec.http.HttpResponseStatus;
import io.netty.handler.codec.http.HttpVersion;
import io.netty.handler.codec.http2.Http2Headers;

public class HttpConversionUtil
{
    protected HttpConversionUtil() {}
    public static FullHttpRequest toFullHttpRequest(int p0, Http2Headers p1, ByteBuf p2, boolean p3){ return null; }
    public static FullHttpRequest toFullHttpRequest(int p0, Http2Headers p1, ByteBufAllocator p2, boolean p3){ return null; }
    public static FullHttpResponse toFullHttpResponse(int p0, Http2Headers p1, ByteBuf p2, boolean p3){ return null; }
    public static FullHttpResponse toFullHttpResponse(int p0, Http2Headers p1, ByteBufAllocator p2, boolean p3){ return null; }
    public static Http2Headers toHttp2Headers(HttpHeaders p0, boolean p1){ return null; }
    public static Http2Headers toHttp2Headers(HttpMessage p0, boolean p1){ return null; }
    public static HttpMethod OUT_OF_MESSAGE_SEQUENCE_METHOD = null;
    public static HttpRequest toHttpRequest(int p0, Http2Headers p1, boolean p2){ return null; }
    public static HttpResponse toHttpResponse(int p0, Http2Headers p1, boolean p2){ return null; }
    public static HttpResponseStatus OUT_OF_MESSAGE_SEQUENCE_RETURN_CODE = null;
    public static HttpResponseStatus parseStatus(CharSequence p0){ return null; }
    public static String OUT_OF_MESSAGE_SEQUENCE_PATH = null;
    public static void addHttp2ToHttpHeaders(int p0, Http2Headers p1, FullHttpMessage p2, boolean p3){}
    public static void addHttp2ToHttpHeaders(int p0, Http2Headers p1, HttpHeaders p2, HttpVersion p3, boolean p4, boolean p5){}
    public static void toHttp2Headers(HttpHeaders p0, Http2Headers p1){}
}
