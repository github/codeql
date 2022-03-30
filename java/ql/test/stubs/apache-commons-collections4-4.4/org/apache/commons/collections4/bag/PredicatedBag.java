// Generated automatically from org.apache.commons.collections4.bag.PredicatedBag for testing purposes

package org.apache.commons.collections4.bag;

import java.util.Set;
import org.apache.commons.collections4.Bag;
import org.apache.commons.collections4.Predicate;
import org.apache.commons.collections4.collection.PredicatedCollection;

public class PredicatedBag<E> extends PredicatedCollection<E> implements Bag<E>
{
    protected PredicatedBag() {}
    protected Bag<E> decorated(){ return null; }
    protected PredicatedBag(Bag<E> p0, Predicate<? super E> p1){}
    public Set<E> uniqueSet(){ return null; }
    public boolean add(E p0, int p1){ return false; }
    public boolean equals(Object p0){ return false; }
    public boolean remove(Object p0, int p1){ return false; }
    public int getCount(Object p0){ return 0; }
    public int hashCode(){ return 0; }
    public static <E> PredicatedBag<E> predicatedBag(Bag<E> p0, Predicate<? super E> p1){ return null; }
}
