// Generated automatically from org.springframework.core.io.FileUrlResource for testing purposes

package org.springframework.core.io;

import java.io.File;
import java.io.OutputStream;
import java.net.URL;
import java.nio.channels.WritableByteChannel;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.core.io.WritableResource;

public class FileUrlResource extends UrlResource implements WritableResource
{
    protected FileUrlResource() {}
    public File getFile(){ return null; }
    public FileUrlResource(String p0){}
    public FileUrlResource(URL p0){}
    public OutputStream getOutputStream(){ return null; }
    public Resource createRelative(String p0){ return null; }
    public WritableByteChannel writableChannel(){ return null; }
    public boolean isWritable(){ return false; }
}
