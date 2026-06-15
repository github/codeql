// Generated automatically from org.springframework.core.io.PathResource for testing purposes

package org.springframework.core.io;

import java.io.File;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URI;
import java.net.URL;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.WritableByteChannel;
import java.nio.charset.Charset;
import java.nio.file.Path;
import org.springframework.core.io.AbstractResource;
import org.springframework.core.io.Resource;
import org.springframework.core.io.WritableResource;

public class PathResource extends AbstractResource implements WritableResource
{
    protected PathResource() {}
    public File getFile(){ return null; }
    public InputStream getInputStream(){ return null; }
    public OutputStream getOutputStream(){ return null; }
    public PathResource(Path p0){}
    public PathResource(String p0){}
    public PathResource(URI p0){}
    public ReadableByteChannel readableChannel(){ return null; }
    public Resource createRelative(String p0){ return null; }
    public String getContentAsString(Charset p0){ return null; }
    public String getDescription(){ return null; }
    public String getFilename(){ return null; }
    public URI getURI(){ return null; }
    public URL getURL(){ return null; }
    public WritableByteChannel writableChannel(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean exists(){ return false; }
    public boolean isFile(){ return false; }
    public boolean isReadable(){ return false; }
    public boolean isWritable(){ return false; }
    public byte[] getContentAsByteArray(){ return null; }
    public final String getPath(){ return null; }
    public int hashCode(){ return 0; }
    public long contentLength(){ return 0; }
    public long lastModified(){ return 0; }
}
