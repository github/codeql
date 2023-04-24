// Generated automatically from io.netty.resolver.NameResolver for testing purposes

package io.netty.resolver;

import io.netty.util.concurrent.Promise;
import java.io.Closeable;
import java.util.List;

public interface NameResolver<T> extends Closeable
{
    io.netty.util.concurrent.Future<T> resolve(String p0);
    io.netty.util.concurrent.Future<T> resolve(String p0, io.netty.util.concurrent.Promise<T> p1);
    io.netty.util.concurrent.Future<java.util.List<T>> resolveAll(String p0);
    io.netty.util.concurrent.Future<java.util.List<T>> resolveAll(String p0, io.netty.util.concurrent.Promise<java.util.List<T>> p1);
    void close();
}
