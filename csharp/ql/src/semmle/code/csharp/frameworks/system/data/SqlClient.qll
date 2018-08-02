/** Provides definitions related to the namespace `System.Data.SqlClient`. */
import csharp
private import semmle.code.csharp.frameworks.system.Data

/** The `System.Data.SqlClient` namespace. */
class SystemDataSqlClientNamespace extends Namespace {
  SystemDataSqlClientNamespace() {
    this.getParentNamespace() instanceof SystemDataNamespace and
    this.hasName("SqlClient")
  }
}

/** DEPRECATED. Gets the `System.Data.SqlClient` namespace. */
deprecated
SystemDataSqlClientNamespace getSystemDataSqlClientNamespace() { any() }

/** A class in the `System.Data.SqlClient` namespace. */
class SystemDataSqlClientClass extends Class {
  SystemDataSqlClientClass() {
    getNamespace() instanceof SystemDataSqlClientNamespace
  }
}

/** The `System.Data.SqlClient.SqlDataAdapter` class. */
class SystemDataSqlClientSqlDataAdapterClass extends SystemDataSqlClientClass {
  SystemDataSqlClientSqlDataAdapterClass() {
    this.hasQualifiedName("System.Data.SqlClient", "SqlDataAdapter")
  }
}

/** DEPRECATED. Gets the `System.Data.SqlClient.SqlDataAdapter` class. */
deprecated
SystemDataSqlClientSqlDataAdapterClass getSystemDataSqlClientSqlDataAdapterClass() { any() }

/** The `System.Data.SqlClient.SqlConnection` class. */
class SystemDataSqlClientSqlConnectionClass extends SystemDataSqlClientClass {
  SystemDataSqlClientSqlConnectionClass() {
    this.hasName("SqlConnection")
  }
}
