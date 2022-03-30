// Generated automatically from org.apache.commons.collections4.set.PredicatedSet for testing purposes

package org.apache.commons.collections4.set;

import java.util.Set;
import org.apache.commons.collections4.Predicate;
import org.apache.commons.collections4.collection.PredicatedCollection;

public class PredicatedSet<E> extends PredicatedCollection<E> implements Set<E>
{
    protected PredicatedSet() {}
    protected PredicatedSet(Set<E> p0, Predicate<? super E> p1){}
    protected Set<E> decorated(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public static <E> PredicatedSet<E> predicatedSet(Set<E> p0, Predicate<? super E> p1){ return null; }
}
