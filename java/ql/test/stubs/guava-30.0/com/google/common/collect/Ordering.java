// Generated automatically from com.google.common.collect.Ordering for testing purposes

package com.google.common.collect;

import com.google.common.base.Function;
import com.google.common.collect.ImmutableList;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

abstract public class Ordering<T> implements Comparator<T>
{
    <T2 extends T> Ordering<Map.Entry<T2, ? extends Object>> onKeys(){ return null; }
    protected Ordering(){}
    public <E extends T> E max(E p0, E p1){ return null; }
    public <E extends T> E max(E p0, E p1, E p2, E... p3){ return null; }
    public <E extends T> E max(Iterable<E> p0){ return null; }
    public <E extends T> E max(Iterator<E> p0){ return null; }
    public <E extends T> E min(E p0, E p1){ return null; }
    public <E extends T> E min(E p0, E p1, E p2, E... p3){ return null; }
    public <E extends T> E min(Iterable<E> p0){ return null; }
    public <E extends T> E min(Iterator<E> p0){ return null; }
    public <E extends T> ImmutableList<E> immutableSortedCopy(Iterable<E> p0){ return null; }
    public <E extends T> List<E> greatestOf(Iterable<E> p0, int p1){ return null; }
    public <E extends T> List<E> greatestOf(Iterator<E> p0, int p1){ return null; }
    public <E extends T> List<E> leastOf(Iterable<E> p0, int p1){ return null; }
    public <E extends T> List<E> leastOf(Iterator<E> p0, int p1){ return null; }
    public <E extends T> List<E> sortedCopy(Iterable<E> p0){ return null; }
    public <F> Ordering<F> onResultOf(Function<F, ? extends T> p0){ return null; }
    public <S extends T> Ordering<Iterable<S>> lexicographical(){ return null; }
    public <S extends T> Ordering<S> nullsFirst(){ return null; }
    public <S extends T> Ordering<S> nullsLast(){ return null; }
    public <S extends T> Ordering<S> reverse(){ return null; }
    public <U extends T> Ordering<U> compound(Comparator<? super U> p0){ return null; }
    public abstract int compare(T p0, T p1);
    public boolean isOrdered(Iterable<? extends T> p0){ return false; }
    public boolean isStrictlyOrdered(Iterable<? extends T> p0){ return false; }
    public int binarySearch(List<? extends T> p0, T p1){ return 0; }
    public static <C extends Comparable> Ordering<C> natural(){ return null; }
    public static <T> Ordering<T> compound(Iterable<? extends Comparator<? super T>> p0){ return null; }
    public static <T> Ordering<T> explicit(List<T> p0){ return null; }
    public static <T> Ordering<T> explicit(T p0, T... p1){ return null; }
    public static <T> Ordering<T> from(Comparator<T> p0){ return null; }
    public static <T> Ordering<T> from(Ordering<T> p0){ return null; }
    public static Ordering<Object> allEqual(){ return null; }
    public static Ordering<Object> arbitrary(){ return null; }
    public static Ordering<Object> usingToString(){ return null; }
    static int LEFT_IS_GREATER = 0;
    static int RIGHT_IS_GREATER = 0;
}
