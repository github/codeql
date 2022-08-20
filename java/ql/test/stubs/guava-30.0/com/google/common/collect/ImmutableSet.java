// Generated automatically from com.google.common.collect.ImmutableSet for testing purposes

package com.google.common.collect;

import com.google.common.collect.ImmutableCollection;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.UnmodifiableIterator;
import java.util.Collection;
import java.util.Iterator;
import java.util.Set;
import java.util.stream.Collector;

abstract public class ImmutableSet<E> extends ImmutableCollection<E> implements Set<E>
{
    public ImmutableList<E> asList(){ return null; }
    public abstract UnmodifiableIterator<E> iterator();
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public static <E> Collector<E, ? extends Object, ImmutableSet<E>> toImmutableSet(){ return null; }
    public static <E> ImmutableSet.Builder<E> builder(){ return null; }
    public static <E> ImmutableSet.Builder<E> builderWithExpectedSize(int p0){ return null; }
    public static <E> ImmutableSet<E> copyOf(Collection<? extends E> p0){ return null; }
    public static <E> ImmutableSet<E> copyOf(E[] p0){ return null; }
    public static <E> ImmutableSet<E> copyOf(Iterable<? extends E> p0){ return null; }
    public static <E> ImmutableSet<E> copyOf(Iterator<? extends E> p0){ return null; }
    public static <E> ImmutableSet<E> of(){ return null; }
    public static <E> ImmutableSet<E> of(E p0){ return null; }
    public static <E> ImmutableSet<E> of(E p0, E p1){ return null; }
    public static <E> ImmutableSet<E> of(E p0, E p1, E p2){ return null; }
    public static <E> ImmutableSet<E> of(E p0, E p1, E p2, E p3){ return null; }
    public static <E> ImmutableSet<E> of(E p0, E p1, E p2, E p3, E p4){ return null; }
    public static <E> ImmutableSet<E> of(E p0, E p1, E p2, E p3, E p4, E p5, E... p6){ return null; }
    static public class Builder<E> extends ImmutableCollection.Builder<E>
    {
        public Builder(){}
        public ImmutableSet.Builder<E> add(E p0){ return null; }
        public ImmutableSet.Builder<E> add(E... p0){ return null; }
        public ImmutableSet.Builder<E> addAll(Iterable<? extends E> p0){ return null; }
        public ImmutableSet.Builder<E> addAll(Iterator<? extends E> p0){ return null; }
        public ImmutableSet<E> build(){ return null; }
    }
}
