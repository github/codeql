/**
 * Provides classes representing sources of stored data.
 */

import csharp
private import semmle.code.csharp.frameworks.system.data.Common
private import semmle.code.csharp.frameworks.system.data.Entity
private import semmle.code.csharp.frameworks.EntityFramework
private import semmle.code.csharp.frameworks.NHibernate
private import semmle.code.csharp.frameworks.Sql

/** A data flow source of stored user input. */
abstract class StoredFlowSource extends DataFlow::Node { }

/**
 * An expression that has a type of `DbRawSqlQuery`, representing the result of an Entity Framework
 * SqlQuery.
 */
class DbRawSqlStoredFlowSource extends StoredFlowSource {
  DbRawSqlStoredFlowSource() {
    this.asExpr().getType() instanceof SystemDataEntityInfrastructure::DbRawSqlQuery
  }
}

/**
 * An expression that has a type of `DbDataReader` or a sub-class, representing the result of a
 * data command.
 */
class DbDataReaderStoredFlowSource extends StoredFlowSource {
  DbDataReaderStoredFlowSource() {
    this.asExpr().getType() = any(SystemDataCommon::DbDataReader dataReader).getASubType*()
  }
}

/** An expression that accesses a method of `DbDataReader` or a sub-class. */
class DbDataReaderMethodStoredFlowSource extends StoredFlowSource {
  DbDataReaderMethodStoredFlowSource() {
    this.asExpr().(MethodCall).getTarget().getDeclaringType() =
      any(SystemDataCommon::DbDataReader dataReader).getASubType*()
  }
}

/** An expression that accesses a property of `DbDataReader` or a sub-class. */
class DbDataReaderPropertyStoredFlowSource extends StoredFlowSource {
  DbDataReaderPropertyStoredFlowSource() {
    this.asExpr().(PropertyAccess).getTarget().getDeclaringType() =
      any(SystemDataCommon::DbDataReader dataReader).getASubType*()
  }
}

/** A read of a mapped property. */
class ORMMappedProperty extends StoredFlowSource {
  ORMMappedProperty() {
    this instanceof EntityFramework::StoredFlowSource or
    this instanceof NHibernate::StoredFlowSource
  }
}
