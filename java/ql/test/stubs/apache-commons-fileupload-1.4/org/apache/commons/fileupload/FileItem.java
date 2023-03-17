// Generated automatically from org.apache.commons.fileupload.FileItem for testing purposes

package org.apache.commons.fileupload;

import java.io.File;
import java.io.InputStream;
import java.io.OutputStream;
import org.apache.commons.fileupload.FileItemHeadersSupport;

public interface FileItem extends FileItemHeadersSupport
{
    InputStream getInputStream();
    OutputStream getOutputStream();
    String getContentType();
    String getFieldName();
    String getName();
    String getString();
    String getString(String p0);
    boolean isFormField();
    boolean isInMemory();
    byte[] get();
    long getSize();
    void delete();
    void setFieldName(String p0);
    void setFormField(boolean p0);
    void write(File p0);
}
