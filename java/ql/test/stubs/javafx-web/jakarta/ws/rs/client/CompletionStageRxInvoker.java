// Generated automatically from jakarta.ws.rs.client.CompletionStageRxInvoker for testing purposes

package jakarta.ws.rs.client;

import jakarta.ws.rs.client.Entity;
import jakarta.ws.rs.client.RxInvoker;
import jakarta.ws.rs.core.GenericType;
import jakarta.ws.rs.core.Response;
import java.util.concurrent.CompletionStage;

public interface CompletionStageRxInvoker extends RxInvoker<CompletionStage>
{
    <T> java.util.concurrent.CompletionStage<T> delete(jakarta.ws.rs.core.GenericType<T> p0);
    <T> java.util.concurrent.CompletionStage<T> delete(java.lang.Class<T> p0);
    <T> java.util.concurrent.CompletionStage<T> get(jakarta.ws.rs.core.GenericType<T> p0);
    <T> java.util.concurrent.CompletionStage<T> get(java.lang.Class<T> p0);
    <T> java.util.concurrent.CompletionStage<T> method(String p0, Entity<? extends Object> p1, jakarta.ws.rs.core.GenericType<T> p2);
    <T> java.util.concurrent.CompletionStage<T> method(String p0, Entity<? extends Object> p1, java.lang.Class<T> p2);
    <T> java.util.concurrent.CompletionStage<T> method(String p0, jakarta.ws.rs.core.GenericType<T> p1);
    <T> java.util.concurrent.CompletionStage<T> method(String p0, java.lang.Class<T> p1);
    <T> java.util.concurrent.CompletionStage<T> options(jakarta.ws.rs.core.GenericType<T> p0);
    <T> java.util.concurrent.CompletionStage<T> options(java.lang.Class<T> p0);
    <T> java.util.concurrent.CompletionStage<T> post(Entity<? extends Object> p0, jakarta.ws.rs.core.GenericType<T> p1);
    <T> java.util.concurrent.CompletionStage<T> post(Entity<? extends Object> p0, java.lang.Class<T> p1);
    <T> java.util.concurrent.CompletionStage<T> put(Entity<? extends Object> p0, jakarta.ws.rs.core.GenericType<T> p1);
    <T> java.util.concurrent.CompletionStage<T> put(Entity<? extends Object> p0, java.lang.Class<T> p1);
    <T> java.util.concurrent.CompletionStage<T> trace(jakarta.ws.rs.core.GenericType<T> p0);
    <T> java.util.concurrent.CompletionStage<T> trace(java.lang.Class<T> p0);
    CompletionStage<Response> delete();
    CompletionStage<Response> get();
    CompletionStage<Response> head();
    CompletionStage<Response> method(String p0);
    CompletionStage<Response> method(String p0, Entity<? extends Object> p1);
    CompletionStage<Response> options();
    CompletionStage<Response> post(Entity<? extends Object> p0);
    CompletionStage<Response> put(Entity<? extends Object> p0);
    CompletionStage<Response> trace();
}
