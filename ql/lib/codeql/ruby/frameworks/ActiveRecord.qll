private import codeql.ruby.AST
private import codeql.ruby.Concepts
private import codeql.ruby.controlflow.CfgNodes
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.internal.DataFlowDispatch
private import codeql.ruby.ast.internal.Module
private import codeql.ruby.ApiGraphs
private import codeql.ruby.frameworks.StandardLibrary

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
  private ActiveRecordModelClass recvCls;

  ActiveRecordModelClassMethodCall() {
    // e.g. Foo.where(...)
    recvCls.getModule() = resolveScopeExpr(this.getReceiver())
    or
    // e.g. Foo.joins(:bars).where(...)
    recvCls = this.getReceiver().(ActiveRecordModelClassMethodCall).getReceiverClass()
    or
    // e.g. self.where(...) within an ActiveRecordModelClass
    this.getReceiver() instanceof Self and
    this.getEnclosingModule() = recvCls
  }

  /** The `ActiveRecordModelClass` of the receiver of this method. */
  ActiveRecordModelClass getReceiverClass() { result = recvCls }
}

private Expr sqlFragmentArgument(MethodCall call) {
  exists(string methodName |
    methodName = call.getMethodName() and
    (
      methodName =
        [
          "delete_all", "delete_by", "destroy_all", "destroy_by", "exists?", "find_by", "find_by!",
          "find_or_create_by", "find_or_create_by!", "find_or_initialize_by", "find_by_sql", "from",
          "group", "having", "joins", "lock", "not", "order", "pluck", "where", "rewhere", "select",
          "reselect", "update_all"
        ] and
      result = call.getArgument(0)
      or
      methodName = "calculate" and result = call.getArgument(1)
      or
      methodName in ["average", "count", "maximum", "minimum", "sum"] and
      result = call.getArgument(0)
      or
      // This format was supported until Rails 2.3.8
      methodName = ["all", "find", "first", "last"] and
      result = call.getKeywordArgument("conditions")
      or
      methodName = "reload" and
      result = call.getKeywordArgument("lock")
    )
  )
}

// An expression that, if tainted by unsanitized input, should not be used as
// part of an argument to an SQL executing method
private predicate unsafeSqlExpr(Expr sqlFragmentExpr) {
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
  // The SQL fragment argument itself
  private Expr sqlFragmentExpr;

  PotentiallyUnsafeSqlExecutingMethodCall() {
    exists(Expr arg |
      arg = sqlFragmentArgument(this) and
      unsafeSqlExpr(sqlFragmentExpr) and
      (
        sqlFragmentExpr = arg
        or
        sqlFragmentExpr = arg.(ArrayLiteral).getElement(0)
      ) and
      // Check that method has not been overridden
      not exists(SingletonMethod m |
        m.getName() = this.getMethodName() and
        m.getOuterScope() = this.getReceiverClass()
      )
    )
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
// TODO: factor this out
private string constantQualifiedName(ConstantWriteAccess w) {
  /* get the qualified name for the parent module, then append w */
  exists(ConstantWriteAccess parent | parent = w.getEnclosingModule() |
    result = constantQualifiedName(parent) + "::" + w.getName()
  )
  or
  /* base case - there's no parent module */
  not exists(ConstantWriteAccess parent | parent = w.getEnclosingModule()) and
  result = w.getName()
}

/**
 * A node that may evaluate to one or more `ActiveRecordModelClass` instances.
 */
abstract class ActiveRecordModelInstantiation extends DataFlow::Node {
  abstract ActiveRecordModelClass getClass();
}

// Names of class methods on ActiveRecord models that may return one or more
// instance of that model. This also includes the `initialize` method.
// See https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html
private string finderMethodName() {
  exists(string baseName |
    baseName =
      [
        "fifth", "find", "find_by", "find_or_initialize_by", "find_or_create_by", "first",
        "forty_two", "fourth", "last", "second", "second_to_last", "take", "third", "third_to_last"
      ] and
    (result = baseName or result = baseName + "!")
  )
  or
  result = "new"
}

// Gets the "final" receiver in a chain of method calls.
// For example, in `Foo.bar`, this would give the `Foo` access, and in
// `foo.bar.baz("arg")` it would give the `foo` variable access
private Expr getUltimateReceiver(MethodCall call) {
  exists(Expr recv |
    recv = call.getReceiver() and
    (
      result = getUltimateReceiver(recv)
      or
      not recv instanceof MethodCall and result = recv
    )
  )
}

// A call to `find`, `where`, etc. that may return active record model object(s)
private class ActiveRecordModelFinderCall extends ActiveRecordModelInstantiation, DataFlow::CallNode {
  private MethodCall call;
  private ActiveRecordModelClass cls;
  private Expr recv;

  ActiveRecordModelFinderCall() {
    call = this.asExpr().getExpr() and
    recv = getUltimateReceiver(call) and
    resolveConstant(recv) = constantQualifiedName(cls) and
    call.getMethodName() = finderMethodName()
  }

  final override ActiveRecordModelClass getClass() { result = cls }

  string getConstantQualifiedClassName() { result = constantQualifiedName(cls) }

  Expr getUltimateReceiver() { result = recv }
}

// A `self` reference that may resolve to an active record model object
private class ActiveRecordModelClassSelfReference extends ActiveRecordModelInstantiation,
  DataFlow::LocalSourceNode {
  private ActiveRecordModelClass cls;

  ActiveRecordModelClassSelfReference() {
    exists(Self s |
      s.getEnclosingModule() = cls and
      s.getEnclosingMethod() = cls.getAMethod() and
      s = this.asExpr().getExpr()
    )
  }

  final override ActiveRecordModelClass getClass() { result = cls }
}

// A (locally tracked) active record model object
private DataFlow::Node activeRecordModelInstance() {
  result instanceof ActiveRecordModelInstantiation
  or
  exists(ActiveRecordModelInstantiation inst | inst.(DataFlow::LocalSourceNode).flowsTo(result))
}

// A call whose receiver may be an active record model object
private class ActiveRecordInstanceMethodCall extends DataFlow::CallNode {
  ActiveRecordInstanceMethodCall() { this.getReceiver() = activeRecordModelInstance() }
}

private string activeRecordPersistenceInstanceMethodName() {
  result =
    [
      "becomes", "becomes!", "decrement", "decrement!", "delete", "delete!", "destroy", "destroy!",
      "destroyed?", "increment", "increment!", "new_record?", "persisted?",
      "previously_new_record?", "reload", "save", "save!", "toggle", "toggle!", "touch", "update",
      "update!", "update_attribute", "update_column", "update_columns"
    ]
}

private predicate isCallToBuiltInMethod(MethodCall c) {
  c.getMethodName() = activeRecordPersistenceInstanceMethodName() or
  c instanceof BasicObjectInstanceMethodCall or
  c instanceof ObjectInstanceMethodCall
}

/**
 * Returns true if `call` may refer to a method that returns a database value
 * if invoked against a `sourceClass` instance.
 */
predicate activeRecordMethodMayAccessField(ActiveRecordModelClass sourceClass, MethodCall call) {
  not (
    // Methods whose names can be hardcoded
    isCallToBuiltInMethod(call)
    or
    // Methods defined in `sourceClass` that do not return database fields
    exists(Method m | m = sourceClass.getMethod(call.getMethodName()) |
      forall(DataFlow::Node returned, ActiveRecordInstanceMethodCall c |
        exprNodeReturnedFrom(returned, m) and c.flowsTo(returned)
      |
        not activeRecordMethodMayAccessField(sourceClass, returned.asExpr().getExpr())
      )
    )
  )
}
