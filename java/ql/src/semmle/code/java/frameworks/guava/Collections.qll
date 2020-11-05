/** Defenitions of flow steps through the collection types in the Guava framework */

import java
private import semmle.code.java.dataflow.FlowSteps
private import semmle.code.java.Collections

private string guavaCollectPackage() { result = "com.google.common.collect" }

/** A reference types that extends a parameterization of one of the various immutable container types. */
private class ImmutableContainerType extends RefType {
  string kind;

  ImmutableContainerType() {
    this.getASourceSupertype().hasQualifiedName(guavaCollectPackage(), kind) and
    kind = ["ImmutableCollection", "ImmutableMap", "ImmutableMultimap", "ImmutableTable"]
  }

  /**
   * Gets the name of the most general superclass of this type
   * from among `ImmutableCollection`, `ImmutableMap`, `ImmutableMultimap`, and `ImmutableTable`.
   */
  string getKind() { result = kind }
}

/** A nested `Builder` class of one of the various immutable container classes */
private class CollectionBuilder extends NestedType {
  CollectionBuilder() {
    this.hasName("Builder") and
    this.getEnclosingType() instanceof ImmutableContainerType
  }
}

private class BuilderBuildMethod extends TaintPreservingCallable {
  BuilderBuildMethod() {
    this.getDeclaringType().getASourceSupertype*() instanceof CollectionBuilder and
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
    this.getDeclaringType().getASourceSupertype*() instanceof CollectionBuilder and
    // @CanIgnoreReturnValue abstract ImmutableCollection.Builder<E> add(E element)
    // @CanIgnoreReturnValue ImmutableCollection.Builder<E> add(E... elements)
    // @CanIgnoreReturnValue ImmutableCollection.Builder<E> addAll(Iterable<? extends E> elements)
    // @CanIgnoreReturnValue ImmutableCollection.Builder<E> addAll(Iterator<? extends E> elements)
    // @CanIgnoreReturnValue ImmutableMultiset.Builder<E> addCopies(E element, int occurrences)
    // @CanIgnoreReturnValue ImmutableMultiset.Builder<E> setCount(E element, int count)
    this.hasName(["add", "addAll", "addCopies", "setCount"]) and
    argument = 0
    or
    // @CanIgnoreReturnValue ImmutableMap.Builder<K,V> put(K key, V value)
    // @CanIgnoreReturnValue ImmutableMap.Builder<K,V> put(Map.Entry<? extends K,? extends V> entry)
    // @CanIgnoreReturnValue ImmutableMap.Builder<K,V> putAll(Map<? extends K,? extends V> map)
    // @CanIgnoreReturnValue ImmutableMap.Builder<K,V> putAll(Iterable<? extends Map.Entry<? extends K,? extends V>> entries)
    // @CanIgnoreReturnValue ImmutableMultimap.Builder<K,V> put(K key, V value)
    // @CanIgnoreReturnValue ImmutableMultimap.Builder<K,V> put(Map.Entry<? extends K,? extends V> entry)
    // @CanIgnoreReturnValue ImmutableMultimap.Builder<K,V> putAll(Iterable<? extends Map.Entry<? extends K,? extends V>> entries)
    // @CanIgnoreReturnValue ImmutableMultimap.Builder<K,V> putAll(K key, Iterable<? extends V> values)
    // @CanIgnoreReturnValue ImmutableMultimap.Builder<K,V> putAll(K key, V... values)
    // @CanIgnoreReturnValue ImmutableMultimap.Builder<K,V> putAll(Multimap<? extends K,? extends V> multimap)
    // @CanIgnoreReturnValue ImmutableTable.Builder<R,C,V> put(R rowKey, C columnKey, V value)
    // @CanIgnoreReturnValue ImmutableTable.Builder<R,C,V> put(Table.Cell<? extends R,? extends C,? extends V> cell)
    // @CanIgnoreReturnValue ImmutableTable.Builder<R,C,V> putAll(Table<? extends R,? extends C,? extends V> table)
    this.hasName(["put", "putAll"]) and
    argument = getNumberOfParameters() - 1
  }

  override predicate returnsTaintFrom(int arg) { arg = [-1, argument] }

  override predicate transfersTaint(int src, int sink) { src = argument and sink = -1 }
}

/**
 * A reference type that extends a parameterization of `com.google.common.collect.Multimap`.
 */
class MultimapType extends RefType {
  MultimapType() { this.getASourceSupertype*().hasQualifiedName(guavaCollectPackage(), "Multimap") }

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
    // @CanIgnoreReturnValue boolean put(@Nullable K key, @Nullable V value)
    // @CanIgnoreReturnValue boolean putAll(@Nullable K key, Iterable<? extends V> values)
    // @CanIgnoreReturnValue boolean putAll(Multimap<? extends K,? extends V> multimap)
    // @CanIgnoreReturnValue Collection<V> replaceValues(@Nullable K key, Iterable<? extends V> values)
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
    // @CanIgnoreReturnValue Collection<V> replaceValues(@Nullable K key, Iterable<? extends V> values)
    // @CanIgnoreReturnValue Collection<V> removeAll(@CompatibleWith("K") @Nullable Object key)
    // Collection<V> get(@Nullable K key)
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
  TableType() { this.getASourceSupertype*().hasQualifiedName(guavaCollectPackage(), "Table") }

  /** Gets the type of row keys stored in this table. */
  RefType getRowType() {
    exists(GenericInterface table | table.hasQualifiedName(guavaCollectPackage(), "Table") |
      indirectlyInstantiates(this, table, 0, result)
    )
  }

  /** Gets the type of row keys stored in this table. */
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
    // @CanIgnoreReturnValue @Nullable V put(R rowKey, C columnKey, V value)
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
    // @CanIgnoreReturnValue @Nullable V put(R rowKey, C columnKey, V value)
    // @CanIgnoreReturnValue @Nullable V remove(@CompatibleWith("R") @Nullable Object rowKey, @CompatibleWith("C") @Nullable Object columnKey)
    // @Nullable V get(@CompatibleWith("R") @Nullable Object rowKey, @CompatibleWith("C") @Nullable Object columnKey)
    // Map<C,V> row(R rowKey)
    // Map<R,V> column(C columnKey)
    // Set<Table.Cell<R,C,V>> cellSet()
    // Collection<V> values()
    // Map<R,Map<C,V>> rowMap()
    // Map<C,Map<R,V>> columnMap()
    this
        .hasName(["put", "remove", "get", "row", "column", "cellSet", "values", "rowMap",
              "columnMap"])
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
      this.getDeclaringType().getASourceSupertype*() = cell and
      // @Nullable V getValue()
      this.hasName("getValue")
    )
  }

  override predicate returnsTaintFrom(int arg) { arg = -1 }
}

/**
 * An `of` static method on the various immutable collection types.
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
    (kind.matches("%Map") implies arg % 2 = 1) and
    (kind = "ImmutableTable" implies arg % 3 = 2)
  }
}

/**
 * A `copyOf` or `sortedCopyOf` static method on the varios immutable collection types.
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
    // static <R,C,V> ImmutableTable<R,C,V> copyOf  (Table<? extends R,? extends C,? extends V> table)
    this.hasName(["copyOf", "sortedCopyOf"]) and
    this.isStatic()
  }

  override predicate returnsTaintFrom(int arg) { arg = getNumberOfParameters() - 1 }
}
