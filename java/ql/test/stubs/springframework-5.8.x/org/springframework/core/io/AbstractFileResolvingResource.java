// Generated automatically from org.springframework.core.io.AbstractFileResolvingResource for testing purposes

package org.springframework.core.io;

import java.io.File;
import java.net.HttpURLConnection;
import java.net.URI;
import java.net.URLConnection;
import java.nio.channels.ReadableByteChannel;
import org.springframework.core.io.AbstractResource;

abstract public class AbstractFileResolvingResource extends AbstractResource
{
    protected File getFile(URI p0){ return null; }
    protected File getFileForLastModifiedCheck(){ return null; }
    protected boolean isFile(URI p0){ return false; }
    protected void customizeConnection(HttpURLConnection p0){}
    protected void customizeConnection(URLConnection p0){}
    public AbstractFileResolvingResource(){}
    public File getFile(){ return null; }
    public ReadableByteChannel readableChannel(){ return null; }
    public boolean exists(){ return false; }
    public boolean isFile(){ return false; }
    public boolean isReadable(){ return false; }
    public long contentLength(){ return 0; }
    public long lastModified(){ return 0; }
}
