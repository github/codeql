// Generated automatically from jakarta.ws.rs.client.Invocation for testing purposes

package jakarta.ws.rs.client;

import jakarta.ws.rs.client.AsyncInvoker;
import jakarta.ws.rs.client.CompletionStageRxInvoker;
import jakarta.ws.rs.client.Entity;
import jakarta.ws.rs.client.InvocationCallback;
import jakarta.ws.rs.client.RxInvoker;
import jakarta.ws.rs.client.SyncInvoker;
import jakarta.ws.rs.core.CacheControl;
import jakarta.ws.rs.core.Cookie;
import jakarta.ws.rs.core.GenericType;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.MultivaluedMap;
import jakarta.ws.rs.core.Response;
import java.util.Locale;
import java.util.concurrent.Future;

public interface Invocation
{
    <T> T invoke(jakarta.ws.rs.core.GenericType<T> p0);
    <T> T invoke(java.lang.Class<T> p0);
    <T> java.util.concurrent.Future<T> submit(jakarta.ws.rs.client.InvocationCallback<T> p0);
    <T> java.util.concurrent.Future<T> submit(jakarta.ws.rs.core.GenericType<T> p0);
    <T> java.util.concurrent.Future<T> submit(java.lang.Class<T> p0);
    Invocation property(String p0, Object p1);
    Response invoke();
    java.util.concurrent.Future<Response> submit();
    static public interface Builder extends SyncInvoker
    {
        <T extends RxInvoker> T rx(java.lang.Class<T> p0);
        AsyncInvoker async();
        CompletionStageRxInvoker rx();
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
