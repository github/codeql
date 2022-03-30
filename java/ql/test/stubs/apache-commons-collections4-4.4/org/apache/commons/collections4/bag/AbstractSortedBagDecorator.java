// Generated automatically from org.apache.commons.collections4.bag.AbstractSortedBagDecorator for testing purposes

package org.apache.commons.collections4.bag;

import java.util.Comparator;
import org.apache.commons.collections4.SortedBag;
import org.apache.commons.collections4.bag.AbstractBagDecorator;

abstract public class AbstractSortedBagDecorator<E> extends AbstractBagDecorator<E> implements SortedBag<E>
{
    protected AbstractSortedBagDecorator(){}
    protected AbstractSortedBagDecorator(SortedBag<E> p0){}
    protected SortedBag<E> decorated(){ return null; }
    public Comparator<? super E> comparator(){ return null; }
    public E first(){ return null; }
    public E last(){ return null; }
}
