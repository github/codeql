/** Definitions of flow steps through the collection types in the Guava framework */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.FlowSteps
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.Collections

private string guavaCollectPackage() { result = "com.google.common.collect" }

private class GuavaCollectCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        //"package;type;overrides;name;signature;ext;inputspec;outputspec;kind",
        // Multisets
        "com.google.common.collect;Multiset;true;add;(Object,int);;Argument[0];Element of Argument[-1];value",
        "com.google.common.collect;Multiset;true;setCount;(Object,int);;Argument[0];Element of Argument[-1];value",
        "com.google.common.collect;Multiset;true;setCount;(Object,int,int);;Argument[0];Element of Argument[-1];value",
        "com.google.common.collect;Multiset;true;elementSet;();;Element of Argument[-1];Element of ReturnValue;value",
        "com.google.common.collect;Multiset;true;entrySet;();;Element of Argument[-1];Element of Element of ReturnValue;value",
        "com.google.common.collect;Multiset<>$Entry;true;getElement;();;Element of Argument[-1];ReturnValue;value",
        // Multimaps (aliasing between the collection 'views' returned by some methods and the original collection is not implemented)
        "com.google.common.collect;Multimap;true;asMap;();;MapKey of Argument[-1];MapKey of ReturnValue;value",
        "com.google.common.collect;Multimap;true;asMap;();;MapValue of Argument[-1];Element of MapValue of ReturnValue;value",
        "com.google.common.collect;Multimap;true;entries;();;MapKey of Argument[-1];MapKey of Element of ReturnValue;value",
        "com.google.common.collect;Multimap;true;entries;();;MapValue of Argument[-1];MapValue of Element of ReturnValue;value",
        "com.google.common.collect;Multimap;true;get;(Object);;MapValue of Argument[-1];Element of ReturnValue;value",
        "com.google.common.collect;Multimap;true;keys;();;MapKey of Argument[-1];Element of ReturnValue;value",
        "com.google.common.collect;Multimap;true;keySet;();;MapKey of Argument[-1];Element of ReturnValue;value",
        "com.google.common.collect;Multimap;true;values;();;MapValue of Argument[-1];Element of ReturnValue;value",
        "com.google.common.collect;Multimap;true;put;(Object,Object);;Argument[0];MapKey of Argument[-1];value",
        "com.google.common.collect;Multimap;true;put;(Object,Object);;Argument[1];MapValue of Argument[-1];value",
        "com.google.common.collect;Multimap;true;putAll;(Object,Iterable);;Argument[0];MapKey of Argument[-1];value",
        "com.google.common.collect;Multimap;true;putAll;(Object,Iterable);;Element of Argument[1];MapValue of Argument[-1];value",
        "com.google.common.collect;Multimap;true;putAll;(Multimap);;MapKey of Argument[0];MapKey of Argument[-1];value",
        "com.google.common.collect;Multimap;true;putAll;(Multimap);;MapValue of Argument[0];MapValue of Argument[-1];value",
        "com.google.common.collect;Multimap;true;removeAll;(Object);;MapValue of Argument[-1];MapValue of ReturnValue;value",
        "com.google.common.collect;Multimap;true;replaceValues;(Object,Iterable);;MapValue of Argument[-1];Element of ReturnValue;value",
        "com.google.common.collect;Multimap;true;replaceValues;(Object,Iterable);;Argument[0];MapKey of Argument[-1];value",
        "com.google.common.collect;Multimap;true;replaceValues;(Object,Iterable);;Element of Argument[1];MapValue of Argument[-1];value",
        "com.google.common.collect;ImmutableMultimap;true;inverse;();;MapKey of Argument[-1];MapValue of ReturnValue;value",
        "com.google.common.collect;ImmutableMultimap;true;inverse;();;MapValue of Argument[-1];MapKey of ReturnValue;value",
        // Tables
        "com.google.common.collect;Table<>$Cell;true;getRowKey;();;SyntheticField[com.google.common.collect.Table.rowKey] of MapKey of Argument[-1];ReturnValue;value",
        "com.google.common.collect;Table<>$Cell;true;getColumnKey;();;SyntheticField[com.google.common.collect.Table.columnKey] of MapKey of Argument[-1];ReturnValue;value",
        "com.google.common.collect;Table<>$Cell;true;getValue;();;MapValue of Argument[-1];ReturnValue;value",
        "com.google.common.collect;Table;true;cellSet;();;MapKey of Argument[-1];MapKey of Element of ReturnValue;value",
        "com.google.common.collect;Table;true;cellSet;();;MapValue of Argument[-1];MapValue of Element of ReturnValue;value",
        "com.google.common.collect;Table;true;row;(Object);;SyntheticField[com.google.common.collect.Table.columnKey] of MapKey of Argument[-1];MapKey of ReturnValue;value",
        "com.google.common.collect;Table;true;row;(Object);;MapValue of Argument[-1];MapValue of ReturnValue;value",
        "com.google.common.collect;Table;true;rowKeySet;();;SyntheticField[com.google.common.collect.Table.rowKey] of MapKey of Argument[-1];Element of ReturnValue;value",
        "com.google.common.collect;Table;true;rowMap;();;SyntheticField[com.google.common.collect.Table.rowKey] of MapKey of Argument[-1];MapKey of ReturnValue;value",
        "com.google.common.collect;Table;true;rowMap;();;SyntheticField[com.google.common.collect.Table.columnKey] of MapKey of Argument[-1];MapKey of MapValue of ReturnValue;value",
        "com.google.common.collect;Table;true;rowMap;();;MapValue of Argument[-1];MapValue of MapValue of ReturnValue;value",
        "com.google.common.collect;Table;true;column;(Object);;SyntheticField[com.google.common.collect.Table.rowKey] of MapKey of Argument[-1];MapKey of ReturnValue;value",
        "com.google.common.collect;Table;true;column;(Object);;MapValue of Argument[-1];MapValue of ReturnValue;value",
        "com.google.common.collect;Table;true;columnKeySet;();;SyntheticField[com.google.common.collect.Table.columnKey] of MapKey of Argument[-1];Element of ReturnValue;value",
        "com.google.common.collect;Table;true;columnMap;();;SyntheticField[com.google.common.collect.Table.columnKey] of MapKey of Argument[-1];MapKey of ReturnValue;value",
        "com.google.common.collect;Table;true;columnMap;();;SyntheticField[com.google.common.collect.Table.rowKey] of MapKey of Argument[-1];MapKey of MapValue of ReturnValue;value",
        "com.google.common.collect;Table;true;columnMap;();;MapValue of Argument[-1];MapValue of MapValue of ReturnValue;value",
        "com.google.common.collect;Table;true;values;();;MapValue of Argument[-1];Element of ReturnValue;value",
        "com.google.common.collect;Table;true;get;(Object,Object);;MapValue of Argument[-1];ReturnValue;value",
        "com.google.common.collect;Table;true;remove;(Object,Object);;MapValue of Argument[-1];ReturnValue;value",
        "com.google.common.collect;Table;true;put;(Object,Object,Object);;Argument[0];SyntheticField[com.google.common.collect.Table.rowKey] of MapKey of Argument[-1];value",
        "com.google.common.collect;Table;true;put;(Object,Object,Object);;Argument[1];SyntheticField[com.google.common.collect.Table.columnKey] of MapKey of Argument[-1];value",
        "com.google.common.collect;Table;true;put;(Object,Object,Object);;Argument[2];MapValue of Argument[-1];value",
        "com.google.common.collect;Table;true;putAll;(Table);;MapKey of Argument[0];MapKey of Argument[-1];value",
        "com.google.common.collect;Table;true;putAll;(Table);;MapValue of Argument[0];MapValue of Argument[-1];value",
        // Misc collections and utilities
        "com.google.common.collect;ImmutableCollection;true;asList;();;Element of Argument[-1];Element of ReturnValue;value",
        "com.google.common.collect;ImmutableList;true;reverse;();;Element of Argument[-1];Element of ReturnValue;value",
        "com.google.common.collect;ImmutableCollection;true;subList;(int,int);;Element of Argument[-1];Element of ReturnValue;value",
        "com.google.common.collect;BiMap;true;forcePut;(Object,Object);;Argument[0];MapKey of Argument[-1];value",
        "com.google.common.collect;BiMap;true;forcePut;(Object,Object);;Argument[1];MapValue of Argument[-1];value",
        "com.google.common.collect;BiMap;true;inverse;();;MapKey of Argument[-1];MapValue of ReturnValue;value",
        "com.google.common.collect;BiMap;true;inverse;();;MapValue of Argument[-1];MapKey of ReturnValue;value",
        "com.google.common.collect;ClassToInstanceMap;true;getInstance;(Class);;MapValue of Argument[-1];ReturnValue;value",
        "com.google.common.collect;ClassToInstanceMap;true;putInstance;(Class,Object);;MapValue of Argument[-1];ReturnValue;value",
        "com.google.common.collect;ClassToInstanceMap;true;putInstance;(Class,Object);;Argument[1];MapValue of Argument[-1];value",
        // Builders
        "com.google.common.collect;ImmutableCollection<>$Builder;true;build;();;Element of Argument[-1];Element of ReturnValue;value",
        "com.google.common.collect;ImmutableCollection<>$Builder;true;add;(Object);;Argument[-1];ReturnValue;value",
        "com.google.common.collect;ImmutableCollection<>$Builder;true;add;(Object);;Argument[0];Element of Argument[-1];value",
        "com.google.common.collect;ImmutableCollection<>$Builder;true;addAll;;;Argument[-1];ReturnValue;value",
        "com.google.common.collect;ImmutableCollection<>$Builder;true;addAll;(Object[]);;ArrayElement of Argument[0];Element of Argument[-1];value",
        "com.google.common.collect;ImmutableCollection<>$Builder;true;addAll;(Iterable);;Element of Argument[0];Element of Argument[-1];value",
        "com.google.common.collect;ImmutableCollection<>$Builder;true;addAll;(Iterator);;Element of Argument[0];Element of Argument[-1];value",
        "com.google.common.collect;ImmutableMultiset<>$Builder;true;addCopies;(Object,int);;Argument[-1];ReturnValue;value",
        "com.google.common.collect;ImmutableMultiset<>$Builder;true;addCopies;(Object,int);;Argument[0];Element of Argument[-1];value",
        "com.google.common.collect;ImmutableMap<>$Builder;true;build;();;MapKey of Argument[-1];MapKey of ReturnValue;value",
        "com.google.common.collect;ImmutableMap<>$Builder;true;build;();;MapValue of Argument[-1];MapValue of ReturnValue;value",
        "com.google.common.collect;ImmutableMap<>$Builder;true;orderEntriesByValue;(Comparator);;Argument[-1];ReturnValue;value",
        "com.google.common.collect;ImmutableMap<>$Builder;true;put;;;Argument[-1];ReturnValue;value",
        "com.google.common.collect;ImmutableMap<>$Builder;true;put;(Entry);;MapKey of Argument[0];MapKey of Argument[-1];value",
        "com.google.common.collect;ImmutableMap<>$Builder;true;put;(Entry);;MapValue of Argument[0];MapValue of Argument[-1];value",
        "com.google.common.collect;ImmutableMap<>$Builder;true;put;(Object,Object);;Argument[0];MapKey of Argument[-1];value",
        "com.google.common.collect;ImmutableMap<>$Builder;true;put;(Object,Object);;Argument[1];MapValue of Argument[-1];value",
        "com.google.common.collect;ImmutableMap<>$Builder;true;putAll;;;Argument[-1];ReturnValue;value",
        "com.google.common.collect;ImmutableMap<>$Builder;true;putAll;(Iterable);;MapKey of Element of Argument[0];MapKey of Argument[-1];value",
        "com.google.common.collect;ImmutableMap<>$Builder;true;putAll;(Iterable);;MapValue of Element of Argument[0];MapValue of Argument[-1];value",
        "com.google.common.collect;ImmutableMap<>$Builder;true;putAll;(Map);;MapKey of Argument[0];MapKey of Argument[-1];value",
        "com.google.common.collect;ImmutableMap<>$Builder;true;putAll;(Map);;MapValue of Argument[0];MapValue of Argument[-1];value",
        "com.google.common.collect;ImmutableMultimap<>$Builder;true;build;();;MapKey of Argument[-1];MapKey of ReturnValue;value",
        "com.google.common.collect;ImmutableMultimap<>$Builder;true;build;();;MapValue of Argument[-1];MapValue of ReturnValue;value",
        "com.google.common.collect;ImmutableMultimap<>$Builder;true;orderKeysBy;(Comparator);;Argument[-1];ReturnValue;value",
        "com.google.common.collect;ImmutableMultimap<>$Builder;true;orderValuesBy;(Comparator);;Argument[-1];ReturnValue;value",
        "com.google.common.collect;ImmutableMultimap<>$Builder;true;put;;;Argument[-1];ReturnValue;value",
        "com.google.common.collect;ImmutableMultimap<>$Builder;true;put;(Entry);;MapKey of Argument[0];MapKey of Argument[-1];value",
        "com.google.common.collect;ImmutableMultimap<>$Builder;true;put;(Entry);;MapValue of Argument[0];MapValue of Argument[-1];value",
        "com.google.common.collect;ImmutableMultimap<>$Builder;true;put;(Object,Object);;Argument[0];MapKey of Argument[-1];value",
        "com.google.common.collect;ImmutableMultimap<>$Builder;true;put;(Object,Object);;Argument[1];MapValue of Argument[-1];value",
        "com.google.common.collect;ImmutableMultimap<>$Builder;true;putAll;;;Argument[-1];ReturnValue;value",
        "com.google.common.collect;ImmutableMultimap<>$Builder;true;putAll;(Iterable);;MapKey of Element of Argument[0];MapKey of Argument[-1];value",
        "com.google.common.collect;ImmutableMultimap<>$Builder;true;putAll;(Iterable);;MapValue of Element of Argument[0];MapValue of Argument[-1];value",
        "com.google.common.collect;ImmutableMultimap<>$Builder;true;putAll;(Multimap);;MapKey of Argument[0];MapKey of Argument[-1];value",
        "com.google.common.collect;ImmutableMultimap<>$Builder;true;putAll;(Multimap);;MapValue of Argument[0];MapValue of Argument[-1];value",
        "com.google.common.collect;ImmutableMultimap<>$Builder;true;putAll;(Object,Iterable);;Argument[0];MapKey of Argument[-1];value",
        "com.google.common.collect;ImmutableMultimap<>$Builder;true;putAll;(Object,Iterable);;Element of Argument[1];MapValue of Argument[-1];value",
        "com.google.common.collect;ImmutableMultimap<>$Builder;true;putAll;(Object,Iterable);;Argument[0];MapKey of Argument[-1];value",
        "com.google.common.collect;ImmutableMultimap<>$Builder;true;putAll;(Object,Object[]);;ArrayElement of Argument[1];MapValue of Argument[-1];value",
        "com.google.common.collect;ImmutableTable<>$Builder;true;build;();;SyntheticField[com.google.common.collect.Table.rowKey] of MapKey of Argument[-1];SyntheticField[com.google.common.collect.Table.rowKey] of MapKey of ReturnValue;value",
        "com.google.common.collect;ImmutableTable<>$Builder;true;build;();;SyntheticField[com.google.common.collect.Table.columnKey] of MapKey of Argument[-1];SyntheticField[com.google.common.collect.Table.columnKey] of MapKey of ReturnValue;value",
        "com.google.common.collect;ImmutableTable<>$Builder;true;build;();;MapValue of Argument[-1];MapValue of ReturnValue;value",
        "com.google.common.collect;ImmutableTable<>$Builder;true;orderRowsBy;(Comparator);;Argument[-1];ReturnValue;value",
        "com.google.common.collect;ImmutableTable<>$Builder;true;orderColumnsBy;(Comparator);;Argument[-1];ReturnValue;value",
        "com.google.common.collect;ImmutableTable<>$Builder;true;put;(Object,Object,Object);;Argument[-1];ReturnValue;value",
        "com.google.common.collect;ImmutableTable<>$Builder;true;put;(Cell);;Argument[-1];ReturnValue;value",
        "com.google.common.collect;ImmutableTable<>$Builder;true;putAll;(Table);;Argument[-1];ReturnValue;value",
        "com.google.common.collect;ImmutableTable<>$Builder;true;put;(Object,Object,Object);;Argument[0];SyntheticField[com.google.common.collect.Table.rowKey] of MapKey of Argument[-1];value",
        "com.google.common.collect;ImmutableTable<>$Builder;true;put;(Object,Object,Object);;Argument[1];SyntheticField[com.google.common.collect.Table.columnKey] of MapKey of Argument[-1];value",
        "com.google.common.collect;ImmutableTable<>$Builder;true;put;(Object,Object,Object);;Argument[2];MapValue of Argument[-1];value",
        "com.google.common.collect;ImmutableTable<>$Builder;true;put;(Cell);;MapKey of Argument[0];MapKey of Argument[-1];value",
        "com.google.common.collect;ImmutableTable<>$Builder;true;put;(Cell);;MapValue of Argument[0];MapValue of Argument[-1];value",
        "com.google.common.collect;ImmutableTable<>$Builder;true;putAll;(Table);;MapKey of Argument[0];MapKey of Argument[-1];value",
        "com.google.common.collect;ImmutableTable<>$Builder;true;putAll;(Table);;MapValue of Argument[0];MapValue of Argument[-1];value",
        // `of` methods
        "com.google.common.collect;ImmutableList;true;of;;;Argument[0..11];Element of ReturnValue;value",
        "com.google.common.collect;ImmutableList;true;of;;;ArrayElement of Argument[12];Element of ReturnValue;value",
        "com.google.common.collect;ImmutableSet;true;of;;;Argument[0..5];Element of ReturnValue;value",
        "com.google.common.collect;ImmutableSet;true;of;;;ArrayElement of Argument[6];Element of ReturnValue;value",
        "com.google.common.collect;ImmutableMultiset;true;of;;;Argument[0..5];Element of ReturnValue;value",
        "com.google.common.collect;ImmutableMultiset;true;of;;;Element of Argument[6];Element of ReturnValue;value",
        "com.google.common.collect;ImmutableMap;true;of;;;Argument[0];MapKey of ReturnValue;value",
        "com.google.common.collect;ImmutableMap;true;of;;;Argument[1];MapValue of ReturnValue;value",
        "com.google.common.collect;ImmutableMap;true;of;;;Argument[2];MapKey of ReturnValue;value",
        "com.google.common.collect;ImmutableMap;true;of;;;Argument[3];MapValue of ReturnValue;value",
        "com.google.common.collect;ImmutableMap;true;of;;;Argument[4];MapKey of ReturnValue;value",
        "com.google.common.collect;ImmutableMap;true;of;;;Argument[5];MapValue of ReturnValue;value",
        "com.google.common.collect;ImmutableMap;true;of;;;Argument[6];MapKey of ReturnValue;value",
        "com.google.common.collect;ImmutableMap;true;of;;;Argument[7];MapValue of ReturnValue;value",
        "com.google.common.collect;ImmutableMap;true;of;;;Argument[8];MapKey of ReturnValue;value",
        "com.google.common.collect;ImmutableMap;true;of;;;Argument[9];MapValue of ReturnValue;value",
        "com.google.common.collect;ImmutableMap;true;of;;;Argument[10];MapKey of ReturnValue;value",
        "com.google.common.collect;ImmutableMap;true;of;;;Argument[11];MapValue of ReturnValue;value",
        "com.google.common.collect;ImmutableMultimap;true;of;;;Argument[0];MapKey of ReturnValue;value",
        "com.google.common.collect;ImmutableMultimap;true;of;;;Argument[1];MapValue of ReturnValue;value",
        "com.google.common.collect;ImmutableMultimap;true;of;;;Argument[2];MapKey of ReturnValue;value",
        "com.google.common.collect;ImmutableMultimap;true;of;;;Argument[3];MapValue of ReturnValue;value",
        "com.google.common.collect;ImmutableMultimap;true;of;;;Argument[4];MapKey of ReturnValue;value",
        "com.google.common.collect;ImmutableMultimap;true;of;;;Argument[5];MapValue of ReturnValue;value",
        "com.google.common.collect;ImmutableMultimap;true;of;;;Argument[6];MapKey of ReturnValue;value",
        "com.google.common.collect;ImmutableMultimap;true;of;;;Argument[7];MapValue of ReturnValue;value",
        "com.google.common.collect;ImmutableMultimap;true;of;;;Argument[8];MapKey of ReturnValue;value",
        "com.google.common.collect;ImmutableMultimap;true;of;;;Argument[9];MapValue of ReturnValue;value",
        "com.google.common.collect;ImmutableClassToInstanceMap;true;of;(Class,Object);;Argument[0];MapKey of ReturnValue;value",
        "com.google.common.collect;ImmutableClassToInstanceMap;true;of;(Class,Object);;Argument[1];MapValue of ReturnValue;value",
        "com.google.common.collect;ImmutableTable;true;of;(Object,Object,Object);;Argument[0];SyntheticField[com.google.common.collect.Table.rowKey] of MapKey of ReturnValue;value",
        "com.google.common.collect;ImmutableTable;true;of;(Object,Object,Object);;Argument[1];SyntheticField[com.google.common.collect.Table.columnKey] of MapKey of ReturnValue;value",
        "com.google.common.collect;ImmutableTable;true;of;(Object,Object,Object);;Argument[2];MapValue of ReturnValue;value",
        // `copyOf` methods
        "com.google.common.collect;ImmutableList;true;copyOf;(Object[]);;ArrayElement of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;ImmutableList;true;copyOf;(Iterable);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;ImmutableList;true;copyOf;(Iterator);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;ImmutableList;true;copyOf;(Collection);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;ImmutableList;true;sortedCopyOf;(Iterable);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;ImmutableList;true;sortedCopyOf;(Comparator,Iterable);;Element of Argument[1];Element of ReturnValue;value",
        "com.google.common.collect;ImmutableSet;true;copyOf;(Object[]);;ArrayElement of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;ImmutableSet;true;copyOf;(Iterable);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;ImmutableSet;true;copyOf;(Iterator);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;ImmutableSet;true;copyOf;(Collection);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;ImmutableSortedSet;true;copyOf;(Comparator,Iterable);;Element of Argument[1];Element of ReturnValue;value",
        "com.google.common.collect;ImmutableSortedSet;true;copyOf;(Comparator,Iterator);;Element of Argument[1];Element of ReturnValue;value",
        "com.google.common.collect;ImmutableSortedSet;true;copyOf;(Comparator,Collection);;Element of Argument[1];Element of ReturnValue;value",
        "com.google.common.collect;ImmutableSortedSet;true;copyOfSorted;(SortedSet);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;ImmutableMultiset;true;copyOf;(Object[]);;ArrayElement of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;ImmutableMultiset;true;copyOf;(Iterable);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;ImmutableMultiset;true;copyOf;(Iterator);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;ImmutableSortedMultiset;true;copyOf;(Comparator,Iterable);;Element of Argument[1];Element of ReturnValue;value",
        "com.google.common.collect;ImmutableSortedMultiset;true;copyOf;(Comparator,Iterator);;Element of Argument[1];Element of ReturnValue;value",
        "com.google.common.collect;ImmutableSortedMultiset;true;copyOf;(Comparator,Collection);;Element of Argument[1];Element of ReturnValue;value",
        "com.google.common.collect;ImmutableSortedMultiset;true;copyOfSorted;(SortedMultiSet);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;ImmutableMap;true;copyOf;(Map);;MapKey of Argument[0];MapKey of ReturnValue;value",
        "com.google.common.collect;ImmutableMap;true;copyOf;(Map);;MapValue of Argument[0];MapValue of ReturnValue;value",
        "com.google.common.collect;ImmutableMap;true;copyOf;(Iterable);;MapKey of Element of Argument[0];MapKey of ReturnValue;value",
        "com.google.common.collect;ImmutableMap;true;copyOf;(Iterable);;MapValue of Element of Argument[0];MapValue of ReturnValue;value",
        "com.google.common.collect;ImmutableSortedMap;true;copyOfSorted;(SortedMap);;MapKey of Argument[0];MapKey of ReturnValue;value",
        "com.google.common.collect;ImmutableSortedMap;true;copyOfSorted;(SortedMap);;MapValue of Argument[0];MapValue of ReturnValue;value",
        "com.google.common.collect;ImmutableSortedMap;true;copyOf;(Map,Comparator);;MapKey of Argument[0];MapKey of ReturnValue;value",
        "com.google.common.collect;ImmutableSortedMap;true;copyOf;(Map,Comparator);;MapValue of Argument[0];MapValue of ReturnValue;value",
        "com.google.common.collect;ImmutableMultimap;true;copyOf;(Multimap);;MapKey of Argument[0];MapKey of ReturnValue;value",
        "com.google.common.collect;ImmutableMultimap;true;copyOf;(Multimap);;MapValue of Argument[0];MapValue of ReturnValue;value",
        "com.google.common.collect;ImmutableMultimap;true;copyOf;(Iterable);;MapKey of Element of Argument[0];MapKey of ReturnValue;value",
        "com.google.common.collect;ImmutableMultimap;true;copyOf;(Iterable);;MapValue of Element of Argument[0];MapValue of ReturnValue;value",
        "com.google.common.collect;ImmutableClassToInstanceMap;true;copyOf;(Map);;MapKey of Argument[0];MapKey of ReturnValue;value",
        "com.google.common.collect;ImmutableClassToInstanceMap;true;copyOf;(Map);;MapValue of Argument[0];MapValue of ReturnValue;value",
        "com.google.common.collect;ImmutableTable;true;copyOf;(Table);;MapKey of Argument[0];MapKey of ReturnValue;value",
        "com.google.common.collect;ImmutableTable;true;copyOf;(Table);;MapValue of Argument[0];MapValue of ReturnValue;value",
        // `create` methods
        "com.google.common.collect;HashMultiset;true;create;(Iterable);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;LinkdHashMultiset;true;create;(Iterable);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;TreeMultiset;true;create;(Iterable);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;ConcurrentHashMultiset;true;create;(Iterable);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;HashMultimap;true;create;(Multimap);;MapKey of Argument[0];MapKey of ReturnValue;value",
        "com.google.common.collect;HashMultimap;true;create;(Multimap);;MapValue of Argument[0];MapValue of ReturnValue;value",
        "com.google.common.collect;LinkedHashMultimap;true;create;(Multimap);;MapKey of Argument[0];MapKey of ReturnValue;value",
        "com.google.common.collect;LinkedHashMultimap;true;create;(Multimap);;MapValue of Argument[0];MapValue of ReturnValue;value",
        "com.google.common.collect;LinkedListMultimap;true;create;(Multimap);;MapKey of Argument[0];MapKey of ReturnValue;value",
        "com.google.common.collect;LinkedListMultimap;true;create;(Multimap);;MapValue of Argument[0];MapValue of ReturnValue;value",
        "com.google.common.collect;ArrayListMultimap;true;create;(Multimap);;MapKey of Argument[0];MapKey of ReturnValue;value",
        "com.google.common.collect;ArrayListMultimap;true;create;(Multimap);;MapValue of Argument[0];MapValue of ReturnValue;value",
        "com.google.common.collect;TreeMultimap;true;create;(Multimap);;MapKey of Argument[0];MapKey of ReturnValue;value",
        "com.google.common.collect;TreeMultimap;true;create;(Multimap);;MapValue of Argument[0];MapValue of ReturnValue;value",
        "com.google.common.collect;HashBiMap;true;create;(Map);;MapKey of Argument[0];MapKey of ReturnValue;value",
        "com.google.common.collect;HashBiMap;true;create;(Map);;MapValue of Argument[0];MapValue of ReturnValue;value",
        "com.google.common.collect;MutableClassToInstanceMap;true;create;(Multimap);;MapKey of Argument[0];MapKey of ReturnValue;value",
        "com.google.common.collect;MutableClassToInstanceMap;true;create;(Multimap);;MapValue of Argument[0];MapValue of ReturnValue;value",
        "com.google.common.collect;HashBasedTable;true;create;(Table);;MapKey of Argument[0];MapKey of ReturnValue;value",
        "com.google.common.collect;HashBasedTable;true;create;(Table);;MapValue of Argument[0];MapValue of ReturnValue;value",
        "com.google.common.collect;TreeBasedTable;true;create;(Table);;MapKey of Argument[0];MapKey of ReturnValue;value",
        "com.google.common.collect;TreeBasedTable;true;create;(Table);;MapValue of Argument[0];MapValue of ReturnValue;value",
        "com.google.common.collect;ArrayTable;true;create;(Iterable,Iterable);;Element of Argument[0];SyntheticField[com.google.common.collect.Table.rowKey] of MapKey of ReturnValue;value",
        "com.google.common.collect;ArrayTable;true;create;(Iterable,Iterable);;Element of Argument[1];SyntheticField[com.google.common.collect.Table.columnKey] of MapKey of ReturnValue;value",
        // Utility classes (a few methods depending on lambda flow are not included)
        "com.google.common.collect;Sets$SetView;true;immutableCopy;();;Element of Argument[-1];Element of ReturnValue;value",
        "com.google.common.collect;Sets$SetView;true;copyInto;(Set);;Element of Argument[-1];Element of Argument[0];value",
        "com.google.common.collect;Sets;false;cartesanProduct;(List);;Element of Element of Argument[0];Element of Element of ReturnValue;value",
        "com.google.common.collect;Sets;false;cartesanProduct;(Set[]);;Element of ArrayElement of Argument[0];Element of Element of ReturnValue;value",
        "com.google.common.collect;Sets;false;combinations;(Set,int);;Element of Argument[0];Element of Element of ReturnValue;value",
        "com.google.common.collect;Sets;false;difference;(Set,Set);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;Sets;false;filter;(NavigableSet,Predicate);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;Sets;false;filter;(Set,Predicate);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;Sets;false;filter;(SortedSet,Predicate);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;Sets;false;newConcurrentHashSet;(Iterable);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;Sets;false;newCopyOnWriteArraySet;(Iterable);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;Sets;false;newConcurrentHashSet;(Iterable);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;Sets;false;newHashSet;(Iterable);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;Sets;false;newHashSet;(Iterator);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;Sets;false;newHashSet;(Object[]);;ArrayElement of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;Sets;false;newLinkedHashSet;(Iterable);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;Sets;false;newTreeSet;(Iterable);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;Sets;false;newSetFromMap;(Map);;MapKey of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;Sets;false;powerSet;(Set);;Element of Argument[0];Element of Element of ReturnValue;value",
        "com.google.common.collect;Sets;false;subSet;(NavigableSet,Range);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;Sets;false;symmetricDifference;(Set,Set);;Element of Argument[0..1]; Element of ReturnValue;value",
        "com.google.common.collect;Sets;false;union;(Set,Set);;Element of Argument[0..1];Element of ReturnValue;value",
        "com.google.common.collect;Sets;false;synchronizedNavigableSet;(NavigableSet);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;Sets;false;unmodifiableNavigableSet;(NavigableSet);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;Lists;false;asList;(Object,Object);;Argument[0..1];Element of ReturnValue;value",
        "com.google.common.collect;Lists;false;asList;(Object,Object[]);;Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;Lists;false;asList;(Object,Object[]);;ArrayElememnt of Argument[1];Element of ReturnValue;value",
        "com.google.common.collect;Lists;false;cartesanProduct;(List);;Element of Element of Argument[0];Element of Element of ReturnValue;value",
        "com.google.common.collect;Lists;false;cartesanProduct;(List[]);;Element of ArrayElement of Argument[0];Element of Element of ReturnValue;value",
        "com.google.common.collect;Lists;false;charactersOf;(CharSequence);;Argument[0];Element of ReturnValue;taint",
        "com.google.common.collect;Lists;false;charactersOf;(String);;Argument[0];Element of ReturnValue;taint",
        "com.google.common.collect;Lists;false;newArrayList;(Object[]);;ArrayElement of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;Lists;false;newArrayList;(Iterator);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;Lists;false;newArrayList;(Iterable);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;Lists;false;newCopyOnWriteArrayList;(Iterable);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;Lists;false;newLinkedList;(Iterable);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;Lists;false;partition;(List,int);;Element of Argument[0];Element of Element of ReturnValue;value",
        "com.google.common.collect;Lists;false;reverse;(List);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;Collections2;false;filter;(Collection,Predicate);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;Collections2;false;orderedPermutations;(Iterable,Comparator);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;Collections2;false;orderedPermutations;(Iterable);;Element of Argument[0];Element of ReturnValue;value",
        "com.google.common.collect;Collections2;false;permutations;(Collection);;Element of Argument[0];Element of ReturnValue;value"
      ]
  }
}

/**
 * A reference type that extends a parameterization of `com.google.common.collect.Multimap`.
 */
class MultimapType extends RefType {
  MultimapType() {
    this.getSourceDeclaration()
        .getASourceSupertype*()
        .hasQualifiedName(guavaCollectPackage(), "Multimap")
  }

  /** Gets the type of keys stored in this map. */
  RefType getKeyType() {
    exists(GenericInterface map | map.hasQualifiedName(guavaCollectPackage(), "Multimap") |
      indirectlyInstantiates(this, map, 0, result)
    )
  }

  /** Gets the type of values stored in this map. */
  RefType getValueType() {
    exists(GenericInterface map | map.hasQualifiedName(guavaCollectPackage(), "Multimap") |
      indirectlyInstantiates(this, map, 1, result)
    )
  }
}

/**
 * A reference type that extends a parameterization of `com.google.common.collect.Table`.
 */
class TableType extends RefType {
  TableType() {
    this.getSourceDeclaration()
        .getASourceSupertype*()
        .hasQualifiedName(guavaCollectPackage(), "Table")
  }

  /** Gets the type of row keys stored in this table. */
  RefType getRowType() {
    exists(GenericInterface table | table.hasQualifiedName(guavaCollectPackage(), "Table") |
      indirectlyInstantiates(this, table, 0, result)
    )
  }

  /** Gets the type of column keys stored in this table. */
  RefType getColumnType() {
    exists(GenericInterface table | table.hasQualifiedName(guavaCollectPackage(), "Table") |
      indirectlyInstantiates(this, table, 1, result)
    )
  }

  /** Gets the type of values stored in this table. */
  RefType getValueType() {
    exists(GenericInterface table | table.hasQualifiedName(guavaCollectPackage(), "Table") |
      indirectlyInstantiates(this, table, 2, result)
    )
  }
}

private class TableRowField extends SyntheticField {
  override predicate fieldSpec(RefType owningType, string fieldName, Type fieldType) {
    owningType.hasQualifiedName(guavaCollectPackage(), "Table") and
    fieldName = "rowKey" and
    fieldType instanceof TypeObject
  }
}

private class TableColumnField extends SyntheticField {
  override predicate fieldSpec(RefType owningType, string fieldName, Type fieldType) {
    owningType.hasQualifiedName(guavaCollectPackage(), "Table") and
    fieldName = "columnKey" and
    fieldType instanceof TypeObject
  }
}
