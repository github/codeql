/** Definitions of flow steps through the collection types in the Guava framework */

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.FlowSteps
private import semmle.code.java.Collections

private string guavaCollectPackage() { result = "com.google.common.collect" }

/** A reference type that extends a parameterization of one of the various immutable container types. */
private class ImmutableContainerType extends RefType {
  string kind;

  ImmutableContainerType() {
    this.getSourceDeclaration().getASourceSupertype*().hasQualifiedName(guavaCollectPackage(), kind) and
    kind = ["ImmutableCollection", "ImmutableMap", "ImmutableMultimap", "ImmutableTable"]
  }

  /**
   * Gets the name of the most general superclass of this type
   * from among `ImmutableCollection`, `ImmutableMap`, `ImmutableMultimap`, and `ImmutableTable`.
   */
  string getKind() { result = kind }
}

/** A nested `Builder` class of one of the various immutable container classes */
private class ContainerBuilder extends NestedType {
  ContainerBuilder() {
    this.hasName("Builder") and
    this.getEnclosingType() instanceof ImmutableContainerType
  }
}

private class BuilderBuildMethod extends TaintPreservingCallable {
  BuilderBuildMethod() {
    this.getDeclaringType().getASourceSupertype*() instanceof ContainerBuilder and
    // abstract ImmutableCollection<E> build()
    // similar for other builder types
    this.hasName("build")
  }

  override predicate returnsTaintFrom(int arg) { arg = -1 }
}

/** A method on a `Builder` class that adds elements to the container being built */
private class BuilderAddMethod extends TaintPreservingCallable {
  int argument;

  BuilderAddMethod() {
    this.getDeclaringType().getASourceSupertype*() instanceof ContainerBuilder and
    (
      // abstract ImmutableCollection.Builder<E> add(E element)
      // ImmutableCollection.Builder<E> add(E... elements)
      // ImmutableCollection.Builder<E> addAll(Iterable<? extends E> elements)
      // ImmutableCollection.Builder<E> addAll(Iterator<? extends E> elements)
      // ImmutableMultiset.Builder<E> addCopies(E element, int occurrences)
      // ImmutableMultiset.Builder<E> setCount(E element, int count)
      this.hasName(["add", "addAll", "addCopies", "setCount"]) and
      argument = 0
      or
      // ImmutableMap.Builder<K,V> put(K key, V value)
      // ImmutableMap.Builder<K,V> put(Map.Entry<? extends K,? extends V> entry)
      // ImmutableMap.Builder<K,V> putAll(Map<? extends K,? extends V> map)
      // ImmutableMap.Builder<K,V> putAll(Iterable<? extends Map.Entry<? extends K,? extends V>> entries)
      // ImmutableMultimap.Builder<K,V> put(K key, V value)
      // ImmutableMultimap.Builder<K,V> put(Map.Entry<? extends K,? extends V> entry)
      // ImmutableMultimap.Builder<K,V> putAll(Iterable<? extends Map.Entry<? extends K,? extends V>> entries)
      // ImmutableMultimap.Builder<K,V> putAll(K key, Iterable<? extends V> values)
      // ImmutableMultimap.Builder<K,V> putAll(K key, V... values)
      // ImmutableMultimap.Builder<K,V> putAll(Multimap<? extends K,? extends V> multimap)
      // ImmutableTable.Builder<R,C,V> put(R rowKey, C columnKey, V value)
      // ImmutableTable.Builder<R,C,V> put(Table.Cell<? extends R,? extends C,? extends V> cell)
      // ImmutableTable.Builder<R,C,V> putAll(Table<? extends R,? extends C,? extends V> table)
      this.hasName(["put", "putAll"]) and
      argument = getNumberOfParameters() - 1
    )
  }

  override predicate returnsTaintFrom(int arg) { arg = [-1, argument] }

  override predicate transfersTaint(int src, int sink) { src = argument and sink = -1 }
}

/**
 * In a chained call `b.add(x).add(y).add(z)`, represents a flow step from the return value of
 * this expression to the post update node of `b` (valid because the builder add methods return their qualifier).
 * This is sufficient to express flow from `y` and `z` to `b`.
 */
private class ChainedBuilderAddStep extends AdditionalTaintStep {
  override predicate step(DataFlow::Node src, DataFlow::Node sink) {
    exists(MethodAccess ma |
      ma.getMethod() instanceof BuilderAddMethod and
      src.asExpr() = ma and
      chainedBuilderMethod+(sink.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr()) = ma
    )
  }
}

private MethodAccess chainedBuilderMethod(Expr e) {
  result.getQualifier() = e and
  result.getMethod() instanceof BuilderAddMethod
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

private class MultimapWriteMethod extends TaintPreservingCallable {
  MultimapWriteMethod() {
    this.getDeclaringType() instanceof MultimapType and
    // boolean put(K key, V value)
    // boolean putAll(K key, Iterable<? extends V> values)
    // boolean putAll(Multimap<? extends K,? extends V> multimap)
    // Collection<V> replaceValues(K key, Iterable<? extends V> values)
    this.hasName(["put", "putAll", "replaceValues"])
  }

  override predicate transfersTaint(int src, int sink) {
    src = getNumberOfParameters() - 1 and
    sink = -1
  }
}

private class MultimapReadMethod extends TaintPreservingCallable {
  MultimapReadMethod() {
    this.getDeclaringType() instanceof MultimapType and
    // Collection<V> replaceValues(K key, Iterable<? extends V> values)
    // Collection<V> removeAll(@CompatibleWith("K") Object key)
    // Collection<V> get(K key)
    // Collection<V> values()
    // Collection<Map.Entry<K,V>> entries()
    // Map<K,Collection<V>> asMap()
    this.hasName(["replaceValues", "removeAll", "get", "values", "entries", "asMap"])
  }

  override predicate returnsTaintFrom(int arg) { arg = -1 }
  // Not implemented: Some of these methods return "views", which when modified will modify the map itself.
  // However, taint flow from these views to the map is not implemented.
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

private class TableWriteMethod extends TaintPreservingCallable {
  TableWriteMethod() {
    this.getDeclaringType() instanceof TableType and
    // V put(R rowKey, C columnKey, V value)
    // void putAll(Table<? extends R,? extends C,? extends V> table)
    this.hasName(["put", "putAll"])
  }

  override predicate transfersTaint(int src, int sink) {
    src = getNumberOfParameters() - 1 and
    sink = -1
  }
}

private class TableReadMethod extends TaintPreservingCallable {
  TableReadMethod() {
    this.getDeclaringType() instanceof TableType and
    // V put(R rowKey, C columnKey, V value)
    // V remove(@CompatibleWith("R") Object rowKey, @CompatibleWith("C") Object columnKey)
    // V get(@CompatibleWith("R") Object rowKey, @CompatibleWith("C") Object columnKey)
    // Map<C,V> row(R rowKey)
    // Map<R,V> column(C columnKey)
    // Set<Table.Cell<R,C,V>> cellSet()
    // Collection<V> values()
    // Map<R,Map<C,V>> rowMap()
    // Map<C,Map<R,V>> columnMap()
    this.hasName([
        "put", "remove", "get", "row", "column", "cellSet", "values", "rowMap", "columnMap"
      ])
  }

  override predicate returnsTaintFrom(int arg) { arg = -1 }
  // Not implemented: Some of these methods return "views", which when modified will modify the table itself.
  // However, taint flow from these views to the table is not implemented.
}

private class TableCellReadMethod extends TaintPreservingCallable {
  TableCellReadMethod() {
    exists(NestedType cell |
      cell.getEnclosingType() instanceof TableType and
      cell.hasName("Cell") and
      this.getDeclaringType().getSourceDeclaration().getASourceSupertype*() = cell and
      // V getValue()
      this.hasName("getValue")
    )
  }

  override predicate returnsTaintFrom(int arg) { arg = -1 }
}

/**
 * An `of` static method on the various immutable container types.
 */
private class OfMethod extends TaintPreservingCallable {
  string kind;

  OfMethod() {
    this.getDeclaringType().(ImmutableContainerType).getKind() = kind and
    // static <E> ImmutableList<E> of(E e1, E e2, E e3, E e4, E e5, E e6)
    // static <K,V> ImmutableMap<K,V> of(K k1, V v1, K k2, V v2, K k3, V v3, K k4, V v4)
    // static <K,V> ImmutableMultimap<K,V> of(K k1, V v1, K k2, V v2, K k3, V v3, K k4, V v4)
    // static <R,C,V> ImmutableTable<R,C,V> of(R rowKey, C columnKey, V value)
    // etc for other types and numbers of parameters
    this.hasName("of") and
    this.isStatic()
  }

  override predicate returnsTaintFrom(int arg) {
    arg = [0 .. getNumberOfParameters()] and
    (kind.regexpMatch(".*[Mm]ap") implies arg % 2 = 1) and
    (kind = "ImmutableTable" implies arg % 3 = 2)
  }
}

private class ComparatorType extends RefType {
  ComparatorType() { this.getASourceSupertype*().hasQualifiedName("java.util", "Comparator") }
}

/**
 * A `copyOf`, `sortedCopyOf`, or `copyOfSorted` static method on the various immutable container types.
 */
private class CopyOfMethod extends TaintPreservingCallable {
  CopyOfMethod() {
    this.getDeclaringType() instanceof ImmutableContainerType and
    // static <E> ImmutableList<E> copyOf(E[] elements)
    // static <E> ImmutableList<E> copyOf(Iterable<? extends E> elements)
    // static <E> ImmutableList<E> copyOf(Collection<? extends E> elements)
    // static <E> ImmutableList<E> copyOf(Iterator<? extends E> elements)
    // static <E extends Comparable<? super E>> ImmutableList<E> sortedCopyOf(Iterable<? extends E> elements)
    // static <E> ImmutableList<E> sortedCopyOf(Comparator<? super E> comparator, Iterable<? extends E> elements)
    // static <K,V> ImmutableMap<K,V> copyOf(Map<? extends K,? extends V> map)
    // static <K,V> ImmutableMap<K,V> copyOf(Iterable<? extends Map.Entry<? extends K,? extends V>> entries)
    // static <K,V> ImmutableMultimap<K,V> copyOf(Multimap<? extends K,? extends V> multimap)
    // static <K,V> ImmutableMultimap<K,V> copyOf(Iterable<? extends Map.Entry<? extends K,? extends V>> entries)
    // static <R,C,V> ImmutableTable<R,C,V> copyOf(Table<? extends R,? extends C,? extends V> table)
    // static <K, V> ImmutableSortedMap<K, V> copyOf(Map<? extends K, ? extends V> map)
    // static <K, V> ImmutableSortedMap<K, V> copyOf(Map<? extends K, ? extends V> map, Comparator<? super K> comparator)
    // static <K, V> ImmutableSortedMap<K, V> copyOfSorted(SortedMap<K, ? extends V> map)
    // static <E> ImmutableSortedSet<E> copyOf(Iterator<? extends E> elements)
    // static <E> ImmutableSortedSet<E> copyOf(Comparator<? super E> comparator, Iterator<? extends E> elements)
    // static <E> ImmutableSortedSet<E> copyOfSorted(SortedSet<E> sortedSet)
    // etc
    this.hasName(["copyOf", "sortedCopyOf", "copyOfSorted"]) and
    this.isStatic()
  }

  override predicate returnsTaintFrom(int arg) {
    arg = [0 .. getNumberOfParameters()] and
    not getParameterType(arg) instanceof ComparatorType
  }
}

private class CollectionAsListMethod extends TaintPreservingCallable {
  CollectionAsListMethod() {
    this.getDeclaringType()
        .getASourceSupertype*()
        .hasQualifiedName(guavaCollectPackage(), "ImmutableCollection") and
    // public ImmutableList<E> asList()
    this.hasName("asList")
  }

  override predicate returnsTaintFrom(int arg) { arg = -1 }
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
