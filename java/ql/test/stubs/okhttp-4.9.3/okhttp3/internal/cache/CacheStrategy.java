// Generated automatically from okhttp3.internal.cache.CacheStrategy for testing purposes

package okhttp3.internal.cache;

import okhttp3.Request;
import okhttp3.Response;

public class CacheStrategy
{
    protected CacheStrategy() {}
    public CacheStrategy(Request p0, Response p1){}
    public final Request getNetworkRequest(){ return null; }
    public final Response getCacheResponse(){ return null; }
    public static CacheStrategy.Companion Companion = null;
    static public class Companion
    {
        protected Companion() {}
        public final boolean isCacheable(Response p0, Request p1){ return false; }
    }
}
