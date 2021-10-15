// Generated automatically from com.google.common.collect.ImmutableList for testing purposes

package com.google.common.collect;

import com.google.common.collect.ImmutableCollection;
import com.google.common.collect.UnmodifiableIterator;
import com.google.common.collect.UnmodifiableListIterator;
import java.util.Collection;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;
import java.util.RandomAccess;
import java.util.Spliterator;
import java.util.function.Consumer;
import java.util.function.UnaryOperator;
import java.util.stream.Collector;

abstract public class ImmutableList<E> extends ImmutableCollection<E> implements List<E>, RandomAccess
{
    public ImmutableList<E> reverse(){ return null; }
    public ImmutableList<E> subList(int p0, int p1){ return null; }
    public Spliterator<E> spliterator(){ return null; }
    public UnmodifiableIterator<E> iterator(){ return null; }
    public UnmodifiableListIterator<E> listIterator(){ return null; }
    public UnmodifiableListIterator<E> listIterator(int p0){ return null; }
    public boolean contains(Object p0){ return false; }
    public boolean equals(Object p0){ return false; }
    public final E remove(int p0){ return null; }
    public final E set(int p0, E p1){ return null; }
    public final ImmutableList<E> asList(){ return null; }
    public final boolean addAll(int p0, Collection<? extends E> p1){ return false; }
    public final void add(int p0, E p1){}
    public final void replaceAll(UnaryOperator<E> p0){}
    public final void sort(Comparator<? super E> p0){}
    public int hashCode(){ return 0; }
    public int indexOf(Object p0){ return 0; }
    public int lastIndexOf(Object p0){ return 0; }
    public static <E extends Comparable<? super E>> ImmutableList<E> sortedCopyOf(Iterable<? extends E> p0){ return null; }
    public static <E> Collector<E, ? extends Object, ImmutableList<E>> toImmutableList(){ return null; }
    public static <E> ImmutableList.Builder<E> builder(){ return null; }
    public static <E> ImmutableList.Builder<E> builderWithExpectedSize(int p0){ return null; }
    public static <E> ImmutableList<E> copyOf(Collection<? extends E> p0){ return null; }
    public static <E> ImmutableList<E> copyOf(E[] p0){ return null; }
    public static <E> ImmutableList<E> copyOf(Iterable<? extends E> p0){ return null; }
    public static <E> ImmutableList<E> copyOf(Iterator<? extends E> p0){ return null; }
    public static <E> ImmutableList<E> of(){ return null; }
    public static <E> ImmutableList<E> of(E p0){ return null; }
    public static <E> ImmutableList<E> of(E p0, E p1){ return null; }
    public static <E> ImmutableList<E> of(E p0, E p1, E p2){ return null; }
    public static <E> ImmutableList<E> of(E p0, E p1, E p2, E p3){ return null; }
    public static <E> ImmutableList<E> of(E p0, E p1, E p2, E p3, E p4){ return null; }
    public static <E> ImmutableList<E> of(E p0, E p1, E p2, E p3, E p4, E p5){ return null; }
    public static <E> ImmutableList<E> of(E p0, E p1, E p2, E p3, E p4, E p5, E p6){ return null; }
    public static <E> ImmutableList<E> of(E p0, E p1, E p2, E p3, E p4, E p5, E p6, E p7){ return null; }
    public static <E> ImmutableList<E> of(E p0, E p1, E p2, E p3, E p4, E p5, E p6, E p7, E p8){ return null; }
    public static <E> ImmutableList<E> of(E p0, E p1, E p2, E p3, E p4, E p5, E p6, E p7, E p8, E p9){ return null; }
    public static <E> ImmutableList<E> of(E p0, E p1, E p2, E p3, E p4, E p5, E p6, E p7, E p8, E p9, E p10){ return null; }
    public static <E> ImmutableList<E> of(E p0, E p1, E p2, E p3, E p4, E p5, E p6, E p7, E p8, E p9, E p10, E p11, E... p12){ return null; }
    public static <E> ImmutableList<E> sortedCopyOf(Comparator<? super E> p0, Iterable<? extends E> p1){ return null; }
    public void forEach(Consumer<? super E> p0){}
    static public class Builder<E> extends ImmutableCollection.Builder<E>
    {
        public Builder(){}
        public ImmutableList.Builder<E> add(E p0){ return null; }
        public ImmutableList.Builder<E> add(E... p0){ return null; }
        public ImmutableList.Builder<E> addAll(Iterable<? extends E> p0){ return null; }
        public ImmutableList.Builder<E> addAll(Iterator<? extends E> p0){ return null; }
        public ImmutableList<E> build(){ return null; }
    }
}
