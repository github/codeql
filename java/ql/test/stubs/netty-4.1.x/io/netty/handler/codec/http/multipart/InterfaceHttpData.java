// Generated automatically from io.netty.handler.codec.http.multipart.InterfaceHttpData for testing purposes

package io.netty.handler.codec.http.multipart;

import io.netty.util.ReferenceCounted;

public interface InterfaceHttpData extends Comparable<InterfaceHttpData>, ReferenceCounted
{
    InterfaceHttpData retain();
    InterfaceHttpData retain(int p0);
    InterfaceHttpData touch();
    InterfaceHttpData touch(Object p0);
    InterfaceHttpData.HttpDataType getHttpDataType();
    String getName();
    static public enum HttpDataType
    {
        Attribute, FileUpload, InternalAttribute;
        private HttpDataType() {}
    }
}
