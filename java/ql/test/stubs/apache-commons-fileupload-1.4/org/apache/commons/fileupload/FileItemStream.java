package org.apache.commons.fileupload;

import java.io.InputStream;
import org.apache.commons.fileupload.FileItemHeadersSupport;


public interface FileItemStream extends FileItemHeadersSupport 
{
    InputStream openStream() throws java.io.IOException;
    String getContentType();
    String getName();
    String getFieldName();
    boolean isFormField();
}