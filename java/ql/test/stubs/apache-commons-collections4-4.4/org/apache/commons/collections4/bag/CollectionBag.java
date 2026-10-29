// Generated automatically from org.apache.commons.collections4.bag.CollectionBag for testing purposes

package org.apache.commons.collections4.bag;

import java.util.Collection;
import org.apache.commons.collections4.Bag;
import org.apache.commons.collections4.bag.AbstractBagDecorator;

public class CollectionBag<E> extends AbstractBagDecorator<E>
{
    protected CollectionBag() {}
    public CollectionBag(Bag<E> p0){}
    public boolean add(E p0){ return false; }
    public boolean add(E p0, int p1){ return false; }
    public boolean addAll(Collection<? extends E> p0){ return false; }
    public boolean containsAll(Collection<? extends Object> p0){ return false; }
    public boolean remove(Object p0){ return false; }
    public boolean removeAll(Collection<? extends Object> p0){ return false; }
    public boolean retainAll(Collection<? extends Object> p0){ return false; }
    public static <E> Bag<E> collectionBag(Bag<E> p0){ return null; }
}
