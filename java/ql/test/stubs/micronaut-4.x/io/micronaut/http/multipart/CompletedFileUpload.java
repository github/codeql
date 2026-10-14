package io.micronaut.http.multipart;

import java.io.IOException;
import java.io.InputStream;
import java.util.Optional;
import io.micronaut.http.MediaType;

public interface CompletedFileUpload {
    String getFilename();
    byte[] getBytes() throws IOException;
    InputStream getInputStream() throws IOException;
    long getSize();
    Optional<MediaType> getContentType();
}
