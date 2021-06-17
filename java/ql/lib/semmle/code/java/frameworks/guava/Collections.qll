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
        "com.google.common.collect;Multimap;true;values();;MapValue of Argument[-1];Element of ReturnValue;value",
        "com.google.common.collect;Multimap;true;put;(Object,Object);;Argument[0];MapKey of Argument[-1];value",
        "com.google.common.collect;Multimap;true;put;(Object,Object);;Argument[1];MapValue of Argument[-1];value",
        "com.google.common.collect;Multimap;true;putAll;(Object,Iterable);;Argument[0];MapKey of Argument[-1];value",
        "com.google.common.collect;Multimap;true;putAll;(Object,Iterable);;Element of Argument[1];MapValue of Argument[-1];value",
        "com.google.common.collect;Multimap;true;putAll;(Multimap);;MapKey of Argument[0];MapKey of Argument[-1];value",
        "com.google.common.collect;Multimap;true;putAll;(Multimap);;MapValue of Argument[0];MapValue of Argument[-1];value",
        "com.google.common.collect;Multimap;true;removeAll;(Object);;MapValue of Argument[-1];MapValue of ReturnValue;value",
        "com.google.common.collect;Multimap;true;replaceValues;(Object,Iterable);;MapValue of Argument[-1];MapValue of ReturnValue;value",
        "com.google.common.collect;Multimap;true;replaceValues(Object,Iterable);;Argument[0];MapKey of Argument[-1];value",
        "com.google.common.collect;Multimap;true;replaceValues(Object,Iterable);;Element of Argument[0];MapValue of Argument[-1];value",
        "com.google.common.collect;ImmutableMultimap;true;inverse;();;MapKey of Argument[-1];MapValue of ReturnValue;value",
        "com.google.common.collect;ImmutableMultimap;true;inverse;();;MapValue of Argument[-1];MapKey of ReturnValue;value",
        // Tables (TODO)
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
        "com.google.common.collect;ImmutableMultimap;true;copyOf;(Multimap);;MapKey of Argument[0];MapKey of ReturnValue;value",
        "com.google.common.collect;ImmutableMultimap;true;copyOf;(Multimap);;MapValue of Argument[0];MapValue of ReturnValue;value",
        "com.google.common.collect;ImmutableMultimap;true;copyOf;(Iterable);;MapKey of Element of Argument[0];MapKey of ReturnValue;value",
        "com.google.common.collect;ImmutableMultimap;true;copyOf;(Iterable);;MapValue of Element of Argument[0];MapValue of ReturnValue;value"
        // Utility classes
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

/**
 * A taint-preserving static method of `com.google.common.collect.Sets`.
 */
private class SetsMethod extends TaintPreservingCallable {
  int arg;

  SetsMethod() {
    this.getDeclaringType().hasQualifiedName(guavaCollectPackage(), "Sets") and
    this.isStatic() and
    (
      // static <E> HashSet<E> newHashSet(E... elements)
      // static <E> Set<E> newConcurrentHashSet(Iterable<? extends E> elements)
      // static <E> CopyOnWriteArraySet<E> newCopyOnWriteArraySet(Iterable<? extends E> elements)
      // etc
      this.getName().matches("new%Set") and
      arg = 0
      or
      // static <B> Set<List<B>> cartesianProduct(List<? extends Set<? extends B>> sets)
      // static <B> Set<List<B>> cartesianProduct(Set<? extends B>... sets)
      // static <E> Set<Set<E>> combinations(Set<E> set, int size)
      // static <E> Sets.SetView<E> difference(Set<E> set1, Set<?> set2)
      // static <E> NavigableSet<E> filter(NavigableSet<E> unfiltered, Predicate<? super E> predicate)
      // static <E> Set<E> filter(Set<E> unfiltered, Predicate<? super E> predicate)
      // static <E> SortedSet<E> filter(SortedSet<E> unfiltered, Predicate<? super E> predicate)
      // static <E> Set<Set<E>> powerSet(Set<E> set)
      // static <K extends Comparable<? super K>> NavigableSet<K> subSet(NavigableSet<K> set, Range<K> range)
      // static <E> NavigableSet<E> synchronizedNavigableSet(NavigableSet<E> navigableSet)
      // static <E> NavigableSet<E> unmodifiableNavigableSet(NavigableSet<E> set)
      this.hasName([
          "cartesianProduct", "combinations", "difference", "filter", "powerSet", "subSet",
          "synchronizedNavigableSet", "unmodifyableNavigableSet"
        ]) and
      arg = 0
      or
      // static <E> Sets.SetView<E> symmetricDifference(Set<? extends E> set1, Set<? extends E> set2)
      // static <E> Sets.SetView<E> union(Set<? extends E> set1, Set<? extends E> set2)
      this.hasName(["symmetricDifference", "union"]) and
      arg = [0, 1]
    )
  }

  override predicate returnsTaintFrom(int arg_) { arg_ = arg }
}
