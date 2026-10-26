// Generated automatically from org.apache.commons.collections4.collection.PredicatedCollection for testing purposes

package org.apache.commons.collections4.collection;

import java.util.Collection;
import java.util.List;
import java.util.Queue;
import java.util.Set;
import org.apache.commons.collections4.Bag;
import org.apache.commons.collections4.MultiSet;
import org.apache.commons.collections4.Predicate;
import org.apache.commons.collections4.collection.AbstractCollectionDecorator;

public class PredicatedCollection<E> extends AbstractCollectionDecorator<E>
{
    protected PredicatedCollection() {}
    protected PredicatedCollection(Collection<E> p0, Predicate<? super E> p1){}
    protected final Predicate<? super E> predicate = null;
    protected void validate(E p0){}
    public boolean add(E p0){ return false; }
    public boolean addAll(Collection<? extends E> p0){ return false; }
    public static <E> PredicatedCollection.Builder<E> builder(Predicate<? super E> p0){ return null; }
    public static <E> PredicatedCollection.Builder<E> notNullBuilder(){ return null; }
    public static <T> PredicatedCollection<T> predicatedCollection(Collection<T> p0, Predicate<? super T> p1){ return null; }
    static public class Builder<E>
    {
        protected Builder() {}
        public Bag<E> createPredicatedBag(){ return null; }
        public Bag<E> createPredicatedBag(Bag<E> p0){ return null; }
        public Builder(Predicate<? super E> p0){}
        public Collection<E> rejectedElements(){ return null; }
        public List<E> createPredicatedList(){ return null; }
        public List<E> createPredicatedList(List<E> p0){ return null; }
        public MultiSet<E> createPredicatedMultiSet(){ return null; }
        public MultiSet<E> createPredicatedMultiSet(MultiSet<E> p0){ return null; }
        public PredicatedCollection.Builder<E> add(E p0){ return null; }
        public PredicatedCollection.Builder<E> addAll(Collection<? extends E> p0){ return null; }
        public Queue<E> createPredicatedQueue(){ return null; }
        public Queue<E> createPredicatedQueue(Queue<E> p0){ return null; }
        public Set<E> createPredicatedSet(){ return null; }
        public Set<E> createPredicatedSet(Set<E> p0){ return null; }
    }
}
