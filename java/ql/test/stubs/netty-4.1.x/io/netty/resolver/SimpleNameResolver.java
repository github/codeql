// Generated automatically from io.netty.resolver.SimpleNameResolver for testing purposes

package io.netty.resolver;

import io.netty.resolver.NameResolver;
import io.netty.util.concurrent.EventExecutor;
import io.netty.util.concurrent.Promise;
import java.util.List;

abstract public class SimpleNameResolver<T> implements NameResolver<T>
{
    protected SimpleNameResolver() {}
    protected EventExecutor executor(){ return null; }
    protected SimpleNameResolver(EventExecutor p0){}
    protected abstract void doResolve(String p0, io.netty.util.concurrent.Promise<T> p1);
    protected abstract void doResolveAll(String p0, io.netty.util.concurrent.Promise<java.util.List<T>> p1);
    public final io.netty.util.concurrent.Future<T> resolve(String p0){ return null; }
    public final io.netty.util.concurrent.Future<java.util.List<T>> resolveAll(String p0){ return null; }
    public io.netty.util.concurrent.Future<T> resolve(String p0, io.netty.util.concurrent.Promise<T> p1){ return null; }
    public io.netty.util.concurrent.Future<java.util.List<T>> resolveAll(String p0, io.netty.util.concurrent.Promise<java.util.List<T>> p1){ return null; }
    public void close(){}
}
