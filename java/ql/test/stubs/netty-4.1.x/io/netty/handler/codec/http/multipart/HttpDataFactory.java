// Generated automatically from io.netty.handler.codec.http.multipart.HttpDataFactory for testing purposes

package io.netty.handler.codec.http.multipart;

import io.netty.handler.codec.http.HttpRequest;
import io.netty.handler.codec.http.multipart.Attribute;
import io.netty.handler.codec.http.multipart.FileUpload;
import io.netty.handler.codec.http.multipart.InterfaceHttpData;
import java.nio.charset.Charset;

public interface HttpDataFactory
{
    Attribute createAttribute(HttpRequest p0, String p1);
    Attribute createAttribute(HttpRequest p0, String p1, String p2);
    Attribute createAttribute(HttpRequest p0, String p1, long p2);
    FileUpload createFileUpload(HttpRequest p0, String p1, String p2, String p3, String p4, Charset p5, long p6);
    void cleanAllHttpData();
    void cleanAllHttpDatas();
    void cleanRequestHttpData(HttpRequest p0);
    void cleanRequestHttpDatas(HttpRequest p0);
    void removeHttpDataFromClean(HttpRequest p0, InterfaceHttpData p1);
    void setMaxLimit(long p0);
}
