// Generated automatically from com.google.common.collect.Cut for testing purposes

package com.google.common.collect;

import com.google.common.collect.BoundType;
import com.google.common.collect.DiscreteDomain;
import java.io.Serializable;

abstract class Cut<C extends Comparable> implements Comparable<Cut<C>>, Serializable
{
    protected Cut() {}
    C endpoint(){ return null; }
    Cut(C p0){}
    Cut<C> canonical(DiscreteDomain<C> p0){ return null; }
    abstract BoundType typeAsLowerBound();
    abstract BoundType typeAsUpperBound();
    abstract C greatestValueBelow(DiscreteDomain<C> p0);
    abstract C leastValueAbove(DiscreteDomain<C> p0);
    abstract Cut<C> withLowerBoundType(BoundType p0, DiscreteDomain<C> p1);
    abstract Cut<C> withUpperBoundType(BoundType p0, DiscreteDomain<C> p1);
    abstract boolean isLessThan(C p0);
    abstract void describeAsLowerBound(StringBuilder p0);
    abstract void describeAsUpperBound(StringBuilder p0);
    final C endpoint = null;
    public abstract int hashCode();
    public boolean equals(Object p0){ return false; }
    public int compareTo(Cut<C> p0){ return 0; }
    static <C extends Comparable> Cut<C> aboveAll(){ return null; }
    static <C extends Comparable> Cut<C> aboveValue(C p0){ return null; }
    static <C extends Comparable> Cut<C> belowAll(){ return null; }
    static <C extends Comparable> Cut<C> belowValue(C p0){ return null; }
}
