/**
 * Provides classes related to the namespace `System.Data.Common`.
 */

private import csharp as CSharp
private import semmle.code.csharp.frameworks.system.Data as Data
private import semmle.code.csharp.dataflow.ExternalFlow as ExternalFlow

/** Definitions relating to the `System.Data.Common` namespace. */
module SystemDataCommon {
  /** The `System.Data.Common` namespace. */
  class Namespace extends CSharp::Namespace {
    Namespace() {
      this.getParentNamespace() instanceof Data::SystemDataNamespace and
      this.hasName("Common")
    }
  }

  /** A class in the `System.Data.Common` namespace. */
  class Class extends CSharp::Class {
    Class() { this.getNamespace() instanceof Namespace }
  }

  /** The `System.Data.Common.DbDataReader` class. */
  class DbDataReader extends Class {
    DbDataReader() { this.hasName("DbDataReader") }
  }

  /** The `System.Data.Common.DbException` class. */
  class DbException extends Class {
    DbException() { this.hasName("DbException") }
  }
}

/** Data flow for `System.Data.Common.DbConnectionStringBuilder`. */
private class SystemDataCommonDbConnectionStringBuilderFlowModelCsv extends ExternalFlow::SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Data.Common;DbConnectionStringBuilder;false;Add;(System.String,System.Object);;Argument[0];Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value",
        "System.Data.Common;DbConnectionStringBuilder;false;Add;(System.String,System.Object);;Argument[1];Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value",
        "System.Data.Common;DbConnectionStringBuilder;false;get_Item;(System.String);;Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];ReturnValue;value",
        "System.Data.Common;DbConnectionStringBuilder;false;set_Item;(System.String,System.Object);;Argument[0];Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Key];value",
        "System.Data.Common;DbConnectionStringBuilder;false;set_Item;(System.String,System.Object);;Argument[1];Argument[Qualifier].Element.Property[System.Collections.Generic.KeyValuePair<,>.Value];value",
      ]
  }
}

/** Data flow for `System.Data.Common.DataColumnMappingCollection`. */
private class SystemDataCommonDataColumnMappingCollectionFlowModelCsv extends ExternalFlow::SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Data.Common;DataColumnMappingCollection;false;AddRange;(System.Array);;Argument[0].Element;Argument[Qualifier].Element;value",
        "System.Data.Common;DataColumnMappingCollection;false;AddRange;(System.Data.Common.DataColumnMapping[]);;Argument[0].Element;Argument[Qualifier].Element;value",
        "System.Data.Common;DataColumnMappingCollection;false;CopyTo;(System.Data.Common.DataColumnMapping[],System.Int32);;Argument[Qualifier].Element;Argument[0].Element;value",
        "System.Data.Common;DataColumnMappingCollection;false;Insert;(System.Int32,System.Data.Common.DataColumnMapping);;Argument[1];Argument[Qualifier].Element;value",
        "System.Data.Common;DataColumnMappingCollection;false;get_Item;(System.Int32);;Argument[Qualifier].Element;ReturnValue;value",
        "System.Data.Common;DataColumnMappingCollection;false;get_Item;(System.String);;Argument[Qualifier].Element;ReturnValue;value",
        "System.Data.Common;DataColumnMappingCollection;false;set_Item;(System.Int32,System.Data.Common.DataColumnMapping);;Argument[1];Argument[Qualifier].Element;value",
        "System.Data.Common;DataColumnMappingCollection;false;set_Item;(System.String,System.Data.Common.DataColumnMapping);;Argument[1];Argument[Qualifier].Element;value",
      ]
  }
}

/** Data flow for `System.Data.Common.DataTableMappingCollection`. */
private class SystemDataCommonDataTableMappingCollectionFlowModelCsv extends ExternalFlow::SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Data.Common;DataTableMappingCollection;false;AddRange;(System.Array);;Argument[0].Element;Argument[Qualifier].Element;value",
        "System.Data.Common;DataTableMappingCollection;false;AddRange;(System.Data.Common.DataTableMapping[]);;Argument[0].Element;Argument[Qualifier].Element;value",
        "System.Data.Common;DataTableMappingCollection;false;CopyTo;(System.Data.Common.DataTableMapping[],System.Int32);;Argument[Qualifier].Element;Argument[0].Element;value",
        "System.Data.Common;DataTableMappingCollection;false;Insert;(System.Int32,System.Data.Common.DataTableMapping);;Argument[1];Argument[Qualifier].Element;value",
        "System.Data.Common;DataTableMappingCollection;false;get_Item;(System.Int32);;Argument[Qualifier].Element;ReturnValue;value",
        "System.Data.Common;DataTableMappingCollection;false;get_Item;(System.String);;Argument[Qualifier].Element;ReturnValue;value",
        "System.Data.Common;DataTableMappingCollection;false;set_Item;(System.Int32,System.Data.Common.DataTableMapping);;Argument[1];Argument[Qualifier].Element;value",
        "System.Data.Common;DataTableMappingCollection;false;set_Item;(System.String,System.Data.Common.DataTableMapping);;Argument[1];Argument[Qualifier].Element;value",
      ]
  }
}

/** Data flow for `System.Data.Common.DbParameterCollection`. */
private class SystemDataCommonDbParameterCollectionFlowModelCsv extends ExternalFlow::SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Data.Common;DbParameterCollection;false;get_Item;(System.Int32);;Argument[Qualifier].Element;ReturnValue;value",
        "System.Data.Common;DbParameterCollection;false;get_Item;(System.String);;Argument[Qualifier].Element;ReturnValue;value",
        "System.Data.Common;DbParameterCollection;false;set_Item;(System.Int32,System.Data.Common.DbParameter);;Argument[1];Argument[Qualifier].Element;value",
        "System.Data.Common;DbParameterCollection;false;set_Item;(System.String,System.Data.Common.DbParameter);;Argument[1];Argument[Qualifier].Element;value",
        "System.Data.Common;DbParameterCollection;true;Add;(System.Object);;Argument[0];Argument[Qualifier].Element;value",
        "System.Data.Common;DbParameterCollection;true;AddRange;(System.Array);;Argument[0].Element;Argument[Qualifier].Element;value",
        "System.Data.Common;DbParameterCollection;true;Insert;(System.Int32,System.Object);;Argument[1];Argument[Qualifier].Element;value",
      ]
  }
}
