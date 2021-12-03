// Generated automatically from org.apache.commons.collections4.IterableUtils for testing purposes

package org.apache.commons.collections4;

import java.util.Collection;
import java.util.Comparator;
import java.util.List;
import org.apache.commons.collections4.Closure;
import org.apache.commons.collections4.Equator;
import org.apache.commons.collections4.Factory;
import org.apache.commons.collections4.FluentIterable;
import org.apache.commons.collections4.Predicate;
import org.apache.commons.collections4.Transformer;

public class IterableUtils
{
    public IterableUtils(){}
    public static <E, T extends E> int frequency(Iterable<E> p0, T p1){ return 0; }
    public static <E> E find(Iterable<E> p0, Predicate<? super E> p1){ return null; }
    public static <E> E forEachButLast(Iterable<E> p0, Closure<? super E> p1){ return null; }
    public static <E> Iterable<E> boundedIterable(Iterable<E> p0, long p1){ return null; }
    public static <E> Iterable<E> chainedIterable(Iterable<? extends E> p0, Iterable<? extends E> p1){ return null; }
    public static <E> Iterable<E> chainedIterable(Iterable<? extends E> p0, Iterable<? extends E> p1, Iterable<? extends E> p2){ return null; }
    public static <E> Iterable<E> chainedIterable(Iterable<? extends E> p0, Iterable<? extends E> p1, Iterable<? extends E> p2, Iterable<? extends E> p3){ return null; }
    public static <E> Iterable<E> chainedIterable(Iterable<? extends E>... p0){ return null; }
    public static <E> Iterable<E> collatedIterable(Comparator<? super E> p0, Iterable<? extends E> p1, Iterable<? extends E> p2){ return null; }
    public static <E> Iterable<E> collatedIterable(Iterable<? extends E> p0, Iterable<? extends E> p1){ return null; }
    public static <E> Iterable<E> emptyIfNull(Iterable<E> p0){ return null; }
    public static <E> Iterable<E> emptyIterable(){ return null; }
    public static <E> Iterable<E> filteredIterable(Iterable<E> p0, Predicate<? super E> p1){ return null; }
    public static <E> Iterable<E> loopingIterable(Iterable<E> p0){ return null; }
    public static <E> Iterable<E> reversedIterable(Iterable<E> p0){ return null; }
    public static <E> Iterable<E> skippingIterable(Iterable<E> p0, long p1){ return null; }
    public static <E> Iterable<E> uniqueIterable(Iterable<E> p0){ return null; }
    public static <E> Iterable<E> unmodifiableIterable(Iterable<E> p0){ return null; }
    public static <E> Iterable<E> zippingIterable(Iterable<? extends E> p0, Iterable<? extends E> p1){ return null; }
    public static <E> Iterable<E> zippingIterable(Iterable<? extends E> p0, Iterable<? extends E>... p1){ return null; }
    public static <E> List<E> toList(Iterable<E> p0){ return null; }
    public static <E> String toString(Iterable<E> p0){ return null; }
    public static <E> String toString(Iterable<E> p0, Transformer<? super E, String> p1){ return null; }
    public static <E> String toString(Iterable<E> p0, Transformer<? super E, String> p1, String p2, String p3, String p4){ return null; }
    public static <E> boolean contains(Iterable<? extends E> p0, E p1, Equator<? super E> p2){ return false; }
    public static <E> boolean contains(Iterable<E> p0, Object p1){ return false; }
    public static <E> boolean matchesAll(Iterable<E> p0, Predicate<? super E> p1){ return false; }
    public static <E> boolean matchesAny(Iterable<E> p0, Predicate<? super E> p1){ return false; }
    public static <E> int indexOf(Iterable<E> p0, Predicate<? super E> p1){ return 0; }
    public static <E> long countMatches(Iterable<E> p0, Predicate<? super E> p1){ return 0; }
    public static <E> void forEach(Iterable<E> p0, Closure<? super E> p1){}
    public static <I, O> Iterable<O> transformedIterable(Iterable<I> p0, Transformer<? super I, ? extends O> p1){ return null; }
    public static <O, R extends Collection<O>> List<R> partition(Iterable<? extends O> p0, Factory<R> p1, Predicate<? super O>... p2){ return null; }
    public static <O> List<List<O>> partition(Iterable<? extends O> p0, Predicate<? super O> p1){ return null; }
    public static <O> List<List<O>> partition(Iterable<? extends O> p0, Predicate<? super O>... p1){ return null; }
    public static <T> T first(Iterable<T> p0){ return null; }
    public static <T> T get(Iterable<T> p0, int p1){ return null; }
    public static boolean isEmpty(Iterable<? extends Object> p0){ return false; }
    public static int size(Iterable<? extends Object> p0){ return 0; }
    static FluentIterable EMPTY_ITERABLE = null;
    static void checkNotNull(Iterable<? extends Object> p0){}
    static void checkNotNull(Iterable<? extends Object>... p0){}
}
