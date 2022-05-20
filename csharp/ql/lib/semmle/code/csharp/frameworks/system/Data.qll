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
        "System.Data;EnumerableRowCollectionExtensions;false;Cast<>;(System.Data.EnumerableRowCollection);;Argument[0].Element;ReturnValue.Element;value",
        "System.Data;EnumerableRowCollectionExtensions;false;OrderBy<,>;(System.Data.EnumerableRowCollection<TRow>,System.Func<TRow,TKey>);;Argument[0].Element;ReturnValue.Element;value",
        "System.Data;EnumerableRowCollectionExtensions;false;OrderBy<,>;(System.Data.EnumerableRowCollection<TRow>,System.Func<TRow,TKey>);;Argument[0].Element;Argument[1].Parameter[0];value",
        "System.Data;EnumerableRowCollectionExtensions;false;OrderBy<,>;(System.Data.EnumerableRowCollection<TRow>,System.Func<TRow,TKey>,System.Collections.Generic.IComparer<TKey>);;Argument[0].Element;ReturnValue.Element;value",
        "System.Data;EnumerableRowCollectionExtensions;false;OrderBy<,>;(System.Data.EnumerableRowCollection<TRow>,System.Func<TRow,TKey>,System.Collections.Generic.IComparer<TKey>);;Argument[0].Element;Argument[1].Parameter[0];value",
        "System.Data;EnumerableRowCollectionExtensions;false;OrderByDescending<,>;(System.Data.EnumerableRowCollection<TRow>,System.Func<TRow,TKey>);;Argument[0].Element;ReturnValue.Element;value",
        "System.Data;EnumerableRowCollectionExtensions;false;OrderByDescending<,>;(System.Data.EnumerableRowCollection<TRow>,System.Func<TRow,TKey>);;Argument[0].Element;Argument[1].Parameter[0];value",
        "System.Data;EnumerableRowCollectionExtensions;false;OrderByDescending<,>;(System.Data.EnumerableRowCollection<TRow>,System.Func<TRow,TKey>,System.Collections.Generic.IComparer<TKey>);;Argument[0].Element;ReturnValue.Element;value",
        "System.Data;EnumerableRowCollectionExtensions;false;OrderByDescending<,>;(System.Data.EnumerableRowCollection<TRow>,System.Func<TRow,TKey>,System.Collections.Generic.IComparer<TKey>);;Argument[0].Element;Argument[1].Parameter[0];value",
        "System.Data;EnumerableRowCollectionExtensions;false;Select<,>;(System.Data.EnumerableRowCollection<TRow>,System.Func<TRow,S>);;Argument[0].Element;Argument[1].Parameter[0];value",
        "System.Data;EnumerableRowCollectionExtensions;false;Select<,>;(System.Data.EnumerableRowCollection<TRow>,System.Func<TRow,S>);;Argument[1].ReturnValue;ReturnValue.Element;value",
        "System.Data;EnumerableRowCollectionExtensions;false;ThenBy<,>;(System.Data.OrderedEnumerableRowCollection<TRow>,System.Func<TRow,TKey>);;Argument[0].Element;ReturnValue.Element;value",
        "System.Data;EnumerableRowCollectionExtensions;false;ThenBy<,>;(System.Data.OrderedEnumerableRowCollection<TRow>,System.Func<TRow,TKey>);;Argument[0].Element;Argument[1].Parameter[0];value",
        "System.Data;EnumerableRowCollectionExtensions;false;ThenBy<,>;(System.Data.OrderedEnumerableRowCollection<TRow>,System.Func<TRow,TKey>,System.Collections.Generic.IComparer<TKey>);;Argument[0].Element;ReturnValue.Element;value",
        "System.Data;EnumerableRowCollectionExtensions;false;ThenBy<,>;(System.Data.OrderedEnumerableRowCollection<TRow>,System.Func<TRow,TKey>,System.Collections.Generic.IComparer<TKey>);;Argument[0].Element;Argument[1].Parameter[0];value",
        "System.Data;EnumerableRowCollectionExtensions;false;ThenByDescending<,>;(System.Data.OrderedEnumerableRowCollection<TRow>,System.Func<TRow,TKey>);;Argument[0].Element;ReturnValue.Element;value",
        "System.Data;EnumerableRowCollectionExtensions;false;ThenByDescending<,>;(System.Data.OrderedEnumerableRowCollection<TRow>,System.Func<TRow,TKey>);;Argument[0].Element;Argument[1].Parameter[0];value",
        "System.Data;EnumerableRowCollectionExtensions;false;ThenByDescending<,>;(System.Data.OrderedEnumerableRowCollection<TRow>,System.Func<TRow,TKey>,System.Collections.Generic.IComparer<TKey>);;Argument[0].Element;ReturnValue.Element;value",
        "System.Data;EnumerableRowCollectionExtensions;false;ThenByDescending<,>;(System.Data.OrderedEnumerableRowCollection<TRow>,System.Func<TRow,TKey>,System.Collections.Generic.IComparer<TKey>);;Argument[0].Element;Argument[1].Parameter[0];value",
        "System.Data;EnumerableRowCollectionExtensions;false;Where<>;(System.Data.EnumerableRowCollection<TRow>,System.Func<TRow,System.Boolean>);;Argument[0].Element;ReturnValue.Element;value",
        "System.Data;EnumerableRowCollectionExtensions;false;Where<>;(System.Data.EnumerableRowCollection<TRow>,System.Func<TRow,System.Boolean>);;Argument[0].Element;Argument[1].Parameter[0];value",
      ]
  }
}

/** Data flow for `System.Data.TypedTableBaseExtensions`. */
private class SystemDataTypedTableBaseExtensionsFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Data;TypedTableBaseExtensions;false;AsEnumerable<>;(System.Data.TypedTableBase<TRow>);;Argument[0].Element;ReturnValue.Element;value",
        "System.Data;TypedTableBaseExtensions;false;ElementAtOrDefault<>;(System.Data.TypedTableBase<TRow>,System.Int32);;Argument[0].Element;ReturnValue;value",
        "System.Data;TypedTableBaseExtensions;false;OrderBy<,>;(System.Data.TypedTableBase<TRow>,System.Func<TRow,TKey>);;Argument[0].Element;ReturnValue.Element;value",
        "System.Data;TypedTableBaseExtensions;false;OrderBy<,>;(System.Data.TypedTableBase<TRow>,System.Func<TRow,TKey>);;Argument[0].Element;Argument[1].Parameter[0];value",
        "System.Data;TypedTableBaseExtensions;false;OrderBy<,>;(System.Data.TypedTableBase<TRow>,System.Func<TRow,TKey>,System.Collections.Generic.IComparer<TKey>);;Argument[0].Element;ReturnValue.Element;value",
        "System.Data;TypedTableBaseExtensions;false;OrderBy<,>;(System.Data.TypedTableBase<TRow>,System.Func<TRow,TKey>,System.Collections.Generic.IComparer<TKey>);;Argument[0].Element;Argument[1].Parameter[0];value",
        "System.Data;TypedTableBaseExtensions;false;OrderByDescending<,>;(System.Data.TypedTableBase<TRow>,System.Func<TRow,TKey>);;Argument[0].Element;ReturnValue.Element;value",
        "System.Data;TypedTableBaseExtensions;false;OrderByDescending<,>;(System.Data.TypedTableBase<TRow>,System.Func<TRow,TKey>);;Argument[0].Element;Argument[1].Parameter[0];value",
        "System.Data;TypedTableBaseExtensions;false;OrderByDescending<,>;(System.Data.TypedTableBase<TRow>,System.Func<TRow,TKey>,System.Collections.Generic.IComparer<TKey>);;Argument[0].Element;ReturnValue.Element;value",
        "System.Data;TypedTableBaseExtensions;false;OrderByDescending<,>;(System.Data.TypedTableBase<TRow>,System.Func<TRow,TKey>,System.Collections.Generic.IComparer<TKey>);;Argument[0].Element;Argument[1].Parameter[0];value",
        "System.Data;TypedTableBaseExtensions;false;Select<,>;(System.Data.TypedTableBase<TRow>,System.Func<TRow,S>);;Argument[0].Element;Argument[1].Parameter[0];value",
        "System.Data;TypedTableBaseExtensions;false;Select<,>;(System.Data.TypedTableBase<TRow>,System.Func<TRow,S>);;Argument[1].ReturnValue;ReturnValue.Element;value",
        "System.Data;TypedTableBaseExtensions;false;Where<>;(System.Data.TypedTableBase<TRow>,System.Func<TRow,System.Boolean>);;Argument[0].Element;ReturnValue.Element;value",
        "System.Data;TypedTableBaseExtensions;false;Where<>;(System.Data.TypedTableBase<TRow>,System.Func<TRow,System.Boolean>);;Argument[0].Element;Argument[1].Parameter[0];value",
      ]
  }
}

/** Data flow for `System.Data.DataView`. */
private class SystemDataDataViewFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Data;DataView;false;Find;(System.Object);;Argument[Qualifier].Element;ReturnValue;value",
        "System.Data;DataView;false;Find;(System.Object[]);;Argument[Qualifier].Element;ReturnValue;value",
        "System.Data;DataView;false;get_Item;(System.Int32);;Argument[Qualifier].Element;ReturnValue;value",
      ]
  }
}

/** Data flow for `System.Data.IColumnMappingCollection`. */
private class SystemDataIColumnMappingCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Data;IColumnMappingCollection;true;get_Item;(System.String);;Argument[Qualifier].Element;ReturnValue;value",
        "System.Data;IColumnMappingCollection;true;set_Item;(System.String,System.Object);;Argument[1];Argument[Qualifier].Element;value",
      ]
  }
}

/** Data flow for `System.Data.IDataParameterCollection`. */
private class SystemDataIDataParameterCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Data;IDataParameterCollection;true;get_Item;(System.String);;Argument[Qualifier].Element;ReturnValue;value",
        "System.Data;IDataParameterCollection;true;set_Item;(System.String,System.Object);;Argument[1];Argument[Qualifier].Element;value",
      ]
  }
}

/** Data flow for `System.Data.ITableMappingCollection`. */
private class SystemDataITableMappingCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Data;ITableMappingCollection;true;get_Item;(System.String);;Argument[Qualifier].Element;ReturnValue;value",
        "System.Data;ITableMappingCollection;true;set_Item;(System.String,System.Object);;Argument[1];Argument[Qualifier].Element;value",
      ]
  }
}

/** Data flow for `System.Data.ConstraintCollection`. */
private class SystemDataConstraintCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Data;ConstraintCollection;false;Add;(System.Data.Constraint);;Argument[0];Argument[Qualifier].Element;value",
        "System.Data;ConstraintCollection;false;AddRange;(System.Data.Constraint[]);;Argument[0].Element;Argument[Qualifier].Element;value",
        "System.Data;ConstraintCollection;false;CopyTo;(System.Data.Constraint[],System.Int32);;Argument[Qualifier].Element;Argument[0].Element;value",
      ]
  }
}

/** Data flow for `System.Data.DataColumnCollection`. */
private class SystemDataDataColumnCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Data;DataColumnCollection;false;Add;(System.Data.DataColumn);;Argument[0];Argument[Qualifier].Element;value",
        "System.Data;DataColumnCollection;false;Add;(System.String);;Argument[0];Argument[Qualifier].Element;value",
        "System.Data;DataColumnCollection;false;AddRange;(System.Data.DataColumn[]);;Argument[0].Element;Argument[Qualifier].Element;value",
        "System.Data;DataColumnCollection;false;CopyTo;(System.Data.DataColumn[],System.Int32);;Argument[Qualifier].Element;Argument[0].Element;value",
      ]
  }
}

/** Data flow for `System.Data.DataRelationCollection`. */
private class SystemDataDataRelationCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Data;DataRelationCollection;false;Add;(System.Data.DataRelation);;Argument[0];Argument[Qualifier].Element;value",
        "System.Data;DataRelationCollection;false;CopyTo;(System.Data.DataRelation[],System.Int32);;Argument[Qualifier].Element;Argument[0].Element;value",
        "System.Data;DataRelationCollection;true;AddRange;(System.Data.DataRelation[]);;Argument[0].Element;Argument[Qualifier].Element;value",
      ]
  }
}

/** Data flow for `System.Data.DataRawCollection`. */
private class SystemDataDataRawCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Data;DataRowCollection;false;Add;(System.Data.DataRow);;Argument[0];Argument[Qualifier].Element;value",
        "System.Data;DataRowCollection;false;Add;(System.Object[]);;Argument[0];Argument[Qualifier].Element;value",
        "System.Data;DataRowCollection;false;CopyTo;(System.Data.DataRow[],System.Int32);;Argument[Qualifier].Element;Argument[0].Element;value",
        "System.Data;DataRowCollection;false;Find;(System.Object);;Argument[Qualifier].Element;ReturnValue;value",
        "System.Data;DataRowCollection;false;Find;(System.Object[]);;Argument[Qualifier].Element;ReturnValue;value",
      ]
  }
}

/** Data flow for `System.Data.DataTableCollection`. */
private class SystemDataDataTableCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Data;DataTableCollection;false;Add;(System.Data.DataTable);;Argument[0];Argument[Qualifier].Element;value",
        "System.Data;DataTableCollection;false;Add;(System.String);;Argument[0];Argument[Qualifier].Element;value",
        "System.Data;DataTableCollection;false;AddRange;(System.Data.DataTable[]);;Argument[0].Element;Argument[Qualifier].Element;value",
        "System.Data;DataTableCollection;false;CopyTo;(System.Data.DataTable[],System.Int32);;Argument[Qualifier].Element;Argument[0].Element;value",
      ]
  }
}

/** Data flow for `System.Data.DataViewSettingCollection`. */
private class SystemDataDataViewSettingCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Data;DataViewSettingCollection;false;CopyTo;(System.Data.DataViewSetting[],System.Int32);;Argument[Qualifier].Element;Argument[0].Element;value"
  }
}

/** Data flow for `System.Data.PropertyCollection`. */
private class SystemDataPropertyCollectionFlowModelCsv extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      "System.Data;PropertyCollection;false;Clone;();;Argument[0].Element;ReturnValue.Element;value"
  }
}
