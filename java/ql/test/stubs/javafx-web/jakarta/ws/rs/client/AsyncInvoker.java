// Generated automatically from jakarta.ws.rs.client.AsyncInvoker for testing purposes

package jakarta.ws.rs.client;

import jakarta.ws.rs.client.Entity;
import jakarta.ws.rs.client.InvocationCallback;
import jakarta.ws.rs.core.GenericType;
import jakarta.ws.rs.core.Response;
import java.util.concurrent.Future;

public interface AsyncInvoker
{
    <T> java.util.concurrent.Future<T> delete(jakarta.ws.rs.client.InvocationCallback<T> p0);
    <T> java.util.concurrent.Future<T> delete(jakarta.ws.rs.core.GenericType<T> p0);
    <T> java.util.concurrent.Future<T> delete(java.lang.Class<T> p0);
    <T> java.util.concurrent.Future<T> get(jakarta.ws.rs.client.InvocationCallback<T> p0);
    <T> java.util.concurrent.Future<T> get(jakarta.ws.rs.core.GenericType<T> p0);
    <T> java.util.concurrent.Future<T> get(java.lang.Class<T> p0);
    <T> java.util.concurrent.Future<T> method(String p0, Entity<? extends Object> p1, jakarta.ws.rs.client.InvocationCallback<T> p2);
    <T> java.util.concurrent.Future<T> method(String p0, Entity<? extends Object> p1, jakarta.ws.rs.core.GenericType<T> p2);
    <T> java.util.concurrent.Future<T> method(String p0, Entity<? extends Object> p1, java.lang.Class<T> p2);
    <T> java.util.concurrent.Future<T> method(String p0, jakarta.ws.rs.client.InvocationCallback<T> p1);
    <T> java.util.concurrent.Future<T> method(String p0, jakarta.ws.rs.core.GenericType<T> p1);
    <T> java.util.concurrent.Future<T> method(String p0, java.lang.Class<T> p1);
    <T> java.util.concurrent.Future<T> options(jakarta.ws.rs.client.InvocationCallback<T> p0);
    <T> java.util.concurrent.Future<T> options(jakarta.ws.rs.core.GenericType<T> p0);
    <T> java.util.concurrent.Future<T> options(java.lang.Class<T> p0);
    <T> java.util.concurrent.Future<T> post(Entity<? extends Object> p0, jakarta.ws.rs.client.InvocationCallback<T> p1);
    <T> java.util.concurrent.Future<T> post(Entity<? extends Object> p0, jakarta.ws.rs.core.GenericType<T> p1);
    <T> java.util.concurrent.Future<T> post(Entity<? extends Object> p0, java.lang.Class<T> p1);
    <T> java.util.concurrent.Future<T> put(Entity<? extends Object> p0, jakarta.ws.rs.client.InvocationCallback<T> p1);
    <T> java.util.concurrent.Future<T> put(Entity<? extends Object> p0, jakarta.ws.rs.core.GenericType<T> p1);
    <T> java.util.concurrent.Future<T> put(Entity<? extends Object> p0, java.lang.Class<T> p1);
    <T> java.util.concurrent.Future<T> trace(jakarta.ws.rs.client.InvocationCallback<T> p0);
    <T> java.util.concurrent.Future<T> trace(jakarta.ws.rs.core.GenericType<T> p0);
    <T> java.util.concurrent.Future<T> trace(java.lang.Class<T> p0);
    java.util.concurrent.Future<Response> delete();
    java.util.concurrent.Future<Response> get();
    java.util.concurrent.Future<Response> head();
    java.util.concurrent.Future<Response> head(InvocationCallback<Response> p0);
    java.util.concurrent.Future<Response> method(String p0);
    java.util.concurrent.Future<Response> method(String p0, Entity<? extends Object> p1);
    java.util.concurrent.Future<Response> options();
    java.util.concurrent.Future<Response> post(Entity<? extends Object> p0);
    java.util.concurrent.Future<Response> put(Entity<? extends Object> p0);
    java.util.concurrent.Future<Response> trace();
}
