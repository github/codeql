/**
 * Provides all access expression classes.
 *
 * All access expressions have the common base class `Access`.
 */

import Expr
import semmle.code.csharp.Variable

/**
 * An access expression. Either a `this` access (`ThisAccess`), a
 * `base` access (`BaseAccess`), a member access (`MemberAccess`),
 * an assignable access (`AssignableAccess`), or a callable access
 * (`CallableAccess`).
 */
class Access extends Expr, @access_expr {
  Access() { AccessImpl::isAccess(this) }

  /** Gets the target of this access. */
  Declaration getTarget() { none() }
}

/**
 * An internal helper module to calculate accesses and their targets.
 */
cached
private module AccessImpl {
  cached
  predicate isAccess(@access_expr ae) {
    isLocalVariableAccess(ae) implies exists(getLocalVariableAccessTarget(ae))
  }

  private predicate isLocalVariableAccess(@local_variable_access a) { any() }

  cached
  LocalVariable getLocalVariableAccessTarget(@local_variable_access a) {
    result = getLocalVariableAccessTargetNoDecl(a) or
    result = getLocalVariableAccessTargetDecl(a)
  }

  private LocalVariable getLocalVariableAccessTargetNoDecl(@local_variable_access_expr a) {
    expr_access(a, result)
  }

  private LocalVariable getLocalVariableAccessTargetDecl(LocalVariableDeclExpr decl) {
    decl.isOutArgument() and
    result = decl.getVariable()
  }
}

/**
 * A `this` access, for example `this` on line 5 in
 *
 * ```csharp
 * class C {
 *   int Count;
 *
 *   public int GetCount() {
 *     return this.Count;
 *   }
 * }
 * ```
 *
 * Note that a `this` access may be implicit, for example the implicit `this`
 * qualifier on line 5 in
 *
 * ```csharp
 * class C {
 *   int Count;
 *
 *   public int GetCount() {
 *     return Count;
 *   }
 * }
 * ```
 */
class ThisAccess extends Access, @this_access_expr {
  override Class getTarget() { result = this.getEnclosingCallable().getDeclaringType() }

  override string toString() { result = "this access" }

  override string getAPrimaryQlClass() { result = "ThisAccess" }
}

/**
 * A `base` access, for example `base` on line 2 in
 *
 * ```csharp
 * public override void Dispose() {
 *   base.Dispose();
 *   ...
 * }
 * ```
 */
class BaseAccess extends Access, @base_access_expr {
  override Class getTarget() {
    result = this.getEnclosingCallable().getDeclaringType().getBaseClass()
  }

  override string toString() { result = "base access" }

  override string getAPrimaryQlClass() { result = "BaseAccess" }
}

/**
 * A member access. Either an access to a field (`FieldAccess`), an access to a
 * property (`PropertyAccess`), an access to an indexer (`IndexerAccess`), an
 * access to an event (`EventAccess`), an access to a method (`MethodAccess`),
 * an access to a type (`TypeAccess`), or a dynamic member access
 * (`DynamicMemberAccess`).
 */
class MemberAccess extends Access, QualifiableExpr, @member_access_expr {
  override predicate hasImplicitThisQualifier() {
    QualifiableExpr.super.hasImplicitThisQualifier() and
    not exists(MemberInitializer mi | mi.getLValue() = this)
  }

  override Member getQualifiedDeclaration() { result = this.getTarget() }

  override Member getTarget() { none() }
}

/**
 * An assignable access, that is, an access that is valid on the left-hand side
 * of some assignment. Either an access to a variable (`VariableAccess`), an
 * access to a property (`PropertyAccess`), an access to an element
 * (`ElementAccess`), an access to an event (`EventAccess`), or a dynamic member
 * access (`DynamicMemberAccess`).
 */
class AssignableAccess extends Access, @assignable_access_expr {
  override Assignable getTarget() { none() }

  /**
   * Holds if this access passes the assignable being accessed as an `out`
   * argument in a method call.
   */
  predicate isOutArgument() { expr_argument(this, 2) }

  /**
   * Holds if this access passes the assignable being accessed as a `ref`
   * argument in a method call.
   */
  predicate isRefArgument() { expr_argument(this, 1) }

  /**
   * Holds if this access passes the assignable being accessed as an `out`
   * or a `ref` argument in a method call.
   */
  predicate isOutOrRefArgument() {
    this.isOutArgument() or
    this.isRefArgument()
  }

  /**
   * Holds if this access passes the assignable being accessed as an `in`
   * argument in a method call.
   */
  predicate isInArgument() { expr_argument(this, 3) }
}

/**
 * An access to a variable. Either an access to a local scope variable
 * (`LocalScopeVariableAccess`) or an access to a field (`FieldAccess`).
 */
class VariableAccess extends AssignableAccess, @variable_access_expr {
  override Variable getTarget() { expr_access(this, result) }
}

/**
 * An access to a variable that reads the underlying value. Either an
 * access to a local scope variable (`LocalScopeVariableRead`) or an
 * access to a field (`FieldRead`).
 */
class VariableRead extends VariableAccess, AssignableRead {
  override VariableRead getANextRead() { result = AssignableRead.super.getANextRead() }

  override VariableRead getAReachableRead() { result = AssignableRead.super.getAReachableRead() }
}

/**
 * An access to a variable that updates the underlying value.  Either an
 * access to a local scope variable (`LocalScopeVariableWrite`) or an
 * access to a field (`FieldWrite`).
 */
class VariableWrite extends VariableAccess, AssignableWrite { }

/**
 * An access to a local scope variable. Either an access to a parameter
 * (`ParameterAccess`) or an access to a local variable (`LocalVariableAccess`).
 */
class LocalScopeVariableAccess extends VariableAccess, @local_scope_variable_access_expr {
  override LocalScopeVariable getTarget() { expr_access(this, result) }
}

/**
 * An access to a local scope variable that reads the underlying value. Either
 * an access to a parameter (`ParameterRead`) or an access to a local variable
 * (`LocalVariableRead`).
 */
class LocalScopeVariableRead extends LocalScopeVariableAccess, VariableRead {
  override LocalScopeVariableRead getANextRead() { result = VariableRead.super.getANextRead() }

  override LocalScopeVariableRead getAReachableRead() {
    result = VariableRead.super.getAReachableRead()
  }
}

/**
 * An access to a local scope variable that updates the underlying value. Either
 * an access to a parameter (`ParameterWrite`) or an access to a local variable
 * (`LocalVariableWrite`).
 */
class LocalScopeVariableWrite extends LocalScopeVariableAccess, VariableWrite { }

/**
 * An access to a parameter, for example the access to `p` on line 2 in
 *
 * ```csharp
 * int M(int p) {
 *   return -p;
 * }
 * ```
 */
class ParameterAccess extends LocalScopeVariableAccess, @parameter_access_expr {
  override Parameter getTarget() { expr_access(this, result) }

  override string toString() { result = "access to parameter " + this.getTarget().getName() }

  override string getAPrimaryQlClass() { result = "ParameterAccess" }
}

/**
 * An access to a parameter that reads the underlying value, for example
 * the access to `p` on line 2 in
 *
 * ```csharp
 * int M(int p) {
 *   return -p;
 * }
 * ```
 */
class ParameterRead extends ParameterAccess, LocalScopeVariableRead {
  override ParameterRead getANextRead() { result = LocalScopeVariableRead.super.getANextRead() }

  override ParameterRead getAReachableRead() {
    result = LocalScopeVariableRead.super.getAReachableRead()
  }
}

/**
 * An access to a parameter that updates the underlying value, for example
 * the access to `p` on line 2 in
 *
 * ```csharp
 * int M(int p) {
 *   p = 1;
 *   return p;
 * }
 * ```
 */
class ParameterWrite extends ParameterAccess, VariableWrite { }

/**
 * An access to a local variable, for example the access to `x` on line 3 in
 *
 * ```csharp
 * int M(int p) {
 *   var x = -p;
 *   return x;
 * }
 * ```
 */
class LocalVariableAccess extends LocalScopeVariableAccess, @local_variable_access {
  override LocalVariable getTarget() { result = AccessImpl::getLocalVariableAccessTarget(this) }

  override string toString() {
    // If this access is also a local variable declaration (that is, an `out` declared
    // variable), then use the `toString()` implementation from `LocalVariableDeclExpr`
    not this instanceof LocalVariableDeclExpr and
    result = "access to local variable " + this.getTarget().getName()
  }

  override string getAPrimaryQlClass() { result = "LocalVariableAccess" }
}

/**
 * An access to a local variable that reads the underlying value, for example
 * the access to `x` on line 3 in
 *
 * ```csharp
 * int M(int p) {
 *   var x = -p;
 *   return x;
 * }
 * ```
 */
class LocalVariableRead extends LocalVariableAccess, LocalScopeVariableRead {
  override LocalVariableRead getANextRead() { result = LocalScopeVariableRead.super.getANextRead() }

  override LocalVariableRead getAReachableRead() {
    result = LocalScopeVariableRead.super.getAReachableRead()
  }
}

/**
 * An access to a local variable that updates the underlying value, for example
 * the access to `x` on line 3 in
 *
 * ```csharp
 * int M(int p) {
 *   int x;
 *   x = -p;
 *   return x;
 * }
 * ```
 */
class LocalVariableWrite extends LocalVariableAccess, VariableWrite { }

/**
 * An access to a field, for example the access to `F` on line 5 in
 *
 * ```csharp
 * class C {
 *   int F = 0;
 *
 *   int GetF() {
 *     return F;
 *   }
 * }
 * ```
 */
class FieldAccess extends AssignableMemberAccess, VariableAccess, @field_access_expr {
  override Field getTarget() { expr_access(this, result) }

  override string toString() { result = "access to field " + this.getTarget().getName() }

  override string getAPrimaryQlClass() { result = "FieldAccess" }
}

/**
 * An access to a field that reads the underlying value, for example the
 * access to `F` on line 5 in
 *
 * ```csharp
 * class C {
 *   int F = 0;
 *
 *   int GetF() {
 *     return F;
 *   }
 * }
 * ```
 */
class FieldRead extends FieldAccess, VariableRead { }

/**
 * An access to a field that updates the underlying value, for example the
 * access to `F` on line 5 in
 *
 * ```csharp
 * class C {
 *   int F = 0;
 *
 *   void SetF(int i) {
 *     F = i;
 *   }
 * }
 * ```
 */
class FieldWrite extends FieldAccess, VariableWrite { }

/**
 * An access to a member (field), for example the access to `F` on line 5 in
 *
 * ```csharp
 * class C {
 *   const int F = 0;
 *
 *   int GetF() {
 *     return F;
 *   }
 * }
 * ```
 */
class MemberConstantAccess extends FieldAccess {
  MemberConstantAccess() { super.getTarget() instanceof MemberConstant }

  override MemberConstant getTarget() { expr_access(this, result) }

  override string toString() { result = "access to constant " + this.getTarget().getName() }

  override string getAPrimaryQlClass() { result = "MemberConstantAccess" }
}

/**
 * An internal helper class to share logic between `PropertyAccess` and
 * `PropertyCall`.
 */
library class PropertyAccessExpr extends Expr, @property_access_expr {
  /** Gets the target of this property access. */
  Property getProperty() { expr_access(this, result) }

  override string toString() {
    result = "access to property " + this.getProperty().getName()
    or
    not exists(this.getProperty()) and
    result = "access to property (unknown)"
  }
}

/**
 * An access to a property, for example the access to `P` on line 5 in
 *
 * ```csharp
 * class C {
 *   int P { get; private set; }
 *
 *   int GetP() {
 *     return P;
 *   }
 * }
 * ```
 */
class PropertyAccess extends AssignableMemberAccess, PropertyAccessExpr {
  override Property getTarget() { result = this.getProperty() }
}

/**
 * An access to a property that reads the underlying value, for example
 * the access to `P` on line 5 in
 *
 * ```csharp
 * class C {
 *   int P { get; private set; }
 *
 *   int GetP() {
 *     return P;
 *   }
 * }
 * ```
 */
class PropertyRead extends PropertyAccess, AssignableRead {
  override PropertyRead getANextRead() { result = AssignableRead.super.getANextRead() }

  override PropertyRead getAReachableRead() { result = AssignableRead.super.getAReachableRead() }
}

/**
 * An access to a property that updates the underlying value, for example the
 * access to `P` on line 5 in
 *
 * ```csharp
 * class C {
 *   int P { get; private set; }
 *
 *   void SetP(int i) {
 *     P = i;
 *   }
 * }
 * ```
 */
class PropertyWrite extends PropertyAccess, AssignableWrite { }

/**
 * An access to a trivial property - a property with a default getter and
 * setter. For example, the access to `P` on line 5 in
 *
 * ```csharp
 * class C {
 *   int P { get; private set; }
 *
 *   int GetP() {
 *     return P;
 *   }
 * }
 * ```
 */
class TrivialPropertyAccess extends PropertyAccess {
  TrivialPropertyAccess() { this.getTarget() instanceof TrivialProperty }
}

/**
 * An access to a virtual property - a property that is virtual or defined in
 * an interface. For example, the access to `P` on line 5 in
 *
 * ```csharp
 * class C {
 *   virtual int P { get; private set; }
 *
 *   int GetP() {
 *     return P;
 *   }
 * }
 * ```
 */
class VirtualPropertyAccess extends PropertyAccess {
  VirtualPropertyAccess() { this.targetIsOverridableOrImplementable() }
}

/**
 * An access to an element. Either an access to an indexer (`IndexerAccess`),
 * an access to an array (`ArrayAccess`), or a dynamic element access
 * (`DynamicElementAccess`).
 */
class ElementAccess extends AssignableAccess, QualifiableExpr, @element_access_expr {
  /**
   * Gets an index expression of this element access, for example
   * `1` in `x[0, 1]`.
   */
  Expr getAnIndex() { result = this.getIndex(_) }

  /**
   * Gets the `i`th index expression of this element access, for example the
   * second (`i = 1`) index expression is `1` in `x[0, 1]`.
   */
  Expr getIndex(int i) { result = this.getChild(i) and i >= 0 }

  override Assignable getQualifiedDeclaration() { result = this.getTarget() }
}

/**
 * An access to an element that reads the underlying value. Either an access
 * to an indexer (`IndexerRead`), an access to an array (`ArrayRead`), or an
 * access to a dynamic element (`DynamicElementRead`).
 */
class ElementRead extends ElementAccess, AssignableRead { }

/**
 * An access to an element that updates the underlying value. Either an access
 * to an indexer (`IndexerWrite`), an access to an array (`ArrayWrite`), or an
 * access to a dynamic element (`DynamicElementWrite`).
 */
class ElementWrite extends ElementAccess, AssignableWrite { }

/**
 * An internal helper class to share logic between `IndexerAccess` and
 * `IndexerCall`.
 */
library class IndexerAccessExpr extends Expr, @indexer_access_expr {
  /** Gets the target of this indexer access. */
  Indexer getIndexer() { expr_access(this, result) }

  override string toString() { result = "access to indexer" }
}

/**
 * An access to an indexer, for example the access to `c` on line 5 in
 *
 * ```csharp
 * class C {
 *   public string this[int i] { ... }
 *
 *   static string GetItem(C c) {
 *     return c[0];
 *   }
 * }
 * ```
 */
class IndexerAccess extends AssignableMemberAccess, ElementAccess, IndexerAccessExpr {
  override Indexer getTarget() { result = this.getIndexer() }

  override Indexer getQualifiedDeclaration() {
    result = ElementAccess.super.getQualifiedDeclaration()
  }
}

/**
 * An access to an indexer that reads the underlying value, for example the
 * access to `c` on line 5 in
 *
 * ```csharp
 * class C {
 *   public string this[int i] { ... }
 *
 *   static string GetItem(C c) {
 *     return c[0];
 *   }
 * }
 * ```
 */
class IndexerRead extends IndexerAccess, ElementRead {
  override IndexerRead getANextRead() { result = ElementRead.super.getANextRead() }

  override IndexerRead getAReachableRead() { result = ElementRead.super.getAReachableRead() }
}

/**
 * An access to an indexer that updates the underlying value, for example the
 * access to `c` on line 5 in
 *
 * ```csharp
 * class C {
 *   public string this[int i] { ... }
 *
 *   static void SetItem(C c, int i, string s) {
 *     c[i] = s;
 *   }
 * }
 * ```
 */
class IndexerWrite extends IndexerAccess, ElementWrite { }

/**
 * An access to a virtual indexer - an indexer that is virtual or defined in
 * an interface. For example, the access to `c` on line 5 in
 *
 * ```csharp
 * class C {
 *   public virtual string this[int i] { ... }
 *
 *   static string GetItem(C c) {
 *     return c[0];
 *   }
 * }
 * ```
 */
class VirtualIndexerAccess extends IndexerAccess {
  VirtualIndexerAccess() { this.targetIsOverridableOrImplementable() }
}

/**
 * An internal helper class to share logic between `EventAccess` and
 * `EventCall`.
 */
library class EventAccessExpr extends Expr, @event_access_expr {
  /** Gets the target of this event access. */
  Event getEvent() { expr_access(this, result) }

  override string toString() { result = "access to event " + this.getEvent().getName() }
}

/**
 * An access to an event, for example the accesses to `Click` on lines
 * 7 and 8 in
 *
 * ```csharp
 * class C {
 *   public delegate void EventHandler(object sender, object e);
 *
 *   public event EventHandler Click;
 *
 *   protected void OnClick(object e) {
 *     if (Click != null)
 *       Click(this, e);
 *   }
 * }
 * ```
 */
class EventAccess extends AssignableMemberAccess, EventAccessExpr {
  override Event getTarget() { result = this.getEvent() }

  override string getAPrimaryQlClass() { result = "EventAccess" }
}

/**
 * An access to an event that reads the underlying value, for example the
 * accesses to `Click` on lines 7 and 8 in
 *
 * ```csharp
 * class C {
 *   public delegate void EventHandler(object sender, object e);
 *
 *   public event EventHandler Click;
 *
 *   protected void OnClick(object e) {
 *     if (Click != null)
 *       Click(this, e);
 *   }
 * }
 * ```
 */
class EventRead extends EventAccess, AssignableRead { }

/**
 * An access to an event that updates the underlying value, for example the
 * access to `Click` on line 7 in
 *
 * ```csharp
 * class C {
 *   public delegate void EventHandler(object sender, object e);
 *
 *   event EventHandler Click;
 *
 *   public void AddClickEvent(EventHandler handler) {
 *     Click += handler;
 *   }
 * }
 * ```
 */
class EventWrite extends EventAccess, AssignableWrite { }

/**
 * An access to a virtual event - an event that is virtual or defined in
 * an interface. For example, the accesses to `Click` on lines 7 and 8 in
 *
 * ```csharp
 * class C {
 *   public delegate void EventHandler(object sender, object e);
 *
 *   public virtual event EventHandler Click;
 *
 *   protected void OnClick(object e) {
 *     if (Click != null)
 *       Click(this, e);
 *   }
 * }
 * ```
 */
class VirtualEventAccess extends EventAccess {
  VirtualEventAccess() { this.targetIsOverridableOrImplementable() }
}

/**
 * An access to a callable. Either a method access (`MethodAccess`) or a local
 * function access (`LocalFunctionAccess`).
 *
 * Note that a callable access is *not* the same as a call.
 */
class CallableAccess extends Access, @method_access_expr {
  override Callable getTarget() { expr_access(this, result) }
}

/**
 * An access to a method, for example the access to `Filter` on line 5 in
 *
 * ```csharp
 * class C {
 *   bool Filter(string s) { ... }
 *
 *   public IEnumerable<string> DoFilter(IEnumerable<string> list) {
 *     return list.Where(Filter);
 *   }
 * }
 * ```
 *
 * Note that a method access is *not* the same as a method call (`MethodCall`).
 */
class MethodAccess extends MemberAccess, CallableAccess {
  MethodAccess() { expr_access(this, any(Method m)) }

  override Method getTarget() { expr_access(this, result) }

  override string toString() { result = "access to method " + this.getTarget().getName() }

  override string getAPrimaryQlClass() { result = "MethodAccess" }
}

/**
 * An access to a local function, for example the access to `Filter` on line 4 in
 *
 * ```csharp
 * class C {
 *   public IEnumerable<string> DoFilter(IEnumerable<string> list) {
 *     bool Filter(string s) { ... };
 *     return list.Where(Filter);
 *   }
 * }
 * ```
 *
 * Note that a local function access is *not* the same as a local function call
 * (`LocalFunctionCall`).
 */
class LocalFunctionAccess extends CallableAccess {
  LocalFunctionAccess() { expr_access(this, any(LocalFunction f)) }

  override LocalFunction getTarget() { expr_access(this, result) }

  override string toString() { result = "access to local function " + this.getTarget().getName() }

  override string getAPrimaryQlClass() { result = "LocalFunctionAccess" }
}

/**
 * An access to a virtual method - a method that is virtual or defined in
 * an interface. For example, the access to `Filter` on line 5 in
 *
 * ```csharp
 * class C {
 *   public virtual bool Filter(string s) { ... }
 *
 *   public IEnumerable<string> DoFilter(IEnumerable<string> list) {
 *     return list.Where(Filter);
 *   }
 * }
 *
 * Note that a method access is *not* the same as a method call (`MethodCall`).
 * ```
 */
class VirtualMethodAccess extends MethodAccess {
  VirtualMethodAccess() { this.targetIsOverridableOrImplementable() }
}

/**
 * An access to a type, for example the access to `C` on line 3 in
 *
 * ```csharp
 * class C {
 *   public Type GetCType() {
 *     return typeof(C);
 *   }
 * }
 * ```
 */
class TypeAccess extends MemberAccess, @type_access_expr {
  override Type getTarget() { result = this.getType() }

  override string toString() { result = "access to type " + this.getTarget().getName() }

  override string getAPrimaryQlClass() { result = "TypeAccess" }
}

/**
 * An access to an array, for example the access to `args` on line 3 in
 *
 * ```csharp
 * public int FirstOrNegative(params int[] args) {
 *   return args.Length > 0
 *     ? args[0]
 *     : -1;
 *
 * }
 * ```
 */
class ArrayAccess extends ElementAccess, @array_access_expr {
  override string toString() { result = "access to array element" }

  // Although an array (element) can be assigned a value, there is no
  // corresponding assignable (`ArrayAccess` does not extend `MemberAccess`)
  override Assignable getTarget() { none() }

  override string getAPrimaryQlClass() { result = "ArrayAccess" }
}

/**
 * An access to an array that reads the underlying value, for example
 * the access to `a` on line 2 in
 *
 * ```csharp
 * public string Get(string[] a, int i) {
 *   return a[i];
 * }
 * ```
 */
class ArrayRead extends ArrayAccess, ElementRead { }

/**
 * An access to an array that updates the underlying value, for example
 * the access to `a` on line 2 in
 *
 * ```csharp
 * public void Set(string[] a, int i, string s) {
 *   a[i] = s;
 * }
 * ```
 */
class ArrayWrite extends ArrayAccess, ElementWrite { }

/**
 * An access to a namespace, for example `System` in `nameof(System)`.
 */
class NamespaceAccess extends Access, @namespace_access_expr {
  override Namespace getTarget() { expr_access(this, result) }

  override string toString() { result = "access to namespace " + this.getTarget().getName() }

  override string getAPrimaryQlClass() { result = "NamespaceAccess" }
}
