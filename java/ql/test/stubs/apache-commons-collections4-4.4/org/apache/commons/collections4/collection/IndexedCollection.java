// Generated automatically from org.apache.commons.collections4.collection.IndexedCollection for testing purposes

package org.apache.commons.collections4.collection;

import java.util.Collection;
import java.util.function.Predicate;
import org.apache.commons.collections4.MultiMap;
import org.apache.commons.collections4.Transformer;
import org.apache.commons.collections4.collection.AbstractCollectionDecorator;

public class IndexedCollection<K, C> extends AbstractCollectionDecorator<C>
{
    protected IndexedCollection() {}
    public C get(K p0){ return null; }
    public Collection<C> values(K p0){ return null; }
    public IndexedCollection(Collection<C> p0, Transformer<C, K> p1, MultiMap<K, C> p2, boolean p3){}
    public boolean add(C p0){ return false; }
    public boolean addAll(Collection<? extends C> p0){ return false; }
    public boolean contains(Object p0){ return false; }
    public boolean containsAll(Collection<? extends Object> p0){ return false; }
    public boolean remove(Object p0){ return false; }
    public boolean removeAll(Collection<? extends Object> p0){ return false; }
    public boolean removeIf(Predicate<? super C> p0){ return false; }
    public boolean retainAll(Collection<? extends Object> p0){ return false; }
    public static <K, C> IndexedCollection<K, C> nonUniqueIndexedCollection(Collection<C> p0, Transformer<C, K> p1){ return null; }
    public static <K, C> IndexedCollection<K, C> uniqueIndexedCollection(Collection<C> p0, Transformer<C, K> p1){ return null; }
    public void clear(){}
    public void reindex(){}
}
