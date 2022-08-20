// Generated automatically from org.apache.commons.collections4.multiset.UnmodifiableMultiSet for testing purposes

package org.apache.commons.collections4.multiset;

import java.util.Collection;
import java.util.Iterator;
import java.util.Set;
import java.util.function.Predicate;
import org.apache.commons.collections4.MultiSet;
import org.apache.commons.collections4.Unmodifiable;
import org.apache.commons.collections4.multiset.AbstractMultiSetDecorator;

public class UnmodifiableMultiSet<E> extends AbstractMultiSetDecorator<E> implements Unmodifiable
{
    protected UnmodifiableMultiSet() {}
    public Iterator<E> iterator(){ return null; }
    public Set<E> uniqueSet(){ return null; }
    public Set<MultiSet.Entry<E>> entrySet(){ return null; }
    public boolean add(E p0){ return false; }
    public boolean addAll(Collection<? extends E> p0){ return false; }
    public boolean remove(Object p0){ return false; }
    public boolean removeAll(Collection<? extends Object> p0){ return false; }
    public boolean removeIf(Predicate<? super E> p0){ return false; }
    public boolean retainAll(Collection<? extends Object> p0){ return false; }
    public int add(E p0, int p1){ return 0; }
    public int remove(Object p0, int p1){ return 0; }
    public int setCount(E p0, int p1){ return 0; }
    public static <E> MultiSet<E> unmodifiableMultiSet(MultiSet<? extends E> p0){ return null; }
    public void clear(){}
}
