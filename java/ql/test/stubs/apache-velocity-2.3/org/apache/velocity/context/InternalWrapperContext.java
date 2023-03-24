// Generated automatically from org.apache.velocity.context.InternalWrapperContext for testing purposes

package org.apache.velocity.context;

import org.apache.velocity.context.Context;
import org.apache.velocity.context.InternalContextAdapter;

public interface InternalWrapperContext
{
    Context getInternalUserContext();
    InternalContextAdapter getBaseContext();
    Object get(String p0);
    Object put(String p0, Object p1);
    boolean containsKey(String p0);
}
