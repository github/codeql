private import codeql_ruby.AST
private import codeql_ruby.Concepts
private import codeql_ruby.controlflow.CfgNodes
private import codeql_ruby.DataFlow
private import codeql_ruby.ast.internal.Module

private class ActiveRecordBaseAccess extends ConstantReadAccess {
  ActiveRecordBaseAccess() {
    this.getName() = "Base" and
    this.getScopeExpr().(ConstantAccess).getName() = "ActiveRecord"
  }
}

// ApplicationRecord extends ActiveRecord::Base, but we
// treat it separately in case the ApplicationRecord definition
// is not in the database
private class ApplicationRecordAccess extends ConstantReadAccess {
  ApplicationRecordAccess() { this.getName() = "ApplicationRecord" }
}

class ActiveRecordModelClass extends ClassDeclaration {
  ActiveRecordModelClass() {
    // class Foo < ActiveRecord::Base
    this.getSuperclassExpr() instanceof ActiveRecordBaseAccess
    or
    // class Foo < ApplicationRecord
    this.getSuperclassExpr() instanceof ApplicationRecordAccess
    or
    // class Bar < Foo
    exists(ActiveRecordModelClass other |
      other.getModule() = resolveScopeExpr(this.getSuperclassExpr())
    )
  }
}

// A class method call whose receiver is an ActiveRecord model class
class ActiveRecordModelClassMethodCall extends MethodCall {
  // The model class that receives this call, if any
  private ActiveRecordModelClass recvCls;

  ActiveRecordModelClassMethodCall() {
    // e.g. Foo.where(...)
    recvCls.getModule() = resolveScopeExpr(this.getReceiver())
    or
    // e.g. Foo.joins(:bars).where(...)
    this.getReceiver() instanceof ActiveRecordModelClassMethodCall
  }

  // TODO: do we need this?
  ActiveRecordModelClass getAnActiveRecordModelClass() {
    result = recvCls or
    result = this.getReceiver().(ActiveRecordModelClassMethodCall).getAnActiveRecordModelClass()
  }
}

private predicate methodWithSqlFragmentArg(string methodName, int argIndex) {
  methodName =
    [
      "delete_all", "destroy_all", "exists?", "find_by", "find_by_sql", "from", "group", "having",
      "joins", "lock", "not", "order", "pluck", "where"
    ] and
  argIndex = 0
  or
  methodName = "calculate" and argIndex = 1
}

class PotentiallyUnsafeSqlExecutingMethodCall extends ActiveRecordModelClassMethodCall {
  // The name of the method invoked
  private string methodName;
  // The zero-indexed position of the SQL fragment sink argument
  private int sqlFragmentArgumentIndex;
  // The SQL fragment argument itself
  private Expr sqlFragmentExpr;

  // TODO: `find` with `lock:` option also takes an SQL fragment
  PotentiallyUnsafeSqlExecutingMethodCall() {
    methodName = this.getMethodName() and
    sqlFragmentExpr = this.getArgument(sqlFragmentArgumentIndex) and
    methodWithSqlFragmentArg(methodName, sqlFragmentArgumentIndex) and
    (
      // select only literals containing an interpolated value...
      exists(StringInterpolationComponent interpolated |
        interpolated = sqlFragmentExpr.(StringlikeLiteral).getComponent(_)
      )
      or
      // ...or string concatenations...
      sqlFragmentExpr instanceof AddExpr
      or
      // ...or variable reads
      sqlFragmentExpr instanceof VariableReadAccess
    )
  }

  Expr getSqlFragmentSinkArgument() { result = sqlFragmentExpr }
}

class ActiveRecordSqlExecutionRange extends SqlExecution::Range {
  ActiveRecordSqlExecutionRange() {
    exists(PotentiallyUnsafeSqlExecutingMethodCall mc |
      this.asExpr().getNode() = mc.getSqlFragmentSinkArgument()
    )
  }

  override DataFlow::Node getSql() { result = this }
}
