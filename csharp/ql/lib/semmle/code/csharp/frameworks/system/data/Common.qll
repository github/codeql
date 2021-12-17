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
