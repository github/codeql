// Generated automatically from org.springframework.data.domain.Sort for testing purposes

package org.springframework.data.domain;

import java.io.Serializable;
import java.util.Iterator;
import java.util.List;
import java.util.Optional;
import java.util.function.Function;
import org.springframework.data.util.MethodInvocationRecorder;
import org.springframework.data.util.Streamable;

public class Sort implements Serializable, Streamable<Sort.Order>
{
    protected Sort() {}
    protected Sort(List<Sort.Order> p0){}
    public Iterator<Sort.Order> iterator(){ return null; }
    public Sort and(Sort p0){ return null; }
    public Sort ascending(){ return null; }
    public Sort descending(){ return null; }
    public Sort.Order getOrderFor(String p0){ return null; }
    public String toString(){ return null; }
    public boolean equals(Object p0){ return false; }
    public boolean isEmpty(){ return false; }
    public boolean isSorted(){ return false; }
    public boolean isUnsorted(){ return false; }
    public int hashCode(){ return 0; }
    public static <T> Sort.TypedSort<T> sort(Class<T> p0){ return null; }
    public static Sort by(List<Sort.Order> p0){ return null; }
    public static Sort by(Sort.Direction p0, String... p1){ return null; }
    public static Sort by(Sort.Order... p0){ return null; }
    public static Sort by(String... p0){ return null; }
    public static Sort unsorted(){ return null; }
    public static Sort.Direction DEFAULT_DIRECTION = null;
    static public class Order implements Serializable
    {
        protected Order() {}
        public Order(Sort.Direction p0, String p1){}
        public Order(Sort.Direction p0, String p1, Sort.NullHandling p2){}
        public Sort withProperties(String... p0){ return null; }
        public Sort.Direction getDirection(){ return null; }
        public Sort.NullHandling getNullHandling(){ return null; }
        public Sort.Order ignoreCase(){ return null; }
        public Sort.Order nullsFirst(){ return null; }
        public Sort.Order nullsLast(){ return null; }
        public Sort.Order nullsNative(){ return null; }
        public Sort.Order with(Sort.Direction p0){ return null; }
        public Sort.Order with(Sort.NullHandling p0){ return null; }
        public Sort.Order withProperty(String p0){ return null; }
        public String getProperty(){ return null; }
        public String toString(){ return null; }
        public boolean equals(Object p0){ return false; }
        public boolean isAscending(){ return false; }
        public boolean isDescending(){ return false; }
        public boolean isIgnoreCase(){ return false; }
        public int hashCode(){ return 0; }
        public static Sort.Order asc(String p0){ return null; }
        public static Sort.Order by(String p0){ return null; }
        public static Sort.Order desc(String p0){ return null; }
    }
    static public class TypedSort<T> extends Sort
    {
        protected TypedSort() {}
        public <S> Sort.TypedSort<S> by(Function<T, S> p0){ return null; }
        public <S> Sort.TypedSort<S> by(MethodInvocationRecorder.Recorded.ToCollectionConverter<T, S> p0){ return null; }
        public <S> Sort.TypedSort<S> by(MethodInvocationRecorder.Recorded.ToMapConverter<T, S> p0){ return null; }
        public Iterator<Sort.Order> iterator(){ return null; }
        public Sort ascending(){ return null; }
        public Sort descending(){ return null; }
        public String toString(){ return null; }
        public boolean isEmpty(){ return false; }
    }
    static public enum Direction
    {
        ASC, DESC;
        private Direction() {}
        public boolean isAscending(){ return false; }
        public boolean isDescending(){ return false; }
        public static Optional<Sort.Direction> fromOptionalString(String p0){ return null; }
        public static Sort.Direction fromString(String p0){ return null; }
    }
    static public enum NullHandling
    {
        NATIVE, NULLS_FIRST, NULLS_LAST;
        private NullHandling() {}
    }
}
