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
        "org.apache.commons.collections4;KeyValue;true;getKey;;;MapKey of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4;KeyValue;true;getValue;;;MapValue of Argument[-1];ReturnValue;value",
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
        // Note that when lambdas are supported we should have more models for populateMap
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
        // Note that when lambdas are supported we should have more models for populateMap
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
