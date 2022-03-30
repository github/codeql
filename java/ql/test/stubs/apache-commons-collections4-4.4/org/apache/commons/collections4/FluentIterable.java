// Generated automatically from org.apache.commons.collections4.FluentIterable for testing purposes

package org.apache.commons.collections4;

import java.util.Collection;
import java.util.Comparator;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;
import org.apache.commons.collections4.Closure;
import org.apache.commons.collections4.Predicate;
import org.apache.commons.collections4.Transformer;

public class FluentIterable<E> implements Iterable<E>
{
    FluentIterable(){}
    public <O> FluentIterable<O> transform(Transformer<? super E, ? extends O> p0){ return null; }
    public E get(int p0){ return null; }
    public E[] toArray(Class<E> p0){ return null; }
    public Enumeration<E> asEnumeration(){ return null; }
    public FluentIterable<E> append(E... p0){ return null; }
    public FluentIterable<E> append(Iterable<? extends E> p0){ return null; }
    public FluentIterable<E> collate(Iterable<? extends E> p0){ return null; }
    public FluentIterable<E> collate(Iterable<? extends E> p0, Comparator<? super E> p1){ return null; }
    public FluentIterable<E> eval(){ return null; }
    public FluentIterable<E> filter(Predicate<? super E> p0){ return null; }
    public FluentIterable<E> limit(long p0){ return null; }
    public FluentIterable<E> loop(){ return null; }
    public FluentIterable<E> reverse(){ return null; }
    public FluentIterable<E> skip(long p0){ return null; }
    public FluentIterable<E> unique(){ return null; }
    public FluentIterable<E> unmodifiable(){ return null; }
    public FluentIterable<E> zip(Iterable<? extends E> p0){ return null; }
    public FluentIterable<E> zip(Iterable<? extends E>... p0){ return null; }
    public Iterator<E> iterator(){ return null; }
    public List<E> toList(){ return null; }
    public String toString(){ return null; }
    public boolean allMatch(Predicate<? super E> p0){ return false; }
    public boolean anyMatch(Predicate<? super E> p0){ return false; }
    public boolean contains(Object p0){ return false; }
    public boolean isEmpty(){ return false; }
    public int size(){ return 0; }
    public static <T> FluentIterable<T> empty(){ return null; }
    public static <T> FluentIterable<T> of(Iterable<T> p0){ return null; }
    public static <T> FluentIterable<T> of(T p0){ return null; }
    public static <T> FluentIterable<T> of(T... p0){ return null; }
    public void copyInto(Collection<? super E> p0){}
    public void forEach(Closure<? super E> p0){}
}
