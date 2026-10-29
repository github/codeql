package org.lastaflute.web.ruts.multipart;

import java.io.InputStream;
import java.io.IOException;

public interface MultipartFormFile {
    byte[] getFileData() throws IOException;

    InputStream getInputStream() throws IOException;

    String getFileName();

    String getContentType();
}
