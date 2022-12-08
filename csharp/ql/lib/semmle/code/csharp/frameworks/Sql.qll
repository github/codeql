/** Provides definitions related to SQL frameworks. */

import csharp
private import semmle.code.csharp.frameworks.system.Data
private import semmle.code.csharp.frameworks.system.data.SqlClient
private import semmle.code.csharp.frameworks.EntityFramework
private import semmle.code.csharp.frameworks.NHibernate
private import semmle.code.csharp.frameworks.Dapper
private import semmle.code.csharp.dataflow.DataFlow4

/** An expression containing a SQL command. */
abstract class SqlExpr extends Expr {
  /** Gets the SQL command. */
  abstract Expr getSql();
}

/** An assignment to a `CommandText` property. */
class CommandTextAssignmentSqlExpr extends SqlExpr, AssignExpr {
  CommandTextAssignmentSqlExpr() {
    exists(Property p, SystemDataIDbCommandInterface i, Property text |
      p = this.getLValue().(PropertyAccess).getTarget() and
      text = i.getCommandTextProperty()
    |
      p.overridesOrImplementsOrEquals(text)
    )
  }

  override Expr getSql() { result = this.getRValue() }
}

/** A construction of an unknown `IDbCommand` object. */
class IDbCommandConstructionSqlExpr extends SqlExpr, ObjectCreation {
  IDbCommandConstructionSqlExpr() {
    exists(InstanceConstructor ic | ic = this.getTarget() |
      ic.getDeclaringType().getABaseType*() instanceof SystemDataIDbCommandInterface and
      ic.getParameter(0).getType() instanceof StringType and
      not exists(Type t | t = ic.getDeclaringType() |
        // Known sealed classes:
        t.hasQualifiedName("System.Data.SqlClient", "SqlCommand") or
        t.hasQualifiedName("System.Data.Odbc", "OdbcCommand") or
        t.hasQualifiedName("System.Data.OleDb", "OleDbCommand") or
        t.hasQualifiedName("System.Data.EntityClient", "EntityCommand") or
        t.hasQualifiedName("System.Data.SQLite", "SQLiteCommand")
      )
    )
  }

  override Expr getSql() { result = this.getArgument(0) }
}

/** A `Dapper.CommandDefinition` creation that is taking a SQL string argument and is passed to a `Dapper.SqlMapper` method. */
class DapperCommandDefinitionMethodCallSqlExpr extends SqlExpr, ObjectCreation {
  DapperCommandDefinitionMethodCallSqlExpr() {
    this.getObjectType() instanceof Dapper::CommandDefinitionStruct and
    exists(Conf c | c.hasFlow(DataFlow::exprNode(this), _))
  }

  override Expr getSql() { result = this.getArgumentForName("commandText") }
}

private class Conf extends DataFlow4::Configuration {
  Conf() { this = "DapperCommandDefinitionFlowConfig" }

  override predicate isSource(DataFlow::Node node) {
    node.asExpr().(ObjectCreation).getObjectType() instanceof Dapper::CommandDefinitionStruct
  }

  override predicate isSink(DataFlow::Node node) {
    exists(MethodCall mc |
      mc.getTarget() = any(Dapper::SqlMapperClass c).getAQueryMethod() and
      node.asExpr() = mc.getArgumentForName("command")
    )
  }
}
