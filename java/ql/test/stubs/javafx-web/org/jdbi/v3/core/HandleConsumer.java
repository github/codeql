// Generated automatically from org.jdbi.v3.core.HandleConsumer for testing purposes

package org.jdbi.v3.core;

import org.jdbi.v3.core.Handle;
import org.jdbi.v3.core.HandleCallback;

public interface HandleConsumer<X extends Exception>
{
    default HandleCallback<Void, X> asCallback(){ return null; }
    void useHandle(Handle p0);
}
