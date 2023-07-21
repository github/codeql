// Generated automatically from jakarta.ws.rs.client.RxInvoker for testing purposes

package jakarta.ws.rs.client;

import jakarta.ws.rs.client.Entity;
import jakarta.ws.rs.core.GenericType;

public interface RxInvoker<T>
{
    <R> T delete(jakarta.ws.rs.core.GenericType<R> p0);
    <R> T delete(java.lang.Class<R> p0);
    <R> T get(jakarta.ws.rs.core.GenericType<R> p0);
    <R> T get(java.lang.Class<R> p0);
    <R> T method(String p0, Entity<? extends Object> p1, jakarta.ws.rs.core.GenericType<R> p2);
    <R> T method(String p0, Entity<? extends Object> p1, java.lang.Class<R> p2);
    <R> T method(String p0, jakarta.ws.rs.core.GenericType<R> p1);
    <R> T method(String p0, java.lang.Class<R> p1);
    <R> T options(jakarta.ws.rs.core.GenericType<R> p0);
    <R> T options(java.lang.Class<R> p0);
    <R> T post(Entity<? extends Object> p0, jakarta.ws.rs.core.GenericType<R> p1);
    <R> T post(Entity<? extends Object> p0, java.lang.Class<R> p1);
    <R> T put(Entity<? extends Object> p0, jakarta.ws.rs.core.GenericType<R> p1);
    <R> T put(Entity<? extends Object> p0, java.lang.Class<R> p1);
    <R> T trace(jakarta.ws.rs.core.GenericType<R> p0);
    <R> T trace(java.lang.Class<R> p0);
    T delete();
    T get();
    T head();
    T method(String p0);
    T method(String p0, Entity<? extends Object> p1);
    T options();
    T post(Entity<? extends Object> p0);
    T put(Entity<? extends Object> p0);
    T trace();
}
