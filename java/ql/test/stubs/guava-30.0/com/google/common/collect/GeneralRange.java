// Generated automatically from com.google.common.collect.GeneralRange for testing purposes

package com.google.common.collect;

import com.google.common.collect.BoundType;
import com.google.common.collect.Range;
import java.io.Serializable;
import java.util.Comparator;

class GeneralRange<T> implements Serializable
{
    protected GeneralRange() {}
    BoundType getLowerBoundType(){ return null; }
    BoundType getUpperBoundType(){ return null; }
    Comparator<? super T> comparator(){ return null; }
    GeneralRange<T> intersect(GeneralRange<T> p0){ return null; }
    GeneralRange<T> reverse(){ return null; }
    T getLowerEndpoint(){ return null; }
    T getUpperEndpoint(){ return null; }
    boolean contains(T p0){ return false; }
    boolean hasLowerBound(){ return false; }
    boolean hasUpperBound(){ return false; }
    boolean isEmpty(){ return false; }
    boolean tooHigh(T p0){ return false; }
    boolean tooLow(T p0){ return false; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public int hashCode(){ return 0; }
    static <T extends Comparable> GeneralRange<T> from(Range<T> p0){ return null; }
    static <T> GeneralRange<T> all(Comparator<? super T> p0){ return null; }
    static <T> GeneralRange<T> downTo(Comparator<? super T> p0, T p1, BoundType p2){ return null; }
    static <T> GeneralRange<T> range(Comparator<? super T> p0, T p1, BoundType p2, T p3, BoundType p4){ return null; }
    static <T> GeneralRange<T> upTo(Comparator<? super T> p0, T p1, BoundType p2){ return null; }
}
