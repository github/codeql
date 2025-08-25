/**
 * Provides all call classes.
 *
 * All calls have the common base class `Call`.
 */

import Expr
private import semmle.code.csharp.dataflow.internal.DataFlowDispatch
private import semmle.code.csharp.dataflow.internal.DataFlowImplCommon
private import semmle.code.csharp.dispatch.Dispatch

/**
 * A call. Either a method call (`MethodCall`), a constructor initializer call
 * (`ConstructorInitializer`), a call to a user-defined operator (`OperatorCall`),
 * a delegate call (`DelegateCall`), an accessor call (`AccessorCall`), a
 * constructor call (`ObjectCreation`), or a local function call (`LocalFunctionCall`).
 */
class Call extends Expr, @call {
  /**
   * Gets the static (compile-time) target of this call. For example, the
   * static target of `x.M()` on line 9 is `A.M` in
   *
   * ```csharp
   * class A {
   *   virtual void M() { }
   * }
   *
   * class B : A {
   *   override void M() { }
   *
   *   static void CallM(A x) {
   *     x.M();
   *   }
   * }
   * ```
   *
   * Use `getARuntimeTarget()` instead to get a potential run-time target (will
   * include `B.M` in the example above).
   */
  Callable getTarget() { none() }

  /** Gets the `i`th argument to this call, if any. */
  Expr getArgument(int i) { result = this.getChild(i) and i >= 0 }

  /**
   * Gets the `i`th "raw" argument to this call, if any.
   * For instance methods, argument 0 is the qualifier.
   */
  Expr getRawArgument(int i) { result = this.getArgument(i) }

  /** Gets an argument to this call. */
  Expr getAnArgument() { result = this.getArgument(_) }

  /** Gets the number of arguments of this call. */
  int getNumberOfArguments() { result = count(this.getAnArgument()) }

  /** Holds if this call has no arguments. */
  predicate hasNoArguments() { not exists(this.getAnArgument()) }

  /**
   * Gets the argument for this call associated with the parameter `p`, if any.
   *
   * This takes into account both positional and named arguments, but does not
   * consider default arguments.
   */
  cached
  Expr getArgumentForParameter(Parameter p) {
    // Appears in the positional part of the call
    result = this.getImplicitArgument(p)
    or
    // Appears in the named part of the call
    this.getTarget().getAParameter() = p and
    result = this.getExplicitArgument(p.getName())
  }

  pragma[noinline]
  private Expr getImplicitArgument(Parameter p) {
    this.getTarget().getAParameter() = p and
    not exists(result.getExplicitArgumentName()) and
    (
      p.(Parameter).isParams() and
      result = this.getArgument(any(int i | i >= p.getPosition()))
      or
      not p.(Parameter).isParams() and
      result = this.getArgument(p.getPosition())
    )
  }

  pragma[nomagic]
  private Expr getExplicitArgument(string name) {
    result = this.getAnArgument() and
    result.getExplicitArgumentName() = name
  }

  /**
   * Gets the argument to this call associated with the parameter with the given
   * `name`, if any.
   *
   * This takes into account both positional and named arguments, but does not
   * consider default arguments.
   */
  Expr getArgumentForName(string name) {
    exists(Parameter p |
      result = this.getArgumentForParameter(p) and
      p.hasName(name)
    )
  }

  /**
   * Gets a potential run-time target of this call.
   *
   * A potential target is a callable that is neither abstract nor defined in an
   * interface.
   *
   * Unlike `getTarget()`, this predicate takes reflection/dynamic based calls,
   * virtual dispatch, and delegate calls into account. Example:
   *
   * ```csharp
   * class A {
   *   virtual void M() { }
   * }
   *
   * class B : A {
   *   override void M() { }
   *
   *   static void CallM(A a) {
   *     a.M();
   *     typeof(A).InvokeMember("M", BindingFlags.Public, null, a, new object[0]);
   *   }
   * }
   *
   * class C {
   *   void M2(Action<int> a) {
   *     a(0);
   *   }
   *
   *   static void CallM2(C c) {
   *     c.M2(i => { });
   *   }
   * }
   * ```
   *
   * - Line 9: The static target is `A.M()`, whereas the run-time targets are both
   *   `A.M()` and `B.M()`.
   *
   * - Line 10: The static target is `Type.InvokeMember()`, whereas the run-time targets
   *   are both `A.M()` and `B.M()`.
   *
   * - Line 16: There is no static target (delegate call) but the delegate `i => { }`
   *   (line 20) is a run-time target.
   */
  Callable getARuntimeTarget() {
    exists(DispatchCall dc | dc.getCall() = this | result = dc.getADynamicTarget())
  }

  /**
   * Gets the argument that corresponds to the `i`th parameter of a potential
   * run-time target of this call.
   *
   * Unlike `getArgument()`, this predicate takes reflection based calls and named
   * arguments into account. Example:
   *
   * ```csharp
   * class A {
   *   virtual void M(int first, int second) { }
   *
   *   static void CallM(A a) {
   *     a.M(second: 1, first: 2);
   *     typeof(A).InvokeMember("M", BindingFlags.Public, null, a, new int[]{ 1, 2 });
   *   }
   * }
   * ```
   *
   * - Line 5: The first and second arguments are `1` and `2`, respectively. However,
   *   the first and second run-time arguments of `A.M()` are `2` and `1`, respectively.
   *
   * - Line 6: The static target is `Type.InvokeMember()` and the first, second, third,
   *   fourth, and fifth arguments are `"M"`, `BindingFlags.Public`, `null`, `a`, and
   *   `new int[]{ 1, 2 }`, respectively. However, the run-time target is `A.M()` and
   *   the first and second arguments are `1` and `2`, respectively.
   */
  Expr getRuntimeArgument(int i) {
    exists(DispatchCall dc | dc.getCall() = this | result = dc.getArgument(i))
  }

  /**
   * Gets the argument that corresponds to parameter `p` of a potential
   * run-time target of this call.
   *
   * This takes into account both positional and named arguments, but does not
   * consider default arguments.
   */
  cached
  Expr getRuntimeArgumentForParameter(Parameter p) {
    // Appears in the positional part of the call
    result = this.getImplicitRuntimeArgument(p)
    or
    // Appears in the named part of the call
    this.getARuntimeTarget().getAParameter() = p and
    result = this.getExplicitRuntimeArgument(p.getName())
  }

  pragma[noinline]
  private Expr getImplicitRuntimeArgument(Parameter p) {
    this.getARuntimeTarget().getAParameter() = p and
    not exists(result.getExplicitArgumentName()) and
    (
      p.isParams() and
      result = this.getRuntimeArgument(any(int i | i >= p.getPosition()))
      or
      not p.isParams() and
      result = this.getRuntimeArgument(p.getPosition())
    )
  }

  pragma[nomagic]
  private Expr getExplicitRuntimeArgument(string name) {
    result = this.getARuntimeArgument() and
    result.getExplicitArgumentName() = name
  }

  /**
   * Gets the argument that corresponds to a parameter named `name` of a potential
   * run-time target of this call.
   */
  Expr getRuntimeArgumentForName(string name) {
    exists(Parameter p |
      result = this.getRuntimeArgumentForParameter(p) and
      p.hasName(name)
    )
  }

  /**
   * Gets an argument that corresponds to a parameter of a potential
   * run-time target of this call.
   */
  Expr getARuntimeArgument() { result = this.getRuntimeArgument(_) }

  /**
   * Gets the number of arguments that correspond to a parameter of a potential
   * run-time target of this call.
   */
  int getNumberOfRuntimeArguments() { result = count(this.getARuntimeArgument()) }

  /**
   * Holds if this call has no arguments that correspond to a parameter of a
   * potential (run-time) target of this call.
   */
  predicate hasNoRuntimeArguments() { not exists(this.getARuntimeArgument()) }

  override string toString() { result = "call" }
}

/**
 * A method call, for example `a.M()` on line 5 in
 *
 * ```csharp
 * class A {
 *   void M() { }
 *
 *   static void CallM(A a) {
 *     a.M();
 *   }
 * }
 * ```
 */
class MethodCall extends Call, QualifiableExpr, LateBindableExpr, @method_invocation_expr {
  override Method getTarget() { expr_call(this, result) }

  override Method getQualifiedDeclaration() { result = this.getTarget() }

  override string toString() { result = "call to method " + concat(this.getTarget().getName()) }

  override string getAPrimaryQlClass() { result = "MethodCall" }

  override Expr getRawArgument(int i) {
    if exists(this.getQualifier())
    then
      i = 0 and result = this.getQualifier()
      or
      result = this.getArgument(i - 1)
    else result = this.getArgument(i)
  }

  override Expr stripImplicit() {
    if this.isImplicit() then result = this.getQualifier().stripImplicit() else result = this
  }
}

/**
 * A call to an extension method, for example lines 5 and 6 in
 *
 * ```csharp
 * static class A {
 *   static void M(this int i) { }
 *
 *   static void CallM(int x) {
 *     x.M();
 *     M(x);
 *   }
 * }
 * ```
 *
 * Although, syntactically, `x` is a qualifier on line 5, it is treated
 * as the first argument in the method call (similar to the call on line
 * 6), in order to be properly matched with the parameter `i` on line 2.
 */
class ExtensionMethodCall extends MethodCall {
  ExtensionMethodCall() { this.getTarget() instanceof ExtensionMethod }

  override TypeAccess getQualifier() { result = this.getChildExpr(-1) }

  override Expr getArgument(int i) {
    exists(int j | result = this.getChildExpr(j) |
      if this.isOrdinaryStaticCall() then (j = i and j >= 0) else (j = i - 1 and j >= -1)
    )
  }

  /**
   * Holds if this call is an ordinary static method call, where the target
   * happens to be an extension method, for example the calls on lines 6 and
   * 7 (but not line 5) in
   *
   * ```csharp
   * static class Extensions {
   *   public static void Ext(int i) { }
   *
   *   static void M(int i) {
   *     i.Ext();
   *     Ext(i);
   *     Extensions.Ext(i);
   *   }
   * }
   * ```
   */
  predicate isOrdinaryStaticCall() {
    not exists(this.getChildExpr(-1)) // `Ext(i)` case above
    or
    exists(this.getQualifier()) // `Extensions.Ext(i)` case above
  }
}

/**
 * A virtual method call, for example `a.M()` on line 5 in
 *
 * ```csharp
 * class A {
 *   public virtual void M() { }
 *
 *   static void CallM(A a) {
 *     a.M();
 *   }
 * }
 * ```
 */
class VirtualMethodCall extends MethodCall {
  VirtualMethodCall() {
    not this.getQualifier() instanceof BaseAccess and
    this.getTarget().isOverridableOrImplementable()
  }
}

/**
 * A constructor initializer call, for example `base()` (line 6) and
 * `this(0)` (line 8) in
 *
 * ```csharp
 * class A
 * {
 *     public A() { }
 * }
 *
 * class B : A
 * {
 *     public B(int x) : base() { }
 *
 *     public B() : this(0) { }
 * }
 * ```
 */
class ConstructorInitializer extends Call, @constructor_init_expr {
  override Constructor getTarget() { expr_call(this, result) }

  override Constructor getARuntimeTarget() { result = Call.super.getARuntimeTarget() }

  override string toString() { result = "call to constructor " + this.getTarget().getName() }

  override string getAPrimaryQlClass() { result = "ConstructorInitializer" }

  private ValueOrRefType getTargetType() {
    result = this.getTarget().getDeclaringType().getUnboundDeclaration()
  }

  private ValueOrRefType getConstructorType() {
    result = this.getConstructor().getDeclaringType().getUnboundDeclaration()
  }

  /**
   * Holds if this initializer is a `this` initializer, for example `this(0)`
   * in
   *
   * ```csharp
   * class A
   * {
   *     A(int i) { }
   *     A() : this(0) { }
   * }
   * ```
   */
  predicate isThis() { this.getTargetType() = this.getConstructorType() }

  /**
   * Holds if this initializer is a `base` initializer, for example `base(0)`
   * in
   *
   * ```csharp
   * class A
   * {
   *     A(int i) { }
   * }
   *
   * class B : A
   * {
   *     B() : base(0) { }
   * }
   * ```
   */
  predicate isBase() { this.getTargetType() != this.getConstructorType() }

  /**
   * Gets the constructor that this initializer call belongs to. For example,
   * the initializer call `base()` on line 7 belongs to the constructor `B`
   * on line 6 in
   *
   * ```csharp
   * class A
   * {
   *     public A() { }
   * }
   *
   * class B : A
   * {
   *     public B() : base() { }
   * }
   * ```
   */
  Constructor getConstructor() { result.getInitializer() = this }

  override Expr getRawArgument(int i) {
    if this.getTarget().isStatic()
    then result = this.getArgument(i)
    else result = this.getArgument(i - 1)
  }
}

/**
 * A call to a user-defined operator, for example `this + other`
 * on line 7 in
 *
 * ```csharp
 * class A {
 *   public static A operator+(A left, A right) {
 *     return left;
 *   }
 *
 *   public A Add(A other) {
 *     return this + other;
 *   }
 * }
 * ```
 */
class OperatorCall extends Call, LateBindableExpr, @operator_invocation_expr {
  override Operator getTarget() { expr_call(this, result) }

  override Operator getARuntimeTarget() { result = Call.super.getARuntimeTarget() }

  override string toString() { result = "call to operator " + this.getTarget().getName() }

  override string getAPrimaryQlClass() { result = "OperatorCall" }
}

/**
 * A call to a user-defined mutator operator, for example `a++` on
 * line 7 in
 *
 * ```csharp
 * class A {
 *   public static A operator++(A a) {
 *     return a;
 *   }
 *
 *   public static A Increment(A a) {
 *     return a++;
 *   }
 * }
 * ```
 */
class MutatorOperatorCall extends OperatorCall {
  MutatorOperatorCall() { mutator_invocation_mode(this, _) }

  /** Holds if the operator is in prefix position. */
  predicate isPrefix() { mutator_invocation_mode(this, 1) }

  /** Holds if the operator is in postfix position. */
  predicate isPostfix() { mutator_invocation_mode(this, 2) }
}

private class DelegateLikeCall_ = @delegate_invocation_expr or @function_pointer_invocation_expr;

/**
 * A function pointer or delegate call.
 */
class DelegateLikeCall extends Call, DelegateLikeCall_ {
  override Callable getTarget() { none() }

  /**
   * Gets the delegate or function pointer expression of this call. For example, the
   * delegate expression of `X()` on line 5 is the access to the field `X` in
   *
   * ```csharp
   * class A {
   *   Action X = () => { };
   *
   *   void CallX() {
   *     X();
   *   }
   * }
   * ```
   */
  Expr getExpr() { result = this.getChild(-1) }

  final override Callable getARuntimeTarget() {
    exists(ExplicitDelegateLikeDataFlowCall call |
      this = call.getCall() and
      result = viableCallableLambda(call, _).asCallable(_)
    )
  }

  override Expr getRuntimeArgument(int i) { result = this.getArgument(i) }
}

/**
 * A delegate call, for example `x()` on line 5 in
 *
 * ```csharp
 * class A {
 *   Action X = () => { };
 *
 *   void CallX() {
 *     X();
 *   }
 * }
 * ```
 */
class DelegateCall extends DelegateLikeCall, @delegate_invocation_expr {
  override string toString() { result = "delegate call" }

  override string getAPrimaryQlClass() { result = "DelegateCall" }
}

/**
 * A function pointer call, for example `fp(1)` on line 3 in
 *
 * ```csharp
 * class A {
 *   void Call(delegate*<int, void> fp) {
 *     fp(1);
 *   }
 * }
 * ```
 */
class FunctionPointerCall extends DelegateLikeCall, @function_pointer_invocation_expr {
  override string toString() { result = "function pointer call" }

  override string getAPrimaryQlClass() { result = "FunctionPointerCall" }
}

/**
 * A call to an accessor. Either a property accessor call (`PropertyCall`),
 * an indexer accessor call (`IndexerCall`), or an event accessor call
 * (`EventCall`).
 */
class AccessorCall extends Call, QualifiableExpr, @call_access_expr {
  override Accessor getTarget() { none() }

  override Expr getArgument(int i) { none() }

  override Accessor getARuntimeTarget() { result = Call.super.getARuntimeTarget() }
}

/**
 * A call to a property accessor, for example the call to `get_P` on
 * line 5 in
 *
 * ```csharp
 * class A {
 *   int P { get { return 0; } }
 *
 *   public int GetP() {
 *     return P;
 *   }
 * }
 * ```
 */
class PropertyCall extends AccessorCall, PropertyAccessExpr {
  override Accessor getTarget() {
    exists(PropertyAccess pa, Property p | pa = this and p = this.getProperty() |
      pa instanceof AssignableRead and result = p.getGetter()
      or
      pa instanceof AssignableWrite and result = p.getSetter()
    )
  }

  override Expr getArgument(int i) {
    i = 0 and
    result = AssignableInternal::getAccessorCallValueArgument(this)
  }

  override string toString() { result = PropertyAccessExpr.super.toString() }

  override string getAPrimaryQlClass() { result = "PropertyCall" }
}

/**
 * A call to an indexer accessor, for example the call to `get_Item`
 * (defined on line 3) on line 7 in
 *
 * ```csharp
 * class A {
 *   string this[int i] {
 *     get { return i.ToString(); }
 *   }
 *
 *   public string GetItem(int i) {
 *     return this[i];
 *   }
 * }
 * ```
 */
class IndexerCall extends AccessorCall, IndexerAccessExpr {
  override Accessor getTarget() {
    exists(IndexerAccess ia, Indexer i | ia = this and i = this.getIndexer() |
      ia instanceof AssignableRead and result = i.getGetter()
      or
      ia instanceof AssignableWrite and result = i.getSetter()
    )
  }

  override Expr getArgument(int i) {
    result = this.(ElementAccess).getIndex(i)
    or
    i = count(this.(ElementAccess).getAnIndex()) and
    result = AssignableInternal::getAccessorCallValueArgument(this)
  }

  override string toString() { result = IndexerAccessExpr.super.toString() }

  override string getAPrimaryQlClass() { result = "IndexerCall" }
}

/**
 * A call to an event accessor, for example the call to `add_Click`
 * (defined on line 5) on line 12 in
 *
 * ```csharp
 * class A {
 *   public delegate void EventHandler(object sender, object e);
 *
 *   public event EventHandler Click {
 *     add { ... }
 *     remove { ... }
 *   }
 *
 *   void A_Click(object sender, object e) {  }
 *
 *   void AddEvent() {
 *     Click += A_Click;
 *   }
 * }
 * ```
 */
class EventCall extends AccessorCall, EventAccessExpr {
  override EventAccessor getTarget() {
    exists(Event e, AddOrRemoveEventExpr aoree |
      e = this.getEvent() and
      aoree.getLValue() = this
    |
      aoree instanceof AddEventExpr and result = e.getAddEventAccessor()
      or
      aoree instanceof RemoveEventExpr and result = e.getRemoveEventAccessor()
    )
  }

  override Expr getArgument(int i) {
    i = 0 and
    exists(AddOrRemoveEventExpr aoree |
      aoree.getLValue() = this and
      result = aoree.getRValue()
    )
  }

  override string toString() { result = EventAccessExpr.super.toString() }

  override string getAPrimaryQlClass() { result = "EventCall" }
}

/**
 * A call to a local function, for example the call `Fac(n)` on line 6 in
 *
 * ```csharp
 * int Choose(int n, int m) {
 *   int Fac(int x) {
 *     return x > 1 ? x * Fac(x - 1) : 1;
 *   }
 *
 *   return Fac(n) / (Fac(m) * Fac(n - m));
 * }
 * ```
 */
class LocalFunctionCall extends Call, @local_function_invocation_expr {
  override LocalFunction getTarget() { expr_call(this, result) }

  override string toString() { result = "call to local function " + this.getTarget().getName() }

  override string getAPrimaryQlClass() { result = "LocalFunctionCall" }
}
