/** Definitions related to the Apache Commons Collections library. */

import java
private import semmle.code.java.dataflow.FlowSteps
private import semmle.code.java.dataflow.ExternalFlow

/**
 * The method `isEmpty` in either `org.apache.commons.collections.CollectionUtils`
 * or `org.apache.commons.collections4.CollectionUtils`.
 */
class MethodApacheCollectionsIsEmpty extends Method {
  MethodApacheCollectionsIsEmpty() {
    this.getDeclaringType()
        .hasQualifiedName(["org.apache.commons.collections", "org.apache.commons.collections4"],
          "CollectionUtils") and
    this.hasName("isEmpty")
  }
}

/**
 * The method `isNotEmpty` in either `org.apache.commons.collections.CollectionUtils`
 * or `org.apache.commons.collections4.CollectionUtils`.
 */
class MethodApacheCollectionsIsNotEmpty extends Method {
  MethodApacheCollectionsIsNotEmpty() {
    this.getDeclaringType()
        .hasQualifiedName(["org.apache.commons.collections", "org.apache.commons.collections4"],
          "CollectionUtils") and
    this.hasName("isNotEmpty")
  }
}

/**
 * Value-propagating models for classes in the package `org.apache.commons.collections4`.
 */
private class ApacheCollectionsModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      ["org.apache.commons.collections4", "org.apache.commons.collections"] +
        [
          // Note that when lambdas are supported we should model things relating to Closure, Factory, Transformer, FluentIterable.forEach, FluentIterable.transform
          ";ArrayStack;true;peek;;;Argument[-1].Element;ReturnValue;value",
          ";ArrayStack;true;pop;;;Argument[-1].Element;ReturnValue;value",
          ";ArrayStack;true;push;;;Argument[0];Argument[-1].Element;value",
          ";ArrayStack;true;push;;;Argument[0];ReturnValue;value",
          ";Bag;true;add;;;Argument[0];Argument[-1].Element;value",
          ";Bag;true;uniqueSet;;;Argument[-1].Element;ReturnValue.Element;value",
          ";BidiMap;true;getKey;;;Argument[-1].MapKey;ReturnValue;value",
          ";BidiMap;true;removeValue;;;Argument[-1].MapKey;ReturnValue;value",
          ";BidiMap;true;inverseBidiMap;;;Argument[-1].MapKey;ReturnValue.MapValue;value",
          ";BidiMap;true;inverseBidiMap;;;Argument[-1].MapValue;ReturnValue.MapKey;value",
          ";FluentIterable;true;append;(Object[]);;Argument[-1].Element;ReturnValue.Element;value",
          ";FluentIterable;true;append;(Object[]);;Argument[0].ArrayElement;ReturnValue.Element;value",
          ";FluentIterable;true;append;(Iterable);;Argument[-1].Element;ReturnValue.Element;value",
          ";FluentIterable;true;append;(Iterable);;Argument[0].Element;ReturnValue.Element;value",
          ";FluentIterable;true;asEnumeration;;;Argument[-1].Element;ReturnValue.Element;value",
          ";FluentIterable;true;collate;;;Argument[-1].Element;ReturnValue.Element;value",
          ";FluentIterable;true;collate;;;Argument[0].Element;ReturnValue.Element;value",
          ";FluentIterable;true;copyInto;;;Argument[-1].Element;Argument[0].Element;value",
          ";FluentIterable;true;eval;;;Argument[-1].Element;ReturnValue.Element;value",
          ";FluentIterable;true;filter;;;Argument[-1].Element;ReturnValue.Element;value",
          ";FluentIterable;true;get;;;Argument[-1].Element;ReturnValue;value",
          ";FluentIterable;true;limit;;;Argument[-1].Element;ReturnValue.Element;value",
          ";FluentIterable;true;loop;;;Argument[-1].Element;ReturnValue.Element;value",
          ";FluentIterable;true;of;(Iterable);;Argument[0].Element;ReturnValue.Element;value",
          ";FluentIterable;true;of;(Object[]);;Argument[0].ArrayElement;ReturnValue.Element;value",
          ";FluentIterable;true;of;(Object);;Argument[0];ReturnValue.Element;value",
          ";FluentIterable;true;reverse;;;Argument[-1].Element;ReturnValue.Element;value",
          ";FluentIterable;true;skip;;;Argument[-1].Element;ReturnValue.Element;value",
          ";FluentIterable;true;toArray;;;Argument[-1].Element;ReturnValue.ArrayElement;value",
          ";FluentIterable;true;toList;;;Argument[-1].Element;ReturnValue.Element;value",
          ";FluentIterable;true;unique;;;Argument[-1].Element;ReturnValue.Element;value",
          ";FluentIterable;true;unmodifiable;;;Argument[-1].Element;ReturnValue.Element;value",
          ";FluentIterable;true;zip;(Iterable);;Argument[-1].Element;ReturnValue.Element;value",
          ";FluentIterable;true;zip;(Iterable);;Argument[0].Element;ReturnValue.Element;value",
          ";FluentIterable;true;zip;(Iterable[]);;Argument[-1].Element;ReturnValue.Element;value",
          ";FluentIterable;true;zip;(Iterable[]);;Argument[0].ArrayElement.Element;ReturnValue.Element;value",
          ";Get;true;entrySet;;;Argument[-1].MapKey;ReturnValue.Element.MapKey;value",
          ";Get;true;entrySet;;;Argument[-1].MapValue;ReturnValue.Element.MapValue;value",
          ";Get;true;get;;;Argument[-1].MapValue;ReturnValue;value",
          ";Get;true;keySet;();;Argument[-1].MapKey;ReturnValue.Element;value",
          ";Get;true;values;();;Argument[-1].MapValue;ReturnValue.Element;value",
          ";Get;true;remove;(Object);;Argument[-1].MapValue;ReturnValue;value",
          ";IterableGet;true;mapIterator;;;Argument[-1].MapKey;ReturnValue.Element;value",
          ";IterableGet;true;mapIterator;;;Argument[-1].MapValue;ReturnValue.MapValue;value",
          ";KeyValue;true;getKey;;;Argument[-1].MapKey;ReturnValue;value",
          ";KeyValue;true;getValue;;;Argument[-1].MapValue;ReturnValue;value",
          // Note that MapIterator<K, V> implements Iterator<K>, so it iterates over the keys of the map.
          // In order for the models of Iterator to work we have to use Element instead of MapKey for key data.
          ";MapIterator;true;getKey;;;Argument[-1].Element;ReturnValue;value",
          ";MapIterator;true;getValue;;;Argument[-1].MapValue;ReturnValue;value",
          ";MapIterator;true;setValue;;;Argument[-1].MapValue;ReturnValue;value",
          ";MapIterator;true;setValue;;;Argument[0];Argument[-1].MapValue;value",
          ";MultiMap;true;get;;;Argument[-1].MapValue.Element;ReturnValue.Element;value",
          ";MultiMap;true;put;;;Argument[0];Argument[-1].MapKey;value",
          ";MultiMap;true;put;;;Argument[1];Argument[-1].MapValue.Element;value",
          ";MultiMap;true;values;;;Argument[-1].MapValue.Element;ReturnValue.Element;value",
          ";MultiSet$Entry;true;getElement;;;Argument[-1].Element;ReturnValue;value",
          ";MultiSet;true;add;;;Argument[0];Argument[-1].Element;value",
          ";MultiSet;true;uniqueSet;;;Argument[-1].Element;ReturnValue.Element;value",
          ";MultiSet;true;entrySet;;;Argument[-1].Element;ReturnValue.Element.Element;value",
          ";MultiValuedMap;true;asMap;;;Argument[-1].MapKey;ReturnValue.MapKey;value",
          ";MultiValuedMap;true;asMap;;;Argument[-1].MapValue.Element;ReturnValue.MapValue.Element;value",
          ";MultiValuedMap;true;entries;;;Argument[-1].MapKey;ReturnValue.Element.MapKey;value",
          ";MultiValuedMap;true;entries;;;Argument[-1].MapValue.Element;ReturnValue.Element.MapValue;value",
          ";MultiValuedMap;true;get;;;Argument[-1].MapValue.Element;ReturnValue.Element;value",
          ";MultiValuedMap;true;keys;;;Argument[-1].MapKey;ReturnValue.Element;value",
          ";MultiValuedMap;true;keySet;;;Argument[-1].MapKey;ReturnValue.Element;value",
          ";MultiValuedMap;true;mapIterator;;;Argument[-1].MapKey;ReturnValue.Element;value",
          ";MultiValuedMap;true;mapIterator;;;Argument[-1].MapValue.Element;ReturnValue.MapValue;value",
          ";MultiValuedMap;true;put;;;Argument[0];Argument[-1].MapKey;value",
          ";MultiValuedMap;true;put;;;Argument[1];Argument[-1].MapValue.Element;value",
          ";MultiValuedMap;true;putAll;(Object,Iterable);;Argument[0];Argument[-1].MapKey;value",
          ";MultiValuedMap;true;putAll;(Object,Iterable);;Argument[1].Element;Argument[-1].MapValue.Element;value",
          ";MultiValuedMap;true;putAll;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ";MultiValuedMap;true;putAll;(Map);;Argument[0].MapValue;Argument[-1].MapValue.Element;value",
          ";MultiValuedMap;true;putAll;(MultiValuedMap);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ";MultiValuedMap;true;putAll;(MultiValuedMap);;Argument[0].MapValue.Element;Argument[-1].MapValue.Element;value",
          ";MultiValuedMap;true;remove;;;Argument[-1].MapValue.Element;ReturnValue.Element;value",
          ";MultiValuedMap;true;values;;;Argument[-1].MapValue.Element;ReturnValue.Element;value",
          ";OrderedIterator;true;previous;;;Argument[-1].Element;ReturnValue;value",
          ";OrderedMap;true;firstKey;;;Argument[-1].MapKey;ReturnValue;value",
          ";OrderedMap;true;lastKey;;;Argument[-1].MapKey;ReturnValue;value",
          ";OrderedMap;true;nextKey;;;Argument[-1].MapKey;ReturnValue;value",
          ";OrderedMap;true;previousKey;;;Argument[-1].MapKey;ReturnValue;value",
          ";Put;true;put;;;Argument[-1].MapValue;ReturnValue;value",
          ";Put;true;put;;;Argument[0];Argument[-1].MapKey;value",
          ";Put;true;put;;;Argument[1];Argument[-1].MapValue;value",
          ";Put;true;putAll;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ";Put;true;putAll;(Map);;Argument[0].MapValue;Argument[-1].MapValue;value",
          ";SortedBag;true;first;;;Argument[-1].Element;ReturnValue;value",
          ";SortedBag;true;last;;;Argument[-1].Element;ReturnValue;value",
          ";Trie;true;prefixMap;;;Argument[-1].MapKey;ReturnValue.MapKey;value",
          ";Trie;true;prefixMap;;;Argument[-1].MapValue;ReturnValue.MapValue;value"
        ]
  }
}

// Note that when lambdas are supported we should model the package `org.apache.commons.collections4.functors`,
// and when more general callable flow is supported we should model the package
// `org.apache.commons.collections4.sequence`.
/**
 * Value-propagating models for classes in the package `org.apache.commons.collections4.keyvalue`.
 */
private class ApacheKeyValueModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      ["org.apache.commons.collections4", "org.apache.commons.collections"] +
        [
          ".keyvalue;AbstractKeyValue;true;AbstractKeyValue;;;Argument[0];Argument[-1].MapKey;value",
          ".keyvalue;AbstractKeyValue;true;AbstractKeyValue;;;Argument[1];Argument[-1].MapValue;value",
          ".keyvalue;AbstractKeyValue;true;setKey;;;Argument[-1].MapKey;ReturnValue;value",
          ".keyvalue;AbstractKeyValue;true;setKey;;;Argument[0];Argument[-1].MapKey;value",
          ".keyvalue;AbstractKeyValue;true;setValue;;;Argument[-1].MapValue;ReturnValue;value",
          ".keyvalue;AbstractKeyValue;true;setValue;;;Argument[0];Argument[-1].MapValue;value",
          ".keyvalue;AbstractMapEntry;true;AbstractMapEntry;;;Argument[0];Argument[-1].MapKey;value",
          ".keyvalue;AbstractMapEntry;true;AbstractMapEntry;;;Argument[1];Argument[-1].MapValue;value",
          ".keyvalue;AbstractMapEntryDecorator;true;AbstractMapEntryDecorator;;;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".keyvalue;AbstractMapEntryDecorator;true;AbstractMapEntryDecorator;;;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".keyvalue;AbstractMapEntryDecorator;true;getMapEntry;;;Argument[-1].MapKey;ReturnValue.MapKey;value",
          ".keyvalue;AbstractMapEntryDecorator;true;getMapEntry;;;Argument[-1].MapValue;ReturnValue.MapValue;value",
          ".keyvalue;DefaultKeyValue;true;DefaultKeyValue;(Object,Object);;Argument[0];Argument[-1].MapKey;value",
          ".keyvalue;DefaultKeyValue;true;DefaultKeyValue;(Object,Object);;Argument[1];Argument[-1].MapValue;value",
          ".keyvalue;DefaultKeyValue;true;DefaultKeyValue;(KeyValue);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".keyvalue;DefaultKeyValue;true;DefaultKeyValue;(KeyValue);;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".keyvalue;DefaultKeyValue;true;DefaultKeyValue;(Entry);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".keyvalue;DefaultKeyValue;true;DefaultKeyValue;(Entry);;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".keyvalue;DefaultKeyValue;true;toMapEntry;;;Argument[-1].MapKey;ReturnValue.MapKey;value",
          ".keyvalue;DefaultKeyValue;true;toMapEntry;;;Argument[-1].MapValue;ReturnValue.MapValue;value",
          ".keyvalue;DefaultMapEntry;true;DefaultMapEntry;(Object,Object);;Argument[0];Argument[-1].MapKey;value",
          ".keyvalue;DefaultMapEntry;true;DefaultMapEntry;(Object,Object);;Argument[1];Argument[-1].MapValue;value",
          ".keyvalue;DefaultMapEntry;true;DefaultMapEntry;(KeyValue);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".keyvalue;DefaultMapEntry;true;DefaultMapEntry;(KeyValue);;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".keyvalue;DefaultMapEntry;true;DefaultMapEntry;(Entry);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".keyvalue;DefaultMapEntry;true;DefaultMapEntry;(Entry);;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".keyvalue;MultiKey;true;MultiKey;(Object[]);;Argument[0].ArrayElement;Argument[-1].Element;value",
          ".keyvalue;MultiKey;true;MultiKey;(Object[],boolean);;Argument[0].ArrayElement;Argument[-1].Element;value",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object);;Argument[0];Argument[-1].Element;value",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object);;Argument[1];Argument[-1].Element;value",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object);;Argument[0];Argument[-1].Element;value",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object);;Argument[1];Argument[-1].Element;value",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object);;Argument[2];Argument[-1].Element;value",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object);;Argument[0];Argument[-1].Element;value",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object);;Argument[1];Argument[-1].Element;value",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object);;Argument[2];Argument[-1].Element;value",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object);;Argument[3];Argument[-1].Element;value",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object,Object);;Argument[0];Argument[-1].Element;value",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object,Object);;Argument[1];Argument[-1].Element;value",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object,Object);;Argument[2];Argument[-1].Element;value",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object,Object);;Argument[3];Argument[-1].Element;value",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object,Object);;Argument[4];Argument[-1].Element;value",
          ".keyvalue;MultiKey;true;getKeys;;;Argument[-1].Element;ReturnValue.ArrayElement;value",
          ".keyvalue;MultiKey;true;getKey;;;Argument[-1].Element;ReturnValue;value",
          ".keyvalue;TiedMapEntry;true;TiedMapEntry;;;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".keyvalue;TiedMapEntry;true;TiedMapEntry;;;Argument[1];Argument[-1].MapKey;value",
          ".keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(Object,Object);;Argument[0];Argument[-1].MapKey;value",
          ".keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(Object,Object);;Argument[1];Argument[-1].MapValue;value",
          ".keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(KeyValue);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(KeyValue);;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(Entry);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(Entry);;Argument[0].MapValue;Argument[-1].MapValue;value"
        ]
  }
}

/**
 * Value-propagating models for classes in the package `org.apache.commons.collections4.bag`.
 */
private class ApacheBagModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      ["org.apache.commons.collections4", "org.apache.commons.collections"] +
        [
          // Note that when lambdas are supported we should have more models for TransformedBag, TransformedSortedBag
          ".bag;AbstractBagDecorator;true;AbstractBagDecorator;;;Argument[0].Element;Argument[-1].Element;value",
          ".bag;AbstractMapBag;true;AbstractMapBag;;;Argument[0].MapKey;Argument[-1].Element;value",
          ".bag;AbstractMapBag;true;getMap;;;Argument[-1].Element;ReturnValue.MapKey;value",
          ".bag;AbstractSortedBagDecorator;true;AbstractSortedBagDecorator;;;Argument[0].Element;Argument[-1].Element;value",
          ".bag;CollectionBag;true;CollectionBag;;;Argument[0].Element;Argument[-1].Element;value",
          ".bag;CollectionBag;true;collectionBag;;;Argument[0].Element;ReturnValue.Element;value",
          ".bag;CollectionSortedBag;true;CollectionSortedBag;;;Argument[0].Element;Argument[-1].Element;value",
          ".bag;CollectionSortedBag;true;collectionSortedBag;;;Argument[0].Element;ReturnValue.Element;value",
          ".bag;HashBag;true;HashBag;;;Argument[0].Element;Argument[-1].Element;value",
          ".bag;PredicatedBag;true;predicatedBag;;;Argument[0].Element;ReturnValue.Element;value",
          ".bag;PredicatedSortedBag;true;predicatedSortedBag;;;Argument[0].Element;ReturnValue.Element;value",
          ".bag;SynchronizedBag;true;synchronizedBag;;;Argument[0].Element;ReturnValue.Element;value",
          ".bag;SynchronizedSortedBag;true;synchronizedSortedBag;;;Argument[0].Element;ReturnValue.Element;value",
          ".bag;TransformedBag;true;transformedBag;;;Argument[0].Element;ReturnValue.Element;value",
          ".bag;TransformedSortedBag;true;transformedSortedBag;;;Argument[0].Element;ReturnValue.Element;value",
          ".bag;TreeBag;true;TreeBag;(Collection);;Argument[0].Element;Argument[-1].Element;value",
          ".bag;UnmodifiableBag;true;unmodifiableBag;;;Argument[0].Element;ReturnValue.Element;value",
          ".bag;UnmodifiableSortedBag;true;unmodifiableSortedBag;;;Argument[0].Element;ReturnValue.Element;value"
        ]
  }
}

/**
 * Value-propagating models for classes in the package `org.apache.commons.collections4.bidimap`.
 */
private class ApacheBidiMapModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      ["org.apache.commons.collections4", "org.apache.commons.collections"] +
        [
          ".bidimap;AbstractBidiMapDecorator;true;AbstractBidiMapDecorator;;;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".bidimap;AbstractBidiMapDecorator;true;AbstractBidiMapDecorator;;;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".bidimap;AbstractDualBidiMap;true;AbstractDualBidiMap;;;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".bidimap;AbstractDualBidiMap;true;AbstractDualBidiMap;;;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".bidimap;AbstractDualBidiMap;true;AbstractDualBidiMap;;;Argument[1].MapKey;Argument[-1].MapValue;value",
          ".bidimap;AbstractDualBidiMap;true;AbstractDualBidiMap;;;Argument[1].MapValue;Argument[-1].MapKey;value",
          ".bidimap;AbstractDualBidiMap;true;AbstractDualBidiMap;;;Argument[2].MapKey;Argument[-1].MapValue;value",
          ".bidimap;AbstractDualBidiMap;true;AbstractDualBidiMap;;;Argument[2].MapValue;Argument[-1].MapKey;value",
          ".bidimap;AbstractOrderedBidiMapDecorator;true;AbstractOrderedBidiMapDecorator;;;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".bidimap;AbstractOrderedBidiMapDecorator;true;AbstractOrderedBidiMapDecorator;;;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".bidimap;AbstractSortedBidiMapDecorator;true;AbstractSortedBidiMapDecorator;;;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".bidimap;AbstractSortedBidiMapDecorator;true;AbstractSortedBidiMapDecorator;;;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".bidimap;DualHashBidiMap;true;DualHashBidiMap;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".bidimap;DualHashBidiMap;true;DualHashBidiMap;(Map);;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".bidimap;DualLinkedHashBidiMap;true;DualLinkedHashBidiMap;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".bidimap;DualLinkedHashBidiMap;true;DualLinkedHashBidiMap;(Map);;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".bidimap;DualTreeBidiMap;true;DualTreeBidiMap;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".bidimap;DualTreeBidiMap;true;DualTreeBidiMap;(Map);;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".bidimap;DualTreeBidiMap;true;inverseOrderedBidiMap;;;Argument[-1].MapKey;ReturnValue.MapValue;value",
          ".bidimap;DualTreeBidiMap;true;inverseOrderedBidiMap;;;Argument[-1].MapValue;ReturnValue.MapKey;value",
          ".bidimap;DualTreeBidiMap;true;inverseSortedBidiMap;;;Argument[-1].MapKey;ReturnValue.MapValue;value",
          ".bidimap;DualTreeBidiMap;true;inverseSortedBidiMap;;;Argument[-1].MapValue;ReturnValue.MapKey;value",
          ".bidimap;TreeBidiMap;true;TreeBidiMap;;;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".bidimap;TreeBidiMap;true;TreeBidiMap;;;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".bidimap;UnmodifiableBidiMap;true;unmodifiableBidiMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ".bidimap;UnmodifiableBidiMap;true;unmodifiableBidiMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ".bidimap;UnmodifiableOrderedBidiMap;true;unmodifiableOrderedBidiMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ".bidimap;UnmodifiableOrderedBidiMap;true;unmodifiableOrderedBidiMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ".bidimap;UnmodifiableOrderedBidiMap;true;inverseOrderedBidiMap;;;Argument[-1].MapKey;ReturnValue.MapValue;value",
          ".bidimap;UnmodifiableOrderedBidiMap;true;inverseOrderedBidiMap;;;Argument[-1].MapValue;ReturnValue.MapKey;value",
          ".bidimap;UnmodifiableSortedBidiMap;true;unmodifiableSortedBidiMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ".bidimap;UnmodifiableSortedBidiMap;true;unmodifiableSortedBidiMap;;;Argument[0].MapValue;ReturnValue.MapValue;value"
        ]
  }
}

/**
 * Value-propagating models for classes in the package `org.apache.commons.collections4.collection`.
 */
private class ApacheCollectionModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      ["org.apache.commons.collections4", "org.apache.commons.collections"] +
        [
          // Note that when lambdas are supported we should have more models for TransformedCollection
          ".collection;AbstractCollectionDecorator;true;AbstractCollectionDecorator;;;Argument[0].Element;Argument[-1].Element;value",
          ".collection;AbstractCollectionDecorator;true;decorated;;;Argument[-1].Element;ReturnValue.Element;value",
          ".collection;AbstractCollectionDecorator;true;setCollection;;;Argument[0].Element;Argument[-1].Element;value",
          ".collection;CompositeCollection$CollectionMutator;true;add;;;Argument[2];Argument[0].Element;value",
          ".collection;CompositeCollection$CollectionMutator;true;add;;;Argument[2];Argument[1].Element.Element;value",
          ".collection;CompositeCollection$CollectionMutator;true;addAll;;;Argument[2].Element;Argument[0].Element;value",
          ".collection;CompositeCollection$CollectionMutator;true;addAll;;;Argument[2].Element;Argument[1].Element.Element;value",
          ".collection;CompositeCollection;true;CompositeCollection;(Collection);;Argument[0].Element;Argument[-1].Element;value",
          ".collection;CompositeCollection;true;CompositeCollection;(Collection,Collection);;Argument[0].Element;Argument[-1].Element;value",
          ".collection;CompositeCollection;true;CompositeCollection;(Collection,Collection);;Argument[1].Element;Argument[-1].Element;value",
          ".collection;CompositeCollection;true;CompositeCollection;(Collection[]);;Argument[0].ArrayElement.Element;Argument[-1].Element;value",
          ".collection;CompositeCollection;true;addComposited;(Collection);;Argument[0].Element;Argument[-1].Element;value",
          ".collection;CompositeCollection;true;addComposited;(Collection,Collection);;Argument[0].Element;Argument[-1].Element;value",
          ".collection;CompositeCollection;true;addComposited;(Collection,Collection);;Argument[1].Element;Argument[-1].Element;value",
          ".collection;CompositeCollection;true;addComposited;(Collection[]);;Argument[0].ArrayElement.Element;Argument[-1].Element;value",
          ".collection;CompositeCollection;true;toCollection;;;Argument[-1].Element;ReturnValue.Element;value",
          ".collection;CompositeCollection;true;getCollections;;;Argument[-1].Element;ReturnValue.Element.Element;value",
          ".collection;IndexedCollection;true;IndexedCollection;;;Argument[0].Element;Argument[-1].Element;value",
          ".collection;IndexedCollection;true;uniqueIndexedCollection;;;Argument[0].Element;ReturnValue.Element;value",
          ".collection;IndexedCollection;true;nonUniqueIndexedCollection;;;Argument[0].Element;ReturnValue.Element;value",
          ".collection;IndexedCollection;true;get;;;Argument[-1].Element;ReturnValue;value",
          ".collection;IndexedCollection;true;values;;;Argument[-1].Element;ReturnValue.Element;value",
          ".collection;PredicatedCollection$Builder;true;add;;;Argument[0];Argument[-1].Element;value",
          ".collection;PredicatedCollection$Builder;true;addAll;;;Argument[0].Element;Argument[-1].Element;value",
          ".collection;PredicatedCollection$Builder;true;createPredicatedList;;;Argument[-1].Element;ReturnValue.Element;value",
          ".collection;PredicatedCollection$Builder;true;createPredicatedList;;;Argument[0].Element;ReturnValue.Element;value",
          ".collection;PredicatedCollection$Builder;true;createPredicatedSet;;;Argument[-1].Element;ReturnValue.Element;value",
          ".collection;PredicatedCollection$Builder;true;createPredicatedSet;;;Argument[0].Element;ReturnValue.Element;value",
          ".collection;PredicatedCollection$Builder;true;createPredicatedMultiSet;;;Argument[-1].Element;ReturnValue.Element;value",
          ".collection;PredicatedCollection$Builder;true;createPredicatedMultiSet;;;Argument[0].Element;ReturnValue.Element;value",
          ".collection;PredicatedCollection$Builder;true;createPredicatedBag;;;Argument[-1].Element;ReturnValue.Element;value",
          ".collection;PredicatedCollection$Builder;true;createPredicatedBag;;;Argument[0].Element;ReturnValue.Element;value",
          ".collection;PredicatedCollection$Builder;true;createPredicatedQueue;;;Argument[-1].Element;ReturnValue.Element;value",
          ".collection;PredicatedCollection$Builder;true;createPredicatedQueue;;;Argument[0].Element;ReturnValue.Element;value",
          ".collection;PredicatedCollection$Builder;true;rejectedElements;;;Argument[-1].Element;ReturnValue.Element;value",
          ".collection;PredicatedCollection;true;predicatedCollection;;;Argument[0].Element;ReturnValue.Element;value",
          ".collection;SynchronizedCollection;true;synchronizedCollection;;;Argument[0].Element;ReturnValue.Element;value",
          ".collection;TransformedCollection;true;transformingCollection;;;Argument[0].Element;ReturnValue.Element;value",
          ".collection;UnmodifiableBoundedCollection;true;unmodifiableBoundedCollection;;;Argument[0].Element;ReturnValue.Element;value",
          ".collection;UnmodifiableCollection;true;unmodifiableCollection;;;Argument[0].Element;ReturnValue.Element;value"
        ]
  }
}

/**
 * Value-propagating models for the package `org.apache.commons.collections4.iterators`.
 */
private class ApacheIteratorsModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      ["org.apache.commons.collections4", "org.apache.commons.collections"] +
        [
          // Note that when lambdas are supported we should have more models for TransformIterator
          ".iterators;AbstractIteratorDecorator;true;AbstractIteratorDecorator;;;Argument[0].Element;Argument[-1].Element;value",
          ".iterators;AbstractListIteratorDecorator;true;AbstractListIteratorDecorator;;;Argument[0].Element;Argument[-1].Element;value",
          ".iterators;AbstractListIteratorDecorator;true;getListIterator;;;Argument[-1].Element;ReturnValue.Element;value",
          ".iterators;AbstractMapIteratorDecorator;true;AbstractMapIteratorDecorator;;;Argument[0].Element;Argument[-1].Element;value",
          ".iterators;AbstractMapIteratorDecorator;true;AbstractMapIteratorDecorator;;;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".iterators;AbstractMapIteratorDecorator;true;getMapIterator;;;Argument[-1].Element;ReturnValue.Element;value",
          ".iterators;AbstractMapIteratorDecorator;true;getMapIterator;;;Argument[-1].MapValue;ReturnValue.MapValue;value",
          ".iterators;AbstractOrderedMapIteratorDecorator;true;AbstractOrderedMapIteratorDecorator;;;Argument[0].Element;Argument[-1].Element;value",
          ".iterators;AbstractOrderedMapIteratorDecorator;true;AbstractOrderedMapIteratorDecorator;;;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".iterators;AbstractOrderedMapIteratorDecorator;true;getOrderedMapIterator;;;Argument[-1].Element;ReturnValue.Element;value",
          ".iterators;AbstractOrderedMapIteratorDecorator;true;getOrderedMapIterator;;;Argument[-1].MapValue;ReturnValue.MapValue;value",
          ".iterators;AbstractUntypedIteratorDecorator;true;AbstractUntypedIteratorDecorator;;;Argument[0].Element;Argument[-1].Element;value",
          ".iterators;AbstractUntypedIteratorDecorator;true;getIterator;;;Argument[-1].Element;ReturnValue.Element;value",
          ".iterators;ArrayIterator;true;ArrayIterator;;;Argument[0].ArrayElement;Argument[-1].Element;value",
          ".iterators;ArrayIterator;true;getArray;;;Argument[-1].Element;ReturnValue.ArrayElement;value",
          ".iterators;ArrayListIterator;true;ArrayListIterator;;;Argument[0].ArrayElement;Argument[-1].Element;value",
          ".iterators;BoundedIterator;true;BoundedIterator;;;Argument[0].Element;Argument[-1].Element;value",
          ".iterators;CollatingIterator;true;CollatingIterator;(Comparator,Iterator,Iterator);;Argument[1].Element;Argument[-1].Element;value",
          ".iterators;CollatingIterator;true;CollatingIterator;(Comparator,Iterator,Iterator);;Argument[2].Element;Argument[-1].Element;value",
          ".iterators;CollatingIterator;true;CollatingIterator;(Comparator,Iterator[]);;Argument[1].ArrayElement.Element;Argument[-1].Element;value",
          ".iterators;CollatingIterator;true;CollatingIterator;(Comparator,Collection);;Argument[1].Element.Element;Argument[-1].Element;value",
          ".iterators;CollatingIterator;true;addIterator;;;Argument[0].Element;Argument[-1].Element;value",
          ".iterators;CollatingIterator;true;setIterator;;;Argument[1].Element;Argument[-1].Element;value",
          ".iterators;CollatingIterator;true;getIterators;;;Argument[-1].Element;ReturnValue.Element.Element;value",
          ".iterators;EnumerationIterator;true;EnumerationIterator;;;Argument[0].Element;Argument[-1].Element;value",
          ".iterators;EnumerationIterator;true;getEnumeration;;;Argument[-1].Element;ReturnValue.Element;value",
          ".iterators;EnumerationIterator;true;setEnumeration;;;Argument[0].Element;Argument[-1].Element;value",
          ".iterators;FilterIterator;true;FilterIterator;;;Argument[0].Element;Argument[-1].Element;value",
          ".iterators;FilterIterator;true;getIterator;;;Argument[-1].Element;ReturnValue.Element;value",
          ".iterators;FilterIterator;true;setIterator;;;Argument[0].Element;Argument[-1].Element;value",
          ".iterators;FilterListIterator;true;FilterListIterator;(ListIterator);;Argument[0].Element;Argument[-1].Element;value",
          ".iterators;FilterListIterator;true;FilterListIterator;(ListIterator,Predicate);;Argument[0].Element;Argument[-1].Element;value",
          ".iterators;FilterListIterator;true;getListIterator;;;Argument[-1].Element;ReturnValue.Element;value",
          ".iterators;FilterListIterator;true;setListIterator;;;Argument[0].Element;Argument[-1].Element;value",
          ".iterators;IteratorChain;true;IteratorChain;(Iterator);;Argument[0].Element;Argument[-1].Element;value",
          ".iterators;IteratorChain;true;IteratorChain;(Iterator,Iterator);;Argument[0].Element;Argument[-1].Element;value",
          ".iterators;IteratorChain;true;IteratorChain;(Iterator,Iterator);;Argument[1].Element;Argument[-1].Element;value",
          ".iterators;IteratorChain;true;IteratorChain;(Iterator[]);;Argument[0].ArrayElement.Element;Argument[-1].Element;value",
          ".iterators;IteratorChain;true;IteratorChain;(Collection);;Argument[0].Element.Element;Argument[-1].Element;value",
          ".iterators;IteratorChain;true;addIterator;;;Argument[0].Element;Argument[-1].Element;value",
          ".iterators;IteratorEnumeration;true;IteratorEnumeration;;;Argument[0].Element;Argument[-1].Element;value",
          ".iterators;IteratorEnumeration;true;getIterator;;;Argument[-1].Element;ReturnValue.Element;value",
          ".iterators;IteratorEnumeration;true;setIterator;;;Argument[0].Element;Argument[-1].Element;value",
          ".iterators;IteratorIterable;true;IteratorIterable;;;Argument[0].Element;Argument[-1].Element;value",
          ".iterators;ListIteratorWrapper;true;ListIteratorWrapper;;;Argument[0].Element;Argument[-1].Element;value",
          ".iterators;LoopingIterator;true;LoopingIterator;;;Argument[0].Element;Argument[-1].Element;value",
          ".iterators;LoopingListIterator;true;LoopingListIterator;;;Argument[0].Element;Argument[-1].Element;value",
          ".iterators;ObjectArrayIterator;true;ObjectArrayIterator;;;Argument[0].ArrayElement;Argument[-1].Element;value",
          ".iterators;ObjectArrayIterator;true;getArray;;;Argument[-1].Element;ReturnValue.ArrayElement;value",
          ".iterators;ObjectArrayListIterator;true;ObjectArrayListIterator;;;Argument[0].ArrayElement;Argument[-1].Element;value",
          ".iterators;PeekingIterator;true;PeekingIterator;;;Argument[0].Element;Argument[-1].Element;value",
          ".iterators;PeekingIterator;true;peekingIterator;;;Argument[0].Element;ReturnValue.Element;value",
          ".iterators;PeekingIterator;true;peek;;;Argument[-1].Element;ReturnValue;value",
          ".iterators;PeekingIterator;true;element;;;Argument[-1].Element;ReturnValue;value",
          ".iterators;PermutationIterator;true;PermutationIterator;;;Argument[0].Element;Argument[-1].Element.Element;value",
          ".iterators;PushbackIterator;true;PushbackIterator;;;Argument[0].Element;Argument[-1].Element;value",
          ".iterators;PushbackIterator;true;pushbackIterator;;;Argument[0].Element;ReturnValue.Element;value",
          ".iterators;PushbackIterator;true;pushback;;;Argument[0];Argument[-1].Element;value",
          ".iterators;ReverseListIterator;true;ReverseListIterator;;;Argument[0].Element;Argument[-1].Element;value",
          ".iterators;SingletonIterator;true;SingletonIterator;;;Argument[0];Argument[-1].Element;value",
          ".iterators;SingletonListIterator;true;SingletonListIterator;;;Argument[0];Argument[-1].Element;value",
          ".iterators;SkippingIterator;true;SkippingIterator;;;Argument[0].Element;Argument[-1].Element;value",
          ".iterators;UniqueFilterIterator;true;UniqueFilterIterator;;;Argument[0].Element;Argument[-1].Element;value",
          ".iterators;UnmodifiableIterator;true;unmodifiableIterator;;;Argument[0].Element;ReturnValue.Element;value",
          ".iterators;UnmodifiableListIterator;true;umodifiableListIterator;;;Argument[0].Element;ReturnValue.Element;value",
          ".iterators;UnmodifiableMapIterator;true;unmodifiableMapIterator;;;Argument[0].Element;ReturnValue.Element;value",
          ".iterators;UnmodifiableMapIterator;true;unmodifiableMapIterator;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ".iterators;UnmodifiableOrderedMapIterator;true;unmodifiableOrderedMapIterator;;;Argument[0].Element;ReturnValue.Element;value",
          ".iterators;UnmodifiableOrderedMapIterator;true;unmodifiableOrderedMapIterator;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ".iterators;ZippingIterator;true;ZippingIterator;(Iterator[]);;Argument[0].ArrayElement.Element;Argument[-1].Element;value",
          ".iterators;ZippingIterator;true;ZippingIterator;(Iterator,Iterator);;Argument[0].Element;Argument[-1].Element;value",
          ".iterators;ZippingIterator;true;ZippingIterator;(Iterator,Iterator);;Argument[1].Element;Argument[-1].Element;value",
          ".iterators;ZippingIterator;true;ZippingIterator;(Iterator,Iterator,Iterator);;Argument[0].Element;Argument[-1].Element;value",
          ".iterators;ZippingIterator;true;ZippingIterator;(Iterator,Iterator,Iterator);;Argument[1].Element;Argument[-1].Element;value",
          ".iterators;ZippingIterator;true;ZippingIterator;(Iterator,Iterator,Iterator);;Argument[2].Element;Argument[-1].Element;value"
        ]
  }
}

/**
 * Value-propagating models for the package `org.apache.commons.collections4.list`.
 */
private class ApacheListModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      ["org.apache.commons.collections4", "org.apache.commons.collections"] +
        [
          // Note that when lambdas are supported we should have more models for TransformedList
          ".list;AbstractLinkedList;true;AbstractLinkedList;;;Argument[0].Element;Argument[-1].Element;value",
          ".list;AbstractLinkedList;true;getFirst;;;Argument[-1].Element;ReturnValue;value",
          ".list;AbstractLinkedList;true;getLast;;;Argument[-1].Element;ReturnValue;value",
          ".list;AbstractLinkedList;true;addFirst;;;Argument[0];Argument[-1].Element;value",
          ".list;AbstractLinkedList;true;addLast;;;Argument[0];Argument[-1].Element;value",
          ".list;AbstractLinkedList;true;removeFirst;;;Argument[-1].Element;ReturnValue;value",
          ".list;AbstractLinkedList;true;removeLast;;;Argument[-1].Element;ReturnValue;value",
          ".list;AbstractListDecorator;true;AbstractListDecorator;;;Argument[0].Element;Argument[-1].Element;value",
          ".list;AbstractSerializableListDecorator;true;AbstractSerializableListDecorator;;;Argument[0].Element;Argument[-1].Element;value",
          ".list;CursorableLinkedList;true;CursorableLinkedList;;;Argument[0].Element;Argument[-1].Element;value",
          ".list;CursorableLinkedList;true;cursor;;;Argument[-1].Element;ReturnValue.Element;value",
          ".list;FixedSizeList;true;fixedSizeList;;;Argument[0].Element;ReturnValue.Element;value",
          ".list;GrowthList;true;growthList;;;Argument[0].Element;ReturnValue.Element;value",
          ".list;LazyList;true;lazyList;;;Argument[0].Element;ReturnValue.Element;value",
          ".list;NodeCachingLinkedList;true;NodeCachingLinkedList;(Collection);;Argument[0].Element;Argument[-1].Element;value",
          ".list;PredicatedList;true;predicatedList;;;Argument[0].Element;ReturnValue.Element;value",
          ".list;SetUniqueList;true;setUniqueList;;;Argument[0].Element;ReturnValue.Element;value",
          ".list;SetUniqueList;true;asSet;;;Argument[-1].Element;ReturnValue.Element;value",
          ".list;TransformedList;true;transformingList;;;Argument[0].Element;ReturnValue.Element;value",
          ".list;TreeList;true;TreeList;;;Argument[0].Element;Argument[-1].Element;value",
          ".list;UnmodifiableList;true;UnmodifiableList;;;Argument[0].Element;Argument[-1].Element;value",
          ".list;UnmodifiableList;true;unmodifiableList;;;Argument[0].Element;ReturnValue.Element;value"
        ]
  }
}

/**
 * Value-propagating models for the package `org.apache.commons.collections4.map`.
 */
private class ApacheMapModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      ["org.apache.commons.collections4", "org.apache.commons.collections"] +
        [
          // Note that when lambdas are supported we should have more models for DefaultedMap, LazyMap, TransformedMap, TransformedSortedMap
          ".map;AbstractHashedMap;true;AbstractHashedMap;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".map;AbstractHashedMap;true;AbstractHashedMap;(Map);;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".map;AbstractLinkedMap;true;AbstractLinkedMap;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".map;AbstractLinkedMap;true;AbstractLinkedMap;(Map);;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".map;AbstractMapDecorator;true;AbstractMapDecorator;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".map;AbstractMapDecorator;true;AbstractMapDecorator;(Map);;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".map;AbstractMapDecorator;true;decorated;;;Argument[-1].MapKey;ReturnValue.MapKey;value",
          ".map;AbstractMapDecorator;true;decorated;;;Argument[-1].MapValue;ReturnValue.MapValue;value",
          ".map;AbstractOrderedMapDecorator;true;AbstractOrderedMapDecorator;(OrderedMap);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".map;AbstractOrderedMapDecorator;true;AbstractOrderedMapDecorator;(OrderedMap);;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".map;AbstractSortedMapDecorator;true;AbstractSortedMapDecorator;(SortedMap);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".map;AbstractSortedMapDecorator;true;AbstractSortedMapDecorator;(SortedMap);;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".map;CaseInsensitiveMap;true;CaseInsensitiveMap;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".map;CaseInsensitiveMap;true;CaseInsensitiveMap;(Map);;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".map;CompositeMap;true;CompositeMap;(Map,Map);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".map;CompositeMap;true;CompositeMap;(Map,Map);;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".map;CompositeMap;true;CompositeMap;(Map,Map);;Argument[1].MapKey;Argument[-1].MapKey;value",
          ".map;CompositeMap;true;CompositeMap;(Map,Map);;Argument[1].MapValue;Argument[-1].MapValue;value",
          ".map;CompositeMap;true;CompositeMap;(Map,Map,MapMutator);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".map;CompositeMap;true;CompositeMap;(Map,Map,MapMutator);;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".map;CompositeMap;true;CompositeMap;(Map,Map,MapMutator);;Argument[1].MapKey;Argument[-1].MapKey;value",
          ".map;CompositeMap;true;CompositeMap;(Map,Map,MapMutator);;Argument[1].MapValue;Argument[-1].MapValue;value",
          ".map;CompositeMap;true;CompositeMap;(Map[]);;Argument[0].ArrayElement.MapKey;Argument[-1].MapKey;value",
          ".map;CompositeMap;true;CompositeMap;(Map[]);;Argument[0].ArrayElement.MapValue;Argument[-1].MapValue;value",
          ".map;CompositeMap;true;CompositeMap;(Map[],MapMutator);;Argument[0].ArrayElement.MapKey;Argument[-1].MapKey;value",
          ".map;CompositeMap;true;CompositeMap;(Map[],MapMutator);;Argument[0].ArrayElement.MapValue;Argument[-1].MapValue;value",
          ".map;CompositeMap;true;addComposited;;;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".map;CompositeMap;true;addComposited;;;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".map;CompositeMap;true;removeComposited;;;Argument[-1].MapKey;ReturnValue.MapKey;value",
          ".map;CompositeMap;true;removeComposited;;;Argument[-1].MapValue;ReturnValue.MapValue;value",
          ".map;CompositeMap;true;removeComposited;;;Argument[0];ReturnValue;value",
          ".map;DefaultedMap;true;DefaultedMap;(Object);;Argument[0];Argument[-1].MapValue;value",
          ".map;DefaultedMap;true;defaultedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ".map;DefaultedMap;true;defaultedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ".map;DefaultedMap;true;defaultedMap;(Map,Object);;Argument[1];ReturnValue.MapValue;value",
          ".map;EntrySetToMapIteratorAdapter;true;EntrySetToMapIteratorAdapter;;;Argument[0].Element.MapKey;Argument[-1].Element;value",
          ".map;EntrySetToMapIteratorAdapter;true;EntrySetToMapIteratorAdapter;;;Argument[0].Element.MapValue;Argument[-1].MapValue;value",
          ".map;FixedSizeMap;true;fixedSizeMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ".map;FixedSizeMap;true;fixedSizeMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ".map;FixedSizeSortedMap;true;fixedSizeSortedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ".map;FixedSizeSortedMap;true;fixedSizeSortedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ".map;Flat3Map;true;Flat3Map;;;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".map;Flat3Map;true;Flat3Map;;;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".map;HashedMap;true;HashedMap;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".map;HashedMap;true;HashedMap;(Map);;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".map;LazyMap;true;lazyMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ".map;LazyMap;true;lazyMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ".map;LazySortedMap;true;lazySortedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ".map;LazySortedMap;true;lazySortedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ".map;LinkedMap;true;LinkedMap;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".map;LinkedMap;true;LinkedMap;(Map);;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".map;LinkedMap;true;get;(int);;Argument[-1].MapKey;ReturnValue;value",
          ".map;LinkedMap;true;getValue;(int);;Argument[-1].MapValue;ReturnValue;value",
          ".map;LinkedMap;true;remove;(int);;Argument[-1].MapValue;ReturnValue;value",
          ".map;LinkedMap;true;asList;;;Argument[-1].MapKey;ReturnValue.Element;value",
          ".map;ListOrderedMap;true;listOrderedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ".map;ListOrderedMap;true;listOrderedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ".map;ListOrderedMap;true;putAll;;;Argument[1].MapKey;Argument[-1].MapKey;value",
          ".map;ListOrderedMap;true;putAll;;;Argument[1].MapValue;Argument[-1].MapValue;value",
          ".map;ListOrderedMap;true;keyList;;;Argument[-1].MapKey;ReturnValue.Element;value",
          ".map;ListOrderedMap;true;valueList;;;Argument[-1].MapValue;ReturnValue.Element;value",
          ".map;ListOrderedMap;true;get;(int);;Argument[-1].MapKey;ReturnValue;value",
          ".map;ListOrderedMap;true;getValue;(int);;Argument[-1].MapValue;ReturnValue;value",
          ".map;ListOrderedMap;true;setValue;;;Argument[1];Argument[-1].MapValue;value",
          ".map;ListOrderedMap;true;put;;;Argument[1];Argument[-1].MapKey;value",
          ".map;ListOrderedMap;true;put;;;Argument[2];Argument[-1].MapValue;value",
          ".map;ListOrderedMap;true;remove;(int);;Argument[-1].MapValue;ReturnValue;value",
          ".map;ListOrderedMap;true;asList;;;Argument[-1].MapKey;ReturnValue.Element;value",
          ".map;LRUMap;true;LRUMap;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".map;LRUMap;true;LRUMap;(Map);;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".map;LRUMap;true;LRUMap;(Map,boolean);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".map;LRUMap;true;LRUMap;(Map,boolean);;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".map;LRUMap;true;get;(Object,boolean);;Argument[0].MapValue;ReturnValue;value",
          ".map;MultiKeyMap;true;get;;;Argument[-1].MapValue;ReturnValue;value",
          ".map;MultiKeyMap;true;put;;;Argument[-1].MapValue;ReturnValue;value",
          ".map;MultiKeyMap;true;put;(Object,Object,Object);;Argument[0..1];Argument[-1].MapKey.Element;value",
          ".map;MultiKeyMap;true;put;(Object,Object,Object,Object);;Argument[0..2];Argument[-1].MapKey.Element;value",
          ".map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object);;Argument[0..3];Argument[-1].MapKey.Element;value",
          ".map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object,Object);;Argument[0..4];Argument[-1].MapKey.Element;value",
          ".map;MultiKeyMap;true;put;(Object,Object,Object);;Argument[2];Argument[-1].MapValue;value",
          ".map;MultiKeyMap;true;put;(Object,Object,Object,Object);;Argument[3];Argument[-1].MapValue;value",
          ".map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object);;Argument[4];Argument[-1].MapValue;value",
          ".map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object,Object);;Argument[5];Argument[-1].MapValue;value",
          ".map;MultiKeyMap;true;removeMultiKey;;;Argument[-1].MapValue;ReturnValue;value",
          ".map;MultiValueMap;true;multiValueMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ".map;MultiValueMap;true;multiValueMap;;;Argument[0].MapValue.Element;ReturnValue.MapValue.Element;value",
          ".map;MultiValueMap;true;getCollection;;;Argument[-1].MapValue.Element;ReturnValue.Element;value",
          ".map;MultiValueMap;true;putAll;(Map);;Argument[0].MapValue;Argument[-1].MapValue.Element;value",
          ".map;MultiValueMap;true;putAll;(Map);;Argument[0].MapValue.Element;Argument[-1].MapValue.Element;value",
          ".map;MultiValueMap;true;values;;;Argument[-1].MapValue.Element;ReturnValue.Element;value",
          ".map;MultiValueMap;true;putAll;(Object,Collection);;Argument[0];Argument[-1].MapKey;value",
          ".map;MultiValueMap;true;putAll;(Object,Collection);;Argument[1].Element;Argument[-1].MapValue.Element;value",
          ".map;MultiValueMap;true;iterator;(Object);;Argument[-1].MapValue.Element;ReturnValue.Element;value",
          ".map;MultiValueMap;true;iterator;();;Argument[-1].MapKey;ReturnValue.Element.MapKey;value",
          ".map;MultiValueMap;true;iterator;();;Argument[-1].MapValue.Element;ReturnValue.Element.MapValue;value",
          ".map;PassiveExpiringMap;true;PassiveExpiringMap;(ExpirationPolicy,Map);;Argument[1].MapKey;Argument[-1].MapKey;value",
          ".map;PassiveExpiringMap;true;PassiveExpiringMap;(ExpirationPolicy,Map);;Argument[1].MapValue;Argument[-1].MapValue;value",
          ".map;PassiveExpiringMap;true;PassiveExpiringMap;(long,Map);;Argument[1].MapKey;Argument[-1].MapKey;value",
          ".map;PassiveExpiringMap;true;PassiveExpiringMap;(long,Map);;Argument[1].MapValue;Argument[-1].MapValue;value",
          ".map;PassiveExpiringMap;true;PassiveExpiringMap;(long,TimeUnit,Map);;Argument[2].MapKey;Argument[-1].MapKey;value",
          ".map;PassiveExpiringMap;true;PassiveExpiringMap;(long,TimeUnit,Map);;Argument[2].MapValue;Argument[-1].MapValue;value",
          ".map;PassiveExpiringMap;true;PassiveExpiringMap;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".map;PassiveExpiringMap;true;PassiveExpiringMap;(Map);;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".map;PredicatedMap;true;predicatedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ".map;PredicatedMap;true;predicatedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ".map;PredicatedSortedMap;true;predicatedSortedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ".map;PredicatedSortedMap;true;predicatedSortedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ".map;SingletonMap;true;SingletonMap;(Object,Object);;Argument[0];Argument[-1].MapKey;value",
          ".map;SingletonMap;true;SingletonMap;(Object,Object);;Argument[1];Argument[-1].MapValue;value",
          ".map;SingletonMap;true;SingletonMap;(KeyValue);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".map;SingletonMap;true;SingletonMap;(KeyValue);;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".map;SingletonMap;true;SingletonMap;(Entry);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".map;SingletonMap;true;SingletonMap;(Entry);;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".map;SingletonMap;true;SingletonMap;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".map;SingletonMap;true;SingletonMap;(Map);;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".map;SingletonMap;true;setValue;;;Argument[0];Argument[-1].MapValue;value",
          ".map;TransformedMap;true;transformingMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ".map;TransformedMap;true;transformingMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ".map;TransformedSortedMap;true;transformingSortedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ".map;TransformedSortedMap;true;transformingSortedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ".map;UnmodifiableEntrySet;true;unmodifiableEntrySet;;;Argument[0].Element.MapKey;ReturnValue.Element.MapKey;value",
          ".map;UnmodifiableEntrySet;true;unmodifiableEntrySet;;;Argument[0].Element.MapValue;ReturnValue.Element.MapValue;value",
          ".map;UnmodifiableMap;true;unmodifiableMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ".map;UnmodifiableMap;true;unmodifiableMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ".map;UnmodifiableOrderedMap;true;unmodifiableOrderedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ".map;UnmodifiableOrderedMap;true;unmodifiableOrderedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ".map;UnmodifiableSortedMap;true;unmodifiableSortedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ".map;UnmodifiableSortedMap;true;unmodifiableSortedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value"
        ]
  }
}

/**
 * Value-propagating models for the package `org.apache.commons.collections4.multimap`.
 */
private class ApacheMultiMapModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      ["org.apache.commons.collections4", "org.apache.commons.collections"] +
        [
          // Note that when lambdas are supported we should have more models for TransformedMultiValuedMap
          ".multimap;ArrayListValuedHashMap;true;ArrayListValuedHashMap;(MultiValuedMap);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".multimap;ArrayListValuedHashMap;true;ArrayListValuedHashMap;(MultiValuedMap);;Argument[0].MapValue.Element;Argument[-1].MapValue.Element;value",
          ".multimap;ArrayListValuedHashMap;true;ArrayListValuedHashMap;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".multimap;ArrayListValuedHashMap;true;ArrayListValuedHashMap;(Map);;Argument[0].MapValue;Argument[-1].MapValue.Element;value",
          ".multimap;HashSetValuedHashMap;true;HashSetValuedHashMap;(MultiValuedMap);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".multimap;HashSetValuedHashMap;true;HashSetValuedHashMap;(MultiValuedMap);;Argument[0].MapValue.Element;Argument[-1].MapValue.Element;value",
          ".multimap;HashSetValuedHashMap;true;HashSetValuedHashMap;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".multimap;HashSetValuedHashMap;true;HashSetValuedHashMap;(Map);;Argument[0].MapValue;Argument[-1].MapValue.Element;value",
          ".multimap;TransformedMultiValuedMap;true;transformingMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ".multimap;TransformedMultiValuedMap;true;transformingMap;;;Argument[0].MapValue.Element;ReturnValue.MapValue.Element;value",
          ".multimap;UnmodifiableMultiValuedMap;true;unmodifiableMultiValuedMap;(MultiValuedMap);;Argument[0].MapKey;ReturnValue.MapKey;value",
          ".multimap;UnmodifiableMultiValuedMap;true;unmodifiableMultiValuedMap;(MultiValuedMap);;Argument[0].MapValue.Element;ReturnValue.MapValue.Element;value"
        ]
  }
}

/**
 * Value-propagating models for the package `org.apache.commons.collections4.multiset`.
 */
private class ApacheMultiSetModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      ["org.apache.commons.collections4", "org.apache.commons.collections"] +
        [
          ".multiset;HashMultiSet;true;HashMultiSet;;;Argument[0].Element;Argument[-1].Element;value",
          ".multiset;PredicatedMultiSet;true;predicatedMultiSet;;;Argument[0].Element;ReturnValue.Element;value",
          ".multiset;SynchronizedMultiSet;true;synchronizedMultiSet;;;Argument[0].Element;ReturnValue.Element;value",
          ".multiset;UnmodifiableMultiSet;true;unmodifiableMultiSet;;;Argument[0].Element;ReturnValue.Element;value"
        ]
  }
}

/**
 * Value-propagating models for the package `org.apache.commons.collections4.properties`.
 */
private class ApachePropertiesModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      ["org.apache.commons.collections4", "org.apache.commons.collections"] +
        [
          ".properties;AbstractPropertiesFactory;true;load;(ClassLoader,String);;Argument[1];ReturnValue;taint",
          ".properties;AbstractPropertiesFactory;true;load;(File);;Argument[0];ReturnValue;taint",
          ".properties;AbstractPropertiesFactory;true;load;(InputStream);;Argument[0];ReturnValue;taint",
          ".properties;AbstractPropertiesFactory;true;load;(Path);;Argument[0];ReturnValue;taint",
          ".properties;AbstractPropertiesFactory;true;load;(Reader);;Argument[0];ReturnValue;taint",
          ".properties;AbstractPropertiesFactory;true;load;(String);;Argument[0];ReturnValue;taint",
          ".properties;AbstractPropertiesFactory;true;load;(URI);;Argument[0];ReturnValue;taint",
          ".properties;AbstractPropertiesFactory;true;load;(URL);;Argument[0];ReturnValue;taint"
        ]
  }
}

/**
 * Value-propagating models for the package `org.apache.commons.collections4.queue`.
 */
private class ApacheQueueModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      ["org.apache.commons.collections4", "org.apache.commons.collections"] +
        [
          // Note that when lambdas are supported we should have more models for TransformedQueue
          ".queue;CircularFifoQueue;true;CircularFifoQueue;(Collection);;Argument[0].Element;Argument[-1].Element;value",
          ".queue;CircularFifoQueue;true;get;;;Argument[-1].Element;ReturnValue;value",
          ".queue;PredicatedQueue;true;predicatedQueue;;;Argument[0].Element;ReturnValue.Element;value",
          ".queue;SynchronizedQueue;true;synchronizedQueue;;;Argument[0].Element;ReturnValue.Element;value",
          ".queue;TransformedQueue;true;transformingQueue;;;Argument[0].Element;ReturnValue.Element;value",
          ".queue;UnmodifiableQueue;true;unmodifiableQueue;;;Argument[0].Element;ReturnValue.Element;value"
        ]
  }
}

/**
 * Value-propagating models for the package `org.apache.commons.collections4.set`.
 */
private class ApacheSetModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      ["org.apache.commons.collections4", "org.apache.commons.collections"] +
        [
          // Note that when lambdas are supported we should have more models for TransformedNavigableSet
          ".set;AbstractNavigableSetDecorator;true;AbstractNavigableSetDecorator;;;Argument[0].Element;Argument[-1].Element;value",
          ".set;AbstractSetDecorator;true;AbstractSetDecorator;;;Argument[0].Element;Argument[-1].Element;value",
          ".set;AbstractSortedSetDecorator;true;AbstractSortedSetDecorator;;;Argument[0].Element;Argument[-1].Element;value",
          ".set;CompositeSet$SetMutator;true;add;;;Argument[2];Argument[0].Element;value",
          ".set;CompositeSet$SetMutator;true;add;;;Argument[2];Argument[1].Element.Element;value",
          ".set;CompositeSet$SetMutator;true;addAll;;;Argument[2].Element;Argument[0].Element;value",
          ".set;CompositeSet$SetMutator;true;addAll;;;Argument[2].Element;Argument[1].Element.Element;value",
          ".set;CompositeSet;true;CompositeSet;(Set);;Argument[0].Element;Argument[-1].Element;value",
          ".set;CompositeSet;true;CompositeSet;(Set[]);;Argument[0].ArrayElement.Element;Argument[-1].Element;value",
          ".set;CompositeSet;true;addComposited;(Set);;Argument[0].Element;Argument[-1].Element;value",
          ".set;CompositeSet;true;addComposited;(Set,Set);;Argument[0].Element;Argument[-1].Element;value",
          ".set;CompositeSet;true;addComposited;(Set,Set);;Argument[1].Element;Argument[-1].Element;value",
          ".set;CompositeSet;true;addComposited;(Set[]);;Argument[0].ArrayElement.Element;Argument[-1].Element;value",
          ".set;CompositeSet;true;toSet;;;Argument[-1].Element;ReturnValue.Element;value",
          ".set;CompositeSet;true;getSets;;;Argument[-1].Element;ReturnValue.Element.Element;value",
          ".set;ListOrderedSet;true;listOrderedSet;(Set);;Argument[0].Element;ReturnValue.Element;value",
          ".set;ListOrderedSet;true;listOrderedSet;(List);;Argument[0].Element;ReturnValue.Element;value",
          ".set;ListOrderedSet;true;asList;;;Argument[-1].Element;ReturnValue.Element;value",
          ".set;ListOrderedSet;true;get;;;Argument[-1].Element;ReturnValue;value",
          ".set;ListOrderedSet;true;add;;;Argument[1];Argument[-1].Element;value",
          ".set;ListOrderedSet;true;addAll;;;Argument[1].Element;Argument[-1].Element;value",
          ".set;MapBackedSet;true;mapBackedSet;;;Argument[0].MapKey;ReturnValue.Element;value",
          ".set;PredicatedNavigableSet;true;predicatedNavigableSet;;;Argument[0].Element;ReturnValue.Element;value",
          ".set;PredicatedSet;true;predicatedSet;;;Argument[0].Element;ReturnValue.Element;value",
          ".set;PredicatedSortedSet;true;predicatedSortedSet;;;Argument[0].Element;ReturnValue.Element;value",
          ".set;TransformedNavigableSet;true;transformingNavigableSet;;;Argument[0].Element;ReturnValue.Element;value",
          ".set;TransformedSet;true;transformingSet;;;Argument[0].Element;ReturnValue.Element;value",
          ".set;TransformedSortedSet;true;transformingSortedSet;;;Argument[0].Element;ReturnValue.Element;value",
          ".set;UnmodifiableNavigableSet;true;unmodifiableNavigableSet;;;Argument[0].Element;ReturnValue.Element;value",
          ".set;UnmodifiableSet;true;unmodifiableSet;;;Argument[0].Element;ReturnValue.Element;value",
          ".set;UnmodifiableSortedSet;true;unmodifiableSortedSet;;;Argument[0].Element;ReturnValue.Element;value"
        ]
  }
}

/**
 * Value-propagating models for the package `org.apache.commons.collections4.splitmap`.
 */
private class ApacheSplitMapModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      ["org.apache.commons.collections4", "org.apache.commons.collections"] +
        [
          // Note that when lambdas are supported we should have more models for TransformedSplitMap
          ".splitmap;AbstractIterableGetMapDecorator;true;AbstractIterableGetMapDecorator;;;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".splitmap;AbstractIterableGetMapDecorator;true;AbstractIterableGetMapDecorator;;;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".splitmap;TransformedSplitMap;true;transformingMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ".splitmap;TransformedSplitMap;true;transformingMap;;;Argument[0].MapValue;ReturnValue.MapValue;value"
        ]
  }
}

/**
 * Value-propagating models for the package `org.apache.commons.collections4.trie`.
 */
private class ApacheTrieModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      ["org.apache.commons.collections4", "org.apache.commons.collections"] +
        [
          // Note that when lambdas are supported we should have more models for TransformedSplitMap
          ".trie;PatriciaTrie;true;PatriciaTrie;;;Argument[0].MapKey;Argument[-1].MapKey;value",
          ".trie;PatriciaTrie;true;PatriciaTrie;;;Argument[0].MapValue;Argument[-1].MapValue;value",
          ".trie;AbstractPatriciaTrie;true;select;;;Argument[-1].MapKey;ReturnValue.MapKey;value",
          ".trie;AbstractPatriciaTrie;true;select;;;Argument[-1].MapValue;ReturnValue.MapValue;value",
          ".trie;AbstractPatriciaTrie;true;selectKey;;;Argument[-1].MapKey;ReturnValue;value",
          ".trie;AbstractPatriciaTrie;true;selectValue;;;Argument[-1].MapValue;ReturnValue;value",
          ".trie;UnmodifiableTrie;true;unmodifiableTrie;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ".trie;UnmodifiableTrie;true;unmodifiableTrie;;;Argument[0].MapValue;ReturnValue.MapValue;value"
        ]
  }
}

/**
 * Value-propagating models for the class `org.apache.commons.collections4.MapUtils`.
 */
private class ApacheMapUtilsModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      ["org.apache.commons.collections4", "org.apache.commons.collections"] +
        [
          // Note that when lambdas are supported we should have more models for populateMap
          ";MapUtils;true;emptyIfNull;;;Argument[0];ReturnValue;value",
          ";MapUtils;true;fixedSizeMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ";MapUtils;true;fixedSizeMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ";MapUtils;true;fixedSizeSortedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ";MapUtils;true;fixedSizeSortedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ";MapUtils;true;getMap;;;Argument[0].MapValue;ReturnValue;value",
          ";MapUtils;true;getMap;;;Argument[2];ReturnValue;value",
          ";MapUtils;true;getObject;;;Argument[0].MapValue;ReturnValue;value",
          ";MapUtils;true;getObject;;;Argument[2];ReturnValue;value",
          ";MapUtils;true;getString;;;Argument[0].MapValue;ReturnValue;value",
          ";MapUtils;true;getString;;;Argument[2];ReturnValue;value",
          ";MapUtils;true;invertMap;;;Argument[0].MapKey;ReturnValue.MapValue;value",
          ";MapUtils;true;invertMap;;;Argument[0].MapValue;ReturnValue.MapKey;value",
          ";MapUtils;true;iterableMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ";MapUtils;true;iterableMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ";MapUtils;true;iterableSortedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ";MapUtils;true;iterableSortedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ";MapUtils;true;lazyMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ";MapUtils;true;lazyMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ";MapUtils;true;lazySortedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ";MapUtils;true;lazySortedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ";MapUtils;true;multiValueMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ";MapUtils;true;multiValueMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ";MapUtils;true;orderedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ";MapUtils;true;orderedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ";MapUtils;true;populateMap;(Map,Iterable,Transformer);;Argument[1].Element;Argument[0].MapValue;value",
          ";MapUtils;true;populateMap;(MultiMap,Iterable,Transformer);;Argument[1].Element;Argument[0].MapValue.Element;value",
          ";MapUtils;true;predicatedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ";MapUtils;true;predicatedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ";MapUtils;true;predicatedSortedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ";MapUtils;true;predicatedSortedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ";MapUtils;true;putAll;;;Argument[1].ArrayElement;Argument[0].MapKey;value",
          ";MapUtils;true;putAll;;;Argument[1].ArrayElement;ReturnValue.MapKey;value",
          ";MapUtils;true;putAll;;;Argument[1].ArrayElement;Argument[0].MapValue;value",
          ";MapUtils;true;putAll;;;Argument[1].ArrayElement;ReturnValue.MapValue;value",
          ";MapUtils;true;putAll;;;Argument[1].ArrayElement.ArrayElement;Argument[0].MapKey;value",
          ";MapUtils;true;putAll;;;Argument[1].ArrayElement.ArrayElement;ReturnValue.MapKey;value",
          ";MapUtils;true;putAll;;;Argument[1].ArrayElement.ArrayElement;Argument[0].MapValue;value",
          ";MapUtils;true;putAll;;;Argument[1].ArrayElement.ArrayElement;ReturnValue.MapValue;value",
          ";MapUtils;true;putAll;;;Argument[1].ArrayElement.MapKey;Argument[0].MapKey;value",
          ";MapUtils;true;putAll;;;Argument[1].ArrayElement.MapKey;ReturnValue.MapKey;value",
          ";MapUtils;true;putAll;;;Argument[1].ArrayElement.MapValue;Argument[0].MapValue;value",
          ";MapUtils;true;putAll;;;Argument[1].ArrayElement.MapValue;ReturnValue.MapValue;value",
          ";MapUtils;true;safeAddToMap;;;Argument[1];Argument[0].MapKey;value",
          ";MapUtils;true;safeAddToMap;;;Argument[2];Argument[0].MapValue;value",
          ";MapUtils;true;synchronizedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ";MapUtils;true;synchronizedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ";MapUtils;true;synchronizedSortedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ";MapUtils;true;synchronizedSortedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ";MapUtils;true;toMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ";MapUtils;true;toMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ";MapUtils;true;transformedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ";MapUtils;true;transformedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ";MapUtils;true;transformedSortedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ";MapUtils;true;transformedSortedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ";MapUtils;true;unmodifiableMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ";MapUtils;true;unmodifiableMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ";MapUtils;true;unmodifiableSortedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ";MapUtils;true;unmodifiableSortedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value"
        ]
  }
}

/**
 * Value-propagating models for the class `org.apache.commons.collections4.CollectionUtils`.
 */
private class ApacheCollectionUtilsModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      ["org.apache.commons.collections4", "org.apache.commons.collections"] +
        [
          // Note that when lambdas are supported we should have a model for collect, forAllButLastDo, forAllDo, transform
          ";CollectionUtils;true;addAll;(Collection,Object[]);;Argument[1].ArrayElement;Argument[0].Element;value",
          ";CollectionUtils;true;addAll;(Collection,Enumeration);;Argument[1].Element;Argument[0].Element;value",
          ";CollectionUtils;true;addAll;(Collection,Iterable);;Argument[1].Element;Argument[0].Element;value",
          ";CollectionUtils;true;addAll;(Collection,Iterator);;Argument[1].Element;Argument[0].Element;value",
          ";CollectionUtils;true;addIgnoreNull;;;Argument[1];Argument[0].Element;value",
          ";CollectionUtils;true;collate;;;Argument[0].Element;ReturnValue.Element;value",
          ";CollectionUtils;true;collate;;;Argument[1].Element;ReturnValue.Element;value",
          ";CollectionUtils;true;disjunction;;;Argument[0].Element;ReturnValue.Element;value",
          ";CollectionUtils;true;disjunction;;;Argument[1].Element;ReturnValue.Element;value",
          ";CollectionUtils;true;emptyIfNull;;;Argument[0];ReturnValue;value",
          ";CollectionUtils;true;extractSingleton;;;Argument[0].Element;ReturnValue;value",
          ";CollectionUtils;true;find;;;Argument[0].Element;ReturnValue;value",
          ";CollectionUtils;true;get;(Iterator,int);;Argument[0].Element;ReturnValue;value",
          ";CollectionUtils;true;get;(Iterable,int);;Argument[0].Element;ReturnValue;value",
          ";CollectionUtils;true;get;(Map,int);;Argument[0].MapKey;ReturnValue.MapKey;value",
          ";CollectionUtils;true;get;(Map,int);;Argument[0].MapValue;ReturnValue.MapValue;value",
          ";CollectionUtils;true;get;(Object,int);;Argument[0].ArrayElement;ReturnValue;value",
          ";CollectionUtils;true;get;(Object,int);;Argument[0].Element;ReturnValue;value",
          ";CollectionUtils;true;get;(Object,int);;Argument[0].MapKey;ReturnValue.MapKey;value",
          ";CollectionUtils;true;get;(Object,int);;Argument[0].MapValue;ReturnValue.MapValue;value",
          ";CollectionUtils;true;getCardinalityMap;;;Argument[0].Element;ReturnValue.MapKey;value",
          ";CollectionUtils;true;intersection;;;Argument[0].Element;ReturnValue.Element;value",
          ";CollectionUtils;true;intersection;;;Argument[1].Element;ReturnValue.Element;value",
          ";CollectionUtils;true;permutations;;;Argument[0].Element;ReturnValue.Element.Element;value",
          ";CollectionUtils;true;predicatedCollection;;;Argument[0].Element;ReturnValue.Element;value",
          ";CollectionUtils;true;removeAll;;;Argument[0].Element;ReturnValue.Element;value",
          ";CollectionUtils;true;retainAll;;;Argument[0].Element;ReturnValue.Element;value",
          ";CollectionUtils;true;select;(Iterable,Predicate);;Argument[0].Element;ReturnValue.Element;value",
          ";CollectionUtils;true;select;(Iterable,Predicate,Collection);;Argument[0].Element;Argument[2].Element;value",
          ";CollectionUtils;true;select;(Iterable,Predicate,Collection);;Argument[2];ReturnValue;value",
          ";CollectionUtils;true;select;(Iterable,Predicate,Collection,Collection);;Argument[0].Element;Argument[2].Element;value",
          ";CollectionUtils;true;select;(Iterable,Predicate,Collection,Collection);;Argument[0].Element;Argument[3].Element;value",
          ";CollectionUtils;true;select;(Iterable,Predicate,Collection,Collection);;Argument[2];ReturnValue;value",
          ";CollectionUtils;true;selectRejected;(Iterable,Predicate);;Argument[0].Element;ReturnValue.Element;value",
          ";CollectionUtils;true;selectRejected;(Iterable,Predicate,Collection);;Argument[0].Element;Argument[2].Element;value",
          ";CollectionUtils;true;selectRejected;(Iterable,Predicate,Collection);;Argument[2];ReturnValue;value",
          ";CollectionUtils;true;subtract;;;Argument[0].Element;ReturnValue.Element;value",
          ";CollectionUtils;true;synchronizedCollection;;;Argument[0].Element;ReturnValue.Element;value",
          // Note that `CollectionUtils.transformingCollection` does not transform existing list elements
          ";CollectionUtils;true;transformingCollection;;;Argument[0].Element;ReturnValue.Element;value",
          ";CollectionUtils;true;union;;;Argument[0].Element;ReturnValue.Element;value",
          ";CollectionUtils;true;union;;;Argument[1].Element;ReturnValue.Element;value",
          ";CollectionUtils;true;unmodifiableCollection;;;Argument[0].Element;ReturnValue.Element;value"
        ]
  }
}

/**
 * Value-propagating models for the class `org.apache.commons.collections4.ListUtils`.
 */
private class ApacheListUtilsModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      ["org.apache.commons.collections4", "org.apache.commons.collections"] +
        [
          ";ListUtils;true;defaultIfNull;;;Argument[0];ReturnValue;value",
          ";ListUtils;true;defaultIfNull;;;Argument[1];ReturnValue;value",
          ";ListUtils;true;emptyIfNull;;;Argument[0];ReturnValue;value",
          ";ListUtils;true;fixedSizeList;;;Argument[0].Element;ReturnValue.Element;value",
          ";ListUtils;true;intersection;;;Argument[0].Element;ReturnValue.Element;value",
          ";ListUtils;true;intersection;;;Argument[1].Element;ReturnValue.Element;value",
          // Note that `ListUtils.lazyList` does not transform existing list elements
          ";ListUtils;true;lazyList;;;Argument[0].Element;ReturnValue.Element;value",
          ";ListUtils;true;longestCommonSubsequence;(CharSequence,CharSequence);;Argument[0];ReturnValue;taint",
          ";ListUtils;true;longestCommonSubsequence;(CharSequence,CharSequence);;Argument[1];ReturnValue;taint",
          ";ListUtils;true;longestCommonSubsequence;(List,List);;Argument[0].Element;ReturnValue.Element;value",
          ";ListUtils;true;longestCommonSubsequence;(List,List);;Argument[1].Element;ReturnValue.Element;value",
          ";ListUtils;true;longestCommonSubsequence;(List,List,Equator);;Argument[0].Element;ReturnValue.Element;value",
          ";ListUtils;true;longestCommonSubsequence;(List,List,Equator);;Argument[1].Element;ReturnValue.Element;value",
          ";ListUtils;true;partition;;;Argument[0].Element;ReturnValue.Element.Element;value",
          ";ListUtils;true;predicatedList;;;Argument[0].Element;ReturnValue.Element;value",
          ";ListUtils;true;removeAll;;;Argument[0].Element;ReturnValue.Element;value",
          ";ListUtils;true;retainAll;;;Argument[0].Element;ReturnValue.Element;value",
          ";ListUtils;true;select;;;Argument[0].Element;ReturnValue.Element;value",
          ";ListUtils;true;selectRejected;;;Argument[0].Element;ReturnValue.Element;value",
          ";ListUtils;true;subtract;;;Argument[0].Element;ReturnValue.Element;value",
          ";ListUtils;true;sum;;;Argument[0].Element;ReturnValue.Element;value",
          ";ListUtils;true;sum;;;Argument[1].Element;ReturnValue.Element;value",
          ";ListUtils;true;synchronizedList;;;Argument[0].Element;ReturnValue.Element;value",
          // Note that `ListUtils.transformedList` does not transform existing list elements
          ";ListUtils;true;transformedList;;;Argument[0].Element;ReturnValue.Element;value",
          ";ListUtils;true;union;;;Argument[0].Element;ReturnValue.Element;value",
          ";ListUtils;true;union;;;Argument[1].Element;ReturnValue.Element;value",
          ";ListUtils;true;unmodifiableList;;;Argument[0].Element;ReturnValue.Element;value"
        ]
  }
}

/**
 * Value-propagating models for the class `org.apache.commons.collections4.IteratorUtils`.
 */
private class ApacheIteratorUtilsModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      ["org.apache.commons.collections4", "org.apache.commons.collections"] +
        [
          // Note that when lambdas are supported we should have a model for forEach, forEachButLast, transformedIterator
          ";IteratorUtils;true;arrayIterator;;;Argument[0].ArrayElement;ReturnValue.Element;value",
          ";IteratorUtils;true;arrayListIterator;;;Argument[0].ArrayElement;ReturnValue.Element;value",
          ";IteratorUtils;true;asEnumeration;;;Argument[0].Element;ReturnValue.Element;value",
          ";IteratorUtils;true;asIterable;;;Argument[0].Element;ReturnValue.Element;value",
          ";IteratorUtils;true;asIterator;;;Argument[0].Element;ReturnValue.Element;value",
          ";IteratorUtils;true;asMultipleUseIterable;;;Argument[0].Element;ReturnValue.Element;value",
          ";IteratorUtils;true;boundedIterator;;;Argument[0].Element;ReturnValue.Element;value",
          ";IteratorUtils;true;chainedIterator;(Collection);;Argument[0].Element.Element;ReturnValue.Element;value",
          ";IteratorUtils;true;chainedIterator;(Iterator[]);;Argument[0].ArrayElement.Element;ReturnValue.Element;value",
          ";IteratorUtils;true;chainedIterator;(Iterator,Iterator);;Argument[0].Element;ReturnValue.Element;value",
          ";IteratorUtils;true;chainedIterator;(Iterator,Iterator);;Argument[1].Element;ReturnValue.Element;value",
          ";IteratorUtils;true;collatedIterator;(Comparator,Collection);;Argument[1].Element.Element;ReturnValue.Element;value",
          ";IteratorUtils;true;collatedIterator;(Comparator,Iterator[]);;Argument[1].ArrayElement.Element;ReturnValue.Element;value",
          ";IteratorUtils;true;collatedIterator;(Comparator,Iterator,Iterator);;Argument[1].Element;ReturnValue.Element;value",
          ";IteratorUtils;true;collatedIterator;(Comparator,Iterator,Iterator);;Argument[2].Element;ReturnValue.Element;value",
          ";IteratorUtils;true;filteredIterator;;;Argument[0].Element;ReturnValue.Element;value",
          ";IteratorUtils;true;filteredListIterator;;;Argument[0].Element;ReturnValue.Element;value",
          ";IteratorUtils;true;find;;;Argument[0].Element;ReturnValue;value",
          ";IteratorUtils;true;first;;;Argument[0].Element;ReturnValue;value",
          ";IteratorUtils;true;forEachButLast;;;Argument[0].Element;ReturnValue;value",
          ";IteratorUtils;true;get;;;Argument[0].Element;ReturnValue;value",
          ";IteratorUtils;true;getIterator;;;Argument[0].Element;ReturnValue.Element;value",
          ";IteratorUtils;true;getIterator;;;Argument[0].ArrayElement;ReturnValue.Element;value",
          ";IteratorUtils;true;getIterator;;;Argument[0];ReturnValue.Element;value",
          ";IteratorUtils;true;getIterator;;;Argument[0].MapValue;ReturnValue.Element;value",
          ";IteratorUtils;true;loopingIterator;;;Argument[0].Element;ReturnValue.Element;value",
          ";IteratorUtils;true;loopingListIterator;;;Argument[0].Element;ReturnValue.Element;value",
          ";IteratorUtils;true;peekingIterator;;;Argument[0].Element;ReturnValue.Element;value",
          ";IteratorUtils;true;pushbackIterator;;;Argument[0].Element;ReturnValue.Element;value",
          ";IteratorUtils;true;singletonIterator;;;Argument[0];ReturnValue.Element;value",
          ";IteratorUtils;true;singletonListIterator;;;Argument[0];ReturnValue.Element;value",
          ";IteratorUtils;true;skippingIterator;;;Argument[0].Element;ReturnValue.Element;value",
          ";IteratorUtils;true;toArray;;;Argument[0].Element;ReturnValue.ArrayElement;value",
          ";IteratorUtils;true;toList;;;Argument[0].Element;ReturnValue.Element;value",
          ";IteratorUtils;true;toListIterator;;;Argument[0].Element;ReturnValue.Element;value",
          ";IteratorUtils;true;toString;;;Argument[2];ReturnValue;taint",
          ";IteratorUtils;true;toString;;;Argument[3];ReturnValue;taint",
          ";IteratorUtils;true;toString;;;Argument[4];ReturnValue;taint",
          ";IteratorUtils;true;unmodifiableIterator;;;Argument[0].Element;ReturnValue.Element;value",
          ";IteratorUtils;true;unmodifiableListIterator;;;Argument[0].Element;ReturnValue.Element;value",
          ";IteratorUtils;true;unmodifiableMapIterator;;;Argument[0].Element;ReturnValue.Element;value",
          ";IteratorUtils;true;unmodifiableMapIterator;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ";IteratorUtils;true;zippingIterator;(Iterator[]);;Argument[0].ArrayElement.Element;ReturnValue.Element;value",
          ";IteratorUtils;true;zippingIterator;(Iterator,Iterator);;Argument[0].Element;ReturnValue.Element;value",
          ";IteratorUtils;true;zippingIterator;(Iterator,Iterator);;Argument[1].Element;ReturnValue.Element;value",
          ";IteratorUtils;true;zippingIterator;(Iterator,Iterator,Iterator);;Argument[0].Element;ReturnValue.Element;value",
          ";IteratorUtils;true;zippingIterator;(Iterator,Iterator,Iterator);;Argument[1].Element;ReturnValue.Element;value",
          ";IteratorUtils;true;zippingIterator;(Iterator,Iterator,Iterator);;Argument[2].Element;ReturnValue.Element;value"
        ]
  }
}

/**
 * Value-propagating models for the class `org.apache.commons.collections4.IterableUtils`.
 */
private class ApacheIterableUtilsModel extends SummaryModelCsv {
  override predicate row(string row) {
    // Note that when lambdas are supported we should have a model for forEach, forEachButLast, transformedIterable
    row =
      ["org.apache.commons.collections4", "org.apache.commons.collections"] +
        [
          ";IterableUtils;true;boundedIterable;;;Argument[0].Element;ReturnValue.Element;value",
          ";IterableUtils;true;chainedIterable;(Iterable[]);;Argument[0].ArrayElement.Element;ReturnValue.Element;value",
          ";IterableUtils;true;chainedIterable;(Iterable,Iterable);;Argument[0].Element;ReturnValue.Element;value",
          ";IterableUtils;true;chainedIterable;(Iterable,Iterable);;Argument[1].Element;ReturnValue.Element;value",
          ";IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable);;Argument[0].Element;ReturnValue.Element;value",
          ";IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable);;Argument[1].Element;ReturnValue.Element;value",
          ";IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable);;Argument[2].Element;ReturnValue.Element;value",
          ";IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable,Iterable);;Argument[0].Element;ReturnValue.Element;value",
          ";IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable,Iterable);;Argument[1].Element;ReturnValue.Element;value",
          ";IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable,Iterable);;Argument[2].Element;ReturnValue.Element;value",
          ";IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable,Iterable);;Argument[3].Element;ReturnValue.Element;value",
          ";IterableUtils;true;collatedIterable;(Comparator,Iterable,Iterable);;Argument[1].Element;ReturnValue.Element;value",
          ";IterableUtils;true;collatedIterable;(Comparator,Iterable,Iterable);;Argument[2].Element;ReturnValue.Element;value",
          ";IterableUtils;true;collatedIterable;(Iterable,Iterable);;Argument[0].Element;ReturnValue.Element;value",
          ";IterableUtils;true;collatedIterable;(Iterable,Iterable);;Argument[1].Element;ReturnValue.Element;value",
          ";IterableUtils;true;emptyIfNull;;;Argument[0];ReturnValue;value",
          ";IterableUtils;true;filteredIterable;;;Argument[0].Element;ReturnValue.Element;value",
          ";IterableUtils;true;find;;;Argument[0].Element;ReturnValue;value",
          ";IterableUtils;true;first;;;Argument[0].Element;ReturnValue;value",
          ";IterableUtils;true;forEachButLast;;;Argument[0].Element;ReturnValue;value",
          ";IterableUtils;true;get;;;Argument[0].Element;ReturnValue;value",
          ";IterableUtils;true;loopingIterable;;;Argument[0].Element;ReturnValue.Element;value",
          ";IterableUtils;true;partition;;;Argument[0].Element;ReturnValue.Element.Element;value",
          ";IterableUtils;true;reversedIterable;;;Argument[0].Element;ReturnValue.Element;value",
          ";IterableUtils;true;skippingIterable;;;Argument[0].Element;ReturnValue.Element;value",
          ";IterableUtils;true;toList;;;Argument[0].Element;ReturnValue.Element;value",
          ";IterableUtils;true;toString;;;Argument[2];ReturnValue;taint",
          ";IterableUtils;true;toString;;;Argument[3];ReturnValue;taint",
          ";IterableUtils;true;toString;;;Argument[4];ReturnValue;taint",
          ";IterableUtils;true;uniqueIterable;;;Argument[0].Element;ReturnValue.Element;value",
          ";IterableUtils;true;unmodifiableIterable;;;Argument[0].Element;ReturnValue.Element;value",
          ";IterableUtils;true;zippingIterable;;;Argument[0].Element;ReturnValue.Element;value",
          ";IterableUtils;true;zippingIterable;(Iterable,Iterable[]);;Argument[1].ArrayElement.Element;ReturnValue.Element;value",
          ";IterableUtils;true;zippingIterable;(Iterable,Iterable);;Argument[1].Element;ReturnValue.Element;value"
        ]
  }
}

/**
 * Value-propagating models for the class `org.apache.commons.collections4.EnumerationUtils`.
 */
private class ApacheEnumerationUtilsModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      ["org.apache.commons.collections4", "org.apache.commons.collections"] +
        [
          ";EnumerationUtils;true;get;;;Argument[0].Element;ReturnValue;value",
          ";EnumerationUtils;true;toList;(Enumeration);;Argument[0].Element;ReturnValue.Element;value",
          ";EnumerationUtils;true;toList;(StringTokenizer);;Argument[0];ReturnValue.Element;taint"
        ]
  }
}

/**
 * Value-propagating models for the class `org.apache.commons.collections4.MultiMapUtils`.
 */
private class ApacheMultiMapUtilsModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      ["org.apache.commons.collections4", "org.apache.commons.collections"] +
        [
          ";MultiMapUtils;true;emptyIfNull;;;Argument[0];ReturnValue;value",
          ";MultiMapUtils;true;getCollection;;;Argument[0].MapValue;ReturnValue;value",
          ";MultiMapUtils;true;getValuesAsBag;;;Argument[0].MapValue.Element;ReturnValue.Element;value",
          ";MultiMapUtils;true;getValuesAsList;;;Argument[0].MapValue.Element;ReturnValue.Element;value",
          ";MultiMapUtils;true;getValuesAsSet;;;Argument[0].MapValue.Element;ReturnValue.Element;value",
          ";MultiMapUtils;true;transformedMultiValuedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ";MultiMapUtils;true;transformedMultiValuedMap;;;Argument[0].MapValue.Element;ReturnValue.MapValue.Element;value",
          ";MultiMapUtils;true;unmodifiableMultiValuedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ";MultiMapUtils;true;unmodifiableMultiValuedMap;;;Argument[0].MapValue.Element;ReturnValue.MapValue.Element;value"
        ]
  }
}

/**
 * Value-propagating models for the class `org.apache.commons.collections4.MultiSetUtils`.
 */
private class ApacheMultiSetUtilsModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      ["org.apache.commons.collections4", "org.apache.commons.collections"] +
        [
          ";MultiSetUtils;true;predicatedMultiSet;;;Argument[0].Element;ReturnValue.Element;value",
          ";MultiSetUtils;true;synchronizedMultiSet;;;Argument[0].Element;ReturnValue.Element;value",
          ";MultiSetUtils;true;unmodifiableMultiSet;;;Argument[0].Element;ReturnValue.Element;value"
        ]
  }
}

/**
 * Value-propagating models for the class `org.apache.commons.collections4.QueueUtils`.
 */
private class ApacheQueueUtilsModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      ["org.apache.commons.collections4", "org.apache.commons.collections"] +
        [
          ";QueueUtils;true;predicatedQueue;;;Argument[0].Element;ReturnValue.Element;value",
          ";QueueUtils;true;synchronizedQueue;;;Argument[0].Element;ReturnValue.Element;value",
          ";QueueUtils;true;transformingQueue;;;Argument[0].Element;ReturnValue.Element;value",
          ";QueueUtils;true;unmodifiableQueue;;;Argument[0].Element;ReturnValue.Element;value"
        ]
  }
}

/**
 * Value-propagating models for the classes `org.apache.commons.collections4.SetUtils`
 * and `org.apache.commons.collections4.SetUtils$SetView`.
 */
private class ApacheSetUtilsModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      ["org.apache.commons.collections4", "org.apache.commons.collections"] +
        [
          ";SetUtils$SetView;true;copyInto;;;Argument[-1].Element;Argument[0].Element;value",
          ";SetUtils$SetView;true;createIterator;;;Argument[-1].Element;ReturnValue.Element;value",
          ";SetUtils$SetView;true;toSet;;;Argument[-1].Element;ReturnValue.Element;value",
          ";SetUtils;true;difference;;;Argument[0].Element;ReturnValue.Element;value",
          ";SetUtils;true;disjunction;;;Argument[0].Element;ReturnValue.Element;value",
          ";SetUtils;true;disjunction;;;Argument[1].Element;ReturnValue.Element;value",
          ";SetUtils;true;emptyIfNull;;;Argument[0];ReturnValue;value",
          ";SetUtils;true;hashSet;;;Argument[0].ArrayElement;ReturnValue.Element;value",
          ";SetUtils;true;intersection;;;Argument[0].Element;ReturnValue.Element;value",
          ";SetUtils;true;intersection;;;Argument[1].Element;ReturnValue.Element;value",
          ";SetUtils;true;orderedSet;;;Argument[0].Element;ReturnValue.Element;value",
          ";SetUtils;true;predicatedNavigableSet;;;Argument[0].Element;ReturnValue.Element;value",
          ";SetUtils;true;predicatedSet;;;Argument[0].Element;ReturnValue.Element;value",
          ";SetUtils;true;predicatedSortedSet;;;Argument[0].Element;ReturnValue.Element;value",
          ";SetUtils;true;synchronizedSet;;;Argument[0].Element;ReturnValue.Element;value",
          ";SetUtils;true;synchronizedSortedSet;;;Argument[0].Element;ReturnValue.Element;value",
          ";SetUtils;true;transformedNavigableSet;;;Argument[0].Element;ReturnValue.Element;value",
          ";SetUtils;true;transformedSet;;;Argument[0].Element;ReturnValue.Element;value",
          ";SetUtils;true;transformedSortedSet;;;Argument[0].Element;ReturnValue.Element;value",
          ";SetUtils;true;union;;;Argument[0].Element;ReturnValue.Element;value",
          ";SetUtils;true;union;;;Argument[1].Element;ReturnValue.Element;value",
          ";SetUtils;true;unmodifiableNavigableSet;;;Argument[0].Element;ReturnValue.Element;value",
          ";SetUtils;true;unmodifiableSet;(Object[]);;Argument[0].ArrayElement;ReturnValue.Element;value",
          ";SetUtils;true;unmodifiableSet;(Set);;Argument[0].Element;ReturnValue.Element;value",
          ";SetUtils;true;unmodifiableSortedSet;;;Argument[0].Element;ReturnValue.Element;value"
        ]
  }
}

/**
 * Value-propagating models for the class `org.apache.commons.collections4.SplitMapUtils`.
 */
private class ApacheSplitMapUtilsModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      ["org.apache.commons.collections4", "org.apache.commons.collections"] +
        [
          ";SplitMapUtils;true;readableMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ";SplitMapUtils;true;readableMap;;;Argument[0].MapValue;ReturnValue.MapValue;value",
          ";SplitMapUtils;true;writableMap;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ";SplitMapUtils;true;writableMap;;;Argument[0].MapValue;ReturnValue.MapValue;value"
        ]
  }
}

/**
 * Value-propagating models for the class `org.apache.commons.collections4.TrieUtils`.
 */
private class ApacheTrieUtilsModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      ["org.apache.commons.collections4", "org.apache.commons.collections"] +
        [
          ";TrieUtils;true;unmodifiableTrie;;;Argument[0].MapKey;ReturnValue.MapKey;value",
          ";TrieUtils;true;unmodifiableTrie;;;Argument[0].MapValue;ReturnValue.MapValue;value"
        ]
  }
}

/**
 * Value-propagating models for the class `org.apache.commons.collections4.BagUtils`.
 */
private class ApacheBagUtilsModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      ["org.apache.commons.collections4", "org.apache.commons.collections"] +
        [
          ";BagUtils;true;collectionBag;;;Argument[0].Element;ReturnValue.Element;value",
          ";BagUtils;true;predicatedBag;;;Argument[0].Element;ReturnValue.Element;value",
          ";BagUtils;true;predicatedSortedBag;;;Argument[0].Element;ReturnValue.Element;value",
          ";BagUtils;true;synchronizedBag;;;Argument[0].Element;ReturnValue.Element;value",
          ";BagUtils;true;synchronizedSortedBag;;;Argument[0].Element;ReturnValue.Element;value",
          ";BagUtils;true;transformingBag;;;Argument[0].Element;ReturnValue.Element;value",
          ";BagUtils;true;transformingSortedBag;;;Argument[0].Element;ReturnValue.Element;value",
          ";BagUtils;true;unmodifiableBag;;;Argument[0].Element;ReturnValue.Element;value",
          ";BagUtils;true;unmodifiableSortedBag;;;Argument[0].Element;ReturnValue.Element;value"
        ]
  }
}
