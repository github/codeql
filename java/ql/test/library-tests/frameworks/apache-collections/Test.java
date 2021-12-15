package generatedtest;

import java.io.File;
import java.io.InputStream;
import java.io.Reader;
import java.net.URI;
import java.net.URL;
import java.nio.file.Path;
import java.util.Collection;
import java.util.Comparator;
import java.util.Enumeration;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import java.util.NavigableSet;
import java.util.Properties;
import java.util.Queue;
import java.util.ResourceBundle;
import java.util.Set;
import java.util.SortedMap;
import java.util.SortedSet;
import java.util.StringTokenizer;
import java.util.TreeMap;
import java.util.TreeSet;
import java.util.Vector;
import org.apache.commons.collections4.ArrayStack;
import org.apache.commons.collections4.Bag;
import org.apache.commons.collections4.bag.AbstractBagDecorator;
import org.apache.commons.collections4.bag.AbstractMapBag;
import org.apache.commons.collections4.bag.AbstractSortedBagDecorator;
import org.apache.commons.collections4.bag.CollectionBag;
import org.apache.commons.collections4.bag.CollectionSortedBag;
import org.apache.commons.collections4.bag.HashBag;
import org.apache.commons.collections4.bag.PredicatedBag;
import org.apache.commons.collections4.bag.PredicatedSortedBag;
import org.apache.commons.collections4.bag.SynchronizedBag;
import org.apache.commons.collections4.bag.SynchronizedSortedBag;
import org.apache.commons.collections4.bag.TransformedBag;
import org.apache.commons.collections4.bag.TransformedSortedBag;
import org.apache.commons.collections4.bag.TreeBag;
import org.apache.commons.collections4.bag.UnmodifiableBag;
import org.apache.commons.collections4.bag.UnmodifiableSortedBag;
import org.apache.commons.collections4.BagUtils;
import org.apache.commons.collections4.BidiMap;
import org.apache.commons.collections4.bidimap.AbstractBidiMapDecorator;
import org.apache.commons.collections4.bidimap.AbstractDualBidiMap;
import org.apache.commons.collections4.bidimap.AbstractOrderedBidiMapDecorator;
import org.apache.commons.collections4.bidimap.AbstractSortedBidiMapDecorator;
import org.apache.commons.collections4.bidimap.DualHashBidiMap;
import org.apache.commons.collections4.bidimap.DualLinkedHashBidiMap;
import org.apache.commons.collections4.bidimap.DualTreeBidiMap;
import org.apache.commons.collections4.bidimap.TreeBidiMap;
import org.apache.commons.collections4.bidimap.UnmodifiableBidiMap;
import org.apache.commons.collections4.bidimap.UnmodifiableOrderedBidiMap;
import org.apache.commons.collections4.bidimap.UnmodifiableSortedBidiMap;
import org.apache.commons.collections4.BoundedCollection;
import org.apache.commons.collections4.collection.AbstractCollectionDecorator;
import org.apache.commons.collections4.collection.CompositeCollection;
import org.apache.commons.collections4.collection.IndexedCollection;
import org.apache.commons.collections4.collection.PredicatedCollection;
import org.apache.commons.collections4.collection.SynchronizedCollection;
import org.apache.commons.collections4.collection.TransformedCollection;
import org.apache.commons.collections4.collection.UnmodifiableBoundedCollection;
import org.apache.commons.collections4.collection.UnmodifiableCollection;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.collections4.EnumerationUtils;
import org.apache.commons.collections4.Factory;
import org.apache.commons.collections4.FluentIterable;
import org.apache.commons.collections4.Get;
import org.apache.commons.collections4.IterableGet;
import org.apache.commons.collections4.IterableMap;
import org.apache.commons.collections4.IterableSortedMap;
import org.apache.commons.collections4.IterableUtils;
import org.apache.commons.collections4.iterators.AbstractIteratorDecorator;
import org.apache.commons.collections4.iterators.AbstractListIteratorDecorator;
import org.apache.commons.collections4.iterators.AbstractMapIteratorDecorator;
import org.apache.commons.collections4.iterators.AbstractOrderedMapIteratorDecorator;
import org.apache.commons.collections4.iterators.AbstractUntypedIteratorDecorator;
import org.apache.commons.collections4.iterators.ArrayIterator;
import org.apache.commons.collections4.iterators.ArrayListIterator;
import org.apache.commons.collections4.iterators.BoundedIterator;
import org.apache.commons.collections4.iterators.CollatingIterator;
import org.apache.commons.collections4.iterators.EnumerationIterator;
import org.apache.commons.collections4.iterators.FilterIterator;
import org.apache.commons.collections4.iterators.FilterListIterator;
import org.apache.commons.collections4.iterators.IteratorChain;
import org.apache.commons.collections4.iterators.IteratorEnumeration;
import org.apache.commons.collections4.iterators.IteratorIterable;
import org.apache.commons.collections4.iterators.ListIteratorWrapper;
import org.apache.commons.collections4.iterators.LoopingIterator;
import org.apache.commons.collections4.iterators.LoopingListIterator;
import org.apache.commons.collections4.iterators.ObjectArrayIterator;
import org.apache.commons.collections4.iterators.ObjectArrayListIterator;
import org.apache.commons.collections4.iterators.PeekingIterator;
import org.apache.commons.collections4.iterators.PermutationIterator;
import org.apache.commons.collections4.iterators.PushbackIterator;
import org.apache.commons.collections4.iterators.ReverseListIterator;
import org.apache.commons.collections4.iterators.SingletonIterator;
import org.apache.commons.collections4.iterators.SingletonListIterator;
import org.apache.commons.collections4.iterators.SkippingIterator;
import org.apache.commons.collections4.iterators.UniqueFilterIterator;
import org.apache.commons.collections4.iterators.UnmodifiableIterator;
import org.apache.commons.collections4.iterators.UnmodifiableListIterator;
import org.apache.commons.collections4.iterators.UnmodifiableMapIterator;
import org.apache.commons.collections4.iterators.UnmodifiableOrderedMapIterator;
import org.apache.commons.collections4.iterators.ZippingIterator;
import org.apache.commons.collections4.IteratorUtils;
import org.apache.commons.collections4.KeyValue;
import org.apache.commons.collections4.keyvalue.AbstractKeyValue;
import org.apache.commons.collections4.keyvalue.AbstractMapEntry;
import org.apache.commons.collections4.keyvalue.AbstractMapEntryDecorator;
import org.apache.commons.collections4.keyvalue.DefaultKeyValue;
import org.apache.commons.collections4.keyvalue.DefaultMapEntry;
import org.apache.commons.collections4.keyvalue.MultiKey;
import org.apache.commons.collections4.keyvalue.TiedMapEntry;
import org.apache.commons.collections4.keyvalue.UnmodifiableMapEntry;
import org.apache.commons.collections4.list.AbstractLinkedList;
import org.apache.commons.collections4.list.AbstractListDecorator;
import org.apache.commons.collections4.list.AbstractSerializableListDecorator;
import org.apache.commons.collections4.list.CursorableLinkedList;
import org.apache.commons.collections4.list.FixedSizeList;
import org.apache.commons.collections4.list.GrowthList;
import org.apache.commons.collections4.list.LazyList;
import org.apache.commons.collections4.list.NodeCachingLinkedList;
import org.apache.commons.collections4.list.PredicatedList;
import org.apache.commons.collections4.list.SetUniqueList;
import org.apache.commons.collections4.list.TransformedList;
import org.apache.commons.collections4.list.TreeList;
import org.apache.commons.collections4.list.UnmodifiableList;
import org.apache.commons.collections4.ListUtils;
import org.apache.commons.collections4.ListValuedMap;
import org.apache.commons.collections4.map.AbstractHashedMap;
import org.apache.commons.collections4.map.AbstractLinkedMap;
import org.apache.commons.collections4.map.AbstractIterableMap;
import org.apache.commons.collections4.map.AbstractMapDecorator;
import org.apache.commons.collections4.map.AbstractOrderedMapDecorator;
import org.apache.commons.collections4.map.AbstractSortedMapDecorator;
import org.apache.commons.collections4.map.CaseInsensitiveMap;
import org.apache.commons.collections4.map.CompositeMap;
import org.apache.commons.collections4.map.DefaultedMap;
import org.apache.commons.collections4.map.EntrySetToMapIteratorAdapter;
import org.apache.commons.collections4.map.FixedSizeMap;
import org.apache.commons.collections4.map.FixedSizeSortedMap;
import org.apache.commons.collections4.map.Flat3Map;
import org.apache.commons.collections4.map.HashedMap;
import org.apache.commons.collections4.map.LazyMap;
import org.apache.commons.collections4.map.LazySortedMap;
import org.apache.commons.collections4.map.LinkedMap;
import org.apache.commons.collections4.map.ListOrderedMap;
import org.apache.commons.collections4.map.LRUMap;
import org.apache.commons.collections4.map.MultiKeyMap;
import org.apache.commons.collections4.map.MultiValueMap;
import org.apache.commons.collections4.map.PassiveExpiringMap;
import org.apache.commons.collections4.map.PredicatedMap;
import org.apache.commons.collections4.map.PredicatedSortedMap;
import org.apache.commons.collections4.map.SingletonMap;
import org.apache.commons.collections4.map.TransformedMap;
import org.apache.commons.collections4.map.TransformedSortedMap;
import org.apache.commons.collections4.map.UnmodifiableEntrySet;
import org.apache.commons.collections4.map.UnmodifiableMap;
import org.apache.commons.collections4.map.UnmodifiableOrderedMap;
import org.apache.commons.collections4.map.UnmodifiableSortedMap;
import org.apache.commons.collections4.MapIterator;
import org.apache.commons.collections4.MapUtils;
import org.apache.commons.collections4.MultiMap;
import org.apache.commons.collections4.multimap.ArrayListValuedHashMap;
import org.apache.commons.collections4.multimap.HashSetValuedHashMap;
import org.apache.commons.collections4.multimap.TransformedMultiValuedMap;
import org.apache.commons.collections4.multimap.UnmodifiableMultiValuedMap;
import org.apache.commons.collections4.MultiMapUtils;
import org.apache.commons.collections4.MultiSet;
import org.apache.commons.collections4.multiset.HashMultiSet;
import org.apache.commons.collections4.multiset.HashMultiSet;
import org.apache.commons.collections4.multiset.PredicatedMultiSet;
import org.apache.commons.collections4.multiset.SynchronizedMultiSet;
import org.apache.commons.collections4.multiset.UnmodifiableMultiSet;
import org.apache.commons.collections4.MultiSetUtils;
import org.apache.commons.collections4.MultiValuedMap;
import org.apache.commons.collections4.OrderedBidiMap;
import org.apache.commons.collections4.OrderedIterator;
import org.apache.commons.collections4.OrderedMap;
import org.apache.commons.collections4.OrderedMapIterator;
import org.apache.commons.collections4.Predicate;
import org.apache.commons.collections4.properties.AbstractPropertiesFactory;
import org.apache.commons.collections4.Put;
import org.apache.commons.collections4.queue.CircularFifoQueue;
import org.apache.commons.collections4.queue.PredicatedQueue;
import org.apache.commons.collections4.queue.SynchronizedQueue;
import org.apache.commons.collections4.queue.TransformedQueue;
import org.apache.commons.collections4.queue.UnmodifiableQueue;
import org.apache.commons.collections4.QueueUtils;
import org.apache.commons.collections4.ResettableIterator;
import org.apache.commons.collections4.ResettableListIterator;
import org.apache.commons.collections4.set.AbstractNavigableSetDecorator;
import org.apache.commons.collections4.set.AbstractSetDecorator;
import org.apache.commons.collections4.set.AbstractSortedSetDecorator;
import org.apache.commons.collections4.set.CompositeSet;
import org.apache.commons.collections4.set.ListOrderedSet;
import org.apache.commons.collections4.set.MapBackedSet;
import org.apache.commons.collections4.set.PredicatedNavigableSet;
import org.apache.commons.collections4.set.PredicatedSet;
import org.apache.commons.collections4.set.PredicatedSortedSet;
import org.apache.commons.collections4.set.TransformedNavigableSet;
import org.apache.commons.collections4.set.TransformedSet;
import org.apache.commons.collections4.set.TransformedSortedSet;
import org.apache.commons.collections4.set.UnmodifiableNavigableSet;
import org.apache.commons.collections4.set.UnmodifiableSet;
import org.apache.commons.collections4.set.UnmodifiableSortedSet;
import org.apache.commons.collections4.SetUtils;
import org.apache.commons.collections4.SetValuedMap;
import org.apache.commons.collections4.SortedBag;
import org.apache.commons.collections4.SortedBidiMap;
import org.apache.commons.collections4.splitmap.AbstractIterableGetMapDecorator;
import org.apache.commons.collections4.splitmap.TransformedSplitMap;
import org.apache.commons.collections4.SplitMapUtils;
import org.apache.commons.collections4.Transformer;
import org.apache.commons.collections4.Trie;
import org.apache.commons.collections4.trie.PatriciaTrie;
import org.apache.commons.collections4.trie.UnmodifiableTrie;
import org.apache.commons.collections4.TrieUtils;

// Test case generated by GenerateFlowTestCase.ql
public class Test {

	<K> K getMapKey(Map<K,?> map) { return map.keySet().iterator().next(); }
	<T> T getArrayElement(T[] array) { return array[0]; }
	<T> T getElement(Iterable<T> it) { return it.iterator().next(); }
	<T> T getElement(Iterator<T> it) { return it.next(); }
	<V> V getMapValue(Map<?,V> map) { return map.get(null); }

	<E> E getElement(Enumeration<E> container) { return container.nextElement(); }
	<E> E getElement(MultiSet.Entry<E> container) { return container.getElement(); }
	<E> E getElement(MultiKey<E> container) { return container.getKey(0); }
	<K> K getMapKey(AbstractKeyValue<K,?> container) { return container.getKey(); }
	<K> K getMapKeyFromEntry(Map.Entry<K,?> container) { return container.getKey(); }
	<K> K getMapKey(AbstractMapEntryDecorator<K,?> container) { return container.getKey(); }
	<K> K getMapKey(MultiValuedMap<K,?> container) { return container.keySet().iterator().next(); }
	<K> K getMapKeyFromGet(Get<K,?> container) { return container.keySet().iterator().next(); }
	<K,V> K getMapKeyFromPut(Put<K,V> container) { return getMapKey((Map<K,V>)container); }
	<V> V getMapValue(AbstractKeyValue<?,V> container) { return container.getValue(); }
	<V> V getMapValueFromEntry(Map.Entry<?,V> container) { return container.getValue(); }
	<V> V getMapValue(AbstractMapEntryDecorator<?,V> container) { return container.getValue(); }
	<V> V getMapValue(MapIterator<?,V> mapIterator) { return mapIterator.getValue(); }
	<V> Collection<V> getMapValue(MultiValuedMap<?,V> container) { return container.get(null); }
	<V> V getMapValueFromGet(Get<?,V> container) { return container.get(null); }
	<K,V> V getMapValueFromPut(Put<K,V> container) { return getMapValue((Map<K,V>)container); }

	Object[] newWithArrayElement(Object element) { return new Object[] {element}; }
	<T> ArrayStack<T> newArrayStackWithElement(T element) { ArrayStack<T> a = new ArrayStack<>(); a.push(element); return a; }
	<T> CircularFifoQueue<T> newCircularFifoQueueWithElement(T element) { CircularFifoQueue<T> x = new CircularFifoQueue<>(); x.add(element); return x; }
	<T> CompositeSet<T> newCompositeSetWithElement(T element) { return new CompositeSet<T>(newListOrderedSetWithElement(element)); }
	<T> CursorableLinkedList<T> newCursorableLinkedListWithElement(T element) { CursorableLinkedList<T> x = new CursorableLinkedList<>(); x.add(element); return x; }
	<T> Enumeration<T> newEnumerationWithElement(T element) { return new IteratorEnumeration<T>(newVectorWithElement(element).iterator()); }
	<T> FluentIterable<T> newFluentIterableWithElement(T element) { return FluentIterable.of(element); }
	<T> HashMultiSet<T> newHashMultiSetWithElement(T element) { HashMultiSet<T> x = new HashMultiSet<>(); x.add(element); return x; }
	<T> ListIterator<T> newListIteratorWithElement(T element) { return newVectorWithElement(element).listIterator(); }
	<T> ListOrderedSet<T> newListOrderedSetWithElement(T element) { ListOrderedSet<T> x = new ListOrderedSet<>(); x.add(element); return x; }
	<T> MultiKey<T> newMultiKeyWithElement(T element) { return new MultiKey<T>(element, (T)null); }
	<T> MultiSet.Entry<T> newMultiSetEntryWithElement(T element) { return getElement(newMultiSetWithElement(element).entrySet()); }
	<T> MultiSet<T> newMultiSetWithElement(T element) { HashMultiSet<T> h = new HashMultiSet<>(); h.add(element); return h; }
	<T> PredicatedCollection.Builder<T> newPredicatedCollectionBuilderWithElement(T element) { PredicatedCollection.Builder<T> x = PredicatedCollection.<T>notNullBuilder(); x.add(element); return x; }
	<T> Queue<T> newQueueWithElement(T element) { LinkedList<T> q = new LinkedList<>(); q.add(element); return q; }
	<T> MySetView<T> newSetViewWithElement(T element) { MySetView<T> s = new MySetView<>(); s.add(element); return s; }
	<T> TreeBag<T> newTreeBagWithElement(T element) { TreeBag<T> b = new TreeBag<>(); b.add(element); return b; }
	<T> TreeSet<T> newTreeSetWithElement(T element) { TreeSet<T> h = new TreeSet<>(); h.add(element); return h; }
	<T> Vector<T> newVectorWithElement(T element) { Vector<T> v = new Vector<>(); v.add(element); return v; }
	<T> Vector<Iterable<T>> newVectorWithElement(Iterable<T> element) { Vector<Iterable<T>> v = new Vector<>(); v.add(element); return v; }

	<K> ArrayListValuedHashMap<K,String> newALVHMWithMapKey(K key) { ArrayListValuedHashMap<K,String> m = new ArrayListValuedHashMap<>(); m.put(key,null); return m; }
	<K> DefaultKeyValue<K,String> newDKVWithMapKey(K key) { return new DefaultKeyValue<K,String>(key,null); }
	<K> DualTreeBidiMap<K,String> newDualTreeBidiMapWithMapKey(K key) { return new DualTreeBidiMap<K,String>(Map.of(key, null)); }
	<K> HashedMap<K,String> newHashedMapWithMapKey(K key) { HashedMap<K,String> m = new HashedMap<>(); m.put(key,null); return m; }
	<K> LinkedMap<K,String> newLinkedMapWithMapKey(K key) { return new LinkedMap<K,String>(Map.of(key, null)); }
	<K> ListOrderedMap<K,String> newListOrderedMapWithMapKey(K key) { return ListOrderedMap.<K,String>listOrderedMap(Map.of(key, null)); }
	<K> MultiKeyMap<K,String> newMKMWithMapKey(K key) { MultiKeyMap<K,String> m = new MultiKeyMap<>(); m.put(key,null,null); return m; }
	<K> MultiValueMap<K,String> newMVMWithMapKey(K key) { MultiValueMap<K,String> m = new MultiValueMap<>(); m.put(key,null); return m; }
	<K> MyAbstractMapEntry<K,String> newMAMEWithMapKey(K key) { return new MyAbstractMapEntry<K,String>(key,null); }
	<K> MyAbstractMapEntryDecorator<K,String> newMAMEDWithMapKey(K key) { return new MyAbstractMapEntryDecorator<K,String>(newMAMEWithMapKey(key)); }
	<K> MyAbstractKeyValue<K,String> newMAKVWithMapKey(K key) { return new MyAbstractKeyValue<K,String>(key,null); }
	<K> OrderedMapIterator<K,String> newOMIWithElement(K key) { LinkedMap<K,String> m = new LinkedMap<>(); m.put(key,null); return m.mapIterator(); }
	ResourceBundle newRBWithMapKey(String key) { return (ResourceBundle)null; }
	<K> SortedMap<K,String> newTreeMapWithMapKey(K key) { SortedMap<K,String> m = new TreeMap<>(); m.put(key,null); return m; }
	<K> TiedMapEntry<K,String> newTMEWithMapKey(K key) { return new TiedMapEntry<K,String>(new TreeMap<K,String>(),key); }
	<K extends Comparable<K>> TreeBidiMap<K,String> newTreeBidiMapWithMapKey(K key) { TreeBidiMap<K,String> m = new TreeBidiMap<>(); m.put(key,null); return m; }
	PatriciaTrie<Object> newPatriciaTrieWithMapKey(String key) { PatriciaTrie<Object> m = new PatriciaTrie<>(); m.put(key,null); return m; }

	<V> ArrayListValuedHashMap<String,V> newALVHMWithMapValue(V value) { ArrayListValuedHashMap<String,V> m = new ArrayListValuedHashMap<>(); m.put(null,value); return m; }
	<V> DefaultKeyValue<String,V> newDKVWithMapValue(V value) { return new DefaultKeyValue<String,V>(null,value); }
	<V> DualTreeBidiMap<String,V> newDualTreeBidiMapWithMapValue(V value) { return new DualTreeBidiMap<String,V>(Map.of(null, value)); }
	<V> HashedMap<String,V> newHashedMapWithMapValue(V value) { HashedMap<String,V> m = new HashedMap<>(); m.put(null,value); return m; }
	<V> HashSetValuedHashMap<String,V> newHSVHMWithMapValue(V value) { HashSetValuedHashMap<String,V> m = new HashSetValuedHashMap<>(); m.put(null,value); return m; }
	<V> LinkedMap<String,V> newLinkedMapWithMapValue(V value) { return new LinkedMap<String,V>(Map.of(null, value)); }
	<V> ListOrderedMap<String,V> newListOrderedMapWithMapValue(V value) { return ListOrderedMap.<String,V>listOrderedMap(Map.of(null, value)); }
	<V> MultiKeyMap<String,V> newMKMWithMapValue(V value) { MultiKeyMap<String,V> m = new MultiKeyMap<>(); m.put(null,null,value); return m; }
	<V> MultiValueMap<String,V> newMVMWithMapValue(V value) { MultiValueMap<String,V> m = new MultiValueMap<>(); m.put(null,value); return m; }
	<V> MyAbstractKeyValue<String,V> newMAKVWithMapValue(V value) { return new MyAbstractKeyValue<String,V>(null,value); }
	<V> MyAbstractMapEntry<String,V> newMAMEWithMapValue(V value) { return new MyAbstractMapEntry<String,V>(null,value); }
	<V> MyAbstractMapEntryDecorator<String,V> newMAMEDWithMapValue(V value) { return new MyAbstractMapEntryDecorator<String,V>(newMAMEWithMapValue(value)); }
	<V> OrderedMapIterator<String,V> newOMIWithMapValue(V value) { LinkedMap<String,V> m = new LinkedMap<>(); m.put(null,value); return m.mapIterator(); }
	ResourceBundle newRBWithMapValue(Object value) { return (ResourceBundle)null; }
	<V> SortedMap<String,V> newTreeMapWithMapValue(V value) { SortedMap<String,V> m = new TreeMap<>(); m.put(null,value); return m; }
	<V> TiedMapEntry<String,V> newTMEWithMapValue(V value) { return new TiedMapEntry<String,V>(newTreeMapWithMapValue(value),null); }
	<V extends Comparable<V>> TreeBidiMap<String,V> newTreeBidiMapWithMapValue(V value) { TreeBidiMap<String,V> m = new TreeBidiMap<>(); m.put(null,value); return m; }
	<V> PatriciaTrie<V> newPatriciaTrieWithMapValue(V value) { PatriciaTrie<V> m = new PatriciaTrie<>(); m.put(null,value); return m; }
	<V> UnmodifiableMapEntry<String,V> newUMEWithMapValue(V value) { return new UnmodifiableMapEntry<String,V>(null,value); }

	Object source() { return null; }
	void sink(Object o) { }

	public void test() throws Exception {

		{
			// "org.apache.commons.collections4.keyvalue;AbstractKeyValue;true;AbstractKeyValue;;;Argument[0];MapKey of Argument[-1];value"
			AbstractKeyValue out = null;
			Object in = source();
			out = new MyAbstractKeyValue(in, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;AbstractKeyValue;true;AbstractKeyValue;;;Argument[1];MapValue of Argument[-1];value"
			AbstractKeyValue out = null;
			Object in = source();
			out = new MyAbstractKeyValue(null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;AbstractKeyValue;true;setKey;;;Argument[0];MapKey of Argument[-1];value"
			DefaultKeyValue out = null;
			Object in = source();
			out.setKey(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;AbstractKeyValue;true;setKey;;;Argument[0];MapKey of Argument[-1];value"
			MyAbstractKeyValue out = null;
			Object in = source();
			out.mySetKey(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;AbstractKeyValue;true;setKey;;;MapKey of Argument[-1];ReturnValue;value"
			Object out = null;
			DefaultKeyValue in = newDKVWithMapKey((String)source());
			out = in.setKey(null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;AbstractKeyValue;true;setKey;;;MapKey of Argument[-1];ReturnValue;value"
			Object out = null;
			MyAbstractKeyValue in = newMAKVWithMapKey((String)source());
			out = in.mySetKey(null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;AbstractKeyValue;true;setValue;;;Argument[0];MapValue of Argument[-1];value"
			UnmodifiableMapEntry out = null;
			Object in = source();
			out.setValue(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;AbstractKeyValue;true;setValue;;;Argument[0];MapValue of Argument[-1];value"
			DefaultKeyValue out = null;
			Object in = source();
			out.setValue(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;AbstractKeyValue;true;setValue;;;Argument[0];MapValue of Argument[-1];value"
			AbstractMapEntry out = null;
			Object in = source();
			out.setValue(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;AbstractKeyValue;true;setValue;;;Argument[0];MapValue of Argument[-1];value"
			MyAbstractKeyValue out = null;
			Object in = source();
			out.mySetValue(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;AbstractKeyValue;true;setValue;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			UnmodifiableMapEntry in = newUMEWithMapValue((String)source());
			out = in.setValue(null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;AbstractKeyValue;true;setValue;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			DefaultKeyValue in = newDKVWithMapValue((String)source());
			out = in.setValue(null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;AbstractKeyValue;true;setValue;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			AbstractMapEntry in = newMAMEWithMapValue((String)source());
			out = in.setValue(null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;AbstractKeyValue;true;setValue;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			AbstractMapEntry in = newMAMEWithMapValue((String)source());
			out = in.setValue(null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;AbstractKeyValue;true;setValue;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MyAbstractKeyValue in = newMAKVWithMapValue((String)source());
			out = in.mySetValue(null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;AbstractKeyValue;true;setValue;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MyAbstractKeyValue in = newMAKVWithMapValue((String)source());
			out = in.mySetValue((Object)null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;AbstractMapEntry;true;AbstractMapEntry;;;Argument[0];MapKey of Argument[-1];value"
			AbstractMapEntry out = null;
			Object in = source();
			out = new MyAbstractMapEntry(in, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;AbstractMapEntry;true;AbstractMapEntry;;;Argument[1];MapValue of Argument[-1];value"
			AbstractMapEntry out = null;
			Object in = source();
			out = new MyAbstractMapEntry(null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;AbstractMapEntryDecorator;true;AbstractMapEntryDecorator;;;MapKey of Argument[0];MapKey of Argument[-1];value"
			AbstractMapEntryDecorator out = null;
			Map.Entry<String,String> in = newMAMEWithMapKey((String)source());
			out = new MyAbstractMapEntryDecorator(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;AbstractMapEntryDecorator;true;AbstractMapEntryDecorator;;;MapValue of Argument[0];MapValue of Argument[-1];value"
			AbstractMapEntryDecorator out = null;
			Map.Entry<String,String> in = newMAMEWithMapValue((String)source());
			out = new MyAbstractMapEntryDecorator(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;AbstractMapEntryDecorator;true;getMapEntry;;;MapKey of Argument[-1];MapKey of ReturnValue;value"
			Map.Entry<String,String> out = null;
			MyAbstractMapEntryDecorator in = newMAMEDWithMapKey((String)source());
			out = in.myGetMapEntry();
			sink(getMapKeyFromEntry(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;AbstractMapEntryDecorator;true;getMapEntry;;;MapValue of Argument[-1];MapValue of ReturnValue;value"
			Map.Entry<String,String> out = null;
			MyAbstractMapEntryDecorator in = newMAMEDWithMapValue((String)source());
			out = in.myGetMapEntry();
			sink(getMapValueFromEntry(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;DefaultKeyValue;true;DefaultKeyValue;(Entry);;MapKey of Argument[0];MapKey of Argument[-1];value"
			DefaultKeyValue out = null;
			Map.Entry<String,String> in = newMAMEWithMapKey((String)source());
			out = new DefaultKeyValue(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;DefaultKeyValue;true;DefaultKeyValue;(Entry);;MapValue of Argument[0];MapValue of Argument[-1];value"
			DefaultKeyValue out = null;
			Map.Entry<String,String> in = newMAMEWithMapValue((String)source());
			out = new DefaultKeyValue(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;DefaultKeyValue;true;DefaultKeyValue;(KeyValue);;MapKey of Argument[0];MapKey of Argument[-1];value"
			DefaultKeyValue out = null;
			KeyValue in = newMAKVWithMapKey((String)source());
			out = new DefaultKeyValue(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;DefaultKeyValue;true;DefaultKeyValue;(KeyValue);;MapValue of Argument[0];MapValue of Argument[-1];value"
			DefaultKeyValue out = null;
			KeyValue in = newMAKVWithMapValue((String)source());
			out = new DefaultKeyValue(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;DefaultKeyValue;true;DefaultKeyValue;(Object,Object);;Argument[0];MapKey of Argument[-1];value"
			DefaultKeyValue out = null;
			Object in = source();
			out = new DefaultKeyValue(in, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;DefaultKeyValue;true;DefaultKeyValue;(Object,Object);;Argument[1];MapValue of Argument[-1];value"
			DefaultKeyValue out = null;
			Object in = source();
			out = new DefaultKeyValue(null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;DefaultKeyValue;true;toMapEntry;;;MapKey of Argument[-1];MapKey of ReturnValue;value"
			Map.Entry<String,String> out = null;
			DefaultKeyValue in = newDKVWithMapKey((String)source());
			out = in.toMapEntry();
			sink(getMapKeyFromEntry(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;DefaultKeyValue;true;toMapEntry;;;MapValue of Argument[-1];MapValue of ReturnValue;value"
			Map.Entry<String,String> out = null;
			DefaultKeyValue in = newDKVWithMapValue((String)source());
			out = in.toMapEntry();
			sink(getMapValueFromEntry(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;DefaultMapEntry;true;DefaultMapEntry;(Entry);;MapKey of Argument[0];MapKey of Argument[-1];value"
			DefaultMapEntry out = null;
			Map.Entry<String,String> in = newMAMEWithMapKey((String)source());
			out = new DefaultMapEntry(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;DefaultMapEntry;true;DefaultMapEntry;(Entry);;MapValue of Argument[0];MapValue of Argument[-1];value"
			DefaultMapEntry out = null;
			Map.Entry<String,String> in = newMAMEWithMapValue((String)source());
			out = new DefaultMapEntry(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;DefaultMapEntry;true;DefaultMapEntry;(KeyValue);;MapKey of Argument[0];MapKey of Argument[-1];value"
			DefaultMapEntry out = null;
			KeyValue in = newMAKVWithMapKey((String)source());
			out = new DefaultMapEntry(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;DefaultMapEntry;true;DefaultMapEntry;(KeyValue);;MapValue of Argument[0];MapValue of Argument[-1];value"
			DefaultMapEntry out = null;
			KeyValue in = newMAKVWithMapValue((String)source());
			out = new DefaultMapEntry(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;DefaultMapEntry;true;DefaultMapEntry;(Object,Object);;Argument[0];MapKey of Argument[-1];value"
			DefaultMapEntry out = null;
			Object in = source();
			out = new DefaultMapEntry(in, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;DefaultMapEntry;true;DefaultMapEntry;(Object,Object);;Argument[1];MapValue of Argument[-1];value"
			DefaultMapEntry out = null;
			Object in = source();
			out = new DefaultMapEntry(null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;TiedMapEntry;true;TiedMapEntry;;;Argument[1];MapKey of Argument[-1];value"
			TiedMapEntry out = null;
			Object in = source();
			out = new TiedMapEntry(null, in);
			sink(getMapKeyFromEntry(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;TiedMapEntry;true;TiedMapEntry;;;MapValue of Argument[0];MapValue of Argument[-1];value"
			TiedMapEntry out = null;
			Map in = newTreeMapWithMapValue((String)source());
			out = new TiedMapEntry(in, null);
			sink(getMapValueFromEntry(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(Entry);;MapKey of Argument[0];MapKey of Argument[-1];value"
			UnmodifiableMapEntry out = null;
			Map.Entry<String,String> in = newMAMEWithMapKey((String)source());
			out = new UnmodifiableMapEntry(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(Entry);;MapValue of Argument[0];MapValue of Argument[-1];value"
			UnmodifiableMapEntry out = null;
			Map.Entry<String,String> in = newMAMEWithMapValue((String)source());
			out = new UnmodifiableMapEntry(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(KeyValue);;MapKey of Argument[0];MapKey of Argument[-1];value"
			UnmodifiableMapEntry out = null;
			KeyValue in = newMAKVWithMapKey((String)source());
			out = new UnmodifiableMapEntry(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(KeyValue);;MapValue of Argument[0];MapValue of Argument[-1];value"
			UnmodifiableMapEntry out = null;
			KeyValue in = newMAKVWithMapValue((String)source());
			out = new UnmodifiableMapEntry(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(Object,Object);;Argument[0];MapKey of Argument[-1];value"
			UnmodifiableMapEntry out = null;
			Object in = source();
			out = new UnmodifiableMapEntry(in, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(Object,Object);;Argument[1];MapValue of Argument[-1];value"
			UnmodifiableMapEntry out = null;
			Object in = source();
			out = new UnmodifiableMapEntry(null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;KeyValue;true;getKey;;;MapKey of Argument[-1];ReturnValue;value"
			Object out = null;
			TiedMapEntry in = newTMEWithMapKey((String)source());
			out = in.getKey();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;KeyValue;true;getKey;;;MapKey of Argument[-1];ReturnValue;value"
			Object out = null;
			KeyValue in = newMAKVWithMapKey((String)source());
			out = in.getKey();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;KeyValue;true;getKey;;;MapKey of Argument[-1];ReturnValue;value"
			Object out = null;
			AbstractMapEntryDecorator in = newMAMEDWithMapKey((String)source());
			out = in.getKey();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;KeyValue;true;getKey;;;MapKey of Argument[-1];ReturnValue;value"
			Object out = null;
			AbstractKeyValue in = newMAKVWithMapKey((String)source());
			out = in.getKey();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;KeyValue;true;getValue;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			TiedMapEntry in = newTMEWithMapValue((String)source());
			out = in.getValue();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;KeyValue;true;getValue;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			KeyValue in = newMAKVWithMapValue((String)source());
			out = in.getValue();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;KeyValue;true;getValue;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			AbstractMapEntryDecorator in = newMAMEDWithMapValue((String)source());
			out = in.getValue();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;KeyValue;true;getValue;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			AbstractKeyValue in = newMAKVWithMapValue((String)source());
			out = in.getValue();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;emptyIfNull;;;Argument[0];ReturnValue;value"
			Map out = null;
			Map in = (Map)source();
			out = MapUtils.emptyIfNull(in);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;fixedSizeMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			IterableMap out = null;
			Map in = newTreeMapWithMapKey((String)source());
			out = MapUtils.fixedSizeMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;fixedSizeMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			IterableMap out = null;
			Map in = newTreeMapWithMapValue((String)source());
			out = MapUtils.fixedSizeMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;fixedSizeSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			SortedMap out = null;
			SortedMap in = newTreeMapWithMapKey((String)source());
			out = MapUtils.fixedSizeSortedMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;fixedSizeSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			SortedMap out = null;
			SortedMap in = newTreeMapWithMapValue((String)source());
			out = MapUtils.fixedSizeSortedMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;getMap;;;Argument[2];ReturnValue;value"
			Map out = null;
			Map in = (Map)source();
			out = MapUtils.getMap(null, null, in);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;getMap;;;MapValue of Argument[0];ReturnValue;value"
			Map out = null;
			Map in = newTreeMapWithMapValue((String)source());
			out = MapUtils.getMap(in, null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;getMap;;;MapValue of Argument[0];ReturnValue;value"
			Map out = null;
			Map in = newTreeMapWithMapValue((String)source());
			out = MapUtils.getMap(in, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;getObject;;;Argument[2];ReturnValue;value"
			Object out = null;
			Object in = source();
			out = MapUtils.getObject(null, null, in);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;getObject;;;MapValue of Argument[0];ReturnValue;value"
			Object out = null;
			Map in = newTreeMapWithMapValue((String)source());
			out = MapUtils.getObject(in, null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;getObject;;;MapValue of Argument[0];ReturnValue;value"
			Object out = null;
			Map in = newTreeMapWithMapValue((String)source());
			out = MapUtils.getObject(in, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;getString;;;Argument[2];ReturnValue;value"
			String out = null;
			String in = (String)source();
			out = MapUtils.getString(null, null, in);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;getString;;;MapValue of Argument[0];ReturnValue;value"
			String out = null;
			Map in = newTreeMapWithMapValue((String)source());
			out = MapUtils.getString(in, null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;getString;;;MapValue of Argument[0];ReturnValue;value"
			String out = null;
			Map in = newTreeMapWithMapValue((String)source());
			out = MapUtils.getString(in, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;invertMap;;;MapKey of Argument[0];MapValue of ReturnValue;value"
			Map out = null;
			Map in = newTreeMapWithMapKey((String)source());
			out = MapUtils.invertMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;invertMap;;;MapValue of Argument[0];MapKey of ReturnValue;value"
			Map out = null;
			Map in = newTreeMapWithMapValue((String)source());
			out = MapUtils.invertMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;iterableMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			IterableMap out = null;
			Map in = newTreeMapWithMapKey((String)source());
			out = MapUtils.iterableMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;iterableMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			IterableMap out = null;
			Map in = newTreeMapWithMapValue((String)source());
			out = MapUtils.iterableMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;iterableSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			IterableSortedMap out = null;
			SortedMap in = newTreeMapWithMapKey((String)source());
			out = MapUtils.iterableSortedMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;iterableSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			IterableSortedMap out = null;
			SortedMap in = newTreeMapWithMapValue((String)source());
			out = MapUtils.iterableSortedMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;lazyMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			IterableMap out = null;
			Map in = newTreeMapWithMapKey((String)source());
			out = MapUtils.lazyMap(in, (Transformer)null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;lazyMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			IterableMap out = null;
			Map in = newTreeMapWithMapKey((String)source());
			out = MapUtils.lazyMap(in, (Factory)null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;lazyMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			IterableMap out = null;
			Map in = newTreeMapWithMapValue((String)source());
			out = MapUtils.lazyMap(in, (Transformer)null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;lazyMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			IterableMap out = null;
			Map in = newTreeMapWithMapValue((String)source());
			out = MapUtils.lazyMap(in, (Factory)null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;lazySortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			SortedMap out = null;
			SortedMap in = newTreeMapWithMapKey((String)source());
			out = MapUtils.lazySortedMap(in, (Transformer)null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;lazySortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			SortedMap out = null;
			SortedMap in = newTreeMapWithMapKey((String)source());
			out = MapUtils.lazySortedMap(in, (Factory)null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;lazySortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			SortedMap out = null;
			SortedMap in = newTreeMapWithMapValue((String)source());
			out = MapUtils.lazySortedMap(in, (Transformer)null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;lazySortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			SortedMap out = null;
			SortedMap in = newTreeMapWithMapValue((String)source());
			out = MapUtils.lazySortedMap(in, (Factory)null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;multiValueMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			MultiValueMap out = null;
			Map in = newTreeMapWithMapKey((String)source());
			out = MapUtils.multiValueMap(in, (Factory)null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;multiValueMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			MultiValueMap out = null;
			Map in = newTreeMapWithMapKey((String)source());
			out = MapUtils.multiValueMap(in, (Class)null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;multiValueMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			MultiValueMap out = null;
			Map in = newTreeMapWithMapKey((String)source());
			out = MapUtils.multiValueMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;multiValueMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			MultiValueMap out = null;
			Map in = newTreeMapWithMapValue((String)source());
			out = MapUtils.multiValueMap(in, (Factory)null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;multiValueMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			MultiValueMap out = null;
			Map in = newTreeMapWithMapValue((String)source());
			out = MapUtils.multiValueMap(in, (Class)null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;multiValueMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			MultiValueMap out = null;
			Map in = newTreeMapWithMapValue((String)source());
			out = MapUtils.multiValueMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;orderedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			OrderedMap out = null;
			Map in = newTreeMapWithMapKey((String)source());
			out = MapUtils.orderedMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;orderedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			OrderedMap out = null;
			Map in = newTreeMapWithMapValue((String)source());
			out = MapUtils.orderedMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;populateMap;(Map,Iterable,Transformer);;Element of Argument[1];MapValue of Argument[0];value"
			Map out = null;
			Iterable in = newVectorWithElement((String)source());
			MapUtils.populateMap(out, in, (Transformer)null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// Note it is tricky to get this to compile - the compiler thinks it is ambiguous
			// which overload it should choose unless you put the generic types in correctly
			// "org.apache.commons.collections4;MapUtils;true;populateMap;(MultiMap,Iterable,Transformer);;Element of Argument[1];Element of MapValue of Argument[0];value"
			MultiMap<Integer, String> out = null;
			Iterable<String> in = newVectorWithElement((String)source());
			MapUtils.populateMap(out, in, (Transformer<String, Integer>)null);
			sink(getElement((Collection)getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;predicatedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			IterableMap out = null;
			Map in = newTreeMapWithMapKey((String)source());
			out = MapUtils.predicatedMap(in, null, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;predicatedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			IterableMap out = null;
			Map in = newTreeMapWithMapValue((String)source());
			out = MapUtils.predicatedMap(in, null, null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;predicatedSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			SortedMap out = null;
			SortedMap in = newTreeMapWithMapKey((String)source());
			out = MapUtils.predicatedSortedMap(in, null, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;predicatedSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			SortedMap out = null;
			SortedMap in = newTreeMapWithMapValue((String)source());
			out = MapUtils.predicatedSortedMap(in, null, null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;putAll;;;ArrayElement of Argument[1];MapKey of Argument[0];value"
			Map out = null;
			Object[] in = newWithArrayElement((String)source());
			MapUtils.putAll(out, in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;putAll;;;ArrayElement of Argument[1];MapKey of ReturnValue;value"
			Map out = null;
			Object[] in = newWithArrayElement((String)source());
			out = MapUtils.putAll(null, in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;putAll;;;ArrayElement of Argument[1];MapValue of Argument[0];value"
			Map out = null;
			Object[] in = newWithArrayElement((String)source());
			MapUtils.putAll(out, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;putAll;;;ArrayElement of Argument[1];MapValue of ReturnValue;value"
			Map out = null;
			Object[] in = newWithArrayElement((String)source());
			out = MapUtils.putAll(null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;putAll;;;ArrayElement of ArrayElement of Argument[1];MapKey of Argument[0];value"
			Map out = null;
			Object[] in = newWithArrayElement(newWithArrayElement((String)source()));
			MapUtils.putAll(out, in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;putAll;;;ArrayElement of ArrayElement of Argument[1];MapKey of ReturnValue;value"
			Map out = null;
			Object[] in = newWithArrayElement(newWithArrayElement((String)source()));
			out = MapUtils.putAll(null, in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;putAll;;;ArrayElement of ArrayElement of Argument[1];MapValue of Argument[0];value"
			Map out = null;
			Object[] in = newWithArrayElement(newWithArrayElement((String)source()));
			MapUtils.putAll(out, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;putAll;;;ArrayElement of ArrayElement of Argument[1];MapValue of ReturnValue;value"
			Map out = null;
			Object[] in = newWithArrayElement(newWithArrayElement((String)source()));
			out = MapUtils.putAll(null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;putAll;;;MapKey of ArrayElement of Argument[1];MapKey of Argument[0];value"
			Map out = null;
			Object[] in = newWithArrayElement(newMAKVWithMapKey((String)source()));
			MapUtils.putAll(out, in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;putAll;;;MapKey of ArrayElement of Argument[1];MapKey of ReturnValue;value"
			Map out = null;
			Object[] in = newWithArrayElement(newMAKVWithMapKey((String)source()));
			out = MapUtils.putAll(null, in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;putAll;;;MapValue of ArrayElement of Argument[1];MapValue of Argument[0];value"
			Map out = null;
			Object[] in = newWithArrayElement(newMAKVWithMapValue((String)source()));
			MapUtils.putAll(out, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;putAll;;;MapValue of ArrayElement of Argument[1];MapValue of ReturnValue;value"
			Map out = null;
			Object[] in = newWithArrayElement(newMAKVWithMapValue((String)source()));
			out = MapUtils.putAll(null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;safeAddToMap;;;Argument[1];MapKey of Argument[0];value"
			Map out = null;
			Object in = source();
			MapUtils.safeAddToMap(out, in, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;safeAddToMap;;;Argument[2];MapValue of Argument[0];value"
			Map out = null;
			Object in = source();
			MapUtils.safeAddToMap(out, null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;synchronizedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			Map out = null;
			Map in = newTreeMapWithMapKey((String)source());
			out = MapUtils.synchronizedMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;synchronizedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			Map out = null;
			Map in = newTreeMapWithMapValue((String)source());
			out = MapUtils.synchronizedMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;synchronizedSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			SortedMap out = null;
			SortedMap in = newTreeMapWithMapKey((String)source());
			out = MapUtils.synchronizedSortedMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;synchronizedSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			SortedMap out = null;
			SortedMap in = newTreeMapWithMapValue((String)source());
			out = MapUtils.synchronizedSortedMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;toMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			Map out = null;
			ResourceBundle in = newRBWithMapKey((String)source());
			out = MapUtils.toMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;toMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			Map out = null;
			ResourceBundle in = newRBWithMapValue((String)source());
			out = MapUtils.toMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;transformedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			IterableMap out = null;
			Map in = newTreeMapWithMapKey((String)source());
			out = MapUtils.transformedMap(in, null, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;transformedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			IterableMap out = null;
			Map in = newTreeMapWithMapValue((String)source());
			out = MapUtils.transformedMap(in, null, null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;transformedSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			SortedMap out = null;
			SortedMap in = newTreeMapWithMapKey((String)source());
			out = MapUtils.transformedSortedMap(in, null, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;transformedSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			SortedMap out = null;
			SortedMap in = newTreeMapWithMapValue((String)source());
			out = MapUtils.transformedSortedMap(in, null, null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;unmodifiableMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			Map out = null;
			Map in = newTreeMapWithMapKey((String)source());
			out = MapUtils.unmodifiableMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;unmodifiableMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			Map out = null;
			Map in = newTreeMapWithMapValue((String)source());
			out = MapUtils.unmodifiableMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;unmodifiableSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			SortedMap out = null;
			SortedMap in = newTreeMapWithMapKey((String)source());
			out = MapUtils.unmodifiableSortedMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapUtils;true;unmodifiableSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			SortedMap out = null;
			SortedMap in = newTreeMapWithMapValue((String)source());
			out = MapUtils.unmodifiableSortedMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ArrayStack;true;peek;;;Element of Argument[-1];ReturnValue;value"
			Object out = null;
			ArrayStack in = newArrayStackWithElement((String)source());
			out = in.peek(0);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ArrayStack;true;peek;;;Element of Argument[-1];ReturnValue;value"
			Object out = null;
			ArrayStack in = newArrayStackWithElement((String)source());
			out = in.peek();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ArrayStack;true;pop;;;Element of Argument[-1];ReturnValue;value"
			Object out = null;
			ArrayStack in = newArrayStackWithElement((String)source());
			out = in.pop();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ArrayStack;true;push;;;Argument[0];Element of Argument[-1];value"
			ArrayStack out = null;
			Object in = source();
			out.push(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ArrayStack;true;push;;;Argument[0];ReturnValue;value"
			Object out = null;
			Object in = source();
			ArrayStack instance = null;
			out = instance.push(in);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Bag;true;add;;;Argument[0];Element of Argument[-1];value"
			Bag out = null;
			Object in = source();
			out.add(in, 0);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Bag;true;add;;;Argument[0];Element of Argument[-1];value"
			Bag out = null;
			Object in = source();
			out.add(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Bag;true;uniqueSet;;;Element of Argument[-1];Element of ReturnValue;value"
			Set out = null;
			Bag in = newTreeBagWithElement((String)source());
			out = in.uniqueSet();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;BagUtils;true;collectionBag;;;Element of Argument[0];Element of ReturnValue;value"
			Bag out = null;
			Bag in = newTreeBagWithElement((String)source());
			out = BagUtils.collectionBag(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;BagUtils;true;predicatedBag;;;Element of Argument[0];Element of ReturnValue;value"
			Bag out = null;
			Bag in = newTreeBagWithElement((String)source());
			out = BagUtils.predicatedBag(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;BagUtils;true;predicatedSortedBag;;;Element of Argument[0];Element of ReturnValue;value"
			SortedBag out = null;
			SortedBag in = newTreeBagWithElement((String)source());
			out = BagUtils.predicatedSortedBag(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;BagUtils;true;synchronizedBag;;;Element of Argument[0];Element of ReturnValue;value"
			Bag out = null;
			Bag in = newTreeBagWithElement((String)source());
			out = BagUtils.synchronizedBag(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;BagUtils;true;synchronizedSortedBag;;;Element of Argument[0];Element of ReturnValue;value"
			SortedBag out = null;
			SortedBag in = newTreeBagWithElement((String)source());
			out = BagUtils.synchronizedSortedBag(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;BagUtils;true;transformingBag;;;Element of Argument[0];Element of ReturnValue;value"
			Bag out = null;
			Bag in = newTreeBagWithElement((String)source());
			out = BagUtils.transformingBag(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;BagUtils;true;transformingSortedBag;;;Element of Argument[0];Element of ReturnValue;value"
			SortedBag out = null;
			SortedBag in = newTreeBagWithElement((String)source());
			out = BagUtils.transformingSortedBag(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;BagUtils;true;unmodifiableBag;;;Element of Argument[0];Element of ReturnValue;value"
			Bag out = null;
			Bag in = newTreeBagWithElement((String)source());
			out = BagUtils.unmodifiableBag(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;BagUtils;true;unmodifiableSortedBag;;;Element of Argument[0];Element of ReturnValue;value"
			SortedBag out = null;
			SortedBag in = newTreeBagWithElement((String)source());
			out = BagUtils.unmodifiableSortedBag(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;BidiMap;true;getKey;;;MapKey of Argument[-1];ReturnValue;value"
			Object out = null;
			BidiMap in = newTreeBidiMapWithMapKey((String)source());
			out = in.getKey(null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;BidiMap;true;inverseBidiMap;;;MapKey of Argument[-1];MapValue of ReturnValue;value"
			BidiMap out = null;
			BidiMap in = newTreeBidiMapWithMapKey((String)source());
			out = in.inverseBidiMap();
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;BidiMap;true;inverseBidiMap;;;MapValue of Argument[-1];MapKey of ReturnValue;value"
			BidiMap out = null;
			BidiMap in = newTreeBidiMapWithMapValue((String)source());
			out = in.inverseBidiMap();
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;BidiMap;true;removeValue;;;MapKey of Argument[-1];ReturnValue;value"
			Object out = null;
			BidiMap in = newTreeBidiMapWithMapKey((String)source());
			out = in.removeValue(null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;addAll;(Collection,Enumeration);;Element of Argument[1];Element of Argument[0];value"
			Collection out = null;
			Enumeration in = newEnumerationWithElement((String)source());
			CollectionUtils.addAll(out, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;addAll;(Collection,Iterable);;Element of Argument[1];Element of Argument[0];value"
			Collection out = null;
			Iterable in = newVectorWithElement((String)source());
			CollectionUtils.addAll(out, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;addAll;(Collection,Iterator);;Element of Argument[1];Element of Argument[0];value"
			Collection out = null;
			Iterator in = newListIteratorWithElement((String)source());
			CollectionUtils.addAll(out, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;addAll;(Collection,Object[]);;ArrayElement of Argument[1];Element of Argument[0];value"
			Collection out = null;
			Object[] in = newWithArrayElement((String)source());
			CollectionUtils.addAll(out, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;addIgnoreNull;;;Argument[1];Element of Argument[0];value"
			Collection out = null;
			Object in = source();
			CollectionUtils.addIgnoreNull(out, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;collate;;;Element of Argument[0];Element of ReturnValue;value"
			List out = null;
			Iterable in = newVectorWithElement((String)source());
			out = CollectionUtils.collate(in, null, null, false);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;collate;;;Element of Argument[0];Element of ReturnValue;value"
			List out = null;
			Iterable in = newVectorWithElement((String)source());
			out = CollectionUtils.collate(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;collate;;;Element of Argument[0];Element of ReturnValue;value"
			List out = null;
			Iterable in = newVectorWithElement((String)source());
			out = CollectionUtils.collate(in, (Iterable)null, false);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;collate;;;Element of Argument[0];Element of ReturnValue;value"
			List out = null;
			Iterable in = newVectorWithElement((String)source());
			out = CollectionUtils.collate(in, (Iterable)null, (Comparator)null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;collate;;;Element of Argument[1];Element of ReturnValue;value"
			List out = null;
			Iterable in = newVectorWithElement((String)source());
			out = CollectionUtils.collate(null, in, null, false);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;collate;;;Element of Argument[1];Element of ReturnValue;value"
			List out = null;
			Iterable in = newVectorWithElement((String)source());
			out = CollectionUtils.collate(null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;collate;;;Element of Argument[1];Element of ReturnValue;value"
			List out = null;
			Iterable in = newVectorWithElement((String)source());
			out = CollectionUtils.collate((Iterable)null, in, false);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;collate;;;Element of Argument[1];Element of ReturnValue;value"
			List out = null;
			Iterable in = newVectorWithElement((String)source());
			out = CollectionUtils.collate((Iterable)null, in, (Comparator)null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;disjunction;;;Element of Argument[0];Element of ReturnValue;value"
			Collection out = null;
			Iterable in = newVectorWithElement((String)source());
			out = CollectionUtils.disjunction(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;disjunction;;;Element of Argument[1];Element of ReturnValue;value"
			Collection out = null;
			Iterable in = newVectorWithElement((String)source());
			out = CollectionUtils.disjunction(null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;emptyIfNull;;;Argument[0];ReturnValue;value"
			Collection out = null;
			Collection in = (Collection)source();
			out = CollectionUtils.emptyIfNull(in);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;extractSingleton;;;Element of Argument[0];ReturnValue;value"
			Object out = null;
			Collection in = newVectorWithElement((String)source());
			out = CollectionUtils.extractSingleton(in);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;find;;;Element of Argument[0];ReturnValue;value"
			Object out = null;
			Iterable in = newVectorWithElement((String)source());
			out = CollectionUtils.find(in, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;get;(Iterator,int);;Element of Argument[0];ReturnValue;value"
			Object out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = CollectionUtils.get(in, 0);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;get;(Iterable,int);;Element of Argument[0];ReturnValue;value"
			Object out = null;
			Iterable in = newVectorWithElement((String)source());
			out = CollectionUtils.get(in, 0);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;get;(Map,int);;MapKey of Argument[0];MapKey of ReturnValue;value"
			Map.Entry out = null;
			Map in = newTreeMapWithMapKey((String)source());
			out = CollectionUtils.get(in, 0);
			sink(getMapKeyFromEntry(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;get;(Map,int);;MapValue of Argument[0];MapValue of ReturnValue;value"
			Map.Entry out = null;
			Map in = newTreeMapWithMapValue((String)source());
			out = CollectionUtils.get(in, 0);
			sink(getMapValueFromEntry(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;get;(Object,int);;ArrayElement of Argument[0];ReturnValue;value"
			Object out = null;
			Object in = newWithArrayElement((String)source());
			out = CollectionUtils.get(in, 0);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;get;(Object,int);;Element of Argument[0];ReturnValue;value"
			Object out = null;
			Object in = newVectorWithElement((String)source());
			out = CollectionUtils.get(in, 0);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;get;(Object,int);;MapKey of Argument[0];MapKey of ReturnValue;value"
			Map.Entry out = null;
			Object in = newTreeMapWithMapKey((String)source());
			out = (Map.Entry)CollectionUtils.get(in, 0);
			sink(getMapKeyFromEntry(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;get;(Object,int);;MapValue of Argument[0];MapValue of ReturnValue;value"
			Map.Entry out = null;
			Object in = newTreeMapWithMapValue((String)source());
			out = (Map.Entry)CollectionUtils.get(in, 0);
			sink(getMapValueFromEntry(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;getCardinalityMap;;;Element of Argument[0];MapKey of ReturnValue;value"
			Map out = null;
			Iterable in = newVectorWithElement((String)source());
			out = CollectionUtils.getCardinalityMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;intersection;;;Element of Argument[0];Element of ReturnValue;value"
			Collection out = null;
			Iterable in = newVectorWithElement((String)source());
			out = CollectionUtils.intersection(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;intersection;;;Element of Argument[1];Element of ReturnValue;value"
			Collection out = null;
			Iterable in = newVectorWithElement((String)source());
			out = CollectionUtils.intersection(null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;permutations;;;Element of Argument[0];Element of Element of ReturnValue;value"
			Collection out = null;
			Collection in = newVectorWithElement((String)source());
			out = CollectionUtils.permutations(in);
			sink(getElement((Iterable)getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;predicatedCollection;;;Element of Argument[0];Element of ReturnValue;value"
			Collection out = null;
			Collection in = newVectorWithElement((String)source());
			out = CollectionUtils.predicatedCollection(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;removeAll;;;Element of Argument[0];Element of ReturnValue;value"
			Collection out = null;
			Iterable in = newVectorWithElement((String)source());
			out = CollectionUtils.removeAll(in, null, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;removeAll;;;Element of Argument[0];Element of ReturnValue;value"
			Collection out = null;
			Collection in = newVectorWithElement((String)source());
			out = CollectionUtils.removeAll(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;retainAll;;;Element of Argument[0];Element of ReturnValue;value"
			Collection out = null;
			Iterable in = newVectorWithElement((String)source());
			out = CollectionUtils.retainAll(in, null, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;retainAll;;;Element of Argument[0];Element of ReturnValue;value"
			Collection out = null;
			Collection in = newVectorWithElement((String)source());
			out = CollectionUtils.retainAll(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;select;(Iterable,Predicate);;Element of Argument[0];Element of ReturnValue;value"
			Collection out = null;
			Iterable in = newVectorWithElement((String)source());
			out = CollectionUtils.select(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;select;(Iterable,Predicate,Collection);;Argument[2];ReturnValue;value"
			Collection out = null;
			Collection in = (Collection)source();
			out = CollectionUtils.select(null, null, in);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;select;(Iterable,Predicate,Collection);;Element of Argument[0];Element of Argument[2];value"
			Collection out = null;
			Iterable in = newVectorWithElement((String)source());
			CollectionUtils.select(in, null, out);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			Collection mid = null;
			Collection out = null;
			Iterable in = newVectorWithElement((String)source());
			out = CollectionUtils.select(in, null, mid);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;select;(Iterable,Predicate,Collection,Collection);;Argument[2];ReturnValue;value"
			Collection out = null;
			Collection in = (Collection)source();
			out = CollectionUtils.select(null, null, in, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;select;(Iterable,Predicate,Collection,Collection);;Element of Argument[0];Element of Argument[2];value"
			Collection out = null;
			Iterable in = newVectorWithElement((String)source());
			CollectionUtils.select(in, null, out, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			Collection mid = null;
			Collection out = null;
			Iterable in = newVectorWithElement((String)source());
			out = CollectionUtils.select(in, null, mid, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;select;(Iterable,Predicate,Collection,Collection);;Element of Argument[0];Element of Argument[3];value"
			Collection out = null;
			Iterable in = newVectorWithElement((String)source());
			CollectionUtils.select(in, null, null, out);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;selectRejected;(Iterable,Predicate);;Element of Argument[0];Element of ReturnValue;value"
			Collection out = null;
			Iterable in = newVectorWithElement((String)source());
			out = CollectionUtils.selectRejected(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;selectRejected;(Iterable,Predicate,Collection);;Argument[2];ReturnValue;value"
			Collection out = null;
			Collection in = (Collection)source();
			out = CollectionUtils.selectRejected(null, null, in);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;selectRejected;(Iterable,Predicate,Collection);;Element of Argument[0];Element of Argument[2];value"
			Collection out = null;
			Iterable in = newVectorWithElement((String)source());
			CollectionUtils.selectRejected(in, null, out);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;subtract;;;Element of Argument[0];Element of ReturnValue;value"
			Collection out = null;
			Iterable in = newVectorWithElement((String)source());
			out = CollectionUtils.subtract(in, null, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;subtract;;;Element of Argument[0];Element of ReturnValue;value"
			Collection out = null;
			Iterable in = newVectorWithElement((String)source());
			out = CollectionUtils.subtract(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;synchronizedCollection;;;Element of Argument[0];Element of ReturnValue;value"
			Collection out = null;
			Collection in = newVectorWithElement((String)source());
			out = CollectionUtils.synchronizedCollection(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;transformingCollection;;;Element of Argument[0];Element of ReturnValue;value"
			Collection out = null;
			Collection in = newVectorWithElement((String)source());
			out = CollectionUtils.transformingCollection(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;union;;;Element of Argument[0];Element of ReturnValue;value"
			Collection out = null;
			Iterable in = newVectorWithElement((String)source());
			out = CollectionUtils.union(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;union;;;Element of Argument[1];Element of ReturnValue;value"
			Collection out = null;
			Iterable in = newVectorWithElement((String)source());
			out = CollectionUtils.union(null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;CollectionUtils;true;unmodifiableCollection;;;Element of Argument[0];Element of ReturnValue;value"
			Collection out = null;
			Collection in = newVectorWithElement((String)source());
			out = CollectionUtils.unmodifiableCollection(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;EnumerationUtils;true;get;;;Element of Argument[0];ReturnValue;value"
			Object out = null;
			Enumeration in = newEnumerationWithElement((String)source());
			out = EnumerationUtils.get(in, 0);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;EnumerationUtils;true;toList;(Enumeration);;Element of Argument[0];Element of ReturnValue;value"
			List out = null;
			Enumeration in = newEnumerationWithElement((String)source());
			out = EnumerationUtils.toList(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;EnumerationUtils;true;toList;(StringTokenizer);;Argument[0];Element of ReturnValue;taint"
			List out = null;
			StringTokenizer in = (StringTokenizer)source();
			out = EnumerationUtils.toList(in);
			sink(getElement(out)); // $ hasTaintFlow
		}
		{
			// "org.apache.commons.collections4;FluentIterable;true;append;(Iterable);;Element of Argument[-1];Element of ReturnValue;value"
			FluentIterable out = null;
			FluentIterable in = newFluentIterableWithElement((String)source());
			out = in.append((Iterable)null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;FluentIterable;true;append;(Iterable);;Element of Argument[0];Element of ReturnValue;value"
			FluentIterable out = null;
			Iterable in = newFluentIterableWithElement((String)source());
			FluentIterable instance = null;
			out = instance.append(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;FluentIterable;true;append;(Object[]);;ArrayElement of Argument[0];Element of ReturnValue;value"
			FluentIterable out = null;
			Object in = source();
			FluentIterable instance = null;
			out = instance.append(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;FluentIterable;true;append;(Object[]);;Element of Argument[-1];Element of ReturnValue;value"
			FluentIterable out = null;
			FluentIterable in = newFluentIterableWithElement((String)source());
			out = in.append();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;FluentIterable;true;asEnumeration;;;Element of Argument[-1];Element of ReturnValue;value"
			Enumeration out = null;
			FluentIterable in = newFluentIterableWithElement((String)source());
			out = in.asEnumeration();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;FluentIterable;true;collate;;;Element of Argument[-1];Element of ReturnValue;value"
			FluentIterable out = null;
			FluentIterable in = newFluentIterableWithElement((String)source());
			out = in.collate(null, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;FluentIterable;true;collate;;;Element of Argument[-1];Element of ReturnValue;value"
			FluentIterable out = null;
			FluentIterable in = newFluentIterableWithElement((String)source());
			out = in.collate(null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;FluentIterable;true;collate;;;Element of Argument[0];Element of ReturnValue;value"
			FluentIterable out = null;
			Iterable in = newFluentIterableWithElement((String)source());
			FluentIterable instance = null;
			out = instance.collate(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;FluentIterable;true;collate;;;Element of Argument[0];Element of ReturnValue;value"
			FluentIterable out = null;
			Iterable in = newFluentIterableWithElement((String)source());
			FluentIterable instance = null;
			out = instance.collate(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;FluentIterable;true;copyInto;;;Element of Argument[-1];Element of Argument[0];value"
			Collection out = null;
			FluentIterable in = newFluentIterableWithElement((String)source());
			in.copyInto(out);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;FluentIterable;true;eval;;;Element of Argument[-1];Element of ReturnValue;value"
			FluentIterable out = null;
			FluentIterable in = newFluentIterableWithElement((String)source());
			out = in.eval();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;FluentIterable;true;filter;;;Element of Argument[-1];Element of ReturnValue;value"
			FluentIterable out = null;
			FluentIterable in = newFluentIterableWithElement((String)source());
			out = in.filter(null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;FluentIterable;true;get;;;Element of Argument[-1];ReturnValue;value"
			Object out = null;
			FluentIterable in = newFluentIterableWithElement((String)source());
			out = in.get(0);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;FluentIterable;true;limit;;;Element of Argument[-1];Element of ReturnValue;value"
			FluentIterable out = null;
			FluentIterable in = newFluentIterableWithElement((String)source());
			out = in.limit(0L);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;FluentIterable;true;loop;;;Element of Argument[-1];Element of ReturnValue;value"
			FluentIterable out = null;
			FluentIterable in = newFluentIterableWithElement((String)source());
			out = in.loop();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;FluentIterable;true;of;(Iterable);;Element of Argument[0];Element of ReturnValue;value"
			FluentIterable out = null;
			Iterable in = newFluentIterableWithElement((String)source());
			out = FluentIterable.of(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;FluentIterable;true;of;(Object);;Argument[0];Element of ReturnValue;value"
			FluentIterable out = null;
			Object in = source();
			out = FluentIterable.of(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;FluentIterable;true;of;(Object[]);;ArrayElement of Argument[0];Element of ReturnValue;value"
			FluentIterable out = null;
			Object[] in = newWithArrayElement((String)source());
			out = FluentIterable.of(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;FluentIterable;true;reverse;;;Element of Argument[-1];Element of ReturnValue;value"
			FluentIterable out = null;
			FluentIterable in = newFluentIterableWithElement((String)source());
			out = in.reverse();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;FluentIterable;true;skip;;;Element of Argument[-1];Element of ReturnValue;value"
			FluentIterable out = null;
			FluentIterable in = newFluentIterableWithElement((String)source());
			out = in.skip(0L);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;FluentIterable;true;toArray;;;Element of Argument[-1];ArrayElement of ReturnValue;value"
			Object[] out = null;
			FluentIterable in = newFluentIterableWithElement((String)source());
			out = in.toArray(null);
			sink(getArrayElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;FluentIterable;true;toList;;;Element of Argument[-1];Element of ReturnValue;value"
			List out = null;
			FluentIterable in = newFluentIterableWithElement((String)source());
			out = in.toList();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;FluentIterable;true;unique;;;Element of Argument[-1];Element of ReturnValue;value"
			FluentIterable out = null;
			FluentIterable in = newFluentIterableWithElement((String)source());
			out = in.unique();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;FluentIterable;true;unmodifiable;;;Element of Argument[-1];Element of ReturnValue;value"
			FluentIterable out = null;
			FluentIterable in = newFluentIterableWithElement((String)source());
			out = in.unmodifiable();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;FluentIterable;true;zip;(Iterable);;Element of Argument[-1];Element of ReturnValue;value"
			FluentIterable out = null;
			FluentIterable in = newFluentIterableWithElement((String)source());
			out = in.zip((Iterable)null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;FluentIterable;true;zip;(Iterable);;Element of Argument[0];Element of ReturnValue;value"
			FluentIterable out = null;
			Iterable in = newFluentIterableWithElement((String)source());
			FluentIterable instance = null;
			out = instance.zip(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;FluentIterable;true;zip;(Iterable[]);;Element of Argument[-1];Element of ReturnValue;value"
			FluentIterable out = null;
			FluentIterable in = newFluentIterableWithElement((String)source());
			out = in.zip((Iterable)null, (Iterable)null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;FluentIterable;true;zip;(Iterable[]);;Element of ArrayElement of Argument[0];Element of ReturnValue;value"
			FluentIterable out = null;
			Iterable in = newVectorWithElement((String)source());
			FluentIterable instance = null;
			out = instance.zip(in, (Iterable)null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Get;true;entrySet;;;MapKey of Argument[-1];MapKey of Element of ReturnValue;value"
			Set<Map.Entry> out = null;
			MultiValueMap in = newMVMWithMapKey((String)source());
			out = in.entrySet();
			sink(getMapKeyFromEntry(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Get;true;entrySet;;;MapKey of Argument[-1];MapKey of Element of ReturnValue;value"
			Set<Map.Entry> out = null;
			Get in = newPatriciaTrieWithMapKey((String)source());
			out = in.entrySet();
			sink(getMapKeyFromEntry(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Get;true;entrySet;;;MapKey of Argument[-1];MapKey of Element of ReturnValue;value"
			Set<Map.Entry> out = null;
			AbstractMapDecorator in = newMVMWithMapKey((String)source());
			out = in.entrySet();
			sink(getMapKeyFromEntry(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Get;true;entrySet;;;MapValue of Argument[-1];MapValue of Element of ReturnValue;value"
			Set<Map.Entry> out = null;
			MultiValueMap in = newMVMWithMapValue((String)source());
			out = in.entrySet();
			sink(getMapValueFromEntry(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Get;true;entrySet;;;MapValue of Argument[-1];MapValue of Element of ReturnValue;value"
			Set<Map.Entry> out = null;
			Get in = newPatriciaTrieWithMapValue((String)source());
			out = in.entrySet();
			sink(getMapValueFromEntry(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Get;true;entrySet;;;MapValue of Argument[-1];MapValue of Element of ReturnValue;value"
			Set<Map.Entry> out = null;
			AbstractMapDecorator in = newMVMWithMapValue((String)source());
			out = in.entrySet();
			sink(getMapValueFromEntry(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Get;true;get;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiMap in = newMVMWithMapValue((String)source());
			out = in.get(null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Get;true;get;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			Get in = newPatriciaTrieWithMapValue((String)source());
			out = in.get(null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Get;true;get;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			AbstractMapDecorator in = newMVMWithMapValue((String)source());
			out = in.get(null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Get;true;keySet;();;MapKey of Argument[-1];Element of ReturnValue;value"
			Set out = null;
			Get in = newPatriciaTrieWithMapKey((String)source());
			out = in.keySet();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Get;true;keySet;();;MapKey of Argument[-1];Element of ReturnValue;value"
			Set out = null;
			AbstractMapDecorator in = newMVMWithMapKey((String)source());
			out = in.keySet();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Get;true;remove;(Object);;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiMap in = newMVMWithMapValue((String)source());
			out = in.remove(null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Get;true;remove;(Object);;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			Get in = newPatriciaTrieWithMapValue((String)source());
			out = in.remove(null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Get;true;remove;(Object);;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			AbstractMapDecorator in = newMVMWithMapValue((String)source());
			out = in.remove(null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Get;true;values;();;MapValue of Argument[-1];Element of ReturnValue;value"
			Set out = null;
			BidiMap in = newTreeBidiMapWithMapValue((String)source());
			out = in.values();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Get;true;values;();;MapValue of Argument[-1];Element of ReturnValue;value"
			Collection out = null;
			MultiValueMap in = newMVMWithMapValue((String)source());
			out = in.values();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Get;true;values;();;MapValue of Argument[-1];Element of ReturnValue;value"
			Collection out = null;
			MultiMap in = newMVMWithMapValue((String)source());
			out = in.values();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Get;true;values;();;MapValue of Argument[-1];Element of ReturnValue;value"
			Collection out = null;
			Get in = newPatriciaTrieWithMapValue((String)source());
			out = in.values();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Get;true;values;();;MapValue of Argument[-1];Element of ReturnValue;value"
			Collection out = null;
			AbstractMapDecorator in = newMVMWithMapValue((String)source());
			out = in.values();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableGet;true;mapIterator;;;MapKey of Argument[-1];Element of ReturnValue;value"
			OrderedMapIterator out = null;
			OrderedMap in = newTreeBidiMapWithMapKey((String)source());
			out = in.mapIterator();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableGet;true;mapIterator;;;MapKey of Argument[-1];Element of ReturnValue;value"
			MapIterator out = null;
			IterableGet in = newHashedMapWithMapKey((String)source());
			out = in.mapIterator();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableGet;true;mapIterator;;;MapKey of Argument[-1];Element of ReturnValue;value"
			MapIterator out = null;
			AbstractIterableMap in = newMVMWithMapKey((String)source());
			out = in.mapIterator();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableGet;true;mapIterator;;;MapValue of Argument[-1];MapValue of ReturnValue;value"
			OrderedMapIterator out = null;
			OrderedMap in = newTreeBidiMapWithMapValue((String)source());
			out = in.mapIterator();
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableGet;true;mapIterator;;;MapValue of Argument[-1];MapValue of ReturnValue;value"
			MapIterator out = null;
			IterableGet in = newHashedMapWithMapValue((String)source());
			out = in.mapIterator();
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableGet;true;mapIterator;;;MapValue of Argument[-1];MapValue of ReturnValue;value"
			MapIterator out = null;
			AbstractIterableMap in = newMVMWithMapValue((String)source());
			out = in.mapIterator();
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;boundedIterable;;;Element of Argument[0];Element of ReturnValue;value"
			Iterable out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.boundedIterable(in, 0L);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;chainedIterable;(Iterable[]);;Element of ArrayElement of Argument[0];Element of ReturnValue;value"
			Iterable out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.chainedIterable(in, (Iterable)null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;chainedIterable;(Iterable,Iterable);;Element of Argument[0];Element of ReturnValue;value"
			Iterable out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.chainedIterable(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;chainedIterable;(Iterable,Iterable);;Element of Argument[1];Element of ReturnValue;value"
			Iterable out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.chainedIterable(null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable);;Element of Argument[0];Element of ReturnValue;value"
			Iterable out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.chainedIterable(in, null, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable);;Element of Argument[1];Element of ReturnValue;value"
			Iterable out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.chainedIterable(null, in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable);;Element of Argument[2];Element of ReturnValue;value"
			Iterable out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.chainedIterable(null, null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable,Iterable);;Element of Argument[0];Element of ReturnValue;value"
			Iterable out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.chainedIterable(in, null, null, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable,Iterable);;Element of Argument[1];Element of ReturnValue;value"
			Iterable out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.chainedIterable(null, in, null, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable,Iterable);;Element of Argument[2];Element of ReturnValue;value"
			Iterable out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.chainedIterable(null, null, in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable,Iterable);;Element of Argument[3];Element of ReturnValue;value"
			Iterable out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.chainedIterable(null, null, null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;collatedIterable;(Comparator,Iterable,Iterable);;Element of Argument[1];Element of ReturnValue;value"
			Iterable out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.collatedIterable(null, in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;collatedIterable;(Comparator,Iterable,Iterable);;Element of Argument[2];Element of ReturnValue;value"
			Iterable out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.collatedIterable(null, null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;collatedIterable;(Iterable,Iterable);;Element of Argument[0];Element of ReturnValue;value"
			Iterable out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.collatedIterable(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;collatedIterable;(Iterable,Iterable);;Element of Argument[1];Element of ReturnValue;value"
			Iterable out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.collatedIterable(null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;emptyIfNull;;;Argument[0];ReturnValue;value"
			Iterable out = null;
			Iterable in = (Iterable)source();
			out = IterableUtils.emptyIfNull(in);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;filteredIterable;;;Element of Argument[0];Element of ReturnValue;value"
			Iterable out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.filteredIterable(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;find;;;Element of Argument[0];ReturnValue;value"
			Object out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.find(in, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;first;;;Element of Argument[0];ReturnValue;value"
			Object out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.first(in);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;forEachButLast;;;Element of Argument[0];ReturnValue;value"
			Object out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.forEachButLast(in, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;get;;;Element of Argument[0];ReturnValue;value"
			Object out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.get(in, 0);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;loopingIterable;;;Element of Argument[0];Element of ReturnValue;value"
			Iterable out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.loopingIterable(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;partition;;;Element of Argument[0];Element of Element of ReturnValue;value"
			List out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.partition(in, (Factory)null, (Predicate)null, (Predicate)null);
			sink(getElement((Iterable)getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;partition;;;Element of Argument[0];Element of Element of ReturnValue;value"
			List out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.partition(in, (Predicate)null, (Predicate)null);
			sink(getElement((Iterable)getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;partition;;;Element of Argument[0];Element of Element of ReturnValue;value"
			List out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.partition(in, (Predicate)null, (Predicate)null);
			sink(getElement((Iterable)getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;reversedIterable;;;Element of Argument[0];Element of ReturnValue;value"
			Iterable out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.reversedIterable(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;skippingIterable;;;Element of Argument[0];Element of ReturnValue;value"
			Iterable out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.skippingIterable(in, 0L);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;toList;;;Element of Argument[0];Element of ReturnValue;value"
			List out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.toList(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;toString;;;Argument[2];ReturnValue;taint"
			String out = null;
			String in = (String)source();
			out = IterableUtils.toString(null, null, in, null, null);
			sink(out); // $ hasTaintFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;toString;;;Argument[3];ReturnValue;taint"
			String out = null;
			String in = (String)source();
			out = IterableUtils.toString(null, null, null, in, null);
			sink(out); // $ hasTaintFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;toString;;;Argument[4];ReturnValue;taint"
			String out = null;
			String in = (String)source();
			out = IterableUtils.toString(null, null, null, null, in);
			sink(out); // $ hasTaintFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;uniqueIterable;;;Element of Argument[0];Element of ReturnValue;value"
			Iterable out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.uniqueIterable(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;unmodifiableIterable;;;Element of Argument[0];Element of ReturnValue;value"
			Iterable out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.unmodifiableIterable(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;zippingIterable;(Iterable,Iterable);;Element of Argument[1];Element of ReturnValue;value"
			Iterable out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.zippingIterable((Iterable)null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;zippingIterable;(Iterable,Iterable[]);;Element of ArrayElement of Argument[1];Element of ReturnValue;value"
			Iterable out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.zippingIterable((Iterable)null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;zippingIterable;;;Element of Argument[0];Element of ReturnValue;value"
			Iterable out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.zippingIterable(in, (Iterable)null, (Iterable)null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IterableUtils;true;zippingIterable;;;Element of Argument[0];Element of ReturnValue;value"
			Iterable out = null;
			Iterable in = newVectorWithElement((String)source());
			out = IterableUtils.zippingIterable(in, (Iterable)null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;arrayIterator;;;ArrayElement of Argument[0];Element of ReturnValue;value"
			ResettableIterator out = null;
			Object[] in = newWithArrayElement((String)source());
			out = IteratorUtils.arrayIterator(in, 0, 0);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;arrayIterator;;;ArrayElement of Argument[0];Element of ReturnValue;value"
			ResettableIterator out = null;
			Object[] in = newWithArrayElement((String)source());
			out = IteratorUtils.arrayIterator(in, 0);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;arrayIterator;;;ArrayElement of Argument[0];Element of ReturnValue;value"
			ResettableIterator out = null;
			Object in = source();
			out = IteratorUtils.arrayIterator(in, (Object)null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;arrayIterator;;;ArrayElement of Argument[0];Element of ReturnValue;value"
			ResettableIterator out = null;
			Object in = newWithArrayElement((String)source());
			out = IteratorUtils.arrayIterator(in, 0, 0);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;arrayIterator;;;ArrayElement of Argument[0];Element of ReturnValue;value"
			ResettableIterator out = null;
			Object in = newWithArrayElement((String)source());
			out = IteratorUtils.arrayIterator(in, 0);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;arrayIterator;;;ArrayElement of Argument[0];Element of ReturnValue;value"
			ResettableIterator out = null;
			Object in = newWithArrayElement((String)source());
			out = IteratorUtils.arrayIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;arrayListIterator;;;ArrayElement of Argument[0];Element of ReturnValue;value"
			ResettableListIterator out = null;
			Object[] in = newWithArrayElement((String)source());
			out = IteratorUtils.arrayListIterator(in, 0, 0);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;arrayListIterator;;;ArrayElement of Argument[0];Element of ReturnValue;value"
			ResettableListIterator out = null;
			Object[] in = newWithArrayElement((String)source());
			out = IteratorUtils.arrayListIterator(in, 0);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;arrayListIterator;;;ArrayElement of Argument[0];Element of ReturnValue;value"
			ResettableListIterator out = null;
			Object in = source();
			out = IteratorUtils.arrayListIterator(in, (Object)null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;arrayListIterator;;;ArrayElement of Argument[0];Element of ReturnValue;value"
			ResettableListIterator out = null;
			Object in = newWithArrayElement((String)source());
			out = IteratorUtils.arrayListIterator(in, 0, 0);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;arrayListIterator;;;ArrayElement of Argument[0];Element of ReturnValue;value"
			ResettableListIterator out = null;
			Object in = newWithArrayElement((String)source());
			out = IteratorUtils.arrayListIterator(in, 0);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;arrayListIterator;;;ArrayElement of Argument[0];Element of ReturnValue;value"
			ResettableListIterator out = null;
			Object in = newWithArrayElement((String)source());
			out = IteratorUtils.arrayListIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;asEnumeration;;;Element of Argument[0];Element of ReturnValue;value"
			Enumeration out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.asEnumeration(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;asIterable;;;Element of Argument[0];Element of ReturnValue;value"
			Iterable out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.asIterable(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;asIterator;;;Element of Argument[0];Element of ReturnValue;value"
			Iterator out = null;
			Enumeration in = newEnumerationWithElement((String)source());
			out = IteratorUtils.asIterator(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;asIterator;;;Element of Argument[0];Element of ReturnValue;value"
			Iterator out = null;
			Enumeration in = newEnumerationWithElement((String)source());
			out = IteratorUtils.asIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;asMultipleUseIterable;;;Element of Argument[0];Element of ReturnValue;value"
			Iterable out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.asMultipleUseIterable(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;boundedIterator;;;Element of Argument[0];Element of ReturnValue;value"
			BoundedIterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.boundedIterator(in, 0L, 0L);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;boundedIterator;;;Element of Argument[0];Element of ReturnValue;value"
			BoundedIterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.boundedIterator(in, 0L);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;chainedIterator;(Collection);;Element of Element of Argument[0];Element of ReturnValue;value"
			Iterator out = null;
			Collection in = newVectorWithElement(newVectorWithElement((String)source()));
			out = IteratorUtils.chainedIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;chainedIterator;(Iterator[]);;Element of ArrayElement of Argument[0];Element of ReturnValue;value"
			Iterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.chainedIterator(in, (Iterator)null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;chainedIterator;(Iterator,Iterator);;Element of Argument[0];Element of ReturnValue;value"
			Iterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.chainedIterator(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;chainedIterator;(Iterator,Iterator);;Element of Argument[1];Element of ReturnValue;value"
			Iterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.chainedIterator(null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;collatedIterator;(Comparator,Collection);;Element of Element of Argument[1];Element of ReturnValue;value"
			Iterator out = null;
			Collection in = newVectorWithElement(newVectorWithElement((String)source()));
			out = IteratorUtils.collatedIterator((Comparator)null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;collatedIterator;(Comparator,Iterator[]);;Element of ArrayElement of Argument[1];Element of ReturnValue;value"
			Iterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.collatedIterator((Comparator)null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;collatedIterator;(Comparator,Iterator,Iterator);;Element of Argument[1];Element of ReturnValue;value"
			Iterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.collatedIterator(null, in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;collatedIterator;(Comparator,Iterator,Iterator);;Element of Argument[2];Element of ReturnValue;value"
			Iterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.collatedIterator(null, null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;filteredIterator;;;Element of Argument[0];Element of ReturnValue;value"
			Iterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.filteredIterator(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;filteredListIterator;;;Element of Argument[0];Element of ReturnValue;value"
			ListIterator out = null;
			ListIterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.filteredListIterator(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;find;;;Element of Argument[0];ReturnValue;value"
			Object out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.find(in, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;first;;;Element of Argument[0];ReturnValue;value"
			Object out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.first(in);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;forEachButLast;;;Element of Argument[0];ReturnValue;value"
			Object out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.forEachButLast(in, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;get;;;Element of Argument[0];ReturnValue;value"
			Object out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.get(in, 0);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;getIterator;;;Argument[0];Element of ReturnValue;value"
			Iterator out = null;
			Object in = source();
			out = IteratorUtils.getIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;getIterator;;;ArrayElement of Argument[0];Element of ReturnValue;value"
			Iterator out = null;
			Object in = newWithArrayElement((String)source());
			out = IteratorUtils.getIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;getIterator;;;Element of Argument[0];Element of ReturnValue;value"
			Iterator out = null;
			Object in = newVectorWithElement((String)source());
			out = IteratorUtils.getIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;getIterator;;;MapValue of Argument[0];Element of ReturnValue;value"
			Iterator out = null;
			Map in = newTreeMapWithMapValue((String)source());
			out = IteratorUtils.getIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;loopingIterator;;;Element of Argument[0];Element of ReturnValue;value"
			ResettableIterator out = null;
			Collection in = newVectorWithElement((String)source());
			out = IteratorUtils.loopingIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;loopingListIterator;;;Element of Argument[0];Element of ReturnValue;value"
			ResettableListIterator out = null;
			List in = newVectorWithElement((String)source());
			out = IteratorUtils.loopingListIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;peekingIterator;;;Element of Argument[0];Element of ReturnValue;value"
			Iterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.peekingIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;pushbackIterator;;;Element of Argument[0];Element of ReturnValue;value"
			Iterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.pushbackIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;singletonIterator;;;Argument[0];Element of ReturnValue;value"
			ResettableIterator out = null;
			Object in = source();
			out = IteratorUtils.singletonIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;singletonListIterator;;;Argument[0];Element of ReturnValue;value"
			ListIterator out = null;
			Object in = source();
			out = IteratorUtils.singletonListIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;skippingIterator;;;Element of Argument[0];Element of ReturnValue;value"
			SkippingIterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.skippingIterator(in, 0L);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;toArray;;;Element of Argument[0];ArrayElement of ReturnValue;value"
			Object[] out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.toArray(in, null);
			sink(getArrayElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;toArray;;;Element of Argument[0];ArrayElement of ReturnValue;value"
			Object[] out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.toArray(in);
			sink(getArrayElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;toList;;;Element of Argument[0];Element of ReturnValue;value"
			List out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.toList(in, 0);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;toList;;;Element of Argument[0];Element of ReturnValue;value"
			List out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.toList(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;toListIterator;;;Element of Argument[0];Element of ReturnValue;value"
			ListIterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.toListIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;toString;;;Argument[2];ReturnValue;taint"
			String out = null;
			String in = (String)source();
			out = IteratorUtils.toString(null, null, in, null, null);
			sink(out); // $ hasTaintFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;toString;;;Argument[3];ReturnValue;taint"
			String out = null;
			String in = (String)source();
			out = IteratorUtils.toString(null, null, null, in, null);
			sink(out); // $ hasTaintFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;toString;;;Argument[4];ReturnValue;taint"
			String out = null;
			String in = (String)source();
			out = IteratorUtils.toString(null, null, null, null, in);
			sink(out); // $ hasTaintFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;unmodifiableIterator;;;Element of Argument[0];Element of ReturnValue;value"
			Iterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.unmodifiableIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;unmodifiableListIterator;;;Element of Argument[0];Element of ReturnValue;value"
			ListIterator out = null;
			ListIterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.unmodifiableListIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;unmodifiableMapIterator;;;Element of Argument[0];Element of ReturnValue;value"
			MapIterator out = null;
			MapIterator in = newOMIWithElement((String)source());
			out = IteratorUtils.unmodifiableMapIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;unmodifiableMapIterator;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			MapIterator out = null;
			MapIterator in = newOMIWithMapValue((String)source());
			out = IteratorUtils.unmodifiableMapIterator(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;zippingIterator;(Iterator[]);;Element of ArrayElement of Argument[0];Element of ReturnValue;value"
			ZippingIterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.zippingIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;zippingIterator;(Iterator,Iterator);;Element of Argument[0];Element of ReturnValue;value"
			ZippingIterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.zippingIterator(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;zippingIterator;(Iterator,Iterator);;Element of Argument[1];Element of ReturnValue;value"
			ZippingIterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.zippingIterator(null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;zippingIterator;(Iterator,Iterator,Iterator);;Element of Argument[0];Element of ReturnValue;value"
			ZippingIterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.zippingIterator(in, null, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;zippingIterator;(Iterator,Iterator,Iterator);;Element of Argument[1];Element of ReturnValue;value"
			ZippingIterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.zippingIterator(null, in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;IteratorUtils;true;zippingIterator;(Iterator,Iterator,Iterator);;Element of Argument[2];Element of ReturnValue;value"
			ZippingIterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = IteratorUtils.zippingIterator(null, null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ListUtils;true;defaultIfNull;;;Argument[0];ReturnValue;value"
			List out = null;
			List in = (List)source();
			out = ListUtils.defaultIfNull(in, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ListUtils;true;defaultIfNull;;;Argument[1];ReturnValue;value"
			List out = null;
			List in = (List)source();
			out = ListUtils.defaultIfNull(null, in);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ListUtils;true;emptyIfNull;;;Argument[0];ReturnValue;value"
			List out = null;
			List in = (List)source();
			out = ListUtils.emptyIfNull(in);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ListUtils;true;fixedSizeList;;;Element of Argument[0];Element of ReturnValue;value"
			List out = null;
			List in = newVectorWithElement((String)source());
			out = ListUtils.fixedSizeList(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ListUtils;true;intersection;;;Element of Argument[0];Element of ReturnValue;value"
			List out = null;
			List in = newVectorWithElement((String)source());
			out = ListUtils.intersection(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ListUtils;true;intersection;;;Element of Argument[1];Element of ReturnValue;value"
			List out = null;
			List in = newVectorWithElement((String)source());
			out = ListUtils.intersection(null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ListUtils;true;lazyList;;;Element of Argument[0];Element of ReturnValue;value"
			List out = null;
			List in = newVectorWithElement((String)source());
			out = ListUtils.lazyList(in, (Transformer)null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ListUtils;true;lazyList;;;Element of Argument[0];Element of ReturnValue;value"
			List out = null;
			List in = newVectorWithElement((String)source());
			out = ListUtils.lazyList(in, (Factory)null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ListUtils;true;longestCommonSubsequence;(CharSequence,CharSequence);;Argument[0];ReturnValue;taint"
			String out = null;
			CharSequence in = (CharSequence)source();
			out = ListUtils.longestCommonSubsequence(in, (CharSequence)null);
			sink(out); // $ hasTaintFlow
		}
		{
			// "org.apache.commons.collections4;ListUtils;true;longestCommonSubsequence;(CharSequence,CharSequence);;Argument[1];ReturnValue;taint"
			String out = null;
			CharSequence in = (CharSequence)source();
			out = ListUtils.longestCommonSubsequence((CharSequence)null, in);
			sink(out); // $ hasTaintFlow
		}
		{
			// "org.apache.commons.collections4;ListUtils;true;longestCommonSubsequence;(List,List);;Element of Argument[0];Element of ReturnValue;value"
			List out = null;
			List in = newVectorWithElement((String)source());
			out = ListUtils.longestCommonSubsequence(in, (List)null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ListUtils;true;longestCommonSubsequence;(List,List);;Element of Argument[1];Element of ReturnValue;value"
			List out = null;
			List in = newVectorWithElement((String)source());
			out = ListUtils.longestCommonSubsequence((List)null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ListUtils;true;longestCommonSubsequence;(List,List,Equator);;Element of Argument[0];Element of ReturnValue;value"
			List out = null;
			List in = newVectorWithElement((String)source());
			out = ListUtils.longestCommonSubsequence(in, null, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ListUtils;true;longestCommonSubsequence;(List,List,Equator);;Element of Argument[1];Element of ReturnValue;value"
			List out = null;
			List in = newVectorWithElement((String)source());
			out = ListUtils.longestCommonSubsequence(null, in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ListUtils;true;partition;;;Element of Argument[0];Element of Element of ReturnValue;value"
			List out = null;
			List in = newVectorWithElement((String)source());
			out = ListUtils.partition(in, 0);
			sink(getElement((Iterable)getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ListUtils;true;predicatedList;;;Element of Argument[0];Element of ReturnValue;value"
			List out = null;
			List in = newVectorWithElement((String)source());
			out = ListUtils.predicatedList(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ListUtils;true;removeAll;;;Element of Argument[0];Element of ReturnValue;value"
			List out = null;
			Collection in = newVectorWithElement((String)source());
			out = ListUtils.removeAll(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ListUtils;true;retainAll;;;Element of Argument[0];Element of ReturnValue;value"
			List out = null;
			Collection in = newVectorWithElement((String)source());
			out = ListUtils.retainAll(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ListUtils;true;select;;;Element of Argument[0];Element of ReturnValue;value"
			List out = null;
			Collection in = newVectorWithElement((String)source());
			out = ListUtils.select(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ListUtils;true;selectRejected;;;Element of Argument[0];Element of ReturnValue;value"
			List out = null;
			Collection in = newVectorWithElement((String)source());
			out = ListUtils.selectRejected(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ListUtils;true;subtract;;;Element of Argument[0];Element of ReturnValue;value"
			List out = null;
			List in = newVectorWithElement((String)source());
			out = ListUtils.subtract(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ListUtils;true;sum;;;Element of Argument[0];Element of ReturnValue;value"
			List out = null;
			List in = newVectorWithElement((String)source());
			out = ListUtils.sum(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ListUtils;true;sum;;;Element of Argument[1];Element of ReturnValue;value"
			List out = null;
			List in = newVectorWithElement((String)source());
			out = ListUtils.sum(null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ListUtils;true;synchronizedList;;;Element of Argument[0];Element of ReturnValue;value"
			List out = null;
			List in = newVectorWithElement((String)source());
			out = ListUtils.synchronizedList(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ListUtils;true;transformedList;;;Element of Argument[0];Element of ReturnValue;value"
			List out = null;
			List in = newVectorWithElement((String)source());
			out = ListUtils.transformedList(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ListUtils;true;union;;;Element of Argument[0];Element of ReturnValue;value"
			List out = null;
			List in = newVectorWithElement((String)source());
			out = ListUtils.union(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ListUtils;true;union;;;Element of Argument[1];Element of ReturnValue;value"
			List out = null;
			List in = newVectorWithElement((String)source());
			out = ListUtils.union(null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;ListUtils;true;unmodifiableList;;;Element of Argument[0];Element of ReturnValue;value"
			List out = null;
			List in = newVectorWithElement((String)source());
			out = ListUtils.unmodifiableList(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapIterator;true;getKey;;;Element of Argument[-1];ReturnValue;value"
			Object out = null;
			MapIterator in = newOMIWithElement((String)source());
			out = in.getKey();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapIterator;true;getValue;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MapIterator in = newOMIWithMapValue((String)source());
			out = in.getValue();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapIterator;true;setValue;;;Argument[0];MapValue of Argument[-1];value"
			MapIterator out = null;
			Object in = source();
			out.setValue(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MapIterator;true;setValue;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MapIterator in = newOMIWithMapValue((String)source());
			out = in.setValue(null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiMap;true;get;;;Element of MapValue of Argument[-1];Element of ReturnValue;value"
			Collection out = null;
			MultiMap in = newMVMWithMapValue((String)source());
			out = (Collection)in.get(null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiMap;true;put;;;Argument[0];MapKey of Argument[-1];value"
			MultiValueMap out = null;
			Object in = source();
			out.put(in, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiMap;true;put;;;Argument[0];MapKey of Argument[-1];value"
			MultiMap out = null;
			Object in = source();
			out.put(in, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiMap;true;put;;;Argument[1];Element of MapValue of Argument[-1];value"
			MultiValueMap out = null;
			Object in = source();
			out.put(null, in);
			sink(getElement((Collection)getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiMap;true;put;;;Argument[1];Element of MapValue of Argument[-1];value"
			MultiMap out = null;
			Object in = source();
			out.put(null, in);
			sink(getElement((Collection)getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiMap;true;values;;;Element of MapValue of Argument[-1];Element of ReturnValue;value"
			Collection out = null;
			MultiValueMap in = newMVMWithMapValue((String)source());
			out = in.values();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiMap;true;values;;;Element of MapValue of Argument[-1];Element of ReturnValue;value"
			Collection out = null;
			MultiMap in = newMVMWithMapValue((String)source());
			out = in.values();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiMapUtils;true;emptyIfNull;;;Argument[0];ReturnValue;value"
			MultiValuedMap out = null;
			MultiValuedMap in = (MultiValuedMap)source();
			out = MultiMapUtils.emptyIfNull(in);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiValuedMap;true;entries;;;MapKey of Argument[-1];MapKey of Element of ReturnValue;value"
			Collection<Map.Entry> out = null;
			MultiValuedMap in = newALVHMWithMapKey((String)source());
			out = in.entries();
			sink(getMapKeyFromEntry(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiValuedMap;true;entries;;;Element of MapValue of Argument[-1];MapValue of Element of ReturnValue;value"
			Collection<Map.Entry> out = null;
			MultiValuedMap in = newALVHMWithMapValue((String)source());
			out = in.entries();
			sink(getMapValueFromEntry(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiMapUtils;true;getCollection;;;MapValue of Argument[0];ReturnValue;value"
			Collection out = null;
			MultiValuedMap in = newALVHMWithMapValue((String)source());
			out = MultiMapUtils.getCollection(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiMapUtils;true;getValuesAsBag;;;Element of MapValue of Argument[0];Element of ReturnValue;value"
			Bag out = null;
			MultiValuedMap in = newALVHMWithMapValue((String)source());
			out = MultiMapUtils.getValuesAsBag(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiMapUtils;true;getValuesAsList;;;Element of MapValue of Argument[0];Element of ReturnValue;value"
			List out = null;
			MultiValuedMap in = newALVHMWithMapValue((String)source());
			out = MultiMapUtils.getValuesAsList(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiMapUtils;true;getValuesAsSet;;;Element of MapValue of Argument[0];Element of ReturnValue;value"
			Set out = null;
			MultiValuedMap in = newALVHMWithMapValue((String)source());
			out = MultiMapUtils.getValuesAsSet(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiMapUtils;true;transformedMultiValuedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			MultiValuedMap out = null;
			MultiValuedMap in = newALVHMWithMapKey((String)source());
			out = MultiMapUtils.transformedMultiValuedMap(in, null, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiMapUtils;true;transformedMultiValuedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			MultiValuedMap out = null;
			MultiValuedMap in = newALVHMWithMapValue((String)source());
			out = MultiMapUtils.transformedMultiValuedMap(in, null, null);
			sink(getElement(getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiMapUtils;true;unmodifiableMultiValuedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			MultiValuedMap out = null;
			MultiValuedMap in = newALVHMWithMapKey((String)source());
			out = MultiMapUtils.unmodifiableMultiValuedMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiMapUtils;true;unmodifiableMultiValuedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			MultiValuedMap out = null;
			MultiValuedMap in = newALVHMWithMapValue((String)source());
			out = MultiMapUtils.unmodifiableMultiValuedMap(in);
			sink(getElement(getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiSet$Entry;true;getElement;;;Element of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiSet.Entry in = newMultiSetEntryWithElement((String)source());
			out = in.getElement();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiSet;true;add;;;Argument[0];Element of Argument[-1];value"
			MultiSet out = null;
			Object in = source();
			out.add(in, 0);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiSet;true;add;;;Argument[0];Element of Argument[-1];value"
			MultiSet out = null;
			Object in = source();
			out.add(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiSet;true;entrySet;;;Element of Argument[-1];Element of Element of ReturnValue;value"
			Set<MultiSet.Entry> out = null;
			MultiSet in = newMultiSetWithElement((String)source());
			out = in.entrySet();
			sink(getElement(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiSet;true;uniqueSet;;;Element of Argument[-1];Element of ReturnValue;value"
			Set out = null;
			MultiSet in = newMultiSetWithElement((String)source());
			out = in.uniqueSet();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiSetUtils;true;predicatedMultiSet;;;Element of Argument[0];Element of ReturnValue;value"
			MultiSet out = null;
			MultiSet in = newMultiSetWithElement((String)source());
			out = MultiSetUtils.predicatedMultiSet(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiSetUtils;true;synchronizedMultiSet;;;Element of Argument[0];Element of ReturnValue;value"
			MultiSet out = null;
			MultiSet in = newMultiSetWithElement((String)source());
			out = MultiSetUtils.synchronizedMultiSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiSetUtils;true;unmodifiableMultiSet;;;Element of Argument[0];Element of ReturnValue;value"
			MultiSet out = null;
			MultiSet in = newMultiSetWithElement((String)source());
			out = MultiSetUtils.unmodifiableMultiSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiValuedMap;true;asMap;;;Element of MapValue of Argument[-1];Element of MapValue of ReturnValue;value"
			Map out = null;
			MultiValuedMap in = newALVHMWithMapValue((String)source());
			out = in.asMap();
			sink(getElement((Collection)getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiValuedMap;true;asMap;;;MapKey of Argument[-1];MapKey of ReturnValue;value"
			Map out = null;
			MultiValuedMap in = newALVHMWithMapKey((String)source());
			out = in.asMap();
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiValuedMap;true;get;;;Element of MapValue of Argument[-1];Element of ReturnValue;value"
			Set out = null;
			SetValuedMap in = newHSVHMWithMapValue((String)source());
			out = in.get(null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiValuedMap;true;get;;;Element of MapValue of Argument[-1];Element of ReturnValue;value"
			List out = null;
			ListValuedMap in = newALVHMWithMapValue((String)source());
			out = in.get(null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiValuedMap;true;get;;;Element of MapValue of Argument[-1];Element of ReturnValue;value"
			Collection out = null;
			MultiValuedMap in = newALVHMWithMapValue((String)source());
			out = in.get(null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiValuedMap;true;keySet;;;MapKey of Argument[-1];Element of ReturnValue;value"
			Set out = null;
			MultiValuedMap in = newALVHMWithMapKey((String)source());
			out = in.keySet();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiValuedMap;true;keys;;;MapKey of Argument[-1];Element of ReturnValue;value"
			MultiSet out = null;
			MultiValuedMap in = newALVHMWithMapKey((String)source());
			out = in.keys();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiValuedMap;true;mapIterator;;;Element of MapValue of Argument[-1];MapValue of ReturnValue;value"
			MapIterator out = null;
			MultiValuedMap in = newALVHMWithMapValue((String)source());
			out = in.mapIterator();
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiValuedMap;true;mapIterator;;;MapKey of Argument[-1];Element of ReturnValue;value"
			MapIterator out = null;
			MultiValuedMap in = newALVHMWithMapKey((String)source());
			out = in.mapIterator();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiValuedMap;true;put;;;Argument[0];MapKey of Argument[-1];value"
			MultiValuedMap out = null;
			Object in = source();
			out.put(in, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiValuedMap;true;put;;;Argument[1];Element of MapValue of Argument[-1];value"
			MultiValuedMap out = null;
			Object in = source();
			out.put(null, in);
			sink(getElement(getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiValuedMap;true;putAll;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			MultiValuedMap out = null;
			Map in = newTreeMapWithMapKey((String)source());
			out.putAll(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiValuedMap;true;putAll;(Map);;MapValue of Argument[0];Element of MapValue of Argument[-1];value"
			MultiValuedMap out = null;
			Map in = newTreeMapWithMapValue((String)source());
			out.putAll(in);
			sink(getElement(getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiValuedMap;true;putAll;(MultiValuedMap);;Element of MapValue of Argument[0];Element of MapValue of Argument[-1];value"
			MultiValuedMap out = null;
			MultiValuedMap in = newALVHMWithMapValue((String)source());
			out.putAll(in);
			sink(getElement(getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiValuedMap;true;putAll;(MultiValuedMap);;MapKey of Argument[0];MapKey of Argument[-1];value"
			MultiValuedMap out = null;
			MultiValuedMap in = newALVHMWithMapKey((String)source());
			out.putAll(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiValuedMap;true;putAll;(Object,Iterable);;Argument[0];MapKey of Argument[-1];value"
			MultiValuedMap out = null;
			Object in = source();
			out.putAll(in, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiValuedMap;true;putAll;(Object,Iterable);;Element of Argument[1];Element of MapValue of Argument[-1];value"
			MultiValuedMap out = null;
			Iterable in = newFluentIterableWithElement((String)source());
			out.putAll(null, in);
			sink(getElement(getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiValuedMap;true;remove;;;Element of MapValue of Argument[-1];Element of ReturnValue;value"
			Set out = null;
			SetValuedMap in = newHSVHMWithMapValue((String)source());
			out = in.remove(null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiValuedMap;true;remove;;;Element of MapValue of Argument[-1];Element of ReturnValue;value"
			List out = null;
			ListValuedMap in = newALVHMWithMapValue((String)source());
			out = in.remove(null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiValuedMap;true;remove;;;Element of MapValue of Argument[-1];Element of ReturnValue;value"
			Collection out = null;
			MultiValuedMap in = newALVHMWithMapValue((String)source());
			out = in.remove(null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;MultiValuedMap;true;values;;;Element of MapValue of Argument[-1];Element of ReturnValue;value"
			Collection out = null;
			MultiValuedMap in = newALVHMWithMapValue((String)source());
			out = in.values();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;OrderedIterator;true;previous;;;Element of Argument[-1];ReturnValue;value"
			Object out = null;
			OrderedMapIterator in = newOMIWithElement((String)source());
			out = in.previous();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;OrderedIterator;true;previous;;;Element of Argument[-1];ReturnValue;value"
			Object out = null;
			OrderedIterator in = newOMIWithElement((String)source());
			out = in.previous();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;OrderedMap;true;firstKey;;;MapKey of Argument[-1];ReturnValue;value"
			Object out = null;
			OrderedMap in = newTreeBidiMapWithMapKey((String)source());
			out = in.firstKey();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;OrderedMap;true;lastKey;;;MapKey of Argument[-1];ReturnValue;value"
			Object out = null;
			OrderedMap in = newTreeBidiMapWithMapKey((String)source());
			out = in.lastKey();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;OrderedMap;true;nextKey;;;MapKey of Argument[-1];ReturnValue;value"
			Object out = null;
			OrderedMap in = newTreeBidiMapWithMapKey((String)source());
			out = in.nextKey(null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;OrderedMap;true;previousKey;;;MapKey of Argument[-1];ReturnValue;value"
			Object out = null;
			OrderedMap in = newTreeBidiMapWithMapKey((String)source());
			out = in.previousKey(null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Put;true;put;;;Argument[0];MapKey of Argument[-1];value"
			Put out = null;
			Object in = source();
			out.put(in, null);
			sink(getMapKeyFromPut(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Put;true;put;;;Argument[0];MapKey of Argument[-1];value"
			MultiValueMap out = null;
			Object in = source();
			out.put(in, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Put;true;put;;;Argument[0];MapKey of Argument[-1];value"
			MultiMap out = null;
			Object in = source();
			out.put(in, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Put;true;put;;;Argument[0];MapKey of Argument[-1];value"
			BidiMap out = null;
			Object in = source();
			out.put(in, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Put;true;put;;;Argument[0];MapKey of Argument[-1];value"
			AbstractMapDecorator out = null;
			Object in = source();
			out.put(in, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Put;true;put;;;Argument[1];MapValue of Argument[-1];value"
			Put out = null;
			Object in = source();
			out.put(null, in);
			sink(getMapValueFromPut(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Put;true;put;;;Argument[1];MapValue of Argument[-1];value"
			MultiValueMap out = null;
			Object in = source();
			out.put(null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Put;true;put;;;Argument[1];MapValue of Argument[-1];value"
			MultiMap out = null;
			Object in = source();
			out.put(null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Put;true;put;;;Argument[1];MapValue of Argument[-1];value"
			BidiMap out = null;
			Object in = source();
			out.put(null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Put;true;put;;;Argument[1];MapValue of Argument[-1];value"
			AbstractMapDecorator out = null;
			Object in = source();
			out.put(null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Put;true;put;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			Put in = newHashedMapWithMapValue((String)source());
			out = in.put(null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Put;true;put;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiValueMap in = newMVMWithMapValue((String)source());
			out = in.put(null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Put;true;put;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiMap in = newMVMWithMapValue((String)source());
			out = in.put(null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Put;true;put;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			BidiMap in = newTreeBidiMapWithMapValue((String)source());
			out = in.put(null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Put;true;put;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			AbstractMapDecorator in = newMVMWithMapValue((String)source());
			out = in.put(null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Put;true;putAll;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			Put out = null;
			Map in = newTreeMapWithMapKey((String)source());
			out.putAll(in);
			sink(getMapKeyFromPut(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Put;true;putAll;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			MultiValueMap out = null;
			Map in = newTreeMapWithMapKey((String)source());
			out.putAll(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Put;true;putAll;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			AbstractMapDecorator out = null;
			Map in = newTreeMapWithMapKey((String)source());
			out.putAll(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Put;true;putAll;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value"
			Put out = null;
			Map in = newTreeMapWithMapValue((String)source());
			out.putAll(in);
			sink(getMapValueFromPut(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Put;true;putAll;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value"
			MultiValueMap out = null;
			Map in = newTreeMapWithMapValue((String)source());
			out.putAll(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Put;true;putAll;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value"
			AbstractMapDecorator out = null;
			Map in = newTreeMapWithMapValue((String)source());
			out.putAll(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;QueueUtils;true;predicatedQueue;;;Element of Argument[0];Element of ReturnValue;value"
			Queue out = null;
			Queue in = newQueueWithElement((String)source());
			out = QueueUtils.predicatedQueue(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;QueueUtils;true;synchronizedQueue;;;Element of Argument[0];Element of ReturnValue;value"
			Queue out = null;
			Queue in = newQueueWithElement((String)source());
			out = QueueUtils.synchronizedQueue(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;QueueUtils;true;transformingQueue;;;Element of Argument[0];Element of ReturnValue;value"
			Queue out = null;
			Queue in = newQueueWithElement((String)source());
			out = QueueUtils.transformingQueue(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;QueueUtils;true;unmodifiableQueue;;;Element of Argument[0];Element of ReturnValue;value"
			Queue out = null;
			Queue in = newQueueWithElement((String)source());
			out = QueueUtils.unmodifiableQueue(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SetUtils$SetView;true;copyInto;;;Element of Argument[-1];Element of Argument[0];value"
			Set out = null;
			SetUtils.SetView in = newSetViewWithElement((String)source());
			in.copyInto(out);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SetUtils$SetView;true;createIterator;;;Element of Argument[-1];Element of ReturnValue;value"
			Iterator out = null;
			MySetView in = newSetViewWithElement((String)source());
			out = in.myCreateIterator();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SetUtils$SetView;true;toSet;;;Element of Argument[-1];Element of ReturnValue;value"
			Set out = null;
			MySetView in = newSetViewWithElement((String)source());
			out = in.toSet();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SetUtils;true;difference;;;Element of Argument[0];Element of ReturnValue;value"
			SetUtils.SetView out = null;
			Set in = newTreeSetWithElement((String)source());
			out = SetUtils.difference(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SetUtils;true;disjunction;;;Element of Argument[0];Element of ReturnValue;value"
			SetUtils.SetView out = null;
			Set in = newTreeSetWithElement((String)source());
			out = SetUtils.disjunction(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SetUtils;true;disjunction;;;Element of Argument[1];Element of ReturnValue;value"
			SetUtils.SetView out = null;
			Set in = newTreeSetWithElement((String)source());
			out = SetUtils.disjunction(null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SetUtils;true;emptyIfNull;;;Argument[0];ReturnValue;value"
			Set out = null;
			Set in = (Set)source();
			out = SetUtils.emptyIfNull(in);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SetUtils;true;hashSet;;;ArrayElement of Argument[0];Element of ReturnValue;value"
			HashSet out = null;
			Object in = source();
			out = SetUtils.hashSet(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SetUtils;true;intersection;;;Element of Argument[0];Element of ReturnValue;value"
			SetUtils.SetView out = null;
			Set in = newTreeSetWithElement((String)source());
			out = SetUtils.intersection(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SetUtils;true;intersection;;;Element of Argument[1];Element of ReturnValue;value"
			SetUtils.SetView out = null;
			Set in = newTreeSetWithElement((String)source());
			out = SetUtils.intersection(null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SetUtils;true;orderedSet;;;Element of Argument[0];Element of ReturnValue;value"
			Set out = null;
			Set in = newTreeSetWithElement((String)source());
			out = SetUtils.orderedSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SetUtils;true;predicatedNavigableSet;;;Element of Argument[0];Element of ReturnValue;value"
			SortedSet out = null;
			NavigableSet in = newTreeSetWithElement((String)source());
			out = SetUtils.predicatedNavigableSet(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SetUtils;true;predicatedSet;;;Element of Argument[0];Element of ReturnValue;value"
			Set out = null;
			Set in = newTreeSetWithElement((String)source());
			out = SetUtils.predicatedSet(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SetUtils;true;predicatedSortedSet;;;Element of Argument[0];Element of ReturnValue;value"
			SortedSet out = null;
			SortedSet in = newTreeSetWithElement((String)source());
			out = SetUtils.predicatedSortedSet(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SetUtils;true;synchronizedSet;;;Element of Argument[0];Element of ReturnValue;value"
			Set out = null;
			Set in = newTreeSetWithElement((String)source());
			out = SetUtils.synchronizedSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SetUtils;true;synchronizedSortedSet;;;Element of Argument[0];Element of ReturnValue;value"
			SortedSet out = null;
			SortedSet in = newTreeSetWithElement((String)source());
			out = SetUtils.synchronizedSortedSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SetUtils;true;transformedNavigableSet;;;Element of Argument[0];Element of ReturnValue;value"
			SortedSet out = null;
			NavigableSet in = newTreeSetWithElement((String)source());
			out = SetUtils.transformedNavigableSet(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SetUtils;true;transformedSet;;;Element of Argument[0];Element of ReturnValue;value"
			Set out = null;
			Set in = newTreeSetWithElement((String)source());
			out = SetUtils.transformedSet(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SetUtils;true;transformedSortedSet;;;Element of Argument[0];Element of ReturnValue;value"
			SortedSet out = null;
			SortedSet in = newTreeSetWithElement((String)source());
			out = SetUtils.transformedSortedSet(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SetUtils;true;union;;;Element of Argument[0];Element of ReturnValue;value"
			SetUtils.SetView out = null;
			Set in = newTreeSetWithElement((String)source());
			out = SetUtils.union(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SetUtils;true;union;;;Element of Argument[1];Element of ReturnValue;value"
			SetUtils.SetView out = null;
			Set in = newTreeSetWithElement((String)source());
			out = SetUtils.union(null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SetUtils;true;unmodifiableNavigableSet;;;Element of Argument[0];Element of ReturnValue;value"
			SortedSet out = null;
			NavigableSet in = newTreeSetWithElement((String)source());
			out = SetUtils.unmodifiableNavigableSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SetUtils;true;unmodifiableSet;(Object[]);;ArrayElement of Argument[0];Element of ReturnValue;value"
			Set out = null;
			Object in = source();
			out = SetUtils.unmodifiableSet(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SetUtils;true;unmodifiableSet;(Set);;Element of Argument[0];Element of ReturnValue;value"
			Set out = null;
			Set in = newTreeSetWithElement((String)source());
			out = SetUtils.unmodifiableSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SetUtils;true;unmodifiableSortedSet;;;Element of Argument[0];Element of ReturnValue;value"
			SortedSet out = null;
			SortedSet in = newTreeSetWithElement((String)source());
			out = SetUtils.unmodifiableSortedSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SortedBag;true;first;;;Element of Argument[-1];ReturnValue;value"
			Object out = null;
			SortedBag in = newTreeBagWithElement((String)source());
			out = in.first();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SortedBag;true;last;;;Element of Argument[-1];ReturnValue;value"
			Object out = null;
			SortedBag in = newTreeBagWithElement((String)source());
			out = in.last();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SplitMapUtils;true;readableMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			IterableMap out = null;
			Get in = newHashedMapWithMapKey((String)source());
			out = SplitMapUtils.readableMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SplitMapUtils;true;readableMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			IterableMap out = null;
			Get in = newHashedMapWithMapValue((String)source());
			out = SplitMapUtils.readableMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SplitMapUtils;true;writableMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			Map out = null;
			Put in = newHashedMapWithMapKey((String)source());
			out = SplitMapUtils.writableMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;SplitMapUtils;true;writableMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			Map out = null;
			Put in = newHashedMapWithMapValue((String)source());
			out = SplitMapUtils.writableMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Trie;true;prefixMap;;;MapKey of Argument[-1];MapKey of ReturnValue;value"
			SortedMap out = null;
			Trie in = newPatriciaTrieWithMapKey((String)source());
			out = in.prefixMap(null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;Trie;true;prefixMap;;;MapValue of Argument[-1];MapValue of ReturnValue;value"
			SortedMap out = null;
			Trie in = newPatriciaTrieWithMapValue((String)source());
			out = in.prefixMap(null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;TrieUtils;true;unmodifiableTrie;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			Trie out = null;
			Trie in = newPatriciaTrieWithMapKey((String)source());
			out = TrieUtils.unmodifiableTrie(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4;TrieUtils;true;unmodifiableTrie;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			Trie out = null;
			Trie in = newPatriciaTrieWithMapValue((String)source());
			out = TrieUtils.unmodifiableTrie(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;AbstractBagDecorator;true;AbstractBagDecorator;;;Element of Argument[0];Element of Argument[-1];value"
			AbstractBagDecorator out = null;
			Bag in = newTreeBagWithElement((String)source());
			out = new MyAbstractBagDecorator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;AbstractMapBag;true;AbstractMapBag;;;MapKey of Argument[0];Element of Argument[-1];value"
			AbstractMapBag out = null;
			Map in = Map.of((String)source(), null);
			out = new MyAbstractMapBag(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;AbstractMapBag;true;getMap;;;Element of Argument[-1];MapKey of ReturnValue;value"
			Map out = null;
			MyAbstractMapBag in = new MyAbstractMapBag(Map.of((String)source(), null));
			out = in.myGetMap();
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;AbstractSortedBagDecorator;true;AbstractSortedBagDecorator;;;Element of Argument[0];Element of Argument[-1];value"
			AbstractSortedBagDecorator out = null;
			SortedBag in = newTreeBagWithElement((String)source());
			out = new MyAbstractSortedBagDecorator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;CollectionBag;true;CollectionBag;;;Element of Argument[0];Element of Argument[-1];value"
			CollectionBag out = null;
			Bag in = newTreeBagWithElement((String)source());
			out = new CollectionBag(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;CollectionBag;true;collectionBag;;;Element of Argument[0];Element of ReturnValue;value"
			Bag out = null;
			Bag in = newTreeBagWithElement((String)source());
			out = CollectionBag.collectionBag(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;CollectionSortedBag;true;CollectionSortedBag;;;Element of Argument[0];Element of Argument[-1];value"
			CollectionSortedBag out = null;
			SortedBag in = newTreeBagWithElement((String)source());
			out = new CollectionSortedBag(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;CollectionSortedBag;true;collectionSortedBag;;;Element of Argument[0];Element of ReturnValue;value"
			SortedBag out = null;
			SortedBag in = newTreeBagWithElement((String)source());
			out = CollectionSortedBag.collectionSortedBag(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;HashBag;true;HashBag;;;Element of Argument[0];Element of Argument[-1];value"
			HashBag out = null;
			Collection in = newTreeBagWithElement((String)source());
			out = new HashBag(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;PredicatedBag;true;predicatedBag;;;Element of Argument[0];Element of ReturnValue;value"
			PredicatedBag out = null;
			Bag in = newTreeBagWithElement((String)source());
			out = PredicatedBag.predicatedBag(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;PredicatedSortedBag;true;predicatedSortedBag;;;Element of Argument[0];Element of ReturnValue;value"
			PredicatedSortedBag out = null;
			SortedBag in = newTreeBagWithElement((String)source());
			out = PredicatedSortedBag.predicatedSortedBag(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;SynchronizedBag;true;synchronizedBag;;;Element of Argument[0];Element of ReturnValue;value"
			SynchronizedBag out = null;
			Bag in = newTreeBagWithElement((String)source());
			out = SynchronizedBag.synchronizedBag(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;SynchronizedSortedBag;true;synchronizedSortedBag;;;Element of Argument[0];Element of ReturnValue;value"
			SynchronizedSortedBag out = null;
			SortedBag in = newTreeBagWithElement((String)source());
			out = SynchronizedSortedBag.synchronizedSortedBag(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;TransformedBag;true;transformedBag;;;Element of Argument[0];Element of ReturnValue;value"
			Bag out = null;
			Bag in = newTreeBagWithElement((String)source());
			out = TransformedBag.transformedBag(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;TransformedSortedBag;true;transformedSortedBag;;;Element of Argument[0];Element of ReturnValue;value"
			TransformedSortedBag out = null;
			SortedBag in = newTreeBagWithElement((String)source());
			out = TransformedSortedBag.transformedSortedBag(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;TreeBag;true;TreeBag;(Collection);;Element of Argument[0];Element of Argument[-1];value"
			TreeBag out = null;
			Collection in = newTreeBagWithElement((String)source());
			out = new TreeBag(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;UnmodifiableBag;true;unmodifiableBag;;;Element of Argument[0];Element of ReturnValue;value"
			Bag out = null;
			Bag in = newTreeBagWithElement((String)source());
			out = UnmodifiableBag.unmodifiableBag(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;UnmodifiableSortedBag;true;unmodifiableSortedBag;;;Element of Argument[0];Element of ReturnValue;value"
			SortedBag out = null;
			SortedBag in = newTreeBagWithElement((String)source());
			out = UnmodifiableSortedBag.unmodifiableSortedBag(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;AbstractBidiMapDecorator;true;AbstractBidiMapDecorator;;;MapKey of Argument[0];MapKey of Argument[-1];value"
			AbstractBidiMapDecorator out = null;
			BidiMap in = newDualTreeBidiMapWithMapKey((String)source());
			out = new MyAbstractBidiMapDecorator(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;AbstractBidiMapDecorator;true;AbstractBidiMapDecorator;;;MapValue of Argument[0];MapValue of Argument[-1];value"
			AbstractBidiMapDecorator out = null;
			BidiMap in = newDualTreeBidiMapWithMapValue((String)source());
			out = new MyAbstractBidiMapDecorator(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;AbstractDualBidiMap;true;AbstractDualBidiMap;;;MapKey of Argument[0];MapKey of Argument[-1];value"
			AbstractDualBidiMap out = null;
			BidiMap in = newDualTreeBidiMapWithMapKey((String)source());
			out = new MyAbstractDualBidiMap(in, null, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;AbstractDualBidiMap;true;AbstractDualBidiMap;;;MapKey of Argument[1];MapValue of Argument[-1];value"
			AbstractDualBidiMap out = null;
			BidiMap in = newDualTreeBidiMapWithMapKey((String)source());
			out = new MyAbstractDualBidiMap(null, in, null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;AbstractDualBidiMap;true;AbstractDualBidiMap;;;MapKey of Argument[2];MapValue of Argument[-1];value"
			AbstractDualBidiMap out = null;
			BidiMap in = newDualTreeBidiMapWithMapKey((String)source());
			out = new MyAbstractDualBidiMap(null, null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;AbstractDualBidiMap;true;AbstractDualBidiMap;;;MapValue of Argument[0];MapValue of Argument[-1];value"
			AbstractDualBidiMap out = null;
			BidiMap in = newDualTreeBidiMapWithMapValue((String)source());
			out = new MyAbstractDualBidiMap(in, null, null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;AbstractDualBidiMap;true;AbstractDualBidiMap;;;MapValue of Argument[1];MapKey of Argument[-1];value"
			AbstractDualBidiMap out = null;
			BidiMap in = newDualTreeBidiMapWithMapValue((String)source());
			out = new MyAbstractDualBidiMap(null, in, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;AbstractDualBidiMap;true;AbstractDualBidiMap;;;MapValue of Argument[2];MapKey of Argument[-1];value"
			AbstractDualBidiMap out = null;
			BidiMap in = newDualTreeBidiMapWithMapValue((String)source());
			out = new MyAbstractDualBidiMap(null, null, in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;AbstractOrderedBidiMapDecorator;true;AbstractOrderedBidiMapDecorator;;;MapKey of Argument[0];MapKey of Argument[-1];value"
			AbstractOrderedBidiMapDecorator out = null;
			OrderedBidiMap in = newDualTreeBidiMapWithMapKey((String)source());
			out = new MyAbstractOrderedBidiMapDecorator(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;AbstractOrderedBidiMapDecorator;true;AbstractOrderedBidiMapDecorator;;;MapValue of Argument[0];MapValue of Argument[-1];value"
			AbstractOrderedBidiMapDecorator out = null;
			OrderedBidiMap in = newDualTreeBidiMapWithMapValue((String)source());
			out = new MyAbstractOrderedBidiMapDecorator(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;AbstractSortedBidiMapDecorator;true;AbstractSortedBidiMapDecorator;;;MapKey of Argument[0];MapKey of Argument[-1];value"
			AbstractSortedBidiMapDecorator out = null;
			SortedBidiMap in = newDualTreeBidiMapWithMapKey((String)source());
			out = new MyAbstractSortedBidiMapDecorator(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;AbstractSortedBidiMapDecorator;true;AbstractSortedBidiMapDecorator;;;MapValue of Argument[0];MapValue of Argument[-1];value"
			AbstractSortedBidiMapDecorator out = null;
			SortedBidiMap in = newDualTreeBidiMapWithMapValue((String)source());
			out = new MyAbstractSortedBidiMapDecorator(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;DualHashBidiMap;true;DualHashBidiMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			DualHashBidiMap out = null;
			Map in = Map.of((String)source(), null);
			out = new DualHashBidiMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;DualHashBidiMap;true;DualHashBidiMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value"
			DualHashBidiMap out = null;
			Map in = Map.of(null, (String)source());
			out = new DualHashBidiMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;DualLinkedHashBidiMap;true;DualLinkedHashBidiMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			DualLinkedHashBidiMap out = null;
			Map in = Map.of((String)source(), null);
			out = new DualLinkedHashBidiMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;DualLinkedHashBidiMap;true;DualLinkedHashBidiMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value"
			DualLinkedHashBidiMap out = null;
			Map in = Map.of(null, (String)source());
			out = new DualLinkedHashBidiMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;DualTreeBidiMap;true;DualTreeBidiMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			DualTreeBidiMap out = null;
			Map in = Map.of((String)source(), null);
			out = new DualTreeBidiMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;DualTreeBidiMap;true;DualTreeBidiMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value"
			DualTreeBidiMap out = null;
			Map in = Map.of(null, (String)source());
			out = new DualTreeBidiMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;DualTreeBidiMap;true;inverseOrderedBidiMap;;;MapKey of Argument[-1];MapValue of ReturnValue;value"
			OrderedBidiMap out = null;
			DualTreeBidiMap in = newDualTreeBidiMapWithMapKey((String)source());
			out = in.inverseOrderedBidiMap();
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;DualTreeBidiMap;true;inverseOrderedBidiMap;;;MapValue of Argument[-1];MapKey of ReturnValue;value"
			OrderedBidiMap out = null;
			DualTreeBidiMap in = newDualTreeBidiMapWithMapValue((String)source());
			out = in.inverseOrderedBidiMap();
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;DualTreeBidiMap;true;inverseSortedBidiMap;;;MapKey of Argument[-1];MapValue of ReturnValue;value"
			SortedBidiMap out = null;
			DualTreeBidiMap in = newDualTreeBidiMapWithMapKey((String)source());
			out = in.inverseSortedBidiMap();
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;DualTreeBidiMap;true;inverseSortedBidiMap;;;MapValue of Argument[-1];MapKey of ReturnValue;value"
			SortedBidiMap out = null;
			DualTreeBidiMap in = newDualTreeBidiMapWithMapValue((String)source());
			out = in.inverseSortedBidiMap();
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;TreeBidiMap;true;TreeBidiMap;;;MapKey of Argument[0];MapKey of Argument[-1];value"
			TreeBidiMap out = null;
			Map in = Map.of((String)source(), null);
			out = new TreeBidiMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;TreeBidiMap;true;TreeBidiMap;;;MapValue of Argument[0];MapValue of Argument[-1];value"
			TreeBidiMap out = null;
			Map in = Map.of(null, (String)source());
			out = new TreeBidiMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;UnmodifiableBidiMap;true;unmodifiableBidiMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			BidiMap out = null;
			BidiMap in = newDualTreeBidiMapWithMapKey((String)source());
			out = UnmodifiableBidiMap.unmodifiableBidiMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;UnmodifiableBidiMap;true;unmodifiableBidiMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			BidiMap out = null;
			BidiMap in = newDualTreeBidiMapWithMapValue((String)source());
			out = UnmodifiableBidiMap.unmodifiableBidiMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;UnmodifiableOrderedBidiMap;true;inverseOrderedBidiMap;;;MapKey of Argument[-1];MapValue of ReturnValue;value"
			OrderedBidiMap out = null;
			UnmodifiableOrderedBidiMap in = (UnmodifiableOrderedBidiMap)UnmodifiableOrderedBidiMap.unmodifiableOrderedBidiMap(newDualTreeBidiMapWithMapKey((String)source()));
			out = in.inverseOrderedBidiMap();
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;UnmodifiableOrderedBidiMap;true;inverseOrderedBidiMap;;;MapValue of Argument[-1];MapKey of ReturnValue;value"
			OrderedBidiMap out = null;
			UnmodifiableOrderedBidiMap in = (UnmodifiableOrderedBidiMap)UnmodifiableOrderedBidiMap.unmodifiableOrderedBidiMap(newDualTreeBidiMapWithMapValue((String)source()));
			out = in.inverseOrderedBidiMap();
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;UnmodifiableOrderedBidiMap;true;unmodifiableOrderedBidiMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			OrderedBidiMap out = null;
			OrderedBidiMap in = newDualTreeBidiMapWithMapKey((String)source());
			out = UnmodifiableOrderedBidiMap.unmodifiableOrderedBidiMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;UnmodifiableOrderedBidiMap;true;unmodifiableOrderedBidiMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			OrderedBidiMap out = null;
			OrderedBidiMap in = newDualTreeBidiMapWithMapValue((String)source());
			out = UnmodifiableOrderedBidiMap.unmodifiableOrderedBidiMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;UnmodifiableSortedBidiMap;true;unmodifiableSortedBidiMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			SortedBidiMap out = null;
			SortedBidiMap in = newDualTreeBidiMapWithMapKey((String)source());
			out = UnmodifiableSortedBidiMap.unmodifiableSortedBidiMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;UnmodifiableSortedBidiMap;true;unmodifiableSortedBidiMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			SortedBidiMap out = null;
			SortedBidiMap in = newDualTreeBidiMapWithMapValue((String)source());
			out = UnmodifiableSortedBidiMap.unmodifiableSortedBidiMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;AbstractCollectionDecorator;true;AbstractCollectionDecorator;;;Element of Argument[0];Element of Argument[-1];value"
			AbstractCollectionDecorator out = null;
			Collection in = newTreeBagWithElement((String)source());
			out = new MyAbstractCollectionDecorator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;AbstractCollectionDecorator;true;decorated;;;Element of Argument[-1];Element of ReturnValue;value"
			Collection out = null;
			MyAbstractCollectionDecorator in = new MyAbstractCollectionDecorator(newTreeBagWithElement((String)source()));
			out = in.myDecorated();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;AbstractCollectionDecorator;true;setCollection;;;Element of Argument[0];Element of Argument[-1];value"
			MyAbstractCollectionDecorator out = null;
			Collection in = newTreeBagWithElement((String)source());
			out.mySetCollection(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;CompositeCollection$CollectionMutator;true;add;;;Argument[2];Element of Argument[0];value"
			CompositeCollection out = null;
			Object in = source();
			CompositeCollection.CollectionMutator instance = null;
			instance.add(out, null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;CompositeCollection$CollectionMutator;true;add;;;Argument[2];Element of Element of Argument[1];value"
			List<Collection> out = null;
			Object in = source();
			CompositeCollection.CollectionMutator instance = null;
			instance.add(null, out, in);
			sink(getElement(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;CompositeCollection$CollectionMutator;true;addAll;;;Element of Argument[2];Element of Argument[0];value"
			CompositeCollection out = null;
			Collection in = newTreeBagWithElement((String)source());
			CompositeCollection.CollectionMutator instance = null;
			instance.addAll(out, null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;CompositeCollection$CollectionMutator;true;addAll;;;Element of Argument[2];Element of Element of Argument[1];value"
			List<Collection> out = null;
			Collection in = newTreeBagWithElement((String)source());
			CompositeCollection.CollectionMutator instance = null;
			instance.addAll(null, out, in);
			sink(getElement(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;CompositeCollection;true;CompositeCollection;(Collection);;Element of Argument[0];Element of Argument[-1];value"
			CompositeCollection out = null;
			Collection in = newTreeBagWithElement((String)source());
			out = new CompositeCollection(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;CompositeCollection;true;CompositeCollection;(Collection,Collection);;Element of Argument[0];Element of Argument[-1];value"
			CompositeCollection out = null;
			Collection in = newTreeBagWithElement((String)source());
			out = new CompositeCollection(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;CompositeCollection;true;CompositeCollection;(Collection,Collection);;Element of Argument[1];Element of Argument[-1];value"
			CompositeCollection out = null;
			Collection in = newTreeBagWithElement((String)source());
			out = new CompositeCollection(null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;CompositeCollection;true;CompositeCollection;(Collection[]);;Element of ArrayElement of Argument[0];Element of Argument[-1];value"
			CompositeCollection out = null;
			Collection[] in = new Collection[]{newTreeBagWithElement((String)source())};
			out = new CompositeCollection(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;CompositeCollection;true;addComposited;(Collection);;Element of Argument[0];Element of Argument[-1];value"
			CompositeCollection out = null;
			Collection in = newTreeBagWithElement((String)source());
			out.addComposited(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;CompositeCollection;true;addComposited;(Collection,Collection);;Element of Argument[0];Element of Argument[-1];value"
			CompositeCollection out = null;
			Collection in = newTreeBagWithElement((String)source());
			out.addComposited(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;CompositeCollection;true;addComposited;(Collection,Collection);;Element of Argument[1];Element of Argument[-1];value"
			CompositeCollection out = null;
			Collection in = newTreeBagWithElement((String)source());
			out.addComposited(null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;CompositeCollection;true;addComposited;(Collection[]);;Element of ArrayElement of Argument[0];Element of Argument[-1];value"
			CompositeCollection out = null;
			Collection[] in = new Collection[]{newTreeBagWithElement((String)source())};
			out.addComposited(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;CompositeCollection;true;getCollections;;;Element of Argument[-1];Element of Element of ReturnValue;value"
			List<Collection> out = null;
			CompositeCollection in = new CompositeCollection(newTreeBagWithElement((String)source()));
			out = in.getCollections();
			sink(getElement(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;CompositeCollection;true;toCollection;;;Element of Argument[-1];Element of ReturnValue;value"
			Collection out = null;
			CompositeCollection in = new CompositeCollection(newTreeBagWithElement((String)source()));
			out = in.toCollection();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;IndexedCollection;true;IndexedCollection;;;Element of Argument[0];Element of Argument[-1];value"
			IndexedCollection out = null;
			Collection in = newTreeBagWithElement((String)source());
			out = new IndexedCollection(in, null, null, false);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;IndexedCollection;true;get;;;Element of Argument[-1];ReturnValue;value"
			Object out = null;
			IndexedCollection in = new IndexedCollection(newTreeBagWithElement((String)source()), null, null, false);
			out = in.get(null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;IndexedCollection;true;nonUniqueIndexedCollection;;;Element of Argument[0];Element of ReturnValue;value"
			IndexedCollection out = null;
			Collection in = newTreeBagWithElement((String)source());
			out = IndexedCollection.nonUniqueIndexedCollection(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;IndexedCollection;true;uniqueIndexedCollection;;;Element of Argument[0];Element of ReturnValue;value"
			IndexedCollection out = null;
			Collection in = newTreeBagWithElement((String)source());
			out = IndexedCollection.uniqueIndexedCollection(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;IndexedCollection;true;values;;;Element of Argument[-1];Element of ReturnValue;value"
			Collection out = null;
			IndexedCollection in = new IndexedCollection(newTreeBagWithElement((String)source()), null, null, false);
			out = in.values(null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;add;;;Argument[0];Element of Argument[-1];value"
			PredicatedCollection.Builder out = null;
			Object in = (String)source();
			out.add(in);
			sink(getElement(out.createPredicatedList())); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;addAll;;;Element of Argument[0];Element of Argument[-1];value"
			PredicatedCollection.Builder out = null;
			Collection in = List.of((String)source());
			out.addAll(in);
			sink(getElement(out.createPredicatedList())); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;createPredicatedBag;;;Element of Argument[-1];Element of ReturnValue;value"
			Bag out = null;
			PredicatedCollection.Builder in = newPredicatedCollectionBuilderWithElement((String)source());
			out = in.createPredicatedBag(null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;createPredicatedBag;;;Element of Argument[-1];Element of ReturnValue;value"
			Bag out = null;
			PredicatedCollection.Builder in = newPredicatedCollectionBuilderWithElement((String)source());
			out = in.createPredicatedBag();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;createPredicatedBag;;;Element of Argument[0];Element of ReturnValue;value"
			Bag out = null;
			Bag in = newTreeBagWithElement((String)source());
			PredicatedCollection.Builder instance = null;
			out = instance.createPredicatedBag(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;createPredicatedList;;;Element of Argument[-1];Element of ReturnValue;value"
			List out = null;
			PredicatedCollection.Builder in = newPredicatedCollectionBuilderWithElement((String)source());
			out = in.createPredicatedList(null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;createPredicatedList;;;Element of Argument[-1];Element of ReturnValue;value"
			List out = null;
			PredicatedCollection.Builder in = newPredicatedCollectionBuilderWithElement((String)source());
			out = in.createPredicatedList();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;createPredicatedList;;;Element of Argument[0];Element of ReturnValue;value"
			List out = null;
			List in = List.of((String)source());
			PredicatedCollection.Builder instance = null;
			out = instance.createPredicatedList(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;createPredicatedMultiSet;;;Element of Argument[-1];Element of ReturnValue;value"
			MultiSet out = null;
			PredicatedCollection.Builder in = newPredicatedCollectionBuilderWithElement((String)source());
			out = in.createPredicatedMultiSet(null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;createPredicatedMultiSet;;;Element of Argument[-1];Element of ReturnValue;value"
			MultiSet out = null;
			PredicatedCollection.Builder in = newPredicatedCollectionBuilderWithElement((String)source());
			out = in.createPredicatedMultiSet();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;createPredicatedMultiSet;;;Element of Argument[0];Element of ReturnValue;value"
			MultiSet out = null;
			MultiSet in = newHashMultiSetWithElement((String)source());
			PredicatedCollection.Builder instance = null;
			out = instance.createPredicatedMultiSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;createPredicatedQueue;;;Element of Argument[-1];Element of ReturnValue;value"
			Queue out = null;
			PredicatedCollection.Builder in = newPredicatedCollectionBuilderWithElement((String)source());
			out = in.createPredicatedQueue(null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;createPredicatedQueue;;;Element of Argument[-1];Element of ReturnValue;value"
			Queue out = null;
			PredicatedCollection.Builder in = newPredicatedCollectionBuilderWithElement((String)source());
			out = in.createPredicatedQueue();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;createPredicatedQueue;;;Element of Argument[0];Element of ReturnValue;value"
			Queue out = null;
			Queue in = newCircularFifoQueueWithElement((String)source());
			PredicatedCollection.Builder instance = null;
			out = instance.createPredicatedQueue(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;createPredicatedSet;;;Element of Argument[-1];Element of ReturnValue;value"
			Set out = null;
			PredicatedCollection.Builder in = newPredicatedCollectionBuilderWithElement((String)source());
			out = in.createPredicatedSet(null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;createPredicatedSet;;;Element of Argument[-1];Element of ReturnValue;value"
			Set out = null;
			PredicatedCollection.Builder in = newPredicatedCollectionBuilderWithElement((String)source());
			out = in.createPredicatedSet();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;createPredicatedSet;;;Element of Argument[0];Element of ReturnValue;value"
			Set out = null;
			Set in = newListOrderedSetWithElement((String)source());
			PredicatedCollection.Builder instance = null;
			out = instance.createPredicatedSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;rejectedElements;;;Element of Argument[-1];Element of ReturnValue;value"
			Collection out = null;
			PredicatedCollection.Builder in = newPredicatedCollectionBuilderWithElement((String)source());
			out = in.rejectedElements();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection;true;predicatedCollection;;;Element of Argument[0];Element of ReturnValue;value"
			PredicatedCollection out = null;
			Collection in = newTreeBagWithElement((String)source());
			out = PredicatedCollection.predicatedCollection(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;SynchronizedCollection;true;synchronizedCollection;;;Element of Argument[0];Element of ReturnValue;value"
			SynchronizedCollection out = null;
			Collection in = newTreeBagWithElement((String)source());
			out = SynchronizedCollection.synchronizedCollection(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;TransformedCollection;true;transformingCollection;;;Element of Argument[0];Element of ReturnValue;value"
			TransformedCollection out = null;
			Collection in = newTreeBagWithElement((String)source());
			out = TransformedCollection.transformingCollection(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;UnmodifiableBoundedCollection;true;unmodifiableBoundedCollection;;;Element of Argument[0];Element of ReturnValue;value"
			BoundedCollection out = null;
			Collection in = newTreeBagWithElement((String)source());
			out = UnmodifiableBoundedCollection.unmodifiableBoundedCollection(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;UnmodifiableBoundedCollection;true;unmodifiableBoundedCollection;;;Element of Argument[0];Element of ReturnValue;value"
			BoundedCollection out = null;
			BoundedCollection in = newCircularFifoQueueWithElement((String)source());
			out = UnmodifiableBoundedCollection.unmodifiableBoundedCollection(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;UnmodifiableCollection;true;unmodifiableCollection;;;Element of Argument[0];Element of ReturnValue;value"
			Collection out = null;
			Collection in = newTreeBagWithElement((String)source());
			out = UnmodifiableCollection.unmodifiableCollection(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;AbstractIteratorDecorator;true;AbstractIteratorDecorator;;;Element of Argument[0];Element of Argument[-1];value"
			AbstractIteratorDecorator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = new MyAbstractIteratorDecorator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;AbstractListIteratorDecorator;true;AbstractListIteratorDecorator;;;Element of Argument[0];Element of Argument[-1];value"
			AbstractListIteratorDecorator out = null;
			ListIterator in = newListIteratorWithElement((String)source());
			out = new MyAbstractListIteratorDecorator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;AbstractListIteratorDecorator;true;getListIterator;;;Element of Argument[-1];Element of ReturnValue;value"
			ListIterator out = null;
			MyAbstractListIteratorDecorator in = new MyAbstractListIteratorDecorator(newListIteratorWithElement((String)source()));
			out = in.myGetListIterator();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;AbstractMapIteratorDecorator;true;AbstractMapIteratorDecorator;;;Element of Argument[0];Element of Argument[-1];value"
			AbstractMapIteratorDecorator out = null;
			MapIterator in = newLinkedMapWithMapKey((String)source()).mapIterator();
			out = new MyAbstractMapIteratorDecorator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;AbstractMapIteratorDecorator;true;AbstractMapIteratorDecorator;;;MapValue of Argument[0];MapValue of Argument[-1];value"
			AbstractMapIteratorDecorator out = null;
			MapIterator in = newLinkedMapWithMapValue((String)source()).mapIterator();
			out = new MyAbstractMapIteratorDecorator(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;AbstractMapIteratorDecorator;true;getMapIterator;;;Element of Argument[-1];Element of ReturnValue;value"
			MapIterator out = null;
			MyAbstractMapIteratorDecorator in = new MyAbstractMapIteratorDecorator(newLinkedMapWithMapKey((String)source()).mapIterator());
			out = in.myGetMapIterator();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;AbstractMapIteratorDecorator;true;getMapIterator;;;MapValue of Argument[-1];MapValue of ReturnValue;value"
			MapIterator out = null;
			MyAbstractMapIteratorDecorator in = new MyAbstractMapIteratorDecorator(newLinkedMapWithMapValue((String)source()).mapIterator());
			out = in.myGetMapIterator();
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;AbstractOrderedMapIteratorDecorator;true;AbstractOrderedMapIteratorDecorator;;;Element of Argument[0];Element of Argument[-1];value"
			AbstractOrderedMapIteratorDecorator out = null;
			OrderedMapIterator in = newListOrderedMapWithMapKey((String)source()).mapIterator();
			out = new MyAbstractOrderedMapIteratorDecorator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;AbstractOrderedMapIteratorDecorator;true;AbstractOrderedMapIteratorDecorator;;;MapValue of Argument[0];MapValue of Argument[-1];value"
			AbstractOrderedMapIteratorDecorator out = null;
			OrderedMapIterator in = newListOrderedMapWithMapValue((String)source()).mapIterator();
			out = new MyAbstractOrderedMapIteratorDecorator(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;AbstractOrderedMapIteratorDecorator;true;getOrderedMapIterator;;;Element of Argument[-1];Element of ReturnValue;value"
			OrderedMapIterator out = null;
			MyAbstractOrderedMapIteratorDecorator in = new MyAbstractOrderedMapIteratorDecorator(newListOrderedMapWithMapKey((String)source()).mapIterator());
			out = in.myGetOrderedMapIterator();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;AbstractOrderedMapIteratorDecorator;true;getOrderedMapIterator;;;MapValue of Argument[-1];MapValue of ReturnValue;value"
			OrderedMapIterator out = null;
			MyAbstractOrderedMapIteratorDecorator in = new MyAbstractOrderedMapIteratorDecorator(newListOrderedMapWithMapValue((String)source()).mapIterator());
			out = in.myGetOrderedMapIterator();
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;AbstractUntypedIteratorDecorator;true;AbstractUntypedIteratorDecorator;;;Element of Argument[0];Element of Argument[-1];value"
			AbstractUntypedIteratorDecorator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = new MyAbstractUntypedIteratorDecorator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;AbstractUntypedIteratorDecorator;true;getIterator;;;Element of Argument[-1];Element of ReturnValue;value"
			Iterator out = null;
			MyAbstractUntypedIteratorDecorator in = new MyAbstractUntypedIteratorDecorator(newListIteratorWithElement((String)source()));
			out = in.myGetIterator();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ArrayIterator;true;ArrayIterator;;;ArrayElement of Argument[0];Element of Argument[-1];value"
			ArrayIterator out = null;
			Object in = (Object)newWithArrayElement((String)source());
			out = new ArrayIterator(in, 0, 0);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ArrayIterator;true;ArrayIterator;;;ArrayElement of Argument[0];Element of Argument[-1];value"
			ArrayIterator out = null;
			Object in = (Object)newWithArrayElement((String)source());
			out = new ArrayIterator(in, 0);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ArrayIterator;true;ArrayIterator;;;ArrayElement of Argument[0];Element of Argument[-1];value"
			ArrayIterator out = null;
			Object in = (Object)newWithArrayElement((String)source());
			out = new ArrayIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ArrayIterator;true;getArray;;;Element of Argument[-1];ArrayElement of ReturnValue;value"
			String[] out = null;
			ArrayIterator in = new ArrayIterator((Object)newWithArrayElement((String)source()));
			out = (String[])in.getArray();
			sink(getArrayElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ArrayListIterator;true;ArrayListIterator;;;ArrayElement of Argument[0];Element of Argument[-1];value"
			ArrayListIterator out = null;
			Object in = (Object)newWithArrayElement((String)source());
			out = new ArrayListIterator(in, 0, 0);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ArrayListIterator;true;ArrayListIterator;;;ArrayElement of Argument[0];Element of Argument[-1];value"
			ArrayListIterator out = null;
			Object in = (Object)newWithArrayElement((String)source());
			out = new ArrayListIterator(in, 0);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ArrayListIterator;true;ArrayListIterator;;;ArrayElement of Argument[0];Element of Argument[-1];value"
			ArrayListIterator out = null;
			Object in = (Object)newWithArrayElement((String)source());
			out = new ArrayListIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;BoundedIterator;true;BoundedIterator;;;Element of Argument[0];Element of Argument[-1];value"
			BoundedIterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = new BoundedIterator(in, 0L, 0L);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;CollatingIterator;true;CollatingIterator;(Comparator,Collection);;Element of Element of Argument[1];Element of Argument[-1];value"
			CollatingIterator out = null;
			Collection in = List.of(newListIteratorWithElement((String)source()));
			out = new CollatingIterator((Comparator)null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;CollatingIterator;true;CollatingIterator;(Comparator,Iterator,Iterator);;Element of Argument[1];Element of Argument[-1];value"
			CollatingIterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = new CollatingIterator(null, in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;CollatingIterator;true;CollatingIterator;(Comparator,Iterator,Iterator);;Element of Argument[2];Element of Argument[-1];value"
			CollatingIterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = new CollatingIterator(null, null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;CollatingIterator;true;CollatingIterator;(Comparator,Iterator[]);;Element of ArrayElement of Argument[1];Element of Argument[-1];value"
			CollatingIterator out = null;
			Iterator[] in = new Iterator[]{newListIteratorWithElement((String)source())};
			out = new CollatingIterator((Comparator)null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;CollatingIterator;true;addIterator;;;Element of Argument[0];Element of Argument[-1];value"
			CollatingIterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out.addIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;CollatingIterator;true;getIterators;;;Element of Argument[-1];Element of Element of ReturnValue;value"
			List<Iterator> out = null;
			CollatingIterator in = new CollatingIterator((Comparator)null, List.of(newListIteratorWithElement((String)source())));
			out = in.getIterators();
			sink(getElement(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;CollatingIterator;true;setIterator;;;Element of Argument[1];Element of Argument[-1];value"
			CollatingIterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out.setIterator(0, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;EnumerationIterator;true;EnumerationIterator;;;Element of Argument[0];Element of Argument[-1];value"
			EnumerationIterator out = null;
			Enumeration in = newEnumerationWithElement((String)source());
			out = new EnumerationIterator(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;EnumerationIterator;true;EnumerationIterator;;;Element of Argument[0];Element of Argument[-1];value"
			EnumerationIterator out = null;
			Enumeration in = newEnumerationWithElement((String)source());
			out = new EnumerationIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;EnumerationIterator;true;getEnumeration;;;Element of Argument[-1];Element of ReturnValue;value"
			Enumeration out = null;
			EnumerationIterator in = new EnumerationIterator(newEnumerationWithElement((String)source()));
			out = in.getEnumeration();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;EnumerationIterator;true;setEnumeration;;;Element of Argument[0];Element of Argument[-1];value"
			EnumerationIterator out = null;
			Enumeration in = newEnumerationWithElement((String)source());
			out.setEnumeration(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;FilterIterator;true;FilterIterator;;;Element of Argument[0];Element of Argument[-1];value"
			FilterIterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = new FilterIterator(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;FilterIterator;true;FilterIterator;;;Element of Argument[0];Element of Argument[-1];value"
			FilterIterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = new FilterIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;FilterIterator;true;getIterator;;;Element of Argument[-1];Element of ReturnValue;value"
			Iterator out = null;
			FilterIterator in = new FilterIterator(newListIteratorWithElement((String)source()));
			out = in.getIterator();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;FilterIterator;true;setIterator;;;Element of Argument[0];Element of Argument[-1];value"
			FilterIterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out.setIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;FilterListIterator;true;FilterListIterator;(ListIterator);;Element of Argument[0];Element of Argument[-1];value"
			FilterListIterator out = null;
			ListIterator in = newListIteratorWithElement((String)source());
			out = new FilterListIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;FilterListIterator;true;FilterListIterator;(ListIterator,Predicate);;Element of Argument[0];Element of Argument[-1];value"
			FilterListIterator out = null;
			ListIterator in = newListIteratorWithElement((String)source());
			out = new FilterListIterator(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;FilterListIterator;true;getListIterator;;;Element of Argument[-1];Element of ReturnValue;value"
			ListIterator out = null;
			FilterListIterator in = new FilterListIterator(newListIteratorWithElement((String)source()));
			out = in.getListIterator();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;FilterListIterator;true;setListIterator;;;Element of Argument[0];Element of Argument[-1];value"
			FilterListIterator out = null;
			ListIterator in = newListIteratorWithElement((String)source());
			out.setListIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;IteratorChain;true;IteratorChain;(Collection);;Element of Element of Argument[0];Element of Argument[-1];value"
			IteratorChain out = null;
			Collection in = newTreeBagWithElement(newListIteratorWithElement((String)source()));
			out = new IteratorChain(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;IteratorChain;true;IteratorChain;(Iterator);;Element of Argument[0];Element of Argument[-1];value"
			IteratorChain out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = new IteratorChain(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;IteratorChain;true;IteratorChain;(Iterator,Iterator);;Element of Argument[0];Element of Argument[-1];value"
			IteratorChain out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = new IteratorChain(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;IteratorChain;true;IteratorChain;(Iterator,Iterator);;Element of Argument[1];Element of Argument[-1];value"
			IteratorChain out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = new IteratorChain(null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;IteratorChain;true;IteratorChain;(Iterator[]);;Element of ArrayElement of Argument[0];Element of Argument[-1];value"
			IteratorChain out = null;
			Iterator[] in = new Iterator[]{newListIteratorWithElement((String)source())};
			out = new IteratorChain(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;IteratorChain;true;addIterator;;;Element of Argument[0];Element of Argument[-1];value"
			IteratorChain out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out.addIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;IteratorEnumeration;true;IteratorEnumeration;;;Element of Argument[0];Element of Argument[-1];value"
			IteratorEnumeration out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = new IteratorEnumeration(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;IteratorEnumeration;true;getIterator;;;Element of Argument[-1];Element of ReturnValue;value"
			Iterator out = null;
			IteratorEnumeration in = new IteratorEnumeration(newListIteratorWithElement((String)source()));
			out = in.getIterator();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;IteratorEnumeration;true;setIterator;;;Element of Argument[0];Element of Argument[-1];value"
			IteratorEnumeration out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out.setIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;IteratorIterable;true;IteratorIterable;;;Element of Argument[0];Element of Argument[-1];value"
			IteratorIterable out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = new IteratorIterable(in, false);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;IteratorIterable;true;IteratorIterable;;;Element of Argument[0];Element of Argument[-1];value"
			IteratorIterable out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = new IteratorIterable(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ListIteratorWrapper;true;ListIteratorWrapper;;;Element of Argument[0];Element of Argument[-1];value"
			ListIteratorWrapper out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = new ListIteratorWrapper(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;LoopingIterator;true;LoopingIterator;;;Element of Argument[0];Element of Argument[-1];value"
			LoopingIterator out = null;
			Collection in = newTreeBagWithElement((String)source());
			out = new LoopingIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;LoopingListIterator;true;LoopingListIterator;;;Element of Argument[0];Element of Argument[-1];value"
			LoopingListIterator out = null;
			List in = List.of((String)source());
			out = new LoopingListIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ObjectArrayIterator;true;ObjectArrayIterator;;;ArrayElement of Argument[0];Element of Argument[-1];value"
			ObjectArrayIterator out = null;
			Object[] in = new Object[]{(String)source()};
			out = new ObjectArrayIterator(in, 0, 0);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ObjectArrayIterator;true;ObjectArrayIterator;;;ArrayElement of Argument[0];Element of Argument[-1];value"
			ObjectArrayIterator out = null;
			Object[] in = new Object[]{(String)source()};
			out = new ObjectArrayIterator(in, 0);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ObjectArrayIterator;true;ObjectArrayIterator;;;ArrayElement of Argument[0];Element of Argument[-1];value"
			ObjectArrayIterator out = null;
			Object[] in = new Object[]{(String)source()};
			out = new ObjectArrayIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ObjectArrayIterator;true;getArray;;;Element of Argument[-1];ArrayElement of ReturnValue;value"
			Object[] out = null;
			ObjectArrayIterator in = new ObjectArrayIterator(new Object[]{(String)source()});
			out = in.getArray();
			sink(getArrayElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ObjectArrayListIterator;true;ObjectArrayListIterator;;;ArrayElement of Argument[0];Element of Argument[-1];value"
			ObjectArrayListIterator out = null;
			Object[] in = new Object[]{(String)source()};
			out = new ObjectArrayListIterator(in, 0, 0);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ObjectArrayListIterator;true;ObjectArrayListIterator;;;ArrayElement of Argument[0];Element of Argument[-1];value"
			ObjectArrayListIterator out = null;
			Object[] in = new Object[]{(String)source()};
			out = new ObjectArrayListIterator(in, 0);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ObjectArrayListIterator;true;ObjectArrayListIterator;;;ArrayElement of Argument[0];Element of Argument[-1];value"
			ObjectArrayListIterator out = null;
			Object[] in = new Object[]{(String)source()};
			out = new ObjectArrayListIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;PeekingIterator;true;PeekingIterator;;;Element of Argument[0];Element of Argument[-1];value"
			PeekingIterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = new PeekingIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;PeekingIterator;true;element;;;Element of Argument[-1];ReturnValue;value"
			Object out = null;
			PeekingIterator in = new PeekingIterator(newListIteratorWithElement((String)source()));
			out = in.element();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;PeekingIterator;true;peek;;;Element of Argument[-1];ReturnValue;value"
			Object out = null;
			PeekingIterator in = new PeekingIterator(newListIteratorWithElement((String)source()));
			out = in.peek();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;PeekingIterator;true;peekingIterator;;;Element of Argument[0];Element of ReturnValue;value"
			PeekingIterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = PeekingIterator.peekingIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;PermutationIterator;true;PermutationIterator;;;Element of Argument[0];Element of Element of Argument[-1];value"
			PermutationIterator<String> out = null;
			Collection<String> in = List.<String>of((String)source());
			out = new PermutationIterator(in);
			sink(getElement(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;PushbackIterator;true;PushbackIterator;;;Element of Argument[0];Element of Argument[-1];value"
			PushbackIterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = new PushbackIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;PushbackIterator;true;pushback;;;Argument[0];Element of Argument[-1];value"
			PushbackIterator out = null;
			Object in = source();
			out.pushback(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;PushbackIterator;true;pushbackIterator;;;Element of Argument[0];Element of ReturnValue;value"
			PushbackIterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = PushbackIterator.pushbackIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ReverseListIterator;true;ReverseListIterator;;;Element of Argument[0];Element of Argument[-1];value"
			ReverseListIterator out = null;
			List in = List.of((String)source());
			out = new ReverseListIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;SingletonIterator;true;SingletonIterator;;;Argument[0];Element of Argument[-1];value"
			SingletonIterator out = null;
			Object in = source();
			out = new SingletonIterator(in, false);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;SingletonIterator;true;SingletonIterator;;;Argument[0];Element of Argument[-1];value"
			SingletonIterator out = null;
			Object in = source();
			out = new SingletonIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;SingletonListIterator;true;SingletonListIterator;;;Argument[0];Element of Argument[-1];value"
			SingletonListIterator out = null;
			Object in = source();
			out = new SingletonListIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;SkippingIterator;true;SkippingIterator;;;Element of Argument[0];Element of Argument[-1];value"
			SkippingIterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = new SkippingIterator(in, 0L);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;UniqueFilterIterator;true;UniqueFilterIterator;;;Element of Argument[0];Element of Argument[-1];value"
			UniqueFilterIterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = new UniqueFilterIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;UnmodifiableIterator;true;unmodifiableIterator;;;Element of Argument[0];Element of ReturnValue;value"
			Iterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = UnmodifiableIterator.unmodifiableIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;UnmodifiableListIterator;true;umodifiableListIterator;;;Element of Argument[0];Element of ReturnValue;value"
			ListIterator out = null;
			ListIterator in = newListIteratorWithElement((String)source());
			out = UnmodifiableListIterator.umodifiableListIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;UnmodifiableMapIterator;true;unmodifiableMapIterator;;;Element of Argument[0];Element of ReturnValue;value"
			MapIterator out = null;
			MapIterator in = newLinkedMapWithMapKey((String)source()).mapIterator();
			out = UnmodifiableMapIterator.unmodifiableMapIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;UnmodifiableMapIterator;true;unmodifiableMapIterator;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			MapIterator out = null;
			MapIterator in = newLinkedMapWithMapValue((String)source()).mapIterator();
			out = UnmodifiableMapIterator.unmodifiableMapIterator(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;UnmodifiableOrderedMapIterator;true;unmodifiableOrderedMapIterator;;;Element of Argument[0];Element of ReturnValue;value"
			OrderedMapIterator out = null;
			OrderedMapIterator in = newListOrderedMapWithMapKey((String)source()).mapIterator();
			out = UnmodifiableOrderedMapIterator.unmodifiableOrderedMapIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;UnmodifiableOrderedMapIterator;true;unmodifiableOrderedMapIterator;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			OrderedMapIterator out = null;
			OrderedMapIterator in = newListOrderedMapWithMapValue((String)source()).mapIterator();
			out = UnmodifiableOrderedMapIterator.unmodifiableOrderedMapIterator(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ZippingIterator;true;ZippingIterator;(Iterator,Iterator);;Element of Argument[0];Element of Argument[-1];value"
			ZippingIterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = new ZippingIterator(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ZippingIterator;true;ZippingIterator;(Iterator,Iterator);;Element of Argument[1];Element of Argument[-1];value"
			ZippingIterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = new ZippingIterator(null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ZippingIterator;true;ZippingIterator;(Iterator,Iterator,Iterator);;Element of Argument[0];Element of Argument[-1];value"
			ZippingIterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = new ZippingIterator(in, null, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ZippingIterator;true;ZippingIterator;(Iterator,Iterator,Iterator);;Element of Argument[1];Element of Argument[-1];value"
			ZippingIterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = new ZippingIterator(null, in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ZippingIterator;true;ZippingIterator;(Iterator,Iterator,Iterator);;Element of Argument[2];Element of Argument[-1];value"
			ZippingIterator out = null;
			Iterator in = newListIteratorWithElement((String)source());
			out = new ZippingIterator(null, null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ZippingIterator;true;ZippingIterator;(Iterator[]);;Element of ArrayElement of Argument[0];Element of Argument[-1];value"
			ZippingIterator out = null;
			Iterator[] in = new Iterator[]{newListIteratorWithElement((String)source())};
			out = new ZippingIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object,Object);;Argument[0];Element of Argument[-1];value"
			MultiKey out = null;
			Object in = source();
			out = new MultiKey(in, (Object)null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object,Object);;Argument[1];Element of Argument[-1];value"
			MultiKey out = null;
			Object in = source();
			out = new MultiKey((Object)null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object,Object,Object);;Argument[0];Element of Argument[-1];value"
			MultiKey out = null;
			Object in = source();
			out = new MultiKey(in, null, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object,Object,Object);;Argument[1];Element of Argument[-1];value"
			MultiKey out = null;
			Object in = source();
			out = new MultiKey(null, in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object,Object,Object);;Argument[2];Element of Argument[-1];value"
			MultiKey out = null;
			Object in = source();
			out = new MultiKey(null, null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object);;Argument[0];Element of Argument[-1];value"
			MultiKey out = null;
			Object in = source();
			out = new MultiKey(in, null, null, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object);;Argument[1];Element of Argument[-1];value"
			MultiKey out = null;
			Object in = source();
			out = new MultiKey(null, in, null, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object);;Argument[2];Element of Argument[-1];value"
			MultiKey out = null;
			Object in = source();
			out = new MultiKey(null, null, in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object);;Argument[3];Element of Argument[-1];value"
			MultiKey out = null;
			Object in = source();
			out = new MultiKey(null, null, null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object,Object);;Argument[0];Element of Argument[-1];value"
			MultiKey out = null;
			Object in = source();
			out = new MultiKey(in, null, null, null, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object,Object);;Argument[1];Element of Argument[-1];value"
			MultiKey out = null;
			Object in = source();
			out = new MultiKey(null, in, null, null, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object,Object);;Argument[2];Element of Argument[-1];value"
			MultiKey out = null;
			Object in = source();
			out = new MultiKey(null, null, in, null, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object,Object);;Argument[3];Element of Argument[-1];value"
			MultiKey out = null;
			Object in = source();
			out = new MultiKey(null, null, null, in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object,Object);;Argument[4];Element of Argument[-1];value"
			MultiKey out = null;
			Object in = source();
			out = new MultiKey(null, null, null, null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object[]);;ArrayElement of Argument[0];Element of Argument[-1];value"
			MultiKey out = null;
			Object[] in = new Object[]{(String)source()};
			out = new MultiKey(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object[],boolean);;ArrayElement of Argument[0];Element of Argument[-1];value"
			MultiKey out = null;
			Object[] in = new Object[]{(String)source()};
			out = new MultiKey(in, false);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;getKey;;;Element of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiKey in = newMultiKeyWithElement((String)source());
			out = in.getKey(0);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;getKeys;;;Element of Argument[-1];ArrayElement of ReturnValue;value"
			Object[] out = null;
			MultiKey in = newMultiKeyWithElement((String)source());
			out = in.getKeys();
			sink(getArrayElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;AbstractLinkedList;true;AbstractLinkedList;;;Element of Argument[0];Element of Argument[-1];value"
			AbstractLinkedList out = null;
			Collection in = newTreeBagWithElement((String)source());
			out = new MyAbstractLinkedList(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;AbstractLinkedList;true;addFirst;;;Argument[0];Element of Argument[-1];value"
			AbstractLinkedList out = null;
			Object in = source();
			out.addFirst(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;AbstractLinkedList;true;addLast;;;Argument[0];Element of Argument[-1];value"
			AbstractLinkedList out = null;
			Object in = source();
			out.addLast(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;AbstractLinkedList;true;getFirst;;;Element of Argument[-1];ReturnValue;value"
			Object out = null;
			AbstractLinkedList in = newCursorableLinkedListWithElement((String)source());
			out = in.getFirst();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;AbstractLinkedList;true;getLast;;;Element of Argument[-1];ReturnValue;value"
			Object out = null;
			AbstractLinkedList in = newCursorableLinkedListWithElement((String)source());
			out = in.getLast();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;AbstractLinkedList;true;removeFirst;;;Element of Argument[-1];ReturnValue;value"
			Object out = null;
			AbstractLinkedList in = newCursorableLinkedListWithElement((String)source());
			out = in.removeFirst();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;AbstractLinkedList;true;removeLast;;;Element of Argument[-1];ReturnValue;value"
			Object out = null;
			AbstractLinkedList in = newCursorableLinkedListWithElement((String)source());
			out = in.removeLast();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;AbstractListDecorator;true;AbstractListDecorator;;;Element of Argument[0];Element of Argument[-1];value"
			AbstractListDecorator out = null;
			List in = List.of((String)source());
			out = new MyAbstractListDecorator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;AbstractSerializableListDecorator;true;AbstractSerializableListDecorator;;;Element of Argument[0];Element of Argument[-1];value"
			AbstractSerializableListDecorator out = null;
			List in = List.of((String)source());
			out = new MyAbstractSerializableListDecorator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;CursorableLinkedList;true;CursorableLinkedList;;;Element of Argument[0];Element of Argument[-1];value"
			CursorableLinkedList out = null;
			Collection in = List.of((String)source());
			out = new CursorableLinkedList(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;CursorableLinkedList;true;cursor;;;Element of Argument[-1];Element of ReturnValue;value"
			CursorableLinkedList.Cursor out = null;
			CursorableLinkedList in = newCursorableLinkedListWithElement((String)source());
			out = in.cursor(0);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;CursorableLinkedList;true;cursor;;;Element of Argument[-1];Element of ReturnValue;value"
			CursorableLinkedList.Cursor out = null;
			CursorableLinkedList in = newCursorableLinkedListWithElement((String)source());
			out = in.cursor();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;FixedSizeList;true;fixedSizeList;;;Element of Argument[0];Element of ReturnValue;value"
			FixedSizeList out = null;
			List in = List.of((String)source());
			out = FixedSizeList.fixedSizeList(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;GrowthList;true;growthList;;;Element of Argument[0];Element of ReturnValue;value"
			GrowthList out = null;
			List in = List.of((String)source());
			out = GrowthList.growthList(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;LazyList;true;lazyList;;;Element of Argument[0];Element of ReturnValue;value"
			LazyList out = null;
			List in = List.of((String)source());
			out = LazyList.lazyList(in, (Transformer)null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;LazyList;true;lazyList;;;Element of Argument[0];Element of ReturnValue;value"
			LazyList out = null;
			List in = List.of((String)source());
			out = LazyList.lazyList(in, (Factory)null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;NodeCachingLinkedList;true;NodeCachingLinkedList;(Collection);;Element of Argument[0];Element of Argument[-1];value"
			NodeCachingLinkedList out = null;
			Collection in = List.of((String)source());
			out = new NodeCachingLinkedList(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;PredicatedList;true;predicatedList;;;Element of Argument[0];Element of ReturnValue;value"
			PredicatedList out = null;
			List in = List.of((String)source());
			out = PredicatedList.predicatedList(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;SetUniqueList;true;asSet;;;Element of Argument[-1];Element of ReturnValue;value"
			Set out = null;
			SetUniqueList in = SetUniqueList.setUniqueList(List.of((String)source()));
			out = in.asSet();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;SetUniqueList;true;setUniqueList;;;Element of Argument[0];Element of ReturnValue;value"
			SetUniqueList out = null;
			List in = List.of((String)source());
			out = SetUniqueList.setUniqueList(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;TransformedList;true;transformingList;;;Element of Argument[0];Element of ReturnValue;value"
			TransformedList out = null;
			List in = List.of((String)source());
			out = TransformedList.transformingList(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;TreeList;true;TreeList;;;Element of Argument[0];Element of Argument[-1];value"
			TreeList out = null;
			Collection in = List.of((String)source());
			out = new TreeList(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;UnmodifiableList;true;UnmodifiableList;;;Element of Argument[0];Element of Argument[-1];value"
			UnmodifiableList out = null;
			List in = List.of((String)source());
			out = new UnmodifiableList(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;UnmodifiableList;true;unmodifiableList;;;Element of Argument[0];Element of ReturnValue;value"
			List out = null;
			List in = List.of((String)source());
			out = UnmodifiableList.unmodifiableList(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;AbstractHashedMap;true;AbstractHashedMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			AbstractHashedMap out = null;
			Map in = Map.of((String)source(), null);
			out = new MyAbstractHashedMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;AbstractHashedMap;true;AbstractHashedMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value"
			AbstractHashedMap out = null;
			Map in = Map.of(null, (String)source());
			out = new MyAbstractHashedMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;AbstractLinkedMap;true;AbstractLinkedMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			AbstractLinkedMap out = null;
			Map in = Map.of((String)source(), null);
			out = new MyAbstractLinkedMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;AbstractLinkedMap;true;AbstractLinkedMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value"
			AbstractLinkedMap out = null;
			Map in = Map.of(null, (String)source());
			out = new MyAbstractLinkedMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;AbstractMapDecorator;true;AbstractMapDecorator;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			AbstractMapDecorator out = null;
			Map in = Map.of((String)source(), null);
			out = new MyAbstractMapDecorator(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;AbstractMapDecorator;true;AbstractMapDecorator;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value"
			AbstractMapDecorator out = null;
			Map in = Map.of(null, (String)source());
			out = new MyAbstractMapDecorator(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;AbstractMapDecorator;true;decorated;;;MapKey of Argument[-1];MapKey of ReturnValue;value"
			Map out = null;
			MyAbstractMapDecorator in = new MyAbstractMapDecorator(Map.of((String)source(), null));
			out = in.myDecorated();
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;AbstractMapDecorator;true;decorated;;;MapValue of Argument[-1];MapValue of ReturnValue;value"
			Map out = null;
			MyAbstractMapDecorator in = new MyAbstractMapDecorator(Map.of(null, (String)source()));
			out = in.myDecorated();
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;AbstractOrderedMapDecorator;true;AbstractOrderedMapDecorator;(OrderedMap);;MapKey of Argument[0];MapKey of Argument[-1];value"
			AbstractOrderedMapDecorator out = null;
			OrderedMap in = newListOrderedMapWithMapKey((String)source());
			out = new MyAbstractOrderedMapDecorator(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;AbstractOrderedMapDecorator;true;AbstractOrderedMapDecorator;(OrderedMap);;MapValue of Argument[0];MapValue of Argument[-1];value"
			AbstractOrderedMapDecorator out = null;
			OrderedMap in = newListOrderedMapWithMapValue((String)source());
			out = new MyAbstractOrderedMapDecorator(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;AbstractSortedMapDecorator;true;AbstractSortedMapDecorator;(SortedMap);;MapKey of Argument[0];MapKey of Argument[-1];value"
			AbstractSortedMapDecorator out = null;
			SortedMap in = newTreeMapWithMapKey((String)source());
			out = new MyAbstractSortedMapDecorator(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;AbstractSortedMapDecorator;true;AbstractSortedMapDecorator;(SortedMap);;MapValue of Argument[0];MapValue of Argument[-1];value"
			AbstractSortedMapDecorator out = null;
			SortedMap in = newTreeMapWithMapValue((String)source());
			out = new MyAbstractSortedMapDecorator(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CaseInsensitiveMap;true;CaseInsensitiveMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			CaseInsensitiveMap out = null;
			Map in = Map.of((String)source(), null);
			out = new CaseInsensitiveMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CaseInsensitiveMap;true;CaseInsensitiveMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value"
			CaseInsensitiveMap out = null;
			Map in = Map.of(null, (String)source());
			out = new CaseInsensitiveMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;CompositeMap;(Map,Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			CompositeMap out = null;
			Map in = Map.of((String)source(), null);
			out = new CompositeMap(in, (Map)null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;CompositeMap;(Map,Map);;MapKey of Argument[1];MapKey of Argument[-1];value"
			CompositeMap out = null;
			Map in = Map.of((String)source(), null);
			out = new CompositeMap((Map)null, in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;CompositeMap;(Map,Map);;MapValue of Argument[0];MapValue of Argument[-1];value"
			CompositeMap out = null;
			Map in = Map.of(null, (String)source());
			out = new CompositeMap(in, (Map)null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;CompositeMap;(Map,Map);;MapValue of Argument[1];MapValue of Argument[-1];value"
			CompositeMap out = null;
			Map in = Map.of(null, (String)source());
			out = new CompositeMap((Map)null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;CompositeMap;(Map,Map,MapMutator);;MapKey of Argument[0];MapKey of Argument[-1];value"
			CompositeMap out = null;
			Map in = Map.of((String)source(), null);
			out = new CompositeMap(in, null, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;CompositeMap;(Map,Map,MapMutator);;MapKey of Argument[1];MapKey of Argument[-1];value"
			CompositeMap out = null;
			Map in = Map.of((String)source(), null);
			out = new CompositeMap(null, in, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;CompositeMap;(Map,Map,MapMutator);;MapValue of Argument[0];MapValue of Argument[-1];value"
			CompositeMap out = null;
			Map in = Map.of(null, (String)source());
			out = new CompositeMap(in, null, null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;CompositeMap;(Map,Map,MapMutator);;MapValue of Argument[1];MapValue of Argument[-1];value"
			CompositeMap out = null;
			Map in = Map.of(null, (String)source());
			out = new CompositeMap(null, in, null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;CompositeMap;(Map[]);;MapKey of ArrayElement of Argument[0];MapKey of Argument[-1];value"
			CompositeMap out = null;
			Map[] in = new Map[]{Map.of((String)source(), null)};
			out = new CompositeMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;CompositeMap;(Map[]);;MapValue of ArrayElement of Argument[0];MapValue of Argument[-1];value"
			CompositeMap out = null;
			Map[] in = new Map[]{Map.of(null, (String)source())};
			out = new CompositeMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;CompositeMap;(Map[],MapMutator);;MapKey of ArrayElement of Argument[0];MapKey of Argument[-1];value"
			CompositeMap out = null;
			Map[] in = new Map[]{Map.of((String)source(), null)};
			out = new CompositeMap(in, (CompositeMap.MapMutator)null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;CompositeMap;(Map[],MapMutator);;MapValue of ArrayElement of Argument[0];MapValue of Argument[-1];value"
			CompositeMap out = null;
			Map[] in = new Map[]{Map.of(null, (String)source())};
			out = new CompositeMap(in, (CompositeMap.MapMutator)null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;addComposited;;;MapKey of Argument[0];MapKey of Argument[-1];value"
			CompositeMap out = null;
			Map in = Map.of((String)source(), null);
			out.addComposited(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;addComposited;;;MapValue of Argument[0];MapValue of Argument[-1];value"
			CompositeMap out = null;
			Map in = Map.of(null, (String)source());
			out.addComposited(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;removeComposited;;;Argument[0];ReturnValue;value"
			Map out = null;
			Map in = (Map)source();
			CompositeMap instance = null;
			out = instance.removeComposited(in);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;removeComposited;;;MapKey of Argument[-1];MapKey of ReturnValue;value"
			Map out = null;
			CompositeMap in = new CompositeMap(Map.of((String)source(), null), null);
			out = in.removeComposited(null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;removeComposited;;;MapValue of Argument[-1];MapValue of ReturnValue;value"
			Map out = null;
			CompositeMap in = new CompositeMap(Map.of(null, (String)source()), null);
			out = in.removeComposited(null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;DefaultedMap;true;DefaultedMap;(Object);;Argument[0];MapValue of Argument[-1];value"
			DefaultedMap out = null;
			Object in = source();
			out = new DefaultedMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;DefaultedMap;true;defaultedMap;(Map,Object);;Argument[1];MapValue of ReturnValue;value"
			DefaultedMap out = null;
			Object in = source();
			out = DefaultedMap.defaultedMap((Map)null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;DefaultedMap;true;defaultedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			Map out = null;
			Map<Object,String> in = Map.of((String)source(), null);
			out = DefaultedMap.defaultedMap(in, (Transformer)null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;DefaultedMap;true;defaultedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			DefaultedMap out = null;
			Map in = Map.of((String)source(), null);
			out = DefaultedMap.defaultedMap(in, (Object)null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;DefaultedMap;true;defaultedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			DefaultedMap out = null;
			Map<Object,String> in = Map.of((String)source(), null);
			out = DefaultedMap.defaultedMap(in, (Factory)null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;DefaultedMap;true;defaultedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			Map out = null;
			Map<Object,String> in = Map.of(null, (String)source());
			out = DefaultedMap.defaultedMap(in, (Transformer)null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;DefaultedMap;true;defaultedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			DefaultedMap out = null;
			Map in = Map.of(null, (String)source());
			out = DefaultedMap.defaultedMap(in, (Object)null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;DefaultedMap;true;defaultedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			DefaultedMap out = null;
			Map<Object,String> in = Map.of(null, (String)source());
			out = DefaultedMap.defaultedMap(in, (Factory)null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;EntrySetToMapIteratorAdapter;true;EntrySetToMapIteratorAdapter;;;MapKey of Element of Argument[0];Element of Argument[-1];value"
			EntrySetToMapIteratorAdapter out = null;
			Set in = newListOrderedSetWithElement(newTMEWithMapKey((String)source()));
			out = new EntrySetToMapIteratorAdapter(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;EntrySetToMapIteratorAdapter;true;EntrySetToMapIteratorAdapter;;;MapValue of Element of Argument[0];MapValue of Argument[-1];value"
			EntrySetToMapIteratorAdapter out = null;
			Set in = newListOrderedSetWithElement(newTMEWithMapValue((String)source()));
			out = new EntrySetToMapIteratorAdapter(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;FixedSizeMap;true;fixedSizeMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			FixedSizeMap out = null;
			Map in = Map.of((String)source(), null);
			out = FixedSizeMap.fixedSizeMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;FixedSizeMap;true;fixedSizeMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			FixedSizeMap out = null;
			Map in = Map.of(null, (String)source());
			out = FixedSizeMap.fixedSizeMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;FixedSizeSortedMap;true;fixedSizeSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			FixedSizeSortedMap out = null;
			SortedMap in = newTreeMapWithMapKey((String)source());
			out = FixedSizeSortedMap.fixedSizeSortedMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;FixedSizeSortedMap;true;fixedSizeSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			FixedSizeSortedMap out = null;
			SortedMap in = newTreeMapWithMapValue((String)source());
			out = FixedSizeSortedMap.fixedSizeSortedMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;Flat3Map;true;Flat3Map;;;MapKey of Argument[0];MapKey of Argument[-1];value"
			Flat3Map out = null;
			Map in = Map.of((String)source(), null);
			out = new Flat3Map(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;Flat3Map;true;Flat3Map;;;MapValue of Argument[0];MapValue of Argument[-1];value"
			Flat3Map out = null;
			Map in = Map.of(null, (String)source());
			out = new Flat3Map(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;HashedMap;true;HashedMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			HashedMap out = null;
			Map in = Map.of((String)source(), null);
			out = new HashedMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;HashedMap;true;HashedMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value"
			HashedMap out = null;
			Map in = Map.of(null, (String)source());
			out = new HashedMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LRUMap;true;LRUMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			LRUMap out = null;
			Map in = Map.of((String)source(), null);
			out = new LRUMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LRUMap;true;LRUMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value"
			LRUMap out = null;
			Map in = Map.of(null, (String)source());
			out = new LRUMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LRUMap;true;LRUMap;(Map,boolean);;MapKey of Argument[0];MapKey of Argument[-1];value"
			LRUMap out = null;
			Map in = Map.of((String)source(), null);
			out = new LRUMap(in, false);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LRUMap;true;LRUMap;(Map,boolean);;MapValue of Argument[0];MapValue of Argument[-1];value"
			LRUMap out = null;
			Map in = Map.of(null, (String)source());
			out = new LRUMap(in, false);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LRUMap;true;get;(Object,boolean);;MapValue of Argument[0];ReturnValue;value"
			Object out = null;
			Object in = (Object)Map.of(null, (String)source());
			LRUMap instance = null;
			out = instance.get(in, false);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LazyMap;true;lazyMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			LazyMap out = null;
			Map in = Map.of((String)source(), null);
			out = LazyMap.lazyMap(in, (Transformer)null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LazyMap;true;lazyMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			LazyMap out = null;
			Map in = Map.of((String)source(), null);
			out = LazyMap.lazyMap(in, (Factory)null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LazyMap;true;lazyMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			LazyMap out = null;
			Map in = Map.of(null, (String)source());
			out = LazyMap.lazyMap(in, (Transformer)null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LazyMap;true;lazyMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			LazyMap out = null;
			Map in = Map.of(null, (String)source());
			out = LazyMap.lazyMap(in, (Factory)null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LazySortedMap;true;lazySortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			LazySortedMap out = null;
			SortedMap in = newTreeMapWithMapKey((String)source());
			out = LazySortedMap.lazySortedMap(in, (Transformer)null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LazySortedMap;true;lazySortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			LazySortedMap out = null;
			SortedMap in = newTreeMapWithMapKey((String)source());
			out = LazySortedMap.lazySortedMap(in, (Factory)null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LazySortedMap;true;lazySortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			LazySortedMap out = null;
			SortedMap in = newTreeMapWithMapValue((String)source());
			out = LazySortedMap.lazySortedMap(in, (Transformer)null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LazySortedMap;true;lazySortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			LazySortedMap out = null;
			SortedMap in = newTreeMapWithMapValue((String)source());
			out = LazySortedMap.lazySortedMap(in, (Factory)null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LinkedMap;true;LinkedMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			LinkedMap out = null;
			Map in = Map.of((String)source(), null);
			out = new LinkedMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LinkedMap;true;LinkedMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value"
			LinkedMap out = null;
			Map in = Map.of(null, (String)source());
			out = new LinkedMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LinkedMap;true;asList;;;MapKey of Argument[-1];Element of ReturnValue;value"
			List out = null;
			LinkedMap in = newLinkedMapWithMapKey((String)source());
			out = in.asList();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LinkedMap;true;get;(int);;MapKey of Argument[-1];ReturnValue;value"
			Object out = null;
			LinkedMap in = newLinkedMapWithMapKey((String)source());
			out = in.get(0);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LinkedMap;true;getValue;(int);;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			LinkedMap in = newLinkedMapWithMapValue((String)source());
			out = in.getValue(0);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LinkedMap;true;remove;(int);;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			LinkedMap in = newLinkedMapWithMapValue((String)source());
			out = in.remove(0);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;ListOrderedMap;true;asList;;;MapKey of Argument[-1];Element of ReturnValue;value"
			List out = null;
			ListOrderedMap in = newListOrderedMapWithMapKey((String)source());
			out = in.asList();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;ListOrderedMap;true;get;(int);;MapKey of Argument[-1];ReturnValue;value"
			Object out = null;
			ListOrderedMap in = newListOrderedMapWithMapKey(source());
			out = in.get(0);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;ListOrderedMap;true;getValue;(int);;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			ListOrderedMap in = newListOrderedMapWithMapValue(source());
			out = in.getValue(0);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;ListOrderedMap;true;keyList;;;MapKey of Argument[-1];Element of ReturnValue;value"
			List out = null;
			ListOrderedMap in = newListOrderedMapWithMapKey((String)source());
			out = in.keyList();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;ListOrderedMap;true;listOrderedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			ListOrderedMap out = null;
			Map in = Map.of((String)source(), null);
			out = ListOrderedMap.listOrderedMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;ListOrderedMap;true;listOrderedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			ListOrderedMap out = null;
			Map in = Map.of(null, (String)source());
			out = ListOrderedMap.listOrderedMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;ListOrderedMap;true;put;;;Argument[1];MapKey of Argument[-1];value"
			ListOrderedMap out = null;
			Object in = source();
			out.put(null, in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;ListOrderedMap;true;put;;;Argument[1];MapKey of Argument[-1];value"
			ListOrderedMap out = null;
			Object in = source();
			out.put(0, in, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;ListOrderedMap;true;put;;;Argument[2];MapValue of Argument[-1];value"
			ListOrderedMap out = null;
			Object in = source();
			out.put(0, null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;ListOrderedMap;true;putAll;;;MapKey of Argument[1];MapKey of Argument[-1];value"
			ListOrderedMap out = null;
			Map in = Map.of((String)source(), null);
			out.putAll(0, in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;ListOrderedMap;true;putAll;;;MapValue of Argument[1];MapValue of Argument[-1];value"
			ListOrderedMap out = null;
			Map in = Map.of(null, (String)source());
			out.putAll(0, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;ListOrderedMap;true;remove;(int);;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			ListOrderedMap in = newListOrderedMapWithMapValue((String)source());
			out = in.remove(0);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;ListOrderedMap;true;setValue;;;Argument[1];MapValue of Argument[-1];value"
			ListOrderedMap out = null;
			Object in = source();
			out.setValue(0, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;ListOrderedMap;true;valueList;;;MapValue of Argument[-1];Element of ReturnValue;value"
			List out = null;
			ListOrderedMap in = newListOrderedMapWithMapValue((String)source());
			out = in.valueList();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;get;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiKeyMap in = newMKMWithMapValue((String)source());
			out = in.get(null, null, null, null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;get;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiKeyMap in = newMKMWithMapValue((String)source());
			out = in.get(null, null, null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;get;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiKeyMap in = newMKMWithMapValue((String)source());
			out = in.get(null, null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;get;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiKeyMap in = newMKMWithMapValue((String)source());
			out = in.get(null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object);;Argument[0..1];Element of MapKey of Argument[-1];value"
			MultiKeyMap<String,String> out = null;
			String in = (String)source();
			out.put(null, in, null);
			sink(getElement(getMapKey(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object);;Argument[0..1];Element of MapKey of Argument[-1];value"
			MultiKeyMap<String,String> out = null;
			String in = (String)source();
			out.put(in, null, null);
			sink(getElement(getMapKey(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object);;Argument[2];MapValue of Argument[-1];value"
			MultiKeyMap<String,String> out = null;
			String in = (String)source();
			out.put(null, null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object,Object);;Argument[0..2];Element of MapKey of Argument[-1];value"
			MultiKeyMap<String,String> out = null;
			String in = (String)source();
			out.put(null, null, in, null);
			sink(getElement(getMapKey(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object,Object);;Argument[0..2];Element of MapKey of Argument[-1];value"
			MultiKeyMap<String,String> out = null;
			String in = (String)source();
			out.put(null, in, null, null);
			sink(getElement(getMapKey(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object,Object);;Argument[0..2];Element of MapKey of Argument[-1];value"
			MultiKeyMap<String,String> out = null;
			String in = (String)source();
			out.put(in, null, null, null);
			sink(getElement(getMapKey(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object,Object);;Argument[3];MapValue of Argument[-1];value"
			MultiKeyMap<String,String> out = null;
			String in = (String)source();
			out.put(null, null, null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object);;Argument[0..3];Element of MapKey of Argument[-1];value"
			MultiKeyMap<String,String> out = null;
			String in = (String)source();
			out.put(null, null, null, in, null);
			sink(getElement(getMapKey(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object);;Argument[0..3];Element of MapKey of Argument[-1];value"
			MultiKeyMap<String,String> out = null;
			String in = (String)source();
			out.put(null, null, in, null, null);
			sink(getElement(getMapKey(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object);;Argument[0..3];Element of MapKey of Argument[-1];value"
			MultiKeyMap<String,String> out = null;
			String in = (String)source();
			out.put(null, in, null, null, null);
			sink(getElement(getMapKey(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object);;Argument[0..3];Element of MapKey of Argument[-1];value"
			MultiKeyMap<String,String> out = null;
			String in = (String)source();
			out.put(in, null, null, null, null);
			sink(getElement(getMapKey(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object);;Argument[4];MapValue of Argument[-1];value"
			MultiKeyMap<String,String> out = null;
			String in = (String)source();
			out.put(null, null, null, null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object,Object);;Argument[0..4];Element of MapKey of Argument[-1];value"
			MultiKeyMap<String,String> out = null;
			String in = (String)source();
			out.put(null, null, null, null, in, null);
			sink(getElement(getMapKey(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object,Object);;Argument[0..4];Element of MapKey of Argument[-1];value"
			MultiKeyMap<String,String> out = null;
			String in = (String)source();
			out.put(null, null, null, in, null, null);
			sink(getElement(getMapKey(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object,Object);;Argument[0..4];Element of MapKey of Argument[-1];value"
			MultiKeyMap<String,String> out = null;
			String in = (String)source();
			out.put(null, null, in, null, null, null);
			sink(getElement(getMapKey(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object,Object);;Argument[0..4];Element of MapKey of Argument[-1];value"
			MultiKeyMap<String,String> out = null;
			String in = (String)source();
			out.put(null, in, null, null, null, null);
			sink(getElement(getMapKey(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object,Object);;Argument[0..4];Element of MapKey of Argument[-1];value"
			MultiKeyMap<String,String> out = null;
			String in = (String)source();
			out.put(in, null, null, null, null, null);
			sink(getElement(getMapKey(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object,Object);;Argument[5];MapValue of Argument[-1];value"
			MultiKeyMap<String,String> out = null;
			String in = (String)source();
			out.put(null, null, null, null, null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiKeyMap in = newMKMWithMapValue((String)source());
			out = in.put(null, null, null, null, null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiKeyMap in = newMKMWithMapValue((String)source());
			out = in.put(null, null, null, null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiKeyMap in = newMKMWithMapValue((String)source());
			out = in.put(null, null, null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiKeyMap in = newMKMWithMapValue((String)source());
			out = in.put(null, null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiKeyMap in = newMKMWithMapValue((String)source());
			out = in.put(null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;removeMultiKey;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiKeyMap in = newMKMWithMapValue((String)source());
			out = in.removeMultiKey(null, null, null, null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;removeMultiKey;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiKeyMap in = newMKMWithMapValue((String)source());
			out = in.removeMultiKey(null, null, null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;removeMultiKey;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiKeyMap in = newMKMWithMapValue((String)source());
			out = in.removeMultiKey(null, null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;removeMultiKey;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiKeyMap in = newMKMWithMapValue((String)source());
			out = in.removeMultiKey(null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiValueMap;true;getCollection;;;Element of MapValue of Argument[-1];Element of ReturnValue;value"
			Collection out = null;
			MultiValueMap in = newMVMWithMapValue((String)source());
			out = in.getCollection(null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiValueMap;true;iterator;();;Element of MapValue of Argument[-1];MapValue of Element of ReturnValue;value"
			Iterator<Map.Entry<String,String>> out = null;
			MultiValueMap<String,String> in = newMVMWithMapValue((String)source());
			out = in.iterator();
			sink(getMapValueFromEntry(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;<String,String>;true;iterator;();;MapKey of Argument[-1];MapKey of Element of ReturnValue;value"
			Iterator<Map.Entry<String,String>> out = null;
			MultiValueMap<String,String> in = newMVMWithMapKey((String)source());
			out = in.iterator();
			sink(getMapKeyFromEntry(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiValueMap;true;iterator;(Object);;Element of MapValue of Argument[-1];Element of ReturnValue;value"
			Iterator<String> out = null;
			MultiValueMap<String,String> in = newMVMWithMapValue((String)source());
			out = in.iterator(null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiValueMap;true;multiValueMap;;;Element of MapValue of Argument[0];Element of MapValue of ReturnValue;value"
			MultiValueMap out = null;
			Map in = Map.of(null, newVectorWithElement((String)source()));
			out = MultiValueMap.multiValueMap(in, (Factory)null);
			sink(getElement((Collection)getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiValueMap;true;multiValueMap;;;Element of MapValue of Argument[0];Element of MapValue of ReturnValue;value"
			MultiValueMap out = null;
			Map in = Map.of(null, newVectorWithElement((String)source()));
			out = MultiValueMap.multiValueMap(in, (Class)null);
			sink(getElement((Collection)getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiValueMap;true;multiValueMap;;;Element of MapValue of Argument[0];Element of MapValue of ReturnValue;value"
			MultiValueMap out = null;
			Map in = Map.of(null, newVectorWithElement((String)source()));
			out = MultiValueMap.multiValueMap(in);
			sink(getElement((Collection)getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiValueMap;true;multiValueMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			MultiValueMap out = null;
			Map in = Map.of((String)source(), null);
			out = MultiValueMap.multiValueMap(in, (Factory)null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiValueMap;true;multiValueMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			MultiValueMap out = null;
			Map in = Map.of((String)source(), null);
			out = MultiValueMap.multiValueMap(in, (Class)null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiValueMap;true;multiValueMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			MultiValueMap out = null;
			Map in = Map.of((String)source(), null);
			out = MultiValueMap.multiValueMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiValueMap;true;putAll;(Map);;Element of MapValue of Argument[0];Element of MapValue of Argument[-1];value"
			MultiValueMap out = null;
			Map in = newMVMWithMapValue((String)source());
			out.putAll(in);
			sink(getElement((Collection)getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiValueMap;true;putAll;(Map);;MapValue of Argument[0];Element of MapValue of Argument[-1];value"
			MultiValueMap out = null;
			Map in = Map.of(null, source());
			out.putAll(in);
			sink(getElement((Collection)getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiValueMap;true;putAll;(Object,Collection);;Argument[0];MapKey of Argument[-1];value"
			MultiValueMap out = null;
			Object in = source();
			out.putAll(in, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiValueMap;true;putAll;(Object,Collection);;Element of Argument[1];Element of MapValue of Argument[-1];value"
			MultiValueMap out = null;
			Collection in = newTreeBagWithElement((String)source());
			out.putAll(null, in);
			sink(getElement((Collection)getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiValueMap;true;values;;;Element of MapValue of Argument[-1];Element of ReturnValue;value"
			Collection out = null;
			MultiValueMap in = newMVMWithMapValue((String)source());
			out = in.values();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;PassiveExpiringMap;true;PassiveExpiringMap;(ExpirationPolicy,Map);;MapKey of Argument[1];MapKey of Argument[-1];value"
			PassiveExpiringMap out = null;
			Map in = Map.of((String)source(), null);
			out = new PassiveExpiringMap((PassiveExpiringMap.ExpirationPolicy)null, in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;PassiveExpiringMap;true;PassiveExpiringMap;(ExpirationPolicy,Map);;MapValue of Argument[1];MapValue of Argument[-1];value"
			PassiveExpiringMap out = null;
			Map in = Map.of(null, (String)source());
			out = new PassiveExpiringMap((PassiveExpiringMap.ExpirationPolicy)null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;PassiveExpiringMap;true;PassiveExpiringMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			PassiveExpiringMap out = null;
			Map in = Map.of((String)source(), null);
			out = new PassiveExpiringMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;PassiveExpiringMap;true;PassiveExpiringMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value"
			PassiveExpiringMap out = null;
			Map in = Map.of(null, (String)source());
			out = new PassiveExpiringMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;PassiveExpiringMap;true;PassiveExpiringMap;(long,Map);;MapKey of Argument[1];MapKey of Argument[-1];value"
			PassiveExpiringMap out = null;
			Map in = Map.of((String)source(), null);
			out = new PassiveExpiringMap(0L, in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;PassiveExpiringMap;true;PassiveExpiringMap;(long,Map);;MapValue of Argument[1];MapValue of Argument[-1];value"
			PassiveExpiringMap out = null;
			Map in = Map.of(null, (String)source());
			out = new PassiveExpiringMap(0L, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;PassiveExpiringMap;true;PassiveExpiringMap;(long,TimeUnit,Map);;MapKey of Argument[2];MapKey of Argument[-1];value"
			PassiveExpiringMap out = null;
			Map in = Map.of((String)source(), null);
			out = new PassiveExpiringMap(0L, null, in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;PassiveExpiringMap;true;PassiveExpiringMap;(long,TimeUnit,Map);;MapValue of Argument[2];MapValue of Argument[-1];value"
			PassiveExpiringMap out = null;
			Map in = Map.of(null, (String)source());
			out = new PassiveExpiringMap(0L, null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;PredicatedMap;true;predicatedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			PredicatedMap out = null;
			Map in = Map.of((String)source(), null);
			out = PredicatedMap.predicatedMap(in, null, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;PredicatedMap;true;predicatedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			PredicatedMap out = null;
			Map in = Map.of(null, (String)source());
			out = PredicatedMap.predicatedMap(in, null, null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;PredicatedSortedMap;true;predicatedSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			PredicatedSortedMap out = null;
			SortedMap in = newTreeMapWithMapKey((String)source());
			out = PredicatedSortedMap.predicatedSortedMap(in, null, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;PredicatedSortedMap;true;predicatedSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			PredicatedSortedMap out = null;
			SortedMap in = newTreeMapWithMapValue((String)source());
			out = PredicatedSortedMap.predicatedSortedMap(in, null, null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;SingletonMap;true;SingletonMap;(Entry);;MapKey of Argument[0];MapKey of Argument[-1];value"
			SingletonMap out = null;
			Map.Entry in = newTMEWithMapKey((String)source());
			out = new SingletonMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;SingletonMap;true;SingletonMap;(Entry);;MapValue of Argument[0];MapValue of Argument[-1];value"
			SingletonMap out = null;
			Map.Entry in = newTMEWithMapValue((String)source());
			out = new SingletonMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;SingletonMap;true;SingletonMap;(KeyValue);;MapKey of Argument[0];MapKey of Argument[-1];value"
			SingletonMap out = null;
			KeyValue in = newDKVWithMapKey((String)source());
			out = new SingletonMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;SingletonMap;true;SingletonMap;(KeyValue);;MapValue of Argument[0];MapValue of Argument[-1];value"
			SingletonMap out = null;
			KeyValue in = newDKVWithMapValue((String)source());
			out = new SingletonMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;SingletonMap;true;SingletonMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			SingletonMap out = null;
			Map in = Map.of((String)source(), null);
			out = new SingletonMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;SingletonMap;true;SingletonMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value"
			SingletonMap out = null;
			Map in = Map.of(null, (String)source());
			out = new SingletonMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;SingletonMap;true;SingletonMap;(Object,Object);;Argument[0];MapKey of Argument[-1];value"
			SingletonMap out = null;
			Object in = source();
			out = new SingletonMap(in, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;SingletonMap;true;SingletonMap;(Object,Object);;Argument[1];MapValue of Argument[-1];value"
			SingletonMap out = null;
			Object in = source();
			out = new SingletonMap(null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;SingletonMap;true;setValue;;;Argument[0];MapValue of Argument[-1];value"
			SingletonMap out = null;
			Object in = source();
			out.setValue(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;TransformedMap;true;transformingMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			TransformedMap out = null;
			Map in = Map.of((String)source(), null);
			out = TransformedMap.transformingMap(in, null, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;TransformedMap;true;transformingMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			TransformedMap out = null;
			Map in = Map.of(null, (String)source());
			out = TransformedMap.transformingMap(in, null, null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;TransformedSortedMap;true;transformingSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			TransformedSortedMap out = null;
			SortedMap in = newTreeMapWithMapKey((String)source());
			out = TransformedSortedMap.transformingSortedMap(in, null, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;TransformedSortedMap;true;transformingSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			TransformedSortedMap out = null;
			SortedMap in = newTreeMapWithMapValue((String)source());
			out = TransformedSortedMap.transformingSortedMap(in, null, null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;UnmodifiableEntrySet;true;unmodifiableEntrySet;;;MapKey of Element of Argument[0];MapKey of Element of ReturnValue;value"
			Set<Map.Entry<String,String>> out = null;
			Set<Map.Entry<String,String>> in = newListOrderedSetWithElement(newTMEWithMapKey((String)source()));
			out = UnmodifiableEntrySet.unmodifiableEntrySet(in);
			sink(getMapKeyFromEntry(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;UnmodifiableEntrySet;true;unmodifiableEntrySet;;;MapValue of Element of Argument[0];MapValue of Element of ReturnValue;value"
			Set<Map.Entry<String,String>> out = null;
			Set<Map.Entry<String,String>> in = newListOrderedSetWithElement(newTMEWithMapValue((String)source()));
			out = UnmodifiableEntrySet.unmodifiableEntrySet(in);
			sink(getMapValueFromEntry(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;UnmodifiableMap;true;unmodifiableMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			Map out = null;
			Map in = Map.of((String)source(), null);
			out = UnmodifiableMap.unmodifiableMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;UnmodifiableMap;true;unmodifiableMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			Map out = null;
			Map in = Map.of(null, (String)source());
			out = UnmodifiableMap.unmodifiableMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;UnmodifiableOrderedMap;true;unmodifiableOrderedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			OrderedMap out = null;
			OrderedMap in = newListOrderedMapWithMapKey((String)source());
			out = UnmodifiableOrderedMap.unmodifiableOrderedMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;UnmodifiableOrderedMap;true;unmodifiableOrderedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			OrderedMap out = null;
			OrderedMap in = newListOrderedMapWithMapValue((String)source());
			out = UnmodifiableOrderedMap.unmodifiableOrderedMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;UnmodifiableSortedMap;true;unmodifiableSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			SortedMap out = null;
			SortedMap in = newTreeMapWithMapKey((String)source());
			out = UnmodifiableSortedMap.unmodifiableSortedMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;UnmodifiableSortedMap;true;unmodifiableSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			SortedMap out = null;
			SortedMap in = newTreeMapWithMapValue((String)source());
			out = UnmodifiableSortedMap.unmodifiableSortedMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multimap;ArrayListValuedHashMap;true;ArrayListValuedHashMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			ArrayListValuedHashMap out = null;
			Map in = Map.of((String)source(), null);
			out = new ArrayListValuedHashMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multimap;ArrayListValuedHashMap;true;ArrayListValuedHashMap;(Map);;MapValue of Argument[0];Element of MapValue of Argument[-1];value"
			ArrayListValuedHashMap out = null;
			Map in = Map.of(null, (String)source());
			out = new ArrayListValuedHashMap(in);
			sink(getElement(getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multimap;ArrayListValuedHashMap;true;ArrayListValuedHashMap;(MultiValuedMap);;Element of MapValue of Argument[0];Element of MapValue of Argument[-1];value"
			ArrayListValuedHashMap out = null;
			MultiValuedMap in = newALVHMWithMapValue((String)source());
			out = new ArrayListValuedHashMap(in);
			sink(getElement(getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multimap;ArrayListValuedHashMap;true;ArrayListValuedHashMap;(MultiValuedMap);;MapKey of Argument[0];MapKey of Argument[-1];value"
			ArrayListValuedHashMap out = null;
			MultiValuedMap in = newALVHMWithMapKey((String)source());
			out = new ArrayListValuedHashMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multimap;HashSetValuedHashMap;true;HashSetValuedHashMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			HashSetValuedHashMap out = null;
			Map in = Map.of((String)source(), null);
			out = new HashSetValuedHashMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multimap;HashSetValuedHashMap;true;HashSetValuedHashMap;(Map);;MapValue of Argument[0];Element of MapValue of Argument[-1];value"
			HashSetValuedHashMap out = null;
			Map in = Map.of(null, (String)source());
			out = new HashSetValuedHashMap(in);
			sink(getElement(getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multimap;HashSetValuedHashMap;true;HashSetValuedHashMap;(MultiValuedMap);;Element of MapValue of Argument[0];Element of MapValue of Argument[-1];value"
			HashSetValuedHashMap out = null;
			MultiValuedMap in = newALVHMWithMapValue((String)source());
			out = new HashSetValuedHashMap(in);
			sink(getElement(getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multimap;HashSetValuedHashMap;true;HashSetValuedHashMap;(MultiValuedMap);;MapKey of Argument[0];MapKey of Argument[-1];value"
			HashSetValuedHashMap out = null;
			MultiValuedMap in = newALVHMWithMapKey((String)source());
			out = new HashSetValuedHashMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multimap;TransformedMultiValuedMap;true;transformingMap;;;Element of MapValue of Argument[0];Element of MapValue of ReturnValue;value"
			TransformedMultiValuedMap out = null;
			MultiValuedMap in = newALVHMWithMapValue((String)source());
			out = TransformedMultiValuedMap.transformingMap(in, null, null);
			sink(getElement(getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multimap;TransformedMultiValuedMap;true;transformingMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			TransformedMultiValuedMap out = null;
			MultiValuedMap in = newALVHMWithMapKey((String)source());
			out = TransformedMultiValuedMap.transformingMap(in, null, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multimap;UnmodifiableMultiValuedMap;true;unmodifiableMultiValuedMap;(MultiValuedMap);;Element of MapValue of Argument[0];Element of MapValue of ReturnValue;value"
			UnmodifiableMultiValuedMap out = null;
			MultiValuedMap in = newALVHMWithMapValue((String)source());
			out = UnmodifiableMultiValuedMap.unmodifiableMultiValuedMap(in);
			sink(getElement(getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multimap;UnmodifiableMultiValuedMap;true;unmodifiableMultiValuedMap;(MultiValuedMap);;MapKey of Argument[0];MapKey of ReturnValue;value"
			UnmodifiableMultiValuedMap out = null;
			MultiValuedMap in = newALVHMWithMapKey((String)source());
			out = UnmodifiableMultiValuedMap.unmodifiableMultiValuedMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multiset;HashMultiSet;true;HashMultiSet;;;Element of Argument[0];Element of Argument[-1];value"
			HashMultiSet out = null;
			Collection in = newTreeBagWithElement((String)source());
			out = new HashMultiSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multiset;PredicatedMultiSet;true;predicatedMultiSet;;;Element of Argument[0];Element of ReturnValue;value"
			PredicatedMultiSet out = null;
			MultiSet in = newHashMultiSetWithElement((String)source());
			out = PredicatedMultiSet.predicatedMultiSet(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multiset;SynchronizedMultiSet;true;synchronizedMultiSet;;;Element of Argument[0];Element of ReturnValue;value"
			SynchronizedMultiSet out = null;
			MultiSet in = newHashMultiSetWithElement((String)source());
			out = SynchronizedMultiSet.synchronizedMultiSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multiset;UnmodifiableMultiSet;true;unmodifiableMultiSet;;;Element of Argument[0];Element of ReturnValue;value"
			MultiSet out = null;
			MultiSet in = newHashMultiSetWithElement((String)source());
			out = UnmodifiableMultiSet.unmodifiableMultiSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.properties;AbstractPropertiesFactory;true;load;(ClassLoader,String);;Argument[1];ReturnValue;taint"
			Properties out = null;
			String in = (String)source();
			AbstractPropertiesFactory instance = null;
			out = instance.load(null, in);
			sink(out); // $ hasTaintFlow
		}
		{
			// "org.apache.commons.collections4.properties;AbstractPropertiesFactory;true;load;(File);;Argument[0];ReturnValue;taint"
			Properties out = null;
			File in = (File)source();
			AbstractPropertiesFactory instance = null;
			out = instance.load(in);
			sink(out); // $ hasTaintFlow
		}
		{
			// "org.apache.commons.collections4.properties;AbstractPropertiesFactory;true;load;(InputStream);;Argument[0];ReturnValue;taint"
			Properties out = null;
			InputStream in = (InputStream)source();
			AbstractPropertiesFactory instance = null;
			out = instance.load(in);
			sink(out); // $ hasTaintFlow
		}
		{
			// "org.apache.commons.collections4.properties;AbstractPropertiesFactory;true;load;(Path);;Argument[0];ReturnValue;taint"
			Properties out = null;
			Path in = (Path)source();
			AbstractPropertiesFactory instance = null;
			out = instance.load(in);
			sink(out); // $ hasTaintFlow
		}
		{
			// "org.apache.commons.collections4.properties;AbstractPropertiesFactory;true;load;(Reader);;Argument[0];ReturnValue;taint"
			Properties out = null;
			Reader in = (Reader)source();
			AbstractPropertiesFactory instance = null;
			out = instance.load(in);
			sink(out); // $ hasTaintFlow
		}
		{
			// "org.apache.commons.collections4.properties;AbstractPropertiesFactory;true;load;(String);;Argument[0];ReturnValue;taint"
			Properties out = null;
			String in = (String)source();
			AbstractPropertiesFactory instance = null;
			out = instance.load(in);
			sink(out); // $ hasTaintFlow
		}
		{
			// "org.apache.commons.collections4.properties;AbstractPropertiesFactory;true;load;(URI);;Argument[0];ReturnValue;taint"
			Properties out = null;
			URI in = (URI)source();
			AbstractPropertiesFactory instance = null;
			out = instance.load(in);
			sink(out); // $ hasTaintFlow
		}
		{
			// "org.apache.commons.collections4.properties;AbstractPropertiesFactory;true;load;(URL);;Argument[0];ReturnValue;taint"
			Properties out = null;
			URL in = (URL)source();
			AbstractPropertiesFactory instance = null;
			out = instance.load(in);
			sink(out); // $ hasTaintFlow
		}
		{
			// "org.apache.commons.collections4.queue;CircularFifoQueue;true;CircularFifoQueue;(Collection);;Element of Argument[0];Element of Argument[-1];value"
			CircularFifoQueue out = null;
			Collection in = newTreeBagWithElement((String)source());
			out = new CircularFifoQueue(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.queue;CircularFifoQueue;true;get;;;Element of Argument[-1];ReturnValue;value"
			Object out = null;
			CircularFifoQueue in = newCircularFifoQueueWithElement((String)source());
			out = in.get(0);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.queue;PredicatedQueue;true;predicatedQueue;;;Element of Argument[0];Element of ReturnValue;value"
			PredicatedQueue out = null;
			Queue in = newCircularFifoQueueWithElement((String)source());
			out = PredicatedQueue.predicatedQueue(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.queue;SynchronizedQueue;true;synchronizedQueue;;;Element of Argument[0];Element of ReturnValue;value"
			SynchronizedQueue out = null;
			Queue in = newCircularFifoQueueWithElement((String)source());
			out = SynchronizedQueue.synchronizedQueue(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.queue;TransformedQueue;true;transformingQueue;;;Element of Argument[0];Element of ReturnValue;value"
			TransformedQueue out = null;
			Queue in = newCircularFifoQueueWithElement((String)source());
			out = TransformedQueue.transformingQueue(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.queue;UnmodifiableQueue;true;unmodifiableQueue;;;Element of Argument[0];Element of ReturnValue;value"
			Queue out = null;
			Queue in = newCircularFifoQueueWithElement((String)source());
			out = UnmodifiableQueue.unmodifiableQueue(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;AbstractNavigableSetDecorator;true;AbstractNavigableSetDecorator;;;Element of Argument[0];Element of Argument[-1];value"
			AbstractNavigableSetDecorator out = null;
			NavigableSet in = newTreeSetWithElement((String)source());
			out = new MyAbstractNavigableSetDecorator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;AbstractSetDecorator;true;AbstractSetDecorator;;;Element of Argument[0];Element of Argument[-1];value"
			AbstractSetDecorator out = null;
			Set in = newListOrderedSetWithElement((String)source());
			out = new MyAbstractSetDecorator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;AbstractSortedSetDecorator;true;AbstractSortedSetDecorator;;;Element of Argument[0];Element of Argument[-1];value"
			AbstractSortedSetDecorator out = null;
			Set in = newListOrderedSetWithElement((String)source());
			out = new MyAbstractSortedSetDecorator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;CompositeSet$SetMutator;true;add;;;Argument[2];Element of Argument[0];value"
			CompositeSet out = null;
			Object in = source();
			CompositeSet.SetMutator instance = null;
			instance.add(out, null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;CompositeSet$SetMutator;true;add;;;Argument[2];Element of Element of Argument[1];value"
			List<Set> out = null;
			Object in = source();
			CompositeSet.SetMutator instance = null;
			instance.add(null, out, in);
			sink(getElement(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;CompositeSet$SetMutator;true;addAll;;;Element of Argument[2];Element of Argument[0];value"
			CompositeSet out = null;
			Collection in = newTreeBagWithElement((String)source());
			CompositeSet.SetMutator instance = null;
			instance.addAll(out, null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;CompositeSet$SetMutator;true;addAll;;;Element of Argument[2];Element of Element of Argument[1];value"
			List<Set> out = null;
			Collection in = newTreeBagWithElement((String)source());
			CompositeSet.SetMutator instance = null;
			instance.addAll(null, out, in);
			sink(getElement(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;CompositeSet;true;CompositeSet;(Set);;Element of Argument[0];Element of Argument[-1];value"
			CompositeSet out = null;
			Set in = newListOrderedSetWithElement((String)source());
			out = new CompositeSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;CompositeSet;true;CompositeSet;(Set[]);;Element of ArrayElement of Argument[0];Element of Argument[-1];value"
			CompositeSet out = null;
			Set[] in = new Set[]{newListOrderedSetWithElement((String)source())};
			out = new CompositeSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;CompositeSet;true;addComposited;(Set);;Element of Argument[0];Element of Argument[-1];value"
			CompositeSet out = null;
			Set in = newListOrderedSetWithElement((String)source());
			out.addComposited(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;CompositeSet;true;addComposited;(Set,Set);;Element of Argument[0];Element of Argument[-1];value"
			CompositeSet out = null;
			Set in = newListOrderedSetWithElement((String)source());
			out.addComposited(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;CompositeSet;true;addComposited;(Set,Set);;Element of Argument[1];Element of Argument[-1];value"
			CompositeSet out = null;
			Set in = newListOrderedSetWithElement((String)source());
			out.addComposited(null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;CompositeSet;true;addComposited;(Set[]);;Element of ArrayElement of Argument[0];Element of Argument[-1];value"
			CompositeSet out = null;
			Set[] in = new Set[]{newListOrderedSetWithElement((String)source())};
			out.addComposited(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;CompositeSet;true;getSets;;;Element of Argument[-1];Element of Element of ReturnValue;value"
			List<Set<String>> out = null;
			CompositeSet<String> in = newCompositeSetWithElement((String)source());
			out = in.getSets();
			sink(getElement(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;CompositeSet;true;toSet;;;Element of Argument[-1];Element of ReturnValue;value"
			Set out = null;
			CompositeSet in = newCompositeSetWithElement((String)source());
			out = in.toSet();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;ListOrderedSet;true;add;;;Argument[1];Element of Argument[-1];value"
			ListOrderedSet out = null;
			Object in = source();
			out.add(0, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;ListOrderedSet;true;addAll;;;Element of Argument[1];Element of Argument[-1];value"
			ListOrderedSet out = null;
			Collection in = List.of((String)source());
			out.addAll(0, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;ListOrderedSet;true;asList;;;Element of Argument[-1];Element of ReturnValue;value"
			List out = null;
			ListOrderedSet in = newListOrderedSetWithElement((String)source());
			out = in.asList();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;ListOrderedSet;true;get;;;Element of Argument[-1];ReturnValue;value"
			Object out = null;
			ListOrderedSet in = newListOrderedSetWithElement((String)source());
			out = in.get(0);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;ListOrderedSet;true;listOrderedSet;(List);;Element of Argument[0];Element of ReturnValue;value"
			ListOrderedSet out = null;
			List in = List.of((String)source());
			out = ListOrderedSet.listOrderedSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;ListOrderedSet;true;listOrderedSet;(Set);;Element of Argument[0];Element of ReturnValue;value"
			ListOrderedSet out = null;
			Set in = newListOrderedSetWithElement((String)source());
			out = ListOrderedSet.listOrderedSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;MapBackedSet;true;mapBackedSet;;;MapKey of Argument[0];Element of ReturnValue;value"
			MapBackedSet out = null;
			Map in = Map.of((String)source(), null);
			out = MapBackedSet.mapBackedSet(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;MapBackedSet;true;mapBackedSet;;;MapKey of Argument[0];Element of ReturnValue;value"
			MapBackedSet out = null;
			Map in = Map.of((String)source(), null);
			out = MapBackedSet.mapBackedSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;PredicatedNavigableSet;true;predicatedNavigableSet;;;Element of Argument[0];Element of ReturnValue;value"
			PredicatedNavigableSet out = null;
			NavigableSet in = newTreeSetWithElement((String)source());
			out = PredicatedNavigableSet.predicatedNavigableSet(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;PredicatedSet;true;predicatedSet;;;Element of Argument[0];Element of ReturnValue;value"
			PredicatedSet out = null;
			Set in = newListOrderedSetWithElement((String)source());
			out = PredicatedSet.predicatedSet(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;PredicatedSortedSet;true;predicatedSortedSet;;;Element of Argument[0];Element of ReturnValue;value"
			PredicatedSortedSet out = null;
			SortedSet in = newTreeSetWithElement((String)source());
			out = PredicatedSortedSet.predicatedSortedSet(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;TransformedNavigableSet;true;transformingNavigableSet;;;Element of Argument[0];Element of ReturnValue;value"
			TransformedNavigableSet out = null;
			NavigableSet in = newTreeSetWithElement((String)source());
			out = TransformedNavigableSet.transformingNavigableSet(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;TransformedSet;true;transformingSet;;;Element of Argument[0];Element of ReturnValue;value"
			TransformedSet out = null;
			Set in = newListOrderedSetWithElement((String)source());
			out = TransformedSet.transformingSet(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;TransformedSortedSet;true;transformingSortedSet;;;Element of Argument[0];Element of ReturnValue;value"
			TransformedSortedSet out = null;
			SortedSet in = newTreeSetWithElement((String)source());
			out = TransformedSortedSet.transformingSortedSet(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;UnmodifiableNavigableSet;true;unmodifiableNavigableSet;;;Element of Argument[0];Element of ReturnValue;value"
			NavigableSet out = null;
			NavigableSet in = newTreeSetWithElement((String)source());
			out = UnmodifiableNavigableSet.unmodifiableNavigableSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;UnmodifiableSet;true;unmodifiableSet;;;Element of Argument[0];Element of ReturnValue;value"
			Set out = null;
			Set in = newListOrderedSetWithElement((String)source());
			out = UnmodifiableSet.unmodifiableSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;UnmodifiableSortedSet;true;unmodifiableSortedSet;;;Element of Argument[0];Element of ReturnValue;value"
			SortedSet out = null;
			SortedSet in = newTreeSetWithElement((String)source());
			out = UnmodifiableSortedSet.unmodifiableSortedSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.splitmap;AbstractIterableGetMapDecorator;true;AbstractIterableGetMapDecorator;;;MapKey of Argument[0];MapKey of Argument[-1];value"
			AbstractIterableGetMapDecorator out = null;
			Map in = Map.of((String)source(), null);
			out = new AbstractIterableGetMapDecorator(in);
			sink(getMapKeyFromGet(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.splitmap;AbstractIterableGetMapDecorator;true;AbstractIterableGetMapDecorator;;;MapValue of Argument[0];MapValue of Argument[-1];value"
			AbstractIterableGetMapDecorator out = null;
			Map in = Map.of(null, (String)source());
			out = new AbstractIterableGetMapDecorator(in);
			sink(getMapValueFromGet(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.splitmap;TransformedSplitMap;true;transformingMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			TransformedSplitMap out = null;
			Map in = Map.of((String)source(), null);
			out = TransformedSplitMap.transformingMap(in, null, null);
			sink(getMapKeyFromGet(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.splitmap;TransformedSplitMap;true;transformingMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			TransformedSplitMap out = null;
			Map in = Map.of(null, (String)source());
			out = TransformedSplitMap.transformingMap(in, null, null);
			sink(getMapValueFromGet(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.trie;PatriciaTrie;true;PatriciaTrie;;;MapKey of Argument[0];MapKey of Argument[-1];value"
			PatriciaTrie out = null;
			Map in = Map.of((String)source(), null);
			out = new PatriciaTrie(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.trie;PatriciaTrie;true;PatriciaTrie;;;MapValue of Argument[0];MapValue of Argument[-1];value"
			PatriciaTrie out = null;
			Map in = Map.of(null, (String)source());
			out = new PatriciaTrie(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.trie;AbstractPatriciaTrie;true;select;;;MapKey of Argument[-1];MapKey of ReturnValue;value"
			PatriciaTrie<Object> in = newPatriciaTrieWithMapKey((String)source());
			Map.Entry<String,Object> out = null;
			out = in.select(null);
			sink(getMapKeyFromEntry(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.trie;AbstractPatriciaTrie;true;select;;;MapValue of Argument[-1];MapValue of ReturnValue;value"
			PatriciaTrie<String> in = newPatriciaTrieWithMapValue((String)source());
			Map.Entry<String,String> out = null;
			out = in.select(null);
			sink(getMapValueFromEntry(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.trie;AbstractPatriciaTrie;true;selectKey;;;MapKey of Argument[-1];ReturnValue;value"
			PatriciaTrie<Object> in = newPatriciaTrieWithMapKey((String)source());
			String out = null;
			out = in.selectKey(null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.trie;AbstractPatriciaTrie;true;selectValue;;;MapValue of Argument[-1];ReturnValue;value"
			PatriciaTrie<String> in = newPatriciaTrieWithMapValue((String)source());
			String out = null;
			out = in.selectValue(null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.trie;UnmodifiableTrie;true;unmodifiableTrie;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			Trie out = null;
			Trie in = newPatriciaTrieWithMapKey((String)source());
			out = UnmodifiableTrie.unmodifiableTrie(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.trie;UnmodifiableTrie;true;unmodifiableTrie;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			Trie out = null;
			Trie in = newPatriciaTrieWithMapValue((String)source());
			out = UnmodifiableTrie.unmodifiableTrie(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}

	}

	class MyAbstractKeyValue<K, V> extends AbstractKeyValue<K, V> {
		MyAbstractKeyValue(K key, V value) {
			super(key, value);
		}

		K mySetKey(final K key) {
			return super.setKey(key);
		}

		V mySetValue(final V value) {
			return super.setValue(value);
		}
	}

	class MyAbstractMapEntry<K, V> extends AbstractMapEntry<K, V> {
		MyAbstractMapEntry(final K key, final V value) {
			super(key, value);
		}
		@Override
		public K getKey() { return null; }
		@Override
		public V getValue() { return null; }
	}

	class MyAbstractMapEntryDecorator<K, V> extends AbstractMapEntryDecorator<K, V> {
		MyAbstractMapEntryDecorator(final Map.Entry<K, V> entry) {
			super(entry);
		}

		Map.Entry<K, V> myGetMapEntry() {
			return super.getMapEntry();
		}
	}

	class MySetView<E> extends SetUtils.SetView<E> {
		MySetView() { super(); }

		@Override
		protected Iterator<E> createIterator() { return null; }

		Iterator<E> myCreateIterator() { return createIterator(); }
	}

	class MyAbstractSortedBidiMapDecorator<K, V> extends AbstractSortedBidiMapDecorator<K, V> {
		public MyAbstractSortedBidiMapDecorator(final SortedBidiMap<K, V> map) {
			super(map);
		}
	}

	class MyAbstractOrderedMapDecorator<K, V> extends AbstractOrderedMapDecorator<K, V> {
		public MyAbstractOrderedMapDecorator(final OrderedMap<K, V> map) {
			super(map);
		}
	}

	class MyAbstractSortedMapDecorator<K, V> extends AbstractSortedMapDecorator<K, V> {
		public MyAbstractSortedMapDecorator(final SortedMap<K, V> map) {
			super(map);
		}
	}

	class MyAbstractBagDecorator<E> extends AbstractBagDecorator<E> {
		public MyAbstractBagDecorator(final Bag<E> bag) {
			super(bag);
		}
	}

	class MyAbstractMapBag<E> extends AbstractMapBag<E> {
		public MyAbstractMapBag(final Map<E, MutableInteger> map) {
			super(map);
		}
		public Map<E, MutableInteger> myGetMap() {
			return super.getMap();
		}
	}

	class MyAbstractSortedBagDecorator<E> extends AbstractSortedBagDecorator<E> {
		public MyAbstractSortedBagDecorator(final SortedBag<E> bag) {
			super(bag);
		}
	}

	class MyAbstractBidiMapDecorator<K,V> extends AbstractBidiMapDecorator<K,V> {
		public MyAbstractBidiMapDecorator(final BidiMap<K, V> map) {
			super(map);
		}
	}

	class MyAbstractDualBidiMap<K,V> extends AbstractDualBidiMap<K,V> {
		public MyAbstractDualBidiMap(final Map<K, V> normalMap, final Map<V, K> reverseMap) {
			super(normalMap, reverseMap);
		}
		public MyAbstractDualBidiMap(final Map<K, V> normalMap, final Map<V, K> reverseMap, final BidiMap<V, K> inverseBidiMap) {
			super(normalMap, reverseMap, inverseBidiMap);
		}
		protected BidiMap<V, K> createBidiMap(Map<V, K> normalMap, Map<K, V> reverseMap, BidiMap<K, V> inverseMap) {
			return null;
		}
	}

	class MyAbstractOrderedBidiMapDecorator<K,V> extends AbstractOrderedBidiMapDecorator<K,V> {
		public MyAbstractOrderedBidiMapDecorator(final OrderedBidiMap<K, V> map) {
			super(map);
		}
	}

	class MyAbstractCollectionDecorator<E> extends AbstractCollectionDecorator<E> {
		public MyAbstractCollectionDecorator(final Collection<E> coll) {
			super(coll);
		}
		public Collection<E> myDecorated() {
			return super.decorated();
		}
		public void mySetCollection(final Collection<E> coll) {
			super.setCollection(coll);
		}
	}

	class MyAbstractIteratorDecorator<E> extends AbstractIteratorDecorator<E> {
		public MyAbstractIteratorDecorator(final Iterator<E> iterator) {
			super(iterator);
		}
	}

	class MyAbstractListIteratorDecorator<E> extends AbstractListIteratorDecorator<E> {
		public MyAbstractListIteratorDecorator(final ListIterator<E> iterator) {
			super(iterator);
		}
		public ListIterator<E> myGetListIterator() {
			return super.getListIterator();
		}
	}

	class MyAbstractMapIteratorDecorator<K,V> extends AbstractMapIteratorDecorator<K,V> {
		public MyAbstractMapIteratorDecorator(final MapIterator<K, V> iterator) {
			super(iterator);
		}
		public MapIterator<K, V> myGetMapIterator() {
			return super.getMapIterator();
		}
	}

	class MyAbstractOrderedMapIteratorDecorator<K,V> extends AbstractOrderedMapIteratorDecorator<K,V> {
		public MyAbstractOrderedMapIteratorDecorator(final OrderedMapIterator<K, V> iterator) {
			super(iterator);
		}
		public OrderedMapIterator<K, V> myGetOrderedMapIterator() {
			return super.getOrderedMapIterator();
		}
	}

	class MyAbstractUntypedIteratorDecorator<I,O> extends AbstractUntypedIteratorDecorator<I,O> {
		public MyAbstractUntypedIteratorDecorator(final Iterator<I> iterator) {
			super(iterator);
		}
		public Iterator<I> myGetIterator() {
			return super.getIterator();
		}
		public O next() { return null; }
	}

	class MyAbstractLinkedList<E> extends AbstractLinkedList<E> {
		public MyAbstractLinkedList(final Collection<? extends E> coll) {
			super(coll);
		}
	}

	class MyAbstractListDecorator<E> extends AbstractListDecorator<E> {
		public MyAbstractListDecorator(final List<E> list) {
			super(list);
		}
	}

	class MyAbstractSerializableListDecorator<E> extends AbstractSerializableListDecorator<E> {
		public MyAbstractSerializableListDecorator(final List<E> list) {
			super(list);
		}
	}

	class MyAbstractHashedMap<K,V> extends AbstractHashedMap<K,V> {
		public MyAbstractHashedMap(final Map<? extends K, ? extends V> map) {
			super(map);
		}
	}

	class MyAbstractLinkedMap<K,V> extends AbstractLinkedMap<K,V> {
		public MyAbstractLinkedMap(final Map<? extends K, ? extends V> map) {
			super(map);
		}
	}

	class MyAbstractMapDecorator<K,V> extends AbstractMapDecorator<K,V> {
		public MyAbstractMapDecorator(final Map<K, V> map) {
			super(map);
		}
		public Map<K, V> myDecorated() {
			return super.decorated();
		}
	}

	class MyAbstractNavigableSetDecorator<E> extends AbstractNavigableSetDecorator<E> {
		public MyAbstractNavigableSetDecorator(final NavigableSet<E> set) {
			super(set);
		}
	}

	class MyAbstractSetDecorator<E> extends AbstractSetDecorator<E> {
		public MyAbstractSetDecorator(final Set<E> set) {
			super(set);
		}
	}

	class MyAbstractSortedSetDecorator<E> extends AbstractSortedSetDecorator<E> {
		public MyAbstractSortedSetDecorator(final Set<E> set) {
			super(set);
		}
	}

}