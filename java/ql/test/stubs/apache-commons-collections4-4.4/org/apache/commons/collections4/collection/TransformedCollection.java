// Generated automatically from org.apache.commons.collections4.collection.TransformedCollection for testing purposes

package org.apache.commons.collections4.collection;

import java.util.Collection;
import org.apache.commons.collections4.Transformer;
import org.apache.commons.collections4.collection.AbstractCollectionDecorator;

public class TransformedCollection<E> extends AbstractCollectionDecorator<E>
{
    protected TransformedCollection() {}
    protected Collection<E> transform(Collection<? extends E> p0){ return null; }
    protected E transform(E p0){ return null; }
    protected TransformedCollection(Collection<E> p0, Transformer<? super E, ? extends E> p1){}
    protected final Transformer<? super E, ? extends E> transformer = null;
    public boolean add(E p0){ return false; }
    public boolean addAll(Collection<? extends E> p0){ return false; }
    public static <E> TransformedCollection<E> transformedCollection(Collection<E> p0, Transformer<? super E, ? extends E> p1){ return null; }
    public static <E> TransformedCollection<E> transformingCollection(Collection<E> p0, Transformer<? super E, ? extends E> p1){ return null; }
}
