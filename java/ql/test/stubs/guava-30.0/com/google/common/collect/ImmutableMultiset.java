// Generated automatically from com.google.common.collect.ImmutableMultiset for testing purposes

package com.google.common.collect;

import com.google.common.collect.ImmutableCollection;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableMultisetGwtSerializationDependencies;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Multiset;
import com.google.common.collect.UnmodifiableIterator;
import java.util.Iterator;
import java.util.function.Function;
import java.util.function.ToIntFunction;
import java.util.stream.Collector;

abstract public class ImmutableMultiset<E> extends ImmutableMultisetGwtSerializationDependencies<E> implements Multiset<E>
{
    public ImmutableList<E> asList(){ return null; }
    public ImmutableSet<Multiset.Entry<E>> entrySet(){ return null; }
    public String toString(){ return null; }
    public UnmodifiableIterator<E> iterator(){ return null; }
    public abstract ImmutableSet<E> elementSet();
    public boolean contains(Object p0){ return false; }
    public boolean equals(Object p0){ return false; }
    public final boolean setCount(E p0, int p1, int p2){ return false; }
    public final int add(E p0, int p1){ return 0; }
    public final int remove(Object p0, int p1){ return 0; }
    public final int setCount(E p0, int p1){ return 0; }
    public int hashCode(){ return 0; }
    public static <E> Collector<E, ? extends Object, ImmutableMultiset<E>> toImmutableMultiset(){ return null; }
    public static <E> ImmutableMultiset.Builder<E> builder(){ return null; }
    public static <E> ImmutableMultiset<E> copyOf(E[] p0){ return null; }
    public static <E> ImmutableMultiset<E> copyOf(Iterable<? extends E> p0){ return null; }
    public static <E> ImmutableMultiset<E> copyOf(Iterator<? extends E> p0){ return null; }
    public static <E> ImmutableMultiset<E> of(){ return null; }
    public static <E> ImmutableMultiset<E> of(E p0){ return null; }
    public static <E> ImmutableMultiset<E> of(E p0, E p1){ return null; }
    public static <E> ImmutableMultiset<E> of(E p0, E p1, E p2){ return null; }
    public static <E> ImmutableMultiset<E> of(E p0, E p1, E p2, E p3){ return null; }
    public static <E> ImmutableMultiset<E> of(E p0, E p1, E p2, E p3, E p4){ return null; }
    public static <E> ImmutableMultiset<E> of(E p0, E p1, E p2, E p3, E p4, E p5, E... p6){ return null; }
    public static <T, E> Collector<T, ? extends Object, ImmutableMultiset<E>> toImmutableMultiset(Function<? super T, ? extends E> p0, ToIntFunction<? super T> p1){ return null; }
    static public class Builder<E> extends ImmutableCollection.Builder<E>
    {
        public Builder(){}
        public ImmutableMultiset.Builder<E> add(E p0){ return null; }
        public ImmutableMultiset.Builder<E> add(E... p0){ return null; }
        public ImmutableMultiset.Builder<E> addAll(Iterable<? extends E> p0){ return null; }
        public ImmutableMultiset.Builder<E> addAll(Iterator<? extends E> p0){ return null; }
        public ImmutableMultiset.Builder<E> addCopies(E p0, int p1){ return null; }
        public ImmutableMultiset.Builder<E> setCount(E p0, int p1){ return null; }
        public ImmutableMultiset<E> build(){ return null; }
    }
}
