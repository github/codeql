// Generated automatically from okhttp3.internal.connection.RealConnectionPool for testing purposes

package okhttp3.internal.connection;

import java.util.List;
import java.util.concurrent.TimeUnit;
import okhttp3.Address;
import okhttp3.ConnectionPool;
import okhttp3.Route;
import okhttp3.internal.concurrent.TaskRunner;
import okhttp3.internal.connection.RealCall;
import okhttp3.internal.connection.RealConnection;

public class RealConnectionPool
{
    protected RealConnectionPool() {}
    public RealConnectionPool(TaskRunner p0, int p1, long p2, TimeUnit p3){}
    public final boolean callAcquirePooledConnection(Address p0, RealCall p1, List<Route> p2, boolean p3){ return false; }
    public final boolean connectionBecameIdle(RealConnection p0){ return false; }
    public final int connectionCount(){ return 0; }
    public final int idleConnectionCount(){ return 0; }
    public final long cleanup(long p0){ return 0; }
    public final void evictAll(){}
    public final void put(RealConnection p0){}
    public static RealConnectionPool.Companion Companion = null;
    static public class Companion
    {
        protected Companion() {}
        public final RealConnectionPool get(ConnectionPool p0){ return null; }
    }
}
