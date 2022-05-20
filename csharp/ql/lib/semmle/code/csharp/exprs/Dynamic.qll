/**
 * Provides all `dynamic` expression classes.
 *
 * All `dynamic` expressions have the common base class `DynamicExpr`.
 */

import Expr
private import semmle.code.csharp.dispatch.Dispatch

/**
 * An expression involving one or more `dynamic` sub expressions. Either a
 * dynamic constructor call (`DynamicObjectCreation`), a dynamic method call
 * (`DynamicMethodCall`), a dynamic operator call (`DynamicOperatorCall`), a
 * dynamic member access (`DynamicMemberAccess`), a dynamic accessor call
 * (`DynamicAccessorCall`), or a dynamic element access (`DynamicElementAccess`).
 */
class DynamicExpr extends LateBindableExpr {
  DynamicExpr() { this.isLateBound() }
}

/**
 * A constructor call where one of the arguments is a `dynamic` expression, for
 * example `new A(d)` on line 8 in
 *
 * ```csharp
 * class A {
 *   A(int i) { }
 *
 *   A(string s) { }
 *
 *   public static A Create(bool b) {
 *     dynamic d = b ? 0 : (dynamic) "";
 *     return new A(d);
 *   }
 * }
 * ```
 *
 * Unlike an ordinary constructor call (`ObjectCreation`), the target constructor
 * may not be known at compile-time (as in the example above).
 */
class DynamicObjectCreation extends DynamicExpr, ObjectCreation {
  override string toString() {
    result = "dynamic object creation of type " + this.getType().getName()
  }

  override string getAPrimaryQlClass() { result = "DynamicObjectCreation" }
}

/**
 * A method call where the qualifier or one of the arguments is a `dynamic`
 * expression, for example `M(d)` on line 8 in
 *
 * ```csharp
 * class A {
 *   void M(int i) { }
 *
 *   void M(string s) { }
 *
 *   public static void CallM(bool b) {
 *     dynamic d = b ? 0 : (dynamic) "";
 *     M(d);
 *   }
 * }
 * ```
 *
 * Unlike an ordinary method call (`MethodCall`), the (static) target method
 * may not be known at compile-time (as in the example above).
 */
class DynamicMethodCall extends DynamicExpr, MethodCall {
  override string toString() { result = "dynamic call to method " + this.getLateBoundTargetName() }

  override string getAPrimaryQlClass() { result = "DynamicMethodCall" }
}

/**
 * A call to a user-defined operator where one of the operands is a `dynamic`
 * expression, for example `this + d` on line 12 in
 *
 * ```csharp
 * class A {
 *   public static A operator+(A left, int right) {
 *     return left;
 *   }
 *
 *   public static A operator+(A left, string right) {
 *     return left;
 *   }
 *
 *   public A Add(bool b) {
 *     dynamic d = b ? 0 : (dynamic) "";
 *     return this + d;
 *   }
 * }
 * ```
 *
 * Unlike an ordinary call to a user-defined operator (`OperatorCall`), the
 * target operator may not be known at compile-time (as in the example above).
 */
class DynamicOperatorCall extends DynamicExpr, OperatorCall {
  override string toString() {
    result = "dynamic call to operator " + this.getLateBoundTargetName()
  }

  override string getAPrimaryQlClass() { result = "DynamicOperatorCall" }
}

/**
 * A call to a user-defined mutator operator where the operand is a `dynamic`
 * expression, for example `d++` on line 20 in
 *
 * ```csharp
 * class A {
 *   public A() { }
 *
 *   public static A operator++(A a) {
 *     return a;
 *   }
 * }
 *
 * class B {
 *   public B() { }
 *
 *   public static B operator++(B b) {
 *     return b;
 *   }
 * }
 *
 * class C {
 *   public static dynamic Increment(bool b) {
 *     dynamic d = b ? new A() : (dynamic) new B();
 *     return d++;
 *   }
 * }
 * ```
 *
 * Unlike an ordinary call to a user-defined mutator operator
 * (`MutatorOperatorCall`), the target operator may not be known at compile-time
 * (as in the example above).
 */
class DynamicMutatorOperatorCall extends DynamicOperatorCall, MutatorOperatorCall { }

/**
 * An access where the qualifier is a `dynamic` expression. Either a dynamic
 * member access (`DynamicMemberAccess`) or a dynamic element access
 * (`DynamicElementAccess`).
 */
class DynamicAccess extends DynamicExpr {
  DynamicAccess() {
    this instanceof @dynamic_member_access_expr or
    this instanceof @dynamic_element_access_expr
  }
}

/**
 * A member access where the qualifier is a `dynamic` expression, for example
 * `d.X` on line 24 in
 *
 * ```csharp
 * class A {
 *   public A() { }
 *
 *   public int X;
 * }
 *
 * class B {
 *   public B() { }
 *
 *   public string X { get; set; }
 * }
 *
 * class C {
 *   public C() { }
 *
 *   public delegate void EventHandler(object sender, object e);
 *
 *   public event EventHandler X;
 * }
 *
 * class D {
 *   public dynamic GetX(int i) {
 *     dynamic d = i == 0 ? new A() : i > 0 ? new B() : (dynamic) new C();
 *     return d.X;
 *   }
 * }
 * ```
 *
 * Unlike an ordinary member access (`MemberAccess`), the target member may not
 * be known at compile-time (as in the example above). In particular, the type
 * of the member being accessed may not be known (it can be either a field, a
 * property, or an event).
 */
class DynamicMemberAccess extends DynamicAccess, MemberAccess, AssignableAccess,
  @dynamic_member_access_expr {
  override string toString() {
    result = "dynamic access to member " + this.getLateBoundTargetName()
  }

  override string getAPrimaryQlClass() { result = "DynamicMemberAccess" }

  // The target is unknown when the qualifier is a `dynamic` expression
  override DynamicMember getTarget() { none() }
}

/**
 * An access to a dynamic member that reads the underlying value, for example
 * `d.X` on line 16 in
 *
 * ```csharp
 * class A {
 *   public A() { }
 *
 *   public int X;
 * }
 *
 * class B {
 *   public B() { }
 *
 *   public int X { get; set; }
 * }
 *
 * class C {
 *   public int GetX(int i) {
 *     dynamic d = i == 0 ? new A() : (dynamic) new B();
 *     return d.X;
 *   }
 * }
 * ```
 */
class DynamicMemberRead extends DynamicMemberAccess, AssignableRead { }

/**
 * An access to a dynamic member that updates the underlying value, for
 * example `d.X` on line 16 in
 *
 * ```csharp
 * class A {
 *   public A() { }
 *
 *   public int X;
 * }
 *
 * class B {
 *   public B() { }
 *
 *   public int X { get; set; }
 * }
 *
 * class C {
 *   public void SetX(int i, int v) {
 *     dynamic d = i == 0 ? new A() : (dynamic) new B();
 *     d.X = v;
 *   }
 * }
 * ```
 */
class DynamicMemberWrite extends DynamicMemberAccess, AssignableWrite { }

/**
 * A possible target of a dynamic member access (`DynamicMemberAccess`). Either
 * a field (`Field`), a property (`Property`), or an event (`Event`).
 */
class DynamicMember extends AssignableMember {
  DynamicMember() {
    this instanceof Property or
    this instanceof Field or
    this instanceof Event
  }
}

/**
 * A call to an accessor where the qualifier is a `dynamic` expression, for
 * example `d.X` on line 20 and `d[0]` on line 25 in
 *
 * ```csharp
 * class A {
 *   public A() { }
 *
 *   public int X { get; set; }
 *
 *   public int this[int i] { get { return i + 1; } }
 * }
 *
 * class B {
 *   public B() { }
 *
 *   public string X { get; set; }
 *
 *   public string this[int i] { get { return i.ToString(); } }
 * }
 *
 * class C {
 *   public dynamic GetX(bool b) {
 *     dynamic d = b ? new A() : (dynamic) new B();
 *     return d.X;
 *   }
 *
 *   public dynamic GetItem(bool b) {
 *     dynamic d = b ? new A() : (dynamic) new B();
 *     return d[0];
 *   }
 * }
 * ```
 *
 * Unlike an ordinary accessor call (`AccessorCall`), the target accessor may
 * not be known at compile-time (as in the example above).
 */
class DynamicAccessorCall extends DynamicAccess {
  Accessor target;

  DynamicAccessorCall() {
    exists(DispatchCall dc | dc.getCall() = this | target = dc.getADynamicTarget())
  }

  /** Gets an actual run-time target of this dynamic accessor call. */
  Accessor getARuntimeTarget() { result = target }

  /** Gets the `i`th argument of this dynamic accessor call. */
  Expr getArgument(int i) {
    exists(DispatchCall dc |
      dc.getCall() = this and
      result = dc.getArgument(i)
    )
  }
}

/**
 * An element access where the qualifier is a `dynamic` expression, for example
 * `d[0]` on line 12 in
 *
 * ```csharp
 * class A {
 *   public A() { }
 *
 *   public int this[int i] { get { return i + 1; } }
 * }
 *
 * class B {
 *   string[] Array = new[] { "a", "b", "c" };
 *
 *   public dynamic GetItem(bool b) {
 *     dynamic d = b ? new A() : (dynamic) Array;
 *     return d[0];
 *   }
 * }
 * ```
 *
 * Unlike an ordinary element access (`ElementAccess`), the type of the member
 * being accessed may not be known at compile-time (it can be either an indexer
 * or an array).
 */
class DynamicElementAccess extends DynamicAccess, ElementAccess, @dynamic_element_access_expr {
  override string toString() { result = "dynamic access to element" }

  override string getAPrimaryQlClass() { result = "DynamicElementAccess" }
}

/**
 * An access to a dynamic element that reads the underlying value, for example
 * `d[0]` on line 12 in
 *
 * ```csharp
 * class A {
 *   public A() { }
 *
 *   public int this[int i] { get { return i + 1; } }
 * }
 *
 * class B {
 *   string[] Array = new[] { "a", "b", "c" };
 *
 *   public dynamic GetItem(bool b) {
 *     dynamic d = b ? new A() : (dynamic) Array;
 *     return d[0];
 *   }
 * }
 * ```
 */
class DynamicElementRead extends DynamicElementAccess, ElementRead { }

/**
 * An access to a dynamic element that updates the underlying value, for example
 * `d[0]` on line 12 in
 *
 * ```csharp
 * class A {
 *   public A() { }
 *
 *   public int this[int i] { get { return i + 1; } }
 * }
 *
 * class B {
 *   int[] Array = new[] { 0, 1, 2 };
 *
 *   public void SetItem(bool b, int v) {
 *     dynamic d = b ? new A() : (dynamic) Array;
 *     d[0] = v;
 *   }
 * }
 * ```
 */
class DynamicElementWrite extends DynamicElementAccess, ElementWrite { }
