// Generated automatically from com.google.common.collect.SortedMultiset for testing purposes

package com.google.common.collect;

import com.google.common.collect.BoundType;
import com.google.common.collect.Multiset;
import com.google.common.collect.SortedIterable;
import com.google.common.collect.SortedMultisetBridge;
import java.util.Comparator;
import java.util.Iterator;
import java.util.NavigableSet;
import java.util.Set;

public interface SortedMultiset<E> extends SortedIterable<E>, SortedMultisetBridge<E>
{
    Comparator<? super E> comparator();
    Iterator<E> iterator();
    Multiset.Entry<E> firstEntry();
    Multiset.Entry<E> lastEntry();
    Multiset.Entry<E> pollFirstEntry();
    Multiset.Entry<E> pollLastEntry();
    NavigableSet<E> elementSet();
    Set<Multiset.Entry<E>> entrySet();
    SortedMultiset<E> descendingMultiset();
    SortedMultiset<E> headMultiset(E p0, BoundType p1);
    SortedMultiset<E> subMultiset(E p0, BoundType p1, E p2, BoundType p3);
    SortedMultiset<E> tailMultiset(E p0, BoundType p1);
}
