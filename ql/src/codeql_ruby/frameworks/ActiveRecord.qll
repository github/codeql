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

class PotentiallyUnsafeSqlExecutingMethodCall extends ActiveRecordModelClassMethodCall {
  // The name of the method invoked
  private string methodName;
  // The zero-indexed position of the SQL fragment sink argument
  private int sqlFragmentArgumentIndex;
  // The SQL fragment argument itself
  private Expr sqlFragmentExpr;

  // TODO: This is slightly too restricted, we only look for StringlikeLiterals
  // as arguments, but we could instead have a variable read, a string
  // concatenation, certain arrays, etc. and still have a potentially
  // vulnerable call
  // TODO: `find` with `lock:` option also takes an SQL fragment
  PotentiallyUnsafeSqlExecutingMethodCall() {
    methodName = this.getMethodName() and
    sqlFragmentExpr = this.getArgument(sqlFragmentArgumentIndex) and
    (
      methodName = "calculate" and sqlFragmentArgumentIndex = 1
      or
      sqlFragmentArgumentIndex = 0 and
      (
        methodName = "delete_all"
        or
        methodName = "destroy_all"
        or
        methodName = "exists?"
        or
        methodName = "find_by"
        or
        methodName = "find_by_sql"
        or
        methodName = "from"
        or
        methodName = "group"
        or
        methodName = "having"
        or
        methodName = "joins"
        or
        methodName = "lock"
        or
        methodName = "not"
        or
        methodName = "order"
        or
        methodName = "pluck"
        or
        methodName = "where"
      )
    ) and
    sqlFragmentExpr instanceof StringlikeLiteral
  }

  Expr getSqlFragmentSinkArgument() { result = sqlFragmentExpr }
}

class ActiveRecordSqlExecutionRange extends SqlExecution::Range {
  ExprCfgNode sql;

  ActiveRecordSqlExecutionRange() {
    exists(PotentiallyUnsafeSqlExecutingMethodCall mc |
      this.asExpr().getNode() = mc.getSqlFragmentSinkArgument()
    )
  }

  override DataFlow::Node getSql() { result.asExpr() = sql }
}
