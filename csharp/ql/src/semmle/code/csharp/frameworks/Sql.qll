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

/** A construction of an `IDbCommand` object. */
class IDbCommandConstructionSqlExpr extends SqlExpr, ObjectCreation {
  IDbCommandConstructionSqlExpr() {
    exists(InstanceConstructor ic | ic = this.getTarget() |
      ic.getDeclaringType().getABaseType*() instanceof SystemDataIDbCommandInterface and
      ic.getParameter(0).getType() instanceof StringType
    )
  }

  override Expr getSql() { result = this.getArgument(0) }
}

/** A construction of an `SqlDataAdapter` object. */
class SqlDataAdapterConstructionSqlExpr extends SqlExpr, ObjectCreation {
  SqlDataAdapterConstructionSqlExpr() {
    exists(InstanceConstructor ic |
      ic = this.getTarget() and
      ic.getDeclaringType() instanceof SystemDataSqlClientSqlDataAdapterClass and
      ic.getParameter(0).getType() instanceof StringType
    )
  }

  override Expr getSql() { result = this.getArgument(0) }
}

/** A `MySql.Data.MySqlClient.MySqlHelper` method. */
class MySqlHelperMethodCallSqlExpr extends SqlExpr, MethodCall {
  MySqlHelperMethodCallSqlExpr() {
    this.getQualifier().getType().(Class).hasQualifiedName("MySql.Data.MySqlClient", "MySqlHelper")
  }

  override Expr getSql() {
    exists(int i |
      result = getArgument(i) and
      this.getTarget().getParameter(i).hasName("commandText") and
      this.getTarget().getParameter(i).getType() instanceof StringType
    )
  }
}

/** A `Microsoft.ApplicationBlocks.Data.SqlHelper` method. */
class MicrosoftSqlHelperMethodCallSqlExpr extends SqlExpr, MethodCall {
  MicrosoftSqlHelperMethodCallSqlExpr() {
    this.getQualifier()
        .getType()
        .(Class)
        .hasQualifiedName("Microsoft.ApplicationBlocks.Data", "SqlHelper")
  }

  override Expr getSql() {
    exists(int i |
      result = getArgument(i) and
      this.getTarget().getParameter(i).hasName("commandText") and
      this.getTarget().getParameter(i).getType() instanceof StringType
    )
  }
}

/** A `Dapper.SqlMapper` method that is taking a SQL string argument. */
class DapperSqlMethodCallSqlExpr extends SqlExpr, MethodCall {
  DapperSqlMethodCallSqlExpr() {
    this.getTarget() = any(Dapper::SqlMapperClass c).getAQueryMethod()
  }

  override Expr getSql() { result = this.getArgumentForName("sql") }
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
