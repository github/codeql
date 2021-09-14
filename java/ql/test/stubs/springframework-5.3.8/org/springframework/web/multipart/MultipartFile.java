// Generated automatically from org.springframework.web.multipart.MultipartFile for testing purposes

package org.springframework.web.multipart;

import java.io.File;
import java.io.InputStream;
import java.nio.file.Path;
import org.springframework.core.io.InputStreamSource;
import org.springframework.core.io.Resource;

public interface MultipartFile extends InputStreamSource
{
    InputStream getInputStream();
    String getContentType();
    String getName();
    String getOriginalFilename();
    boolean isEmpty();
    byte[] getBytes();
    default Resource getResource(){ return null; }
    default void transferTo(Path p0){}
    long getSize();
    void transferTo(File p0);
}
