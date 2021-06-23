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

/**
 * A `ClassDeclaration` for a class that extends `ActiveRecord::Base`. For example,
 *
 * ```rb
 * class UserGroup < ActiveRecord::Base
 *   has_many :users
 * end
 * ```
 */
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

/** A class method call whose receiver is an `ActiveRecordModelClass`. */
class ActiveRecordModelClassMethodCall extends MethodCall {
  ActiveRecordModelClassMethodCall() {
    // e.g. Foo.where(...)
    exists(ActiveRecordModelClass recvCls |
      recvCls.getModule() = resolveScopeExpr(this.getReceiver())
    )
    or
    // e.g. Foo.joins(:bars).where(...)
    this.getReceiver() instanceof ActiveRecordModelClassMethodCall
    or
    // e.g. self.where(...) within an ActiveRecordModelClass
    (
      this.getReceiver() instanceof Self
      and
      this.getEnclosingModule() instanceof ActiveRecordModelClass
    )
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

// An expression that, if tainted by unsanitized input, should not be used as
// part of an argument to an SQL executing method
private predicate basicUnsafeSqlArg(Expr sqlFragmentExpr) {
  // Literals containing an interpolated value
  exists(StringInterpolationComponent interpolated |
    interpolated = sqlFragmentExpr.(StringlikeLiteral).getComponent(_)
  )
  or
  // String concatenations
  sqlFragmentExpr instanceof AddExpr
  or
  // Variable reads
  sqlFragmentExpr instanceof VariableReadAccess
  or
  // Method call
  sqlFragmentExpr instanceof MethodCall
}

// An expression that, if used as an argument to an SQL executing method,
// may be unsafe if tainted by unsanitized input
private predicate unsafeSqlArg(Expr sqlFragmentExpr) {
  basicUnsafeSqlArg(sqlFragmentExpr) or
  basicUnsafeSqlArg(sqlFragmentExpr.(ArrayLiteral).getElement(0))
}

/**
 * A method call that may result in executing unintended user-controlled SQL
 * queries if the `getSqlFragmentSinkArgument()` expression is tainted by
 * unsanitized user-controlled input. For example, supposing that `User` is an
 * `ActiveRecord` model class, then
 *
 * ```rb
 * User.where("name = '#{user_name}'")
 * ```
 *
 * may be unsafe if `user_name` is from unsanitized user input, as a value such
 * as `"') OR 1=1 --"` could result in the application looking up all users
 * rather than just one with a matching name.
 */
class PotentiallyUnsafeSqlExecutingMethodCall extends ActiveRecordModelClassMethodCall {
  // The name of the method invoked
  private string methodName;
  // The zero-indexed position of the SQL fragment sink argument
  private int sqlFragmentArgumentIndex;
  // The SQL fragment argument itself
  private Expr sqlFragmentExpr;

  // TODO: `find` with `lock:` option also takes an SQL fragment
  // TODO: refine this further to account for cases where the method called has
  //       been overriden to perform validation on its arguments
  PotentiallyUnsafeSqlExecutingMethodCall() {
    methodName = this.getMethodName() and
    sqlFragmentExpr = this.getArgument(sqlFragmentArgumentIndex) and
    methodWithSqlFragmentArg(methodName, sqlFragmentArgumentIndex) and
    unsafeSqlArg(sqlFragmentExpr)
  }

  Expr getSqlFragmentSinkArgument() { result = sqlFragmentExpr }
}

/**
 * An `SqlExecution::Range` for an argument to a
 * `PotentiallyUnsafeSqlExecutingMethodCall` that may be vulnerable to being
 * controlled by user input.
 */
class ActiveRecordSqlExecutionRange extends SqlExecution::Range {
  ActiveRecordSqlExecutionRange() {
    exists(PotentiallyUnsafeSqlExecutingMethodCall mc |
      this.asExpr().getNode() = mc.getSqlFragmentSinkArgument()
    )
  }

  override DataFlow::Node getSql() { result = this }
}
// TODO: model `ActiveRecord` sanitizers
// https://api.rubyonrails.org/classes/ActiveRecord/Sanitization/ClassMethods.html
