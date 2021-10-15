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
          ";MapUtils;true;populateMap;(MultiMap,Iterable,Transformer);;Element of Argument[1];MapValue of Argument[0];value",
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
          ";MultiMapUtils;true;transformedMultiValuedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
          ";MultiMapUtils;true;unmodifiableMultiValuedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
          ";MultiMapUtils;true;unmodifiableMultiValuedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
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
