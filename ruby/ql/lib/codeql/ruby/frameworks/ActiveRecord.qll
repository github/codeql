/**
 * Provides modeling for the `ActiveRecord` library.
 */

private import codeql.ruby.AST
private import codeql.ruby.Concepts
private import codeql.ruby.controlflow.CfgNodes
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.internal.DataFlowDispatch
private import codeql.ruby.dataflow.internal.DataFlowPrivate
private import codeql.ruby.ApiGraphs
private import codeql.ruby.frameworks.Stdlib
private import codeql.ruby.frameworks.Core

/// See https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html
private string activeRecordPersistenceInstanceMethodName() {
  result =
    [
      "becomes", "becomes!", "decrement", "decrement!", "delete", "delete!", "destroy", "destroy!",
      "destroyed?", "increment", "increment!", "new_record?", "persisted?",
      "previously_new_record?", "reload", "save", "save!", "toggle", "toggle!", "touch", "update",
      "update!", "update_attribute", "update_column", "update_columns"
    ]
}

// Methods with these names are defined for all active record model instances,
// so they are unlikely to refer to a database field.
private predicate isBuiltInMethodForActiveRecordModelInstance(string methodName) {
  methodName = activeRecordPersistenceInstanceMethodName() or
  methodName = basicObjectInstanceMethodName() or
  methodName = objectInstanceMethodName()
}

/**
 * A `ClassDeclaration` for a class that inherits from `ActiveRecord::Base`. For example,
 *
 * ```rb
 * class UserGroup < ActiveRecord::Base
 *   has_many :users
 * end
 *
 * class SpecialUserGroup < UserGroup
 * end
 * ```
 */
class ActiveRecordModelClass extends ClassDeclaration {
  ActiveRecordModelClass() {
    // class Foo < ActiveRecord::Base
    // class Bar < Foo
    this.getSuperclassExpr() =
      [
        API::getTopLevelMember("ActiveRecord").getMember("Base"),
        // In Rails applications `ApplicationRecord` typically extends `ActiveRecord::Base`, but we
        // treat it separately in case the `ApplicationRecord` definition is not in the database.
        API::getTopLevelMember("ApplicationRecord")
      ].getASubclass().getAValueReachableFromSource().asExpr().getExpr()
  }

  // Gets the class declaration for this class and all of its super classes
  private ModuleBase getAllClassDeclarations() {
    result = this.getModule().getSuperClass*().getADeclaration()
  }

  /**
   * Gets methods defined in this class that may access a field from the database.
   */
  Method getAPotentialFieldAccessMethod() {
    // It's a method on this class or one of its super classes
    result = this.getAllClassDeclarations().getAMethod() and
    // There is a value that can be returned by this method which may include field data
    exists(DataFlow::Node returned, ActiveRecordInstanceMethodCall cNode, MethodCall c |
      exprNodeReturnedFrom(returned, result) and
      cNode.flowsTo(returned) and
      c = cNode.asExpr().getExpr()
    |
      // The referenced method is not built-in, and...
      not isBuiltInMethodForActiveRecordModelInstance(c.getMethodName()) and
      (
        // ...The receiver does not have a matching method definition, or...
        not exists(
          cNode.getInstance().getClass().getAllClassDeclarations().getMethod(c.getMethodName())
        )
        or
        // ...the called method can access a field
        c.getATarget() = cNode.getInstance().getClass().getAPotentialFieldAccessMethod()
      )
    )
  }
}

/** A class method call whose receiver is an `ActiveRecordModelClass`. */
class ActiveRecordModelClassMethodCall extends MethodCall {
  private ActiveRecordModelClass recvCls;

  ActiveRecordModelClassMethodCall() {
    // e.g. Foo.where(...)
    recvCls.getModule() = this.getReceiver().(ConstantReadAccess).getModule()
    or
    // e.g. Foo.joins(:bars).where(...)
    recvCls = this.getReceiver().(ActiveRecordModelClassMethodCall).getReceiverClass()
    or
    // e.g. self.where(...) within an ActiveRecordModelClass
    this.getReceiver() instanceof SelfVariableAccess and
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
      or
      // Calls to `annotate` can be used to add block comments to SQL queries. These are potentially vulnerable to
      // SQLi if user supplied input is passed in as an argument.
      methodName = "annotate" and
      result = call.getArgument(_)
    )
  )
}

// An expression that, if tainted by unsanitized input, should not be used as
// part of an argument to an SQL executing method
private predicate unsafeSqlExpr(Expr sqlFragmentExpr) {
  // Literals containing an interpolated value
  sqlFragmentExpr.(StringlikeLiteral).getComponent(_) instanceof StringInterpolationComponent
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

  /**
   * Gets the SQL fragment argument of this method call.
   */
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
/**
 * A node that may evaluate to one or more `ActiveRecordModelClass` instances.
 */
abstract class ActiveRecordModelInstantiation extends OrmInstantiation::Range,
  DataFlow::LocalSourceNode {
  /**
   * Gets the `ActiveRecordModelClass` that this instance belongs to.
   */
  abstract ActiveRecordModelClass getClass();

  bindingset[methodName]
  override predicate methodCallMayAccessField(string methodName) {
    // The method is not a built-in, and...
    not isBuiltInMethodForActiveRecordModelInstance(methodName) and
    (
      // ...There is no matching method definition in the class, or...
      not exists(this.getClass().getMethod(methodName))
      or
      // ...the called method can access a field.
      exists(Method m | m = this.getClass().getAPotentialFieldAccessMethod() |
        m.getName() = methodName
      )
    )
  }
}

// Names of class methods on ActiveRecord models that may return one or more
// instances of that model. This also includes the `initialize` method.
// See https://api.rubyonrails.org/classes/ActiveRecord/FinderMethods.html
private string staticFinderMethodName() {
  exists(string baseName |
    baseName =
      [
        "fifth", "find", "find_by", "find_or_initialize_by", "find_or_create_by", "first",
        "forty_two", "fourth", "last", "second", "second_to_last", "take", "third", "third_to_last"
      ] and
    result = baseName + ["", "!"]
  )
  or
  result = ["new", "create"]
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
  private ActiveRecordModelClass cls;

  ActiveRecordModelFinderCall() {
    exists(MethodCall call, Expr recv |
      call = this.asExpr().getExpr() and
      recv = getUltimateReceiver(call) and
      (
        // The receiver refers to an `ActiveRecordModelClass` by name
        recv.(ConstantReadAccess).getAQualifiedName() = cls.getAQualifiedName()
        or
        // The receiver is self, and the call is within a singleton method of
        // the `ActiveRecordModelClass`
        recv instanceof SelfVariableAccess and
        exists(SingletonMethod callScope |
          callScope = call.getCfgScope() and
          callScope = cls.getAMethod()
        )
      ) and
      (
        call.getMethodName() = staticFinderMethodName()
        or
        // dynamically generated finder methods
        call.getMethodName().indexOf("find_by_") = 0
      )
    )
  }

  final override ActiveRecordModelClass getClass() { result = cls }
}

// A `self` reference that may resolve to an active record model object
private class ActiveRecordModelClassSelfReference extends ActiveRecordModelInstantiation,
  SsaSelfDefinitionNode {
  private ActiveRecordModelClass cls;

  ActiveRecordModelClassSelfReference() {
    exists(MethodBase m |
      m = this.getCfgScope() and
      m.getEnclosingModule() = cls and
      m = cls.getAMethod()
    ) and
    // In a singleton method, `self` refers to the class itself rather than an
    // instance of that class
    not this.getSelfScope() instanceof SingletonMethod
  }

  final override ActiveRecordModelClass getClass() { result = cls }
}

/**
 * An instance of an `ActiveRecord` model object.
 */
class ActiveRecordInstance extends DataFlow::Node {
  private ActiveRecordModelInstantiation instantiation;

  ActiveRecordInstance() { this = instantiation or instantiation.flowsTo(this) }

  /** Gets the `ActiveRecordModelClass` that this is an instance of. */
  ActiveRecordModelClass getClass() { result = instantiation.getClass() }
}

/** A call whose receiver may be an active record model object */
class ActiveRecordInstanceMethodCall extends DataFlow::CallNode {
  private ActiveRecordInstance instance;

  ActiveRecordInstanceMethodCall() { this.getReceiver() = instance }

  /** Gets the `ActiveRecordInstance` that is the receiver of this call. */
  ActiveRecordInstance getInstance() { result = instance }
}

/**
 * Provides modeling relating to the `ActiveRecord::Persistence` module.
 */
private module Persistence {
  /**
   * Holds if there is a hash literal argument to `call` at `argIndex`
   * containing a KV pair with value `value`.
   */
  private predicate hashArgumentWithValue(
    DataFlow::CallNode call, int argIndex, DataFlow::ExprNode value
  ) {
    exists(ExprNodes::HashLiteralCfgNode hash, ExprNodes::PairCfgNode pair |
      hash = call.getArgument(argIndex).asExpr() and
      pair = hash.getAKeyValuePair()
    |
      value.asExpr() = pair.getValue()
    )
  }

  /** A call to e.g. `User.create(name: "foo")` */
  private class CreateLikeCall extends DataFlow::CallNode, PersistentWriteAccess::Range {
    CreateLikeCall() {
      exists(this.asExpr().getExpr().(ActiveRecordModelClassMethodCall).getReceiverClass()) and
      this.getMethodName() =
        [
          "create", "create!", "create_or_find_by", "create_or_find_by!", "find_or_create_by",
          "find_or_create_by!", "insert", "insert!"
        ]
    }

    override DataFlow::Node getValue() {
      // attrs as hash elements in arg0
      hashArgumentWithValue(this, 0, result)
      or
      result = this.getKeywordArgument(_)
      or
      result = this.getPositionalArgument(0) and
      not result.asExpr() instanceof ExprNodes::HashLiteralCfgNode
    }
  }

  /** A call to e.g. `User.update(1, name: "foo")` */
  private class UpdateLikeClassMethodCall extends DataFlow::CallNode, PersistentWriteAccess::Range {
    UpdateLikeClassMethodCall() {
      exists(this.asExpr().getExpr().(ActiveRecordModelClassMethodCall).getReceiverClass()) and
      this.getMethodName() = ["update", "update!", "upsert"]
    }

    override DataFlow::Node getValue() {
      // User.update(1, name: "foo")
      result = this.getKeywordArgument(_)
      or
      // User.update(1, params)
      exists(int n | n > 0 |
        result = this.getPositionalArgument(n) and
        not result.asExpr() instanceof ExprNodes::ArrayLiteralCfgNode
      )
      or
      // Case where 2 array args are passed - the first an array of IDs, and the
      // second an array of hashes - each hash corresponding to an ID in the
      // first array.
      // User.update([1,2,3], [{name: "foo"}, {name: "bar"}])
      exists(ExprNodes::ArrayLiteralCfgNode hashesArray |
        this.getArgument(0).asExpr() instanceof ExprNodes::ArrayLiteralCfgNode and
        hashesArray = this.getArgument(1).asExpr()
      |
        exists(ExprNodes::HashLiteralCfgNode hash, ExprNodes::PairCfgNode pair |
          hash = hashesArray.getArgument(_) and
          pair = hash.getAKeyValuePair()
        |
          result.asExpr() = pair.getValue()
        )
      )
    }
  }

  /**
   *  A call to `ActiveRecord::Relation#touch_all`, which updates the `updated_at`
   *  attribute on all records in the relation, setting it to the current time or
   *  the time specified. If passed additional attribute names, they will also be
   *  updated with the time.
   *  Examples:
   *  ```rb
   * Person.all.touch_all
   * Person.where(name: "David").touch_all
   * Person.all.touch_all(:created_at)
   * Person.all.touch_all(time: Time.new(2020, 5, 16, 0, 0, 0))
   * ```
   */
  private class TouchAllCall extends DataFlow::CallNode, PersistentWriteAccess::Range {
    TouchAllCall() {
      exists(this.asExpr().getExpr().(ActiveRecordModelClassMethodCall).getReceiverClass()) and
      this.getMethodName() = "touch_all"
    }

    override DataFlow::Node getValue() { result = this.getKeywordArgument("time") }
  }

  /** A call to e.g. `User.insert_all([{name: "foo"}, {name: "bar"}])` */
  private class InsertAllLikeCall extends DataFlow::CallNode, PersistentWriteAccess::Range {
    private ExprNodes::ArrayLiteralCfgNode arr;

    InsertAllLikeCall() {
      exists(this.asExpr().getExpr().(ActiveRecordModelClassMethodCall).getReceiverClass()) and
      this.getMethodName() = ["insert_all", "insert_all!", "upsert_all"] and
      arr = this.getArgument(0).asExpr()
    }

    override DataFlow::Node getValue() {
      // attrs as hash elements of members of array arg0
      exists(ExprNodes::HashLiteralCfgNode hash, ExprNodes::PairCfgNode pair |
        hash = arr.getArgument(_) and
        pair = hash.getAKeyValuePair()
      |
        result.asExpr() = pair.getValue()
      )
    }
  }

  /** A call to e.g. `user.update(name: "foo")` */
  private class UpdateLikeInstanceMethodCall extends PersistentWriteAccess::Range,
    ActiveRecordInstanceMethodCall {
    UpdateLikeInstanceMethodCall() {
      this.getMethodName() = ["update", "update!", "update_attributes", "update_attributes!"]
    }

    override DataFlow::Node getValue() {
      // attrs as hash elements in arg0
      hashArgumentWithValue(this, 0, result)
      or
      // attrs as variable in arg0
      result = this.getPositionalArgument(0) and
      not result.asExpr() instanceof ExprNodes::HashLiteralCfgNode
      or
      // keyword arg
      result = this.getKeywordArgument(_)
    }
  }

  /** A call to e.g. `user.update_attribute(name, "foo")` */
  private class UpdateAttributeCall extends PersistentWriteAccess::Range,
    ActiveRecordInstanceMethodCall {
    UpdateAttributeCall() { this.getMethodName() = "update_attribute" }

    override DataFlow::Node getValue() {
      // e.g. `foo.update_attribute(key, value)`
      result = this.getArgument(1)
    }
  }

  /**
   * An assignment like `user.name = "foo"`. Though this does not write to the
   * database without a subsequent call to persist the object, it is considered
   * as an `PersistentWriteAccess` to avoid missing cases where the path to a
   * subsequent write is not clear.
   */
  private class AssignAttribute extends PersistentWriteAccess::Range {
    private ExprNodes::AssignExprCfgNode assignNode;

    AssignAttribute() {
      exists(DataFlow::CallNode setter |
        assignNode = this.asExpr() and
        setter.getArgument(0) = this and
        setter instanceof ActiveRecordInstanceMethodCall and
        setter.asExpr().getExpr() instanceof SetterMethodCall
      )
    }

    override DataFlow::Node getValue() { assignNode.getRhs() = result.asExpr() }
  }
}

/**
 * A method call inside an ActiveRecord model class that establishes an
 * association between this model and another model.
 *
 * ```rb
 * class User
 *   has_many :posts
 *   has_one :profile
 * end
 * ```
 */
class ActiveRecordAssociation extends DataFlow::CallNode {
  private ActiveRecordModelClass modelClass;

  ActiveRecordAssociation() {
    not exists(this.asExpr().getExpr().getEnclosingMethod()) and
    this.asExpr().getExpr().getEnclosingModule() = modelClass and
    this.getMethodName() =
      [
        "has_one", "has_many", "belongs_to", "has_and_belongs_to_many", "has_one_attached",
        "has_many_attached"
      ]
  }

  /**
   * Gets the class which declares this association.
   *  For example, in
   *  ```rb
   *  class User
   *    has_many :posts
   *  end
   *  ```
   *  the source class is `User`.
   */
  ActiveRecordModelClass getSourceClass() { result = modelClass }

  /**
   * Gets the class which this association refers to.
   *  For example, in
   *  ```rb
   *  class User
   *    has_many :posts
   *  end
   *  ```
   *  the target class is `Post`.
   */
  ActiveRecordModelClass getTargetClass() {
    result.getName().toLowerCase() = this.getTargetModelName()
  }

  /**
   * Gets the (lowercase) name of the model this association targets.
   * For example, in `has_many :posts`, this is `post`.
   */
  string getTargetModelName() {
    exists(string s | s = this.getArgument(0).getConstantValue().getStringlikeValue() |
      // has_one :profile
      // belongs_to :user
      this.isSingular() and
      result = s
      or
      // has_many :posts
      // has_many :stories
      this.isCollection() and
      pluralize(result) = s
    )
  }

  /** Holds if this association is one-to-one */
  predicate isSingular() { this.getMethodName() = ["has_one", "belongs_to", "has_one_attached"] }

  /** Holds if this association is one-to-many or many-to-many */
  predicate isCollection() {
    this.getMethodName() = ["has_many", "has_and_belongs_to_many", "has_many_attached"]
  }
}

/**
 * Converts `input` to plural form.
 *
 * Examples:
 *
 * - photo -> photos
 * - story -> stories
 * - photos -> photos
 */
bindingset[input]
bindingset[result]
private string pluralize(string input) {
  exists(string stem | stem + "y" = input | result = stem + "ies")
  or
  not exists(string stem | stem + "s" = input) and
  result = input + "s"
  or
  exists(string stem | stem + "s" = input) and result = input
}

/**
 * A call to a method generated by an ActiveRecord association.
 * These yield ActiveRecord collection proxies, which act like collections but
 * add some additional methods.
 * We exclude `<model>_changed?` and `<model>_previously_changed?` because these
 * do not yield ActiveRecord instances.
 * https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html
 */
private class ActiveRecordAssociationMethodCall extends DataFlow::CallNode {
  ActiveRecordAssociation assoc;

  ActiveRecordAssociationMethodCall() {
    exists(string model | model = assoc.getTargetModelName() |
      this.getReceiver().(ActiveRecordInstance).getClass() = assoc.getSourceClass() and
      (
        assoc.isCollection() and
        (
          this.getMethodName() = pluralize(model) + ["", "="]
          or
          this.getMethodName() = "<<"
          or
          this.getMethodName() = model + ["_ids", "_ids="]
        )
        or
        assoc.isSingular() and
        (
          this.getMethodName() = model + ["", "="] or
          this.getMethodName() = ["build_", "reload_"] + model or
          this.getMethodName() = "create_" + model + ["!", ""]
        )
      )
    )
  }

  ActiveRecordAssociation getAssociation() { result = assoc }
}

/**
 * A method call on an ActiveRecord collection proxy that yields one or more
 * ActiveRecord instances.
 * Example:
 * ```rb
 * class User < ActiveRecord::Base
 *   has_many :posts
 * end
 *
 * User.new.posts.create
 * ```
 * https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html
 */
private class ActiveRecordCollectionProxyMethodCall extends DataFlow::CallNode {
  ActiveRecordCollectionProxyMethodCall() {
    this.getMethodName() =
      [
        "push", "concat", "build", "create", "create!", "delete", "delete_all", "destroy",
        "destroy_all", "find", "distinct", "reset", "reload"
      ] and
    (
      this.getReceiver().(ActiveRecordAssociationMethodCall).getAssociation().isCollection()
      or
      exists(ActiveRecordCollectionProxyMethodCall receiver | receiver = this.getReceiver() |
        receiver.getAssociation().isCollection() and
        receiver.getMethodName() = ["reset", "reload", "distinct"]
      )
    )
  }

  ActiveRecordAssociation getAssociation() {
    result = this.getReceiver().(ActiveRecordAssociationMethodCall).getAssociation()
  }
}

/**
 * A call to an association method which yields ActiveRecord instances.
 */
private class ActiveRecordAssociationModelInstantiation extends ActiveRecordModelInstantiation instanceof ActiveRecordAssociationMethodCall {
  override ActiveRecordModelClass getClass() {
    result = this.(ActiveRecordAssociationMethodCall).getAssociation().getTargetClass()
  }
}

/**
 * A call to a method on a collection proxy which yields ActiveRecord instances.
 */
private class ActiveRecordCollectionProxyModelInstantiation extends ActiveRecordModelInstantiation instanceof ActiveRecordCollectionProxyMethodCall {
  override ActiveRecordModelClass getClass() {
    result = this.(ActiveRecordCollectionProxyMethodCall).getAssociation().getTargetClass()
  }
}
