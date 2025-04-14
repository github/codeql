// Generated automatically from org.springframework.core.io.Resource for testing purposes

package org.springframework.core.io;

import java.io.File;
import java.net.URI;
import java.net.URL;
import java.nio.channels.ReadableByteChannel;
import org.springframework.core.io.InputStreamSource;

public interface Resource extends InputStreamSource
{
    File getFile();
    Resource createRelative(String p0);
    String getDescription();
    String getFilename();
    URI getURI();
    URL getURL();
    boolean exists();
    default ReadableByteChannel readableChannel(){ return null; }
    default boolean isFile(){ return false; }
    default boolean isOpen(){ return false; }
    default boolean isReadable(){ return false; }
    long contentLength();
    long lastModified();
}
