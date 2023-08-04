// Generated automatically from io.netty.handler.codec.http.multipart.FileUpload for testing purposes

package io.netty.handler.codec.http.multipart;

import io.netty.buffer.ByteBuf;
import io.netty.handler.codec.http.multipart.HttpData;

public interface FileUpload extends HttpData
{
    FileUpload copy();
    FileUpload duplicate();
    FileUpload replace(ByteBuf p0);
    FileUpload retain();
    FileUpload retain(int p0);
    FileUpload retainedDuplicate();
    FileUpload touch();
    FileUpload touch(Object p0);
    String getContentTransferEncoding();
    String getContentType();
    String getFilename();
    void setContentTransferEncoding(String p0);
    void setContentType(String p0);
    void setFilename(String p0);
}
