package generatedtest;

import com.google.common.base.Function;
import com.google.common.base.Optional;
import com.google.common.base.Predicate;
import com.google.common.collect.ArrayListMultimap;
import com.google.common.collect.ArrayTable;
import com.google.common.collect.BiMap;
import com.google.common.collect.ClassToInstanceMap;
import com.google.common.collect.Collections2;
import com.google.common.collect.ConcurrentHashMultiset;
import com.google.common.collect.HashBasedTable;
import com.google.common.collect.HashBiMap;
import com.google.common.collect.HashMultimap;
import com.google.common.collect.HashMultiset;
import com.google.common.collect.ImmutableClassToInstanceMap;
import com.google.common.collect.ImmutableCollection;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableListMultimap;
import com.google.common.collect.ImmutableMap;
import com.google.common.collect.ImmutableMultimap;
import com.google.common.collect.ImmutableMultiset;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.ImmutableSetMultimap;
import com.google.common.collect.ImmutableSortedMap;
import com.google.common.collect.ImmutableSortedMultiset;
import com.google.common.collect.ImmutableSortedSet;
import com.google.common.collect.ImmutableTable;
import com.google.common.collect.Iterables;
import com.google.common.collect.Iterators;
import com.google.common.collect.LinkedHashMultimap;
import com.google.common.collect.LinkedHashMultiset;
import com.google.common.collect.LinkedListMultimap;
import com.google.common.collect.ListMultimap;
import com.google.common.collect.Lists;
import com.google.common.collect.MapDifference;
import com.google.common.collect.Maps;
import com.google.common.collect.Multimap;
import com.google.common.collect.Multimaps;
import com.google.common.collect.Multiset;
import com.google.common.collect.Multisets;
import com.google.common.collect.MutableClassToInstanceMap;
import com.google.common.collect.ObjectArrays;
import com.google.common.collect.PeekingIterator;
import com.google.common.collect.Queues;
import com.google.common.collect.RowSortedTable;
import com.google.common.collect.SetMultimap;
import com.google.common.collect.Sets;
import com.google.common.collect.SortedMapDifference;
import com.google.common.collect.SortedMultiset;
import com.google.common.collect.SortedSetMultimap;
import com.google.common.collect.Table;
import com.google.common.collect.Tables;
import com.google.common.collect.TreeBasedTable;
import com.google.common.collect.TreeMultimap;
import com.google.common.collect.TreeMultiset;
import com.google.common.collect.UnmodifiableIterator;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Comparator;
import java.util.Deque;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.NavigableMap;
import java.util.NavigableSet;
import java.util.PriorityQueue;
import java.util.Properties;
import java.util.Queue;
import java.util.Set;
import java.util.SortedMap;
import java.util.SortedSet;
import java.util.TreeMap;
import java.util.TreeSet;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.concurrent.LinkedBlockingDeque;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.PriorityBlockingQueue;

// Methods for manipulating contents for use in tests
class Methods {
	<T> T getArrayElement(T[] container) { return container[0]; }
	<T> T getElement(Collection<T> container) { return container.iterator().next(); }
	<T> T getElement(ImmutableCollection.Builder<T> container) { return getElement(container.build()); }
	<T> T getElement(Iterable<T> container) { return container.iterator().next(); }
	<T> T getElement(Iterator<T> container) { return container.next(); }
	<T> T getElement(Optional<T> container) { return container.get(); }
	<T> T getElement(Enumeration<T> container) { return container.nextElement(); }
	<T> T getElement(Multiset.Entry<T> container) { return container.getElement(); }
	<K,V> Map<K,V> getMapDifference_left(MapDifference<K,V> container) { return container.entriesOnlyOnLeft(); }
	<V> V getMapDifference_left(MapDifference.ValueDifference<V> container) { return container.leftValue(); }
	<K,V> Map<K,V> getMapDifference_right(MapDifference<K,V> container) { return container.entriesOnlyOnRight(); }
	<V> V getMapDifference_right(MapDifference.ValueDifference<V> container) { return container.rightValue(); }
	<K,V> K getMapKey(Map<K,V> container) { return getElement(container.keySet()); }
	<K,V> K getMapKey(Multimap<K,V> container) { return getElement(container.keySet()); }
	<K,V> K getMapKey(Map.Entry<K,V> container) { return container.getKey(); }
	<K,V> K getMapKey(ImmutableMap.Builder<K,V> container) { return getMapKey(container.build()); }
	<K,V> K getMapKey(ImmutableMultimap.Builder<K,V> container) { return getMapKey(container.build()); }
	<K,V> V getMapValue(Map<K,V> container) { return getElement(container.values()); }
	<K,V> V getMapValue(Multimap<K,V> container) { return getElement(container.values()); }
	<K,V> V getMapValue(Map.Entry<K,V> container) { return container.getValue(); }
	<K,V> V getMapValue(ImmutableMap.Builder<K,V> container) { return getMapValue(container.build()); }
	<K,V> V getMapValue(ImmutableMultimap.Builder<K,V> container) { return getMapValue(container.build()); }
	<R,C,V> V getMapValue(Table<R,C,V> container) { return getElement(container.values()); }
	<R,C,V> V getMapValue(Table.Cell<R,C,V> container) { return container.getValue(); }
	<R,C,V> V getMapValue(ImmutableTable.Builder<R,C,V> container) { return getMapValue(container.build()); }
	<R,C,V> C getTable_columnKey(Table<R,C,V> container) { return getElement(container.columnKeySet()); }
	<R,C,V> C getTable_columnKey(Table.Cell<R,C,V> container) { return container.getColumnKey(); }
	<R,C,V> C getTable_columnKey(ImmutableTable.Builder<R,C,V> container) { return getTable_columnKey(container.build()); }
	<R,C,V> R getTable_rowKey(Table<R,C,V> container) { return getElement(container.rowKeySet()); }
	<R,C,V> R getTable_rowKey(Table.Cell<R,C,V> container) { return container.getRowKey(); }
	<R,C,V> R getTable_rowKey(ImmutableTable.Builder<R,C,V> container) { return getTable_rowKey(container.build()); }
	<T> T[] newWithArrayElement(T element) { return (T[]) new Object[]{element}; }

	Object newWithElement(Object element) { return null; }
	Object newWithMapDifference_left(Object element) { return null; }
	Object newWithMapDifference_right(Object element) { return null; }
	Object newWithMapKey(Object element) { return null; }
	Object newWithMapValue(Object element) { return null; }
	Object newWithTable_columnKey(Object element) { return null; }
	Object newWithTable_rowKey(Object element) { return null; }
}