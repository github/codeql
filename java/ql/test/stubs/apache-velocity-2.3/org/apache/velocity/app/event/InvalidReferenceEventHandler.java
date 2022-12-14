// Generated automatically from org.apache.velocity.app.event.InvalidReferenceEventHandler for testing purposes

package org.apache.velocity.app.event;

import org.apache.velocity.app.event.EventHandler;
import org.apache.velocity.context.Context;
import org.apache.velocity.util.introspection.Info;

public interface InvalidReferenceEventHandler extends EventHandler
{
    Object invalidGetMethod(Context p0, String p1, Object p2, String p3, Info p4);
    Object invalidMethod(Context p0, String p1, Object p2, String p3, Info p4);
    boolean invalidSetMethod(Context p0, String p1, String p2, Info p3);
}
