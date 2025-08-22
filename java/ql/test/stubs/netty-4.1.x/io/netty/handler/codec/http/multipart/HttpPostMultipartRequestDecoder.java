// Generated automatically from io.netty.handler.codec.http.multipart.HttpPostMultipartRequestDecoder for testing purposes

package io.netty.handler.codec.http.multipart;

import io.netty.handler.codec.http.HttpContent;
import io.netty.handler.codec.http.HttpRequest;
import io.netty.handler.codec.http.multipart.HttpDataFactory;
import io.netty.handler.codec.http.multipart.InterfaceHttpData;
import io.netty.handler.codec.http.multipart.InterfaceHttpPostRequestDecoder;
import java.nio.charset.Charset;
import java.util.List;

public class HttpPostMultipartRequestDecoder implements InterfaceHttpPostRequestDecoder
{
    protected HttpPostMultipartRequestDecoder() {}
    protected InterfaceHttpData getFileUpload(String p0){ return null; }
    protected void addHttpData(InterfaceHttpData p0){}
    public HttpPostMultipartRequestDecoder offer(HttpContent p0){ return null; }
    public HttpPostMultipartRequestDecoder(HttpDataFactory p0, HttpRequest p1){}
    public HttpPostMultipartRequestDecoder(HttpDataFactory p0, HttpRequest p1, Charset p2){}
    public HttpPostMultipartRequestDecoder(HttpRequest p0){}
    public InterfaceHttpData currentPartialHttpData(){ return null; }
    public InterfaceHttpData getBodyHttpData(String p0){ return null; }
    public InterfaceHttpData next(){ return null; }
    public List<InterfaceHttpData> getBodyHttpDatas(){ return null; }
    public List<InterfaceHttpData> getBodyHttpDatas(String p0){ return null; }
    public boolean hasNext(){ return false; }
    public boolean isMultipart(){ return false; }
    public int getDiscardThreshold(){ return 0; }
    public void cleanFiles(){}
    public void destroy(){}
    public void removeHttpDataFromClean(InterfaceHttpData p0){}
    public void setDiscardThreshold(int p0){}
}
