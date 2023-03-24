// Generated automatically from org.apache.velocity.app.event.EventCartridge for testing purposes

package org.apache.velocity.app.event;

import org.apache.velocity.app.event.EventHandler;
import org.apache.velocity.app.event.IncludeEventHandler;
import org.apache.velocity.app.event.InvalidReferenceEventHandler;
import org.apache.velocity.app.event.MethodExceptionEventHandler;
import org.apache.velocity.app.event.ReferenceInsertionEventHandler;
import org.apache.velocity.context.Context;
import org.apache.velocity.context.InternalContextAdapter;
import org.apache.velocity.runtime.RuntimeServices;
import org.apache.velocity.util.introspection.Info;
import org.slf4j.Logger;

public class EventCartridge
{
    protected Logger getLog(){ return null; }
    protected RuntimeServices rsvc = null;
    public EventCartridge(){}
    public Object invalidGetMethod(Context p0, String p1, Object p2, String p3, Info p4){ return null; }
    public Object invalidMethod(Context p0, String p1, Object p2, String p3, Info p4){ return null; }
    public Object methodException(Context p0, Class<? extends Object> p1, String p2, Exception p3, Info p4){ return null; }
    public Object referenceInsert(InternalContextAdapter p0, String p1, Object p2){ return null; }
    public String includeEvent(Context p0, String p1, String p2, String p3){ return null; }
    public boolean addEventHandler(EventHandler p0){ return false; }
    public boolean invalidSetMethod(Context p0, String p1, String p2, Info p3){ return false; }
    public boolean removeEventHandler(EventHandler p0){ return false; }
    public final boolean attachToContext(Context p0){ return false; }
    public void addIncludeEventHandler(IncludeEventHandler p0){}
    public void addInvalidReferenceEventHandler(InvalidReferenceEventHandler p0){}
    public void addMethodExceptionHandler(MethodExceptionEventHandler p0){}
    public void addReferenceInsertionEventHandler(ReferenceInsertionEventHandler p0){}
    public void setRuntimeServices(RuntimeServices p0){}
}
