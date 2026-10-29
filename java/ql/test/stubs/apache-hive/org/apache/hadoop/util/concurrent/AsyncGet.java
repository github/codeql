// Generated automatically from org.apache.hadoop.util.concurrent.AsyncGet for testing purposes

package org.apache.hadoop.util.concurrent;

import java.util.concurrent.TimeUnit;

public interface AsyncGet<R, E extends Throwable>
{
    R get(long p0, TimeUnit p1);
    boolean isDone();
}
