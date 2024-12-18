/**
 * Provides classes representing sources of stored data.
 */

import csharp
private import semmle.code.csharp.dataflow.internal.ExternalFlow
private import semmle.code.csharp.frameworks.system.data.Common
private import semmle.code.csharp.frameworks.system.data.Entity
private import semmle.code.csharp.frameworks.EntityFramework
private import semmle.code.csharp.frameworks.NHibernate
private import semmle.code.csharp.frameworks.Sql
private import semmle.code.csharp.security.dataflow.flowsources.FlowSources

/** A data flow source of stored user input. */
abstract class StoredFlowSource extends SourceNode {
  override string getThreatModel() { result = "local" }
}

/**
 * A node with input from a database.
 */
abstract class DatabaseInputSource extends StoredFlowSource {
  override string getThreatModel() { result = "database" }

  override string getSourceType() { result = "database input" }
}

/**
 * An expression that has a type of `DbRawSqlQuery`, representing the result of an Entity Framework
 * SqlQuery.
 */
class DbRawSqlStoredFlowSource extends DatabaseInputSource {
  DbRawSqlStoredFlowSource() {
    this.asExpr().getType() instanceof SystemDataEntityInfrastructure::DbRawSqlQuery
  }
}

/**
 * An expression that has a type of `DbDataReader` or a sub-class, representing the result of a
 * data command.
 */
class DbDataReaderParameterStoredFlowSource extends DatabaseInputSource {
  DbDataReaderParameterStoredFlowSource() {
    [this.asParameter().getType(), this.asExpr().(MethodCall).getTarget().getReturnType()] =
      any(SystemDataCommon::DbDataReader dataReader).getASubType*()
  }
}

/** An expression that accesses a method of `DbDataReader` or a sub-class. */
deprecated class DbDataReaderMethodStoredFlowSource extends DataFlow::Node {
  DbDataReaderMethodStoredFlowSource() {
    this.asExpr().(MethodCall).getTarget().getDeclaringType() =
      any(SystemDataCommon::DbDataReader dataReader).getASubType*()
  }
}

/** An expression that accesses a property of `DbDataReader` or a sub-class. */
deprecated class DbDataReaderPropertyStoredFlowSource extends DataFlow::Node {
  DbDataReaderPropertyStoredFlowSource() {
    this.asExpr().(PropertyAccess).getTarget().getDeclaringType() =
      any(SystemDataCommon::DbDataReader dataReader).getASubType*()
  }
}

/**
 * DEPRECATED: Use `EntityFramework::StoredFlowSource` and `NHibernate::StoredFlowSource` instead.
 *
 * A read of a mapped property.
 */
deprecated class ORMMappedProperty extends DataFlow::Node {
  ORMMappedProperty() {
    this instanceof EntityFramework::StoredFlowSource or
    this instanceof NHibernate::StoredFlowSource
  }
}

private class ExternalDatabaseInputSource extends DatabaseInputSource {
  ExternalDatabaseInputSource() { sourceNode(this, "database") }
}

/** A file stream source is considered a stored flow source. */
class FileStreamStoredFlowSource extends StoredFlowSource {
  FileStreamStoredFlowSource() { sourceNode(this, "file") }

  override string getThreatModel() { result = "file" }

  override string getSourceType() { result = "file stream" }
}
