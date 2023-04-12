// Generated automatically from org.apache.hc.core5.concurrent.CancellableDependency for testing purposes

package org.apache.hc.core5.concurrent;

import org.apache.hc.core5.concurrent.Cancellable;

public interface CancellableDependency extends Cancellable
{
    boolean isCancelled();
    void setDependency(Cancellable p0);
}
