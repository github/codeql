// Generated automatically from org.springframework.util.CollectionUtils for testing purposes

package org.springframework.util;

import java.util.Collection;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import org.springframework.util.MultiValueMap;

abstract public class CollectionUtils
{
    public CollectionUtils(){}
    public static <A, E extends A> A[] toArray(Enumeration<E> p0, A[] p1){ return null; }
    public static <E> E findFirstMatch(Collection<? extends Object> p0, Collection<E> p1){ return null; }
    public static <E> Iterator<E> toIterator(Enumeration<E> p0){ return null; }
    public static <E> void mergeArrayIntoCollection(Object p0, Collection<E> p1){}
    public static <K, V> HashMap<K, V> newHashMap(int p0){ return null; }
    public static <K, V> LinkedHashMap<K, V> newLinkedHashMap(int p0){ return null; }
    public static <K, V> MultiValueMap<K, V> toMultiValueMap(Map<K, List<V>> p0){ return null; }
    public static <K, V> MultiValueMap<K, V> unmodifiableMultiValueMap(MultiValueMap<? extends K, ? extends V> p0){ return null; }
    public static <K, V> void mergePropertiesIntoMap(Properties p0, Map<K, V> p1){}
    public static <T> T findValueOfType(Collection<? extends Object> p0, Class<T> p1){ return null; }
    public static <T> T firstElement(List<T> p0){ return null; }
    public static <T> T firstElement(Set<T> p0){ return null; }
    public static <T> T lastElement(List<T> p0){ return null; }
    public static <T> T lastElement(Set<T> p0){ return null; }
    public static Class<? extends Object> findCommonElementType(Collection<? extends Object> p0){ return null; }
    public static List<? extends Object> arrayToList(Object p0){ return null; }
    public static Object findValueOfType(Collection<? extends Object> p0, Class<? extends Object>[] p1){ return null; }
    public static boolean contains(Enumeration<? extends Object> p0, Object p1){ return false; }
    public static boolean contains(Iterator<? extends Object> p0, Object p1){ return false; }
    public static boolean containsAny(Collection<? extends Object> p0, Collection<? extends Object> p1){ return false; }
    public static boolean containsInstance(Collection<? extends Object> p0, Object p1){ return false; }
    public static boolean hasUniqueObject(Collection<? extends Object> p0){ return false; }
    public static boolean isEmpty(Collection<? extends Object> p0){ return false; }
    public static boolean isEmpty(Map<? extends Object, ? extends Object> p0){ return false; }
    static float DEFAULT_LOAD_FACTOR = 0;
}
