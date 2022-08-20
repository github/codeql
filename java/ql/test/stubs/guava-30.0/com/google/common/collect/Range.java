// Generated automatically from com.google.common.collect.Range for testing purposes

package com.google.common.collect;

import com.google.common.base.Predicate;
import com.google.common.collect.BoundType;
import com.google.common.collect.DiscreteDomain;
import com.google.common.collect.RangeGwtSerializationDependencies;
import java.io.Serializable;

public class Range<C extends Comparable> extends RangeGwtSerializationDependencies implements Predicate<C>, Serializable
{
    protected Range() {}
    public BoundType lowerBoundType(){ return null; }
    public BoundType upperBoundType(){ return null; }
    public C lowerEndpoint(){ return null; }
    public C upperEndpoint(){ return null; }
    public Range<C> canonical(DiscreteDomain<C> p0){ return null; }
    public Range<C> gap(Range<C> p0){ return null; }
    public Range<C> intersection(Range<C> p0){ return null; }
    public Range<C> span(Range<C> p0){ return null; }
    public String toString(){ return null; }
    public boolean apply(C p0){ return false; }
    public boolean contains(C p0){ return false; }
    public boolean containsAll(Iterable<? extends C> p0){ return false; }
    public boolean encloses(Range<C> p0){ return false; }
    public boolean equals(Object p0){ return false; }
    public boolean hasLowerBound(){ return false; }
    public boolean hasUpperBound(){ return false; }
    public boolean isConnected(Range<C> p0){ return false; }
    public boolean isEmpty(){ return false; }
    public int hashCode(){ return 0; }
    public static <C extends Comparable<? extends Object>> Range<C> all(){ return null; }
    public static <C extends Comparable<? extends Object>> Range<C> atLeast(C p0){ return null; }
    public static <C extends Comparable<? extends Object>> Range<C> atMost(C p0){ return null; }
    public static <C extends Comparable<? extends Object>> Range<C> closed(C p0, C p1){ return null; }
    public static <C extends Comparable<? extends Object>> Range<C> closedOpen(C p0, C p1){ return null; }
    public static <C extends Comparable<? extends Object>> Range<C> downTo(C p0, BoundType p1){ return null; }
    public static <C extends Comparable<? extends Object>> Range<C> encloseAll(Iterable<C> p0){ return null; }
    public static <C extends Comparable<? extends Object>> Range<C> greaterThan(C p0){ return null; }
    public static <C extends Comparable<? extends Object>> Range<C> lessThan(C p0){ return null; }
    public static <C extends Comparable<? extends Object>> Range<C> open(C p0, C p1){ return null; }
    public static <C extends Comparable<? extends Object>> Range<C> openClosed(C p0, C p1){ return null; }
    public static <C extends Comparable<? extends Object>> Range<C> range(C p0, BoundType p1, C p2, BoundType p3){ return null; }
    public static <C extends Comparable<? extends Object>> Range<C> singleton(C p0){ return null; }
    public static <C extends Comparable<? extends Object>> Range<C> upTo(C p0, BoundType p1){ return null; }
}
