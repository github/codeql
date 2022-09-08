// Generated automatically from org.apache.velocity.app.Velocity for testing purposes

package org.apache.velocity.app;

import java.io.Reader;
import java.io.Writer;
import java.util.Properties;
import org.apache.velocity.Template;
import org.apache.velocity.context.Context;
import org.apache.velocity.runtime.RuntimeConstants;
import org.slf4j.Logger;

public class Velocity implements RuntimeConstants
{
    public Velocity(){}
    public static Logger getLog(){ return null; }
    public static Object getProperty(String p0){ return null; }
    public static Template getTemplate(String p0){ return null; }
    public static Template getTemplate(String p0, String p1){ return null; }
    public static boolean evaluate(Context p0, Writer p1, String p2, Reader p3){ return false; }
    public static boolean evaluate(Context p0, Writer p1, String p2, String p3){ return false; }
    public static boolean invokeVelocimacro(String p0, String p1, String[] p2, Context p3, Writer p4){ return false; }
    public static boolean mergeTemplate(String p0, String p1, Context p2, Writer p3){ return false; }
    public static boolean resourceExists(String p0){ return false; }
    public static void addProperty(String p0, Object p1){}
    public static void clearProperty(String p0){}
    public static void init(){}
    public static void init(Properties p0){}
    public static void init(String p0){}
    public static void reset(){}
    public static void setApplicationAttribute(Object p0, Object p1){}
    public static void setProperties(Properties p0){}
    public static void setProperty(String p0, Object p1){}
    public void loadDirective(String p0){}
    public void removeDirective(String p0){}
}
