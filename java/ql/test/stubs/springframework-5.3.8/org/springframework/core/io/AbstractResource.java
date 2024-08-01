// Generated automatically from org.springframework.core.io.AbstractResource for testing purposes

package org.springframework.core.io;

import java.io.File;
import java.net.URI;
import java.net.URL;
import java.nio.channels.ReadableByteChannel;
import org.springframework.core.io.Resource;

abstract public class AbstractResource implements Resource
{
    protected File getFileForLastModifiedCheck(){ return null; }
    public AbstractResource(){}
    public File getFile(){ return null; }
    public ReadableByteChannel readableChannel(){ return null; }
    public Resource createRelative(String p0){ return null; }
    public String getFilename(){ return null; }
    public String toString(){ return null; }
    public URI getURI(){ return null; }
    public URL getURL(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean exists(){ return false; }
    public boolean isFile(){ return false; }
    public boolean isOpen(){ return false; }
    public boolean isReadable(){ return false; }
    public int hashCode(){ return 0; }
    public long contentLength(){ return 0; }
    public long lastModified(){ return 0; }
}
