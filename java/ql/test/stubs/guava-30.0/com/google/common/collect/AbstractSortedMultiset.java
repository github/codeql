// Generated automatically from com.google.common.collect.AbstractSortedMultiset for testing purposes

package com.google.common.collect;

import com.google.common.collect.AbstractMultiset;
import com.google.common.collect.BoundType;
import com.google.common.collect.Multiset;
import com.google.common.collect.SortedMultiset;
import java.util.Comparator;
import java.util.NavigableSet;

abstract class AbstractSortedMultiset<E> extends AbstractMultiset<E> implements SortedMultiset<E>
{
    public Comparator<? super E> comparator(){ return null; }
    public Multiset.Entry<E> firstEntry(){ return null; }
    public Multiset.Entry<E> lastEntry(){ return null; }
    public Multiset.Entry<E> pollFirstEntry(){ return null; }
    public Multiset.Entry<E> pollLastEntry(){ return null; }
    public NavigableSet<E> elementSet(){ return null; }
    public SortedMultiset<E> descendingMultiset(){ return null; }
    public SortedMultiset<E> subMultiset(E p0, BoundType p1, E p2, BoundType p3){ return null; }
}
