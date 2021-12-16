/** Provides definitions related to the namespace `System.Data`. */

import csharp
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.dataflow.ExternalFlow

/** The `System.Data` namespace. */
class SystemDataNamespace extends Namespace {
  SystemDataNamespace() {
    this.getParentNamespace() instanceof SystemNamespace and
    this.hasName("Data")
  }
}

/** An interface in the `System.Data` namespace. */
class SystemDataInterface extends Interface {
  SystemDataInterface() { this.getNamespace() instanceof SystemDataNamespace }
}

/** The `System.Data.IDbCommand` interface. */
class SystemDataIDbCommandInterface extends SystemDataInterface {
  SystemDataIDbCommandInterface() { this.hasName("IDbCommand") }

  /** Gets the `CommandText` property. */
  Property getCommandTextProperty() {
    result.getDeclaringType() = this and
    result.hasName("CommandText") and
    result.getType() instanceof StringType
  }
}

/** The `System.Data.IDbConnection` interface. */
class SystemDataIDbConnectionInterface extends SystemDataInterface {
  SystemDataIDbConnectionInterface() { this.hasName("IDbConnection") }

  /** Gets the `ConnectionString` property. */
  Property getAConnectionStringProperty() { result = this.getProperty("ConnectionString") }
}

/** A class that implements `System.Data.IDbConnection`. */
class SystemDataConnectionClass extends Class {
  SystemDataConnectionClass() { this.getABaseType+() instanceof SystemDataIDbConnectionInterface }

  /** Gets the `ConnectionString` property. */
  Property getConnectionStringProperty() { result = this.getProperty("ConnectionString") }
}

/** Data flow for `System.Data.EnumerableRowCollectionExtensions`. */
private class SystemDataEnumerableRowCollectionsExtensionsFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Data;EnumerableRowCollectionExtensions;false;Cast<>;(System.Data.EnumerableRowCollection);;Element of Argument[0];Element of ReturnValue;value",
        "System.Data;EnumerableRowCollectionExtensions;false;OrderBy<,>;(System.Data.EnumerableRowCollection<TRow>,System.Func<TRow,TKey>);;Element of Argument[0];Element of ReturnValue;value",
        "System.Data;EnumerableRowCollectionExtensions;false;OrderBy<,>;(System.Data.EnumerableRowCollection<TRow>,System.Func<TRow,TKey>);;Element of Argument[0];Parameter[0] of Argument[1];value",
        "System.Data;EnumerableRowCollectionExtensions;false;OrderBy<,>;(System.Data.EnumerableRowCollection<TRow>,System.Func<TRow,TKey>,System.Collections.Generic.IComparer<TKey>);;Element of Argument[0];Element of ReturnValue;value",
        "System.Data;EnumerableRowCollectionExtensions;false;OrderBy<,>;(System.Data.EnumerableRowCollection<TRow>,System.Func<TRow,TKey>,System.Collections.Generic.IComparer<TKey>);;Element of Argument[0];Parameter[0] of Argument[1];value",
        "System.Data;EnumerableRowCollectionExtensions;false;OrderByDescending<,>;(System.Data.EnumerableRowCollection<TRow>,System.Func<TRow,TKey>);;Element of Argument[0];Element of ReturnValue;value",
        "System.Data;EnumerableRowCollectionExtensions;false;OrderByDescending<,>;(System.Data.EnumerableRowCollection<TRow>,System.Func<TRow,TKey>);;Element of Argument[0];Parameter[0] of Argument[1];value",
        "System.Data;EnumerableRowCollectionExtensions;false;OrderByDescending<,>;(System.Data.EnumerableRowCollection<TRow>,System.Func<TRow,TKey>,System.Collections.Generic.IComparer<TKey>);;Element of Argument[0];Element of ReturnValue;value",
        "System.Data;EnumerableRowCollectionExtensions;false;OrderByDescending<,>;(System.Data.EnumerableRowCollection<TRow>,System.Func<TRow,TKey>,System.Collections.Generic.IComparer<TKey>);;Element of Argument[0];Parameter[0] of Argument[1];value",
        "System.Data;EnumerableRowCollectionExtensions;false;Select<,>;(System.Data.EnumerableRowCollection<TRow>,System.Func<TRow,S>);;Element of Argument[0];Parameter[0] of Argument[1];value",
        "System.Data;EnumerableRowCollectionExtensions;false;Select<,>;(System.Data.EnumerableRowCollection<TRow>,System.Func<TRow,S>);;ReturnValue of Argument[1];Element of ReturnValue;value",
        "System.Data;EnumerableRowCollectionExtensions;false;ThenBy<,>;(System.Data.OrderedEnumerableRowCollection<TRow>,System.Func<TRow,TKey>);;Element of Argument[0];Element of ReturnValue;value",
        "System.Data;EnumerableRowCollectionExtensions;false;ThenBy<,>;(System.Data.OrderedEnumerableRowCollection<TRow>,System.Func<TRow,TKey>);;Element of Argument[0];Parameter[0] of Argument[1];value",
        "System.Data;EnumerableRowCollectionExtensions;false;ThenBy<,>;(System.Data.OrderedEnumerableRowCollection<TRow>,System.Func<TRow,TKey>,System.Collections.Generic.IComparer<TKey>);;Element of Argument[0];Element of ReturnValue;value",
        "System.Data;EnumerableRowCollectionExtensions;false;ThenBy<,>;(System.Data.OrderedEnumerableRowCollection<TRow>,System.Func<TRow,TKey>,System.Collections.Generic.IComparer<TKey>);;Element of Argument[0];Parameter[0] of Argument[1];value",
        "System.Data;EnumerableRowCollectionExtensions;false;ThenByDescending<,>;(System.Data.OrderedEnumerableRowCollection<TRow>,System.Func<TRow,TKey>);;Element of Argument[0];Element of ReturnValue;value",
        "System.Data;EnumerableRowCollectionExtensions;false;ThenByDescending<,>;(System.Data.OrderedEnumerableRowCollection<TRow>,System.Func<TRow,TKey>);;Element of Argument[0];Parameter[0] of Argument[1];value",
        "System.Data;EnumerableRowCollectionExtensions;false;ThenByDescending<,>;(System.Data.OrderedEnumerableRowCollection<TRow>,System.Func<TRow,TKey>,System.Collections.Generic.IComparer<TKey>);;Element of Argument[0];Element of ReturnValue;value",
        "System.Data;EnumerableRowCollectionExtensions;false;ThenByDescending<,>;(System.Data.OrderedEnumerableRowCollection<TRow>,System.Func<TRow,TKey>,System.Collections.Generic.IComparer<TKey>);;Element of Argument[0];Parameter[0] of Argument[1];value",
        "System.Data;EnumerableRowCollectionExtensions;false;Where<>;(System.Data.EnumerableRowCollection<TRow>,System.Func<TRow,System.Boolean>);;Element of Argument[0];Element of ReturnValue;value",
        "System.Data;EnumerableRowCollectionExtensions;false;Where<>;(System.Data.EnumerableRowCollection<TRow>,System.Func<TRow,System.Boolean>);;Element of Argument[0];Parameter[0] of Argument[1];value",
      ]
  }
}

/** Data flow for `System.Data.TypedTableBaseExtensions`. */
private class SystemDataTypedTableBaseExtensionsFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Data;TypedTableBaseExtensions;false;AsEnumerable<>;(System.Data.TypedTableBase<TRow>);;Element of Argument[0];Element of ReturnValue;value",
        "System.Data;TypedTableBaseExtensions;false;ElementAtOrDefault<>;(System.Data.TypedTableBase<TRow>,System.Int32);;Element of Argument[0];ReturnValue;value",
        "System.Data;TypedTableBaseExtensions;false;OrderBy<,>;(System.Data.TypedTableBase<TRow>,System.Func<TRow,TKey>);;Element of Argument[0];Element of ReturnValue;value",
        "System.Data;TypedTableBaseExtensions;false;OrderBy<,>;(System.Data.TypedTableBase<TRow>,System.Func<TRow,TKey>);;Element of Argument[0];Parameter[0] of Argument[1];value",
        "System.Data;TypedTableBaseExtensions;false;OrderBy<,>;(System.Data.TypedTableBase<TRow>,System.Func<TRow,TKey>,System.Collections.Generic.IComparer<TKey>);;Element of Argument[0];Element of ReturnValue;value",
        "System.Data;TypedTableBaseExtensions;false;OrderBy<,>;(System.Data.TypedTableBase<TRow>,System.Func<TRow,TKey>,System.Collections.Generic.IComparer<TKey>);;Element of Argument[0];Parameter[0] of Argument[1];value",
        "System.Data;TypedTableBaseExtensions;false;OrderByDescending<,>;(System.Data.TypedTableBase<TRow>,System.Func<TRow,TKey>);;Element of Argument[0];Element of ReturnValue;value",
        "System.Data;TypedTableBaseExtensions;false;OrderByDescending<,>;(System.Data.TypedTableBase<TRow>,System.Func<TRow,TKey>);;Element of Argument[0];Parameter[0] of Argument[1];value",
        "System.Data;TypedTableBaseExtensions;false;OrderByDescending<,>;(System.Data.TypedTableBase<TRow>,System.Func<TRow,TKey>,System.Collections.Generic.IComparer<TKey>);;Element of Argument[0];Element of ReturnValue;value",
        "System.Data;TypedTableBaseExtensions;false;OrderByDescending<,>;(System.Data.TypedTableBase<TRow>,System.Func<TRow,TKey>,System.Collections.Generic.IComparer<TKey>);;Element of Argument[0];Parameter[0] of Argument[1];value",
        "System.Data;TypedTableBaseExtensions;false;Select<,>;(System.Data.TypedTableBase<TRow>,System.Func<TRow,S>);;Element of Argument[0];Parameter[0] of Argument[1];value",
        "System.Data;TypedTableBaseExtensions;false;Select<,>;(System.Data.TypedTableBase<TRow>,System.Func<TRow,S>);;ReturnValue of Argument[1];Element of ReturnValue;value",
        "System.Data;TypedTableBaseExtensions;false;Where<>;(System.Data.TypedTableBase<TRow>,System.Func<TRow,System.Boolean>);;Element of Argument[0];Element of ReturnValue;value",
        "System.Data;TypedTableBaseExtensions;false;Where<>;(System.Data.TypedTableBase<TRow>,System.Func<TRow,System.Boolean>);;Element of Argument[0];Parameter[0] of Argument[1];value",
      ]
  }
}
