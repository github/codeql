// Generated automatically from jakarta.ws.rs.client.SyncInvoker for testing purposes

package jakarta.ws.rs.client;

import jakarta.ws.rs.client.Entity;
import jakarta.ws.rs.core.GenericType;
import jakarta.ws.rs.core.Response;

public interface SyncInvoker
{
    <T> T delete(jakarta.ws.rs.core.GenericType<T> p0);
    <T> T delete(java.lang.Class<T> p0);
    <T> T get(jakarta.ws.rs.core.GenericType<T> p0);
    <T> T get(java.lang.Class<T> p0);
    <T> T method(String p0, Entity<? extends Object> p1, jakarta.ws.rs.core.GenericType<T> p2);
    <T> T method(String p0, Entity<? extends Object> p1, java.lang.Class<T> p2);
    <T> T method(String p0, jakarta.ws.rs.core.GenericType<T> p1);
    <T> T method(String p0, java.lang.Class<T> p1);
    <T> T options(jakarta.ws.rs.core.GenericType<T> p0);
    <T> T options(java.lang.Class<T> p0);
    <T> T post(Entity<? extends Object> p0, jakarta.ws.rs.core.GenericType<T> p1);
    <T> T post(Entity<? extends Object> p0, java.lang.Class<T> p1);
    <T> T put(Entity<? extends Object> p0, jakarta.ws.rs.core.GenericType<T> p1);
    <T> T put(Entity<? extends Object> p0, java.lang.Class<T> p1);
    <T> T trace(jakarta.ws.rs.core.GenericType<T> p0);
    <T> T trace(java.lang.Class<T> p0);
    Response delete();
    Response get();
    Response head();
    Response method(String p0);
    Response method(String p0, Entity<? extends Object> p1);
    Response options();
    Response post(Entity<? extends Object> p0);
    Response put(Entity<? extends Object> p0);
    Response trace();
}
