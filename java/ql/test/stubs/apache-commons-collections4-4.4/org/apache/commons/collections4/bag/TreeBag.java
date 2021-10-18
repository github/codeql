// Generated automatically from org.apache.commons.collections4.bag.TreeBag for testing purposes

package org.apache.commons.collections4.bag;

import java.io.Serializable;
import java.util.Collection;
import java.util.Comparator;
import java.util.SortedMap;
import org.apache.commons.collections4.SortedBag;
import org.apache.commons.collections4.bag.AbstractMapBag;

public class TreeBag<E> extends AbstractMapBag<E> implements Serializable, SortedBag<E>
{
    protected SortedMap<E, AbstractMapBag.MutableInteger> getMap(){ return null; }
    public Comparator<? super E> comparator(){ return null; }
    public E first(){ return null; }
    public E last(){ return null; }
    public TreeBag(){}
    public TreeBag(Collection<? extends E> p0){}
    public TreeBag(Comparator<? super E> p0){}
    public boolean add(E p0){ return false; }
}
