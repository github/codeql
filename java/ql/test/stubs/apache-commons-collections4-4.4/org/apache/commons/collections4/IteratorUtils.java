// Generated automatically from org.apache.commons.collections4.IteratorUtils for testing purposes

package org.apache.commons.collections4;

import java.util.Collection;
import java.util.Comparator;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import org.apache.commons.collections4.Closure;
import org.apache.commons.collections4.MapIterator;
import org.apache.commons.collections4.OrderedIterator;
import org.apache.commons.collections4.OrderedMapIterator;
import org.apache.commons.collections4.Predicate;
import org.apache.commons.collections4.ResettableIterator;
import org.apache.commons.collections4.ResettableListIterator;
import org.apache.commons.collections4.Transformer;
import org.apache.commons.collections4.iterators.BoundedIterator;
import org.apache.commons.collections4.iterators.NodeListIterator;
import org.apache.commons.collections4.iterators.SkippingIterator;
import org.apache.commons.collections4.iterators.ZippingIterator;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class IteratorUtils
{
    protected IteratorUtils() {}
    public static <E> BoundedIterator<E> boundedIterator(Iterator<? extends E> p0, long p1){ return null; }
    public static <E> BoundedIterator<E> boundedIterator(Iterator<? extends E> p0, long p1, long p2){ return null; }
    public static <E> E find(Iterator<E> p0, Predicate<? super E> p1){ return null; }
    public static <E> E first(Iterator<E> p0){ return null; }
    public static <E> E forEachButLast(Iterator<E> p0, Closure<? super E> p1){ return null; }
    public static <E> E get(Iterator<E> p0, int p1){ return null; }
    public static <E> E[] toArray(Iterator<? extends E> p0, Class<E> p1){ return null; }
    public static <E> Enumeration<E> asEnumeration(Iterator<? extends E> p0){ return null; }
    public static <E> Iterable<E> asIterable(Iterator<? extends E> p0){ return null; }
    public static <E> Iterable<E> asMultipleUseIterable(Iterator<? extends E> p0){ return null; }
    public static <E> Iterator<E> asIterator(Enumeration<? extends E> p0){ return null; }
    public static <E> Iterator<E> asIterator(Enumeration<? extends E> p0, Collection<? super E> p1){ return null; }
    public static <E> Iterator<E> chainedIterator(Collection<Iterator<? extends E>> p0){ return null; }
    public static <E> Iterator<E> chainedIterator(Iterator<? extends E> p0, Iterator<? extends E> p1){ return null; }
    public static <E> Iterator<E> chainedIterator(Iterator<? extends E>... p0){ return null; }
    public static <E> Iterator<E> collatedIterator(Comparator<? super E> p0, Collection<Iterator<? extends E>> p1){ return null; }
    public static <E> Iterator<E> collatedIterator(Comparator<? super E> p0, Iterator<? extends E> p1, Iterator<? extends E> p2){ return null; }
    public static <E> Iterator<E> collatedIterator(Comparator<? super E> p0, Iterator<? extends E>... p1){ return null; }
    public static <E> Iterator<E> filteredIterator(Iterator<? extends E> p0, Predicate<? super E> p1){ return null; }
    public static <E> Iterator<E> objectGraphIterator(E p0, Transformer<? super E, ? extends E> p1){ return null; }
    public static <E> Iterator<E> peekingIterator(Iterator<? extends E> p0){ return null; }
    public static <E> Iterator<E> pushbackIterator(Iterator<? extends E> p0){ return null; }
    public static <E> Iterator<E> unmodifiableIterator(Iterator<E> p0){ return null; }
    public static <E> List<E> toList(Iterator<? extends E> p0){ return null; }
    public static <E> List<E> toList(Iterator<? extends E> p0, int p1){ return null; }
    public static <E> ListIterator<E> filteredListIterator(ListIterator<? extends E> p0, Predicate<? super E> p1){ return null; }
    public static <E> ListIterator<E> singletonListIterator(E p0){ return null; }
    public static <E> ListIterator<E> toListIterator(Iterator<? extends E> p0){ return null; }
    public static <E> ListIterator<E> unmodifiableListIterator(ListIterator<E> p0){ return null; }
    public static <E> OrderedIterator<E> emptyOrderedIterator(){ return null; }
    public static <E> ResettableIterator<E> arrayIterator(E... p0){ return null; }
    public static <E> ResettableIterator<E> arrayIterator(E[] p0, int p1){ return null; }
    public static <E> ResettableIterator<E> arrayIterator(E[] p0, int p1, int p2){ return null; }
    public static <E> ResettableIterator<E> arrayIterator(Object p0){ return null; }
    public static <E> ResettableIterator<E> arrayIterator(Object p0, int p1){ return null; }
    public static <E> ResettableIterator<E> arrayIterator(Object p0, int p1, int p2){ return null; }
    public static <E> ResettableIterator<E> emptyIterator(){ return null; }
    public static <E> ResettableIterator<E> loopingIterator(Collection<? extends E> p0){ return null; }
    public static <E> ResettableIterator<E> singletonIterator(E p0){ return null; }
    public static <E> ResettableListIterator<E> arrayListIterator(E... p0){ return null; }
    public static <E> ResettableListIterator<E> arrayListIterator(E[] p0, int p1){ return null; }
    public static <E> ResettableListIterator<E> arrayListIterator(E[] p0, int p1, int p2){ return null; }
    public static <E> ResettableListIterator<E> arrayListIterator(Object p0){ return null; }
    public static <E> ResettableListIterator<E> arrayListIterator(Object p0, int p1){ return null; }
    public static <E> ResettableListIterator<E> arrayListIterator(Object p0, int p1, int p2){ return null; }
    public static <E> ResettableListIterator<E> emptyListIterator(){ return null; }
    public static <E> ResettableListIterator<E> loopingListIterator(List<E> p0){ return null; }
    public static <E> SkippingIterator<E> skippingIterator(Iterator<E> p0, long p1){ return null; }
    public static <E> String toString(Iterator<E> p0){ return null; }
    public static <E> String toString(Iterator<E> p0, Transformer<? super E, String> p1){ return null; }
    public static <E> String toString(Iterator<E> p0, Transformer<? super E, String> p1, String p2, String p3, String p4){ return null; }
    public static <E> ZippingIterator<E> zippingIterator(Iterator<? extends E> p0, Iterator<? extends E> p1){ return null; }
    public static <E> ZippingIterator<E> zippingIterator(Iterator<? extends E> p0, Iterator<? extends E> p1, Iterator<? extends E> p2){ return null; }
    public static <E> ZippingIterator<E> zippingIterator(Iterator<? extends E>... p0){ return null; }
    public static <E> boolean contains(Iterator<E> p0, Object p1){ return false; }
    public static <E> boolean matchesAll(Iterator<E> p0, Predicate<? super E> p1){ return false; }
    public static <E> boolean matchesAny(Iterator<E> p0, Predicate<? super E> p1){ return false; }
    public static <E> int indexOf(Iterator<E> p0, Predicate<? super E> p1){ return 0; }
    public static <E> void forEach(Iterator<E> p0, Closure<? super E> p1){}
    public static <I, O> Iterator<O> transformedIterator(Iterator<? extends I> p0, Transformer<? super I, ? extends O> p1){ return null; }
    public static <K, V> MapIterator<K, V> emptyMapIterator(){ return null; }
    public static <K, V> MapIterator<K, V> unmodifiableMapIterator(MapIterator<K, V> p0){ return null; }
    public static <K, V> OrderedMapIterator<K, V> emptyOrderedMapIterator(){ return null; }
    public static Iterator<? extends Object> getIterator(Object p0){ return null; }
    public static MapIterator EMPTY_MAP_ITERATOR = null;
    public static NodeListIterator nodeListIterator(Node p0){ return null; }
    public static NodeListIterator nodeListIterator(NodeList p0){ return null; }
    public static Object[] toArray(Iterator<? extends Object> p0){ return null; }
    public static OrderedIterator EMPTY_ORDERED_ITERATOR = null;
    public static OrderedMapIterator EMPTY_ORDERED_MAP_ITERATOR = null;
    public static ResettableIterator EMPTY_ITERATOR = null;
    public static ResettableListIterator EMPTY_LIST_ITERATOR = null;
    public static boolean isEmpty(Iterator<? extends Object> p0){ return false; }
    public static int size(Iterator<? extends Object> p0){ return 0; }
}
