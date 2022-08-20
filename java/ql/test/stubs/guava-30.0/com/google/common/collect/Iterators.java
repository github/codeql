// Generated automatically from com.google.common.collect.Iterators for testing purposes

package com.google.common.collect;

import com.google.common.base.Function;
import com.google.common.base.Optional;
import com.google.common.base.Predicate;
import com.google.common.collect.PeekingIterator;
import com.google.common.collect.UnmodifiableIterator;
import java.util.Collection;
import java.util.Comparator;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;

public class Iterators
{
    protected Iterators() {}
    public static <F, T> Iterator<T> transform(Iterator<F> p0, Function<? super F, ? extends T> p1){ return null; }
    public static <T> Enumeration<T> asEnumeration(Iterator<T> p0){ return null; }
    public static <T> Iterator<T> concat(Iterator<? extends Iterator<? extends T>> p0){ return null; }
    public static <T> Iterator<T> concat(Iterator<? extends T> p0, Iterator<? extends T> p1){ return null; }
    public static <T> Iterator<T> concat(Iterator<? extends T> p0, Iterator<? extends T> p1, Iterator<? extends T> p2){ return null; }
    public static <T> Iterator<T> concat(Iterator<? extends T> p0, Iterator<? extends T> p1, Iterator<? extends T> p2, Iterator<? extends T> p3){ return null; }
    public static <T> Iterator<T> concat(Iterator<? extends T>... p0){ return null; }
    public static <T> Iterator<T> consumingIterator(Iterator<T> p0){ return null; }
    public static <T> Iterator<T> cycle(Iterable<T> p0){ return null; }
    public static <T> Iterator<T> cycle(T... p0){ return null; }
    public static <T> Iterator<T> limit(Iterator<T> p0, int p1){ return null; }
    public static <T> Optional<T> tryFind(Iterator<T> p0, Predicate<? super T> p1){ return null; }
    public static <T> PeekingIterator<T> peekingIterator(Iterator<? extends T> p0){ return null; }
    public static <T> PeekingIterator<T> peekingIterator(PeekingIterator<T> p0){ return null; }
    public static <T> T find(Iterator<? extends T> p0, Predicate<? super T> p1, T p2){ return null; }
    public static <T> T find(Iterator<T> p0, Predicate<? super T> p1){ return null; }
    public static <T> T get(Iterator<? extends T> p0, int p1, T p2){ return null; }
    public static <T> T get(Iterator<T> p0, int p1){ return null; }
    public static <T> T getLast(Iterator<? extends T> p0, T p1){ return null; }
    public static <T> T getLast(Iterator<T> p0){ return null; }
    public static <T> T getNext(Iterator<? extends T> p0, T p1){ return null; }
    public static <T> T getOnlyElement(Iterator<? extends T> p0, T p1){ return null; }
    public static <T> T getOnlyElement(Iterator<T> p0){ return null; }
    public static <T> T[] toArray(Iterator<? extends T> p0, Class<T> p1){ return null; }
    public static <T> UnmodifiableIterator<List<T>> paddedPartition(Iterator<T> p0, int p1){ return null; }
    public static <T> UnmodifiableIterator<List<T>> partition(Iterator<T> p0, int p1){ return null; }
    public static <T> UnmodifiableIterator<T> filter(Iterator<? extends Object> p0, Class<T> p1){ return null; }
    public static <T> UnmodifiableIterator<T> filter(Iterator<T> p0, Predicate<? super T> p1){ return null; }
    public static <T> UnmodifiableIterator<T> forArray(T... p0){ return null; }
    public static <T> UnmodifiableIterator<T> forEnumeration(Enumeration<T> p0){ return null; }
    public static <T> UnmodifiableIterator<T> mergeSorted(Iterable<? extends Iterator<? extends T>> p0, Comparator<? super T> p1){ return null; }
    public static <T> UnmodifiableIterator<T> singletonIterator(T p0){ return null; }
    public static <T> UnmodifiableIterator<T> unmodifiableIterator(Iterator<? extends T> p0){ return null; }
    public static <T> UnmodifiableIterator<T> unmodifiableIterator(UnmodifiableIterator<T> p0){ return null; }
    public static <T> boolean addAll(Collection<T> p0, Iterator<? extends T> p1){ return false; }
    public static <T> boolean all(Iterator<T> p0, Predicate<? super T> p1){ return false; }
    public static <T> boolean any(Iterator<T> p0, Predicate<? super T> p1){ return false; }
    public static <T> boolean removeIf(Iterator<T> p0, Predicate<? super T> p1){ return false; }
    public static <T> int indexOf(Iterator<T> p0, Predicate<? super T> p1){ return 0; }
    public static String toString(Iterator<? extends Object> p0){ return null; }
    public static boolean contains(Iterator<? extends Object> p0, Object p1){ return false; }
    public static boolean elementsEqual(Iterator<? extends Object> p0, Iterator<? extends Object> p1){ return false; }
    public static boolean removeAll(Iterator<? extends Object> p0, Collection<? extends Object> p1){ return false; }
    public static boolean retainAll(Iterator<? extends Object> p0, Collection<? extends Object> p1){ return false; }
    public static int advance(Iterator<? extends Object> p0, int p1){ return 0; }
    public static int frequency(Iterator<? extends Object> p0, Object p1){ return 0; }
    public static int size(Iterator<? extends Object> p0){ return 0; }
}
