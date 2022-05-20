// Generated automatically from org.apache.commons.collections4.MapUtils for testing purposes

package org.apache.commons.collections4;

import java.io.PrintStream;
import java.util.Collection;
import java.util.Map;
import java.util.Properties;
import java.util.ResourceBundle;
import java.util.SortedMap;
import org.apache.commons.collections4.Factory;
import org.apache.commons.collections4.IterableMap;
import org.apache.commons.collections4.IterableSortedMap;
import org.apache.commons.collections4.MultiMap;
import org.apache.commons.collections4.OrderedMap;
import org.apache.commons.collections4.Predicate;
import org.apache.commons.collections4.Transformer;
import org.apache.commons.collections4.map.MultiValueMap;

public class MapUtils
{
    protected MapUtils() {}
    public static <K, V, C extends Collection<V>> MultiValueMap<K, V> multiValueMap(Map<K, C> p0, Class<C> p1){ return null; }
    public static <K, V, C extends Collection<V>> MultiValueMap<K, V> multiValueMap(Map<K, C> p0, Factory<C> p1){ return null; }
    public static <K, V, E> void populateMap(Map<K, V> p0, Iterable<? extends E> p1, Transformer<E, K> p2, Transformer<E, V> p3){}
    public static <K, V, E> void populateMap(MultiMap<K, V> p0, Iterable<? extends E> p1, Transformer<E, K> p2, Transformer<E, V> p3){}
    public static <K, V> IterableMap<K, V> fixedSizeMap(Map<K, V> p0){ return null; }
    public static <K, V> IterableMap<K, V> iterableMap(Map<K, V> p0){ return null; }
    public static <K, V> IterableMap<K, V> lazyMap(Map<K, V> p0, Factory<? extends V> p1){ return null; }
    public static <K, V> IterableMap<K, V> lazyMap(Map<K, V> p0, Transformer<? super K, ? extends V> p1){ return null; }
    public static <K, V> IterableMap<K, V> predicatedMap(Map<K, V> p0, Predicate<? super K> p1, Predicate<? super V> p2){ return null; }
    public static <K, V> IterableMap<K, V> transformedMap(Map<K, V> p0, Transformer<? super K, ? extends K> p1, Transformer<? super V, ? extends V> p2){ return null; }
    public static <K, V> IterableSortedMap<K, V> iterableSortedMap(SortedMap<K, V> p0){ return null; }
    public static <K, V> Map<K, V> emptyIfNull(Map<K, V> p0){ return null; }
    public static <K, V> Map<K, V> putAll(Map<K, V> p0, Object[] p1){ return null; }
    public static <K, V> Map<K, V> synchronizedMap(Map<K, V> p0){ return null; }
    public static <K, V> Map<K, V> unmodifiableMap(Map<? extends K, ? extends V> p0){ return null; }
    public static <K, V> Map<V, K> invertMap(Map<K, V> p0){ return null; }
    public static <K, V> MultiValueMap<K, V> multiValueMap(Map<K, ? super Collection<V>> p0){ return null; }
    public static <K, V> OrderedMap<K, V> orderedMap(Map<K, V> p0){ return null; }
    public static <K, V> Properties toProperties(Map<K, V> p0){ return null; }
    public static <K, V> SortedMap<K, V> fixedSizeSortedMap(SortedMap<K, V> p0){ return null; }
    public static <K, V> SortedMap<K, V> lazySortedMap(SortedMap<K, V> p0, Factory<? extends V> p1){ return null; }
    public static <K, V> SortedMap<K, V> lazySortedMap(SortedMap<K, V> p0, Transformer<? super K, ? extends V> p1){ return null; }
    public static <K, V> SortedMap<K, V> predicatedSortedMap(SortedMap<K, V> p0, Predicate<? super K> p1, Predicate<? super V> p2){ return null; }
    public static <K, V> SortedMap<K, V> synchronizedSortedMap(SortedMap<K, V> p0){ return null; }
    public static <K, V> SortedMap<K, V> transformedSortedMap(SortedMap<K, V> p0, Transformer<? super K, ? extends K> p1, Transformer<? super V, ? extends V> p2){ return null; }
    public static <K, V> SortedMap<K, V> unmodifiableSortedMap(SortedMap<K, ? extends V> p0){ return null; }
    public static <K, V> V getObject(Map<? super K, V> p0, K p1){ return null; }
    public static <K, V> V getObject(Map<K, V> p0, K p1, V p2){ return null; }
    public static <K, V> void populateMap(Map<K, V> p0, Iterable<? extends V> p1, Transformer<V, K> p2){}
    public static <K, V> void populateMap(MultiMap<K, V> p0, Iterable<? extends V> p1, Transformer<V, K> p2){}
    public static <K> Boolean getBoolean(Map<? super K, ? extends Object> p0, K p1){ return null; }
    public static <K> Boolean getBoolean(Map<? super K, ? extends Object> p0, K p1, Boolean p2){ return null; }
    public static <K> Byte getByte(Map<? super K, ? extends Object> p0, K p1){ return null; }
    public static <K> Byte getByte(Map<? super K, ? extends Object> p0, K p1, Byte p2){ return null; }
    public static <K> Double getDouble(Map<? super K, ? extends Object> p0, K p1){ return null; }
    public static <K> Double getDouble(Map<? super K, ? extends Object> p0, K p1, Double p2){ return null; }
    public static <K> Float getFloat(Map<? super K, ? extends Object> p0, K p1){ return null; }
    public static <K> Float getFloat(Map<? super K, ? extends Object> p0, K p1, Float p2){ return null; }
    public static <K> Integer getInteger(Map<? super K, ? extends Object> p0, K p1){ return null; }
    public static <K> Integer getInteger(Map<? super K, ? extends Object> p0, K p1, Integer p2){ return null; }
    public static <K> Long getLong(Map<? super K, ? extends Object> p0, K p1){ return null; }
    public static <K> Long getLong(Map<? super K, ? extends Object> p0, K p1, Long p2){ return null; }
    public static <K> Map<? extends Object, ? extends Object> getMap(Map<? super K, ? extends Object> p0, K p1){ return null; }
    public static <K> Map<? extends Object, ? extends Object> getMap(Map<? super K, ? extends Object> p0, K p1, Map<? extends Object, ? extends Object> p2){ return null; }
    public static <K> Number getNumber(Map<? super K, ? extends Object> p0, K p1){ return null; }
    public static <K> Number getNumber(Map<? super K, ? extends Object> p0, K p1, Number p2){ return null; }
    public static <K> Short getShort(Map<? super K, ? extends Object> p0, K p1){ return null; }
    public static <K> Short getShort(Map<? super K, ? extends Object> p0, K p1, Short p2){ return null; }
    public static <K> String getString(Map<? super K, ? extends Object> p0, K p1){ return null; }
    public static <K> String getString(Map<? super K, ? extends Object> p0, K p1, String p2){ return null; }
    public static <K> boolean getBooleanValue(Map<? super K, ? extends Object> p0, K p1){ return false; }
    public static <K> boolean getBooleanValue(Map<? super K, ? extends Object> p0, K p1, boolean p2){ return false; }
    public static <K> byte getByteValue(Map<? super K, ? extends Object> p0, K p1){ return 0; }
    public static <K> byte getByteValue(Map<? super K, ? extends Object> p0, K p1, byte p2){ return 0; }
    public static <K> double getDoubleValue(Map<? super K, ? extends Object> p0, K p1){ return 0; }
    public static <K> double getDoubleValue(Map<? super K, ? extends Object> p0, K p1, double p2){ return 0; }
    public static <K> float getFloatValue(Map<? super K, ? extends Object> p0, K p1){ return 0; }
    public static <K> float getFloatValue(Map<? super K, ? extends Object> p0, K p1, float p2){ return 0; }
    public static <K> int getIntValue(Map<? super K, ? extends Object> p0, K p1){ return 0; }
    public static <K> int getIntValue(Map<? super K, ? extends Object> p0, K p1, int p2){ return 0; }
    public static <K> long getLongValue(Map<? super K, ? extends Object> p0, K p1){ return 0; }
    public static <K> long getLongValue(Map<? super K, ? extends Object> p0, K p1, long p2){ return 0; }
    public static <K> short getShortValue(Map<? super K, ? extends Object> p0, K p1){ return 0; }
    public static <K> short getShortValue(Map<? super K, ? extends Object> p0, K p1, short p2){ return 0; }
    public static <K> void safeAddToMap(Map<? super K, Object> p0, K p1, Object p2){}
    public static Map<String, Object> toMap(ResourceBundle p0){ return null; }
    public static SortedMap EMPTY_SORTED_MAP = null;
    public static boolean isEmpty(Map<? extends Object, ? extends Object> p0){ return false; }
    public static boolean isNotEmpty(Map<? extends Object, ? extends Object> p0){ return false; }
    public static int size(Map<? extends Object, ? extends Object> p0){ return 0; }
    public static void debugPrint(PrintStream p0, Object p1, Map<? extends Object, ? extends Object> p2){}
    public static void verbosePrint(PrintStream p0, Object p1, Map<? extends Object, ? extends Object> p2){}
}
