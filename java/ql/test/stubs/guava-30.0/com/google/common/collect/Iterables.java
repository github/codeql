// Generated automatically from com.google.common.collect.Iterables for testing purposes

package com.google.common.collect;

import com.google.common.base.Function;
import com.google.common.base.Optional;
import com.google.common.base.Predicate;
import com.google.common.collect.ImmutableCollection;
import java.util.Collection;
import java.util.Comparator;
import java.util.List;

public class Iterables
{
    protected Iterables() {}
    public static <E> Iterable<E> unmodifiableIterable(ImmutableCollection<E> p0){ return null; }
    public static <F, T> Iterable<T> transform(Iterable<F> p0, Function<? super F, ? extends T> p1){ return null; }
    public static <T> Iterable<List<T>> paddedPartition(Iterable<T> p0, int p1){ return null; }
    public static <T> Iterable<List<T>> partition(Iterable<T> p0, int p1){ return null; }
    public static <T> Iterable<T> concat(Iterable<? extends Iterable<? extends T>> p0){ return null; }
    public static <T> Iterable<T> concat(Iterable<? extends T> p0, Iterable<? extends T> p1){ return null; }
    public static <T> Iterable<T> concat(Iterable<? extends T> p0, Iterable<? extends T> p1, Iterable<? extends T> p2){ return null; }
    public static <T> Iterable<T> concat(Iterable<? extends T> p0, Iterable<? extends T> p1, Iterable<? extends T> p2, Iterable<? extends T> p3){ return null; }
    public static <T> Iterable<T> concat(Iterable<? extends T>... p0){ return null; }
    public static <T> Iterable<T> consumingIterable(Iterable<T> p0){ return null; }
    public static <T> Iterable<T> cycle(Iterable<T> p0){ return null; }
    public static <T> Iterable<T> cycle(T... p0){ return null; }
    public static <T> Iterable<T> filter(Iterable<? extends Object> p0, Class<T> p1){ return null; }
    public static <T> Iterable<T> filter(Iterable<T> p0, Predicate<? super T> p1){ return null; }
    public static <T> Iterable<T> limit(Iterable<T> p0, int p1){ return null; }
    public static <T> Iterable<T> mergeSorted(Iterable<? extends Iterable<? extends T>> p0, Comparator<? super T> p1){ return null; }
    public static <T> Iterable<T> skip(Iterable<T> p0, int p1){ return null; }
    public static <T> Iterable<T> unmodifiableIterable(Iterable<? extends T> p0){ return null; }
    public static <T> Optional<T> tryFind(Iterable<T> p0, Predicate<? super T> p1){ return null; }
    public static <T> T find(Iterable<? extends T> p0, Predicate<? super T> p1, T p2){ return null; }
    public static <T> T find(Iterable<T> p0, Predicate<? super T> p1){ return null; }
    public static <T> T get(Iterable<? extends T> p0, int p1, T p2){ return null; }
    public static <T> T get(Iterable<T> p0, int p1){ return null; }
    public static <T> T getFirst(Iterable<? extends T> p0, T p1){ return null; }
    public static <T> T getLast(Iterable<? extends T> p0, T p1){ return null; }
    public static <T> T getLast(Iterable<T> p0){ return null; }
    public static <T> T getOnlyElement(Iterable<? extends T> p0, T p1){ return null; }
    public static <T> T getOnlyElement(Iterable<T> p0){ return null; }
    public static <T> T[] toArray(Iterable<? extends T> p0, Class<T> p1){ return null; }
    public static <T> boolean addAll(Collection<T> p0, Iterable<? extends T> p1){ return false; }
    public static <T> boolean all(Iterable<T> p0, Predicate<? super T> p1){ return false; }
    public static <T> boolean any(Iterable<T> p0, Predicate<? super T> p1){ return false; }
    public static <T> boolean removeIf(Iterable<T> p0, Predicate<? super T> p1){ return false; }
    public static <T> int indexOf(Iterable<T> p0, Predicate<? super T> p1){ return 0; }
    public static String toString(Iterable<? extends Object> p0){ return null; }
    public static boolean contains(Iterable<? extends Object> p0, Object p1){ return false; }
    public static boolean elementsEqual(Iterable<? extends Object> p0, Iterable<? extends Object> p1){ return false; }
    public static boolean isEmpty(Iterable<? extends Object> p0){ return false; }
    public static boolean removeAll(Iterable<? extends Object> p0, Collection<? extends Object> p1){ return false; }
    public static boolean retainAll(Iterable<? extends Object> p0, Collection<? extends Object> p1){ return false; }
    public static int frequency(Iterable<? extends Object> p0, Object p1){ return 0; }
    public static int size(Iterable<? extends Object> p0){ return 0; }
}
