// Generated automatically from io.netty.handler.codec.http.multipart.InterfaceHttpPostRequestDecoder for testing purposes

package io.netty.handler.codec.http.multipart;

import io.netty.handler.codec.http.HttpContent;
import io.netty.handler.codec.http.multipart.InterfaceHttpData;
import java.util.List;

public interface InterfaceHttpPostRequestDecoder
{
    InterfaceHttpData currentPartialHttpData();
    InterfaceHttpData getBodyHttpData(String p0);
    InterfaceHttpData next();
    InterfaceHttpPostRequestDecoder offer(HttpContent p0);
    List<InterfaceHttpData> getBodyHttpDatas();
    List<InterfaceHttpData> getBodyHttpDatas(String p0);
    boolean hasNext();
    boolean isMultipart();
    int getDiscardThreshold();
    void cleanFiles();
    void destroy();
    void removeHttpDataFromClean(InterfaceHttpData p0);
    void setDiscardThreshold(int p0);
}
