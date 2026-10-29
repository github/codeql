// Generated automatically from okhttp3.Cache for testing purposes

package okhttp3;

import java.io.Closeable;
import java.io.File;
import java.io.Flushable;
import java.util.Iterator;
import okhttp3.Headers;
import okhttp3.HttpUrl;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.internal.cache.CacheRequest;
import okhttp3.internal.cache.CacheStrategy;
import okhttp3.internal.cache.DiskLruCache;
import okhttp3.internal.io.FileSystem;
import okio.BufferedSource;

public class Cache implements Closeable, Flushable
{
    protected Cache() {}
    public Cache(File p0, long p1){}
    public Cache(File p0, long p1, FileSystem p2){}
    public final CacheRequest put$okhttp(Response p0){ return null; }
    public final DiskLruCache getCache$okhttp(){ return null; }
    public final File directory(){ return null; }
    public final Iterator<String> urls(){ return null; }
    public final Response get$okhttp(Request p0){ return null; }
    public final boolean isClosed(){ return false; }
    public final int getWriteAbortCount$okhttp(){ return 0; }
    public final int getWriteSuccessCount$okhttp(){ return 0; }
    public final int hitCount(){ return 0; }
    public final int networkCount(){ return 0; }
    public final int requestCount(){ return 0; }
    public final int writeAbortCount(){ return 0; }
    public final int writeSuccessCount(){ return 0; }
    public final long maxSize(){ return 0; }
    public final long size(){ return 0; }
    public final void delete(){}
    public final void evictAll(){}
    public final void initialize(){}
    public final void remove$okhttp(Request p0){}
    public final void setWriteAbortCount$okhttp(int p0){}
    public final void setWriteSuccessCount$okhttp(int p0){}
    public final void trackConditionalCacheHit$okhttp(){}
    public final void trackResponse$okhttp(CacheStrategy p0){}
    public final void update$okhttp(Response p0, Response p1){}
    public static Cache.Companion Companion = null;
    public static String key(HttpUrl p0){ return null; }
    public void close(){}
    public void flush(){}
    static public class Companion
    {
        protected Companion() {}
        public final Headers varyHeaders(Response p0){ return null; }
        public final String key(HttpUrl p0){ return null; }
        public final boolean hasVaryAll(Response p0){ return false; }
        public final boolean varyMatches(Response p0, Headers p1, Request p2){ return false; }
        public final int readInt$okhttp(BufferedSource p0){ return 0; }
    }
}
