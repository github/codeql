// Generated automatically from org.apache.velocity.app.VelocityEngine for testing purposes

package org.apache.velocity.app;

import java.io.Reader;
import java.io.Writer;
import java.util.Properties;
import org.apache.velocity.Template;
import org.apache.velocity.context.Context;
import org.apache.velocity.runtime.RuntimeConstants;
import org.slf4j.Logger;

public class VelocityEngine implements RuntimeConstants
{
    public Logger getLog(){ return null; }
    public Object getApplicationAttribute(Object p0){ return null; }
    public Object getProperty(String p0){ return null; }
    public Template getTemplate(String p0){ return null; }
    public Template getTemplate(String p0, String p1){ return null; }
    public VelocityEngine(){}
    public VelocityEngine(Properties p0){}
    public VelocityEngine(String p0){}
    public boolean evaluate(Context p0, Writer p1, String p2, Reader p3){ return false; }
    public boolean evaluate(Context p0, Writer p1, String p2, String p3){ return false; }
    public boolean invokeVelocimacro(String p0, String p1, String[] p2, Context p3, Writer p4){ return false; }
    public boolean mergeTemplate(String p0, String p1, Context p2, Writer p3){ return false; }
    public boolean resourceExists(String p0){ return false; }
    public void addProperty(String p0, Object p1){}
    public void clearProperty(String p0){}
    public void init(){}
    public void init(Properties p0){}
    public void init(String p0){}
    public void loadDirective(String p0){}
    public void removeDirective(String p0){}
    public void reset(){}
    public void setApplicationAttribute(Object p0, Object p1){}
    public void setProperties(Properties p0){}
    public void setProperties(String p0){}
    public void setProperty(String p0, Object p1){}
}
