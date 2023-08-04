// Generated automatically from io.netty.handler.codec.http.multipart.HttpPostRequestDecoder for testing purposes

package io.netty.handler.codec.http.multipart;

import io.netty.handler.codec.http.HttpContent;
import io.netty.handler.codec.http.HttpRequest;
import io.netty.handler.codec.http.multipart.HttpDataFactory;
import io.netty.handler.codec.http.multipart.InterfaceHttpData;
import io.netty.handler.codec.http.multipart.InterfaceHttpPostRequestDecoder;
import java.nio.charset.Charset;
import java.util.List;

public class HttpPostRequestDecoder implements InterfaceHttpPostRequestDecoder
{
    protected HttpPostRequestDecoder() {}
    protected static String[] getMultipartDataBoundary(String p0){ return null; }
    public HttpPostRequestDecoder(HttpDataFactory p0, HttpRequest p1){}
    public HttpPostRequestDecoder(HttpDataFactory p0, HttpRequest p1, Charset p2){}
    public HttpPostRequestDecoder(HttpRequest p0){}
    public InterfaceHttpData currentPartialHttpData(){ return null; }
    public InterfaceHttpData getBodyHttpData(String p0){ return null; }
    public InterfaceHttpData next(){ return null; }
    public InterfaceHttpPostRequestDecoder offer(HttpContent p0){ return null; }
    public List<InterfaceHttpData> getBodyHttpDatas(){ return null; }
    public List<InterfaceHttpData> getBodyHttpDatas(String p0){ return null; }
    public boolean hasNext(){ return false; }
    public boolean isMultipart(){ return false; }
    public int getDiscardThreshold(){ return 0; }
    public static boolean isMultipart(HttpRequest p0){ return false; }
    public void cleanFiles(){}
    public void destroy(){}
    public void removeHttpDataFromClean(InterfaceHttpData p0){}
    public void setDiscardThreshold(int p0){}
}
