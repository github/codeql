// Generated automatically from com.google.common.collect.ImmutableCollection for testing purposes

package com.google.common.collect;

import com.google.common.collect.ImmutableList;
import com.google.common.collect.UnmodifiableIterator;
import java.io.Serializable;
import java.util.AbstractCollection;
import java.util.Collection;
import java.util.Iterator;
import java.util.Spliterator;
import java.util.function.Predicate;

abstract public class ImmutableCollection<E> extends AbstractCollection<E> implements Serializable
{
    ImmutableCollection(){}
    Object writeReplace(){ return null; }
    Object[] internalArray(){ return null; }
    abstract boolean isPartialView();
    abstract static public class Builder<E>
    {
        Builder(){}
        public ImmutableCollection.Builder<E> add(E... p0){ return null; }
        public ImmutableCollection.Builder<E> addAll(Iterable<? extends E> p0){ return null; }
        public ImmutableCollection.Builder<E> addAll(Iterator<? extends E> p0){ return null; }
        public abstract ImmutableCollection.Builder<E> add(E p0);
        public abstract ImmutableCollection<E> build();
        static int DEFAULT_INITIAL_CAPACITY = 0;
        static int expandedCapacity(int p0, int p1){ return 0; }
    }
    int copyIntoArray(Object[] p0, int p1){ return 0; }
    int internalArrayEnd(){ return 0; }
    int internalArrayStart(){ return 0; }
    public ImmutableList<E> asList(){ return null; }
    public Spliterator<E> spliterator(){ return null; }
    public abstract UnmodifiableIterator<E> iterator();
    public abstract boolean contains(Object p0);
    public final <T> T[] toArray(T[] p0){ return null; }
    public final Object[] toArray(){ return null; }
    public final boolean add(E p0){ return false; }
    public final boolean addAll(Collection<? extends E> p0){ return false; }
    public final boolean remove(Object p0){ return false; }
    public final boolean removeAll(Collection<? extends Object> p0){ return false; }
    public final boolean removeIf(Predicate<? super E> p0){ return false; }
    public final boolean retainAll(Collection<? extends Object> p0){ return false; }
    public final void clear(){}
    static int SPLITERATOR_CHARACTERISTICS = 0;
}
