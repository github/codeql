/**
 * Provides classes related to the namespace `System.Data.Common`.
 */

private import csharp as csharp
private import semmle.code.csharp.frameworks.system.Data as Data
private import semmle.code.csharp.dataflow.ExternalFlow as ExternalFlow

/** Definitions relating to the `System.Data.Common` namespace. */
module SystemDataCommon {
  /** The `System.Data.Common` namespace. */
  class Namespace extends csharp::Namespace {
    Namespace() {
      this.getParentNamespace() instanceof Data::SystemDataNamespace and
      this.hasName("Common")
    }
  }

  /** A class in the `System.Data.Common` namespace. */
  class Class extends csharp::Class {
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
        "System.Data.Common;DbConnectionStringBuilder;false;Add;(System.String,System.Object);;Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[-1];value",
        "System.Data.Common;DbConnectionStringBuilder;false;Add;(System.String,System.Object);;Argument[1];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];value",
        "System.Data.Common;DbConnectionStringBuilder;false;get_Item;(System.String);;Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];ReturnValue;value",
        "System.Data.Common;DbConnectionStringBuilder;false;set_Item;(System.String,System.Object);;Argument[0];Property[System.Collections.Generic.KeyValuePair<,>.Key] of Element of Argument[-1];value",
        "System.Data.Common;DbConnectionStringBuilder;false;set_Item;(System.String,System.Object);;Argument[1];Property[System.Collections.Generic.KeyValuePair<,>.Value] of Element of Argument[-1];value",
      ]
  }
}

/** Data flow for `System.Data.Common.DataColumnMappingCollection`. */
private class SystemDataCommonDataColumnMappingCollectionFlowModelCsv extends ExternalFlow::SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Data.Common;DataColumnMappingCollection;false;AddRange;(System.Array);;Element of Argument[0];Element of Argument[-1];value",
        "System.Data.Common;DataColumnMappingCollection;false;AddRange;(System.Data.Common.DataColumnMapping[]);;Element of Argument[0];Element of Argument[-1];value",
        "System.Data.Common;DataColumnMappingCollection;false;CopyTo;(System.Data.Common.DataColumnMapping[],System.Int32);;Element of Argument[-1];Element of Argument[0];value",
        "System.Data.Common;DataColumnMappingCollection;false;Insert;(System.Int32,System.Data.Common.DataColumnMapping);;Argument[1];Element of Argument[-1];value",
        "System.Data.Common;DataColumnMappingCollection;false;get_Item;(System.Int32);;Element of Argument[-1];ReturnValue;value",
        "System.Data.Common;DataColumnMappingCollection;false;get_Item;(System.String);;Element of Argument[-1];ReturnValue;value",
        "System.Data.Common;DataColumnMappingCollection;false;set_Item;(System.Int32,System.Data.Common.DataColumnMapping);;Argument[1];Element of Argument[-1];value",
        "System.Data.Common;DataColumnMappingCollection;false;set_Item;(System.String,System.Data.Common.DataColumnMapping);;Argument[1];Element of Argument[-1];value",
      ]
  }
}

/** Data flow for `System.Data.Common.DataTableMappingCollection`. */
private class SystemDataCommonDataTableMappingCollectionFlowModelCsv extends ExternalFlow::SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Data.Common;DataTableMappingCollection;false;AddRange;(System.Array);;Element of Argument[0];Element of Argument[-1];value",
        "System.Data.Common;DataTableMappingCollection;false;AddRange;(System.Data.Common.DataTableMapping[]);;Element of Argument[0];Element of Argument[-1];value",
        "System.Data.Common;DataTableMappingCollection;false;CopyTo;(System.Data.Common.DataTableMapping[],System.Int32);;Element of Argument[-1];Element of Argument[0];value",
        "System.Data.Common;DataTableMappingCollection;false;Insert;(System.Int32,System.Data.Common.DataTableMapping);;Argument[1];Element of Argument[-1];value",
        "System.Data.Common;DataTableMappingCollection;false;get_Item;(System.Int32);;Element of Argument[-1];ReturnValue;value",
        "System.Data.Common;DataTableMappingCollection;false;get_Item;(System.String);;Element of Argument[-1];ReturnValue;value",
        "System.Data.Common;DataTableMappingCollection;false;set_Item;(System.Int32,System.Data.Common.DataTableMapping);;Argument[1];Element of Argument[-1];value",
        "System.Data.Common;DataTableMappingCollection;false;set_Item;(System.String,System.Data.Common.DataTableMapping);;Argument[1];Element of Argument[-1];value",
      ]
  }
}

/** Data flow for `System.Data.Common.DbParameterCollection`. */
private class SystemDataCommonDbParameterCollectionFlowModelCsv extends ExternalFlow::SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "System.Data.Common;DbParameterCollection;false;get_Item;(System.Int32);;Element of Argument[-1];ReturnValue;value",
        "System.Data.Common;DbParameterCollection;false;get_Item;(System.String);;Element of Argument[-1];ReturnValue;value",
        "System.Data.Common;DbParameterCollection;false;set_Item;(System.Int32,System.Data.Common.DbParameter);;Argument[1];Element of Argument[-1];value",
        "System.Data.Common;DbParameterCollection;false;set_Item;(System.String,System.Data.Common.DbParameter);;Argument[1];Element of Argument[-1];value",
        "System.Data.Common;DbParameterCollection;true;Add;(System.Object);;Argument[0];Element of Argument[-1];value",
        "System.Data.Common;DbParameterCollection;true;AddRange;(System.Array);;Element of Argument[0];Element of Argument[-1];value",
        "System.Data.Common;DbParameterCollection;true;Insert;(System.Int32,System.Object);;Argument[1];Element of Argument[-1];value",
      ]
  }
}
