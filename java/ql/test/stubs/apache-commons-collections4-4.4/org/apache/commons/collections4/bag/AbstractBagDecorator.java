// Generated automatically from org.apache.commons.collections4.bag.AbstractBagDecorator for testing purposes

package org.apache.commons.collections4.bag;

import java.util.Set;
import org.apache.commons.collections4.Bag;
import org.apache.commons.collections4.collection.AbstractCollectionDecorator;

abstract public class AbstractBagDecorator<E> extends AbstractCollectionDecorator<E> implements Bag<E>
{
    protected AbstractBagDecorator(){}
    protected AbstractBagDecorator(Bag<E> p0){}
    protected Bag<E> decorated(){ return null; }
    public Set<E> uniqueSet(){ return null; }
    public boolean add(E p0, int p1){ return false; }
    public boolean equals(Object p0){ return false; }
    public boolean remove(Object p0, int p1){ return false; }
    public int getCount(Object p0){ return 0; }
    public int hashCode(){ return 0; }
}
