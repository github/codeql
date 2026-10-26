// Generated automatically from io.netty.handler.codec.http.multipart.HttpData for testing purposes

package io.netty.handler.codec.http.multipart;

import io.netty.buffer.ByteBuf;
import io.netty.buffer.ByteBufHolder;
import io.netty.handler.codec.http.multipart.InterfaceHttpData;
import java.io.File;
import java.io.InputStream;
import java.nio.charset.Charset;

public interface HttpData extends ByteBufHolder, InterfaceHttpData
{
    ByteBuf getByteBuf();
    ByteBuf getChunk(int p0);
    Charset getCharset();
    File getFile();
    HttpData copy();
    HttpData duplicate();
    HttpData replace(ByteBuf p0);
    HttpData retain();
    HttpData retain(int p0);
    HttpData retainedDuplicate();
    HttpData touch();
    HttpData touch(Object p0);
    String getString();
    String getString(Charset p0);
    boolean isCompleted();
    boolean isInMemory();
    boolean renameTo(File p0);
    byte[] get();
    long definedLength();
    long getMaxSize();
    long length();
    void addContent(ByteBuf p0, boolean p1);
    void checkSize(long p0);
    void delete();
    void setCharset(Charset p0);
    void setContent(ByteBuf p0);
    void setContent(File p0);
    void setContent(InputStream p0);
    void setMaxSize(long p0);
}
