/** Provides definitions related to the namespace `System.Data.SqlServerCe`. */

import csharp
private import semmle.code.csharp.frameworks.system.Data

/** The `System.Data.SqlServerCe` namespace. */
class SystemDataSqlServerCeNamespace extends Namespace {
  SystemDataSqlServerCeNamespace() {
    this.getParentNamespace() instanceof SystemDataNamespace and
    this.hasName("SqlServerCe")
  }
}

/** A class in the `System.Data.SqlServerCe` namespace. */
class SystemDataSqlServerCeClass extends Class {
  SystemDataSqlServerCeClass() { this.getNamespace() instanceof SystemDataSqlServerCeNamespace }
}

/** The `System.Data.SqlServerCe.SqlCeConnection` class. */
class SystemDataSqlServerCeSqlCeConnectionClass extends SystemDataSqlServerCeClass {
  SystemDataSqlServerCeSqlCeConnectionClass() { this.hasName("SqlCeConnection") }
}
