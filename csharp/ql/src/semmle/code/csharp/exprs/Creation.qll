/**
 * Provides expression classes for creating various types of object.
 */

import Expr
import semmle.code.csharp.Callable
private import semmle.code.csharp.frameworks.system.linq.Expressions

/**
 * Either an object initializer (`ObjectInitializer`) or a collection
 * initializer (`CollectionInitializer`).
 */
class ObjectOrCollectionInitializer extends Expr, @objectorcollection_init_expr {
  override string toString() { result = "{ ..., ... }" }
}

/**
 * An object initializer, for example `{ X = 0, Y = 1 }` on line 6 in
 *
 * ```
 * class A {
 *   int X;
 *   int Y;
 *
 *   public static A Create() {
 *     return new A { X = 0, Y = 1 };
 *   }
 * }
 * ```
 */
class ObjectInitializer extends ObjectOrCollectionInitializer, @object_init_expr {
  /**
   * Gets a member initializer of this object initializer. For example, `X = 0`
   * is a member initializer of the object initializer `{ X = 0, Y = 1 }` on
   * line 6 in
   *
   * ```
   * class A {
   *   int X;
   *   int Y;
   *
   *   public static A Create() {
   *     return new A { X = 0, Y = 1 };
   *   }
   * }
   * ```
   */
  MemberInitializer getAMemberInitializer() { result = getMemberInitializer(_) }

  /**
   * Gets the `i`th member initializer of this object initializer. For example,
   * `Y = 1` is the second (`i = 1`) member initializer of the object initializer
   * `{ X = 0, Y = 1 }` on line 6 in
   *
   * ```
   * class A {
   *   int X;
   *   int Y;
   *
   *   public static A Create() {
   *     return new A { X = 0, Y = 1 };
   *   }
   * }
   * ```
   */
  MemberInitializer getMemberInitializer(int i) {
    result = this.getChild(i) and
    i >= 0
  }

  /** Gets the number of member initializers of this object initializer. */
  int getNumberOfMemberInitializers() { result = count(this.getAMemberInitializer()) }

  /** Holds if this object initializer has no member initializers. */
  predicate hasNoMemberInitializers() { not exists(this.getAMemberInitializer()) }
}

/**
 * A member initializer, for example `X = 0` on line 6 in
 *
 * ```
 * class A {
 *   int X;
 *   int Y;
 *
 *   public static A Create() {
 *     return new A { X = 0, Y = 1 };
 *   }
 * }
 * ```
 */
class MemberInitializer extends AssignExpr {
  MemberInitializer() { this.getParent() instanceof ObjectInitializer }

  /** Gets the initialized member. */
  Member getInitializedMember() { result.getAnAccess() = this.getLValue() }
}

/**
 * A collection initializer, for example `{ {0, "a"}, {1, "b"} }` in
 *
 * ```
 * var dict = new Dictionary<int, string>{
 *   {0, "a"},
 *   {1, "b"}
 * };
 * ```
 */
class CollectionInitializer extends ObjectOrCollectionInitializer, @collection_init_expr {
  /**
   * Gets an element initializer of this collection initializer, for example the
   * implicit call to `Add(0, "a")` on line 2 in
   *
   * ```
   * var dict = new Dictionary<int, string>{
   *   {0, "a"},
   *   {1, "b"}
   * };
   * ```
   */
  ElementInitializer getAnElementInitializer() { result = getElementInitializer(_) }

  /**
   * Gets the `i`th element initializer of this collection initializer, for
   * example the second (`i = 1`) element initializer is the implicit call to
   * `Add(1, "b")` in
   *
   * ```
   * var dict = new Dictionary<int, string>{
   *   {0, "a"},
   *   {1, "b"}
   * };
   * ```
   */
  ElementInitializer getElementInitializer(int i) {
    result = this.getChild(i) and
    i >= 0
  }

  /** Gets the number of element initializers of this collection initializer. */
  int getNumberOfElementInitializers() { result = count(this.getAnElementInitializer()) }

  /** Holds if this collection initializer has no element initializers. */
  predicate hasNoElementInitializers() { not exists(this.getAnElementInitializer()) }
}

/**
 * An element initializer, for example the implicit call to `Add(0, "a")`
 * on line 2 in
 *
 * ```
 * var dict = new Dictionary<int, string>{
 *   {0, "a"},
 *   {1, "b"}
 * };
 * ```
 */
class ElementInitializer extends MethodCall {
  ElementInitializer() { this.getParent() instanceof CollectionInitializer }
}

/**
 * A constructor call, for example `new A()` on line 3 in
 *
 * ```
 * class A {
 *   public static A Create() {
 *     return new A();
 *   }
 * }
 * ```
 */
class ObjectCreation extends Call, LateBindableExpr, @object_creation_expr {
  /** Gets the type of the newly created object. */
  ValueOrRefType getObjectType() { result = getType() }

  override Constructor getTarget() { expr_call(this, result) }

  override Constructor getARuntimeTarget() { result = Call.super.getARuntimeTarget() }

  /**
   * Holds if this constructor call includes an object initializer or an
   * element initializer.
   */
  predicate hasInitializer() { exists(this.getInitializer()) }

  /**
   * Gets the object initializer or collection initializer of this constructor
   * call, if any. For example `{ {0, "a"}, {1, "b"} }` in
   *
   * ```
   * var dict = new Dictionary<int, string>{
   *   {0, "a"},
   *   {1, "b"}
   * };
   * ```
   */
  ObjectOrCollectionInitializer getInitializer() { result = this.getChild(-1) }

  override string toString() { result = "object creation of type " + this.getType().getName() }

  override Expr getRawArgument(int i) {
    if this.getTarget().isStatic()
    then result = this.getArgument(i)
    else result = this.getArgument(i - 1)
  }
}

/**
 * An anonymous constructor call, for example
 * `new { First = x[0], Last = x[x.Length - 1] }` on line 2 in
 *
 * ```
 * public IEnumerable<string> FirstLast(IEnumerable<string> list) {
 *   return list.Select(x => new { First = x[0], Last = x[x.Length - 1] }).
 *               Select(y => y.First + y.Last);
 * }
 * ```
 */
class AnonymousObjectCreation extends ObjectCreation {
  AnonymousObjectCreation() { this.getObjectType() instanceof AnonymousClass }

  override ObjectInitializer getInitializer() { result = this.getChild(-1) }
}

/**
 * A delegate creation. Either an explicit delegate creation
 * (`ExplicitDelegateCreation`) or an implicit delegate creation
 * (`ImplicitDelegateCreation`).
 */
class DelegateCreation extends Expr, @delegate_creation_expr {
  /** Gets the delegate type of this delegate creation. */
  DelegateType getDelegateType() { result = this.getType() }

  /**
   * Gets the argument of this delegate creation. Either a callable access
   * (`CallableAccess`), an anonymous function (`AnonymousFunctionExpr`), or a
   * value of delegate type (`DelegateType`).
   */
  Expr getArgument() { result = this.getAChild() }

  override string toString() { result = "delegate creation of type " + this.getType().getName() }
}

/**
 * An explicit delegate creation, for example `new D(M)` on line 6 in
 *
 * ```
 * class A {
 *   delegate void D(int x);
 *
 *   void M(int x) { }
 *
 *   D GetM() { return new D(M); }
 * }
 * ```
 */
class ExplicitDelegateCreation extends DelegateCreation, @explicit_delegate_creation_expr { }

/**
 * An implicit delegate creation, for example the access to `M` on line 6 in
 *
 * ```
 * class A {
 *   delegate void D(int x);
 *
 *   void M(int x) { }
 *
 *   D GetM() { return M; }
 * }
 * ```
 */
class ImplicitDelegateCreation extends DelegateCreation, @implicit_delegate_creation_expr { }

/**
 * An array initializer, for example `{ {0, 1}, {2, 3}, {4, 5} }` in
 *
 * ```
 * var ints = new int[,] {
 *   {0, 1},
 *   {2, 3},
 *   {4, 5}
 * };
 * ```
 */
class ArrayInitializer extends Expr, @array_init_expr {
  /**
   * Gets an element of this array initializer, for example `{0, 1}` on line
   * 2 (itself an array initializer) in
   *
   * ```
   * var ints = new int[,] {
   *   {0, 1},
   *   {2, 3},
   *   {4, 5}
   * };
   * ```
   */
  Expr getAnElement() { result = getElement(_) }

  /**
   * Gets the `i`th element of this array initializer, for example the second
   * (`i = 1`) element is `{2, 3}` on line 3 (itself an array initializer) in
   *
   * ```
   * var ints = new int[,] {
   *   {0, 1},
   *   {2, 3},
   *   {4, 5}
   * };
   * ```
   */
  Expr getElement(int i) {
    result = this.getChild(i) and
    i >= 0
  }

  /** Gets the number of elements in this array initializer. */
  int getNumberOfElements() { result = count(this.getAnElement()) }

  /** Holds if this array initializer has no elements. */
  predicate hasNoElements() { not exists(this.getAnElement()) }

  override string toString() { result = "{ ..., ... }" }
}

/**
 * An array creation, for example `new int[,] { {0, 1}, {2, 3}, {4, 5} }`.
 */
class ArrayCreation extends Expr, @array_creation_expr {
  /** Gets the type of the created array. */
  ArrayType getArrayType() { result = this.getType() }

  /**
   * Gets a dimension's length argument of this array creation, for
   * example `5` in
   *
   * ```
   * new int[5, 10]
   * ```
   */
  Expr getALengthArgument() { result = getLengthArgument(_) }

  /**
   * Gets the `i`th dimension's length argument of this array creation, for
   * example the second (`i = 1`) dimension's length is `10` in
   *
   * ```
   * new int[5, 10]
   * ```
   */
  Expr getLengthArgument(int i) {
    result = this.getChild(i) and
    i >= 0
  }

  /** Gets the number of length arguments of this array creation. */
  int getNumberOfLengthArguments() { result = count(this.getALengthArgument()) }

  /** Holds if the created array is implicitly sized by the initializer. */
  predicate isImplicitlySized() { not explicitly_sized_array_creation(this) }

  /** Holds if this array creation has an initializer. */
  predicate hasInitializer() { exists(this.getInitializer()) }

  /** Gets the array initializer of this array cration, if any. */
  ArrayInitializer getInitializer() { result = this.getChild(-1) }

  /** Holds if the type of the created array is inferred from its initializer. */
  predicate isImplicitlyTyped() { implicitly_typed_array_creation(this) }

  override string toString() { result = "array creation of type " + this.getType().getName() }
}

/**
 * An anonymous function. Either a lambda expression (`LambdaExpr`) or an
 * anonymous method expression (`AnonymousMethodExpr`).
 */
class AnonymousFunctionExpr extends Expr, Callable, @anonymous_function_expr {
  override string getName() { result = "<anonymous>" }

  override Type getReturnType() {
    result = this
          .getType()
          .(SystemLinqExpressions::DelegateExtType)
          .getDelegateType()
          .getReturnType()
  }

  override AnonymousFunctionExpr getSourceDeclaration() { result = this }

  override Callable getEnclosingCallable() { result = Expr.super.getEnclosingCallable() }

  override string toString() { result = Expr.super.toString() }

  override string toStringWithTypes() { result = toString() }
}

/**
 * A lambda expression, for example `(int x) => x + 1`.
 */
class LambdaExpr extends AnonymousFunctionExpr, @lambda_expr {
  override string toString() { result = "(...) => ..." }
}

/**
 * An anonymous method expression, for example
 * `delegate (int x) { return x + 1; }`.
 */
class AnonymousMethodExpr extends AnonymousFunctionExpr, @anonymous_method_expr {
  override string toString() { result = "delegate(...) { ... }" }
}
