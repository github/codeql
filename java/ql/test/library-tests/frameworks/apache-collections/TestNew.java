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
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import java.util.NavigableSet;
import java.util.Properties;
import java.util.Queue;
import java.util.Set;
import java.util.SortedMap;
import java.util.SortedSet;
import org.apache.commons.collections4.Bag;
import org.apache.commons.collections4.BidiMap;
import org.apache.commons.collections4.BoundedCollection;
import org.apache.commons.collections4.Factory;
import org.apache.commons.collections4.KeyValue;
import org.apache.commons.collections4.MapIterator;
import org.apache.commons.collections4.MultiSet;
import org.apache.commons.collections4.MultiValuedMap;
import org.apache.commons.collections4.OrderedBidiMap;
import org.apache.commons.collections4.OrderedMap;
import org.apache.commons.collections4.OrderedMapIterator;
import org.apache.commons.collections4.SortedBag;
import org.apache.commons.collections4.SortedBidiMap;
import org.apache.commons.collections4.Transformer;
import org.apache.commons.collections4.Trie;
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
import org.apache.commons.collections4.bidimap.AbstractSortedBidiMapDecorator;
import org.apache.commons.collections4.bidimap.DualHashBidiMap;
import org.apache.commons.collections4.bidimap.DualLinkedHashBidiMap;
import org.apache.commons.collections4.bidimap.DualTreeBidiMap;
import org.apache.commons.collections4.bidimap.TreeBidiMap;
import org.apache.commons.collections4.bidimap.UnmodifiableBidiMap;
import org.apache.commons.collections4.bidimap.UnmodifiableOrderedBidiMap;
import org.apache.commons.collections4.bidimap.UnmodifiableSortedBidiMap;
import org.apache.commons.collections4.collection.CompositeCollection;
import org.apache.commons.collections4.collection.IndexedCollection;
import org.apache.commons.collections4.collection.PredicatedCollection;
import org.apache.commons.collections4.collection.SynchronizedCollection;
import org.apache.commons.collections4.collection.TransformedCollection;
import org.apache.commons.collections4.collection.UnmodifiableBoundedCollection;
import org.apache.commons.collections4.collection.UnmodifiableCollection;
import org.apache.commons.collections4.iterators.AbstractListIteratorDecorator;
import org.apache.commons.collections4.iterators.AbstractMapIteratorDecorator;
import org.apache.commons.collections4.iterators.AbstractOrderedMapIteratorDecorator;
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
import org.apache.commons.collections4.keyvalue.MultiKey;
import org.apache.commons.collections4.list.AbstractLinkedList;
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
import org.apache.commons.collections4.map.LRUMap;
import org.apache.commons.collections4.map.LazyMap;
import org.apache.commons.collections4.map.LazySortedMap;
import org.apache.commons.collections4.map.LinkedMap;
import org.apache.commons.collections4.map.ListOrderedMap;
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
import org.apache.commons.collections4.multimap.ArrayListValuedHashMap;
import org.apache.commons.collections4.multimap.HashSetValuedHashMap;
import org.apache.commons.collections4.multimap.TransformedMultiValuedMap;
import org.apache.commons.collections4.multimap.UnmodifiableMultiValuedMap;
import org.apache.commons.collections4.multiset.HashMultiSet;
import org.apache.commons.collections4.multiset.PredicatedMultiSet;
import org.apache.commons.collections4.multiset.SynchronizedMultiSet;
import org.apache.commons.collections4.multiset.UnmodifiableMultiSet;
import org.apache.commons.collections4.properties.AbstractPropertiesFactory;
import org.apache.commons.collections4.queue.CircularFifoQueue;
import org.apache.commons.collections4.queue.PredicatedQueue;
import org.apache.commons.collections4.queue.SynchronizedQueue;
import org.apache.commons.collections4.queue.TransformedQueue;
import org.apache.commons.collections4.queue.UnmodifiableQueue;
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
import org.apache.commons.collections4.splitmap.AbstractIterableGetMapDecorator;
import org.apache.commons.collections4.splitmap.TransformedSplitMap;
import org.apache.commons.collections4.trie.PatriciaTrie;
import org.apache.commons.collections4.trie.UnmodifiableTrie;

// Test case generated by GenerateFlowTestCase.ql
public class TestNew {

	<K> K getMapKey(Map<K,?> map) { return map.keySet().iterator().next(); }
	<T> T getArrayElement(T[] array) { return array[0]; }
	<T> T getElement(Iterable<T> it) { return it.iterator().next(); }
	<T> T getElement(Iterator<T> it) { return it.next(); }
	<V> V getMapValue(Map<?,V> map) { return map.get(null); }
	Object getArrayElement(Object container) { return null; }
	Object getElement(Object container) { return null; }
	Object getMapKey(Object container) { return null; }
	Object getMapValue(Object container) { return null; }
	Object newWithArrayElement(Object element) { return null; }
	Object newWithElement(Object element) { return null; }
	Object newWithMapKey(Object element) { return null; }
	Object newWithMapValue(Object element) { return null; }
	Object source() { return null; }
	void sink(Object o) { }

	public void test() throws Exception {

		{
			// "org.apache.commons.collections4.bag;CollectionBag;true;CollectionBag;;;Element of Argument[0];Element of Argument[-1];value"
			CollectionBag out = null;
			Bag in = (Bag)newWithElement(source());
			out = new CollectionBag(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;CollectionBag;true;collectionBag;;;Element of Argument[0];Element of ReturnValue;value"
			Bag out = null;
			Bag in = (Bag)newWithElement(source());
			out = CollectionBag.collectionBag(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;CollectionSortedBag;true;CollectionSortedBag;;;Element of Argument[0];Element of Argument[-1];value"
			CollectionSortedBag out = null;
			SortedBag in = (SortedBag)newWithElement(source());
			out = new CollectionSortedBag(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;CollectionSortedBag;true;collectionSortedBag;;;Element of Argument[0];Element of ReturnValue;value"
			SortedBag out = null;
			SortedBag in = (SortedBag)newWithElement(source());
			out = CollectionSortedBag.collectionSortedBag(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;HashBag;true;HashBag;;;Element of Argument[0];Element of Argument[-1];value"
			HashBag out = null;
			Collection in = (Collection)newWithElement(source());
			out = new HashBag(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;PredicatedBag;true;predicatedBag;;;Element of Argument[0];Element of ReturnValue;value"
			PredicatedBag out = null;
			Bag in = (Bag)newWithElement(source());
			out = PredicatedBag.predicatedBag(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;PredicatedSortedBag;true;predicatedSortedBag;;;Element of Argument[0];Element of ReturnValue;value"
			PredicatedSortedBag out = null;
			SortedBag in = (SortedBag)newWithElement(source());
			out = PredicatedSortedBag.predicatedSortedBag(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;SynchronizedBag;true;synchronizedBag;;;Element of Argument[0];Element of ReturnValue;value"
			SynchronizedBag out = null;
			Bag in = (Bag)newWithElement(source());
			out = SynchronizedBag.synchronizedBag(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;SynchronizedSortedBag;true;synchronizedSortedBag;;;Element of Argument[0];Element of ReturnValue;value"
			SynchronizedSortedBag out = null;
			SortedBag in = (SortedBag)newWithElement(source());
			out = SynchronizedSortedBag.synchronizedSortedBag(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;TransformedBag;true;transformedBag;;;Element of Argument[0];Element of ReturnValue;value"
			Bag out = null;
			Bag in = (Bag)newWithElement(source());
			out = TransformedBag.transformedBag(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;TransformedSortedBag;true;transformedSortedBag;;;Element of Argument[0];Element of ReturnValue;value"
			TransformedSortedBag out = null;
			SortedBag in = (SortedBag)newWithElement(source());
			out = TransformedSortedBag.transformedSortedBag(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;TreeBag;true;TreeBag;(Collection);;Element of Argument[0];Element of Argument[-1];value"
			TreeBag out = null;
			Collection in = (Collection)newWithElement(source());
			out = new TreeBag(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;UnmodifiableBag;true;unmodifiableBag;;;Element of Argument[0];Element of ReturnValue;value"
			Bag out = null;
			Bag in = (Bag)newWithElement(source());
			out = UnmodifiableBag.unmodifiableBag(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bag;UnmodifiableSortedBag;true;unmodifiableSortedBag;;;Element of Argument[0];Element of ReturnValue;value"
			SortedBag out = null;
			SortedBag in = (SortedBag)newWithElement(source());
			out = UnmodifiableSortedBag.unmodifiableSortedBag(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;AbstractSortedBidiMapDecorator;true;AbstractSortedBidiMapDecorator;;;MapKey of Argument[0];MapKey of Argument[-1];value"
			AbstractSortedBidiMapDecorator out = null;
			SortedBidiMap in = (SortedBidiMap)newWithMapKey(source());
			out = new AbstractSortedBidiMapDecorator(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;AbstractSortedBidiMapDecorator;true;AbstractSortedBidiMapDecorator;;;MapValue of Argument[0];MapValue of Argument[-1];value"
			AbstractSortedBidiMapDecorator out = null;
			SortedBidiMap in = (SortedBidiMap)newWithMapValue(source());
			out = new AbstractSortedBidiMapDecorator(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;DualHashBidiMap;true;DualHashBidiMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			DualHashBidiMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = new DualHashBidiMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;DualHashBidiMap;true;DualHashBidiMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value"
			DualHashBidiMap out = null;
			Map in = (Map)Map.of(null, source());
			out = new DualHashBidiMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;DualLinkedHashBidiMap;true;DualLinkedHashBidiMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			DualLinkedHashBidiMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = new DualLinkedHashBidiMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;DualLinkedHashBidiMap;true;DualLinkedHashBidiMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value"
			DualLinkedHashBidiMap out = null;
			Map in = (Map)Map.of(null, source());
			out = new DualLinkedHashBidiMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;DualTreeBidiMap;true;DualTreeBidiMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			DualTreeBidiMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = new DualTreeBidiMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;DualTreeBidiMap;true;DualTreeBidiMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value"
			DualTreeBidiMap out = null;
			Map in = (Map)Map.of(null, source());
			out = new DualTreeBidiMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;DualTreeBidiMap;true;inverseOrderedBidiMap;;;MapKey of Argument[-1];MapValue of ReturnValue;value"
			OrderedBidiMap out = null;
			DualTreeBidiMap in = (DualTreeBidiMap)newWithMapKey(source());
			out = in.inverseOrderedBidiMap();
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;DualTreeBidiMap;true;inverseOrderedBidiMap;;;MapValue of Argument[-1];MapKey of ReturnValue;value"
			OrderedBidiMap out = null;
			DualTreeBidiMap in = (DualTreeBidiMap)newWithMapValue(source());
			out = in.inverseOrderedBidiMap();
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;DualTreeBidiMap;true;inverseSortedBidiMap;;;MapKey of Argument[-1];MapValue of ReturnValue;value"
			SortedBidiMap out = null;
			DualTreeBidiMap in = (DualTreeBidiMap)newWithMapKey(source());
			out = in.inverseSortedBidiMap();
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;DualTreeBidiMap;true;inverseSortedBidiMap;;;MapValue of Argument[-1];MapKey of ReturnValue;value"
			SortedBidiMap out = null;
			DualTreeBidiMap in = (DualTreeBidiMap)newWithMapValue(source());
			out = in.inverseSortedBidiMap();
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;TreeBidiMap;true;TreeBidiMap;;;MapKey of Argument[0];MapKey of Argument[-1];value"
			TreeBidiMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = new TreeBidiMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;TreeBidiMap;true;TreeBidiMap;;;MapValue of Argument[0];MapValue of Argument[-1];value"
			TreeBidiMap out = null;
			Map in = (Map)Map.of(null, source());
			out = new TreeBidiMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;UnmodifiableBidiMap;true;unmodifiableBidiMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			BidiMap out = null;
			BidiMap in = (BidiMap)newWithMapKey(source());
			out = UnmodifiableBidiMap.unmodifiableBidiMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;UnmodifiableBidiMap;true;unmodifiableBidiMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			BidiMap out = null;
			BidiMap in = (BidiMap)newWithMapValue(source());
			out = UnmodifiableBidiMap.unmodifiableBidiMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;UnmodifiableOrderedBidiMap;true;inverseOrderedBidiMap;;;MapKey of Argument[-1];MapValue of ReturnValue;value"
			OrderedBidiMap out = null;
			UnmodifiableOrderedBidiMap in = (UnmodifiableOrderedBidiMap)newWithMapKey(source());
			out = in.inverseOrderedBidiMap();
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;UnmodifiableOrderedBidiMap;true;inverseOrderedBidiMap;;;MapValue of Argument[-1];MapKey of ReturnValue;value"
			OrderedBidiMap out = null;
			UnmodifiableOrderedBidiMap in = (UnmodifiableOrderedBidiMap)newWithMapValue(source());
			out = in.inverseOrderedBidiMap();
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;UnmodifiableOrderedBidiMap;true;unmodifiableOrderedBidiMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			OrderedBidiMap out = null;
			OrderedBidiMap in = (OrderedBidiMap)newWithMapKey(source());
			out = UnmodifiableOrderedBidiMap.unmodifiableOrderedBidiMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;UnmodifiableOrderedBidiMap;true;unmodifiableOrderedBidiMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			OrderedBidiMap out = null;
			OrderedBidiMap in = (OrderedBidiMap)newWithMapValue(source());
			out = UnmodifiableOrderedBidiMap.unmodifiableOrderedBidiMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;UnmodifiableSortedBidiMap;true;unmodifiableSortedBidiMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			SortedBidiMap out = null;
			SortedBidiMap in = (SortedBidiMap)newWithMapKey(source());
			out = UnmodifiableSortedBidiMap.unmodifiableSortedBidiMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.bidimap;UnmodifiableSortedBidiMap;true;unmodifiableSortedBidiMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			SortedBidiMap out = null;
			SortedBidiMap in = (SortedBidiMap)newWithMapValue(source());
			out = UnmodifiableSortedBidiMap.unmodifiableSortedBidiMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;CompositeCollection$CollectionMutator;true;add;;;Argument[2];Element of Argument[0];value"
			CompositeCollection out = null;
			Object in = (Object)source();
			CompositeCollection.CollectionMutator instance = null;
			instance.add(out, null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;CompositeCollection$CollectionMutator;true;add;;;Argument[2];Element of Element of Argument[1];value"
			List out = null;
			Object in = (Object)source();
			CompositeCollection.CollectionMutator instance = null;
			instance.add(null, out, in);
			sink(getElement(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;CompositeCollection$CollectionMutator;true;addAll;;;Element of Argument[2];Element of Argument[0];value"
			CompositeCollection out = null;
			Collection in = (Collection)newWithElement(source());
			CompositeCollection.CollectionMutator instance = null;
			instance.addAll(out, null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;CompositeCollection$CollectionMutator;true;addAll;;;Element of Argument[2];Element of Element of Argument[1];value"
			List out = null;
			Collection in = (Collection)newWithElement(source());
			CompositeCollection.CollectionMutator instance = null;
			instance.addAll(null, out, in);
			sink(getElement(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;CompositeCollection;true;CompositeCollection;(Collection);;Element of Argument[0];Element of Argument[-1];value"
			CompositeCollection out = null;
			Collection in = (Collection)newWithElement(source());
			out = new CompositeCollection(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;CompositeCollection;true;CompositeCollection;(Collection,Collection);;Element of Argument[0];Element of Argument[-1];value"
			CompositeCollection out = null;
			Collection in = (Collection)newWithElement(source());
			out = new CompositeCollection(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;CompositeCollection;true;CompositeCollection;(Collection,Collection);;Element of Argument[1];Element of Argument[-1];value"
			CompositeCollection out = null;
			Collection in = (Collection)newWithElement(source());
			out = new CompositeCollection(null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;CompositeCollection;true;CompositeCollection;(Collection[]);;Element of ArrayElement of Argument[0];Element of Argument[-1];value"
			CompositeCollection out = null;
			Collection[] in = (Collection[])new Collection[]{(Collection)newWithElement(source())};
			out = new CompositeCollection(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;CompositeCollection;true;addComposited;(Collection);;Element of Argument[0];Element of Argument[-1];value"
			CompositeCollection out = null;
			Collection in = (Collection)newWithElement(source());
			out.addComposited(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;CompositeCollection;true;addComposited;(Collection,Collection);;Element of Argument[0];Element of Argument[-1];value"
			CompositeCollection out = null;
			Collection in = (Collection)newWithElement(source());
			out.addComposited(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;CompositeCollection;true;addComposited;(Collection,Collection);;Element of Argument[1];Element of Argument[-1];value"
			CompositeCollection out = null;
			Collection in = (Collection)newWithElement(source());
			out.addComposited(null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;CompositeCollection;true;addComposited;(Collection[]);;Element of ArrayElement of Argument[0];Element of Argument[-1];value"
			CompositeCollection out = null;
			Collection[] in = (Collection[])new Collection[]{(Collection)newWithElement(source())};
			out.addComposited(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;CompositeCollection;true;getCollections;;;Element of Argument[-1];Element of Element of ReturnValue;value"
			List out = null;
			CompositeCollection in = (CompositeCollection)newWithElement(source());
			out = in.getCollections();
			sink(getElement(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;CompositeCollection;true;toCollection;;;Element of Argument[-1];Element of ReturnValue;value"
			Collection out = null;
			CompositeCollection in = (CompositeCollection)newWithElement(source());
			out = in.toCollection();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;IndexedCollection;true;IndexedCollection;;;Element of Argument[0];Element of Argument[-1];value"
			IndexedCollection out = null;
			Collection in = (Collection)newWithElement(source());
			out = new IndexedCollection(in, null, null, false);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;IndexedCollection;true;get;;;Element of Argument[-1];ReturnValue;value"
			Object out = null;
			IndexedCollection in = (IndexedCollection)newWithElement(source());
			out = in.get(null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;IndexedCollection;true;nonUniqueIndexedCollection;;;Element of Argument[0];Element of ReturnValue;value"
			IndexedCollection out = null;
			Collection in = (Collection)newWithElement(source());
			out = IndexedCollection.nonUniqueIndexedCollection(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;IndexedCollection;true;uniqueIndexedCollection;;;Element of Argument[0];Element of ReturnValue;value"
			IndexedCollection out = null;
			Collection in = (Collection)newWithElement(source());
			out = IndexedCollection.uniqueIndexedCollection(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;IndexedCollection;true;values;;;Element of Argument[-1];Element of ReturnValue;value"
			Collection out = null;
			IndexedCollection in = (IndexedCollection)newWithElement(source());
			out = in.values(null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;add;;;Argument[0];Element of Argument[-1];value"
			PredicatedCollection.Builder out = null;
			Object in = (Object)source();
			out.add(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;addAll;;;Element of Argument[0];Element of Argument[-1];value"
			PredicatedCollection.Builder out = null;
			Collection in = (Collection)List.of(source());
			out.addAll(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;createPredicatedBag;;;Element of Argument[-1];Element of ReturnValue;value"
			Bag out = null;
			PredicatedCollection.Builder in = (PredicatedCollection.Builder)newWithElement(source());
			out = in.createPredicatedBag(null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;createPredicatedBag;;;Element of Argument[-1];Element of ReturnValue;value"
			Bag out = null;
			PredicatedCollection.Builder in = (PredicatedCollection.Builder)newWithElement(source());
			out = in.createPredicatedBag();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;createPredicatedBag;;;Element of Argument[0];Element of ReturnValue;value"
			Bag out = null;
			Bag in = (Bag)newWithElement(source());
			PredicatedCollection.Builder instance = null;
			out = instance.createPredicatedBag(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;createPredicatedList;;;Element of Argument[-1];Element of ReturnValue;value"
			List out = null;
			PredicatedCollection.Builder in = (PredicatedCollection.Builder)newWithElement(source());
			out = in.createPredicatedList(null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;createPredicatedList;;;Element of Argument[-1];Element of ReturnValue;value"
			List out = null;
			PredicatedCollection.Builder in = (PredicatedCollection.Builder)newWithElement(source());
			out = in.createPredicatedList();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;createPredicatedList;;;Element of Argument[0];Element of ReturnValue;value"
			List out = null;
			List in = (List)List.of(source());
			PredicatedCollection.Builder instance = null;
			out = instance.createPredicatedList(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;createPredicatedMultiSet;;;Element of Argument[-1];Element of ReturnValue;value"
			MultiSet out = null;
			PredicatedCollection.Builder in = (PredicatedCollection.Builder)newWithElement(source());
			out = in.createPredicatedMultiSet(null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;createPredicatedMultiSet;;;Element of Argument[-1];Element of ReturnValue;value"
			MultiSet out = null;
			PredicatedCollection.Builder in = (PredicatedCollection.Builder)newWithElement(source());
			out = in.createPredicatedMultiSet();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;createPredicatedMultiSet;;;Element of Argument[0];Element of ReturnValue;value"
			MultiSet out = null;
			MultiSet in = (MultiSet)newWithElement(source());
			PredicatedCollection.Builder instance = null;
			out = instance.createPredicatedMultiSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;createPredicatedQueue;;;Element of Argument[-1];Element of ReturnValue;value"
			Queue out = null;
			PredicatedCollection.Builder in = (PredicatedCollection.Builder)newWithElement(source());
			out = in.createPredicatedQueue(null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;createPredicatedQueue;;;Element of Argument[-1];Element of ReturnValue;value"
			Queue out = null;
			PredicatedCollection.Builder in = (PredicatedCollection.Builder)newWithElement(source());
			out = in.createPredicatedQueue();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;createPredicatedQueue;;;Element of Argument[0];Element of ReturnValue;value"
			Queue out = null;
			Queue in = (Queue)newWithElement(source());
			PredicatedCollection.Builder instance = null;
			out = instance.createPredicatedQueue(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;createPredicatedSet;;;Element of Argument[-1];Element of ReturnValue;value"
			Set out = null;
			PredicatedCollection.Builder in = (PredicatedCollection.Builder)newWithElement(source());
			out = in.createPredicatedSet(null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;createPredicatedSet;;;Element of Argument[-1];Element of ReturnValue;value"
			Set out = null;
			PredicatedCollection.Builder in = (PredicatedCollection.Builder)newWithElement(source());
			out = in.createPredicatedSet();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;createPredicatedSet;;;Element of Argument[0];Element of ReturnValue;value"
			Set out = null;
			Set in = (Set)newWithElement(source());
			PredicatedCollection.Builder instance = null;
			out = instance.createPredicatedSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection$Builder;true;rejectedElements;;;Element of Argument[-1];Element of ReturnValue;value"
			Collection out = null;
			PredicatedCollection.Builder in = (PredicatedCollection.Builder)newWithElement(source());
			out = in.rejectedElements();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;PredicatedCollection;true;predicatedCollection;;;Element of Argument[0];Element of ReturnValue;value"
			PredicatedCollection out = null;
			Collection in = (Collection)newWithElement(source());
			out = PredicatedCollection.predicatedCollection(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;SynchronizedCollection;true;synchronizedCollection;;;Element of Argument[0];Element of ReturnValue;value"
			SynchronizedCollection out = null;
			Collection in = (Collection)newWithElement(source());
			out = SynchronizedCollection.synchronizedCollection(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;TransformedCollection;true;transformingCollection;;;Element of Argument[0];Element of ReturnValue;value"
			TransformedCollection out = null;
			Collection in = (Collection)newWithElement(source());
			out = TransformedCollection.transformingCollection(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;UnmodifiableBoundedCollection;true;unmodifiableBoundedCollection;;;Element of Argument[0];Element of ReturnValue;value"
			BoundedCollection out = null;
			Collection in = (Collection)newWithElement(source());
			out = UnmodifiableBoundedCollection.unmodifiableBoundedCollection(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;UnmodifiableBoundedCollection;true;unmodifiableBoundedCollection;;;Element of Argument[0];Element of ReturnValue;value"
			BoundedCollection out = null;
			BoundedCollection in = (BoundedCollection)newWithElement(source());
			out = UnmodifiableBoundedCollection.unmodifiableBoundedCollection(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.collection;UnmodifiableCollection;true;unmodifiableCollection;;;Element of Argument[0];Element of ReturnValue;value"
			Collection out = null;
			Collection in = (Collection)newWithElement(source());
			out = UnmodifiableCollection.unmodifiableCollection(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;AbstractListIteratorDecorator;true;AbstractListIteratorDecorator;;;Element of Argument[0];Element of Argument[-1];value"
			AbstractListIteratorDecorator out = null;
			ListIterator in = (ListIterator)newWithElement(source());
			out = new AbstractListIteratorDecorator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;AbstractMapIteratorDecorator;true;AbstractMapIteratorDecorator;;;Element of Argument[0];Element of Argument[-1];value"
			AbstractMapIteratorDecorator out = null;
			MapIterator in = (MapIterator)newWithElement(source());
			out = new AbstractMapIteratorDecorator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;AbstractMapIteratorDecorator;true;AbstractMapIteratorDecorator;;;MapValue of Argument[0];MapValue of Argument[-1];value"
			AbstractMapIteratorDecorator out = null;
			MapIterator in = (MapIterator)newWithMapValue(source());
			out = new AbstractMapIteratorDecorator(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;AbstractOrderedMapIteratorDecorator;true;AbstractOrderedMapIteratorDecorator;;;Element of Argument[0];Element of Argument[-1];value"
			AbstractOrderedMapIteratorDecorator out = null;
			OrderedMapIterator in = (OrderedMapIterator)newWithElement(source());
			out = new AbstractOrderedMapIteratorDecorator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;AbstractOrderedMapIteratorDecorator;true;AbstractOrderedMapIteratorDecorator;;;MapValue of Argument[0];MapValue of Argument[-1];value"
			AbstractOrderedMapIteratorDecorator out = null;
			OrderedMapIterator in = (OrderedMapIterator)newWithMapValue(source());
			out = new AbstractOrderedMapIteratorDecorator(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ArrayIterator;true;ArrayIterator;;;ArrayElement of Argument[0];Element of Argument[-1];value"
			ArrayIterator out = null;
			Object in = (Object)newWithArrayElement(source());
			out = new ArrayIterator(in, 0, 0);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ArrayIterator;true;ArrayIterator;;;ArrayElement of Argument[0];Element of Argument[-1];value"
			ArrayIterator out = null;
			Object in = (Object)newWithArrayElement(source());
			out = new ArrayIterator(in, 0);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ArrayIterator;true;ArrayIterator;;;ArrayElement of Argument[0];Element of Argument[-1];value"
			ArrayIterator out = null;
			Object in = (Object)newWithArrayElement(source());
			out = new ArrayIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ArrayIterator;true;getArray;;;Element of Argument[-1];ArrayElement of ReturnValue;value"
			Object out = null;
			ArrayIterator in = (ArrayIterator)newWithElement(source());
			out = in.getArray();
			sink(getArrayElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ArrayListIterator;true;ArrayListIterator;;;ArrayElement of Argument[0];Element of Argument[-1];value"
			ArrayListIterator out = null;
			Object in = (Object)newWithArrayElement(source());
			out = new ArrayListIterator(in, 0, 0);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ArrayListIterator;true;ArrayListIterator;;;ArrayElement of Argument[0];Element of Argument[-1];value"
			ArrayListIterator out = null;
			Object in = (Object)newWithArrayElement(source());
			out = new ArrayListIterator(in, 0);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ArrayListIterator;true;ArrayListIterator;;;ArrayElement of Argument[0];Element of Argument[-1];value"
			ArrayListIterator out = null;
			Object in = (Object)newWithArrayElement(source());
			out = new ArrayListIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;BoundedIterator;true;BoundedIterator;;;Element of Argument[0];Element of Argument[-1];value"
			BoundedIterator out = null;
			Iterator in = (Iterator)newWithElement(source());
			out = new BoundedIterator(in, 0L, 0L);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;CollatingIterator;true;CollatingIterator;(Comparator,Collection);;Element of Element of Argument[1];Element of Argument[-1];value"
			CollatingIterator out = null;
			Collection in = (Collection)List.of(newWithElement(source()));
			out = new CollatingIterator((Comparator)null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;CollatingIterator;true;CollatingIterator;(Comparator,Iterator,Iterator);;Element of Argument[1];Element of Argument[-1];value"
			CollatingIterator out = null;
			Iterator in = (Iterator)newWithElement(source());
			out = new CollatingIterator(null, in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;CollatingIterator;true;CollatingIterator;(Comparator,Iterator,Iterator);;Element of Argument[2];Element of Argument[-1];value"
			CollatingIterator out = null;
			Iterator in = (Iterator)newWithElement(source());
			out = new CollatingIterator(null, null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;CollatingIterator;true;CollatingIterator;(Comparator,Iterator[]);;Element of ArrayElement of Argument[1];Element of Argument[-1];value"
			CollatingIterator out = null;
			Iterator[] in = (Iterator[])new Iterator[]{(Iterator)newWithElement(source())};
			out = new CollatingIterator((Comparator)null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;CollatingIterator;true;addIterator;;;Element of Argument[0];Element of Argument[-1];value"
			CollatingIterator out = null;
			Iterator in = (Iterator)newWithElement(source());
			out.addIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;CollatingIterator;true;getIterators;;;Element of Argument[-1];Element of Element of ReturnValue;value"
			List out = null;
			CollatingIterator in = (CollatingIterator)newWithElement(source());
			out = in.getIterators();
			sink(getElement(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;CollatingIterator;true;setIterator;;;Element of Argument[1];Element of Argument[-1];value"
			CollatingIterator out = null;
			Iterator in = (Iterator)newWithElement(source());
			out.setIterator(0, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;EnumerationIterator;true;EnumerationIterator;;;Element of Argument[0];Element of Argument[-1];value"
			EnumerationIterator out = null;
			Enumeration in = (Enumeration)newWithElement(source());
			out = new EnumerationIterator(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;EnumerationIterator;true;EnumerationIterator;;;Element of Argument[0];Element of Argument[-1];value"
			EnumerationIterator out = null;
			Enumeration in = (Enumeration)newWithElement(source());
			out = new EnumerationIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;EnumerationIterator;true;getEnumeration;;;Element of Argument[-1];Element of ReturnValue;value"
			Enumeration out = null;
			EnumerationIterator in = (EnumerationIterator)newWithElement(source());
			out = in.getEnumeration();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;EnumerationIterator;true;setEnumeration;;;Element of Argument[0];Element of Argument[-1];value"
			EnumerationIterator out = null;
			Enumeration in = (Enumeration)newWithElement(source());
			out.setEnumeration(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;FilterIterator;true;FilterIterator;;;Element of Argument[0];Element of Argument[-1];value"
			FilterIterator out = null;
			Iterator in = (Iterator)newWithElement(source());
			out = new FilterIterator(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;FilterIterator;true;FilterIterator;;;Element of Argument[0];Element of Argument[-1];value"
			FilterIterator out = null;
			Iterator in = (Iterator)newWithElement(source());
			out = new FilterIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;FilterIterator;true;getIterator;;;Element of Argument[-1];Element of ReturnValue;value"
			Iterator out = null;
			FilterIterator in = (FilterIterator)newWithElement(source());
			out = in.getIterator();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;FilterIterator;true;setIterator;;;Element of Argument[0];Element of Argument[-1];value"
			FilterIterator out = null;
			Iterator in = (Iterator)newWithElement(source());
			out.setIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;FilterListIterator;true;FilterListIterator;(ListIterator);;Element of Argument[0];Element of Argument[-1];value"
			FilterListIterator out = null;
			ListIterator in = (ListIterator)newWithElement(source());
			out = new FilterListIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;FilterListIterator;true;FilterListIterator;(ListIterator,Predicate);;Element of Argument[0];Element of Argument[-1];value"
			FilterListIterator out = null;
			ListIterator in = (ListIterator)newWithElement(source());
			out = new FilterListIterator(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;FilterListIterator;true;getListIterator;;;Element of Argument[-1];Element of ReturnValue;value"
			ListIterator out = null;
			FilterListIterator in = (FilterListIterator)newWithElement(source());
			out = in.getListIterator();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;FilterListIterator;true;setListIterator;;;Element of Argument[0];Element of Argument[-1];value"
			FilterListIterator out = null;
			ListIterator in = (ListIterator)newWithElement(source());
			out.setListIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;IteratorChain;true;IteratorChain;(Collection);;Element of Element of Argument[0];Element of Argument[-1];value"
			IteratorChain out = null;
			Collection in = (Collection)newWithElement(newWithElement(source()));
			out = new IteratorChain(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;IteratorChain;true;IteratorChain;(Iterator);;Element of Argument[0];Element of Argument[-1];value"
			IteratorChain out = null;
			Iterator in = (Iterator)newWithElement(source());
			out = new IteratorChain(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;IteratorChain;true;IteratorChain;(Iterator,Iterator);;Element of Argument[0];Element of Argument[-1];value"
			IteratorChain out = null;
			Iterator in = (Iterator)newWithElement(source());
			out = new IteratorChain(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;IteratorChain;true;IteratorChain;(Iterator,Iterator);;Element of Argument[1];Element of Argument[-1];value"
			IteratorChain out = null;
			Iterator in = (Iterator)newWithElement(source());
			out = new IteratorChain(null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;IteratorChain;true;IteratorChain;(Iterator[]);;Element of ArrayElement of Argument[0];Element of Argument[-1];value"
			IteratorChain out = null;
			Iterator[] in = (Iterator[])new Iterator[]{(Iterator)newWithElement(source())};
			out = new IteratorChain(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;IteratorChain;true;addIterator;;;Element of Argument[0];Element of Argument[-1];value"
			IteratorChain out = null;
			Iterator in = (Iterator)newWithElement(source());
			out.addIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;IteratorEnumeration;true;IteratorEnumeration;;;Element of Argument[0];Element of Argument[-1];value"
			IteratorEnumeration out = null;
			Iterator in = (Iterator)newWithElement(source());
			out = new IteratorEnumeration(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;IteratorEnumeration;true;getIterator;;;Element of Argument[-1];Element of ReturnValue;value"
			Iterator out = null;
			IteratorEnumeration in = (IteratorEnumeration)newWithElement(source());
			out = in.getIterator();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;IteratorEnumeration;true;setIterator;;;Element of Argument[0];Element of Argument[-1];value"
			IteratorEnumeration out = null;
			Iterator in = (Iterator)newWithElement(source());
			out.setIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;IteratorIterable;true;IteratorIterable;;;Element of Argument[0];Element of Argument[-1];value"
			IteratorIterable out = null;
			Iterator in = (Iterator)newWithElement(source());
			out = new IteratorIterable(in, false);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;IteratorIterable;true;IteratorIterable;;;Element of Argument[0];Element of Argument[-1];value"
			IteratorIterable out = null;
			Iterator in = (Iterator)newWithElement(source());
			out = new IteratorIterable(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ListIteratorWrapper;true;ListIteratorWrapper;;;Element of Argument[0];Element of Argument[-1];value"
			ListIteratorWrapper out = null;
			Iterator in = (Iterator)newWithElement(source());
			out = new ListIteratorWrapper(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;LoopingIterator;true;LoopingIterator;;;Element of Argument[0];Element of Argument[-1];value"
			LoopingIterator out = null;
			Collection in = (Collection)newWithElement(source());
			out = new LoopingIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;LoopingListIterator;true;LoopingListIterator;;;Element of Argument[0];Element of Argument[-1];value"
			LoopingListIterator out = null;
			List in = (List)List.of(source());
			out = new LoopingListIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ObjectArrayIterator;true;ObjectArrayIterator;;;ArrayElement of Argument[0];Element of Argument[-1];value"
			ObjectArrayIterator out = null;
			Object[] in = (Object[])new Object[]{source()};
			out = new ObjectArrayIterator(in, 0, 0);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ObjectArrayIterator;true;ObjectArrayIterator;;;ArrayElement of Argument[0];Element of Argument[-1];value"
			ObjectArrayIterator out = null;
			Object[] in = (Object[])new Object[]{source()};
			out = new ObjectArrayIterator(in, 0);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ObjectArrayIterator;true;ObjectArrayIterator;;;ArrayElement of Argument[0];Element of Argument[-1];value"
			ObjectArrayIterator out = null;
			Object[] in = (Object[])new Object[]{source()};
			out = new ObjectArrayIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ObjectArrayIterator;true;getArray;;;Element of Argument[-1];ArrayElement of ReturnValue;value"
			Object[] out = null;
			ObjectArrayIterator in = (ObjectArrayIterator)newWithElement(source());
			out = in.getArray();
			sink(getArrayElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ObjectArrayListIterator;true;ObjectArrayListIterator;;;ArrayElement of Argument[0];Element of Argument[-1];value"
			ObjectArrayListIterator out = null;
			Object[] in = (Object[])new Object[]{source()};
			out = new ObjectArrayListIterator(in, 0, 0);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ObjectArrayListIterator;true;ObjectArrayListIterator;;;ArrayElement of Argument[0];Element of Argument[-1];value"
			ObjectArrayListIterator out = null;
			Object[] in = (Object[])new Object[]{source()};
			out = new ObjectArrayListIterator(in, 0);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ObjectArrayListIterator;true;ObjectArrayListIterator;;;ArrayElement of Argument[0];Element of Argument[-1];value"
			ObjectArrayListIterator out = null;
			Object[] in = (Object[])new Object[]{source()};
			out = new ObjectArrayListIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;PeekingIterator;true;PeekingIterator;;;Element of Argument[0];Element of Argument[-1];value"
			PeekingIterator out = null;
			Iterator in = (Iterator)newWithElement(source());
			out = new PeekingIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;PeekingIterator;true;element;;;Element of Argument[-1];ReturnValue;value"
			Object out = null;
			PeekingIterator in = (PeekingIterator)newWithElement(source());
			out = in.element();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;PeekingIterator;true;peek;;;Element of Argument[-1];ReturnValue;value"
			Object out = null;
			PeekingIterator in = (PeekingIterator)newWithElement(source());
			out = in.peek();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;PeekingIterator;true;peekingIterator;;;Element of Argument[0];Element of ReturnValue;value"
			PeekingIterator out = null;
			Iterator in = (Iterator)newWithElement(source());
			out = PeekingIterator.peekingIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;PermutationIterator;true;PermutationIterator;;;Element of Argument[0];Element of Element of Argument[-1];value"
			PermutationIterator out = null;
			Collection in = (Collection)List.of(source());
			out = new PermutationIterator(in);
			sink(getElement(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;PushbackIterator;true;PushbackIterator;;;Element of Argument[0];Element of Argument[-1];value"
			PushbackIterator out = null;
			Iterator in = (Iterator)newWithElement(source());
			out = new PushbackIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;PushbackIterator;true;pushback;;;Argument[0];Element of Argument[-1];value"
			PushbackIterator out = null;
			Object in = (Object)source();
			out.pushback(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;PushbackIterator;true;pushbackIterator;;;Element of Argument[0];Element of ReturnValue;value"
			PushbackIterator out = null;
			Iterator in = (Iterator)newWithElement(source());
			out = PushbackIterator.pushbackIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ReverseListIterator;true;ReverseListIterator;;;Element of Argument[0];Element of Argument[-1];value"
			ReverseListIterator out = null;
			List in = (List)List.of(source());
			out = new ReverseListIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;SingletonIterator;true;SingletonIterator;;;Argument[0];Element of Argument[-1];value"
			SingletonIterator out = null;
			Object in = (Object)source();
			out = new SingletonIterator(in, false);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;SingletonIterator;true;SingletonIterator;;;Argument[0];Element of Argument[-1];value"
			SingletonIterator out = null;
			Object in = (Object)source();
			out = new SingletonIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;SingletonListIterator;true;SingletonListIterator;;;Argument[0];Element of Argument[-1];value"
			SingletonListIterator out = null;
			Object in = (Object)source();
			out = new SingletonListIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;SkippingIterator;true;SkippingIterator;;;Element of Argument[0];Element of Argument[-1];value"
			SkippingIterator out = null;
			Iterator in = (Iterator)newWithElement(source());
			out = new SkippingIterator(in, 0L);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;UniqueFilterIterator;true;UniqueFilterIterator;;;Element of Argument[0];Element of Argument[-1];value"
			UniqueFilterIterator out = null;
			Iterator in = (Iterator)newWithElement(source());
			out = new UniqueFilterIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;UnmodifiableIterator;true;unmodifiableIterator;;;Element of Argument[0];Element of ReturnValue;value"
			Iterator out = null;
			Iterator in = (Iterator)newWithElement(source());
			out = UnmodifiableIterator.unmodifiableIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;UnmodifiableListIterator;true;umodifiableListIterator;;;Element of Argument[0];Element of ReturnValue;value"
			ListIterator out = null;
			ListIterator in = (ListIterator)newWithElement(source());
			out = UnmodifiableListIterator.umodifiableListIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;UnmodifiableMapIterator;true;unmodifiableMapIterator;;;Element of Argument[0];Element of ReturnValue;value"
			MapIterator out = null;
			MapIterator in = (MapIterator)newWithElement(source());
			out = UnmodifiableMapIterator.unmodifiableMapIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;UnmodifiableMapIterator;true;unmodifiableMapIterator;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			MapIterator out = null;
			MapIterator in = (MapIterator)newWithMapValue(source());
			out = UnmodifiableMapIterator.unmodifiableMapIterator(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;UnmodifiableOrderedMapIterator;true;unmodifiableOrderedMapIterator;;;Element of Argument[0];Element of ReturnValue;value"
			OrderedMapIterator out = null;
			OrderedMapIterator in = (OrderedMapIterator)newWithElement(source());
			out = UnmodifiableOrderedMapIterator.unmodifiableOrderedMapIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;UnmodifiableOrderedMapIterator;true;unmodifiableOrderedMapIterator;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			OrderedMapIterator out = null;
			OrderedMapIterator in = (OrderedMapIterator)newWithMapValue(source());
			out = UnmodifiableOrderedMapIterator.unmodifiableOrderedMapIterator(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ZippingIterator;true;ZippingIterator;(Iterator,Iterator);;Element of Argument[0];Element of Argument[-1];value"
			ZippingIterator out = null;
			Iterator in = (Iterator)newWithElement(source());
			out = new ZippingIterator(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ZippingIterator;true;ZippingIterator;(Iterator,Iterator);;Element of Argument[1];Element of Argument[-1];value"
			ZippingIterator out = null;
			Iterator in = (Iterator)newWithElement(source());
			out = new ZippingIterator(null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ZippingIterator;true;ZippingIterator;(Iterator,Iterator,Iterator);;Element of Argument[0];Element of Argument[-1];value"
			ZippingIterator out = null;
			Iterator in = (Iterator)newWithElement(source());
			out = new ZippingIterator(in, null, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ZippingIterator;true;ZippingIterator;(Iterator,Iterator,Iterator);;Element of Argument[1];Element of Argument[-1];value"
			ZippingIterator out = null;
			Iterator in = (Iterator)newWithElement(source());
			out = new ZippingIterator(null, in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ZippingIterator;true;ZippingIterator;(Iterator,Iterator,Iterator);;Element of Argument[2];Element of Argument[-1];value"
			ZippingIterator out = null;
			Iterator in = (Iterator)newWithElement(source());
			out = new ZippingIterator(null, null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.iterators;ZippingIterator;true;ZippingIterator;(Iterator[]);;Element of ArrayElement of Argument[0];Element of Argument[-1];value"
			ZippingIterator out = null;
			Iterator[] in = (Iterator[])new Iterator[]{(Iterator)newWithElement(source())};
			out = new ZippingIterator(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object,Object);;Argument[0];Element of Argument[-1];value"
			MultiKey out = null;
			Object in = (Object)source();
			out = new MultiKey(in, (Object)null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object,Object);;Argument[1];Element of Argument[-1];value"
			MultiKey out = null;
			Object in = (Object)source();
			out = new MultiKey((Object)null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object,Object,Object);;Argument[0];Element of Argument[-1];value"
			MultiKey out = null;
			Object in = (Object)source();
			out = new MultiKey(in, null, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object,Object,Object);;Argument[1];Element of Argument[-1];value"
			MultiKey out = null;
			Object in = (Object)source();
			out = new MultiKey(null, in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object,Object,Object);;Argument[2];Element of Argument[-1];value"
			MultiKey out = null;
			Object in = (Object)source();
			out = new MultiKey(null, null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object);;Argument[0];Element of Argument[-1];value"
			MultiKey out = null;
			Object in = (Object)source();
			out = new MultiKey(in, null, null, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object);;Argument[1];Element of Argument[-1];value"
			MultiKey out = null;
			Object in = (Object)source();
			out = new MultiKey(null, in, null, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object);;Argument[2];Element of Argument[-1];value"
			MultiKey out = null;
			Object in = (Object)source();
			out = new MultiKey(null, null, in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object);;Argument[3];Element of Argument[-1];value"
			MultiKey out = null;
			Object in = (Object)source();
			out = new MultiKey(null, null, null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object,Object);;Argument[0];Element of Argument[-1];value"
			MultiKey out = null;
			Object in = (Object)source();
			out = new MultiKey(in, null, null, null, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object,Object);;Argument[1];Element of Argument[-1];value"
			MultiKey out = null;
			Object in = (Object)source();
			out = new MultiKey(null, in, null, null, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object,Object);;Argument[2];Element of Argument[-1];value"
			MultiKey out = null;
			Object in = (Object)source();
			out = new MultiKey(null, null, in, null, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object,Object);;Argument[3];Element of Argument[-1];value"
			MultiKey out = null;
			Object in = (Object)source();
			out = new MultiKey(null, null, null, in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object,Object);;Argument[4];Element of Argument[-1];value"
			MultiKey out = null;
			Object in = (Object)source();
			out = new MultiKey(null, null, null, null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object[]);;ArrayElement of Argument[0];Element of Argument[-1];value"
			MultiKey out = null;
			Object[] in = (Object[])new Object[]{source()};
			out = new MultiKey(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;MultiKey;(Object[],boolean);;ArrayElement of Argument[0];Element of Argument[-1];value"
			MultiKey out = null;
			Object[] in = (Object[])new Object[]{source()};
			out = new MultiKey(in, false);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;getKey;;;Element of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiKey in = (MultiKey)newWithElement(source());
			out = in.getKey(0);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.keyvalue;MultiKey;true;getKeys;;;Element of Argument[-1];ArrayElement of ReturnValue;value"
			Object[] out = null;
			MultiKey in = (MultiKey)newWithElement(source());
			out = in.getKeys();
			sink(getArrayElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;AbstractLinkedList;true;addFirst;;;Argument[0];Element of Argument[-1];value"
			AbstractLinkedList out = null;
			Object in = (Object)source();
			out.addFirst(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;AbstractLinkedList;true;addLast;;;Argument[0];Element of Argument[-1];value"
			AbstractLinkedList out = null;
			Object in = (Object)source();
			out.addLast(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;AbstractLinkedList;true;getFirst;;;Element of Argument[-1];ReturnValue;value"
			Object out = null;
			AbstractLinkedList in = (AbstractLinkedList)newWithElement(source());
			out = in.getFirst();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;AbstractLinkedList;true;getLast;;;Element of Argument[-1];ReturnValue;value"
			Object out = null;
			AbstractLinkedList in = (AbstractLinkedList)newWithElement(source());
			out = in.getLast();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;AbstractLinkedList;true;removeFirst;;;Element of Argument[-1];ReturnValue;value"
			Object out = null;
			AbstractLinkedList in = (AbstractLinkedList)newWithElement(source());
			out = in.removeFirst();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;AbstractLinkedList;true;removeLast;;;Element of Argument[-1];ReturnValue;value"
			Object out = null;
			AbstractLinkedList in = (AbstractLinkedList)newWithElement(source());
			out = in.removeLast();
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;CursorableLinkedList;true;CursorableLinkedList;;;Element of Argument[0];Element of Argument[-1];value"
			CursorableLinkedList out = null;
			Collection in = (Collection)List.of(source());
			out = new CursorableLinkedList(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;CursorableLinkedList;true;cursor;;;Element of Argument[-1];Element of ReturnValue;value"
			CursorableLinkedList.Cursor out = null;
			CursorableLinkedList in = (CursorableLinkedList)newWithElement(source());
			out = in.cursor(0);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;CursorableLinkedList;true;cursor;;;Element of Argument[-1];Element of ReturnValue;value"
			CursorableLinkedList.Cursor out = null;
			CursorableLinkedList in = (CursorableLinkedList)newWithElement(source());
			out = in.cursor();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;FixedSizeList;true;fixedSizeList;;;Element of Argument[0];Element of ReturnValue;value"
			FixedSizeList out = null;
			List in = (List)List.of(source());
			out = FixedSizeList.fixedSizeList(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;GrowthList;true;growthList;;;Element of Argument[0];Element of ReturnValue;value"
			GrowthList out = null;
			List in = (List)List.of(source());
			out = GrowthList.growthList(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;LazyList;true;lazyList;;;Element of Argument[0];Element of ReturnValue;value"
			LazyList out = null;
			List in = (List)List.of(source());
			out = LazyList.lazyList(in, (Transformer)null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;LazyList;true;lazyList;;;Element of Argument[0];Element of ReturnValue;value"
			LazyList out = null;
			List in = (List)List.of(source());
			out = LazyList.lazyList(in, (Factory)null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;NodeCachingLinkedList;true;NodeCachingLinkedList;(Collection);;Element of Argument[0];Element of Argument[-1];value"
			NodeCachingLinkedList out = null;
			Collection in = (Collection)List.of(source());
			out = new NodeCachingLinkedList(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;PredicatedList;true;predicatedList;;;Element of Argument[0];Element of ReturnValue;value"
			PredicatedList out = null;
			List in = (List)List.of(source());
			out = PredicatedList.predicatedList(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;SetUniqueList;true;asSet;;;Element of Argument[-1];Element of ReturnValue;value"
			Set out = null;
			SetUniqueList in = (SetUniqueList)newWithElement(source());
			out = in.asSet();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;SetUniqueList;true;setUniqueList;;;Element of Argument[0];Element of ReturnValue;value"
			SetUniqueList out = null;
			List in = (List)List.of(source());
			out = SetUniqueList.setUniqueList(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;TransformedList;true;transformingList;;;Element of Argument[0];Element of ReturnValue;value"
			TransformedList out = null;
			List in = (List)List.of(source());
			out = TransformedList.transformingList(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;TreeList;true;TreeList;;;Element of Argument[0];Element of Argument[-1];value"
			TreeList out = null;
			Collection in = (Collection)List.of(source());
			out = new TreeList(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;UnmodifiableList;true;UnmodifiableList;;;Element of Argument[0];Element of Argument[-1];value"
			UnmodifiableList out = null;
			List in = (List)List.of(source());
			out = new UnmodifiableList(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.list;UnmodifiableList;true;unmodifiableList;;;Element of Argument[0];Element of ReturnValue;value"
			List out = null;
			List in = (List)List.of(source());
			out = UnmodifiableList.unmodifiableList(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;AbstractOrderedMapDecorator;true;AbstractOrderedMapDecorator;(OrderedMap);;MapKey of Argument[0];MapKey of Argument[-1];value"
			AbstractOrderedMapDecorator out = null;
			OrderedMap in = (OrderedMap)newWithMapKey(source());
			out = new AbstractOrderedMapDecorator(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;AbstractOrderedMapDecorator;true;AbstractOrderedMapDecorator;(OrderedMap);;MapValue of Argument[0];MapValue of Argument[-1];value"
			AbstractOrderedMapDecorator out = null;
			OrderedMap in = (OrderedMap)newWithMapValue(source());
			out = new AbstractOrderedMapDecorator(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;AbstractSortedMapDecorator;true;AbstractSortedMapDecorator;(SortedMap);;MapKey of Argument[0];MapKey of Argument[-1];value"
			AbstractSortedMapDecorator out = null;
			SortedMap in = (SortedMap)newWithMapKey(source());
			out = new AbstractSortedMapDecorator(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;AbstractSortedMapDecorator;true;AbstractSortedMapDecorator;(SortedMap);;MapValue of Argument[0];MapValue of Argument[-1];value"
			AbstractSortedMapDecorator out = null;
			SortedMap in = (SortedMap)newWithMapValue(source());
			out = new AbstractSortedMapDecorator(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CaseInsensitiveMap;true;CaseInsensitiveMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			CaseInsensitiveMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = new CaseInsensitiveMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CaseInsensitiveMap;true;CaseInsensitiveMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value"
			CaseInsensitiveMap out = null;
			Map in = (Map)Map.of(null, source());
			out = new CaseInsensitiveMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;CompositeMap;(Map,Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			CompositeMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = new CompositeMap(in, (Map)null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;CompositeMap;(Map,Map);;MapKey of Argument[1];MapKey of Argument[-1];value"
			CompositeMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = new CompositeMap((Map)null, in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;CompositeMap;(Map,Map);;MapValue of Argument[0];MapValue of Argument[-1];value"
			CompositeMap out = null;
			Map in = (Map)Map.of(null, source());
			out = new CompositeMap(in, (Map)null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;CompositeMap;(Map,Map);;MapValue of Argument[1];MapValue of Argument[-1];value"
			CompositeMap out = null;
			Map in = (Map)Map.of(null, source());
			out = new CompositeMap((Map)null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;CompositeMap;(Map,Map,MapMutator);;MapKey of Argument[0];MapKey of Argument[-1];value"
			CompositeMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = new CompositeMap(in, null, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;CompositeMap;(Map,Map,MapMutator);;MapKey of Argument[1];MapKey of Argument[-1];value"
			CompositeMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = new CompositeMap(null, in, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;CompositeMap;(Map,Map,MapMutator);;MapValue of Argument[0];MapValue of Argument[-1];value"
			CompositeMap out = null;
			Map in = (Map)Map.of(null, source());
			out = new CompositeMap(in, null, null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;CompositeMap;(Map,Map,MapMutator);;MapValue of Argument[1];MapValue of Argument[-1];value"
			CompositeMap out = null;
			Map in = (Map)Map.of(null, source());
			out = new CompositeMap(null, in, null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;CompositeMap;(Map[]);;MapKey of ArrayElement of Argument[0];MapKey of Argument[-1];value"
			CompositeMap out = null;
			Map[] in = (Map[])new Map[]{(Map)newWithMapKey(source())};
			out = new CompositeMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;CompositeMap;(Map[]);;MapValue of ArrayElement of Argument[0];MapValue of Argument[-1];value"
			CompositeMap out = null;
			Map[] in = (Map[])new Map[]{(Map)newWithMapValue(source())};
			out = new CompositeMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;CompositeMap;(Map[],MapMutator);;MapKey of ArrayElement of Argument[0];MapKey of Argument[-1];value"
			CompositeMap out = null;
			Map[] in = (Map[])new Map[]{(Map)newWithMapKey(source())};
			out = new CompositeMap(in, (CompositeMap.MapMutator)null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;CompositeMap;(Map[],MapMutator);;MapValue of ArrayElement of Argument[0];MapValue of Argument[-1];value"
			CompositeMap out = null;
			Map[] in = (Map[])new Map[]{(Map)newWithMapValue(source())};
			out = new CompositeMap(in, (CompositeMap.MapMutator)null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;addComposited;;;MapKey of Argument[0];MapKey of Argument[-1];value"
			CompositeMap out = null;
			Map in = (Map)Map.of(source(), null);
			out.addComposited(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;addComposited;;;MapValue of Argument[0];MapValue of Argument[-1];value"
			CompositeMap out = null;
			Map in = (Map)Map.of(null, source());
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
			CompositeMap in = (CompositeMap)newWithMapKey(source());
			out = in.removeComposited(null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;CompositeMap;true;removeComposited;;;MapValue of Argument[-1];MapValue of ReturnValue;value"
			Map out = null;
			CompositeMap in = (CompositeMap)newWithMapValue(source());
			out = in.removeComposited(null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;DefaultedMap;true;DefaultedMap;(Object);;Argument[0];MapValue of Argument[-1];value"
			DefaultedMap out = null;
			Object in = (Object)source();
			out = new DefaultedMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;DefaultedMap;true;defaultedMap;(Map,Object);;Argument[1];MapValue of ReturnValue;value"
			DefaultedMap out = null;
			Object in = (Object)source();
			out = DefaultedMap.defaultedMap((Map)null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;DefaultedMap;true;defaultedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			Map out = null;
			Map<Object,String> in = (Map)Map.of(source(), null);
			out = DefaultedMap.defaultedMap(in, (Transformer)null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;DefaultedMap;true;defaultedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			DefaultedMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = DefaultedMap.defaultedMap(in, (Object)null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;DefaultedMap;true;defaultedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			DefaultedMap out = null;
			Map<Object,String> in = (Map)Map.of(source(), null);
			out = DefaultedMap.defaultedMap(in, (Factory)null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;DefaultedMap;true;defaultedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			Map out = null;
			Map<Object,String> in = (Map)Map.of(null, source());
			out = DefaultedMap.defaultedMap(in, (Transformer)null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;DefaultedMap;true;defaultedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			DefaultedMap out = null;
			Map in = (Map)Map.of(null, source());
			out = DefaultedMap.defaultedMap(in, (Object)null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;DefaultedMap;true;defaultedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			DefaultedMap out = null;
			Map<Object,String> in = (Map)Map.of(null, source());
			out = DefaultedMap.defaultedMap(in, (Factory)null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;EntrySetToMapIteratorAdapter;true;EntrySetToMapIteratorAdapter;;;MapKey of Element of Argument[0];Element of Argument[-1];value"
			EntrySetToMapIteratorAdapter out = null;
			Set in = (Set)newWithElement(newWithMapKey(source()));
			out = new EntrySetToMapIteratorAdapter(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;EntrySetToMapIteratorAdapter;true;EntrySetToMapIteratorAdapter;;;MapValue of Element of Argument[0];MapValue of Argument[-1];value"
			EntrySetToMapIteratorAdapter out = null;
			Set in = (Set)newWithElement(newWithMapValue(source()));
			out = new EntrySetToMapIteratorAdapter(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;FixedSizeMap;true;fixedSizeMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			FixedSizeMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = FixedSizeMap.fixedSizeMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;FixedSizeMap;true;fixedSizeMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			FixedSizeMap out = null;
			Map in = (Map)Map.of(null, source());
			out = FixedSizeMap.fixedSizeMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;FixedSizeSortedMap;true;fixedSizeSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			FixedSizeSortedMap out = null;
			SortedMap in = (SortedMap)newWithMapKey(source());
			out = FixedSizeSortedMap.fixedSizeSortedMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;FixedSizeSortedMap;true;fixedSizeSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			FixedSizeSortedMap out = null;
			SortedMap in = (SortedMap)newWithMapValue(source());
			out = FixedSizeSortedMap.fixedSizeSortedMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;Flat3Map;true;Flat3Map;;;MapKey of Argument[0];MapKey of Argument[-1];value"
			Flat3Map out = null;
			Map in = (Map)Map.of(source(), null);
			out = new Flat3Map(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;Flat3Map;true;Flat3Map;;;MapValue of Argument[0];MapValue of Argument[-1];value"
			Flat3Map out = null;
			Map in = (Map)Map.of(null, source());
			out = new Flat3Map(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;HashedMap;true;HashedMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			HashedMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = new HashedMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;HashedMap;true;HashedMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value"
			HashedMap out = null;
			Map in = (Map)Map.of(null, source());
			out = new HashedMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LRUMap;true;LRUMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			LRUMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = new LRUMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LRUMap;true;LRUMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value"
			LRUMap out = null;
			Map in = (Map)Map.of(null, source());
			out = new LRUMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LRUMap;true;LRUMap;(Map,boolean);;MapKey of Argument[0];MapKey of Argument[-1];value"
			LRUMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = new LRUMap(in, false);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LRUMap;true;LRUMap;(Map,boolean);;MapValue of Argument[0];MapValue of Argument[-1];value"
			LRUMap out = null;
			Map in = (Map)Map.of(null, source());
			out = new LRUMap(in, false);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LRUMap;true;get;(Object,boolean);;MapValue of Argument[0];ReturnValue;value"
			Object out = null;
			Object in = (Object)Map.of(null, source());
			LRUMap instance = null;
			out = instance.get(in, false);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LazyMap;true;lazyMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			LazyMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = LazyMap.lazyMap(in, (Transformer)null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LazyMap;true;lazyMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			LazyMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = LazyMap.lazyMap(in, (Factory)null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LazyMap;true;lazyMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			LazyMap out = null;
			Map in = (Map)Map.of(null, source());
			out = LazyMap.lazyMap(in, (Transformer)null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LazyMap;true;lazyMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			LazyMap out = null;
			Map in = (Map)Map.of(null, source());
			out = LazyMap.lazyMap(in, (Factory)null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LazySortedMap;true;lazySortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			LazySortedMap out = null;
			SortedMap in = (SortedMap)newWithMapKey(source());
			out = LazySortedMap.lazySortedMap(in, (Transformer)null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LazySortedMap;true;lazySortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			LazySortedMap out = null;
			SortedMap in = (SortedMap)newWithMapKey(source());
			out = LazySortedMap.lazySortedMap(in, (Factory)null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LazySortedMap;true;lazySortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			LazySortedMap out = null;
			SortedMap in = (SortedMap)newWithMapValue(source());
			out = LazySortedMap.lazySortedMap(in, (Transformer)null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LazySortedMap;true;lazySortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			LazySortedMap out = null;
			SortedMap in = (SortedMap)newWithMapValue(source());
			out = LazySortedMap.lazySortedMap(in, (Factory)null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LinkedMap;true;LinkedMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			LinkedMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = new LinkedMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LinkedMap;true;LinkedMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value"
			LinkedMap out = null;
			Map in = (Map)Map.of(null, source());
			out = new LinkedMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LinkedMap;true;asList;;;MapKey of Argument[-1];Element of ReturnValue;value"
			List out = null;
			LinkedMap in = (LinkedMap)newWithMapKey(source());
			out = in.asList();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LinkedMap;true;get;(int);;MapKey of Argument[-1];ReturnValue;value"
			Object out = null;
			LinkedMap in = (LinkedMap)newWithMapKey(source());
			out = in.get(0);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LinkedMap;true;getValue;(int);;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			LinkedMap in = (LinkedMap)newWithMapValue(source());
			out = in.getValue(0);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;LinkedMap;true;remove;(int);;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			LinkedMap in = (LinkedMap)newWithMapValue(source());
			out = in.remove(0);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;ListOrderedMap;true;asList;;;MapKey of Argument[-1];Element of ReturnValue;value"
			List out = null;
			ListOrderedMap in = (ListOrderedMap)newWithMapKey(source());
			out = in.asList();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;ListOrderedMap;true;get;(int);;MapKey of Argument[-1];ReturnValue;value"
			Object out = null;
			ListOrderedMap in = (ListOrderedMap)newWithMapKey(source());
			out = in.get(0);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;ListOrderedMap;true;getValue;(int);;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			ListOrderedMap in = (ListOrderedMap)newWithMapValue(source());
			out = in.getValue(0);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;ListOrderedMap;true;keyList;;;MapKey of Argument[-1];Element of ReturnValue;value"
			List out = null;
			ListOrderedMap in = (ListOrderedMap)newWithMapKey(source());
			out = in.keyList();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;ListOrderedMap;true;listOrderedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			ListOrderedMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = ListOrderedMap.listOrderedMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;ListOrderedMap;true;listOrderedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			ListOrderedMap out = null;
			Map in = (Map)Map.of(null, source());
			out = ListOrderedMap.listOrderedMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;ListOrderedMap;true;put;;;Argument[1];MapKey of Argument[-1];value"
			ListOrderedMap out = null;
			Object in = (Object)source();
			out.put(null, in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;ListOrderedMap;true;put;;;Argument[1];MapKey of Argument[-1];value"
			ListOrderedMap out = null;
			Object in = (Object)source();
			out.put(0, in, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;ListOrderedMap;true;put;;;Argument[2];MapValue of Argument[-1];value"
			ListOrderedMap out = null;
			Object in = (Object)source();
			out.put(0, null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;ListOrderedMap;true;putAll;;;MapKey of Argument[1];MapKey of Argument[-1];value"
			ListOrderedMap out = null;
			Map in = (Map)Map.of(source(), null);
			out.putAll(0, in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;ListOrderedMap;true;putAll;;;MapValue of Argument[1];MapValue of Argument[-1];value"
			ListOrderedMap out = null;
			Map in = (Map)Map.of(null, source());
			out.putAll(0, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;ListOrderedMap;true;remove;(int);;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			ListOrderedMap in = (ListOrderedMap)newWithMapValue(source());
			out = in.remove(0);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;ListOrderedMap;true;setValue;;;Argument[1];MapValue of Argument[-1];value"
			ListOrderedMap out = null;
			Object in = (Object)source();
			out.setValue(0, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;ListOrderedMap;true;valueList;;;MapValue of Argument[-1];Element of ReturnValue;value"
			List out = null;
			ListOrderedMap in = (ListOrderedMap)newWithMapValue(source());
			out = in.valueList();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;get;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiKeyMap in = (MultiKeyMap)newWithMapValue(source());
			out = in.get(null, null, null, null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;get;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiKeyMap in = (MultiKeyMap)newWithMapValue(source());
			out = in.get(null, null, null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;get;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiKeyMap in = (MultiKeyMap)newWithMapValue(source());
			out = in.get(null, null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;get;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiKeyMap in = (MultiKeyMap)newWithMapValue(source());
			out = in.get(null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object);;Argument[0..1];Element of MapKey of Argument[-1];value"
			MultiKeyMap out = null;
			Object in = (Object)source();
			out.put(null, in, null);
			sink(getElement(getMapKey(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object);;Argument[0..1];Element of MapKey of Argument[-1];value"
			MultiKeyMap out = null;
			Object in = (Object)source();
			out.put(in, null, null);
			sink(getElement(getMapKey(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object);;Argument[2];MapValue of Argument[-1];value"
			MultiKeyMap out = null;
			Object in = (Object)source();
			out.put(null, null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object,Object);;Argument[0..2];Element of MapKey of Argument[-1];value"
			MultiKeyMap out = null;
			Object in = (Object)source();
			out.put(null, null, in, null);
			sink(getElement(getMapKey(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object,Object);;Argument[0..2];Element of MapKey of Argument[-1];value"
			MultiKeyMap out = null;
			Object in = (Object)source();
			out.put(null, in, null, null);
			sink(getElement(getMapKey(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object,Object);;Argument[0..2];Element of MapKey of Argument[-1];value"
			MultiKeyMap out = null;
			Object in = (Object)source();
			out.put(in, null, null, null);
			sink(getElement(getMapKey(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object,Object);;Argument[3];MapValue of Argument[-1];value"
			MultiKeyMap out = null;
			Object in = (Object)source();
			out.put(null, null, null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object);;Argument[0..3];Element of MapKey of Argument[-1];value"
			MultiKeyMap out = null;
			Object in = (Object)source();
			out.put(null, null, null, in, null);
			sink(getElement(getMapKey(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object);;Argument[0..3];Element of MapKey of Argument[-1];value"
			MultiKeyMap out = null;
			Object in = (Object)source();
			out.put(null, null, in, null, null);
			sink(getElement(getMapKey(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object);;Argument[0..3];Element of MapKey of Argument[-1];value"
			MultiKeyMap out = null;
			Object in = (Object)source();
			out.put(null, in, null, null, null);
			sink(getElement(getMapKey(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object);;Argument[0..3];Element of MapKey of Argument[-1];value"
			MultiKeyMap out = null;
			Object in = (Object)source();
			out.put(in, null, null, null, null);
			sink(getElement(getMapKey(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object);;Argument[4];MapValue of Argument[-1];value"
			MultiKeyMap out = null;
			Object in = (Object)source();
			out.put(null, null, null, null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object,Object);;Argument[0..4];Element of MapKey of Argument[-1];value"
			MultiKeyMap out = null;
			Object in = (Object)source();
			out.put(null, null, null, null, in, null);
			sink(getElement(getMapKey(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object,Object);;Argument[0..4];Element of MapKey of Argument[-1];value"
			MultiKeyMap out = null;
			Object in = (Object)source();
			out.put(null, null, null, in, null, null);
			sink(getElement(getMapKey(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object,Object);;Argument[0..4];Element of MapKey of Argument[-1];value"
			MultiKeyMap out = null;
			Object in = (Object)source();
			out.put(null, null, in, null, null, null);
			sink(getElement(getMapKey(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object,Object);;Argument[0..4];Element of MapKey of Argument[-1];value"
			MultiKeyMap out = null;
			Object in = (Object)source();
			out.put(null, in, null, null, null, null);
			sink(getElement(getMapKey(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object,Object);;Argument[0..4];Element of MapKey of Argument[-1];value"
			MultiKeyMap out = null;
			Object in = (Object)source();
			out.put(in, null, null, null, null, null);
			sink(getElement(getMapKey(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object,Object);;Argument[5];MapValue of Argument[-1];value"
			MultiKeyMap out = null;
			Object in = (Object)source();
			out.put(null, null, null, null, null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiKeyMap in = (MultiKeyMap)newWithMapValue(source());
			out = in.put(null, null, null, null, null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiKeyMap in = (MultiKeyMap)newWithMapValue(source());
			out = in.put(null, null, null, null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiKeyMap in = (MultiKeyMap)newWithMapValue(source());
			out = in.put(null, null, null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiKeyMap in = (MultiKeyMap)newWithMapValue(source());
			out = in.put(null, null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;put;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiKeyMap in = (MultiKeyMap)newWithMapValue(source());
			out = in.put(null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;removeMultiKey;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiKeyMap in = (MultiKeyMap)newWithMapValue(source());
			out = in.removeMultiKey(null, null, null, null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;removeMultiKey;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiKeyMap in = (MultiKeyMap)newWithMapValue(source());
			out = in.removeMultiKey(null, null, null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;removeMultiKey;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiKeyMap in = (MultiKeyMap)newWithMapValue(source());
			out = in.removeMultiKey(null, null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiKeyMap;true;removeMultiKey;;;MapValue of Argument[-1];ReturnValue;value"
			Object out = null;
			MultiKeyMap in = (MultiKeyMap)newWithMapValue(source());
			out = in.removeMultiKey(null, null);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiValueMap;true;getCollection;;;Element of MapValue of Argument[-1];Element of ReturnValue;value"
			Collection out = null;
			MultiValueMap in = (MultiValueMap)newWithMapValue(newWithElement(source()));
			out = in.getCollection(null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiValueMap;true;iterator;();;Element of MapValue of Argument[-1];MapValue of Element of ReturnValue;value"
			Iterator out = null;
			MultiValueMap in = (MultiValueMap)newWithMapValue(newWithElement(source()));
			out = in.iterator();
			sink(getMapValue(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiValueMap;true;iterator;();;MapKey of Argument[-1];MapKey of Element of ReturnValue;value"
			Iterator out = null;
			MultiValueMap in = (MultiValueMap)newWithMapKey(source());
			out = in.iterator();
			sink(getMapKey(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiValueMap;true;iterator;(Object);;Element of MapValue of Argument[-1];Element of ReturnValue;value"
			Iterator out = null;
			MultiValueMap in = (MultiValueMap)newWithMapValue(newWithElement(source()));
			out = in.iterator(null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiValueMap;true;multiValueMap;;;Element of MapValue of Argument[0];Element of MapValue of ReturnValue;value"
			MultiValueMap out = null;
			Map in = (Map)Map.of(null, newWithElement(source()));
			out = MultiValueMap.multiValueMap(in, (Factory)null);
			sink(getElement(getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiValueMap;true;multiValueMap;;;Element of MapValue of Argument[0];Element of MapValue of ReturnValue;value"
			MultiValueMap out = null;
			Map in = (Map)Map.of(null, newWithElement(source()));
			out = MultiValueMap.multiValueMap(in, (Class)null);
			sink(getElement(getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiValueMap;true;multiValueMap;;;Element of MapValue of Argument[0];Element of MapValue of ReturnValue;value"
			MultiValueMap out = null;
			Map in = (Map)Map.of(null, newWithElement(source()));
			out = MultiValueMap.multiValueMap(in);
			sink(getElement(getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiValueMap;true;multiValueMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			MultiValueMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = MultiValueMap.multiValueMap(in, (Factory)null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiValueMap;true;multiValueMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			MultiValueMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = MultiValueMap.multiValueMap(in, (Class)null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiValueMap;true;multiValueMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			MultiValueMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = MultiValueMap.multiValueMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiValueMap;true;putAll;(Map);;Element of MapValue of Argument[0];Element of MapValue of Argument[-1];value"
			MultiValueMap out = null;
			Map in = (Map)Map.of(null, newWithElement(source()));
			out.putAll(in);
			sink(getElement(getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiValueMap;true;putAll;(Map);;MapValue of Argument[0];Element of MapValue of Argument[-1];value"
			MultiValueMap out = null;
			Map in = (Map)Map.of(null, source());
			out.putAll(in);
			sink(getElement(getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiValueMap;true;putAll;(Object,Collection);;Argument[0];MapKey of Argument[-1];value"
			MultiValueMap out = null;
			Object in = (Object)source();
			out.putAll(in, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiValueMap;true;putAll;(Object,Collection);;Element of Argument[1];Element of MapValue of Argument[-1];value"
			MultiValueMap out = null;
			Collection in = (Collection)newWithElement(source());
			out.putAll(null, in);
			sink(getElement(getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;MultiValueMap;true;values;;;Element of MapValue of Argument[-1];Element of ReturnValue;value"
			Collection out = null;
			MultiValueMap in = (MultiValueMap)newWithMapValue(newWithElement(source()));
			out = in.values();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;PassiveExpiringMap;true;PassiveExpiringMap;(ExpirationPolicy,Map);;MapKey of Argument[1];MapKey of Argument[-1];value"
			PassiveExpiringMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = new PassiveExpiringMap((PassiveExpiringMap.ExpirationPolicy)null, in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;PassiveExpiringMap;true;PassiveExpiringMap;(ExpirationPolicy,Map);;MapValue of Argument[1];MapValue of Argument[-1];value"
			PassiveExpiringMap out = null;
			Map in = (Map)Map.of(null, source());
			out = new PassiveExpiringMap((PassiveExpiringMap.ExpirationPolicy)null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;PassiveExpiringMap;true;PassiveExpiringMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			PassiveExpiringMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = new PassiveExpiringMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;PassiveExpiringMap;true;PassiveExpiringMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value"
			PassiveExpiringMap out = null;
			Map in = (Map)Map.of(null, source());
			out = new PassiveExpiringMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;PassiveExpiringMap;true;PassiveExpiringMap;(long,Map);;MapKey of Argument[1];MapKey of Argument[-1];value"
			PassiveExpiringMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = new PassiveExpiringMap(0L, in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;PassiveExpiringMap;true;PassiveExpiringMap;(long,Map);;MapValue of Argument[1];MapValue of Argument[-1];value"
			PassiveExpiringMap out = null;
			Map in = (Map)Map.of(null, source());
			out = new PassiveExpiringMap(0L, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;PassiveExpiringMap;true;PassiveExpiringMap;(long,TimeUnit,Map);;MapKey of Argument[2];MapKey of Argument[-1];value"
			PassiveExpiringMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = new PassiveExpiringMap(0L, null, in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;PassiveExpiringMap;true;PassiveExpiringMap;(long,TimeUnit,Map);;MapValue of Argument[2];MapValue of Argument[-1];value"
			PassiveExpiringMap out = null;
			Map in = (Map)Map.of(null, source());
			out = new PassiveExpiringMap(0L, null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;PredicatedMap;true;predicatedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			PredicatedMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = PredicatedMap.predicatedMap(in, null, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;PredicatedMap;true;predicatedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			PredicatedMap out = null;
			Map in = (Map)Map.of(null, source());
			out = PredicatedMap.predicatedMap(in, null, null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;PredicatedSortedMap;true;predicatedSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			PredicatedSortedMap out = null;
			SortedMap in = (SortedMap)newWithMapKey(source());
			out = PredicatedSortedMap.predicatedSortedMap(in, null, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;PredicatedSortedMap;true;predicatedSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			PredicatedSortedMap out = null;
			SortedMap in = (SortedMap)newWithMapValue(source());
			out = PredicatedSortedMap.predicatedSortedMap(in, null, null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;SingletonMap;true;SingletonMap;(Entry);;MapKey of Argument[0];MapKey of Argument[-1];value"
			SingletonMap out = null;
			Map.Entry in = (Map.Entry)newWithMapKey(source());
			out = new SingletonMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;SingletonMap;true;SingletonMap;(Entry);;MapValue of Argument[0];MapValue of Argument[-1];value"
			SingletonMap out = null;
			Map.Entry in = (Map.Entry)newWithMapValue(source());
			out = new SingletonMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;SingletonMap;true;SingletonMap;(KeyValue);;MapKey of Argument[0];MapKey of Argument[-1];value"
			SingletonMap out = null;
			KeyValue in = (KeyValue)newWithMapKey(source());
			out = new SingletonMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;SingletonMap;true;SingletonMap;(KeyValue);;MapValue of Argument[0];MapValue of Argument[-1];value"
			SingletonMap out = null;
			KeyValue in = (KeyValue)newWithMapValue(source());
			out = new SingletonMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;SingletonMap;true;SingletonMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			SingletonMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = new SingletonMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;SingletonMap;true;SingletonMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value"
			SingletonMap out = null;
			Map in = (Map)Map.of(null, source());
			out = new SingletonMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;SingletonMap;true;SingletonMap;(Object,Object);;Argument[0];MapKey of Argument[-1];value"
			SingletonMap out = null;
			Object in = (Object)source();
			out = new SingletonMap(in, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;SingletonMap;true;SingletonMap;(Object,Object);;Argument[1];MapValue of Argument[-1];value"
			SingletonMap out = null;
			Object in = (Object)source();
			out = new SingletonMap(null, in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;SingletonMap;true;setValue;;;Argument[0];MapValue of Argument[-1];value"
			SingletonMap out = null;
			Object in = (Object)source();
			out.setValue(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;TransformedMap;true;transformingMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			TransformedMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = TransformedMap.transformingMap(in, null, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;TransformedMap;true;transformingMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			TransformedMap out = null;
			Map in = (Map)Map.of(null, source());
			out = TransformedMap.transformingMap(in, null, null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;TransformedSortedMap;true;transformingSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			TransformedSortedMap out = null;
			SortedMap in = (SortedMap)newWithMapKey(source());
			out = TransformedSortedMap.transformingSortedMap(in, null, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;TransformedSortedMap;true;transformingSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			TransformedSortedMap out = null;
			SortedMap in = (SortedMap)newWithMapValue(source());
			out = TransformedSortedMap.transformingSortedMap(in, null, null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;UnmodifiableEntrySet;true;unmodifiableEntrySet;;;MapKey of Element of Argument[0];MapKey of Element of ReturnValue;value"
			Set out = null;
			Set in = (Set)newWithElement(newWithMapKey(source()));
			out = UnmodifiableEntrySet.unmodifiableEntrySet(in);
			sink(getMapKey(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;UnmodifiableEntrySet;true;unmodifiableEntrySet;;;MapValue of Element of Argument[0];MapValue of Element of ReturnValue;value"
			Set out = null;
			Set in = (Set)newWithElement(newWithMapValue(source()));
			out = UnmodifiableEntrySet.unmodifiableEntrySet(in);
			sink(getMapValue(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;UnmodifiableMap;true;unmodifiableMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			Map out = null;
			Map in = (Map)Map.of(source(), null);
			out = UnmodifiableMap.unmodifiableMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;UnmodifiableMap;true;unmodifiableMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			Map out = null;
			Map in = (Map)Map.of(null, source());
			out = UnmodifiableMap.unmodifiableMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;UnmodifiableOrderedMap;true;unmodifiableOrderedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			OrderedMap out = null;
			OrderedMap in = (OrderedMap)newWithMapKey(source());
			out = UnmodifiableOrderedMap.unmodifiableOrderedMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;UnmodifiableOrderedMap;true;unmodifiableOrderedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			OrderedMap out = null;
			OrderedMap in = (OrderedMap)newWithMapValue(source());
			out = UnmodifiableOrderedMap.unmodifiableOrderedMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;UnmodifiableSortedMap;true;unmodifiableSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			SortedMap out = null;
			SortedMap in = (SortedMap)newWithMapKey(source());
			out = UnmodifiableSortedMap.unmodifiableSortedMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.map;UnmodifiableSortedMap;true;unmodifiableSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			SortedMap out = null;
			SortedMap in = (SortedMap)newWithMapValue(source());
			out = UnmodifiableSortedMap.unmodifiableSortedMap(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multimap;ArrayListValuedHashMap;true;ArrayListValuedHashMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			ArrayListValuedHashMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = new ArrayListValuedHashMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multimap;ArrayListValuedHashMap;true;ArrayListValuedHashMap;(Map);;MapValue of Argument[0];Element of MapValue of Argument[-1];value"
			ArrayListValuedHashMap out = null;
			Map in = (Map)Map.of(null, source());
			out = new ArrayListValuedHashMap(in);
			sink(getElement(getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multimap;ArrayListValuedHashMap;true;ArrayListValuedHashMap;(MultiValuedMap);;Element of MapValue of Argument[0];Element of MapValue of Argument[-1];value"
			ArrayListValuedHashMap out = null;
			MultiValuedMap in = (MultiValuedMap)newWithMapValue(newWithElement(source()));
			out = new ArrayListValuedHashMap(in);
			sink(getElement(getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multimap;ArrayListValuedHashMap;true;ArrayListValuedHashMap;(MultiValuedMap);;MapKey of Argument[0];MapKey of Argument[-1];value"
			ArrayListValuedHashMap out = null;
			MultiValuedMap in = (MultiValuedMap)newWithMapKey(source());
			out = new ArrayListValuedHashMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multimap;HashSetValuedHashMap;true;HashSetValuedHashMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value"
			HashSetValuedHashMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = new HashSetValuedHashMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multimap;HashSetValuedHashMap;true;HashSetValuedHashMap;(Map);;MapValue of Argument[0];Element of MapValue of Argument[-1];value"
			HashSetValuedHashMap out = null;
			Map in = (Map)Map.of(null, source());
			out = new HashSetValuedHashMap(in);
			sink(getElement(getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multimap;HashSetValuedHashMap;true;HashSetValuedHashMap;(MultiValuedMap);;Element of MapValue of Argument[0];Element of MapValue of Argument[-1];value"
			HashSetValuedHashMap out = null;
			MultiValuedMap in = (MultiValuedMap)newWithMapValue(newWithElement(source()));
			out = new HashSetValuedHashMap(in);
			sink(getElement(getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multimap;HashSetValuedHashMap;true;HashSetValuedHashMap;(MultiValuedMap);;MapKey of Argument[0];MapKey of Argument[-1];value"
			HashSetValuedHashMap out = null;
			MultiValuedMap in = (MultiValuedMap)newWithMapKey(source());
			out = new HashSetValuedHashMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multimap;TransformedMultiValuedMap;true;transformingMap;;;Element of MapValue of Argument[0];Element of MapValue of ReturnValue;value"
			TransformedMultiValuedMap out = null;
			MultiValuedMap in = (MultiValuedMap)newWithMapValue(newWithElement(source()));
			out = TransformedMultiValuedMap.transformingMap(in, null, null);
			sink(getElement(getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multimap;TransformedMultiValuedMap;true;transformingMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			TransformedMultiValuedMap out = null;
			MultiValuedMap in = (MultiValuedMap)newWithMapKey(source());
			out = TransformedMultiValuedMap.transformingMap(in, null, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multimap;UnmodifiableMultiValuedMap;true;unmodifiableMultiValuedMap;(MultiValuedMap);;Element of MapValue of Argument[0];Element of MapValue of ReturnValue;value"
			UnmodifiableMultiValuedMap out = null;
			MultiValuedMap in = (MultiValuedMap)newWithMapValue(newWithElement(source()));
			out = UnmodifiableMultiValuedMap.unmodifiableMultiValuedMap(in);
			sink(getElement(getMapValue(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multimap;UnmodifiableMultiValuedMap;true;unmodifiableMultiValuedMap;(MultiValuedMap);;MapKey of Argument[0];MapKey of ReturnValue;value"
			UnmodifiableMultiValuedMap out = null;
			MultiValuedMap in = (MultiValuedMap)newWithMapKey(source());
			out = UnmodifiableMultiValuedMap.unmodifiableMultiValuedMap(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multiset;HashMultiSet;true;HashMultiSet;;;Element of Argument[0];Element of Argument[-1];value"
			HashMultiSet out = null;
			Collection in = (Collection)newWithElement(source());
			out = new HashMultiSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multiset;PredicatedMultiSet;true;predicatedMultiSet;;;Element of Argument[0];Element of ReturnValue;value"
			PredicatedMultiSet out = null;
			MultiSet in = (MultiSet)newWithElement(source());
			out = PredicatedMultiSet.predicatedMultiSet(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multiset;SynchronizedMultiSet;true;synchronizedMultiSet;;;Element of Argument[0];Element of ReturnValue;value"
			SynchronizedMultiSet out = null;
			MultiSet in = (MultiSet)newWithElement(source());
			out = SynchronizedMultiSet.synchronizedMultiSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.multiset;UnmodifiableMultiSet;true;unmodifiableMultiSet;;;Element of Argument[0];Element of ReturnValue;value"
			MultiSet out = null;
			MultiSet in = (MultiSet)newWithElement(source());
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
			Collection in = (Collection)newWithElement(source());
			out = new CircularFifoQueue(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.queue;CircularFifoQueue;true;get;;;Element of Argument[-1];ReturnValue;value"
			Object out = null;
			CircularFifoQueue in = (CircularFifoQueue)newWithElement(source());
			out = in.get(0);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.queue;PredicatedQueue;true;predicatedQueue;;;Element of Argument[0];Element of ReturnValue;value"
			PredicatedQueue out = null;
			Queue in = (Queue)newWithElement(source());
			out = PredicatedQueue.predicatedQueue(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.queue;SynchronizedQueue;true;synchronizedQueue;;;Element of Argument[0];Element of ReturnValue;value"
			SynchronizedQueue out = null;
			Queue in = (Queue)newWithElement(source());
			out = SynchronizedQueue.synchronizedQueue(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.queue;TransformedQueue;true;transformingQueue;;;Element of Argument[0];Element of ReturnValue;value"
			TransformedQueue out = null;
			Queue in = (Queue)newWithElement(source());
			out = TransformedQueue.transformingQueue(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.queue;UnmodifiableQueue;true;unmodifiableQueue;;;Element of Argument[0];Element of ReturnValue;value"
			Queue out = null;
			Queue in = (Queue)newWithElement(source());
			out = UnmodifiableQueue.unmodifiableQueue(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;CompositeSet$SetMutator;true;add;;;Argument[2];Element of Argument[0];value"
			CompositeSet out = null;
			Object in = (Object)source();
			CompositeSet.SetMutator instance = null;
			instance.add(out, null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;CompositeSet$SetMutator;true;add;;;Argument[2];Element of Element of Argument[1];value"
			List out = null;
			Object in = (Object)source();
			CompositeSet.SetMutator instance = null;
			instance.add(null, out, in);
			sink(getElement(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;CompositeSet$SetMutator;true;addAll;;;Element of Argument[2];Element of Argument[0];value"
			CompositeSet out = null;
			Collection in = (Collection)newWithElement(source());
			CompositeSet.SetMutator instance = null;
			instance.addAll(out, null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;CompositeSet$SetMutator;true;addAll;;;Element of Argument[2];Element of Element of Argument[1];value"
			List out = null;
			Collection in = (Collection)newWithElement(source());
			CompositeSet.SetMutator instance = null;
			instance.addAll(null, out, in);
			sink(getElement(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;CompositeSet;true;CompositeSet;(Set);;Element of Argument[0];Element of Argument[-1];value"
			CompositeSet out = null;
			Set in = (Set)newWithElement(source());
			out = new CompositeSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;CompositeSet;true;CompositeSet;(Set[]);;Element of ArrayElement of Argument[0];Element of Argument[-1];value"
			CompositeSet out = null;
			Set[] in = (Set[])new Set[]{(Set)newWithElement(source())};
			out = new CompositeSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;CompositeSet;true;addComposited;(Set);;Element of Argument[0];Element of Argument[-1];value"
			CompositeSet out = null;
			Set in = (Set)newWithElement(source());
			out.addComposited(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;CompositeSet;true;addComposited;(Set,Set);;Element of Argument[0];Element of Argument[-1];value"
			CompositeSet out = null;
			Set in = (Set)newWithElement(source());
			out.addComposited(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;CompositeSet;true;addComposited;(Set,Set);;Element of Argument[1];Element of Argument[-1];value"
			CompositeSet out = null;
			Set in = (Set)newWithElement(source());
			out.addComposited(null, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;CompositeSet;true;addComposited;(Set[]);;Element of ArrayElement of Argument[0];Element of Argument[-1];value"
			CompositeSet out = null;
			Set[] in = (Set[])new Set[]{(Set)newWithElement(source())};
			out.addComposited(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;CompositeSet;true;getSets;;;Element of Argument[-1];Element of Element of ReturnValue;value"
			List out = null;
			CompositeSet in = (CompositeSet)newWithElement(source());
			out = in.getSets();
			sink(getElement(getElement(out))); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;CompositeSet;true;toSet;;;Element of Argument[-1];Element of ReturnValue;value"
			Set out = null;
			CompositeSet in = (CompositeSet)newWithElement(source());
			out = in.toSet();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;ListOrderedSet;true;add;;;Argument[1];Element of Argument[-1];value"
			ListOrderedSet out = null;
			Object in = (Object)source();
			out.add(0, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;ListOrderedSet;true;addAll;;;Element of Argument[1];Element of Argument[-1];value"
			ListOrderedSet out = null;
			Collection in = (Collection)List.of(source());
			out.addAll(0, in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;ListOrderedSet;true;asList;;;Element of Argument[-1];Element of ReturnValue;value"
			List out = null;
			ListOrderedSet in = (ListOrderedSet)newWithElement(source());
			out = in.asList();
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;ListOrderedSet;true;get;;;Element of Argument[-1];ReturnValue;value"
			Object out = null;
			ListOrderedSet in = (ListOrderedSet)newWithElement(source());
			out = in.get(0);
			sink(out); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;ListOrderedSet;true;listOrderedSet;(List);;Element of Argument[0];Element of ReturnValue;value"
			ListOrderedSet out = null;
			List in = (List)List.of(source());
			out = ListOrderedSet.listOrderedSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;ListOrderedSet;true;listOrderedSet;(Set);;Element of Argument[0];Element of ReturnValue;value"
			ListOrderedSet out = null;
			Set in = (Set)newWithElement(source());
			out = ListOrderedSet.listOrderedSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;MapBackedSet;true;mapBackedSet;;;MapKey of Argument[0];Element of ReturnValue;value"
			MapBackedSet out = null;
			Map in = (Map)Map.of(source(), null);
			out = MapBackedSet.mapBackedSet(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;MapBackedSet;true;mapBackedSet;;;MapKey of Argument[0];Element of ReturnValue;value"
			MapBackedSet out = null;
			Map in = (Map)Map.of(source(), null);
			out = MapBackedSet.mapBackedSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;PredicatedNavigableSet;true;predicatedNavigableSet;;;Element of Argument[0];Element of ReturnValue;value"
			PredicatedNavigableSet out = null;
			NavigableSet in = (NavigableSet)newWithElement(source());
			out = PredicatedNavigableSet.predicatedNavigableSet(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;PredicatedSet;true;predicatedSet;;;Element of Argument[0];Element of ReturnValue;value"
			PredicatedSet out = null;
			Set in = (Set)newWithElement(source());
			out = PredicatedSet.predicatedSet(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;PredicatedSortedSet;true;predicatedSortedSet;;;Element of Argument[0];Element of ReturnValue;value"
			PredicatedSortedSet out = null;
			SortedSet in = (SortedSet)newWithElement(source());
			out = PredicatedSortedSet.predicatedSortedSet(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;TransformedNavigableSet;true;transformingNavigableSet;;;Element of Argument[0];Element of ReturnValue;value"
			TransformedNavigableSet out = null;
			NavigableSet in = (NavigableSet)newWithElement(source());
			out = TransformedNavigableSet.transformingNavigableSet(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;TransformedSet;true;transformingSet;;;Element of Argument[0];Element of ReturnValue;value"
			TransformedSet out = null;
			Set in = (Set)newWithElement(source());
			out = TransformedSet.transformingSet(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;TransformedSortedSet;true;transformingSortedSet;;;Element of Argument[0];Element of ReturnValue;value"
			TransformedSortedSet out = null;
			SortedSet in = (SortedSet)newWithElement(source());
			out = TransformedSortedSet.transformingSortedSet(in, null);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;UnmodifiableNavigableSet;true;unmodifiableNavigableSet;;;Element of Argument[0];Element of ReturnValue;value"
			NavigableSet out = null;
			NavigableSet in = (NavigableSet)newWithElement(source());
			out = UnmodifiableNavigableSet.unmodifiableNavigableSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;UnmodifiableSet;true;unmodifiableSet;;;Element of Argument[0];Element of ReturnValue;value"
			Set out = null;
			Set in = (Set)newWithElement(source());
			out = UnmodifiableSet.unmodifiableSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.set;UnmodifiableSortedSet;true;unmodifiableSortedSet;;;Element of Argument[0];Element of ReturnValue;value"
			SortedSet out = null;
			SortedSet in = (SortedSet)newWithElement(source());
			out = UnmodifiableSortedSet.unmodifiableSortedSet(in);
			sink(getElement(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.splitmap;AbstractIterableGetMapDecorator;true;AbstractIterableGetMapDecorator;;;MapKey of Argument[0];MapKey of Argument[-1];value"
			AbstractIterableGetMapDecorator out = null;
			Map in = (Map)Map.of(source(), null);
			out = new AbstractIterableGetMapDecorator(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.splitmap;AbstractIterableGetMapDecorator;true;AbstractIterableGetMapDecorator;;;MapValue of Argument[0];MapValue of Argument[-1];value"
			AbstractIterableGetMapDecorator out = null;
			Map in = (Map)Map.of(null, source());
			out = new AbstractIterableGetMapDecorator(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.splitmap;TransformedSplitMap;true;transformingMap;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			TransformedSplitMap out = null;
			Map in = (Map)Map.of(source(), null);
			out = TransformedSplitMap.transformingMap(in, null, null);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.splitmap;TransformedSplitMap;true;transformingMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			TransformedSplitMap out = null;
			Map in = (Map)Map.of(null, source());
			out = TransformedSplitMap.transformingMap(in, null, null);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.trie;PatriciaTrie;true;PatriciaTrie;;;MapKey of Argument[0];MapKey of Argument[-1];value"
			PatriciaTrie out = null;
			Map in = (Map)Map.of(source(), null);
			out = new PatriciaTrie(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.trie;PatriciaTrie;true;PatriciaTrie;;;MapValue of Argument[0];MapValue of Argument[-1];value"
			PatriciaTrie out = null;
			Map in = (Map)Map.of(null, source());
			out = new PatriciaTrie(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.trie;UnmodifiableTrie;true;unmodifiableTrie;;;MapKey of Argument[0];MapKey of ReturnValue;value"
			Trie out = null;
			Trie in = (Trie)newWithMapKey(source());
			out = UnmodifiableTrie.unmodifiableTrie(in);
			sink(getMapKey(out)); // $ hasValueFlow
		}
		{
			// "org.apache.commons.collections4.trie;UnmodifiableTrie;true;unmodifiableTrie;;;MapValue of Argument[0];MapValue of ReturnValue;value"
			Trie out = null;
			Trie in = (Trie)newWithMapValue(source());
			out = UnmodifiableTrie.unmodifiableTrie(in);
			sink(getMapValue(out)); // $ hasValueFlow
		}

	}

}