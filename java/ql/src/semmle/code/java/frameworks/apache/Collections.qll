/** Definitions related to the Apache Commons Collections library. */

import java
private import semmle.code.java.dataflow.FlowSteps
private import semmle.code.java.dataflow.ExternalFlow

/**
 * The method `isNotEmpty` in either `org.apache.commons.collections.CollectionUtils`
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
      [
        // Note that when lambdas are supported we should model things relating to Closure, Factory, Transformer, FluentIterable.forEach, FluentIterable.transform
        "org.apache.commons.collections4;ArrayStack;true;peek;;;Element of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4;ArrayStack;true;pop;;;Element of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4;ArrayStack;true;push;;;Argument[0];Element of Argument[-1];value",
        "org.apache.commons.collections4;Bag;true;add;;;Argument[0];Element of Argument[-1];value",
        "org.apache.commons.collections4;Bag;true;uniqueSet;;;Element of Argument[-1];Element of ReturnValue;value",
        "org.apache.commons.collections4;BidiMap;true;getKey;;;MapKey of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4;BidiMap;true;removeValue;;;MapKey of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4;BidiMap;true;inverseBidiMap;;;MapKey of Argument[-1];MapValue of ReturnValue;value",
        "org.apache.commons.collections4;BidiMap;true;inverseBidiMap;;;MapValue of Argument[-1];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;FluentIterable;true;append;(Object[]);;Element of Argument[-1];Element of ReturnValue;value",
        "org.apache.commons.collections4;FluentIterable;true;append;(Object[]);;ArrayElement of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;FluentIterable;true;append;(Iterable);;Element of Argument[-1];Element of ReturnValue;value",
        "org.apache.commons.collections4;FluentIterable;true;append;(Iterable);;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;FluentIterable;true;asEnumeration;;;Element of Argument[-1];Element of ReturnValue;value",
        "org.apache.commons.collections4;FluentIterable;true;collate;;;Element of Argument[-1];Element of ReturnValue;value",
        "org.apache.commons.collections4;FluentIterable;true;collate;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;FluentIterable;true;copyInto;;;Element of Argument[-1];Element of Argument[0];value",
        "org.apache.commons.collections4;FluentIterable;true;eval;;;Element of Argument[-1];Element of ReturnValue;value",
        "org.apache.commons.collections4;FluentIterable;true;filter;;;Element of Argument[-1];Element of ReturnValue;value",
        "org.apache.commons.collections4;FluentIterable;true;get;;;Element of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4;FluentIterable;true;limit;;;Element of Argument[-1];Element of ReturnValue;value",
        "org.apache.commons.collections4;FluentIterable;true;loop;;;Element of Argument[-1];Element of ReturnValue;value",
        "org.apache.commons.collections4;FluentIterable;true;of;(Iterable);;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;FluentIterable;true;of;(Object[]);;ArrayElement of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;FluentIterable;true;of;(Object);;Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;FluentIterable;true;reverse;;;Element of Argument[-1];Element of ReturnValue;value",
        "org.apache.commons.collections4;FluentIterable;true;skip;;;Element of Argument[-1];Element of ReturnValue;value",
        "org.apache.commons.collections4;FluentIterable;true;toArray;;;Element of Argument[-1];ArrayElement of ReturnValue;value",
        "org.apache.commons.collections4;FluentIterable;true;toList;;;Element of Argument[-1];Element of ReturnValue;value",
        "org.apache.commons.collections4;FluentIterable;true;toString;;;Element of Argument[-1];ReturnValue;taint",
        "org.apache.commons.collections4;FluentIterable;true;unique;;;Element of Argument[-1];Element of ReturnValue;value",
        "org.apache.commons.collections4;FluentIterable;true;unmodifiable;;;Element of Argument[-1];Element of ReturnValue;value",
        "org.apache.commons.collections4;FluentIterable;true;zip;(Iterable);;Element of Argument[-1];Element of ReturnValue;value",
        "org.apache.commons.collections4;FluentIterable;true;zip;(Iterable);;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;FluentIterable;true;zip;(Iterable);;Element of Argument[-1];Element of ReturnValue;value",
        "org.apache.commons.collections4;FluentIterable;true;zip;(Iterable[]);;Element of ArrayElement of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;Get;true;entrySet;;;MapKey of Argument[-1];MapKey of Element of ReturnValue;value",
        "org.apache.commons.collections4;Get;true;entrySet;;;MapValue of Argument[-1];MapValue of Element of ReturnValue;value",
        "org.apache.commons.collections4;Get;true;get;;;MapValue of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4;Get;true;keySet;();;MapKey of Argument[-1];Element of ReturnValue;value",
        "org.apache.commons.collections4;Get;true;values;();;MapValue of Argument[-1];Element of ReturnValue;value",
        "org.apache.commons.collections4;Get;true;remove;(Object);;MapValue of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4;IterableGet;true;mapIterator;;;MapKey of Argument[-1];Element of ReturnValue;value",
        "org.apache.commons.collections4;IterableGet;true;mapIterator;;;MapValue of Argument[-1];MapValue of ReturnValue;value",
        "org.apache.commons.collections4;KeyValue;true;getKey;;;MapKey of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4;KeyValue;true;getValue;;;MapValue of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4;MapIterator;true;getKey;;;Element of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4;MapIterator;true;getValue;;;MapValue of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4;MapIterator;true;next;;;Element of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4;MapIterator;true;setValue;;;MapValue of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4;MapIterator;true;setValue;;;Argument[0];MapValue of Argument[-1];value",
        "org.apache.commons.collections4;MultiMap;true;get;;;Element of MapValue of Argument[-1];Element of ReturnValue;value",
        "org.apache.commons.collections4;MultiMap;true;put;;;Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections4;MultiMap;true;put;;;Argument[1];Element of MapValue of Argument[-1];value",
        "org.apache.commons.collections4;MultiMap;true;values;;;Element of MapValue of Argument[-1];Element of ReturnValue;value",
        "org.apache.commons.collections4;MultiSet$Entry;true;getElement;;;Element of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4;MultiSet;true;add;;;Argument[0];Element of Argument[-1];value",
        "org.apache.commons.collections4;MultiSet;true;uniqueSet;;;Element of Argument[-1];Element of ReturnValue;value",
        "org.apache.commons.collections4;MultiSet;true;entrySet;;;Element of Argument[-1];Element of Element of ReturnValue;value",
        "org.apache.commons.collections4;MultiValuedMap;true;asMap;;;MapKey of Argument[-1];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;MultiValuedMap;true;asMap;;;Element of MapValue of Argument[-1];Element of MapValue of ReturnValue;value",
        "org.apache.commons.collections4;MultiValuedMap;true;get;;;Element of MapValue of Argument[-1];Element of ReturnValue;value",
        "org.apache.commons.collections4;MultiValuedMap;true;keys;;;MapKey of Argument[-1];Element of ReturnValue;value",
        "org.apache.commons.collections4;MultiValuedMap;true;keySet;;;MapKey of Argument[-1];Element of ReturnValue;value",
        "org.apache.commons.collections4;MultiValuedMap;true;mapIterator;;;MapKey of Argument[-1];Element of ReturnValue;value",
        "org.apache.commons.collections4;MultiValuedMap;true;mapIterator;;;Element of MapValue of Argument[-1];MapValue of ReturnValue;value",
        "org.apache.commons.collections4;MultiValuedMap;true;put;;;Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections4;MultiValuedMap;true;put;;;Argument[1];Element of MapValue of Argument[-1];value",
        "org.apache.commons.collections4;MultiValuedMap;true;putAll;(Object,Iterable);;Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections4;MultiValuedMap;true;putAll;(Object,Iterable);;Element of Argument[1];Element of MapValue of Argument[-1];value",
        "org.apache.commons.collections4;MultiValuedMap;true;putAll;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections4;MultiValuedMap;true;putAll;(Map);;MapValue of Argument[0];Element of MapValue of Argument[-1];value",
        "org.apache.commons.collections4;MultiValuedMap;true;putAll;(MultiValuedMap);;MapKey of Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections4;MultiValuedMap;true;putAll;(MultiValuedMap);;Element of MapValue of Argument[0];Element of MapValue of Argument[-1];value",
        "org.apache.commons.collections4;MultiValuedMap;true;values;;;Element of MapValue of Argument[-1];Element of ReturnValue;value",
        "org.apache.commons.collections4;OrderedIterator;true;previous;;;Element of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4;OrderedMap;true;firstKey;;;MapKey of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4;OrderedMap;true;lastKey;;;MapKey of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4;OrderedMap;true;nextKey;;;MapKey of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4;OrderedMap;true;previousKey;;;MapKey of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4;Put;true;put;;;MapValue of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4;Put;true;put;;;Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections4;Put;true;put;;;Argument[1];MapValue of Argument[-1];value",
        "org.apache.commons.collections4;Put;true;putAll;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections4;Put;true;putAll;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value",
        "org.apache.commons.collections4;SortedBag;true;first;;;Element of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4;SortedBag;true;last;;;Element of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4;Trie;true;prefixMap;;;MapKey of Argument[-1];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;Trie;true;prefixMap;;;MapValue of Argument[-1];MapValue of ReturnValue;value",
        "org.apache.commons.collections;KeyValue;true;getKey;;;MapKey of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections;KeyValue;true;getValue;;;MapValue of Argument[-1];ReturnValue;value"
      ]
  }
}

/**
 * Value-propagating models for classes in the package `org.apache.commons.collections4.keyvalue`.
 */
private class ApacheKeyValueModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.apache.commons.collections4.keyvalue;AbstractKeyValue;true;AbstractKeyValue;;;Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;AbstractKeyValue;true;AbstractKeyValue;;;Argument[1];MapValue of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;AbstractKeyValue;true;setKey;;;MapValue of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4.keyvalue;AbstractKeyValue;true;setKey;;;Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;AbstractKeyValue;true;setValue;;;MapValue of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4.keyvalue;AbstractKeyValue;true;setValue;;;Argument[0];MapValue of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;AbstractKeyValue;true;toString;;;MapKey of Argument[-1];ReturnValue;taint",
        "org.apache.commons.collections4.keyvalue;AbstractKeyValue;true;toString;;;MapValue of Argument[-1];ReturnValue;taint",
        "org.apache.commons.collections4.keyvalue;AbstractMapEntry;true;AbstractMapEntry;;;Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;AbstractMapEntry;true;AbstractMapEntry;;;Argument[1];MapValue of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;AbstractMapEntryDecorator;true;AbstractMapEntryDecorator;;;MapKey of Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;AbstractMapEntryDecorator;true;AbstractMapEntryDecorator;;;MapValue of Argument[0];MapValue of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;AbstractMapEntryDecorator;true;getMapEntry;;;MapKey of Argument[-1];MapKey of ReturnValue;value",
        "org.apache.commons.collections4.keyvalue;AbstractMapEntryDecorator;true;getMapEntry;;;MapValue of Argument[-1];MapValue of ReturnValue;value",
        "org.apache.commons.collections4.keyvalue;AbstractMapEntryDecorator;true;toString;;;MapKey of Argument[-1];ReturnValue;taint",
        "org.apache.commons.collections4.keyvalue;AbstractMapEntryDecorator;true;toString;;;MapValue of Argument[-1];ReturnValue;taint",
        "org.apache.commons.collections4.keyvalue;DefaultKeyValue;true;DefaultKeyValue;(Object,Object);;Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;DefaultKeyValue;true;DefaultKeyValue;(Object,Object);;Argument[1];MapValue of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;DefaultKeyValue;true;DefaultKeyValue;(KeyValue);;MapKey of Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;DefaultKeyValue;true;DefaultKeyValue;(KeyValue);;MapValue of Argument[0];MapValue of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;DefaultKeyValue;true;DefaultKeyValue;(Entry);;MapKey of Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;DefaultKeyValue;true;DefaultKeyValue;(Entry);;MapValue of Argument[0];MapValue of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;DefaultKeyValue;true;toMapEntry;;;MapKey of Argument[-1];MapKey of ReturnValue;value",
        "org.apache.commons.collections4.keyvalue;DefaultKeyValue;true;toMapEntry;;;MapValue of Argument[-1];MapValue of ReturnValue;value",
        "org.apache.commons.collections4.keyvalue;DefaultMapEntry;true;DefaultMapEntry;(Object,Object);;Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;DefaultMapEntry;true;DefaultMapEntry;(Object,Object);;Argument[1];MapValue of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;DefaultMapEntry;true;DefaultMapEntry;(KeyValue);;MapKey of Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;DefaultMapEntry;true;DefaultMapEntry;(KeyValue);;MapValue of Argument[0];MapValue of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;DefaultMapEntry;true;DefaultMapEntry;(Entry);;MapKey of Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;DefaultMapEntry;true;DefaultMapEntry;(Entry);;MapValue of Argument[0];MapValue of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;TiedMapEntry;true;TiedMapEntry;;;MapValue of Argument[0];MapValue of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;TiedMapEntry;true;TiedMapEntry;;;Argument[1];MapKey of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(Object,Object);;Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(Object,Object);;Argument[1];MapValue of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(KeyValue);;MapKey of Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(KeyValue);;MapValue of Argument[0];MapValue of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(Entry);;MapKey of Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(Entry);;MapValue of Argument[0];MapValue of Argument[-1];value",
        "org.apache.commons.collections.keyvalue;AbstractKeyValue;true;AbstractKeyValue;;;Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections.keyvalue;AbstractKeyValue;true;AbstractKeyValue;;;Argument[1];MapValue of Argument[-1];value",
        "org.apache.commons.collections.keyvalue;AbstractKeyValue;true;setKey;;;MapValue of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections.keyvalue;AbstractKeyValue;true;setKey;;;Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections.keyvalue;AbstractKeyValue;true;setValue;;;MapValue of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections.keyvalue;AbstractKeyValue;true;setValue;;;Argument[0];MapValue of Argument[-1];value",
        "org.apache.commons.collections.keyvalue;AbstractKeyValue;true;toString;;;MapKey of Argument[-1];ReturnValue;taint",
        "org.apache.commons.collections.keyvalue;AbstractKeyValue;true;toString;;;MapValue of Argument[-1];ReturnValue;taint",
        "org.apache.commons.collections.keyvalue;AbstractMapEntry;true;AbstractMapEntry;;;Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections.keyvalue;AbstractMapEntry;true;AbstractMapEntry;;;Argument[1];MapValue of Argument[-1];value",
        "org.apache.commons.collections.keyvalue;AbstractMapEntryDecorator;true;AbstractMapEntryDecorator;;;MapKey of Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections.keyvalue;AbstractMapEntryDecorator;true;AbstractMapEntryDecorator;;;MapValue of Argument[0];MapValue of Argument[-1];value",
        "org.apache.commons.collections.keyvalue;AbstractMapEntryDecorator;true;getMapEntry;;;MapKey of Argument[-1];MapKey of ReturnValue;value",
        "org.apache.commons.collections.keyvalue;AbstractMapEntryDecorator;true;getMapEntry;;;MapValue of Argument[-1];MapValue of ReturnValue;value",
        "org.apache.commons.collections.keyvalue;AbstractMapEntryDecorator;true;toString;;;MapKey of Argument[-1];ReturnValue;taint",
        "org.apache.commons.collections.keyvalue;AbstractMapEntryDecorator;true;toString;;;MapValue of Argument[-1];ReturnValue;taint",
        "org.apache.commons.collections.keyvalue;DefaultKeyValue;true;DefaultKeyValue;(Object,Object);;Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections.keyvalue;DefaultKeyValue;true;DefaultKeyValue;(Object,Object);;Argument[1];MapValue of Argument[-1];value",
        "org.apache.commons.collections.keyvalue;DefaultKeyValue;true;DefaultKeyValue;(KeyValue);;MapKey of Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections.keyvalue;DefaultKeyValue;true;DefaultKeyValue;(KeyValue);;MapValue of Argument[0];MapValue of Argument[-1];value",
        "org.apache.commons.collections.keyvalue;DefaultKeyValue;true;DefaultKeyValue;(Entry);;MapKey of Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections.keyvalue;DefaultKeyValue;true;DefaultKeyValue;(Entry);;MapValue of Argument[0];MapValue of Argument[-1];value",
        "org.apache.commons.collections.keyvalue;DefaultKeyValue;true;toMapEntry;;;MapKey of Argument[-1];MapKey of ReturnValue;value",
        "org.apache.commons.collections.keyvalue;DefaultKeyValue;true;toMapEntry;;;MapValue of Argument[-1];MapValue of ReturnValue;value",
        "org.apache.commons.collections.keyvalue;DefaultMapEntry;true;DefaultMapEntry;(Object,Object);;Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections.keyvalue;DefaultMapEntry;true;DefaultMapEntry;(Object,Object);;Argument[1];MapValue of Argument[-1];value",
        "org.apache.commons.collections.keyvalue;DefaultMapEntry;true;DefaultMapEntry;(KeyValue);;MapKey of Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections.keyvalue;DefaultMapEntry;true;DefaultMapEntry;(KeyValue);;MapValue of Argument[0];MapValue of Argument[-1];value",
        "org.apache.commons.collections.keyvalue;DefaultMapEntry;true;DefaultMapEntry;(Entry);;MapKey of Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections.keyvalue;DefaultMapEntry;true;DefaultMapEntry;(Entry);;MapValue of Argument[0];MapValue of Argument[-1];value",
        "org.apache.commons.collections.keyvalue;TiedMapEntry;true;TiedMapEntry;;;MapValue of Argument[0];MapValue of Argument[-1];value",
        "org.apache.commons.collections.keyvalue;TiedMapEntry;true;TiedMapEntry;;;Argument[1];MapKey of Argument[-1];value",
        "org.apache.commons.collections.keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(Object,Object);;Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections.keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(Object,Object);;Argument[1];MapValue of Argument[-1];value",
        "org.apache.commons.collections.keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(KeyValue);;MapKey of Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections.keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(KeyValue);;MapValue of Argument[0];MapValue of Argument[-1];value",
        "org.apache.commons.collections.keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(Entry);;MapKey of Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections.keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(Entry);;MapValue of Argument[0];MapValue of Argument[-1];value"
      ]
  }
}

/**
 * Value-propagating models for the class `org.apache.commons.collections4.MapUtils`.
 */
private class ApacheMapUtilsModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        // Note that when lambdas are supported we should have more models for populateMap
        "org.apache.commons.collections4;MapUtils;true;emptyIfNull;;;Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;fixedSizeMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;fixedSizeMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;fixedSizeSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;fixedSizeSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;getMap;;;MapValue of Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;getMap;;;Argument[2];ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;getObject;;;MapValue of Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;getObject;;;Argument[2];ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;getString;;;MapValue of Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;getString;;;Argument[2];ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;invertMap;;;MapKey of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;invertMap;;;MapValue of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;iterableMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;iterableMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;iterableSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;iterableSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;lazyMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;lazyMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;lazySortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;lazySortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;multiValueMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;multiValueMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;orderedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;orderedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;populateMap;(Map,Iterable,Transformer);;Element of Argument[1];MapValue of Argument[0];value",
        "org.apache.commons.collections4;MapUtils;true;populateMap;(MultiMap,Iterable,Transformer);;Element of Argument[1];MapValue of Argument[0];value",
        "org.apache.commons.collections4;MapUtils;true;predicatedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;predicatedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;predicatedSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;predicatedSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;putAll;;;ArrayElement of Argument[1];MapKey of Argument[0];value",
        "org.apache.commons.collections4;MapUtils;true;putAll;;;ArrayElement of Argument[1];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;putAll;;;ArrayElement of Argument[1];MapValue of Argument[0];value",
        "org.apache.commons.collections4;MapUtils;true;putAll;;;ArrayElement of Argument[1];MapValue of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;putAll;;;ArrayElement of ArrayElement of Argument[1];MapKey of Argument[0];value",
        "org.apache.commons.collections4;MapUtils;true;putAll;;;ArrayElement of ArrayElement of Argument[1];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;putAll;;;ArrayElement of ArrayElement of Argument[1];MapValue of Argument[0];value",
        "org.apache.commons.collections4;MapUtils;true;putAll;;;ArrayElement of ArrayElement of Argument[1];MapValue of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;putAll;;;MapKey of ArrayElement of Argument[1];MapKey of Argument[0];value",
        "org.apache.commons.collections4;MapUtils;true;putAll;;;MapKey of ArrayElement of Argument[1];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;putAll;;;MapValue of ArrayElement of Argument[1];MapValue of Argument[0];value",
        "org.apache.commons.collections4;MapUtils;true;putAll;;;MapValue of ArrayElement of Argument[1];MapValue of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;safeAddToMap;;;Argument[1];MapKey of Argument[0];value",
        "org.apache.commons.collections4;MapUtils;true;safeAddToMap;;;Argument[2];MapValue of Argument[0];value",
        "org.apache.commons.collections4;MapUtils;true;synchronizedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;synchronizedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;synchronizedSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;synchronizedSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;toMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;toMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;transformedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;transformedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;transformedSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;transformedSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;unmodifiableMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;unmodifiableMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;unmodifiableSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;unmodifiableSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;emptyIfNull;;;Argument[0];ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;fixedSizeMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;fixedSizeMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;fixedSizeSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;fixedSizeSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;getMap;;;MapValue of Argument[0];ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;getMap;;;Argument[2];ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;getObject;;;MapValue of Argument[0];ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;getObject;;;Argument[2];ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;getString;;;MapValue of Argument[0];ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;getString;;;Argument[2];ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;invertMap;;;MapKey of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;invertMap;;;MapValue of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;iterableMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;iterableMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;iterableSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;iterableSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;lazyMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;lazyMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;lazySortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;lazySortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;multiValueMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;multiValueMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;orderedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;orderedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;populateMap;(Map,Iterable,Transformer);;Element of Argument[1];MapValue of Argument[0];value",
        "org.apache.commons.collections;MapUtils;true;populateMap;(MultiMap,Iterable,Transformer);;Element of Argument[1];MapValue of Argument[0];value",
        "org.apache.commons.collections;MapUtils;true;predicatedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;predicatedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;predicatedSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;predicatedSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;putAll;;;ArrayElement of Argument[1];MapKey of Argument[0];value",
        "org.apache.commons.collections;MapUtils;true;putAll;;;ArrayElement of Argument[1];MapKey of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;putAll;;;ArrayElement of Argument[1];MapValue of Argument[0];value",
        "org.apache.commons.collections;MapUtils;true;putAll;;;ArrayElement of Argument[1];MapValue of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;putAll;;;ArrayElement of ArrayElement of Argument[1];MapKey of Argument[0];value",
        "org.apache.commons.collections;MapUtils;true;putAll;;;ArrayElement of ArrayElement of Argument[1];MapKey of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;putAll;;;ArrayElement of ArrayElement of Argument[1];MapValue of Argument[0];value",
        "org.apache.commons.collections;MapUtils;true;putAll;;;ArrayElement of ArrayElement of Argument[1];MapValue of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;putAll;;;MapKey of ArrayElement of Argument[1];MapKey of Argument[0];value",
        "org.apache.commons.collections;MapUtils;true;putAll;;;MapKey of ArrayElement of Argument[1];MapKey of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;putAll;;;MapValue of ArrayElement of Argument[1];MapValue of Argument[0];value",
        "org.apache.commons.collections;MapUtils;true;putAll;;;MapValue of ArrayElement of Argument[1];MapValue of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;safeAddToMap;;;Argument[1];MapKey of Argument[0];value",
        "org.apache.commons.collections;MapUtils;true;safeAddToMap;;;Argument[2];MapValue of Argument[0];value",
        "org.apache.commons.collections;MapUtils;true;synchronizedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;synchronizedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;synchronizedSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;synchronizedSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;toMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;toMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;transformedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;transformedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;transformedSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;transformedSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;unmodifiableMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;unmodifiableMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;unmodifiableSortedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections;MapUtils;true;unmodifiableSortedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
      ]
  }
}

/**
 * Value-propagating models for the class `org.apache.commons.collections4.CollectionUtils`.
 */
private class ApacheCollectionUtilsModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        // Note that when lambdas are supported we should have a model for collect, forAllButLastDo, forAllDo, transform
        "org.apache.commons.collections4;CollectionUtils;true;addAll;(Collection,Object[]);;ArrayElement of Argument[1];Element of Argument[0];value",
        "org.apache.commons.collections4;CollectionUtils;true;addAll;(Collection,Enumeration);;Element of Argument[1];Element of Argument[0];value",
        "org.apache.commons.collections4;CollectionUtils;true;addAll;(Collection,Iterable);;Element of Argument[1];Element of Argument[0];value",
        "org.apache.commons.collections4;CollectionUtils;true;addAll;(Collection,Iterator);;Element of Argument[1];Element of Argument[0];value",
        "org.apache.commons.collections4;CollectionUtils;true;addIgnoreNull;;;Argument[1];Element of Argument[0];value",
        "org.apache.commons.collections4;CollectionUtils;true;collate;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;CollectionUtils;true;collate;;;Element of Argument[1];Element of ReturnValue;value",
        "org.apache.commons.collections4;CollectionUtils;true;disjunction;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;CollectionUtils;true;disjunction;;;Element of Argument[1];Element of ReturnValue;value",
        "org.apache.commons.collections4;CollectionUtils;true;emptyIfNull;;;Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;CollectionUtils;true;extractSingleton;;;Element of Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;CollectionUtils;true;find;;;Element of Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;CollectionUtils;true;get;(Iterator,int);;Element of Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;CollectionUtils;true;get;(Map,int);;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;CollectionUtils;true;get;(Map,int);;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections4;CollectionUtils;true;get;(Object,int);;ArrayElement of Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;CollectionUtils;true;get;(Object,int);;Element of Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;CollectionUtils;true;get;(Object,int);;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;CollectionUtils;true;get;(Object,int);;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections4;CollectionUtils;true;getCardinalityMap;;;Element of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;CollectionUtils;true;intersection;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;CollectionUtils;true;intersection;;;Element of Argument[1];Element of ReturnValue;value",
        "org.apache.commons.collections4;CollectionUtils;true;permutations;;;Element of Argument[0];Element of Element of ReturnValue;value",
        "org.apache.commons.collections4;CollectionUtils;true;predicatedCollection;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;CollectionUtils;true;removeAll;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;CollectionUtils;true;retainAll;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;CollectionUtils;true;select;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;CollectionUtils;true;select;;;Element of Argument[0];Element of Argument[2];value",
        "org.apache.commons.collections4;CollectionUtils;true;select;;;Element of Argument[0];Element of Argument[3];value",
        "org.apache.commons.collections4;CollectionUtils;true;selectRejected;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;CollectionUtils;true;selectRejected;;;Element of Argument[0];Element of Argument[2];value",
        "org.apache.commons.collections4;CollectionUtils;true;subtract;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;CollectionUtils;true;synchronizedCollection;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;CollectionUtils;true;transformingCollection;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;CollectionUtils;true;union;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;CollectionUtils;true;union;;;Element of Argument[1];Element of ReturnValue;value",
        "org.apache.commons.collections4;CollectionUtils;true;unmodifiableCollection;;;Element of Argument[0];Element of ReturnValue;value"
      ]
  }
}

/**
 * Value-propagating models for the class `org.apache.commons.collections4.ListUtils`.
 */
private class ApacheListUtilsModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.apache.commons.collections4;ListUtils;true;defaultIfNull;;;Argument[1];ReturnValue;value",
        "org.apache.commons.collections4;ListUtils;true;emptyIfNull;;;Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;ListUtils;true;fixedSizeList;;;Element of Argument[1];Element of ReturnValue;value",
        "org.apache.commons.collections4;ListUtils;true;intersection;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;ListUtils;true;intersection;;;Element of Argument[1];Element of ReturnValue;value",
        "org.apache.commons.collections4;ListUtils;true;lazyList;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;ListUtils;true;longestCommonSubsequence;(CharSequence,CharSequence);;Argument[0];ReturnValue;taint",
        "org.apache.commons.collections4;ListUtils;true;longestCommonSubsequence;(CharSequence,CharSequence);;Argument[1];ReturnValue;taint",
        "org.apache.commons.collections4;ListUtils;true;longestCommonSubsequence;(List,List);;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;ListUtils;true;longestCommonSubsequence;(List,List);;Element of Argument[1];Element of ReturnValue;value",
        "org.apache.commons.collections4;ListUtils;true;longestCommonSubsequence;(List,List,Equator);;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;ListUtils;true;longestCommonSubsequence;(List,List,Equator);;Element of Argument[1];Element of ReturnValue;value",
        "org.apache.commons.collections4;ListUtils;true;partition;;;Element of Argument[0];Element of Element of ReturnValue;value",
        "org.apache.commons.collections4;ListUtils;true;predicatedList;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;ListUtils;true;removeAll;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;ListUtils;true;retainAll;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;ListUtils;true;select;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;ListUtils;true;selectRejected;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;ListUtils;true;subtract;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;ListUtils;true;sum;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;ListUtils;true;sum;;;Element of Argument[1];Element of ReturnValue;value",
        "org.apache.commons.collections4;ListUtils;true;synchronizedList;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;ListUtils;true;transformedList;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;ListUtils;true;union;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;ListUtils;true;union;;;Element of Argument[1];Element of ReturnValue;value",
        "org.apache.commons.collections4;ListUtils;true;unmodifiableList;;;Element of Argument[0];Element of ReturnValue;value"
      ]
  }
}

/**
 * Value-propagating models for the class `org.apache.commons.collections4.IteratorUtils`.
 */
private class ApacheIteratorUtilsModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        // Note that when lambdas are supported we should have a model for forEach, forEachButLast, transformedIterator
        "org.apache.commons.collections4;IteratorUtils;true;arrayIterator;;;ArrayElement of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;arrayListIterator;;;ArrayElement of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;asEnumeration;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;asIterable;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;asIterator;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;asMultipleUseIterable;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;boundedIterator;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;chainedIterator;(Collection);;Element of Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;chainedIterator;(Iterator,Iterator);;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;chainedIterator;(Iterator,Iterator);;Element of Argument[1];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;collatedIterator;(Comparator,Collection);;Element of Element of Argument[1];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;collatedIterator;(Comparator,Iterator[]);;Element of Argument[1];Element of Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;collatedIterator;(Comparator,Iterator,Iterator);;Element of Argument[1];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;collatedIterator;(Comparator,Iterator,Iterator);;Element of Argument[2];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;filteredIterator;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;filteredListIterator;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;find;;;Element of Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;first;;;Element of Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;get;;;Element of Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;getIterator;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;getIterator;;;ArrayElement of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;getIterator;;;Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;getIterator;;;MapValue of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;loopingIterator;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;loopingListIterator;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;peekingIterator;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;pushbackIterator;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;singletonIterator;;;Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;singletonListIterator;;;Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;skippingIterator;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;toArray;;;Element of Argument[0];ArrayElement of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;toList;;;Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;toListIterator;;;Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;toString;;;Element of Argument[0];ReturnValue;taint",
        "org.apache.commons.collections4;IteratorUtils;true;unmodifiableIterator;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;unmodifiableListIterator;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;unmodifiableMapIterator;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;unmodifiableMapIterator;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;zippingIterator;(Iterator[]);;Element of Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;zippingIterator;(Iterator,Iterator);;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;zippingIterator;(Iterator,Iterator);;Element of Argument[1];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;zippingIterator;(Iterator,Iterator,Iterator);;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;zippingIterator;(Iterator,Iterator,Iterator);;Element of Argument[1];Element of ReturnValue;value",
        "org.apache.commons.collections4;IteratorUtils;true;zippingIterator;(Iterator,Iterator,Iterator);;Element of Argument[2];Element of ReturnValue;value"
      ]
  }
}

/**
 * Value-propagating models for the class `org.apache.commons.collections4.IterableUtils`.
 */
private class ApacheIterableUtilsModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        // Note that when lambdas are supported we should have a model for forEach, forEachButLast, transformedIterable
        "org.apache.commons.collections4;IterableUtils;true;boundedIterable;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IterableUtils;true;chainedIterable;(Iterable[]);;Element of Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IterableUtils;true;chainedIterable;(Iterable,Iterable);;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IterableUtils;true;chainedIterable;(Iterable,Iterable);;Element of Argument[1];Element of ReturnValue;value",
        "org.apache.commons.collections4;IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable);;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable);;Element of Argument[1];Element of ReturnValue;value",
        "org.apache.commons.collections4;IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable);;Element of Argument[2];Element of ReturnValue;value",
        "org.apache.commons.collections4;IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable,Iterable);;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable,Iterable);;Element of Argument[1];Element of ReturnValue;value",
        "org.apache.commons.collections4;IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable,Iterable);;Element of Argument[2];Element of ReturnValue;value",
        "org.apache.commons.collections4;IterableUtils;true;chainedIterable;(Iterable,Iterable,Iterable,Iterable);;Element of Argument[3];Element of ReturnValue;value",
        "org.apache.commons.collections4;IterableUtils;true;collatedIterable;(Comparator,Iterable,Iterable);;Element of Argument[1];Element of ReturnValue;value",
        "org.apache.commons.collections4;IterableUtils;true;collatedIterable;(Comparator,Iterable,Iterable);;Element of Argument[2];Element of ReturnValue;value",
        "org.apache.commons.collections4;IterableUtils;true;collatedIterable;(Iterable,Iterable);;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IterableUtils;true;collatedIterable;(Iterable,Iterable);;Element of Argument[1];Element of ReturnValue;value",
        "org.apache.commons.collections4;IterableUtils;true;emptyIfNull;;;Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;IterableUtils;true;filteredIterable;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IterableUtils;true;find;;;Element of Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;IterableUtils;true;first;;;Element of Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;IterableUtils;true;get;;;Element of Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;IterableUtils;true;loopingIterable;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IterableUtils;true;partition;;;Element of Argument[0];Element of Element of ReturnValue;value",
        "org.apache.commons.collections4;IterableUtils;true;reversedIterable;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IterableUtils;true;skippingIterable;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IterableUtils;true;toList;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IterableUtils;true;toString;;;Element of Argument[0];ReturnValue;taint",
        "org.apache.commons.collections4;IterableUtils;true;uniqueIterable;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IterableUtils;true;unmodifiableIterable;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IterableUtils;true;zippingIterable;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;IterableUtils;true;zippingIterable;(Iterable,Iterable[]);;Element of Element of Argument[1];Element of ReturnValue;value",
        "org.apache.commons.collections4;IterableUtils;true;zippingIterable;(Iterable,Iterable);;Element of Argument[1];Element of ReturnValue;value"
      ]
  }
}

/**
 * Value-propagating models for the class `org.apache.commons.collections4.EnumerationUtils`.
 */
private class ApacheEnumerationUtilsModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.apache.commons.collections4;EnumerationUtils;true;get;;;Element of Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;EnumerationUtils;true;toList;(Enumeration);;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;EnumerationUtils;true;toList;(StringTokenizer);;Argument[0];Element of ReturnValue;taint"
      ]
  }
}

/**
 * Value-propagating models for the class `org.apache.commons.collections4.MultiMapUtils`.
 */
private class ApacheMultiMapUtilsModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.apache.commons.collections4;MultiMapUtils;true;emptyIfNull;;;Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;MultiMapUtils;true;getCollection;;;MapValue of Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;MultiMapUtils;true;getValuesAsBag;;;MapValue of Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;MultiMapUtils;true;getValuesAsList;;;MapValue of Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;MultiMapUtils;true;getValuesAsSet;;;MapValue of Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;MultiMapUtils;true;transformedMultiValuedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;MultiMapUtils;true;transformedMultiValuedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections4;MultiMapUtils;true;unmodifiableMultiValuedMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;MultiMapUtils;true;unmodifiableMultiValuedMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
      ]
  }
}

/**
 * Value-propagating models for the class `org.apache.commons.collections4.MultiSetUtils`.
 */
private class ApacheMultiSetUtilsModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.apache.commons.collections4;MultiSetUtils;true;predicatedMultiSet;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;MultiSetUtils;true;synchronizedMultiSet;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;MultiSetUtils;true;unmodifiableMultiSet;;;Element of Argument[0];Element of ReturnValue;value"
      ]
  }
}

/**
 * Value-propagating models for the class `org.apache.commons.collections4.QueueUtils`.
 */
private class ApacheQueueUtilsModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.apache.commons.collections4;QueueUtils;true;predicatedQueue;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;QueueUtils;true;synchronizedQueue;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;QueueUtils;true;transformingQueue;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;QueueUtils;true;unmodifiableQueue;;;Element of Argument[0];Element of ReturnValue;value"
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
      [
        "org.apache.commons.collections4;SetUtils$SetView;true;copyInto;;;Element of Argument[-1];Element of Argument[0];value",
        "org.apache.commons.collections4;SetUtils$SetView;true;createIterator;;;Element of Argument[-1];Element of ReturnValue;value",
        "org.apache.commons.collections4;SetUtils$SetView;true;toSet;;;Element of Argument[-1];Element of Argument[0];value",
        "org.apache.commons.collections4;SetUtils;true;difference;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;SetUtils;true;difference;;;Element of Argument[1];Element of ReturnValue;value",
        "org.apache.commons.collections4;SetUtils;true;emptyIfNull;;;Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;SetUtils;true;hashSet;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;SetUtils;true;intersection;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;SetUtils;true;intersection;;;Element of Argument[1];Element of ReturnValue;value",
        "org.apache.commons.collections4;SetUtils;true;orderedSet;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;SetUtils;true;predicatedNavigableSet;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;SetUtils;true;predicatedSet;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;SetUtils;true;predicatedSortedSet;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;SetUtils;true;synchronizedSet;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;SetUtils;true;synchronizedSortedSet;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;SetUtils;true;transformedNavigableSet;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;SetUtils;true;transformedSet;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;SetUtils;true;transformedSortedSet;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;SetUtils;true;union;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;SetUtils;true;union;;;Element of Argument[1];Element of ReturnValue;value",
        "org.apache.commons.collections4;SetUtils;true;unmodifiableNavigableSet;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;SetUtils;true;unmodifiableSet;(Object[]);;ArrayElement of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;SetUtils;true;unmodifiableSet;(Set);;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;SetUtils;true;unmodifiableSortedSet;;;Element of Argument[0];Element of ReturnValue;value"
      ]
  }
}

/**
 * Value-propagating models for the class `org.apache.commons.collections4.SplitMapUtils`.
 */
private class ApacheSplitMapUtilsModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.apache.commons.collections4;SplitMapUtils;true;readableMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;SplitMapUtils;true;readableMap;;;MapValue of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections4;SplitMapUtils;true;writableMap;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;SplitMapUtils;true;writableMap;;;MapValue of Argument[0];MapValue of ReturnValue;value"
      ]
  }
}

/**
 * Value-propagating models for the class `org.apache.commons.collections4.TrieUtils`.
 */
private class ApacheTrieUtilsModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.apache.commons.collections4;TrieUtils;true;unmodifiableTrie;;;MapKey of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;TrieUtils;true;unmodifiableTrie;;;MapValue of Argument[0];MapValue of ReturnValue;value"
      ]
  }
}

/**
 * Value-propagating models for the class `org.apache.commons.collections4.BagUtils`.
 */
private class ApacheBagUtilsModel extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "org.apache.commons.collections4;BagUtils;true;collectionBag;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;BagUtils;true;predicatedBag;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;BagUtils;true;predicatedSortedBag;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;BagUtils;true;synchronizedBag;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;BagUtils;true;synchronizedSortedBag;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;BagUtils;true;transformingBag;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;BagUtils;true;transformingSortedBag;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;BagUtils;true;unmodifiableBag;;;Element of Argument[0];Element of ReturnValue;value",
        "org.apache.commons.collections4;BagUtils;true;unmodifiableSortedBag;;;Element of Argument[0];Element of ReturnValue;value"
      ]
  }
}
