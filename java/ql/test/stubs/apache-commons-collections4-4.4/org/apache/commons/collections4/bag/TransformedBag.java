// Generated automatically from org.apache.commons.collections4.bag.TransformedBag for testing purposes

package org.apache.commons.collections4.bag;

import java.util.Set;
import org.apache.commons.collections4.Bag;
import org.apache.commons.collections4.Transformer;
import org.apache.commons.collections4.collection.TransformedCollection;

public class TransformedBag<E> extends TransformedCollection<E> implements Bag<E>
{
    protected TransformedBag() {}
    protected Bag<E> getBag(){ return null; }
    protected TransformedBag(Bag<E> p0, Transformer<? super E, ? extends E> p1){}
    public Set<E> uniqueSet(){ return null; }
    public boolean add(E p0, int p1){ return false; }
    public boolean equals(Object p0){ return false; }
    public boolean remove(Object p0, int p1){ return false; }
    public int getCount(Object p0){ return 0; }
    public int hashCode(){ return 0; }
    public static <E> Bag<E> transformedBag(Bag<E> p0, Transformer<? super E, ? extends E> p1){ return null; }
    public static <E> Bag<E> transformingBag(Bag<E> p0, Transformer<? super E, ? extends E> p1){ return null; }
}
