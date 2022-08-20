// Generated automatically from com.google.common.base.Optional for testing purposes, and manually adjusted.

package com.google.common.base;

import com.google.common.base.Function;
import com.google.common.base.Supplier;
import java.io.Serializable;
import java.util.Set;

abstract public class Optional<T> implements Serializable
{
    Optional(){}
    public java.util.Optional<T> toJavaUtil(){ return null; }
    public abstract <V> Optional<V> transform(Function<? super T, V> p0);
    public abstract Optional<T> or(Optional<? extends T> p0);
    public abstract Set<T> asSet();
    public abstract String toString();
    public abstract T get();
    public abstract T or(Supplier<? extends T> p0);
    public abstract T or(T p0);
    public abstract T orNull();
    public abstract boolean equals(Object p0);
    public abstract boolean isPresent();
    public abstract int hashCode();
    public static <T> Iterable<T> presentInstances(Iterable<? extends Optional<? extends T>> p0){ return null; }
    public static <T> Optional<T> absent(){ return null; }
    public static <T> Optional<T> fromJavaUtil(java.util.Optional<T> p0){ return null; }
    public static <T> Optional<T> fromNullable(T p0){ return null; }
    public static <T> Optional<T> of(T p0){ return null; }
    public static <T> java.util.Optional<T> toJavaUtil(Optional<T> p0){ return null; }
}
