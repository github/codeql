// Generated automatically from org.apache.commons.collections4.CollectionUtils for testing purposes

package org.apache.commons.collections4;

import java.util.Collection;
import java.util.Comparator;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import org.apache.commons.collections4.Closure;
import org.apache.commons.collections4.Equator;
import org.apache.commons.collections4.Predicate;
import org.apache.commons.collections4.Transformer;

public class CollectionUtils
{
    protected CollectionUtils() {}
    public static <C> Collection<C> predicatedCollection(Collection<C> p0, Predicate<? super C> p1){ return null; }
    public static <C> Collection<C> retainAll(Collection<C> p0, Collection<? extends Object> p1){ return null; }
    public static <C> Collection<C> synchronizedCollection(Collection<C> p0){ return null; }
    public static <C> Collection<C> unmodifiableCollection(Collection<? extends C> p0){ return null; }
    public static <C> boolean addAll(Collection<C> p0, C... p1){ return false; }
    public static <C> boolean addAll(Collection<C> p0, Enumeration<? extends C> p1){ return false; }
    public static <C> boolean addAll(Collection<C> p0, Iterable<? extends C> p1){ return false; }
    public static <C> boolean addAll(Collection<C> p0, Iterator<? extends C> p1){ return false; }
    public static <C> boolean exists(Iterable<C> p0, Predicate<? super C> p1){ return false; }
    public static <C> boolean matchesAll(Iterable<C> p0, Predicate<? super C> p1){ return false; }
    public static <C> int countMatches(Iterable<C> p0, Predicate<? super C> p1){ return 0; }
    public static <C> void transform(Collection<C> p0, Transformer<? super C, ? extends C> p1){}
    public static <E> Collection<E> removeAll(Collection<E> p0, Collection<? extends Object> p1){ return null; }
    public static <E> Collection<E> removeAll(Iterable<E> p0, Iterable<? extends E> p1, Equator<? super E> p2){ return null; }
    public static <E> Collection<E> retainAll(Iterable<E> p0, Iterable<? extends E> p1, Equator<? super E> p2){ return null; }
    public static <E> Collection<E> transformingCollection(Collection<E> p0, Transformer<? super E, ? extends E> p1){ return null; }
    public static <E> Collection<List<E>> permutations(Collection<E> p0){ return null; }
    public static <E> E extractSingleton(Collection<E> p0){ return null; }
    public static <E> boolean isEqualCollection(Collection<? extends E> p0, Collection<? extends E> p1, Equator<? super E> p2){ return false; }
    public static <I, O, R extends Collection<? super O>> R collect(Iterable<? extends I> p0, Transformer<? super I, ? extends O> p1, R p2){ return null; }
    public static <I, O, R extends Collection<? super O>> R collect(Iterator<? extends I> p0, Transformer<? super I, ? extends O> p1, R p2){ return null; }
    public static <I, O> Collection<O> collect(Iterable<I> p0, Transformer<? super I, ? extends O> p1){ return null; }
    public static <I, O> Collection<O> collect(Iterator<I> p0, Transformer<? super I, ? extends O> p1){ return null; }
    public static <K, V> Map.Entry<K, V> get(Map<K, V> p0, int p1){ return null; }
    public static <O extends Comparable<? super O>> List<O> collate(Iterable<? extends O> p0, Iterable<? extends O> p1){ return null; }
    public static <O extends Comparable<? super O>> List<O> collate(Iterable<? extends O> p0, Iterable<? extends O> p1, boolean p2){ return null; }
    public static <O, R extends Collection<? super O>> R select(Iterable<? extends O> p0, Predicate<? super O> p1, R p2){ return null; }
    public static <O, R extends Collection<? super O>> R select(Iterable<? extends O> p0, Predicate<? super O> p1, R p2, R p3){ return null; }
    public static <O, R extends Collection<? super O>> R selectRejected(Iterable<? extends O> p0, Predicate<? super O> p1, R p2){ return null; }
    public static <O> Collection<O> disjunction(Iterable<? extends O> p0, Iterable<? extends O> p1){ return null; }
    public static <O> Collection<O> intersection(Iterable<? extends O> p0, Iterable<? extends O> p1){ return null; }
    public static <O> Collection<O> select(Iterable<? extends O> p0, Predicate<? super O> p1){ return null; }
    public static <O> Collection<O> selectRejected(Iterable<? extends O> p0, Predicate<? super O> p1){ return null; }
    public static <O> Collection<O> subtract(Iterable<? extends O> p0, Iterable<? extends O> p1){ return null; }
    public static <O> Collection<O> subtract(Iterable<? extends O> p0, Iterable<? extends O> p1, Predicate<O> p2){ return null; }
    public static <O> Collection<O> union(Iterable<? extends O> p0, Iterable<? extends O> p1){ return null; }
    public static <O> List<O> collate(Iterable<? extends O> p0, Iterable<? extends O> p1, Comparator<? super O> p2){ return null; }
    public static <O> List<O> collate(Iterable<? extends O> p0, Iterable<? extends O> p1, Comparator<? super O> p2, boolean p3){ return null; }
    public static <O> Map<O, Integer> getCardinalityMap(Iterable<? extends O> p0){ return null; }
    public static <O> int cardinality(O p0, Iterable<? super O> p1){ return 0; }
    public static <T, C extends Closure<? super T>> C forAllDo(Iterable<T> p0, C p1){ return null; }
    public static <T, C extends Closure<? super T>> C forAllDo(Iterator<T> p0, C p1){ return null; }
    public static <T, C extends Closure<? super T>> T forAllButLastDo(Iterable<T> p0, C p1){ return null; }
    public static <T, C extends Closure<? super T>> T forAllButLastDo(Iterator<T> p0, C p1){ return null; }
    public static <T> Collection<T> emptyCollection(){ return null; }
    public static <T> Collection<T> emptyIfNull(Collection<T> p0){ return null; }
    public static <T> T find(Iterable<T> p0, Predicate<? super T> p1){ return null; }
    public static <T> T get(Iterable<T> p0, int p1){ return null; }
    public static <T> T get(Iterator<T> p0, int p1){ return null; }
    public static <T> boolean addIgnoreNull(Collection<T> p0, T p1){ return false; }
    public static <T> boolean containsAny(Collection<? extends Object> p0, T... p1){ return false; }
    public static <T> boolean filter(Iterable<T> p0, Predicate<? super T> p1){ return false; }
    public static <T> boolean filterInverse(Iterable<T> p0, Predicate<? super T> p1){ return false; }
    public static Collection EMPTY_COLLECTION = null;
    public static Object get(Object p0, int p1){ return null; }
    public static boolean containsAll(Collection<? extends Object> p0, Collection<? extends Object> p1){ return false; }
    public static boolean containsAny(Collection<? extends Object> p0, Collection<? extends Object> p1){ return false; }
    public static boolean isEmpty(Collection<? extends Object> p0){ return false; }
    public static boolean isEqualCollection(Collection<? extends Object> p0, Collection<? extends Object> p1){ return false; }
    public static boolean isFull(Collection<? extends Object> p0){ return false; }
    public static boolean isNotEmpty(Collection<? extends Object> p0){ return false; }
    public static boolean isProperSubCollection(Collection<? extends Object> p0, Collection<? extends Object> p1){ return false; }
    public static boolean isSubCollection(Collection<? extends Object> p0, Collection<? extends Object> p1){ return false; }
    public static boolean sizeIsEmpty(Object p0){ return false; }
    public static int maxSize(Collection<? extends Object> p0){ return 0; }
    public static int size(Object p0){ return 0; }
    public static void reverseArray(Object[] p0){}
    static void checkIndexBounds(int p0){}
}
