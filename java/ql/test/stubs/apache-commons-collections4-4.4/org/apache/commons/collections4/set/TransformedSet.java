// Generated automatically from org.apache.commons.collections4.set.TransformedSet for testing purposes

package org.apache.commons.collections4.set;

import java.util.Set;
import org.apache.commons.collections4.Transformer;
import org.apache.commons.collections4.collection.TransformedCollection;

public class TransformedSet<E> extends TransformedCollection<E> implements Set<E>
{
    protected TransformedSet() {}
    protected TransformedSet(Set<E> p0, Transformer<? super E, ? extends E> p1){}
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    public static <E> Set<E> transformedSet(Set<E> p0, Transformer<? super E, ? extends E> p1){ return null; }
    public static <E> TransformedSet<E> transformingSet(Set<E> p0, Transformer<? super E, ? extends E> p1){ return null; }
}
