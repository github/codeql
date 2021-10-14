/**
 * Provides classes related to the namespace `System.Data.Common`.
 */

private import csharp as csharp
private import semmle.code.csharp.frameworks.system.Data as Data

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
