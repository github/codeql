// Generated automatically from org.apache.commons.collections4.bag.UnmodifiableBag for testing purposes

package org.apache.commons.collections4.bag;

import java.util.Collection;
import java.util.Iterator;
import java.util.Set;
import java.util.function.Predicate;
import org.apache.commons.collections4.Bag;
import org.apache.commons.collections4.Unmodifiable;
import org.apache.commons.collections4.bag.AbstractBagDecorator;

public class UnmodifiableBag<E> extends AbstractBagDecorator<E> implements Unmodifiable
{
    protected UnmodifiableBag() {}
    public Iterator<E> iterator(){ return null; }
    public Set<E> uniqueSet(){ return null; }
    public boolean add(E p0){ return false; }
    public boolean add(E p0, int p1){ return false; }
    public boolean addAll(Collection<? extends E> p0){ return false; }
    public boolean remove(Object p0){ return false; }
    public boolean remove(Object p0, int p1){ return false; }
    public boolean removeAll(Collection<? extends Object> p0){ return false; }
    public boolean removeIf(Predicate<? super E> p0){ return false; }
    public boolean retainAll(Collection<? extends Object> p0){ return false; }
    public static <E> Bag<E> unmodifiableBag(Bag<? extends E> p0){ return null; }
    public void clear(){}
}
