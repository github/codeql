// Generated automatically from com.google.common.collect.TreeMultiset for testing purposes

package com.google.common.collect;

import com.google.common.collect.AbstractSortedMultiset;
import com.google.common.collect.BoundType;
import com.google.common.collect.SortedMultiset;
import java.io.Serializable;
import java.util.Comparator;
import java.util.Iterator;
import java.util.function.ObjIntConsumer;

public class TreeMultiset<E> extends AbstractSortedMultiset<E> implements Serializable
{
    protected TreeMultiset() {}
    public Iterator<E> iterator(){ return null; }
    public SortedMultiset<E> headMultiset(E p0, BoundType p1){ return null; }
    public SortedMultiset<E> tailMultiset(E p0, BoundType p1){ return null; }
    public boolean setCount(E p0, int p1, int p2){ return false; }
    public int add(E p0, int p1){ return 0; }
    public int count(Object p0){ return 0; }
    public int remove(Object p0, int p1){ return 0; }
    public int setCount(E p0, int p1){ return 0; }
    public int size(){ return 0; }
    public static <E extends Comparable> TreeMultiset<E> create(){ return null; }
    public static <E extends Comparable> TreeMultiset<E> create(Iterable<? extends E> p0){ return null; }
    public static <E> TreeMultiset<E> create(Comparator<? super E> p0){ return null; }
    public void clear(){}
    public void forEachEntry(ObjIntConsumer<? super E> p0){}
}
