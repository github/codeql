// Generated automatically from org.apache.hc.core5.pool.ConnPoolControl for testing purposes

package org.apache.hc.core5.pool;

import java.util.Set;
import org.apache.hc.core5.pool.ConnPoolStats;
import org.apache.hc.core5.util.TimeValue;

public interface ConnPoolControl<T> extends org.apache.hc.core5.pool.ConnPoolStats<T>
{
    int getDefaultMaxPerRoute();
    int getMaxPerRoute(T p0);
    int getMaxTotal();
    java.util.Set<T> getRoutes();
    void closeExpired();
    void closeIdle(TimeValue p0);
    void setDefaultMaxPerRoute(int p0);
    void setMaxPerRoute(T p0, int p1);
    void setMaxTotal(int p0);
}
