// Generated automatically from javax.ws.rs.client.Invocation for testing purposes

package javax.ws.rs.client;

import java.util.Locale;
import java.util.concurrent.Future;
import javax.ws.rs.client.AsyncInvoker;
import javax.ws.rs.client.Entity;
import javax.ws.rs.client.InvocationCallback;
import javax.ws.rs.client.SyncInvoker;
import javax.ws.rs.core.CacheControl;
import javax.ws.rs.core.Cookie;
import javax.ws.rs.core.GenericType;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.MultivaluedMap;
import javax.ws.rs.core.Response;

public interface Invocation
{
    <T> T invoke(java.lang.Class<T> p0);
    <T> T invoke(javax.ws.rs.core.GenericType<T> p0);
    <T> java.util.concurrent.Future<T> submit(java.lang.Class<T> p0);
    <T> java.util.concurrent.Future<T> submit(javax.ws.rs.client.InvocationCallback<T> p0);
    <T> java.util.concurrent.Future<T> submit(javax.ws.rs.core.GenericType<T> p0);
    Invocation property(String p0, Object p1);
    Response invoke();
    java.util.concurrent.Future<Response> submit();
    static public interface Builder extends SyncInvoker
    {
        AsyncInvoker async();
        Invocation build(String p0);
        Invocation build(String p0, Entity<? extends Object> p1);
        Invocation buildDelete();
        Invocation buildGet();
        Invocation buildPost(Entity<? extends Object> p0);
        Invocation buildPut(Entity<? extends Object> p0);
        Invocation.Builder accept(MediaType... p0);
        Invocation.Builder accept(String... p0);
        Invocation.Builder acceptEncoding(String... p0);
        Invocation.Builder acceptLanguage(Locale... p0);
        Invocation.Builder acceptLanguage(String... p0);
        Invocation.Builder cacheControl(CacheControl p0);
        Invocation.Builder cookie(Cookie p0);
        Invocation.Builder cookie(String p0, String p1);
        Invocation.Builder header(String p0, Object p1);
        Invocation.Builder headers(MultivaluedMap<String, Object> p0);
        Invocation.Builder property(String p0, Object p1);
    }
}
