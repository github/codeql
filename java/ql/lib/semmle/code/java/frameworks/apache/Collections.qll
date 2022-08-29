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
          ";ArrayStack;true;peek;;;Argument[-1].Element;ReturnValue;value;manual",
          ";ArrayStack;true;pop;;;Argument[-1].Element;ReturnValue;value;manual",
          ";ArrayStack;true;push;;;Argument[0];Argument[-1].Element;value;manual",
          ";ArrayStack;true;push;;;Argument[0];ReturnValue;value;manual",
          ";Bag;true;add;;;Argument[0];Argument[-1].Element;value;manual",
          ";Bag;true;uniqueSet;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ";BidiMap;true;getKey;;;Argument[-1].MapKey;ReturnValue;value;manual",
          ";BidiMap;true;removeValue;;;Argument[-1].MapKey;ReturnValue;value;manual",
          ";BidiMap;true;inverseBidiMap;;;Argument[-1].MapKey;ReturnValue.MapValue;value;manual",
          ";BidiMap;true;inverseBidiMap;;;Argument[-1].MapValue;ReturnValue.MapKey;value;manual",
          ";FluentIterable;true;append;(Object[]);;Argument[-1].Element;ReturnValue.Element;value;manual",
          ";FluentIterable;true;append;(Object[]);;Argument[0].ArrayElement;ReturnValue.Element;value;manual",
          ";FluentIterable;true;append;(Iterable);;Argument[-1].Element;ReturnValue.Element;value;manual",
          ";FluentIterable;true;append;(Iterable);;Argument[0].Element;ReturnValue.Element;value;manual",
          ";FluentIterable;true;asEnumeration;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ";FluentIterable;true;collate;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ";FluentIterable;true;collate;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";FluentIterable;true;copyInto;;;Argument[-1].Element;Argument[0].Element;value;manual",
          ";FluentIterable;true;eval;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ";FluentIterable;true;filter;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ";FluentIterable;true;get;;;Argument[-1].Element;ReturnValue;value;manual",
          ";FluentIterable;true;limit;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ";FluentIterable;true;loop;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ";FluentIterable;true;of;(Iterable);;Argument[0].Element;ReturnValue.Element;value;manual",
          ";FluentIterable;true;of;(Object[]);;Argument[0].ArrayElement;ReturnValue.Element;value;manual",
          ";FluentIterable;true;of;(Object);;Argument[0];ReturnValue.Element;value;manual",
          ";FluentIterable;true;reverse;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ";FluentIterable;true;skip;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ";FluentIterable;true;toArray;;;Argument[-1].Element;ReturnValue.ArrayElement;value;manual",
          ";FluentIterable;true;toList;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ";FluentIterable;true;unique;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ";FluentIterable;true;unmodifiable;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ";FluentIterable;true;zip;(Iterable);;Argument[-1].Element;ReturnValue.Element;value;manual",
          ";FluentIterable;true;zip;(Iterable);;Argument[0].Element;ReturnValue.Element;value;manual",
          ";FluentIterable;true;zip;(Iterable[]);;Argument[-1].Element;ReturnValue.Element;value;manual",
          ";FluentIterable;true;zip;(Iterable[]);;Argument[0].ArrayElement.Element;ReturnValue.Element;value;manual",
          ";Get;true;entrySet;;;Argument[-1].MapKey;ReturnValue.Element.MapKey;value;manual",
          ";Get;true;entrySet;;;Argument[-1].MapValue;ReturnValue.Element.MapValue;value;manual",
          ";Get;true;get;;;Argument[-1].MapValue;ReturnValue;value;manual",
          ";Get;true;keySet;();;Argument[-1].MapKey;ReturnValue.Element;value;manual",
          ";Get;true;values;();;Argument[-1].MapValue;ReturnValue.Element;value;manual",
          ";Get;true;remove;(Object);;Argument[-1].MapValue;ReturnValue;value;manual",
          ";IterableGet;true;mapIterator;;;Argument[-1].MapKey;ReturnValue.Element;value;manual",
          ";IterableGet;true;mapIterator;;;Argument[-1].MapValue;ReturnValue.MapValue;value;manual",
          ";KeyValue;true;getKey;;;Argument[-1].MapKey;ReturnValue;value;manual",
          ";KeyValue;true;getValue;;;Argument[-1].MapValue;ReturnValue;value;manual",
          // Note that MapIterator<K, V> implements Iterator<K>, so it iterates over the keys of the map.
          // In order for the models of Iterator to work we have to use Element instead of MapKey for key data.
          ";MapIterator;true;getKey;;;Argument[-1].Element;ReturnValue;value;manual",
          ";MapIterator;true;getValue;;;Argument[-1].MapValue;ReturnValue;value;manual",
          ";MapIterator;true;setValue;;;Argument[-1].MapValue;ReturnValue;value;manual",
          ";MapIterator;true;setValue;;;Argument[0];Argument[-1].MapValue;value;manual",
          ";MultiMap;true;get;;;Argument[-1].MapValue.Element;ReturnValue.Element;value;manual",
          ";MultiMap;true;put;;;Argument[0];Argument[-1].MapKey;value;manual",
          ";MultiMap;true;put;;;Argument[1];Argument[-1].MapValue.Element;value;manual",
          ";MultiMap;true;values;;;Argument[-1].MapValue.Element;ReturnValue.Element;value;manual",
          ";MultiSet$Entry;true;getElement;;;Argument[-1].Element;ReturnValue;value;manual",
          ";MultiSet;true;add;;;Argument[0];Argument[-1].Element;value;manual",
          ";MultiSet;true;uniqueSet;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ";MultiSet;true;entrySet;;;Argument[-1].Element;ReturnValue.Element.Element;value;manual",
          ";MultiValuedMap;true;asMap;;;Argument[-1].MapKey;ReturnValue.MapKey;value;manual",
          ";MultiValuedMap;true;asMap;;;Argument[-1].MapValue.Element;ReturnValue.MapValue.Element;value;manual",
          ";MultiValuedMap;true;entries;;;Argument[-1].MapKey;ReturnValue.Element.MapKey;value;manual",
          ";MultiValuedMap;true;entries;;;Argument[-1].MapValue.Element;ReturnValue.Element.MapValue;value;manual",
          ";MultiValuedMap;true;get;;;Argument[-1].MapValue.Element;ReturnValue.Element;value;manual",
          ";MultiValuedMap;true;keys;;;Argument[-1].MapKey;ReturnValue.Element;value;manual",
          ";MultiValuedMap;true;keySet;;;Argument[-1].MapKey;ReturnValue.Element;value;manual",
          ";MultiValuedMap;true;mapIterator;;;Argument[-1].MapKey;ReturnValue.Element;value;manual",
          ";MultiValuedMap;true;mapIterator;;;Argument[-1].MapValue.Element;ReturnValue.MapValue;value;manual",
          ";MultiValuedMap;true;put;;;Argument[0];Argument[-1].MapKey;value;manual",
          ";MultiValuedMap;true;put;;;Argument[1];Argument[-1].MapValue.Element;value;manual",
          ";MultiValuedMap;true;putAll;(Object,Iterable);;Argument[0];Argument[-1].MapKey;value;manual",
          ";MultiValuedMap;true;putAll;(Object,Iterable);;Argument[1].Element;Argument[-1].MapValue.Element;value;manual",
          ";MultiValuedMap;true;putAll;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ";MultiValuedMap;true;putAll;(Map);;Argument[0].MapValue;Argument[-1].MapValue.Element;value;manual",
          ";MultiValuedMap;true;putAll;(MultiValuedMap);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ";MultiValuedMap;true;putAll;(MultiValuedMap);;Argument[0].MapValue.Element;Argument[-1].MapValue.Element;value;manual",
          ";MultiValuedMap;true;remove;;;Argument[-1].MapValue.Element;ReturnValue.Element;value;manual",
          ";MultiValuedMap;true;values;;;Argument[-1].MapValue.Element;ReturnValue.Element;value;manual",
          ";OrderedIterator;true;previous;;;Argument[-1].Element;ReturnValue;value;manual",
          ";OrderedMap;true;firstKey;;;Argument[-1].MapKey;ReturnValue;value;manual",
          ";OrderedMap;true;lastKey;;;Argument[-1].MapKey;ReturnValue;value;manual",
          ";OrderedMap;true;nextKey;;;Argument[-1].MapKey;ReturnValue;value;manual",
          ";OrderedMap;true;previousKey;;;Argument[-1].MapKey;ReturnValue;value;manual",
          ";Put;true;put;;;Argument[-1].MapValue;ReturnValue;value;manual",
          ";Put;true;put;;;Argument[0];Argument[-1].MapKey;value;manual",
          ";Put;true;put;;;Argument[1];Argument[-1].MapValue;value;manual",
          ";Put;true;putAll;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ";Put;true;putAll;(Map);;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ";SortedBag;true;first;;;Argument[-1].Element;ReturnValue;value;manual",
          ";SortedBag;true;last;;;Argument[-1].Element;ReturnValue;value;manual",
          ";Trie;true;prefixMap;;;Argument[-1].MapKey;ReturnValue.MapKey;value;manual",
          ";Trie;true;prefixMap;;;Argument[-1].MapValue;ReturnValue.MapValue;value;manual"
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
          ".keyvalue;AbstractKeyValue;true;AbstractKeyValue;;;Argument[0];Argument[-1].MapKey;value;manual",
          ".keyvalue;AbstractKeyValue;true;AbstractKeyValue;;;Argument[1];Argument[-1].MapValue;value;manual",
          ".keyvalue;AbstractKeyValue;true;setKey;;;Argument[-1].MapKey;ReturnValue;value;manual",
          ".keyvalue;AbstractKeyValue;true;setKey;;;Argument[0];Argument[-1].MapKey;value;manual",
          ".keyvalue;AbstractKeyValue;true;setValue;;;Argument[-1].MapValue;ReturnValue;value;manual",
          ".keyvalue;AbstractKeyValue;true;setValue;;;Argument[0];Argument[-1].MapValue;value;manual",
          ".keyvalue;AbstractMapEntry;true;AbstractMapEntry;;;Argument[0];Argument[-1].MapKey;value;manual",
          ".keyvalue;AbstractMapEntry;true;AbstractMapEntry;;;Argument[1];Argument[-1].MapValue;value;manual",
          ".keyvalue;AbstractMapEntryDecorator;true;AbstractMapEntryDecorator;;;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".keyvalue;AbstractMapEntryDecorator;true;AbstractMapEntryDecorator;;;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".keyvalue;AbstractMapEntryDecorator;true;getMapEntry;;;Argument[-1].MapKey;ReturnValue.MapKey;value;manual",
          ".keyvalue;AbstractMapEntryDecorator;true;getMapEntry;;;Argument[-1].MapValue;ReturnValue.MapValue;value;manual",
          ".keyvalue;DefaultKeyValue;true;DefaultKeyValue;(Object,Object);;Argument[0];Argument[-1].MapKey;value;manual",
          ".keyvalue;DefaultKeyValue;true;DefaultKeyValue;(Object,Object);;Argument[1];Argument[-1].MapValue;value;manual",
          ".keyvalue;DefaultKeyValue;true;DefaultKeyValue;(KeyValue);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".keyvalue;DefaultKeyValue;true;DefaultKeyValue;(KeyValue);;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".keyvalue;DefaultKeyValue;true;DefaultKeyValue;(Entry);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".keyvalue;DefaultKeyValue;true;DefaultKeyValue;(Entry);;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".keyvalue;DefaultKeyValue;true;toMapEntry;;;Argument[-1].MapKey;ReturnValue.MapKey;value;manual",
          ".keyvalue;DefaultKeyValue;true;toMapEntry;;;Argument[-1].MapValue;ReturnValue.MapValue;value;manual",
          ".keyvalue;DefaultMapEntry;true;DefaultMapEntry;(Object,Object);;Argument[0];Argument[-1].MapKey;value;manual",
          ".keyvalue;DefaultMapEntry;true;DefaultMapEntry;(Object,Object);;Argument[1];Argument[-1].MapValue;value;manual",
          ".keyvalue;DefaultMapEntry;true;DefaultMapEntry;(KeyValue);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".keyvalue;DefaultMapEntry;true;DefaultMapEntry;(KeyValue);;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".keyvalue;DefaultMapEntry;true;DefaultMapEntry;(Entry);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".keyvalue;DefaultMapEntry;true;DefaultMapEntry;(Entry);;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".keyvalue;MultiKey;true;MultiKey;(Object[]);;Argument[0].ArrayElement;Argument[-1].Element;value;manual",
          ".keyvalue;MultiKey;true;MultiKey;(Object[],boolean);;Argument[0].ArrayElement;Argument[-1].Element;value;manual",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object);;Argument[0];Argument[-1].Element;value;manual",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object);;Argument[1];Argument[-1].Element;value;manual",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object);;Argument[0];Argument[-1].Element;value;manual",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object);;Argument[1];Argument[-1].Element;value;manual",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object);;Argument[2];Argument[-1].Element;value;manual",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object);;Argument[0];Argument[-1].Element;value;manual",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object);;Argument[1];Argument[-1].Element;value;manual",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object);;Argument[2];Argument[-1].Element;value;manual",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object);;Argument[3];Argument[-1].Element;value;manual",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object,Object);;Argument[0];Argument[-1].Element;value;manual",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object,Object);;Argument[1];Argument[-1].Element;value;manual",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object,Object);;Argument[2];Argument[-1].Element;value;manual",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object,Object);;Argument[3];Argument[-1].Element;value;manual",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object,Object);;Argument[4];Argument[-1].Element;value;manual",
          ".keyvalue;MultiKey;true;getKeys;;;Argument[-1].Element;ReturnValue.ArrayElement;value;manual",
          ".keyvalue;MultiKey;true;getKey;;;Argument[-1].Element;ReturnValue;value;manual",
          ".keyvalue;TiedMapEntry;true;TiedMapEntry;;;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".keyvalue;TiedMapEntry;true;TiedMapEntry;;;Argument[1];Argument[-1].MapKey;value;manual",
          ".keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(Object,Object);;Argument[0];Argument[-1].MapKey;value;manual",
          ".keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(Object,Object);;Argument[1];Argument[-1].MapValue;value;manual",
          ".keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(KeyValue);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(KeyValue);;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(Entry);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(Entry);;Argument[0].MapValue;Argument[-1].MapValue;value;manual"
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
          ".bag;AbstractBagDecorator;true;AbstractBagDecorator;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".bag;AbstractMapBag;true;AbstractMapBag;;;Argument[0].MapKey;Argument[-1].Element;value;manual",
          ".bag;AbstractMapBag;true;getMap;;;Argument[-1].Element;ReturnValue.MapKey;value;manual",
          ".bag;AbstractSortedBagDecorator;true;AbstractSortedBagDecorator;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".bag;CollectionBag;true;CollectionBag;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".bag;CollectionBag;true;collectionBag;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".bag;CollectionSortedBag;true;CollectionSortedBag;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".bag;CollectionSortedBag;true;collectionSortedBag;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".bag;HashBag;true;HashBag;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".bag;PredicatedBag;true;predicatedBag;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".bag;PredicatedSortedBag;true;predicatedSortedBag;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".bag;SynchronizedBag;true;synchronizedBag;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".bag;SynchronizedSortedBag;true;synchronizedSortedBag;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".bag;TransformedBag;true;transformedBag;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".bag;TransformedSortedBag;true;transformedSortedBag;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".bag;TreeBag;true;TreeBag;(Collection);;Argument[0].Element;Argument[-1].Element;value;manual",
          ".bag;UnmodifiableBag;true;unmodifiableBag;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".bag;UnmodifiableSortedBag;true;unmodifiableSortedBag;;;Argument[0].Element;ReturnValue.Element;value;manual"
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
          ".bidimap;AbstractBidiMapDecorator;true;AbstractBidiMapDecorator;;;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".bidimap;AbstractBidiMapDecorator;true;AbstractBidiMapDecorator;;;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".bidimap;AbstractDualBidiMap;true;AbstractDualBidiMap;;;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".bidimap;AbstractDualBidiMap;true;AbstractDualBidiMap;;;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".bidimap;AbstractDualBidiMap;true;AbstractDualBidiMap;;;Argument[1].MapKey;Argument[-1].MapValue;value;manual",
          ".bidimap;AbstractDualBidiMap;true;AbstractDualBidiMap;;;Argument[1].MapValue;Argument[-1].MapKey;value;manual",
          ".bidimap;AbstractDualBidiMap;true;AbstractDualBidiMap;;;Argument[2].MapKey;Argument[-1].MapValue;value;manual",
          ".bidimap;AbstractDualBidiMap;true;AbstractDualBidiMap;;;Argument[2].MapValue;Argument[-1].MapKey;value;manual",
          ".bidimap;AbstractOrderedBidiMapDecorator;true;AbstractOrderedBidiMapDecorator;;;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".bidimap;AbstractOrderedBidiMapDecorator;true;AbstractOrderedBidiMapDecorator;;;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".bidimap;AbstractSortedBidiMapDecorator;true;AbstractSortedBidiMapDecorator;;;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".bidimap;AbstractSortedBidiMapDecorator;true;AbstractSortedBidiMapDecorator;;;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".bidimap;DualHashBidiMap;true;DualHashBidiMap;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".bidimap;DualHashBidiMap;true;DualHashBidiMap;(Map);;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".bidimap;DualLinkedHashBidiMap;true;DualLinkedHashBidiMap;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".bidimap;DualLinkedHashBidiMap;true;DualLinkedHashBidiMap;(Map);;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".bidimap;DualTreeBidiMap;true;DualTreeBidiMap;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".bidimap;DualTreeBidiMap;true;DualTreeBidiMap;(Map);;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".bidimap;DualTreeBidiMap;true;inverseOrderedBidiMap;;;Argument[-1].MapKey;ReturnValue.MapValue;value;manual",
          ".bidimap;DualTreeBidiMap;true;inverseOrderedBidiMap;;;Argument[-1].MapValue;ReturnValue.MapKey;value;manual",
          ".bidimap;DualTreeBidiMap;true;inverseSortedBidiMap;;;Argument[-1].MapKey;ReturnValue.MapValue;value;manual",
          ".bidimap;DualTreeBidiMap;true;inverseSortedBidiMap;;;Argument[-1].MapValue;ReturnValue.MapKey;value;manual",
          ".bidimap;TreeBidiMap;true;TreeBidiMap;;;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".bidimap;TreeBidiMap;true;TreeBidiMap;;;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".bidimap;UnmodifiableBidiMap;true;unmodifiableBidiMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ".bidimap;UnmodifiableBidiMap;true;unmodifiableBidiMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ".bidimap;UnmodifiableOrderedBidiMap;true;unmodifiableOrderedBidiMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ".bidimap;UnmodifiableOrderedBidiMap;true;unmodifiableOrderedBidiMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ".bidimap;UnmodifiableOrderedBidiMap;true;inverseOrderedBidiMap;;;Argument[-1].MapKey;ReturnValue.MapValue;value;manual",
          ".bidimap;UnmodifiableOrderedBidiMap;true;inverseOrderedBidiMap;;;Argument[-1].MapValue;ReturnValue.MapKey;value;manual",
          ".bidimap;UnmodifiableSortedBidiMap;true;unmodifiableSortedBidiMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ".bidimap;UnmodifiableSortedBidiMap;true;unmodifiableSortedBidiMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual"
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
          ".collection;AbstractCollectionDecorator;true;AbstractCollectionDecorator;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".collection;AbstractCollectionDecorator;true;decorated;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ".collection;AbstractCollectionDecorator;true;setCollection;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".collection;CompositeCollection$CollectionMutator;true;add;;;Argument[2];Argument[0].Element;value;manual",
          ".collection;CompositeCollection$CollectionMutator;true;add;;;Argument[2];Argument[1].Element.Element;value;manual",
          ".collection;CompositeCollection$CollectionMutator;true;addAll;;;Argument[2].Element;Argument[0].Element;value;manual",
          ".collection;CompositeCollection$CollectionMutator;true;addAll;;;Argument[2].Element;Argument[1].Element.Element;value;manual",
          ".collection;CompositeCollection;true;CompositeCollection;(Collection);;Argument[0].Element;Argument[-1].Element;value;manual",
          ".collection;CompositeCollection;true;CompositeCollection;(Collection,Collection);;Argument[0].Element;Argument[-1].Element;value;manual",
          ".collection;CompositeCollection;true;CompositeCollection;(Collection,Collection);;Argument[1].Element;Argument[-1].Element;value;manual",
          ".collection;CompositeCollection;true;CompositeCollection;(Collection[]);;Argument[0].ArrayElement.Element;Argument[-1].Element;value;manual",
          ".collection;CompositeCollection;true;addComposited;(Collection);;Argument[0].Element;Argument[-1].Element;value;manual",
          ".collection;CompositeCollection;true;addComposited;(Collection,Collection);;Argument[0].Element;Argument[-1].Element;value;manual",
          ".collection;CompositeCollection;true;addComposited;(Collection,Collection);;Argument[1].Element;Argument[-1].Element;value;manual",
          ".collection;CompositeCollection;true;addComposited;(Collection[]);;Argument[0].ArrayElement.Element;Argument[-1].Element;value;manual",
          ".collection;CompositeCollection;true;toCollection;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ".collection;CompositeCollection;true;getCollections;;;Argument[-1].Element;ReturnValue.Element.Element;value;manual",
          ".collection;IndexedCollection;true;IndexedCollection;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".collection;IndexedCollection;true;uniqueIndexedCollection;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".collection;IndexedCollection;true;nonUniqueIndexedCollection;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".collection;IndexedCollection;true;get;;;Argument[-1].Element;ReturnValue;value;manual",
          ".collection;IndexedCollection;true;values;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ".collection;PredicatedCollection$Builder;true;add;;;Argument[0];Argument[-1].Element;value;manual",
          ".collection;PredicatedCollection$Builder;true;addAll;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".collection;PredicatedCollection$Builder;true;createPredicatedList;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ".collection;PredicatedCollection$Builder;true;createPredicatedList;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".collection;PredicatedCollection$Builder;true;createPredicatedSet;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ".collection;PredicatedCollection$Builder;true;createPredicatedSet;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".collection;PredicatedCollection$Builder;true;createPredicatedMultiSet;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ".collection;PredicatedCollection$Builder;true;createPredicatedMultiSet;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".collection;PredicatedCollection$Builder;true;createPredicatedBag;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ".collection;PredicatedCollection$Builder;true;createPredicatedBag;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".collection;PredicatedCollection$Builder;true;createPredicatedQueue;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ".collection;PredicatedCollection$Builder;true;createPredicatedQueue;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".collection;PredicatedCollection$Builder;true;rejectedElements;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ".collection;PredicatedCollection;true;predicatedCollection;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".collection;SynchronizedCollection;true;synchronizedCollection;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".collection;TransformedCollection;true;transformingCollection;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".collection;UnmodifiableBoundedCollection;true;unmodifiableBoundedCollection;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".collection;UnmodifiableCollection;true;unmodifiableCollection;;;Argument[0].Element;ReturnValue.Element;value;manual"
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
          ".iterators;AbstractIteratorDecorator;true;AbstractIteratorDecorator;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".iterators;AbstractListIteratorDecorator;true;AbstractListIteratorDecorator;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".iterators;AbstractListIteratorDecorator;true;getListIterator;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ".iterators;AbstractMapIteratorDecorator;true;AbstractMapIteratorDecorator;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".iterators;AbstractMapIteratorDecorator;true;AbstractMapIteratorDecorator;;;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".iterators;AbstractMapIteratorDecorator;true;getMapIterator;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ".iterators;AbstractMapIteratorDecorator;true;getMapIterator;;;Argument[-1].MapValue;ReturnValue.MapValue;value;manual",
          ".iterators;AbstractOrderedMapIteratorDecorator;true;AbstractOrderedMapIteratorDecorator;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".iterators;AbstractOrderedMapIteratorDecorator;true;AbstractOrderedMapIteratorDecorator;;;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".iterators;AbstractOrderedMapIteratorDecorator;true;getOrderedMapIterator;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ".iterators;AbstractOrderedMapIteratorDecorator;true;getOrderedMapIterator;;;Argument[-1].MapValue;ReturnValue.MapValue;value;manual",
          ".iterators;AbstractUntypedIteratorDecorator;true;AbstractUntypedIteratorDecorator;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".iterators;AbstractUntypedIteratorDecorator;true;getIterator;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ".iterators;ArrayIterator;true;ArrayIterator;;;Argument[0].ArrayElement;Argument[-1].Element;value;manual",
          ".iterators;ArrayIterator;true;getArray;;;Argument[-1].Element;ReturnValue.ArrayElement;value;manual",
          ".iterators;ArrayListIterator;true;ArrayListIterator;;;Argument[0].ArrayElement;Argument[-1].Element;value;manual",
          ".iterators;BoundedIterator;true;BoundedIterator;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".iterators;CollatingIterator;true;CollatingIterator;(Comparator,Iterator,Iterator);;Argument[1].Element;Argument[-1].Element;value;manual",
          ".iterators;CollatingIterator;true;CollatingIterator;(Comparator,Iterator,Iterator);;Argument[2].Element;Argument[-1].Element;value;manual",
          ".iterators;CollatingIterator;true;CollatingIterator;(Comparator,Iterator[]);;Argument[1].ArrayElement.Element;Argument[-1].Element;value;manual",
          ".iterators;CollatingIterator;true;CollatingIterator;(Comparator,Collection);;Argument[1].Element.Element;Argument[-1].Element;value;manual",
          ".iterators;CollatingIterator;true;addIterator;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".iterators;CollatingIterator;true;setIterator;;;Argument[1].Element;Argument[-1].Element;value;manual",
          ".iterators;CollatingIterator;true;getIterators;;;Argument[-1].Element;ReturnValue.Element.Element;value;manual",
          ".iterators;EnumerationIterator;true;EnumerationIterator;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".iterators;EnumerationIterator;true;getEnumeration;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ".iterators;EnumerationIterator;true;setEnumeration;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".iterators;FilterIterator;true;FilterIterator;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".iterators;FilterIterator;true;getIterator;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ".iterators;FilterIterator;true;setIterator;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".iterators;FilterListIterator;true;FilterListIterator;(ListIterator);;Argument[0].Element;Argument[-1].Element;value;manual",
          ".iterators;FilterListIterator;true;FilterListIterator;(ListIterator,Predicate);;Argument[0].Element;Argument[-1].Element;value;manual",
          ".iterators;FilterListIterator;true;getListIterator;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ".iterators;FilterListIterator;true;setListIterator;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".iterators;IteratorChain;true;IteratorChain;(Iterator);;Argument[0].Element;Argument[-1].Element;value;manual",
          ".iterators;IteratorChain;true;IteratorChain;(Iterator,Iterator);;Argument[0].Element;Argument[-1].Element;value;manual",
          ".iterators;IteratorChain;true;IteratorChain;(Iterator,Iterator);;Argument[1].Element;Argument[-1].Element;value;manual",
          ".iterators;IteratorChain;true;IteratorChain;(Iterator[]);;Argument[0].ArrayElement.Element;Argument[-1].Element;value;manual",
          ".iterators;IteratorChain;true;IteratorChain;(Collection);;Argument[0].Element.Element;Argument[-1].Element;value;manual",
          ".iterators;IteratorChain;true;addIterator;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".iterators;IteratorEnumeration;true;IteratorEnumeration;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".iterators;IteratorEnumeration;true;getIterator;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ".iterators;IteratorEnumeration;true;setIterator;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".iterators;IteratorIterable;true;IteratorIterable;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".iterators;ListIteratorWrapper;true;ListIteratorWrapper;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".iterators;LoopingIterator;true;LoopingIterator;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".iterators;LoopingListIterator;true;LoopingListIterator;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".iterators;ObjectArrayIterator;true;ObjectArrayIterator;;;Argument[0].ArrayElement;Argument[-1].Element;value;manual",
          ".iterators;ObjectArrayIterator;true;getArray;;;Argument[-1].Element;ReturnValue.ArrayElement;value;manual",
          ".iterators;ObjectArrayListIterator;true;ObjectArrayListIterator;;;Argument[0].ArrayElement;Argument[-1].Element;value;manual",
          ".iterators;PeekingIterator;true;PeekingIterator;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".iterators;PeekingIterator;true;peekingIterator;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".iterators;PeekingIterator;true;peek;;;Argument[-1].Element;ReturnValue;value;manual",
          ".iterators;PeekingIterator;true;element;;;Argument[-1].Element;ReturnValue;value;manual",
          ".iterators;PermutationIterator;true;PermutationIterator;;;Argument[0].Element;Argument[-1].Element.Element;value;manual",
          ".iterators;PushbackIterator;true;PushbackIterator;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".iterators;PushbackIterator;true;pushbackIterator;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".iterators;PushbackIterator;true;pushback;;;Argument[0];Argument[-1].Element;value;manual",
          ".iterators;ReverseListIterator;true;ReverseListIterator;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".iterators;SingletonIterator;true;SingletonIterator;;;Argument[0];Argument[-1].Element;value;manual",
          ".iterators;SingletonListIterator;true;SingletonListIterator;;;Argument[0];Argument[-1].Element;value;manual",
          ".iterators;SkippingIterator;true;SkippingIterator;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".iterators;UniqueFilterIterator;true;UniqueFilterIterator;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".iterators;UnmodifiableIterator;true;unmodifiableIterator;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".iterators;UnmodifiableListIterator;true;umodifiableListIterator;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".iterators;UnmodifiableMapIterator;true;unmodifiableMapIterator;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".iterators;UnmodifiableMapIterator;true;unmodifiableMapIterator;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ".iterators;UnmodifiableOrderedMapIterator;true;unmodifiableOrderedMapIterator;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".iterators;UnmodifiableOrderedMapIterator;true;unmodifiableOrderedMapIterator;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ".iterators;ZippingIterator;true;ZippingIterator;(Iterator[]);;Argument[0].ArrayElement.Element;Argument[-1].Element;value;manual",
          ".iterators;ZippingIterator;true;ZippingIterator;(Iterator,Iterator);;Argument[0].Element;Argument[-1].Element;value;manual",
          ".iterators;ZippingIterator;true;ZippingIterator;(Iterator,Iterator);;Argument[1].Element;Argument[-1].Element;value;manual",
          ".iterators;ZippingIterator;true;ZippingIterator;(Iterator,Iterator,Iterator);;Argument[0].Element;Argument[-1].Element;value;manual",
          ".iterators;ZippingIterator;true;ZippingIterator;(Iterator,Iterator,Iterator);;Argument[1].Element;Argument[-1].Element;value;manual",
          ".iterators;ZippingIterator;true;ZippingIterator;(Iterator,Iterator,Iterator);;Argument[2].Element;Argument[-1].Element;value;manual"
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
          ".list;AbstractLinkedList;true;AbstractLinkedList;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".list;AbstractLinkedList;true;getFirst;;;Argument[-1].Element;ReturnValue;value;manual",
          ".list;AbstractLinkedList;true;getLast;;;Argument[-1].Element;ReturnValue;value;manual",
          ".list;AbstractLinkedList;true;addFirst;;;Argument[0];Argument[-1].Element;value;manual",
          ".list;AbstractLinkedList;true;addLast;;;Argument[0];Argument[-1].Element;value;manual",
          ".list;AbstractLinkedList;true;removeFirst;;;Argument[-1].Element;ReturnValue;value;manual",
          ".list;AbstractLinkedList;true;removeLast;;;Argument[-1].Element;ReturnValue;value;manual",
          ".list;AbstractListDecorator;true;AbstractListDecorator;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".list;AbstractSerializableListDecorator;true;AbstractSerializableListDecorator;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".list;CursorableLinkedList;true;CursorableLinkedList;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".list;CursorableLinkedList;true;cursor;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ".list;FixedSizeList;true;fixedSizeList;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".list;GrowthList;true;growthList;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".list;LazyList;true;lazyList;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".list;NodeCachingLinkedList;true;NodeCachingLinkedList;(Collection);;Argument[0].Element;Argument[-1].Element;value;manual",
          ".list;PredicatedList;true;predicatedList;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".list;SetUniqueList;true;setUniqueList;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".list;SetUniqueList;true;asSet;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ".list;TransformedList;true;transformingList;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".list;TreeList;true;TreeList;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".list;UnmodifiableList;true;UnmodifiableList;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".list;UnmodifiableList;true;unmodifiableList;;;Argument[0].Element;ReturnValue.Element;value;manual"
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
          ".map;AbstractHashedMap;true;AbstractHashedMap;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".map;AbstractHashedMap;true;AbstractHashedMap;(Map);;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".map;AbstractLinkedMap;true;AbstractLinkedMap;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".map;AbstractLinkedMap;true;AbstractLinkedMap;(Map);;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".map;AbstractMapDecorator;true;AbstractMapDecorator;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".map;AbstractMapDecorator;true;AbstractMapDecorator;(Map);;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".map;AbstractMapDecorator;true;decorated;;;Argument[-1].MapKey;ReturnValue.MapKey;value;manual",
          ".map;AbstractMapDecorator;true;decorated;;;Argument[-1].MapValue;ReturnValue.MapValue;value;manual",
          ".map;AbstractOrderedMapDecorator;true;AbstractOrderedMapDecorator;(OrderedMap);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".map;AbstractOrderedMapDecorator;true;AbstractOrderedMapDecorator;(OrderedMap);;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".map;AbstractSortedMapDecorator;true;AbstractSortedMapDecorator;(SortedMap);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".map;AbstractSortedMapDecorator;true;AbstractSortedMapDecorator;(SortedMap);;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".map;CaseInsensitiveMap;true;CaseInsensitiveMap;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".map;CaseInsensitiveMap;true;CaseInsensitiveMap;(Map);;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".map;CompositeMap;true;CompositeMap;(Map,Map);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".map;CompositeMap;true;CompositeMap;(Map,Map);;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".map;CompositeMap;true;CompositeMap;(Map,Map);;Argument[1].MapKey;Argument[-1].MapKey;value;manual",
          ".map;CompositeMap;true;CompositeMap;(Map,Map);;Argument[1].MapValue;Argument[-1].MapValue;value;manual",
          ".map;CompositeMap;true;CompositeMap;(Map,Map,MapMutator);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".map;CompositeMap;true;CompositeMap;(Map,Map,MapMutator);;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".map;CompositeMap;true;CompositeMap;(Map,Map,MapMutator);;Argument[1].MapKey;Argument[-1].MapKey;value;manual",
          ".map;CompositeMap;true;CompositeMap;(Map,Map,MapMutator);;Argument[1].MapValue;Argument[-1].MapValue;value;manual",
          ".map;CompositeMap;true;CompositeMap;(Map[]);;Argument[0].ArrayElement.MapKey;Argument[-1].MapKey;value;manual",
          ".map;CompositeMap;true;CompositeMap;(Map[]);;Argument[0].ArrayElement.MapValue;Argument[-1].MapValue;value;manual",
          ".map;CompositeMap;true;CompositeMap;(Map[],MapMutator);;Argument[0].ArrayElement.MapKey;Argument[-1].MapKey;value;manual",
          ".map;CompositeMap;true;CompositeMap;(Map[],MapMutator);;Argument[0].ArrayElement.MapValue;Argument[-1].MapValue;value;manual",
          ".map;CompositeMap;true;addComposited;;;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".map;CompositeMap;true;addComposited;;;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".map;CompositeMap;true;removeComposited;;;Argument[-1].MapKey;ReturnValue.MapKey;value;manual",
          ".map;CompositeMap;true;removeComposited;;;Argument[-1].MapValue;ReturnValue.MapValue;value;manual",
          ".map;CompositeMap;true;removeComposited;;;Argument[0];ReturnValue;value;manual",
          ".map;DefaultedMap;true;DefaultedMap;(Object);;Argument[0];Argument[-1].MapValue;value;manual",
          ".map;DefaultedMap;true;defaultedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ".map;DefaultedMap;true;defaultedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ".map;DefaultedMap;true;defaultedMap;(Map,Object);;Argument[1];ReturnValue.MapValue;value;manual",
          ".map;EntrySetToMapIteratorAdapter;true;EntrySetToMapIteratorAdapter;;;Argument[0].Element.MapKey;Argument[-1].Element;value;manual",
          ".map;EntrySetToMapIteratorAdapter;true;EntrySetToMapIteratorAdapter;;;Argument[0].Element.MapValue;Argument[-1].MapValue;value;manual",
          ".map;FixedSizeMap;true;fixedSizeMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ".map;FixedSizeMap;true;fixedSizeMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ".map;FixedSizeSortedMap;true;fixedSizeSortedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ".map;FixedSizeSortedMap;true;fixedSizeSortedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ".map;Flat3Map;true;Flat3Map;;;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".map;Flat3Map;true;Flat3Map;;;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".map;HashedMap;true;HashedMap;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".map;HashedMap;true;HashedMap;(Map);;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".map;LazyMap;true;lazyMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ".map;LazyMap;true;lazyMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ".map;LazySortedMap;true;lazySortedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ".map;LazySortedMap;true;lazySortedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ".map;LinkedMap;true;LinkedMap;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".map;LinkedMap;true;LinkedMap;(Map);;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".map;LinkedMap;true;get;(int);;Argument[-1].MapKey;ReturnValue;value;manual",
          ".map;LinkedMap;true;getValue;(int);;Argument[-1].MapValue;ReturnValue;value;manual",
          ".map;LinkedMap;true;remove;(int);;Argument[-1].MapValue;ReturnValue;value;manual",
          ".map;LinkedMap;true;asList;;;Argument[-1].MapKey;ReturnValue.Element;value;manual",
          ".map;ListOrderedMap;true;listOrderedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ".map;ListOrderedMap;true;listOrderedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ".map;ListOrderedMap;true;putAll;;;Argument[1].MapKey;Argument[-1].MapKey;value;manual",
          ".map;ListOrderedMap;true;putAll;;;Argument[1].MapValue;Argument[-1].MapValue;value;manual",
          ".map;ListOrderedMap;true;keyList;;;Argument[-1].MapKey;ReturnValue.Element;value;manual",
          ".map;ListOrderedMap;true;valueList;;;Argument[-1].MapValue;ReturnValue.Element;value;manual",
          ".map;ListOrderedMap;true;get;(int);;Argument[-1].MapKey;ReturnValue;value;manual",
          ".map;ListOrderedMap;true;getValue;(int);;Argument[-1].MapValue;ReturnValue;value;manual",
          ".map;ListOrderedMap;true;setValue;;;Argument[1];Argument[-1].MapValue;value;manual",
          ".map;ListOrderedMap;true;put;;;Argument[1];Argument[-1].MapKey;value;manual",
          ".map;ListOrderedMap;true;put;;;Argument[2];Argument[-1].MapValue;value;manual",
          ".map;ListOrderedMap;true;remove;(int);;Argument[-1].MapValue;ReturnValue;value;manual",
          ".map;ListOrderedMap;true;asList;;;Argument[-1].MapKey;ReturnValue.Element;value;manual",
          ".map;LRUMap;true;LRUMap;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".map;LRUMap;true;LRUMap;(Map);;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".map;LRUMap;true;LRUMap;(Map,boolean);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".map;LRUMap;true;LRUMap;(Map,boolean);;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".map;LRUMap;true;get;(Object,boolean);;Argument[0].MapValue;ReturnValue;value;manual",
          ".map;MultiKeyMap;true;get;;;Argument[-1].MapValue;ReturnValue;value;manual",
          ".map;MultiKeyMap;true;put;;;Argument[-1].MapValue;ReturnValue;value;manual",
          ".map;MultiKeyMap;true;put;(Object,Object,Object);;Argument[0..1];Argument[-1].MapKey.Element;value;manual",
          ".map;MultiKeyMap;true;put;(Object,Object,Object,Object);;Argument[0..2];Argument[-1].MapKey.Element;value;manual",
          ".map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object);;Argument[0..3];Argument[-1].MapKey.Element;value;manual",
          ".map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object,Object);;Argument[0..4];Argument[-1].MapKey.Element;value;manual",
          ".map;MultiKeyMap;true;put;(Object,Object,Object);;Argument[2];Argument[-1].MapValue;value;manual",
          ".map;MultiKeyMap;true;put;(Object,Object,Object,Object);;Argument[3];Argument[-1].MapValue;value;manual",
          ".map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object);;Argument[4];Argument[-1].MapValue;value;manual",
          ".map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object,Object);;Argument[5];Argument[-1].MapValue;value;manual",
          ".map;MultiKeyMap;true;removeMultiKey;;;Argument[-1].MapValue;ReturnValue;value;manual",
          ".map;MultiValueMap;true;multiValueMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ".map;MultiValueMap;true;multiValueMap;;;Argument[0].MapValue.Element;ReturnValue.MapValue.Element;value;manual",
          ".map;MultiValueMap;true;getCollection;;;Argument[-1].MapValue.Element;ReturnValue.Element;value;manual",
          ".map;MultiValueMap;true;putAll;(Map);;Argument[0].MapValue;Argument[-1].MapValue.Element;value;manual",
          ".map;MultiValueMap;true;putAll;(Map);;Argument[0].MapValue.Element;Argument[-1].MapValue.Element;value;manual",
          ".map;MultiValueMap;true;values;;;Argument[-1].MapValue.Element;ReturnValue.Element;value;manual",
          ".map;MultiValueMap;true;putAll;(Object,Collection);;Argument[0];Argument[-1].MapKey;value;manual",
          ".map;MultiValueMap;true;putAll;(Object,Collection);;Argument[1].Element;Argument[-1].MapValue.Element;value;manual",
          ".map;MultiValueMap;true;iterator;(Object);;Argument[-1].MapValue.Element;ReturnValue.Element;value;manual",
          ".map;MultiValueMap;true;iterator;();;Argument[-1].MapKey;ReturnValue.Element.MapKey;value;manual",
          ".map;MultiValueMap;true;iterator;();;Argument[-1].MapValue.Element;ReturnValue.Element.MapValue;value;manual",
          ".map;PassiveExpiringMap;true;PassiveExpiringMap;(ExpirationPolicy,Map);;Argument[1].MapKey;Argument[-1].MapKey;value;manual",
          ".map;PassiveExpiringMap;true;PassiveExpiringMap;(ExpirationPolicy,Map);;Argument[1].MapValue;Argument[-1].MapValue;value;manual",
          ".map;PassiveExpiringMap;true;PassiveExpiringMap;(long,Map);;Argument[1].MapKey;Argument[-1].MapKey;value;manual",
          ".map;PassiveExpiringMap;true;PassiveExpiringMap;(long,Map);;Argument[1].MapValue;Argument[-1].MapValue;value;manual",
          ".map;PassiveExpiringMap;true;PassiveExpiringMap;(long,TimeUnit,Map);;Argument[2].MapKey;Argument[-1].MapKey;value;manual",
          ".map;PassiveExpiringMap;true;PassiveExpiringMap;(long,TimeUnit,Map);;Argument[2].MapValue;Argument[-1].MapValue;value;manual",
          ".map;PassiveExpiringMap;true;PassiveExpiringMap;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".map;PassiveExpiringMap;true;PassiveExpiringMap;(Map);;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".map;PredicatedMap;true;predicatedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ".map;PredicatedMap;true;predicatedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ".map;PredicatedSortedMap;true;predicatedSortedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ".map;PredicatedSortedMap;true;predicatedSortedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ".map;SingletonMap;true;SingletonMap;(Object,Object);;Argument[0];Argument[-1].MapKey;value;manual",
          ".map;SingletonMap;true;SingletonMap;(Object,Object);;Argument[1];Argument[-1].MapValue;value;manual",
          ".map;SingletonMap;true;SingletonMap;(KeyValue);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".map;SingletonMap;true;SingletonMap;(KeyValue);;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".map;SingletonMap;true;SingletonMap;(Entry);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".map;SingletonMap;true;SingletonMap;(Entry);;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".map;SingletonMap;true;SingletonMap;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".map;SingletonMap;true;SingletonMap;(Map);;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".map;SingletonMap;true;setValue;;;Argument[0];Argument[-1].MapValue;value;manual",
          ".map;TransformedMap;true;transformingMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ".map;TransformedMap;true;transformingMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ".map;TransformedSortedMap;true;transformingSortedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ".map;TransformedSortedMap;true;transformingSortedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ".map;UnmodifiableEntrySet;true;unmodifiableEntrySet;;;Argument[0].Element.MapKey;ReturnValue.Element.MapKey;value;manual",
          ".map;UnmodifiableEntrySet;true;unmodifiableEntrySet;;;Argument[0].Element.MapValue;ReturnValue.Element.MapValue;value;manual",
          ".map;UnmodifiableMap;true;unmodifiableMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ".map;UnmodifiableMap;true;unmodifiableMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ".map;UnmodifiableOrderedMap;true;unmodifiableOrderedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ".map;UnmodifiableOrderedMap;true;unmodifiableOrderedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ".map;UnmodifiableSortedMap;true;unmodifiableSortedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ".map;UnmodifiableSortedMap;true;unmodifiableSortedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual"
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
          ".multimap;ArrayListValuedHashMap;true;ArrayListValuedHashMap;(MultiValuedMap);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".multimap;ArrayListValuedHashMap;true;ArrayListValuedHashMap;(MultiValuedMap);;Argument[0].MapValue.Element;Argument[-1].MapValue.Element;value;manual",
          ".multimap;ArrayListValuedHashMap;true;ArrayListValuedHashMap;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".multimap;ArrayListValuedHashMap;true;ArrayListValuedHashMap;(Map);;Argument[0].MapValue;Argument[-1].MapValue.Element;value;manual",
          ".multimap;HashSetValuedHashMap;true;HashSetValuedHashMap;(MultiValuedMap);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".multimap;HashSetValuedHashMap;true;HashSetValuedHashMap;(MultiValuedMap);;Argument[0].MapValue.Element;Argument[-1].MapValue.Element;value;manual",
          ".multimap;HashSetValuedHashMap;true;HashSetValuedHashMap;(Map);;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".multimap;HashSetValuedHashMap;true;HashSetValuedHashMap;(Map);;Argument[0].MapValue;Argument[-1].MapValue.Element;value;manual",
          ".multimap;TransformedMultiValuedMap;true;transformingMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ".multimap;TransformedMultiValuedMap;true;transformingMap;;;Argument[0].MapValue.Element;ReturnValue.MapValue.Element;value;manual",
          ".multimap;UnmodifiableMultiValuedMap;true;unmodifiableMultiValuedMap;(MultiValuedMap);;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ".multimap;UnmodifiableMultiValuedMap;true;unmodifiableMultiValuedMap;(MultiValuedMap);;Argument[0].MapValue.Element;ReturnValue.MapValue.Element;value;manual"
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
          ".multiset;HashMultiSet;true;HashMultiSet;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".multiset;PredicatedMultiSet;true;predicatedMultiSet;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".multiset;SynchronizedMultiSet;true;synchronizedMultiSet;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".multiset;UnmodifiableMultiSet;true;unmodifiableMultiSet;;;Argument[0].Element;ReturnValue.Element;value;manual"
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
          ".properties;AbstractPropertiesFactory;true;load;(ClassLoader,String);;Argument[1];ReturnValue;taint;manual",
          ".properties;AbstractPropertiesFactory;true;load;(File);;Argument[0];ReturnValue;taint;manual",
          ".properties;AbstractPropertiesFactory;true;load;(InputStream);;Argument[0];ReturnValue;taint;manual",
          ".properties;AbstractPropertiesFactory;true;load;(Path);;Argument[0];ReturnValue;taint;manual",
          ".properties;AbstractPropertiesFactory;true;load;(Reader);;Argument[0];ReturnValue;taint;manual",
          ".properties;AbstractPropertiesFactory;true;load;(String);;Argument[0];ReturnValue;taint;manual",
          ".properties;AbstractPropertiesFactory;true;load;(URI);;Argument[0];ReturnValue;taint;manual",
          ".properties;AbstractPropertiesFactory;true;load;(URL);;Argument[0];ReturnValue;taint;manual"
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
          ".queue;CircularFifoQueue;true;CircularFifoQueue;(Collection);;Argument[0].Element;Argument[-1].Element;value;manual",
          ".queue;CircularFifoQueue;true;get;;;Argument[-1].Element;ReturnValue;value;manual",
          ".queue;PredicatedQueue;true;predicatedQueue;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".queue;SynchronizedQueue;true;synchronizedQueue;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".queue;TransformedQueue;true;transformingQueue;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".queue;UnmodifiableQueue;true;unmodifiableQueue;;;Argument[0].Element;ReturnValue.Element;value;manual"
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
          ".set;AbstractNavigableSetDecorator;true;AbstractNavigableSetDecorator;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".set;AbstractSetDecorator;true;AbstractSetDecorator;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".set;AbstractSortedSetDecorator;true;AbstractSortedSetDecorator;;;Argument[0].Element;Argument[-1].Element;value;manual",
          ".set;CompositeSet$SetMutator;true;add;;;Argument[2];Argument[0].Element;value;manual",
          ".set;CompositeSet$SetMutator;true;add;;;Argument[2];Argument[1].Element.Element;value;manual",
          ".set;CompositeSet$SetMutator;true;addAll;;;Argument[2].Element;Argument[0].Element;value;manual",
          ".set;CompositeSet$SetMutator;true;addAll;;;Argument[2].Element;Argument[1].Element.Element;value;manual",
          ".set;CompositeSet;true;CompositeSet;(Set);;Argument[0].Element;Argument[-1].Element;value;manual",
          ".set;CompositeSet;true;CompositeSet;(Set[]);;Argument[0].ArrayElement.Element;Argument[-1].Element;value;manual",
          ".set;CompositeSet;true;addComposited;(Set);;Argument[0].Element;Argument[-1].Element;value;manual",
          ".set;CompositeSet;true;addComposited;(Set,Set);;Argument[0].Element;Argument[-1].Element;value;manual",
          ".set;CompositeSet;true;addComposited;(Set,Set);;Argument[1].Element;Argument[-1].Element;value;manual",
          ".set;CompositeSet;true;addComposited;(Set[]);;Argument[0].ArrayElement.Element;Argument[-1].Element;value;manual",
          ".set;CompositeSet;true;toSet;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ".set;CompositeSet;true;getSets;;;Argument[-1].Element;ReturnValue.Element.Element;value;manual",
          ".set;ListOrderedSet;true;listOrderedSet;(Set);;Argument[0].Element;ReturnValue.Element;value;manual",
          ".set;ListOrderedSet;true;listOrderedSet;(List);;Argument[0].Element;ReturnValue.Element;value;manual",
          ".set;ListOrderedSet;true;asList;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ".set;ListOrderedSet;true;get;;;Argument[-1].Element;ReturnValue;value;manual",
          ".set;ListOrderedSet;true;add;;;Argument[1];Argument[-1].Element;value;manual",
          ".set;ListOrderedSet;true;addAll;;;Argument[1].Element;Argument[-1].Element;value;manual",
          ".set;MapBackedSet;true;mapBackedSet;;;Argument[0].MapKey;ReturnValue.Element;value;manual",
          ".set;PredicatedNavigableSet;true;predicatedNavigableSet;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".set;PredicatedSet;true;predicatedSet;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".set;PredicatedSortedSet;true;predicatedSortedSet;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".set;TransformedNavigableSet;true;transformingNavigableSet;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".set;TransformedSet;true;transformingSet;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".set;TransformedSortedSet;true;transformingSortedSet;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".set;UnmodifiableNavigableSet;true;unmodifiableNavigableSet;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".set;UnmodifiableSet;true;unmodifiableSet;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ".set;UnmodifiableSortedSet;true;unmodifiableSortedSet;;;Argument[0].Element;ReturnValue.Element;value;manual"
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
          ".splitmap;AbstractIterableGetMapDecorator;true;AbstractIterableGetMapDecorator;;;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".splitmap;AbstractIterableGetMapDecorator;true;AbstractIterableGetMapDecorator;;;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".splitmap;TransformedSplitMap;true;transformingMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ".splitmap;TransformedSplitMap;true;transformingMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual"
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
          ".trie;PatriciaTrie;true;PatriciaTrie;;;Argument[0].MapKey;Argument[-1].MapKey;value;manual",
          ".trie;PatriciaTrie;true;PatriciaTrie;;;Argument[0].MapValue;Argument[-1].MapValue;value;manual",
          ".trie;AbstractPatriciaTrie;true;select;;;Argument[-1].MapKey;ReturnValue.MapKey;value;manual",
          ".trie;AbstractPatriciaTrie;true;select;;;Argument[-1].MapValue;ReturnValue.MapValue;value;manual",
          ".trie;AbstractPatriciaTrie;true;selectKey;;;Argument[-1].MapKey;ReturnValue;value;manual",
          ".trie;AbstractPatriciaTrie;true;selectValue;;;Argument[-1].MapValue;ReturnValue;value;manual",
          ".trie;UnmodifiableTrie;true;unmodifiableTrie;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ".trie;UnmodifiableTrie;true;unmodifiableTrie;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual"
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
          ";MapUtils;true;emptyIfNull;;;Argument[0];ReturnValue;value;manual",
          ";MapUtils;true;fixedSizeMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ";MapUtils;true;fixedSizeMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ";MapUtils;true;fixedSizeSortedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ";MapUtils;true;fixedSizeSortedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ";MapUtils;true;getMap;;;Argument[0].MapValue;ReturnValue;value;manual",
          ";MapUtils;true;getMap;;;Argument[2];ReturnValue;value;manual",
          ";MapUtils;true;getObject;;;Argument[0].MapValue;ReturnValue;value;manual",
          ";MapUtils;true;getObject;;;Argument[2];ReturnValue;value;manual",
          ";MapUtils;true;getString;;;Argument[0].MapValue;ReturnValue;value;manual",
          ";MapUtils;true;getString;;;Argument[2];ReturnValue;value;manual",
          ";MapUtils;true;invertMap;;;Argument[0].MapKey;ReturnValue.MapValue;value;manual",
          ";MapUtils;true;invertMap;;;Argument[0].MapValue;ReturnValue.MapKey;value;manual",
          ";MapUtils;true;iterableMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ";MapUtils;true;iterableMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ";MapUtils;true;iterableSortedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ";MapUtils;true;iterableSortedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ";MapUtils;true;lazyMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ";MapUtils;true;lazyMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ";MapUtils;true;lazySortedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ";MapUtils;true;lazySortedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ";MapUtils;true;multiValueMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ";MapUtils;true;multiValueMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ";MapUtils;true;orderedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ";MapUtils;true;orderedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ";MapUtils;true;populateMap;(Map,Iterable,Transformer);;Argument[1].Element;Argument[0].MapValue;value;manual",
          ";MapUtils;true;populateMap;(MultiMap,Iterable,Transformer);;Argument[1].Element;Argument[0].MapValue.Element;value;manual",
          ";MapUtils;true;predicatedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ";MapUtils;true;predicatedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ";MapUtils;true;predicatedSortedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ";MapUtils;true;predicatedSortedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ";MapUtils;true;putAll;;;Argument[1].ArrayElement;Argument[0].MapKey;value;manual",
          ";MapUtils;true;putAll;;;Argument[1].ArrayElement;ReturnValue.MapKey;value;manual",
          ";MapUtils;true;putAll;;;Argument[1].ArrayElement;Argument[0].MapValue;value;manual",
          ";MapUtils;true;putAll;;;Argument[1].ArrayElement;ReturnValue.MapValue;value;manual",
          ";MapUtils;true;putAll;;;Argument[1].ArrayElement.ArrayElement;Argument[0].MapKey;value;manual",
          ";MapUtils;true;putAll;;;Argument[1].ArrayElement.ArrayElement;ReturnValue.MapKey;value;manual",
          ";MapUtils;true;putAll;;;Argument[1].ArrayElement.ArrayElement;Argument[0].MapValue;value;manual",
          ";MapUtils;true;putAll;;;Argument[1].ArrayElement.ArrayElement;ReturnValue.MapValue;value;manual",
          ";MapUtils;true;putAll;;;Argument[1].ArrayElement.MapKey;Argument[0].MapKey;value;manual",
          ";MapUtils;true;putAll;;;Argument[1].ArrayElement.MapKey;ReturnValue.MapKey;value;manual",
          ";MapUtils;true;putAll;;;Argument[1].ArrayElement.MapValue;Argument[0].MapValue;value;manual",
          ";MapUtils;true;putAll;;;Argument[1].ArrayElement.MapValue;ReturnValue.MapValue;value;manual",
          ";MapUtils;true;safeAddToMap;;;Argument[1];Argument[0].MapKey;value;manual",
          ";MapUtils;true;safeAddToMap;;;Argument[2];Argument[0].MapValue;value;manual",
          ";MapUtils;true;synchronizedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ";MapUtils;true;synchronizedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ";MapUtils;true;synchronizedSortedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ";MapUtils;true;synchronizedSortedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ";MapUtils;true;toMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ";MapUtils;true;toMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ";MapUtils;true;transformedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ";MapUtils;true;transformedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ";MapUtils;true;transformedSortedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ";MapUtils;true;transformedSortedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ";MapUtils;true;unmodifiableMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ";MapUtils;true;unmodifiableMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ";MapUtils;true;unmodifiableSortedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ";MapUtils;true;unmodifiableSortedMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual"
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
          ";CollectionUtils;true;addAll;(Collection,Object[]);;Argument[1].ArrayElement;Argument[0].Element;value;manual",
          ";CollectionUtils;true;addAll;(Collection,Enumeration);;Argument[1].Element;Argument[0].Element;value;manual",
          ";CollectionUtils;true;addAll;(Collection,Iterable);;Argument[1].Element;Argument[0].Element;value;manual",
          ";CollectionUtils;true;addAll;(Collection,Iterator);;Argument[1].Element;Argument[0].Element;value;manual",
          ";CollectionUtils;true;addIgnoreNull;;;Argument[1];Argument[0].Element;value;manual",
          ";CollectionUtils;true;collate;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";CollectionUtils;true;collate;;;Argument[1].Element;ReturnValue.Element;value;manual",
          ";CollectionUtils;true;disjunction;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";CollectionUtils;true;disjunction;;;Argument[1].Element;ReturnValue.Element;value;manual",
          ";CollectionUtils;true;emptyIfNull;;;Argument[0];ReturnValue;value;manual",
          ";CollectionUtils;true;extractSingleton;;;Argument[0].Element;ReturnValue;value;manual",
          ";CollectionUtils;true;find;;;Argument[0].Element;ReturnValue;value;manual",
          ";CollectionUtils;true;get;(Iterator,int);;Argument[0].Element;ReturnValue;value;manual",
          ";CollectionUtils;true;get;(Iterable,int);;Argument[0].Element;ReturnValue;value;manual",
          ";CollectionUtils;true;get;(Map,int);;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ";CollectionUtils;true;get;(Map,int);;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ";CollectionUtils;true;get;(Object,int);;Argument[0].ArrayElement;ReturnValue;value;manual",
          ";CollectionUtils;true;get;(Object,int);;Argument[0].Element;ReturnValue;value;manual",
          ";CollectionUtils;true;get;(Object,int);;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ";CollectionUtils;true;get;(Object,int);;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ";CollectionUtils;true;getCardinalityMap;;;Argument[0].Element;ReturnValue.MapKey;value;manual",
          ";CollectionUtils;true;intersection;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";CollectionUtils;true;intersection;;;Argument[1].Element;ReturnValue.Element;value;manual",
          ";CollectionUtils;true;permutations;;;Argument[0].Element;ReturnValue.Element.Element;value;manual",
          ";CollectionUtils;true;predicatedCollection;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";CollectionUtils;true;removeAll;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";CollectionUtils;true;retainAll;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";CollectionUtils;true;select;(Iterable,Predicate);;Argument[0].Element;ReturnValue.Element;value;manual",
          ";CollectionUtils;true;select;(Iterable,Predicate,Collection);;Argument[0].Element;Argument[2].Element;value;manual",
          ";CollectionUtils;true;select;(Iterable,Predicate,Collection);;Argument[2];ReturnValue;value;manual",
          ";CollectionUtils;true;select;(Iterable,Predicate,Collection,Collection);;Argument[0].Element;Argument[2].Element;value;manual",
          ";CollectionUtils;true;select;(Iterable,Predicate,Collection,Collection);;Argument[0].Element;Argument[3].Element;value;manual",
          ";CollectionUtils;true;select;(Iterable,Predicate,Collection,Collection);;Argument[2];ReturnValue;value;manual",
          ";CollectionUtils;true;selectRejected;(Iterable,Predicate);;Argument[0].Element;ReturnValue.Element;value;manual",
          ";CollectionUtils;true;selectRejected;(Iterable,Predicate,Collection);;Argument[0].Element;Argument[2].Element;value;manual",
          ";CollectionUtils;true;selectRejected;(Iterable,Predicate,Collection);;Argument[2];ReturnValue;value;manual",
          ";CollectionUtils;true;subtract;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";CollectionUtils;true;synchronizedCollection;;;Argument[0].Element;ReturnValue.Element;value;manual",
          // Note that `CollectionUtils.transformingCollection` does not transform existing list elements
          ";CollectionUtils;true;transformingCollection;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";CollectionUtils;true;union;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";CollectionUtils;true;union;;;Argument[1].Element;ReturnValue.Element;value;manual",
          ";CollectionUtils;true;unmodifiableCollection;;;Argument[0].Element;ReturnValue.Element;value;manual"
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
          ";ListUtils;true;defaultIfNull;;;Argument[0];ReturnValue;value;manual",
          ";ListUtils;true;defaultIfNull;;;Argument[1];ReturnValue;value;manual",
          ";ListUtils;true;emptyIfNull;;;Argument[0];ReturnValue;value;manual",
          ";ListUtils;true;fixedSizeList;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";ListUtils;true;intersection;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";ListUtils;true;intersection;;;Argument[1].Element;ReturnValue.Element;value;manual",
          // Note that `ListUtils.lazyList` does not transform existing list elements
          ";ListUtils;true;lazyList;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";ListUtils;true;longestCommonSubsequence;(CharSequence,CharSequence);;Argument[0];ReturnValue;taint;manual",
          ";ListUtils;true;longestCommonSubsequence;(CharSequence,CharSequence);;Argument[1];ReturnValue;taint;manual",
          ";ListUtils;true;longestCommonSubsequence;(List,List);;Argument[0].Element;ReturnValue.Element;value;manual",
          ";ListUtils;true;longestCommonSubsequence;(List,List);;Argument[1].Element;ReturnValue.Element;value;manual",
          ";ListUtils;true;longestCommonSubsequence;(List,List,Equator);;Argument[0].Element;ReturnValue.Element;value;manual",
          ";ListUtils;true;longestCommonSubsequence;(List,List,Equator);;Argument[1].Element;ReturnValue.Element;value;manual",
          ";ListUtils;true;partition;;;Argument[0].Element;ReturnValue.Element.Element;value;manual",
          ";ListUtils;true;predicatedList;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";ListUtils;true;removeAll;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";ListUtils;true;retainAll;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";ListUtils;true;select;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";ListUtils;true;selectRejected;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";ListUtils;true;subtract;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";ListUtils;true;sum;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";ListUtils;true;sum;;;Argument[1].Element;ReturnValue.Element;value;manual",
          ";ListUtils;true;synchronizedList;;;Argument[0].Element;ReturnValue.Element;value;manual",
          // Note that `ListUtils.transformedList` does not transform existing list elements
          ";ListUtils;true;transformedList;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";ListUtils;true;union;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";ListUtils;true;union;;;Argument[1].Element;ReturnValue.Element;value;manual",
          ";ListUtils;true;unmodifiableList;;;Argument[0].Element;ReturnValue.Element;value;manual"
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
          ";IteratorUtils;true;arrayIterator;;;Argument[0].ArrayElement;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;arrayListIterator;;;Argument[0].ArrayElement;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;asEnumeration;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;asIterable;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;asIterator;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;asMultipleUseIterable;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;boundedIterator;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;chainedIterator;(Collection);;Argument[0].Element.Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;chainedIterator;(Iterator[]);;Argument[0].ArrayElement.Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;chainedIterator;(Iterator,Iterator);;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;chainedIterator;(Iterator,Iterator);;Argument[1].Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;collatedIterator;(Comparator,Collection);;Argument[1].Element.Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;collatedIterator;(Comparator,Iterator[]);;Argument[1].ArrayElement.Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;collatedIterator;(Comparator,Iterator,Iterator);;Argument[1].Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;collatedIterator;(Comparator,Iterator,Iterator);;Argument[2].Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;filteredIterator;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;filteredListIterator;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;find;;;Argument[0].Element;ReturnValue;value;manual",
          ";IteratorUtils;true;first;;;Argument[0].Element;ReturnValue;value;manual",
          ";IteratorUtils;true;forEachButLast;;;Argument[0].Element;ReturnValue;value;manual",
          ";IteratorUtils;true;get;;;Argument[0].Element;ReturnValue;value;manual",
          ";IteratorUtils;true;getIterator;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;getIterator;;;Argument[0].ArrayElement;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;getIterator;;;Argument[0];ReturnValue.Element;value;manual",
          ";IteratorUtils;true;getIterator;;;Argument[0].MapValue;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;loopingIterator;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;loopingListIterator;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;peekingIterator;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;pushbackIterator;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;singletonIterator;;;Argument[0];ReturnValue.Element;value;manual",
          ";IteratorUtils;true;singletonListIterator;;;Argument[0];ReturnValue.Element;value;manual",
          ";IteratorUtils;true;skippingIterator;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;toArray;;;Argument[0].Element;ReturnValue.ArrayElement;value;manual",
          ";IteratorUtils;true;toList;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;toListIterator;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;toString;;;Argument[2];ReturnValue;taint;manual",
          ";IteratorUtils;true;toString;;;Argument[3];ReturnValue;taint;manual",
          ";IteratorUtils;true;toString;;;Argument[4];ReturnValue;taint;manual",
          ";IteratorUtils;true;unmodifiableIterator;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;unmodifiableListIterator;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;unmodifiableMapIterator;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;unmodifiableMapIterator;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ";IteratorUtils;true;zippingIterator;(Iterator[]);;Argument[0].ArrayElement.Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;zippingIterator;(Iterator,Iterator);;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;zippingIterator;(Iterator,Iterator);;Argument[1].Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;zippingIterator;(Iterator,Iterator,Iterator);;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;zippingIterator;(Iterator,Iterator,Iterator);;Argument[1].Element;ReturnValue.Element;value;manual",
          ";IteratorUtils;true;zippingIterator;(Iterator,Iterator,Iterator);;Argument[2].Element;ReturnValue.Element;value;manual"
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
          ";IterableUtils;true;boundedIterable;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IterableUtils;true;chainedIterable;(Iterable[]);;Argument[0].ArrayElement.Element;ReturnValue.Element;value;manual",
          ";IterableUtils;true;chainedIterable;(Iterable,Iterable);;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IterableUtils;true;chainedIterable;(Iterable,Iterable);;Argument[1].Element;ReturnValue.Element;value;manual",
          ";IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable);;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable);;Argument[1].Element;ReturnValue.Element;value;manual",
          ";IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable);;Argument[2].Element;ReturnValue.Element;value;manual",
          ";IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable,Iterable);;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable,Iterable);;Argument[1].Element;ReturnValue.Element;value;manual",
          ";IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable,Iterable);;Argument[2].Element;ReturnValue.Element;value;manual",
          ";IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable,Iterable);;Argument[3].Element;ReturnValue.Element;value;manual",
          ";IterableUtils;true;collatedIterable;(Comparator,Iterable,Iterable);;Argument[1].Element;ReturnValue.Element;value;manual",
          ";IterableUtils;true;collatedIterable;(Comparator,Iterable,Iterable);;Argument[2].Element;ReturnValue.Element;value;manual",
          ";IterableUtils;true;collatedIterable;(Iterable,Iterable);;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IterableUtils;true;collatedIterable;(Iterable,Iterable);;Argument[1].Element;ReturnValue.Element;value;manual",
          ";IterableUtils;true;emptyIfNull;;;Argument[0];ReturnValue;value;manual",
          ";IterableUtils;true;filteredIterable;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IterableUtils;true;find;;;Argument[0].Element;ReturnValue;value;manual",
          ";IterableUtils;true;first;;;Argument[0].Element;ReturnValue;value;manual",
          ";IterableUtils;true;forEachButLast;;;Argument[0].Element;ReturnValue;value;manual",
          ";IterableUtils;true;get;;;Argument[0].Element;ReturnValue;value;manual",
          ";IterableUtils;true;loopingIterable;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IterableUtils;true;partition;;;Argument[0].Element;ReturnValue.Element.Element;value;manual",
          ";IterableUtils;true;reversedIterable;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IterableUtils;true;skippingIterable;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IterableUtils;true;toList;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IterableUtils;true;toString;;;Argument[2];ReturnValue;taint;manual",
          ";IterableUtils;true;toString;;;Argument[3];ReturnValue;taint;manual",
          ";IterableUtils;true;toString;;;Argument[4];ReturnValue;taint;manual",
          ";IterableUtils;true;uniqueIterable;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IterableUtils;true;unmodifiableIterable;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IterableUtils;true;zippingIterable;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";IterableUtils;true;zippingIterable;(Iterable,Iterable[]);;Argument[1].ArrayElement.Element;ReturnValue.Element;value;manual",
          ";IterableUtils;true;zippingIterable;(Iterable,Iterable);;Argument[1].Element;ReturnValue.Element;value;manual"
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
          ";EnumerationUtils;true;get;;;Argument[0].Element;ReturnValue;value;manual",
          ";EnumerationUtils;true;toList;(Enumeration);;Argument[0].Element;ReturnValue.Element;value;manual",
          ";EnumerationUtils;true;toList;(StringTokenizer);;Argument[0];ReturnValue.Element;taint;manual"
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
          ";MultiMapUtils;true;emptyIfNull;;;Argument[0];ReturnValue;value;manual",
          ";MultiMapUtils;true;getCollection;;;Argument[0].MapValue;ReturnValue;value;manual",
          ";MultiMapUtils;true;getValuesAsBag;;;Argument[0].MapValue.Element;ReturnValue.Element;value;manual",
          ";MultiMapUtils;true;getValuesAsList;;;Argument[0].MapValue.Element;ReturnValue.Element;value;manual",
          ";MultiMapUtils;true;getValuesAsSet;;;Argument[0].MapValue.Element;ReturnValue.Element;value;manual",
          ";MultiMapUtils;true;transformedMultiValuedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ";MultiMapUtils;true;transformedMultiValuedMap;;;Argument[0].MapValue.Element;ReturnValue.MapValue.Element;value;manual",
          ";MultiMapUtils;true;unmodifiableMultiValuedMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ";MultiMapUtils;true;unmodifiableMultiValuedMap;;;Argument[0].MapValue.Element;ReturnValue.MapValue.Element;value;manual"
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
          ";MultiSetUtils;true;predicatedMultiSet;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";MultiSetUtils;true;synchronizedMultiSet;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";MultiSetUtils;true;unmodifiableMultiSet;;;Argument[0].Element;ReturnValue.Element;value;manual"
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
          ";QueueUtils;true;predicatedQueue;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";QueueUtils;true;synchronizedQueue;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";QueueUtils;true;transformingQueue;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";QueueUtils;true;unmodifiableQueue;;;Argument[0].Element;ReturnValue.Element;value;manual"
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
          ";SetUtils$SetView;true;copyInto;;;Argument[-1].Element;Argument[0].Element;value;manual",
          ";SetUtils$SetView;true;createIterator;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ";SetUtils$SetView;true;toSet;;;Argument[-1].Element;ReturnValue.Element;value;manual",
          ";SetUtils;true;difference;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";SetUtils;true;disjunction;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";SetUtils;true;disjunction;;;Argument[1].Element;ReturnValue.Element;value;manual",
          ";SetUtils;true;emptyIfNull;;;Argument[0];ReturnValue;value;manual",
          ";SetUtils;true;hashSet;;;Argument[0].ArrayElement;ReturnValue.Element;value;manual",
          ";SetUtils;true;intersection;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";SetUtils;true;intersection;;;Argument[1].Element;ReturnValue.Element;value;manual",
          ";SetUtils;true;orderedSet;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";SetUtils;true;predicatedNavigableSet;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";SetUtils;true;predicatedSet;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";SetUtils;true;predicatedSortedSet;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";SetUtils;true;synchronizedSet;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";SetUtils;true;synchronizedSortedSet;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";SetUtils;true;transformedNavigableSet;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";SetUtils;true;transformedSet;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";SetUtils;true;transformedSortedSet;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";SetUtils;true;union;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";SetUtils;true;union;;;Argument[1].Element;ReturnValue.Element;value;manual",
          ";SetUtils;true;unmodifiableNavigableSet;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";SetUtils;true;unmodifiableSet;(Object[]);;Argument[0].ArrayElement;ReturnValue.Element;value;manual",
          ";SetUtils;true;unmodifiableSet;(Set);;Argument[0].Element;ReturnValue.Element;value;manual",
          ";SetUtils;true;unmodifiableSortedSet;;;Argument[0].Element;ReturnValue.Element;value;manual"
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
          ";SplitMapUtils;true;readableMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ";SplitMapUtils;true;readableMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual",
          ";SplitMapUtils;true;writableMap;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ";SplitMapUtils;true;writableMap;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual"
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
          ";TrieUtils;true;unmodifiableTrie;;;Argument[0].MapKey;ReturnValue.MapKey;value;manual",
          ";TrieUtils;true;unmodifiableTrie;;;Argument[0].MapValue;ReturnValue.MapValue;value;manual"
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
          ";BagUtils;true;collectionBag;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";BagUtils;true;predicatedBag;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";BagUtils;true;predicatedSortedBag;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";BagUtils;true;synchronizedBag;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";BagUtils;true;synchronizedSortedBag;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";BagUtils;true;transformingBag;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";BagUtils;true;transformingSortedBag;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";BagUtils;true;unmodifiableBag;;;Argument[0].Element;ReturnValue.Element;value;manual",
          ";BagUtils;true;unmodifiableSortedBag;;;Argument[0].Element;ReturnValue.Element;value;manual"
        ]
  }
}
