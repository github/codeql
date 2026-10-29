// Generated automatically from io.netty.util.HashingStrategy for testing purposes

package io.netty.util;


public interface HashingStrategy<T>
{
    boolean equals(T p0, T p1);
    int hashCode(T p0);
    static HashingStrategy JAVA_HASHER = null;
}
