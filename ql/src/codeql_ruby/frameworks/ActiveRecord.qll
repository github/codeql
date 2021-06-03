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

// TODO: methods are class methods rather than instance?
// A parameter that may represent a credential value
/*
 * private DataFlow::LocalSourceNode activeRecordModelAccess(TypeTracker t) {
 *  t.start() and
 *  exists(AssignExpr ae, Ssa::WriteDefinition def, ActiveRecordModelClass cls |
 *    result.asExpr().getExpr() = def.getWriteAccess() and
 *    result.asExpr().getExpr() = ae.getLeftOperand() and
 *    resolveScopeExpr(ae.getRightOperand()) = cls.getModule()
 *  )
 *  or
 *  exists(TypeTracker t2 | result = activeRecordModelAccess(t2).track(t2, t))
 * }
 *
 * private DataFlow::Node activeRecordModelAccess() {
 *  activeRecordModelAccess(TypeTracker::end()).flowsTo(result)
 * }
 *
 * class ActiveRecordNode extends DataFlow::Node {
 *  ActiveRecordNode() {
 *    this = activeRecordModelAccess()
 *  }
 * }
 */

/*
 * class ActiveRecordModelReadAccess extends VariableReadAccess {
 *  ActiveRecordModelReadAccess() {
 *
 *  }
 * }
 */

// A class method call whose receiver is an ActiveRecord model class
class ActiveRecordModelClassMethodCall extends MethodCall {
  // The model class that receives this call
  private ActiveRecordModelClass recvCls;

  ActiveRecordModelClassMethodCall() { recvCls.getModule() = resolveScopeExpr(this.getReceiver()) }

  // TODO: handle some cases of non-constant receiver expressions
  ActiveRecordModelClass getResolvedReceiverScope() { result = recvCls }
}

class SqlExecutingMethodCall extends ActiveRecordModelClassMethodCall {
  // The name of the method invoked
  private string methodName;
  // The zero-indexed position of the SQL fragment sink argument
  private int sqlFragmentArgumentIndex;

  // TODO: determine when the argument may be a string, rather than a key-value pair
  // TODO: `find` with `lock:` option also takes an SQL fragment
  SqlExecutingMethodCall() {
    methodName = this.getMethodName() and
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
    )
  }

  Expr getSqlFragmentSinkArgument() { result = this.getArgument(sqlFragmentArgumentIndex) }
}

class ActiveRecordSqlExecutionRange extends SqlExecution::Range {
  ExprCfgNode sql;

  ActiveRecordSqlExecutionRange() {
    exists(SqlExecutingMethodCall mc | this.asExpr().getNode() = mc.getSqlFragmentSinkArgument())
  }

  override DataFlow::Node getSql() { result.asExpr() = sql }
}
