/** Provides definitions related to the namespace `System.Data`. */

import csharp
private import semmle.code.csharp.frameworks.System

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
