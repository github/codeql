// Generated automatically from javax.ws.rs.client.AsyncInvoker for testing purposes

package javax.ws.rs.client;

import java.util.concurrent.Future;
import javax.ws.rs.client.Entity;
import javax.ws.rs.client.InvocationCallback;
import javax.ws.rs.core.GenericType;
import javax.ws.rs.core.Response;

public interface AsyncInvoker
{
    <T> java.util.concurrent.Future<T> delete(java.lang.Class<T> p0);
    <T> java.util.concurrent.Future<T> delete(javax.ws.rs.client.InvocationCallback<T> p0);
    <T> java.util.concurrent.Future<T> delete(javax.ws.rs.core.GenericType<T> p0);
    <T> java.util.concurrent.Future<T> get(java.lang.Class<T> p0);
    <T> java.util.concurrent.Future<T> get(javax.ws.rs.client.InvocationCallback<T> p0);
    <T> java.util.concurrent.Future<T> get(javax.ws.rs.core.GenericType<T> p0);
    <T> java.util.concurrent.Future<T> method(String p0, Entity<? extends Object> p1, java.lang.Class<T> p2);
    <T> java.util.concurrent.Future<T> method(String p0, Entity<? extends Object> p1, javax.ws.rs.client.InvocationCallback<T> p2);
    <T> java.util.concurrent.Future<T> method(String p0, Entity<? extends Object> p1, javax.ws.rs.core.GenericType<T> p2);
    <T> java.util.concurrent.Future<T> method(String p0, java.lang.Class<T> p1);
    <T> java.util.concurrent.Future<T> method(String p0, javax.ws.rs.client.InvocationCallback<T> p1);
    <T> java.util.concurrent.Future<T> method(String p0, javax.ws.rs.core.GenericType<T> p1);
    <T> java.util.concurrent.Future<T> options(java.lang.Class<T> p0);
    <T> java.util.concurrent.Future<T> options(javax.ws.rs.client.InvocationCallback<T> p0);
    <T> java.util.concurrent.Future<T> options(javax.ws.rs.core.GenericType<T> p0);
    <T> java.util.concurrent.Future<T> post(Entity<? extends Object> p0, java.lang.Class<T> p1);
    <T> java.util.concurrent.Future<T> post(Entity<? extends Object> p0, javax.ws.rs.client.InvocationCallback<T> p1);
    <T> java.util.concurrent.Future<T> post(Entity<? extends Object> p0, javax.ws.rs.core.GenericType<T> p1);
    <T> java.util.concurrent.Future<T> put(Entity<? extends Object> p0, java.lang.Class<T> p1);
    <T> java.util.concurrent.Future<T> put(Entity<? extends Object> p0, javax.ws.rs.client.InvocationCallback<T> p1);
    <T> java.util.concurrent.Future<T> put(Entity<? extends Object> p0, javax.ws.rs.core.GenericType<T> p1);
    <T> java.util.concurrent.Future<T> trace(java.lang.Class<T> p0);
    <T> java.util.concurrent.Future<T> trace(javax.ws.rs.client.InvocationCallback<T> p0);
    <T> java.util.concurrent.Future<T> trace(javax.ws.rs.core.GenericType<T> p0);
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
