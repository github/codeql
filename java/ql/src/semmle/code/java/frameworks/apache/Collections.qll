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
        "org.apache.commons.collections4;KeyValue;true;getValue;;;MapValue of Argument[-1];ReturnValue;value"
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
        "org.apache.commons.collections4.keyvalue;AbstractKeyValue;true;toString;;;MapKey of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4.keyvalue;AbstractKeyValue;true;toString;;;MapValue of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4.keyvalue;AbstractMapEntry;true;AbstractMapEntry;;;Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;AbstractMapEntry;true;AbstractMapEntry;;;Argument[1];MapValue of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;AbstractMapEntryDecorator;true;AbstractMapEntryDecorator;;;Argument[0];Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;AbstractMapEntryDecorator;true;getMapEntry;;;Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4.keyvalue;AbstractMapEntryDecorator;true;toString;;;MapKey of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4.keyvalue;AbstractMapEntryDecorator;true;toString;;;MapValue of Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4.keyvalue;DefaultKeyValue;true;DefaultKeyValue;(Object,Object);;Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;DefaultKeyValue;true;DefaultKeyValue;(Object,Object);;Argument[1];MapValue of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;DefaultKeyValue;true;DefaultKeyValue;(KeyValue);;Argument[0];Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;DefaultKeyValue;true;DefaultKeyValue;(Entry);;Argument[0];Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;DefaultKeyValue;true;toMapEntry;;;Argument[-1];ReturnValue;value",
        "org.apache.commons.collections4.keyvalue;DefaultMapEntry;true;DefaultMapEntry;(Object,Object);;Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;DefaultMapEntry;true;DefaultMapEntry;(Object,Object);;Argument[1];MapValue of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;DefaultMapEntry;true;DefaultMapEntry;(KeyValue);;Argument[0];Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;DefaultMapEntry;true;DefaultMapEntry;(Entry);;Argument[0];Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;TiedMapEntry;true;TiedMapEntry;;;MapValue of Argument[0];MapValue of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;TiedMapEntry;true;TiedMapEntry;;;Argument[1];MapKey of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(Object,Object);;Argument[0];MapKey of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(Object,Object);;Argument[1];MapValue of Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(KeyValue);;Argument[0];Argument[-1];value",
        "org.apache.commons.collections4.keyvalue;UnmodifiableMapEntry;true;UnmodifiableMapEntry;(Entry);;Argument[0];Argument[-1];value"
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
        "org.apache.commons.collections4;MapUtils;true;fixedSizeMap;;;Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;fixedSizeSortedMap;;;Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;getMap;;;MapValue of Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;getMap;;;Argument[2];ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;getObject;;;MapValue of Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;getObject;;;Argument[2];ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;getString;;;MapValue of Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;getString;;;Argument[2];ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;invertMap;;;MapKey of Argument[0];MapValue of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;invertMap;;;MapValue of Argument[0];MapKey of ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;iterableMap;;;Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;iterableSortedMap;;;Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;lazyMap;;;Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;lazySortedMap;;;Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;multiValueMap;;;Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;orderedMap;;;Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;populateMap;(Map,Iterable,Transformer);;Element of Argument[1];MapValue of Argument[0];value",
        "org.apache.commons.collections4;MapUtils;true;populateMap;(MultiMap,Iterable,Transformer);;Element of Argument[1];MapValue of Argument[0];value",
        // Note that when lambdas are supported we should have more models for populateMap
        "org.apache.commons.collections4;MapUtils;true;predicatedMap;;;Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;predicatedSortedMap;;;Argument[0];ReturnValue;value",
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
        "org.apache.commons.collections4;MapUtils;true;synchronizedMap;;;Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;synchronizedSortedMap;;;Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;toMap;;;Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;transformedMap;;;Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;transformedSortedMap;;;Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;unmodifiableMap;;;Argument[0];ReturnValue;value",
        "org.apache.commons.collections4;MapUtils;true;unmodifiableSortedMap;;;Argument[0];ReturnValue;value"
      ]
  }
}
