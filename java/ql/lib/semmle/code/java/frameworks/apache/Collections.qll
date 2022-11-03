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
          ";ArrayStack;true;peek;;;Element of Argument[-1];ReturnValue;value",
          ";ArrayStack;true;pop;;;Element of Argument[-1];ReturnValue;value",
          ";ArrayStack;true;push;;;Argument[0];Element of Argument[-1];value",
          ";ArrayStack;true;push;;;Argument[0];ReturnValue;value",
          ";Bag;true;add;;;Argument[0];Element of Argument[-1];value",
          ";Bag;true;uniqueSet;;;Element of Argument[-1];Element of ReturnValue;value",
          ";BidiMap;true;getKey;;;MapKey of Argument[-1];ReturnValue;value",
          ";BidiMap;true;removeValue;;;MapKey of Argument[-1];ReturnValue;value",
          ";BidiMap;true;inverseBidiMap;;;MapKey of Argument[-1];MapValue of ReturnValue;value",
          ";BidiMap;true;inverseBidiMap;;;MapValue of Argument[-1];MapKey of ReturnValue;value",
          ";FluentIterable;true;append;(Object[]);;Element of Argument[-1];Element of ReturnValue;value",
          ";FluentIterable;true;append;(Object[]);;ArrayElement of Argument[0];Element of ReturnValue;value",
          ";FluentIterable;true;append;(Iterable);;Element of Argument[-1];Element of ReturnValue;value",
          ";FluentIterable;true;append;(Iterable);;Element of Argument[0];Element of ReturnValue;value",
          ";FluentIterable;true;asEnumeration;;;Element of Argument[-1];Element of ReturnValue;value",
          ";FluentIterable;true;collate;;;Element of Argument[-1];Element of ReturnValue;value",
          ";FluentIterable;true;collate;;;Element of Argument[0];Element of ReturnValue;value",
          ";FluentIterable;true;copyInto;;;Element of Argument[-1];Element of Argument[0];value",
          ";FluentIterable;true;eval;;;Element of Argument[-1];Element of ReturnValue;value",
          ";FluentIterable;true;filter;;;Element of Argument[-1];Element of ReturnValue;value",
          ";FluentIterable;true;get;;;Element of Argument[-1];ReturnValue;value",
          ";FluentIterable;true;limit;;;Element of Argument[-1];Element of ReturnValue;value",
          ";FluentIterable;true;loop;;;Element of Argument[-1];Element of ReturnValue;value",
          ";FluentIterable;true;of;(Iterable);;Element of Argument[0];Element of ReturnValue;value",
          ";FluentIterable;true;of;(Object[]);;ArrayElement of Argument[0];Element of ReturnValue;value",
          ";FluentIterable;true;of;(Object);;Argument[0];Element of ReturnValue;value",
          ";FluentIterable;true;reverse;;;Element of Argument[-1];Element of ReturnValue;value",
          ";FluentIterable;true;skip;;;Element of Argument[-1];Element of ReturnValue;value",
          ";FluentIterable;true;toArray;;;Element of Argument[-1];ArrayElement of ReturnValue;value",
          ";FluentIterable;true;toList;;;Element of Argument[-1];Element of ReturnValue;value",
          ";FluentIterable;true;unique;;;Element of Argument[-1];Element of ReturnValue;value",
          ";FluentIterable;true;unmodifiable;;;Element of Argument[-1];Element of ReturnValue;value",
          ";FluentIterable;true;zip;(Iterable);;Element of Argument[-1];Element of ReturnValue;value",
          ";FluentIterable;true;zip;(Iterable);;Element of Argument[0];Element of ReturnValue;value",
          ";FluentIterable;true;zip;(Iterable[]);;Element of Argument[-1];Element of ReturnValue;value",
          ";FluentIterable;true;zip;(Iterable[]);;Element of ArrayElement of Argument[0];Element of ReturnValue;value",
          ";Get;true;entrySet;;;MapKey of Argument[-1];MapKey of Element of ReturnValue;value",
          ";Get;true;entrySet;;;MapValue of Argument[-1];MapValue of Element of ReturnValue;value",
          ";Get;true;get;;;MapValue of Argument[-1];ReturnValue;value",
          ";Get;true;keySet;();;MapKey of Argument[-1];Element of ReturnValue;value",
          ";Get;true;values;();;MapValue of Argument[-1];Element of ReturnValue;value",
          ";Get;true;remove;(Object);;MapValue of Argument[-1];ReturnValue;value",
          ";IterableGet;true;mapIterator;;;MapKey of Argument[-1];Element of ReturnValue;value",
          ";IterableGet;true;mapIterator;;;MapValue of Argument[-1];MapValue of ReturnValue;value",
          ";KeyValue;true;getKey;;;MapKey of Argument[-1];ReturnValue;value",
          ";KeyValue;true;getValue;;;MapValue of Argument[-1];ReturnValue;value",
          // Note that MapIterator<K, V> implements Iterator<K>, so it iterates over the keys of the map.
          // In order for the models of Iterator to work we have to use Element instead of MapKey for key data.
          ";MapIterator;true;getKey;;;Element of Argument[-1];ReturnValue;value",
          ";MapIterator;true;getValue;;;MapValue of Argument[-1];ReturnValue;value",
          ";MapIterator;true;setValue;;;MapValue of Argument[-1];ReturnValue;value",
          ";MapIterator;true;setValue;;;Argument[0];MapValue of Argument[-1];value",
          ";MultiMap;true;get;;;Element of MapValue of Argument[-1];Element of ReturnValue;value",
          ";MultiMap;true;put;;;Argument[0];MapKey of Argument[-1];value",
          ";MultiMap;true;put;;;Argument[1];Element of MapValue of Argument[-1];value",
          ";MultiMap;true;values;;;Element of MapValue of Argument[-1];Element of ReturnValue;value",
          ";MultiSet$Entry;true;getElement;;;Element of Argument[-1];ReturnValue;value",
          ";MultiSet;true;add;;;Argument[0];Element of Argument[-1];value",
          ";MultiSet;true;uniqueSet;;;Element of Argument[-1];Element of ReturnValue;value",
          ";MultiSet;true;entrySet;;;Element of Argument[-1];Element of Element of ReturnValue;value",
          ";MultiValuedMap;true;asMap;;;MapKey of Argument[-1];MapKey of ReturnValue;value",
          ";MultiValuedMap;true;asMap;;;Element of MapValue of Argument[-1];Element of MapValue of ReturnValue;value",
          ";MultiValuedMap;true;entries;;;MapKey of Argument[-1];MapKey of Element of ReturnValue;value",
          ";MultiValuedMap;true;entries;;;Element of MapValue of Argument[-1];MapValue of Element of ReturnValue;value",
          ";MultiValuedMap;true;get;;;Element of MapValue of Argument[-1];Element of ReturnValue;value",
          ";MultiValuedMap;true;keys;;;MapKey of Argument[-1];Element of ReturnValue;value",
          ";MultiValuedMap;true;keySet;;;MapKey of Argument[-1];Element of ReturnValue;value",
          ";MultiValuedMap;true;mapIterator;;;MapKey of Argument[-1];Element of ReturnValue;value",
          ";MultiValuedMap;true;mapIterator;;;Element of MapValue of Argument[-1];MapValue of ReturnValue;value",
          ";MultiValuedMap;true;put;;;Argument[0];MapKey of Argument[-1];value",
          ";MultiValuedMap;true;put;;;Argument[1];Element of MapValue of Argument[-1];value",
          ";MultiValuedMap;true;putAll;(Object,Iterable);;Argument[0];MapKey of Argument[-1];value",
          ";MultiValuedMap;true;putAll;(Object,Iterable);;Element of Argument[1];Element of MapValue of Argument[-1];value",
          ";MultiValuedMap;true;putAll;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ";MultiValuedMap;true;putAll;(Map);;MapValue of Argument[0];Element of MapValue of Argument[-1];value",
          ";MultiValuedMap;true;putAll;(MultiValuedMap);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ";MultiValuedMap;true;putAll;(MultiValuedMap);;Element of MapValue of Argument[0];Element of MapValue of Argument[-1];value",
          ";MultiValuedMap;true;remove;;;Element of MapValue of Argument[-1];Element of ReturnValue;value",
          ";MultiValuedMap;true;values;;;Element of MapValue of Argument[-1];Element of ReturnValue;value",
          ";OrderedIterator;true;previous;;;Element of Argument[-1];ReturnValue;value",
          ";OrderedMap;true;firstKey;;;MapKey of Argument[-1];ReturnValue;value",
          ";OrderedMap;true;lastKey;;;MapKey of Argument[-1];ReturnValue;value",
          ";OrderedMap;true;nextKey;;;MapKey of Argument[-1];ReturnValue;value",
          ";OrderedMap;true;previousKey;;;MapKey of Argument[-1];ReturnValue;value",
          ";Put;true;put;;;MapValue of Argument[-1];ReturnValue;value",
          ";Put;true;put;;;Argument[0];MapKey of Argument[-1];value",
          ";Put;true;put;;;Argument[1];MapValue of Argument[-1];value",
          ";Put;true;putAll;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ";Put;true;putAll;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value",
          ";SortedBag;true;first;;;Element of Argument[-1];ReturnValue;value",
          ";SortedBag;true;last;;;Element of Argument[-1];ReturnValue;value",
          ";Trie;true;prefixMap;;;MapKey of Argument[-1];MapKey of ReturnValue;value",
          ";Trie;true;prefixMap;;;MapValue of Argument[-1];MapValue of ReturnValue;value"
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
          ".keyvalue;AbstractKeyValue;true;AbstractKeyValue;;;Argument[0];MapKey of Argument[-1];value",
          ".keyvalue;AbstractKeyValue;true;AbstractKeyValue;;;Argument[1];MapValue of Argument[-1];value",
          ".keyvalue;AbstractKeyValue;true;setKey;;;MapKey of Argument[-1];ReturnValue;value",
          ".keyvalue;AbstractKeyValue;true;setKey;;;Argument[0];MapKey of Argument[-1];value",
          ".keyvalue;AbstractKeyValue;true;setValue;;;MapValue of Argument[-1];ReturnValue;value",
          ".keyvalue;AbstractKeyValue;true;setValue;;;Argument[0];MapValue of Argument[-1];value",
          ".keyvalue;AbstractMapEntry;true;AbstractMapEntry;;;Argument[0];MapKey of Argument[-1];value",
          ".keyvalue;AbstractMapEntry;true;AbstractMapEntry;;;Argument[1];MapValue of Argument[-1];value",
          ".keyvalue;AbstractMapEntryDecorator;true;AbstractMapEntryDecorator;;;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".keyvalue;AbstractMapEntryDecorator;true;AbstractMapEntryDecorator;;;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".keyvalue;AbstractMapEntryDecorator;true;getMapEntry;;;MapKey of Argument[-1];MapKey of ReturnValue;value",
          ".keyvalue;AbstractMapEntryDecorator;true;getMapEntry;;;MapValue of Argument[-1];MapValue of ReturnValue;value",
          ".keyvalue;DefaultKeyValue;true;DefaultKeyValue;(Object,Object);;Argument[0];MapKey of Argument[-1];value",
          ".keyvalue;DefaultKeyValue;true;DefaultKeyValue;(Object,Object);;Argument[1];MapValue of Argument[-1];value",
          ".keyvalue;DefaultKeyValue;true;DefaultKeyValue;(KeyValue);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".keyvalue;DefaultKeyValue;true;DefaultKeyValue;(KeyValue);;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".keyvalue;DefaultKeyValue;true;DefaultKeyValue;(Entry);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".keyvalue;DefaultKeyValue;true;DefaultKeyValue;(Entry);;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".keyvalue;DefaultKeyValue;true;toMapEntry;;;MapKey of Argument[-1];MapKey of ReturnValue;value",
          ".keyvalue;DefaultKeyValue;true;toMapEntry;;;MapValue of Argument[-1];MapValue of ReturnValue;value",
          ".keyvalue;DefaultMapEntry;true;DefaultMapEntry;(Object,Object);;Argument[0];MapKey of Argument[-1];value",
          ".keyvalue;DefaultMapEntry;true;DefaultMapEntry;(Object,Object);;Argument[1];MapValue of Argument[-1];value",
          ".keyvalue;DefaultMapEntry;true;DefaultMapEntry;(KeyValue);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".keyvalue;DefaultMapEntry;true;DefaultMapEntry;(KeyValue);;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".keyvalue;DefaultMapEntry;true;DefaultMapEntry;(Entry);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".keyvalue;DefaultMapEntry;true;DefaultMapEntry;(Entry);;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".keyvalue;MultiKey;true;MultiKey;(Object[]);;ArrayElement of Argument[0];Element of Argument[-1];value",
          ".keyvalue;MultiKey;true;MultiKey;(Object[],boolean);;ArrayElement of Argument[0];Element of Argument[-1];value",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object);;Argument[0];Element of Argument[-1];value",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object);;Argument[1];Element of Argument[-1];value",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object);;Argument[0];Element of Argument[-1];value",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object);;Argument[1];Element of Argument[-1];value",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object);;Argument[2];Element of Argument[-1];value",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object);;Argument[0];Element of Argument[-1];value",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object);;Argument[1];Element of Argument[-1];value",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object);;Argument[2];Element of Argument[-1];value",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object);;Argument[3];Element of Argument[-1];value",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object,Object);;Argument[0];Element of Argument[-1];value",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object,Object);;Argument[1];Element of Argument[-1];value",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object,Object);;Argument[2];Element of Argument[-1];value",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object,Object);;Argument[3];Element of Argument[-1];value",
          ".keyvalue;MultiKey;true;MultiKey;(Object,Object,Object,Object,Object);;Argument[4];Element of Argument[-1];value",
          ".keyvalue;MultiKey;true;getKeys;;;Element of Argument[-1];ArrayElement of ReturnValue;value",
          ".keyvalue;MultiKey;true;getKey;;;Element of Argument[-1];ReturnValue;value",
          ".keyvalue;TiedMapEntry;true;TiedMapEntry;;;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".keyvalue;TiedMapEntry;true;TiedMapEntry;;;Argument[1];MapKey of Argument[-1];value",
          ".keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(Object,Object);;Argument[0];MapKey of Argument[-1];value",
          ".keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(Object,Object);;Argument[1];MapValue of Argument[-1];value",
          ".keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(KeyValue);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(KeyValue);;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(Entry);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(Entry);;MapValue of Argument[0];MapValue of Argument[-1];value"
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
          ".bag;AbstractBagDecorator;true;AbstractBagDecorator;;;Element of Argument[0];Element of Argument[-1];value",
          ".bag;AbstractMapBag;true;AbstractMapBag;;;MapKey of Argument[0];Element of Argument[-1];value",
          ".bag;AbstractMapBag;true;getMap;;;Element of Argument[-1];MapKey of ReturnValue;value",
          ".bag;AbstractSortedBagDecorator;true;AbstractSortedBagDecorator;;;Element of Argument[0];Element of Argument[-1];value",
          ".bag;CollectionBag;true;CollectionBag;;;Element of Argument[0];Element of Argument[-1];value",
          ".bag;CollectionBag;true;collectionBag;;;Element of Argument[0];Element of ReturnValue;value",
          ".bag;CollectionSortedBag;true;CollectionSortedBag;;;Element of Argument[0];Element of Argument[-1];value",
          ".bag;CollectionSortedBag;true;collectionSortedBag;;;Element of Argument[0];Element of ReturnValue;value",
          ".bag;HashBag;true;HashBag;;;Element of Argument[0];Element of Argument[-1];value",
          ".bag;PredicatedBag;true;predicatedBag;;;Element of Argument[0];Element of ReturnValue;value",
          ".bag;PredicatedSortedBag;true;predicatedSortedBag;;;Element of Argument[0];Element of ReturnValue;value",
          ".bag;SynchronizedBag;true;synchronizedBag;;;Element of Argument[0];Element of ReturnValue;value",
          ".bag;SynchronizedSortedBag;true;synchronizedSortedBag;;;Element of Argument[0];Element of ReturnValue;value",
          ".bag;TransformedBag;true;transformedBag;;;Element of Argument[0];Element of ReturnValue;value",
          ".bag;TransformedSortedBag;true;transformedSortedBag;;;Element of Argument[0];Element of ReturnValue;value",
          ".bag;TreeBag;true;TreeBag;(Collection);;Element of Argument[0];Element of Argument[-1];value",
          ".bag;UnmodifiableBag;true;unmodifiableBag;;;Element of Argument[0];Element of ReturnValue;value",
          ".bag;UnmodifiableSortedBag;true;unmodifiableSortedBag;;;Element of Argument[0];Element of ReturnValue;value"
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
          ".bidimap;AbstractBidiMapDecorator;true;AbstractBidiMapDecorator;;;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".bidimap;AbstractBidiMapDecorator;true;AbstractBidiMapDecorator;;;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".bidimap;AbstractDualBidiMap;true;AbstractDualBidiMap;;;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".bidimap;AbstractDualBidiMap;true;AbstractDualBidiMap;;;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".bidimap;AbstractDualBidiMap;true;AbstractDualBidiMap;;;MapKey of Argument[1];MapValue of Argument[-1];value",
          ".bidimap;AbstractDualBidiMap;true;AbstractDualBidiMap;;;MapValue of Argument[1];MapKey of Argument[-1];value",
          ".bidimap;AbstractDualBidiMap;true;AbstractDualBidiMap;;;MapKey of Argument[2];MapValue of Argument[-1];value",
          ".bidimap;AbstractDualBidiMap;true;AbstractDualBidiMap;;;MapValue of Argument[2];MapKey of Argument[-1];value",
          ".bidimap;AbstractOrderedBidiMapDecorator;true;AbstractOrderedBidiMapDecorator;;;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".bidimap;AbstractOrderedBidiMapDecorator;true;AbstractOrderedBidiMapDecorator;;;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".bidimap;AbstractSortedBidiMapDecorator;true;AbstractSortedBidiMapDecorator;;;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".bidimap;AbstractSortedBidiMapDecorator;true;AbstractSortedBidiMapDecorator;;;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".bidimap;DualHashBidiMap;true;DualHashBidiMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".bidimap;DualHashBidiMap;true;DualHashBidiMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".bidimap;DualLinkedHashBidiMap;true;DualLinkedHashBidiMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".bidimap;DualLinkedHashBidiMap;true;DualLinkedHashBidiMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".bidimap;DualTreeBidiMap;true;DualTreeBidiMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".bidimap;DualTreeBidiMap;true;DualTreeBidiMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".bidimap;DualTreeBidiMap;true;inverseOrderedBidiMap;;;MapKey of Argument[-1];MapValue of ReturnValue;value",
          ".bidimap;DualTreeBidiMap;true;inverseOrderedBidiMap;;;MapValue of Argument[-1];MapKey of ReturnValue;value",
          ".bidimap;DualTreeBidiMap;true;inverseSortedBidiMap;;;MapKey of Argument[-1];MapValue of ReturnValue;value",
          ".bidimap;DualTreeBidiMap;true;inverseSortedBidiMap;;;MapValue of Argument[-1];MapKey of ReturnValue;value",
          ".bidimap;TreeBidiMap;true;TreeBidiMap;;;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".bidimap;TreeBidiMap;true;TreeBidiMap;;;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".bidimap;UnmodifiableBidiMap;true;unmodifiableBidiMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ".bidimap;UnmodifiableBidiMap;true;unmodifiableBidiMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ".bidimap;UnmodifiableOrderedBidiMap;true;unmodifiableOrderedBidiMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ".bidimap;UnmodifiableOrderedBidiMap;true;unmodifiableOrderedBidiMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ".bidimap;UnmodifiableOrderedBidiMap;true;inverseOrderedBidiMap;;;MapKey of Argument[-1];MapValue of ReturnValue;value",
          ".bidimap;UnmodifiableOrderedBidiMap;true;inverseOrderedBidiMap;;;MapValue of Argument[-1];MapKey of ReturnValue;value",
          ".bidimap;UnmodifiableSortedBidiMap;true;unmodifiableSortedBidiMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ".bidimap;UnmodifiableSortedBidiMap;true;unmodifiableSortedBidiMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
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
          ".collection;AbstractCollectionDecorator;true;AbstractCollectionDecorator;;;Element of Argument[0];Element of Argument[-1];value",
          ".collection;AbstractCollectionDecorator;true;decorated;;;Element of Argument[-1];Element of ReturnValue;value",
          ".collection;AbstractCollectionDecorator;true;setCollection;;;Element of Argument[0];Element of Argument[-1];value",
          ".collection;CompositeCollection$CollectionMutator;true;add;;;Argument[2];Element of Argument[0];value",
          ".collection;CompositeCollection$CollectionMutator;true;add;;;Argument[2];Element of Element of Argument[1];value",
          ".collection;CompositeCollection$CollectionMutator;true;addAll;;;Element of Argument[2];Element of Argument[0];value",
          ".collection;CompositeCollection$CollectionMutator;true;addAll;;;Element of Argument[2];Element of Element of Argument[1];value",
          ".collection;CompositeCollection;true;CompositeCollection;(Collection);;Element of Argument[0];Element of Argument[-1];value",
          ".collection;CompositeCollection;true;CompositeCollection;(Collection,Collection);;Element of Argument[0];Element of Argument[-1];value",
          ".collection;CompositeCollection;true;CompositeCollection;(Collection,Collection);;Element of Argument[1];Element of Argument[-1];value",
          ".collection;CompositeCollection;true;CompositeCollection;(Collection[]);;Element of ArrayElement of Argument[0];Element of Argument[-1];value",
          ".collection;CompositeCollection;true;addComposited;(Collection);;Element of Argument[0];Element of Argument[-1];value",
          ".collection;CompositeCollection;true;addComposited;(Collection,Collection);;Element of Argument[0];Element of Argument[-1];value",
          ".collection;CompositeCollection;true;addComposited;(Collection,Collection);;Element of Argument[1];Element of Argument[-1];value",
          ".collection;CompositeCollection;true;addComposited;(Collection[]);;Element of ArrayElement of Argument[0];Element of Argument[-1];value",
          ".collection;CompositeCollection;true;toCollection;;;Element of Argument[-1];Element of ReturnValue;value",
          ".collection;CompositeCollection;true;getCollections;;;Element of Argument[-1];Element of Element of ReturnValue;value",
          ".collection;IndexedCollection;true;IndexedCollection;;;Element of Argument[0];Element of Argument[-1];value",
          ".collection;IndexedCollection;true;uniqueIndexedCollection;;;Element of Argument[0];Element of ReturnValue;value",
          ".collection;IndexedCollection;true;nonUniqueIndexedCollection;;;Element of Argument[0];Element of ReturnValue;value",
          ".collection;IndexedCollection;true;get;;;Element of Argument[-1];ReturnValue;value",
          ".collection;IndexedCollection;true;values;;;Element of Argument[-1];Element of ReturnValue;value",
          ".collection;PredicatedCollection$Builder;true;add;;;Argument[0];Element of Argument[-1];value",
          ".collection;PredicatedCollection$Builder;true;addAll;;;Element of Argument[0];Element of Argument[-1];value",
          ".collection;PredicatedCollection$Builder;true;createPredicatedList;;;Element of Argument[-1];Element of ReturnValue;value",
          ".collection;PredicatedCollection$Builder;true;createPredicatedList;;;Element of Argument[0];Element of ReturnValue;value",
          ".collection;PredicatedCollection$Builder;true;createPredicatedSet;;;Element of Argument[-1];Element of ReturnValue;value",
          ".collection;PredicatedCollection$Builder;true;createPredicatedSet;;;Element of Argument[0];Element of ReturnValue;value",
          ".collection;PredicatedCollection$Builder;true;createPredicatedMultiSet;;;Element of Argument[-1];Element of ReturnValue;value",
          ".collection;PredicatedCollection$Builder;true;createPredicatedMultiSet;;;Element of Argument[0];Element of ReturnValue;value",
          ".collection;PredicatedCollection$Builder;true;createPredicatedBag;;;Element of Argument[-1];Element of ReturnValue;value",
          ".collection;PredicatedCollection$Builder;true;createPredicatedBag;;;Element of Argument[0];Element of ReturnValue;value",
          ".collection;PredicatedCollection$Builder;true;createPredicatedQueue;;;Element of Argument[-1];Element of ReturnValue;value",
          ".collection;PredicatedCollection$Builder;true;createPredicatedQueue;;;Element of Argument[0];Element of ReturnValue;value",
          ".collection;PredicatedCollection$Builder;true;rejectedElements;;;Element of Argument[-1];Element of ReturnValue;value",
          ".collection;PredicatedCollection;true;predicatedCollection;;;Element of Argument[0];Element of ReturnValue;value",
          ".collection;SynchronizedCollection;true;synchronizedCollection;;;Element of Argument[0];Element of ReturnValue;value",
          ".collection;TransformedCollection;true;transformingCollection;;;Element of Argument[0];Element of ReturnValue;value",
          ".collection;UnmodifiableBoundedCollection;true;unmodifiableBoundedCollection;;;Element of Argument[0];Element of ReturnValue;value",
          ".collection;UnmodifiableCollection;true;unmodifiableCollection;;;Element of Argument[0];Element of ReturnValue;value"
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
          ".iterators;AbstractIteratorDecorator;true;AbstractIteratorDecorator;;;Element of Argument[0];Element of Argument[-1];value",
          ".iterators;AbstractListIteratorDecorator;true;AbstractListIteratorDecorator;;;Element of Argument[0];Element of Argument[-1];value",
          ".iterators;AbstractListIteratorDecorator;true;getListIterator;;;Element of Argument[-1];Element of ReturnValue;value",
          ".iterators;AbstractMapIteratorDecorator;true;AbstractMapIteratorDecorator;;;Element of Argument[0];Element of Argument[-1];value",
          ".iterators;AbstractMapIteratorDecorator;true;AbstractMapIteratorDecorator;;;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".iterators;AbstractMapIteratorDecorator;true;getMapIterator;;;Element of Argument[-1];Element of ReturnValue;value",
          ".iterators;AbstractMapIteratorDecorator;true;getMapIterator;;;MapValue of Argument[-1];MapValue of ReturnValue;value",
          ".iterators;AbstractOrderedMapIteratorDecorator;true;AbstractOrderedMapIteratorDecorator;;;Element of Argument[0];Element of Argument[-1];value",
          ".iterators;AbstractOrderedMapIteratorDecorator;true;AbstractOrderedMapIteratorDecorator;;;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".iterators;AbstractOrderedMapIteratorDecorator;true;getOrderedMapIterator;;;Element of Argument[-1];Element of ReturnValue;value",
          ".iterators;AbstractOrderedMapIteratorDecorator;true;getOrderedMapIterator;;;MapValue of Argument[-1];MapValue of ReturnValue;value",
          ".iterators;AbstractUntypedIteratorDecorator;true;AbstractUntypedIteratorDecorator;;;Element of Argument[0];Element of Argument[-1];value",
          ".iterators;AbstractUntypedIteratorDecorator;true;getIterator;;;Element of Argument[-1];Element of ReturnValue;value",
          ".iterators;ArrayIterator;true;ArrayIterator;;;ArrayElement of Argument[0];Element of Argument[-1];value",
          ".iterators;ArrayIterator;true;getArray;;;Element of Argument[-1];ArrayElement of ReturnValue;value",
          ".iterators;ArrayListIterator;true;ArrayListIterator;;;ArrayElement of Argument[0];Element of Argument[-1];value",
          ".iterators;BoundedIterator;true;BoundedIterator;;;Element of Argument[0];Element of Argument[-1];value",
          ".iterators;CollatingIterator;true;CollatingIterator;(Comparator,Iterator,Iterator);;Element of Argument[1];Element of Argument[-1];value",
          ".iterators;CollatingIterator;true;CollatingIterator;(Comparator,Iterator,Iterator);;Element of Argument[2];Element of Argument[-1];value",
          ".iterators;CollatingIterator;true;CollatingIterator;(Comparator,Iterator[]);;Element of ArrayElement of Argument[1];Element of Argument[-1];value",
          ".iterators;CollatingIterator;true;CollatingIterator;(Comparator,Collection);;Element of Element of Argument[1];Element of Argument[-1];value",
          ".iterators;CollatingIterator;true;addIterator;;;Element of Argument[0];Element of Argument[-1];value",
          ".iterators;CollatingIterator;true;setIterator;;;Element of Argument[1];Element of Argument[-1];value",
          ".iterators;CollatingIterator;true;getIterators;;;Element of Argument[-1];Element of Element of ReturnValue;value",
          ".iterators;EnumerationIterator;true;EnumerationIterator;;;Element of Argument[0];Element of Argument[-1];value",
          ".iterators;EnumerationIterator;true;getEnumeration;;;Element of Argument[-1];Element of ReturnValue;value",
          ".iterators;EnumerationIterator;true;setEnumeration;;;Element of Argument[0];Element of Argument[-1];value",
          ".iterators;FilterIterator;true;FilterIterator;;;Element of Argument[0];Element of Argument[-1];value",
          ".iterators;FilterIterator;true;getIterator;;;Element of Argument[-1];Element of ReturnValue;value",
          ".iterators;FilterIterator;true;setIterator;;;Element of Argument[0];Element of Argument[-1];value",
          ".iterators;FilterListIterator;true;FilterListIterator;(ListIterator);;Element of Argument[0];Element of Argument[-1];value",
          ".iterators;FilterListIterator;true;FilterListIterator;(ListIterator,Predicate);;Element of Argument[0];Element of Argument[-1];value",
          ".iterators;FilterListIterator;true;getListIterator;;;Element of Argument[-1];Element of ReturnValue;value",
          ".iterators;FilterListIterator;true;setListIterator;;;Element of Argument[0];Element of Argument[-1];value",
          ".iterators;IteratorChain;true;IteratorChain;(Iterator);;Element of Argument[0];Element of Argument[-1];value",
          ".iterators;IteratorChain;true;IteratorChain;(Iterator,Iterator);;Element of Argument[0];Element of Argument[-1];value",
          ".iterators;IteratorChain;true;IteratorChain;(Iterator,Iterator);;Element of Argument[1];Element of Argument[-1];value",
          ".iterators;IteratorChain;true;IteratorChain;(Iterator[]);;Element of ArrayElement of Argument[0];Element of Argument[-1];value",
          ".iterators;IteratorChain;true;IteratorChain;(Collection);;Element of Element of Argument[0];Element of Argument[-1];value",
          ".iterators;IteratorChain;true;addIterator;;;Element of Argument[0];Element of Argument[-1];value",
          ".iterators;IteratorEnumeration;true;IteratorEnumeration;;;Element of Argument[0];Element of Argument[-1];value",
          ".iterators;IteratorEnumeration;true;getIterator;;;Element of Argument[-1];Element of ReturnValue;value",
          ".iterators;IteratorEnumeration;true;setIterator;;;Element of Argument[0];Element of Argument[-1];value",
          ".iterators;IteratorIterable;true;IteratorIterable;;;Element of Argument[0];Element of Argument[-1];value",
          ".iterators;ListIteratorWrapper;true;ListIteratorWrapper;;;Element of Argument[0];Element of Argument[-1];value",
          ".iterators;LoopingIterator;true;LoopingIterator;;;Element of Argument[0];Element of Argument[-1];value",
          ".iterators;LoopingListIterator;true;LoopingListIterator;;;Element of Argument[0];Element of Argument[-1];value",
          ".iterators;ObjectArrayIterator;true;ObjectArrayIterator;;;ArrayElement of Argument[0];Element of Argument[-1];value",
          ".iterators;ObjectArrayIterator;true;getArray;;;Element of Argument[-1];ArrayElement of ReturnValue;value",
          ".iterators;ObjectArrayListIterator;true;ObjectArrayListIterator;;;ArrayElement of Argument[0];Element of Argument[-1];value",
          ".iterators;PeekingIterator;true;PeekingIterator;;;Element of Argument[0];Element of Argument[-1];value",
          ".iterators;PeekingIterator;true;peekingIterator;;;Element of Argument[0];Element of ReturnValue;value",
          ".iterators;PeekingIterator;true;peek;;;Element of Argument[-1];ReturnValue;value",
          ".iterators;PeekingIterator;true;element;;;Element of Argument[-1];ReturnValue;value",
          ".iterators;PermutationIterator;true;PermutationIterator;;;Element of Argument[0];Element of Element of Argument[-1];value",
          ".iterators;PushbackIterator;true;PushbackIterator;;;Element of Argument[0];Element of Argument[-1];value",
          ".iterators;PushbackIterator;true;pushbackIterator;;;Element of Argument[0];Element of ReturnValue;value",
          ".iterators;PushbackIterator;true;pushback;;;Argument[0];Element of Argument[-1];value",
          ".iterators;ReverseListIterator;true;ReverseListIterator;;;Element of Argument[0];Element of Argument[-1];value",
          ".iterators;SingletonIterator;true;SingletonIterator;;;Argument[0];Element of Argument[-1];value",
          ".iterators;SingletonListIterator;true;SingletonListIterator;;;Argument[0];Element of Argument[-1];value",
          ".iterators;SkippingIterator;true;SkippingIterator;;;Element of Argument[0];Element of Argument[-1];value",
          ".iterators;UniqueFilterIterator;true;UniqueFilterIterator;;;Element of Argument[0];Element of Argument[-1];value",
          ".iterators;UnmodifiableIterator;true;unmodifiableIterator;;;Element of Argument[0];Element of ReturnValue;value",
          ".iterators;UnmodifiableListIterator;true;umodifiableListIterator;;;Element of Argument[0];Element of ReturnValue;value",
          ".iterators;UnmodifiableMapIterator;true;unmodifiableMapIterator;;;Element of Argument[0];Element of ReturnValue;value",
          ".iterators;UnmodifiableMapIterator;true;unmodifiableMapIterator;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ".iterators;UnmodifiableOrderedMapIterator;true;unmodifiableOrderedMapIterator;;;Element of Argument[0];Element of ReturnValue;value",
          ".iterators;UnmodifiableOrderedMapIterator;true;unmodifiableOrderedMapIterator;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ".iterators;ZippingIterator;true;ZippingIterator;(Iterator[]);;Element of ArrayElement of Argument[0];Element of Argument[-1];value",
          ".iterators;ZippingIterator;true;ZippingIterator;(Iterator,Iterator);;Element of Argument[0];Element of Argument[-1];value",
          ".iterators;ZippingIterator;true;ZippingIterator;(Iterator,Iterator);;Element of Argument[1];Element of Argument[-1];value",
          ".iterators;ZippingIterator;true;ZippingIterator;(Iterator,Iterator,Iterator);;Element of Argument[0];Element of Argument[-1];value",
          ".iterators;ZippingIterator;true;ZippingIterator;(Iterator,Iterator,Iterator);;Element of Argument[1];Element of Argument[-1];value",
          ".iterators;ZippingIterator;true;ZippingIterator;(Iterator,Iterator,Iterator);;Element of Argument[2];Element of Argument[-1];value"
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
          ".list;AbstractLinkedList;true;AbstractLinkedList;;;Element of Argument[0];Element of Argument[-1];value",
          ".list;AbstractLinkedList;true;getFirst;;;Element of Argument[-1];ReturnValue;value",
          ".list;AbstractLinkedList;true;getLast;;;Element of Argument[-1];ReturnValue;value",
          ".list;AbstractLinkedList;true;addFirst;;;Argument[0];Element of Argument[-1];value",
          ".list;AbstractLinkedList;true;addLast;;;Argument[0];Element of Argument[-1];value",
          ".list;AbstractLinkedList;true;removeFirst;;;Element of Argument[-1];ReturnValue;value",
          ".list;AbstractLinkedList;true;removeLast;;;Element of Argument[-1];ReturnValue;value",
          ".list;AbstractListDecorator;true;AbstractListDecorator;;;Element of Argument[0];Element of Argument[-1];value",
          ".list;AbstractSerializableListDecorator;true;AbstractSerializableListDecorator;;;Element of Argument[0];Element of Argument[-1];value",
          ".list;CursorableLinkedList;true;CursorableLinkedList;;;Element of Argument[0];Element of Argument[-1];value",
          ".list;CursorableLinkedList;true;cursor;;;Element of Argument[-1];Element of ReturnValue;value",
          ".list;FixedSizeList;true;fixedSizeList;;;Element of Argument[0];Element of ReturnValue;value",
          ".list;GrowthList;true;growthList;;;Element of Argument[0];Element of ReturnValue;value",
          ".list;LazyList;true;lazyList;;;Element of Argument[0];Element of ReturnValue;value",
          ".list;NodeCachingLinkedList;true;NodeCachingLinkedList;(Collection);;Element of Argument[0];Element of Argument[-1];value",
          ".list;PredicatedList;true;predicatedList;;;Element of Argument[0];Element of ReturnValue;value",
          ".list;SetUniqueList;true;setUniqueList;;;Element of Argument[0];Element of ReturnValue;value",
          ".list;SetUniqueList;true;asSet;;;Element of Argument[-1];Element of ReturnValue;value",
          ".list;TransformedList;true;transformingList;;;Element of Argument[0];Element of ReturnValue;value",
          ".list;TreeList;true;TreeList;;;Element of Argument[0];Element of Argument[-1];value",
          ".list;UnmodifiableList;true;UnmodifiableList;;;Element of Argument[0];Element of Argument[-1];value",
          ".list;UnmodifiableList;true;unmodifiableList;;;Element of Argument[0];Element of ReturnValue;value"
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
          ".map;AbstractHashedMap;true;AbstractHashedMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".map;AbstractHashedMap;true;AbstractHashedMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".map;AbstractLinkedMap;true;AbstractLinkedMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".map;AbstractLinkedMap;true;AbstractLinkedMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".map;AbstractMapDecorator;true;AbstractMapDecorator;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".map;AbstractMapDecorator;true;AbstractMapDecorator;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".map;AbstractMapDecorator;true;decorated;;;MapKey of Argument[-1];MapKey of ReturnValue;value",
          ".map;AbstractMapDecorator;true;decorated;;;MapValue of Argument[-1];MapValue of ReturnValue;value",
          ".map;AbstractOrderedMapDecorator;true;AbstractOrderedMapDecorator;(OrderedMap);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".map;AbstractOrderedMapDecorator;true;AbstractOrderedMapDecorator;(OrderedMap);;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".map;AbstractSortedMapDecorator;true;AbstractSortedMapDecorator;(SortedMap);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".map;AbstractSortedMapDecorator;true;AbstractSortedMapDecorator;(SortedMap);;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".map;CaseInsensitiveMap;true;CaseInsensitiveMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".map;CaseInsensitiveMap;true;CaseInsensitiveMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".map;CompositeMap;true;CompositeMap;(Map,Map);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".map;CompositeMap;true;CompositeMap;(Map,Map);;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".map;CompositeMap;true;CompositeMap;(Map,Map);;MapKey of Argument[1];MapKey of Argument[-1];value",
          ".map;CompositeMap;true;CompositeMap;(Map,Map);;MapValue of Argument[1];MapValue of Argument[-1];value",
          ".map;CompositeMap;true;CompositeMap;(Map,Map,MapMutator);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".map;CompositeMap;true;CompositeMap;(Map,Map,MapMutator);;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".map;CompositeMap;true;CompositeMap;(Map,Map,MapMutator);;MapKey of Argument[1];MapKey of Argument[-1];value",
          ".map;CompositeMap;true;CompositeMap;(Map,Map,MapMutator);;MapValue of Argument[1];MapValue of Argument[-1];value",
          ".map;CompositeMap;true;CompositeMap;(Map[]);;MapKey of ArrayElement of Argument[0];MapKey of Argument[-1];value",
          ".map;CompositeMap;true;CompositeMap;(Map[]);;MapValue of ArrayElement of Argument[0];MapValue of Argument[-1];value",
          ".map;CompositeMap;true;CompositeMap;(Map[],MapMutator);;MapKey of ArrayElement of Argument[0];MapKey of Argument[-1];value",
          ".map;CompositeMap;true;CompositeMap;(Map[],MapMutator);;MapValue of ArrayElement of Argument[0];MapValue of Argument[-1];value",
          ".map;CompositeMap;true;addComposited;;;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".map;CompositeMap;true;addComposited;;;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".map;CompositeMap;true;removeComposited;;;MapKey of Argument[-1];MapKey of ReturnValue;value",
          ".map;CompositeMap;true;removeComposited;;;MapValue of Argument[-1];MapValue of ReturnValue;value",
          ".map;CompositeMap;true;removeComposited;;;Argument[0];ReturnValue;value",
          ".map;DefaultedMap;true;DefaultedMap;(Object);;Argument[0];MapValue of Argument[-1];value",
          ".map;DefaultedMap;true;defaultedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ".map;DefaultedMap;true;defaultedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ".map;DefaultedMap;true;defaultedMap;(Map,Object);;Argument[1];MapValue of ReturnValue;value",
          ".map;EntrySetToMapIteratorAdapter;true;EntrySetToMapIteratorAdapter;;;MapKey of Element of Argument[0];Element of Argument[-1];value",
          ".map;EntrySetToMapIteratorAdapter;true;EntrySetToMapIteratorAdapter;;;MapValue of Element of Argument[0];MapValue of Argument[-1];value",
          ".map;FixedSizeMap;true;fixedSizeMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ".map;FixedSizeMap;true;fixedSizeMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ".map;FixedSizeSortedMap;true;fixedSizeSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ".map;FixedSizeSortedMap;true;fixedSizeSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ".map;Flat3Map;true;Flat3Map;;;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".map;Flat3Map;true;Flat3Map;;;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".map;HashedMap;true;HashedMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".map;HashedMap;true;HashedMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".map;LazyMap;true;lazyMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ".map;LazyMap;true;lazyMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ".map;LazySortedMap;true;lazySortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ".map;LazySortedMap;true;lazySortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ".map;LinkedMap;true;LinkedMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".map;LinkedMap;true;LinkedMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".map;LinkedMap;true;get;(int);;MapKey of Argument[-1];ReturnValue;value",
          ".map;LinkedMap;true;getValue;(int);;MapValue of Argument[-1];ReturnValue;value",
          ".map;LinkedMap;true;remove;(int);;MapValue of Argument[-1];ReturnValue;value",
          ".map;LinkedMap;true;asList;;;MapKey of Argument[-1];Element of ReturnValue;value",
          ".map;ListOrderedMap;true;listOrderedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ".map;ListOrderedMap;true;listOrderedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ".map;ListOrderedMap;true;putAll;;;MapKey of Argument[1];MapKey of Argument[-1];value",
          ".map;ListOrderedMap;true;putAll;;;MapValue of Argument[1];MapValue of Argument[-1];value",
          ".map;ListOrderedMap;true;keyList;;;MapKey of Argument[-1];Element of ReturnValue;value",
          ".map;ListOrderedMap;true;valueList;;;MapValue of Argument[-1];Element of ReturnValue;value",
          ".map;ListOrderedMap;true;get;(int);;MapKey of Argument[-1];ReturnValue;value",
          ".map;ListOrderedMap;true;getValue;(int);;MapValue of Argument[-1];ReturnValue;value",
          ".map;ListOrderedMap;true;setValue;;;Argument[1];MapValue of Argument[-1];value",
          ".map;ListOrderedMap;true;put;;;Argument[1];MapKey of Argument[-1];value",
          ".map;ListOrderedMap;true;put;;;Argument[2];MapValue of Argument[-1];value",
          ".map;ListOrderedMap;true;remove;(int);;MapValue of Argument[-1];ReturnValue;value",
          ".map;ListOrderedMap;true;asList;;;MapKey of Argument[-1];Element of ReturnValue;value",
          ".map;LRUMap;true;LRUMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".map;LRUMap;true;LRUMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".map;LRUMap;true;LRUMap;(Map,boolean);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".map;LRUMap;true;LRUMap;(Map,boolean);;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".map;LRUMap;true;get;(Object,boolean);;MapValue of Argument[0];ReturnValue;value",
          ".map;MultiKeyMap;true;get;;;MapValue of Argument[-1];ReturnValue;value",
          ".map;MultiKeyMap;true;put;;;MapValue of Argument[-1];ReturnValue;value",
          ".map;MultiKeyMap;true;put;(Object,Object,Object);;Argument[0..1];Element of MapKey of Argument[-1];value",
          ".map;MultiKeyMap;true;put;(Object,Object,Object,Object);;Argument[0..2];Element of MapKey of Argument[-1];value",
          ".map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object);;Argument[0..3];Element of MapKey of Argument[-1];value",
          ".map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object,Object);;Argument[0..4];Element of MapKey of Argument[-1];value",
          ".map;MultiKeyMap;true;put;(Object,Object,Object);;Argument[2];MapValue of Argument[-1];value",
          ".map;MultiKeyMap;true;put;(Object,Object,Object,Object);;Argument[3];MapValue of Argument[-1];value",
          ".map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object);;Argument[4];MapValue of Argument[-1];value",
          ".map;MultiKeyMap;true;put;(Object,Object,Object,Object,Object,Object);;Argument[5];MapValue of Argument[-1];value",
          ".map;MultiKeyMap;true;removeMultiKey;;;MapValue of Argument[-1];ReturnValue;value",
          ".map;MultiValueMap;true;multiValueMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ".map;MultiValueMap;true;multiValueMap;;;Element of MapValue of Argument[0];Element of MapValue of ReturnValue;value",
          ".map;MultiValueMap;true;getCollection;;;Element of MapValue of Argument[-1];Element of ReturnValue;value",
          ".map;MultiValueMap;true;putAll;(Map);;MapValue of Argument[0];Element of MapValue of Argument[-1];value",
          ".map;MultiValueMap;true;putAll;(Map);;Element of MapValue of Argument[0];Element of MapValue of Argument[-1];value",
          ".map;MultiValueMap;true;values;;;Element of MapValue of Argument[-1];Element of ReturnValue;value",
          ".map;MultiValueMap;true;putAll;(Object,Collection);;Argument[0];MapKey of Argument[-1];value",
          ".map;MultiValueMap;true;putAll;(Object,Collection);;Element of Argument[1];Element of MapValue of Argument[-1];value",
          ".map;MultiValueMap;true;iterator;(Object);;Element of MapValue of Argument[-1];Element of ReturnValue;value",
          ".map;MultiValueMap;true;iterator;();;MapKey of Argument[-1];MapKey of Element of ReturnValue;value",
          ".map;MultiValueMap;true;iterator;();;Element of MapValue of Argument[-1];MapValue of Element of ReturnValue;value",
          ".map;PassiveExpiringMap;true;PassiveExpiringMap;(ExpirationPolicy,Map);;MapKey of Argument[1];MapKey of Argument[-1];value",
          ".map;PassiveExpiringMap;true;PassiveExpiringMap;(ExpirationPolicy,Map);;MapValue of Argument[1];MapValue of Argument[-1];value",
          ".map;PassiveExpiringMap;true;PassiveExpiringMap;(long,Map);;MapKey of Argument[1];MapKey of Argument[-1];value",
          ".map;PassiveExpiringMap;true;PassiveExpiringMap;(long,Map);;MapValue of Argument[1];MapValue of Argument[-1];value",
          ".map;PassiveExpiringMap;true;PassiveExpiringMap;(long,TimeUnit,Map);;MapKey of Argument[2];MapKey of Argument[-1];value",
          ".map;PassiveExpiringMap;true;PassiveExpiringMap;(long,TimeUnit,Map);;MapValue of Argument[2];MapValue of Argument[-1];value",
          ".map;PassiveExpiringMap;true;PassiveExpiringMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".map;PassiveExpiringMap;true;PassiveExpiringMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".map;PredicatedMap;true;predicatedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ".map;PredicatedMap;true;predicatedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ".map;PredicatedSortedMap;true;predicatedSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ".map;PredicatedSortedMap;true;predicatedSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ".map;SingletonMap;true;SingletonMap;(Object,Object);;Argument[0];MapKey of Argument[-1];value",
          ".map;SingletonMap;true;SingletonMap;(Object,Object);;Argument[1];MapValue of Argument[-1];value",
          ".map;SingletonMap;true;SingletonMap;(KeyValue);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".map;SingletonMap;true;SingletonMap;(KeyValue);;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".map;SingletonMap;true;SingletonMap;(Entry);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".map;SingletonMap;true;SingletonMap;(Entry);;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".map;SingletonMap;true;SingletonMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".map;SingletonMap;true;SingletonMap;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".map;SingletonMap;true;setValue;;;Argument[0];MapValue of Argument[-1];value",
          ".map;TransformedMap;true;transformingMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ".map;TransformedMap;true;transformingMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ".map;TransformedSortedMap;true;transformingSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ".map;TransformedSortedMap;true;transformingSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ".map;UnmodifiableEntrySet;true;unmodifiableEntrySet;;;MapKey of Element of Argument[0];MapKey of Element of ReturnValue;value",
          ".map;UnmodifiableEntrySet;true;unmodifiableEntrySet;;;MapValue of Element of Argument[0];MapValue of Element of ReturnValue;value",
          ".map;UnmodifiableMap;true;unmodifiableMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ".map;UnmodifiableMap;true;unmodifiableMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ".map;UnmodifiableOrderedMap;true;unmodifiableOrderedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ".map;UnmodifiableOrderedMap;true;unmodifiableOrderedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ".map;UnmodifiableSortedMap;true;unmodifiableSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ".map;UnmodifiableSortedMap;true;unmodifiableSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
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
          ".multimap;ArrayListValuedHashMap;true;ArrayListValuedHashMap;(MultiValuedMap);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".multimap;ArrayListValuedHashMap;true;ArrayListValuedHashMap;(MultiValuedMap);;Element of MapValue of Argument[0];Element of MapValue of Argument[-1];value",
          ".multimap;ArrayListValuedHashMap;true;ArrayListValuedHashMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".multimap;ArrayListValuedHashMap;true;ArrayListValuedHashMap;(Map);;MapValue of Argument[0];Element of MapValue of Argument[-1];value",
          ".multimap;HashSetValuedHashMap;true;HashSetValuedHashMap;(MultiValuedMap);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".multimap;HashSetValuedHashMap;true;HashSetValuedHashMap;(MultiValuedMap);;Element of MapValue of Argument[0];Element of MapValue of Argument[-1];value",
          ".multimap;HashSetValuedHashMap;true;HashSetValuedHashMap;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".multimap;HashSetValuedHashMap;true;HashSetValuedHashMap;(Map);;MapValue of Argument[0];Element of MapValue of Argument[-1];value",
          ".multimap;TransformedMultiValuedMap;true;transformingMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ".multimap;TransformedMultiValuedMap;true;transformingMap;;;Element of MapValue of Argument[0];Element of MapValue of ReturnValue;value",
          ".multimap;UnmodifiableMultiValuedMap;true;unmodifiableMultiValuedMap;(MultiValuedMap);;MapKey of Argument[0];MapKey of ReturnValue;value",
          ".multimap;UnmodifiableMultiValuedMap;true;unmodifiableMultiValuedMap;(MultiValuedMap);;Element of MapValue of Argument[0];Element of MapValue of ReturnValue;value"
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
          ".multiset;HashMultiSet;true;HashMultiSet;;;Element of Argument[0];Element of Argument[-1];value",
          ".multiset;PredicatedMultiSet;true;predicatedMultiSet;;;Element of Argument[0];Element of ReturnValue;value",
          ".multiset;SynchronizedMultiSet;true;synchronizedMultiSet;;;Element of Argument[0];Element of ReturnValue;value",
          ".multiset;UnmodifiableMultiSet;true;unmodifiableMultiSet;;;Element of Argument[0];Element of ReturnValue;value"
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
          ".queue;CircularFifoQueue;true;CircularFifoQueue;(Collection);;Element of Argument[0];Element of Argument[-1];value",
          ".queue;CircularFifoQueue;true;get;;;Element of Argument[-1];ReturnValue;value",
          ".queue;PredicatedQueue;true;predicatedQueue;;;Element of Argument[0];Element of ReturnValue;value",
          ".queue;SynchronizedQueue;true;synchronizedQueue;;;Element of Argument[0];Element of ReturnValue;value",
          ".queue;TransformedQueue;true;transformingQueue;;;Element of Argument[0];Element of ReturnValue;value",
          ".queue;UnmodifiableQueue;true;unmodifiableQueue;;;Element of Argument[0];Element of ReturnValue;value"
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
          ".set;AbstractNavigableSetDecorator;true;AbstractNavigableSetDecorator;;;Element of Argument[0];Element of Argument[-1];value",
          ".set;AbstractSetDecorator;true;AbstractSetDecorator;;;Element of Argument[0];Element of Argument[-1];value",
          ".set;AbstractSortedSetDecorator;true;AbstractSortedSetDecorator;;;Element of Argument[0];Element of Argument[-1];value",
          ".set;CompositeSet$SetMutator;true;add;;;Argument[2];Element of Argument[0];value",
          ".set;CompositeSet$SetMutator;true;add;;;Argument[2];Element of Element of Argument[1];value",
          ".set;CompositeSet$SetMutator;true;addAll;;;Element of Argument[2];Element of Argument[0];value",
          ".set;CompositeSet$SetMutator;true;addAll;;;Element of Argument[2];Element of Element of Argument[1];value",
          ".set;CompositeSet;true;CompositeSet;(Set);;Element of Argument[0];Element of Argument[-1];value",
          ".set;CompositeSet;true;CompositeSet;(Set[]);;Element of ArrayElement of Argument[0];Element of Argument[-1];value",
          ".set;CompositeSet;true;addComposited;(Set);;Element of Argument[0];Element of Argument[-1];value",
          ".set;CompositeSet;true;addComposited;(Set,Set);;Element of Argument[0];Element of Argument[-1];value",
          ".set;CompositeSet;true;addComposited;(Set,Set);;Element of Argument[1];Element of Argument[-1];value",
          ".set;CompositeSet;true;addComposited;(Set[]);;Element of ArrayElement of Argument[0];Element of Argument[-1];value",
          ".set;CompositeSet;true;toSet;;;Element of Argument[-1];Element of ReturnValue;value",
          ".set;CompositeSet;true;getSets;;;Element of Argument[-1];Element of Element of ReturnValue;value",
          ".set;ListOrderedSet;true;listOrderedSet;(Set);;Element of Argument[0];Element of ReturnValue;value",
          ".set;ListOrderedSet;true;listOrderedSet;(List);;Element of Argument[0];Element of ReturnValue;value",
          ".set;ListOrderedSet;true;asList;;;Element of Argument[-1];Element of ReturnValue;value",
          ".set;ListOrderedSet;true;get;;;Element of Argument[-1];ReturnValue;value",
          ".set;ListOrderedSet;true;add;;;Argument[1];Element of Argument[-1];value",
          ".set;ListOrderedSet;true;addAll;;;Element of Argument[1];Element of Argument[-1];value",
          ".set;MapBackedSet;true;mapBackedSet;;;MapKey of Argument[0];Element of ReturnValue;value",
          ".set;PredicatedNavigableSet;true;predicatedNavigableSet;;;Element of Argument[0];Element of ReturnValue;value",
          ".set;PredicatedSet;true;predicatedSet;;;Element of Argument[0];Element of ReturnValue;value",
          ".set;PredicatedSortedSet;true;predicatedSortedSet;;;Element of Argument[0];Element of ReturnValue;value",
          ".set;TransformedNavigableSet;true;transformingNavigableSet;;;Element of Argument[0];Element of ReturnValue;value",
          ".set;TransformedSet;true;transformingSet;;;Element of Argument[0];Element of ReturnValue;value",
          ".set;TransformedSortedSet;true;transformingSortedSet;;;Element of Argument[0];Element of ReturnValue;value",
          ".set;UnmodifiableNavigableSet;true;unmodifiableNavigableSet;;;Element of Argument[0];Element of ReturnValue;value",
          ".set;UnmodifiableSet;true;unmodifiableSet;;;Element of Argument[0];Element of ReturnValue;value",
          ".set;UnmodifiableSortedSet;true;unmodifiableSortedSet;;;Element of Argument[0];Element of ReturnValue;value"
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
          ".splitmap;AbstractIterableGetMapDecorator;true;AbstractIterableGetMapDecorator;;;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".splitmap;AbstractIterableGetMapDecorator;true;AbstractIterableGetMapDecorator;;;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".splitmap;TransformedSplitMap;true;transformingMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ".splitmap;TransformedSplitMap;true;transformingMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
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
          ".trie;PatriciaTrie;true;PatriciaTrie;;;MapKey of Argument[0];MapKey of Argument[-1];value",
          ".trie;PatriciaTrie;true;PatriciaTrie;;;MapValue of Argument[0];MapValue of Argument[-1];value",
          ".trie;AbstractPatriciaTrie;true;select;;;MapKey of Argument[-1];MapKey of ReturnValue;value",
          ".trie;AbstractPatriciaTrie;true;select;;;MapValue of Argument[-1];MapValue of ReturnValue;value",
          ".trie;AbstractPatriciaTrie;true;selectKey;;;MapKey of Argument[-1];ReturnValue;value",
          ".trie;AbstractPatriciaTrie;true;selectValue;;;MapValue of Argument[-1];ReturnValue;value",
          ".trie;UnmodifiableTrie;true;unmodifiableTrie;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ".trie;UnmodifiableTrie;true;unmodifiableTrie;;;MapValue of Argument[0];MapValue of ReturnValue;value"
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
          ";MapUtils;true;fixedSizeMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ";MapUtils;true;fixedSizeMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ";MapUtils;true;fixedSizeSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ";MapUtils;true;fixedSizeSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ";MapUtils;true;getMap;;;MapValue of Argument[0];ReturnValue;value",
          ";MapUtils;true;getMap;;;Argument[2];ReturnValue;value",
          ";MapUtils;true;getObject;;;MapValue of Argument[0];ReturnValue;value",
          ";MapUtils;true;getObject;;;Argument[2];ReturnValue;value",
          ";MapUtils;true;getString;;;MapValue of Argument[0];ReturnValue;value",
          ";MapUtils;true;getString;;;Argument[2];ReturnValue;value",
          ";MapUtils;true;invertMap;;;MapKey of Argument[0];MapValue of ReturnValue;value",
          ";MapUtils;true;invertMap;;;MapValue of Argument[0];MapKey of ReturnValue;value",
          ";MapUtils;true;iterableMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ";MapUtils;true;iterableMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ";MapUtils;true;iterableSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ";MapUtils;true;iterableSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ";MapUtils;true;lazyMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ";MapUtils;true;lazyMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ";MapUtils;true;lazySortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ";MapUtils;true;lazySortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ";MapUtils;true;multiValueMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ";MapUtils;true;multiValueMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ";MapUtils;true;orderedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ";MapUtils;true;orderedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ";MapUtils;true;populateMap;(Map,Iterable,Transformer);;Element of Argument[1];MapValue of Argument[0];value",
          ";MapUtils;true;populateMap;(MultiMap,Iterable,Transformer);;Element of Argument[1];Element of MapValue of Argument[0];value",
          ";MapUtils;true;predicatedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ";MapUtils;true;predicatedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ";MapUtils;true;predicatedSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ";MapUtils;true;predicatedSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ";MapUtils;true;putAll;;;ArrayElement of Argument[1];MapKey of Argument[0];value",
          ";MapUtils;true;putAll;;;ArrayElement of Argument[1];MapKey of ReturnValue;value",
          ";MapUtils;true;putAll;;;ArrayElement of Argument[1];MapValue of Argument[0];value",
          ";MapUtils;true;putAll;;;ArrayElement of Argument[1];MapValue of ReturnValue;value",
          ";MapUtils;true;putAll;;;ArrayElement of ArrayElement of Argument[1];MapKey of Argument[0];value",
          ";MapUtils;true;putAll;;;ArrayElement of ArrayElement of Argument[1];MapKey of ReturnValue;value",
          ";MapUtils;true;putAll;;;ArrayElement of ArrayElement of Argument[1];MapValue of Argument[0];value",
          ";MapUtils;true;putAll;;;ArrayElement of ArrayElement of Argument[1];MapValue of ReturnValue;value",
          ";MapUtils;true;putAll;;;MapKey of ArrayElement of Argument[1];MapKey of Argument[0];value",
          ";MapUtils;true;putAll;;;MapKey of ArrayElement of Argument[1];MapKey of ReturnValue;value",
          ";MapUtils;true;putAll;;;MapValue of ArrayElement of Argument[1];MapValue of Argument[0];value",
          ";MapUtils;true;putAll;;;MapValue of ArrayElement of Argument[1];MapValue of ReturnValue;value",
          ";MapUtils;true;safeAddToMap;;;Argument[1];MapKey of Argument[0];value",
          ";MapUtils;true;safeAddToMap;;;Argument[2];MapValue of Argument[0];value",
          ";MapUtils;true;synchronizedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ";MapUtils;true;synchronizedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ";MapUtils;true;synchronizedSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ";MapUtils;true;synchronizedSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ";MapUtils;true;toMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ";MapUtils;true;toMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ";MapUtils;true;transformedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ";MapUtils;true;transformedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ";MapUtils;true;transformedSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ";MapUtils;true;transformedSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ";MapUtils;true;unmodifiableMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ";MapUtils;true;unmodifiableMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ";MapUtils;true;unmodifiableSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ";MapUtils;true;unmodifiableSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
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
          ";CollectionUtils;true;addAll;(Collection,Object[]);;ArrayElement of Argument[1];Element of Argument[0];value",
          ";CollectionUtils;true;addAll;(Collection,Enumeration);;Element of Argument[1];Element of Argument[0];value",
          ";CollectionUtils;true;addAll;(Collection,Iterable);;Element of Argument[1];Element of Argument[0];value",
          ";CollectionUtils;true;addAll;(Collection,Iterator);;Element of Argument[1];Element of Argument[0];value",
          ";CollectionUtils;true;addIgnoreNull;;;Argument[1];Element of Argument[0];value",
          ";CollectionUtils;true;collate;;;Element of Argument[0];Element of ReturnValue;value",
          ";CollectionUtils;true;collate;;;Element of Argument[1];Element of ReturnValue;value",
          ";CollectionUtils;true;disjunction;;;Element of Argument[0];Element of ReturnValue;value",
          ";CollectionUtils;true;disjunction;;;Element of Argument[1];Element of ReturnValue;value",
          ";CollectionUtils;true;emptyIfNull;;;Argument[0];ReturnValue;value",
          ";CollectionUtils;true;extractSingleton;;;Element of Argument[0];ReturnValue;value",
          ";CollectionUtils;true;find;;;Element of Argument[0];ReturnValue;value",
          ";CollectionUtils;true;get;(Iterator,int);;Element of Argument[0];ReturnValue;value",
          ";CollectionUtils;true;get;(Iterable,int);;Element of Argument[0];ReturnValue;value",
          ";CollectionUtils;true;get;(Map,int);;MapKey of Argument[0];MapKey of ReturnValue;value",
          ";CollectionUtils;true;get;(Map,int);;MapValue of Argument[0];MapValue of ReturnValue;value",
          ";CollectionUtils;true;get;(Object,int);;ArrayElement of Argument[0];ReturnValue;value",
          ";CollectionUtils;true;get;(Object,int);;Element of Argument[0];ReturnValue;value",
          ";CollectionUtils;true;get;(Object,int);;MapKey of Argument[0];MapKey of ReturnValue;value",
          ";CollectionUtils;true;get;(Object,int);;MapValue of Argument[0];MapValue of ReturnValue;value",
          ";CollectionUtils;true;getCardinalityMap;;;Element of Argument[0];MapKey of ReturnValue;value",
          ";CollectionUtils;true;intersection;;;Element of Argument[0];Element of ReturnValue;value",
          ";CollectionUtils;true;intersection;;;Element of Argument[1];Element of ReturnValue;value",
          ";CollectionUtils;true;permutations;;;Element of Argument[0];Element of Element of ReturnValue;value",
          ";CollectionUtils;true;predicatedCollection;;;Element of Argument[0];Element of ReturnValue;value",
          ";CollectionUtils;true;removeAll;;;Element of Argument[0];Element of ReturnValue;value",
          ";CollectionUtils;true;retainAll;;;Element of Argument[0];Element of ReturnValue;value",
          ";CollectionUtils;true;select;(Iterable,Predicate);;Element of Argument[0];Element of ReturnValue;value",
          ";CollectionUtils;true;select;(Iterable,Predicate,Collection);;Element of Argument[0];Element of Argument[2];value",
          ";CollectionUtils;true;select;(Iterable,Predicate,Collection);;Argument[2];ReturnValue;value",
          ";CollectionUtils;true;select;(Iterable,Predicate,Collection,Collection);;Element of Argument[0];Element of Argument[2];value",
          ";CollectionUtils;true;select;(Iterable,Predicate,Collection,Collection);;Element of Argument[0];Element of Argument[3];value",
          ";CollectionUtils;true;select;(Iterable,Predicate,Collection,Collection);;Argument[2];ReturnValue;value",
          ";CollectionUtils;true;selectRejected;(Iterable,Predicate);;Element of Argument[0];Element of ReturnValue;value",
          ";CollectionUtils;true;selectRejected;(Iterable,Predicate,Collection);;Element of Argument[0];Element of Argument[2];value",
          ";CollectionUtils;true;selectRejected;(Iterable,Predicate,Collection);;Argument[2];ReturnValue;value",
          ";CollectionUtils;true;subtract;;;Element of Argument[0];Element of ReturnValue;value",
          ";CollectionUtils;true;synchronizedCollection;;;Element of Argument[0];Element of ReturnValue;value",
          // Note that `CollectionUtils.transformingCollection` does not transform existing list elements
          ";CollectionUtils;true;transformingCollection;;;Element of Argument[0];Element of ReturnValue;value",
          ";CollectionUtils;true;union;;;Element of Argument[0];Element of ReturnValue;value",
          ";CollectionUtils;true;union;;;Element of Argument[1];Element of ReturnValue;value",
          ";CollectionUtils;true;unmodifiableCollection;;;Element of Argument[0];Element of ReturnValue;value"
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
          ";ListUtils;true;fixedSizeList;;;Element of Argument[0];Element of ReturnValue;value",
          ";ListUtils;true;intersection;;;Element of Argument[0];Element of ReturnValue;value",
          ";ListUtils;true;intersection;;;Element of Argument[1];Element of ReturnValue;value",
          // Note that `ListUtils.lazyList` does not transform existing list elements
          ";ListUtils;true;lazyList;;;Element of Argument[0];Element of ReturnValue;value",
          ";ListUtils;true;longestCommonSubsequence;(CharSequence,CharSequence);;Argument[0];ReturnValue;taint",
          ";ListUtils;true;longestCommonSubsequence;(CharSequence,CharSequence);;Argument[1];ReturnValue;taint",
          ";ListUtils;true;longestCommonSubsequence;(List,List);;Element of Argument[0];Element of ReturnValue;value",
          ";ListUtils;true;longestCommonSubsequence;(List,List);;Element of Argument[1];Element of ReturnValue;value",
          ";ListUtils;true;longestCommonSubsequence;(List,List,Equator);;Element of Argument[0];Element of ReturnValue;value",
          ";ListUtils;true;longestCommonSubsequence;(List,List,Equator);;Element of Argument[1];Element of ReturnValue;value",
          ";ListUtils;true;partition;;;Element of Argument[0];Element of Element of ReturnValue;value",
          ";ListUtils;true;predicatedList;;;Element of Argument[0];Element of ReturnValue;value",
          ";ListUtils;true;removeAll;;;Element of Argument[0];Element of ReturnValue;value",
          ";ListUtils;true;retainAll;;;Element of Argument[0];Element of ReturnValue;value",
          ";ListUtils;true;select;;;Element of Argument[0];Element of ReturnValue;value",
          ";ListUtils;true;selectRejected;;;Element of Argument[0];Element of ReturnValue;value",
          ";ListUtils;true;subtract;;;Element of Argument[0];Element of ReturnValue;value",
          ";ListUtils;true;sum;;;Element of Argument[0];Element of ReturnValue;value",
          ";ListUtils;true;sum;;;Element of Argument[1];Element of ReturnValue;value",
          ";ListUtils;true;synchronizedList;;;Element of Argument[0];Element of ReturnValue;value",
          // Note that `ListUtils.transformedList` does not transform existing list elements
          ";ListUtils;true;transformedList;;;Element of Argument[0];Element of ReturnValue;value",
          ";ListUtils;true;union;;;Element of Argument[0];Element of ReturnValue;value",
          ";ListUtils;true;union;;;Element of Argument[1];Element of ReturnValue;value",
          ";ListUtils;true;unmodifiableList;;;Element of Argument[0];Element of ReturnValue;value"
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
          ";IteratorUtils;true;arrayIterator;;;ArrayElement of Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;arrayListIterator;;;ArrayElement of Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;asEnumeration;;;Element of Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;asIterable;;;Element of Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;asIterator;;;Element of Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;asMultipleUseIterable;;;Element of Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;boundedIterator;;;Element of Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;chainedIterator;(Collection);;Element of Element of Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;chainedIterator;(Iterator[]);;Element of ArrayElement of Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;chainedIterator;(Iterator,Iterator);;Element of Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;chainedIterator;(Iterator,Iterator);;Element of Argument[1];Element of ReturnValue;value",
          ";IteratorUtils;true;collatedIterator;(Comparator,Collection);;Element of Element of Argument[1];Element of ReturnValue;value",
          ";IteratorUtils;true;collatedIterator;(Comparator,Iterator[]);;Element of ArrayElement of Argument[1];Element of ReturnValue;value",
          ";IteratorUtils;true;collatedIterator;(Comparator,Iterator,Iterator);;Element of Argument[1];Element of ReturnValue;value",
          ";IteratorUtils;true;collatedIterator;(Comparator,Iterator,Iterator);;Element of Argument[2];Element of ReturnValue;value",
          ";IteratorUtils;true;filteredIterator;;;Element of Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;filteredListIterator;;;Element of Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;find;;;Element of Argument[0];ReturnValue;value",
          ";IteratorUtils;true;first;;;Element of Argument[0];ReturnValue;value",
          ";IteratorUtils;true;forEachButLast;;;Element of Argument[0];ReturnValue;value",
          ";IteratorUtils;true;get;;;Element of Argument[0];ReturnValue;value",
          ";IteratorUtils;true;getIterator;;;Element of Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;getIterator;;;ArrayElement of Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;getIterator;;;Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;getIterator;;;MapValue of Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;loopingIterator;;;Element of Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;loopingListIterator;;;Element of Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;peekingIterator;;;Element of Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;pushbackIterator;;;Element of Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;singletonIterator;;;Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;singletonListIterator;;;Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;skippingIterator;;;Element of Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;toArray;;;Element of Argument[0];ArrayElement of ReturnValue;value",
          ";IteratorUtils;true;toList;;;Element of Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;toListIterator;;;Element of Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;toString;;;Argument[2];ReturnValue;taint",
          ";IteratorUtils;true;toString;;;Argument[3];ReturnValue;taint",
          ";IteratorUtils;true;toString;;;Argument[4];ReturnValue;taint",
          ";IteratorUtils;true;unmodifiableIterator;;;Element of Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;unmodifiableListIterator;;;Element of Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;unmodifiableMapIterator;;;Element of Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;unmodifiableMapIterator;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ";IteratorUtils;true;zippingIterator;(Iterator[]);;Element of ArrayElement of Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;zippingIterator;(Iterator,Iterator);;Element of Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;zippingIterator;(Iterator,Iterator);;Element of Argument[1];Element of ReturnValue;value",
          ";IteratorUtils;true;zippingIterator;(Iterator,Iterator,Iterator);;Element of Argument[0];Element of ReturnValue;value",
          ";IteratorUtils;true;zippingIterator;(Iterator,Iterator,Iterator);;Element of Argument[1];Element of ReturnValue;value",
          ";IteratorUtils;true;zippingIterator;(Iterator,Iterator,Iterator);;Element of Argument[2];Element of ReturnValue;value"
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
          ";IterableUtils;true;boundedIterable;;;Element of Argument[0];Element of ReturnValue;value",
          ";IterableUtils;true;chainedIterable;(Iterable[]);;Element of ArrayElement of Argument[0];Element of ReturnValue;value",
          ";IterableUtils;true;chainedIterable;(Iterable,Iterable);;Element of Argument[0];Element of ReturnValue;value",
          ";IterableUtils;true;chainedIterable;(Iterable,Iterable);;Element of Argument[1];Element of ReturnValue;value",
          ";IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable);;Element of Argument[0];Element of ReturnValue;value",
          ";IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable);;Element of Argument[1];Element of ReturnValue;value",
          ";IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable);;Element of Argument[2];Element of ReturnValue;value",
          ";IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable,Iterable);;Element of Argument[0];Element of ReturnValue;value",
          ";IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable,Iterable);;Element of Argument[1];Element of ReturnValue;value",
          ";IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable,Iterable);;Element of Argument[2];Element of ReturnValue;value",
          ";IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable,Iterable);;Element of Argument[3];Element of ReturnValue;value",
          ";IterableUtils;true;collatedIterable;(Comparator,Iterable,Iterable);;Element of Argument[1];Element of ReturnValue;value",
          ";IterableUtils;true;collatedIterable;(Comparator,Iterable,Iterable);;Element of Argument[2];Element of ReturnValue;value",
          ";IterableUtils;true;collatedIterable;(Iterable,Iterable);;Element of Argument[0];Element of ReturnValue;value",
          ";IterableUtils;true;collatedIterable;(Iterable,Iterable);;Element of Argument[1];Element of ReturnValue;value",
          ";IterableUtils;true;emptyIfNull;;;Argument[0];ReturnValue;value",
          ";IterableUtils;true;filteredIterable;;;Element of Argument[0];Element of ReturnValue;value",
          ";IterableUtils;true;find;;;Element of Argument[0];ReturnValue;value",
          ";IterableUtils;true;first;;;Element of Argument[0];ReturnValue;value",
          ";IterableUtils;true;forEachButLast;;;Element of Argument[0];ReturnValue;value",
          ";IterableUtils;true;get;;;Element of Argument[0];ReturnValue;value",
          ";IterableUtils;true;loopingIterable;;;Element of Argument[0];Element of ReturnValue;value",
          ";IterableUtils;true;partition;;;Element of Argument[0];Element of Element of ReturnValue;value",
          ";IterableUtils;true;reversedIterable;;;Element of Argument[0];Element of ReturnValue;value",
          ";IterableUtils;true;skippingIterable;;;Element of Argument[0];Element of ReturnValue;value",
          ";IterableUtils;true;toList;;;Element of Argument[0];Element of ReturnValue;value",
          ";IterableUtils;true;toString;;;Argument[2];ReturnValue;taint",
          ";IterableUtils;true;toString;;;Argument[3];ReturnValue;taint",
          ";IterableUtils;true;toString;;;Argument[4];ReturnValue;taint",
          ";IterableUtils;true;uniqueIterable;;;Element of Argument[0];Element of ReturnValue;value",
          ";IterableUtils;true;unmodifiableIterable;;;Element of Argument[0];Element of ReturnValue;value",
          ";IterableUtils;true;zippingIterable;;;Element of Argument[0];Element of ReturnValue;value",
          ";IterableUtils;true;zippingIterable;(Iterable,Iterable[]);;Element of ArrayElement of Argument[1];Element of ReturnValue;value",
          ";IterableUtils;true;zippingIterable;(Iterable,Iterable);;Element of Argument[1];Element of ReturnValue;value"
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
          ";EnumerationUtils;true;get;;;Element of Argument[0];ReturnValue;value",
          ";EnumerationUtils;true;toList;(Enumeration);;Element of Argument[0];Element of ReturnValue;value",
          ";EnumerationUtils;true;toList;(StringTokenizer);;Argument[0];Element of ReturnValue;taint"
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
          ";MultiMapUtils;true;getCollection;;;MapValue of Argument[0];ReturnValue;value",
          ";MultiMapUtils;true;getValuesAsBag;;;Element of MapValue of Argument[0];Element of ReturnValue;value",
          ";MultiMapUtils;true;getValuesAsList;;;Element of MapValue of Argument[0];Element of ReturnValue;value",
          ";MultiMapUtils;true;getValuesAsSet;;;Element of MapValue of Argument[0];Element of ReturnValue;value",
          ";MultiMapUtils;true;transformedMultiValuedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ";MultiMapUtils;true;transformedMultiValuedMap;;;Element of MapValue of Argument[0];Element of MapValue of ReturnValue;value",
          ";MultiMapUtils;true;unmodifiableMultiValuedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ";MultiMapUtils;true;unmodifiableMultiValuedMap;;;Element of MapValue of Argument[0];Element of MapValue of ReturnValue;value"
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
          ";MultiSetUtils;true;predicatedMultiSet;;;Element of Argument[0];Element of ReturnValue;value",
          ";MultiSetUtils;true;synchronizedMultiSet;;;Element of Argument[0];Element of ReturnValue;value",
          ";MultiSetUtils;true;unmodifiableMultiSet;;;Element of Argument[0];Element of ReturnValue;value"
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
          ";QueueUtils;true;predicatedQueue;;;Element of Argument[0];Element of ReturnValue;value",
          ";QueueUtils;true;synchronizedQueue;;;Element of Argument[0];Element of ReturnValue;value",
          ";QueueUtils;true;transformingQueue;;;Element of Argument[0];Element of ReturnValue;value",
          ";QueueUtils;true;unmodifiableQueue;;;Element of Argument[0];Element of ReturnValue;value"
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
          ";SetUtils$SetView;true;copyInto;;;Element of Argument[-1];Element of Argument[0];value",
          ";SetUtils$SetView;true;createIterator;;;Element of Argument[-1];Element of ReturnValue;value",
          ";SetUtils$SetView;true;toSet;;;Element of Argument[-1];Element of ReturnValue;value",
          ";SetUtils;true;difference;;;Element of Argument[0];Element of ReturnValue;value",
          ";SetUtils;true;disjunction;;;Element of Argument[0];Element of ReturnValue;value",
          ";SetUtils;true;disjunction;;;Element of Argument[1];Element of ReturnValue;value",
          ";SetUtils;true;emptyIfNull;;;Argument[0];ReturnValue;value",
          ";SetUtils;true;hashSet;;;ArrayElement of Argument[0];Element of ReturnValue;value",
          ";SetUtils;true;intersection;;;Element of Argument[0];Element of ReturnValue;value",
          ";SetUtils;true;intersection;;;Element of Argument[1];Element of ReturnValue;value",
          ";SetUtils;true;orderedSet;;;Element of Argument[0];Element of ReturnValue;value",
          ";SetUtils;true;predicatedNavigableSet;;;Element of Argument[0];Element of ReturnValue;value",
          ";SetUtils;true;predicatedSet;;;Element of Argument[0];Element of ReturnValue;value",
          ";SetUtils;true;predicatedSortedSet;;;Element of Argument[0];Element of ReturnValue;value",
          ";SetUtils;true;synchronizedSet;;;Element of Argument[0];Element of ReturnValue;value",
          ";SetUtils;true;synchronizedSortedSet;;;Element of Argument[0];Element of ReturnValue;value",
          ";SetUtils;true;transformedNavigableSet;;;Element of Argument[0];Element of ReturnValue;value",
          ";SetUtils;true;transformedSet;;;Element of Argument[0];Element of ReturnValue;value",
          ";SetUtils;true;transformedSortedSet;;;Element of Argument[0];Element of ReturnValue;value",
          ";SetUtils;true;union;;;Element of Argument[0];Element of ReturnValue;value",
          ";SetUtils;true;union;;;Element of Argument[1];Element of ReturnValue;value",
          ";SetUtils;true;unmodifiableNavigableSet;;;Element of Argument[0];Element of ReturnValue;value",
          ";SetUtils;true;unmodifiableSet;(Object[]);;ArrayElement of Argument[0];Element of ReturnValue;value",
          ";SetUtils;true;unmodifiableSet;(Set);;Element of Argument[0];Element of ReturnValue;value",
          ";SetUtils;true;unmodifiableSortedSet;;;Element of Argument[0];Element of ReturnValue;value"
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
          ";SplitMapUtils;true;readableMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ";SplitMapUtils;true;readableMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ";SplitMapUtils;true;writableMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ";SplitMapUtils;true;writableMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
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
          ";TrieUtils;true;unmodifiableTrie;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ";TrieUtils;true;unmodifiableTrie;;;MapValue of Argument[0];MapValue of ReturnValue;value"
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
          ";BagUtils;true;collectionBag;;;Element of Argument[0];Element of ReturnValue;value",
          ";BagUtils;true;predicatedBag;;;Element of Argument[0];Element of ReturnValue;value",
          ";BagUtils;true;predicatedSortedBag;;;Element of Argument[0];Element of ReturnValue;value",
          ";BagUtils;true;synchronizedBag;;;Element of Argument[0];Element of ReturnValue;value",
          ";BagUtils;true;synchronizedSortedBag;;;Element of Argument[0];Element of ReturnValue;value",
          ";BagUtils;true;transformingBag;;;Element of Argument[0];Element of ReturnValue;value",
          ";BagUtils;true;transformingSortedBag;;;Element of Argument[0];Element of ReturnValue;value",
          ";BagUtils;true;unmodifiableBag;;;Element of Argument[0];Element of ReturnValue;value",
          ";BagUtils;true;unmodifiableSortedBag;;;Element of Argument[0];Element of ReturnValue;value"
        ]
  }
}
