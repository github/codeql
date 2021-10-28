// Generated automatically from org.apache.commons.collections4.list.LazyList for testing purposes

package org.apache.commons.collections4.list;

import java.util.List;
import org.apache.commons.collections4.Factory;
import org.apache.commons.collections4.Transformer;
import org.apache.commons.collections4.list.AbstractSerializableListDecorator;

public class LazyList<E> extends AbstractSerializableListDecorator<E>
{
    protected LazyList() {}
    protected LazyList(List<E> p0, Factory<? extends E> p1){}
    protected LazyList(List<E> p0, Transformer<Integer, ? extends E> p1){}
    public E get(int p0){ return null; }
    public List<E> subList(int p0, int p1){ return null; }
    public static <E> LazyList<E> lazyList(List<E> p0, Factory<? extends E> p1){ return null; }
    public static <E> LazyList<E> lazyList(List<E> p0, Transformer<Integer, ? extends E> p1){ return null; }
}
