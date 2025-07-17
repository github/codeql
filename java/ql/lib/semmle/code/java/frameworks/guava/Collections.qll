/** Definitions of flow steps through the collection types in the Guava framework */
overlay[local?]
module;

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.FlowSteps
private import semmle.code.java.Collections

private string guavaCollectPackage() { result = "com.google.common.collect" }

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
