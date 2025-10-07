// Generated automatically from org.springframework.core.io.UrlResource for testing purposes

package org.springframework.core.io;

import java.io.File;
import java.io.InputStream;
import java.net.URI;
import java.net.URL;
import java.net.URLConnection;
import org.springframework.core.io.AbstractFileResolvingResource;
import org.springframework.core.io.Resource;

public class UrlResource extends AbstractFileResolvingResource
{
    protected UrlResource() {}
    protected URL createRelativeURL(String p0){ return null; }
    protected void customizeConnection(URLConnection p0){}
    public File getFile(){ return null; }
    public InputStream getInputStream(){ return null; }
    public Resource createRelative(String p0){ return null; }
    public String getDescription(){ return null; }
    public String getFilename(){ return null; }
    public URI getURI(){ return null; }
    public URL getURL(){ return null; }
    public UrlResource(String p0){}
    public UrlResource(String p0, String p1){}
    public UrlResource(String p0, String p1, String p2){}
    public UrlResource(URI p0){}
    public UrlResource(URL p0){}
    public boolean equals(Object p0){ return false; }
    public boolean isFile(){ return false; }
    public int hashCode(){ return 0; }
    public static UrlResource from(String p0){ return null; }
    public static UrlResource from(URI p0){ return null; }
}
