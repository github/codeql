/**
 * Classes for modeling Dapper.
 */

import csharp
private import semmle.code.csharp.frameworks.system.Data

/** Definitions relating to the `Dapper` package. */
module Dapper {
  /** The namespace `Dapper`. */
  class DapperNamespace extends Namespace {
    DapperNamespace() { this.hasQualifiedName("Dapper") }
  }

  /** A class in `Dapper`. */
  class DapperClass extends Class {
    DapperClass() { this.getParent() instanceof DapperNamespace }
  }

  /** A struct in `Dapper`. */
  class DapperStruct extends Struct {
    DapperStruct() { this.getParent() instanceof DapperNamespace }
  }

  /** The `Dapper.SqlMapper` class. */
  class SqlMapperClass extends DapperClass {
    SqlMapperClass() { this.hasName("SqlMapper") }

    /** Gets a DB query method. */
    ExtensionMethod getAQueryMethod() {
      result = this.getAMethod() and
      result.getName().regexpMatch("Query.*|Execute.*") and
      result.getExtendedType() instanceof SystemDataIDbConnectionInterface and
      result.isPublic()
    }
  }

  /** The `Dapper.CommandDefinition` struct. */
  class CommandDefinitionStruct extends DapperStruct {
    CommandDefinitionStruct() { this.hasName("CommandDefinition") }
  }
}
