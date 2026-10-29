// Generated automatically from org.apache.velocity.runtime.resource.loader.ResourceLoader for testing purposes

package org.apache.velocity.runtime.resource.loader;

import java.io.InputStream;
import java.io.Reader;
import org.apache.velocity.runtime.RuntimeServices;
import org.apache.velocity.runtime.resource.Resource;
import org.apache.velocity.util.ExtProperties;
import org.slf4j.Logger;

abstract public class ResourceLoader
{
    protected Logger log = null;
    protected Reader buildReader(InputStream p0, String p1){ return null; }
    protected RuntimeServices rsvc = null;
    protected String className = null;
    protected boolean isCachingOn = false;
    protected long modificationCheckInterval = 0;
    public ResourceLoader(){}
    public String getClassName(){ return null; }
    public abstract Reader getResourceReader(String p0, String p1);
    public abstract boolean isSourceModified(Resource p0);
    public abstract long getLastModified(Resource p0);
    public abstract void init(ExtProperties p0);
    public boolean isCachingOn(){ return false; }
    public boolean resourceExists(String p0){ return false; }
    public long getModificationCheckInterval(){ return 0; }
    public void commonInit(RuntimeServices p0, ExtProperties p1){}
    public void setCachingOn(boolean p0){}
    public void setModificationCheckInterval(long p0){}
}
