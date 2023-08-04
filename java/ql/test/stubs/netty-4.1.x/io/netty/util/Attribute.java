// Generated automatically from io.netty.util.Attribute for testing purposes

package io.netty.util;

import io.netty.util.AttributeKey;

public interface Attribute<T>
{
    T get();
    T getAndRemove();
    T getAndSet(T p0);
    T setIfAbsent(T p0);
    boolean compareAndSet(T p0, T p1);
    io.netty.util.AttributeKey<T> key();
    void remove();
    void set(T p0);
}
