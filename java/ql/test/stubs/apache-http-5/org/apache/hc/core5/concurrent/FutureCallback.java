// Generated automatically from org.apache.hc.core5.concurrent.FutureCallback for testing purposes

package org.apache.hc.core5.concurrent;


public interface FutureCallback<T>
{
    void cancelled();
    void completed(T p0);
    void failed(Exception p0);
}
