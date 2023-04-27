// Generated automatically from org.apache.http.client.methods.HttpExecutionAware for testing purposes

package org.apache.http.client.methods;

import org.apache.http.concurrent.Cancellable;

public interface HttpExecutionAware
{
    boolean isAborted();
    void setCancellable(Cancellable p0);
}
