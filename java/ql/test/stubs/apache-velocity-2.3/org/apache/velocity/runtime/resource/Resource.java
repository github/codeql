// Generated automatically from org.apache.velocity.runtime.resource.Resource for testing purposes

package org.apache.velocity.runtime.resource;

import org.apache.velocity.runtime.RuntimeServices;
import org.apache.velocity.runtime.resource.loader.ResourceLoader;
import org.slf4j.Logger;

abstract public class Resource
{
    protected Logger log = null;
    protected Object data = null;
    protected ResourceLoader resourceLoader = null;
    protected RuntimeServices rsvc = null;
    protected String encoding = null;
    protected String name = null;
    protected int type = 0;
    protected long lastModified = 0;
    protected long modificationCheckInterval = 0;
    protected long nextCheck = 0;
    protected static long MILLIS_PER_SECOND = 0;
    public Object getData(){ return null; }
    public Resource(){}
    public ResourceLoader getResourceLoader(){ return null; }
    public String getEncoding(){ return null; }
    public String getName(){ return null; }
    public abstract boolean process();
    public boolean isSourceModified(){ return false; }
    public boolean requiresChecking(){ return false; }
    public int getType(){ return 0; }
    public long getLastModified(){ return 0; }
    public void setData(Object p0){}
    public void setEncoding(String p0){}
    public void setLastModified(long p0){}
    public void setModificationCheckInterval(long p0){}
    public void setName(String p0){}
    public void setResourceLoader(ResourceLoader p0){}
    public void setRuntimeServices(RuntimeServices p0){}
    public void setType(int p0){}
    public void touch(){}
}
