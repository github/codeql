/**
 * Provides classes for capturing various ways of performing comparison tests.
 */

private import csharp
private import semmle.code.csharp.frameworks.System
private import semmle.code.csharp.frameworks.system.Collections
private import semmle.code.csharp.frameworks.system.collections.Generic

private newtype TComparisonKind =
  TEquality() or
  TInequality() or
  TLessThan() or
  TLessThanEquals() or
  TCompare()

/**
 * A comparison kind. Either equality, inequality, less than, less than or equals,
 * or ternary comparison.
 */
class ComparisonKind extends TComparisonKind {
  /** Holds if this is an equality kind (`=`). */
  predicate isEquality() { this = TEquality() }

  /** Holds if this is an inequality kind (`!=`). */
  predicate isInequality() { this = TInequality() }

  /** Holds if this is a less than kind (`<`). */
  predicate isLessThan() { this = TLessThan() }

  /** Holds if this is a less than or equals kind (`<=`). */
  predicate isLessThanEquals() { this = TLessThanEquals() }

  /**
   * Holds if this is a ternary comparison kind. That is, a comparison of the form
   * `compare(x, y, z)`, where `z = 0` if `x = y`, `z < 0` if `x < y`, and `z > 0`
   * if `x > y`, respectively.
   */
  predicate isCompare() { this = TCompare() }

  /** Gets a textual representation of this comparison kind. */
  string toString() {
    this = TEquality() and result = "="
    or
    this = TInequality() and result = "!="
    or
    this = TLessThan() and result = "<"
    or
    this = TLessThanEquals() and result = "<="
    or
    this = TCompare() and result = "compare"
  }
}

cached
private newtype TComparisonTest =
  TComparisonOperation(ComparisonOperation co, ComparisonKind kind, Expr first, Expr second) {
    co instanceof EQExpr and
    kind.isEquality() and
    first = co.getLeftOperand() and
    second = co.getRightOperand()
    or
    co instanceof NEExpr and
    kind.isInequality() and
    first = co.getLeftOperand() and
    second = co.getRightOperand()
    or
    co instanceof GTExpr and
    kind.isLessThan() and
    first = co.getRightOperand() and
    second = co.getLeftOperand()
    or
    co instanceof LTExpr and
    kind.isLessThan() and
    first = co.getLeftOperand() and
    second = co.getRightOperand()
    or
    co instanceof GEExpr and
    kind.isLessThanEquals() and
    first = co.getRightOperand() and
    second = co.getLeftOperand()
    or
    co instanceof LEExpr and
    kind.isLessThanEquals() and
    first = co.getLeftOperand() and
    second = co.getRightOperand()
  } or
  TEqualsCall(MethodCall mc) {
    exists(Method m | m = mc.getTarget() |
      m instanceof EqualsMethod or
      m instanceof IEquatableEqualsMethod
    )
  } or
  TStaticEqualsCall(MethodCall mc) {
    exists(Method m | m = mc.getTarget() |
      m = any(SystemObjectClass c).getStaticEqualsMethod() or
      m = any(SystemObjectClass c).getReferenceEqualsMethod()
    )
  } or
  TCompareToCall(MethodCall mc) {
    exists(Method m, Method target |
      target = mc.getTarget() and
      (target = m or target = m.getAnUltimateImplementor())
    |
      m = any(SystemIComparableInterface i).getCompareToMethod()
      or
      m = any(SystemIComparableTInterface i).getAConstructedGeneric().getAMethod() and
      m.getUnboundDeclaration() = any(SystemIComparableTInterface i).getCompareToMethod()
    )
  } or
  TCompareCall(MethodCall mc) {
    exists(Method m, Method target |
      target = mc.getTarget() and
      (target = m or target = m.getAnUltimateImplementor())
    |
      m = any(SystemCollectionsIComparerInterface i).getCompareMethod()
      or
      m = any(SystemCollectionsGenericIComparerTInterface i).getAConstructedGeneric().getAMethod() and
      m.getUnboundDeclaration() =
        any(SystemCollectionsGenericIComparerTInterface i).getCompareMethod()
    )
  } or
  TComparisonOperatorCall(OperatorCall oc, ComparisonKind kind, Expr first, Expr second) {
    exists(Operator o |
      o = oc.getTarget() or
      o.getName() = oc.(DynamicOperatorCall).getLateBoundTargetName()
    |
      o instanceof EQOperator and
      kind.isEquality() and
      first = oc.getArgument(0) and
      second = oc.getArgument(1)
      or
      o instanceof NEOperator and
      kind.isInequality() and
      first = oc.getArgument(0) and
      second = oc.getArgument(1)
      or
      o instanceof GTOperator and
      kind.isLessThan() and
      first = oc.getArgument(1) and
      second = oc.getArgument(0)
      or
      o instanceof LTOperator and
      kind.isLessThan() and
      first = oc.getArgument(0) and
      second = oc.getArgument(1)
      or
      o instanceof GEOperator and
      kind.isLessThanEquals() and
      first = oc.getArgument(1) and
      second = oc.getArgument(0)
      or
      o instanceof LEOperator and
      kind.isLessThanEquals() and
      first = oc.getArgument(0) and
      second = oc.getArgument(1)
    )
  } or
  TCompareWithConstant(ComparisonTest outer, ComparisonKind kind, Expr first, Expr second) {
    exists(ComparisonKind outerKind, ComparisonTest compare, int i |
      compare.getComparisonKind().isCompare() and
      outerKind = outer.getComparisonKind() and
      outer.getAnArgument() = compare.getExpr() and
      i = outer.getAnArgument().getValue().toInt()
    |
      outerKind.isEquality() and
      (
        // `x.CompareTo(y) == 0` => `x = y`
        i = 0 and
        kind.isEquality() and
        first = compare.getFirstArgument() and
        second = compare.getSecondArgument()
        or
        // `x.CompareTo(y) == 1` => `y < x`
        i > 0 and
        kind.isLessThan() and
        first = compare.getSecondArgument() and
        second = compare.getFirstArgument()
        or
        // `x.CompareTo(y) == -1` => `x < y`
        i < 0 and
        kind.isLessThan() and
        first = compare.getFirstArgument() and
        second = compare.getSecondArgument()
      )
      or
      outerKind.isLessThan() and
      (
        outer.getFirstArgument() = compare.getExpr() and
        (
          // `x.CompareTo(y) < 1` => `x <= y`
          i = 1 and
          kind.isLessThanEquals() and
          first = compare.getFirstArgument() and
          second = compare.getSecondArgument()
          or
          // `x.CompareTo(y) < 0` => `x < y`
          i <= 0 and
          kind.isLessThan() and
          first = compare.getFirstArgument() and
          second = compare.getSecondArgument()
        )
        or
        outer.getSecondArgument() = compare.getExpr() and
        (
          // `-1 < x.CompareTo(y)` => `x >= y`
          i = -1 and
          kind.isLessThanEquals() and
          first = compare.getSecondArgument() and
          second = compare.getFirstArgument()
          or
          // `0 < x.CompareTo(y)` => `x > y`
          i >= 0 and
          kind.isLessThan() and
          first = compare.getSecondArgument() and
          second = compare.getFirstArgument()
        )
      )
      or
      outerKind.isLessThanEquals() and
      (
        outer.getFirstArgument() = compare.getExpr() and
        (
          // `x.CompareTo(y) <= 0` => `x <= y`
          i = 0 and
          kind.isLessThanEquals() and
          first = compare.getFirstArgument() and
          second = compare.getSecondArgument()
          or
          // `x.CompareTo(y) <= -1` => `x < y`
          i <= -1 and
          kind.isLessThan() and
          first = compare.getFirstArgument() and
          second = compare.getSecondArgument()
        )
        or
        outer.getSecondArgument() = compare.getExpr() and
        (
          // `0 <= x.CompareTo(y)` => `x >= y`
          i = 0 and
          kind.isLessThanEquals() and
          first = compare.getSecondArgument() and
          second = compare.getFirstArgument()
          or
          // `1 <= x.CompareTo(y)` => `x > y`
          i >= 1 and
          kind.isLessThan() and
          first = compare.getSecondArgument() and
          second = compare.getFirstArgument()
        )
      )
    )
  }

/** A comparison test between two expressions. */
class ComparisonTest extends TComparisonTest {
  /** Gets the underlying expression. */
  final Expr getExpr() {
    this = TComparisonOperation(result, _, _, _) or
    this = TEqualsCall(result) or
    this = TCompareToCall(result) or
    this = TStaticEqualsCall(result) or
    this = TCompareCall(result) or
    this = TComparisonOperatorCall(result, _, _, _) or
    result = any(ComparisonTest ct | this = TCompareWithConstant(ct, _, _, _)).getExpr()
  }

  /** Gets the comparison kind. */
  final ComparisonKind getComparisonKind() {
    this = TComparisonOperation(_, result, _, _)
    or
    this = TEqualsCall(_) and result.isEquality()
    or
    this = TCompareToCall(_) and result.isCompare()
    or
    this = TStaticEqualsCall(_) and result.isEquality()
    or
    this = TCompareCall(_) and result.isCompare()
    or
    this = TComparisonOperatorCall(_, result, _, _)
    or
    this = TCompareWithConstant(_, result, _, _)
  }

  /** Gets the first argument of this comparison test. */
  final Expr getFirstArgument() {
    this = TComparisonOperation(_, _, result, _) or
    this = TEqualsCall(any(MethodCall mc | result = mc.getQualifier())) or
    this = TCompareToCall(any(MethodCall mc | result = mc.getQualifier())) or
    this = TStaticEqualsCall(any(MethodCall mc | result = mc.getArgument(0))) or
    this = TCompareCall(any(MethodCall mc | result = mc.getArgument(0))) or
    this = TComparisonOperatorCall(_, _, result, _) or
    this = TCompareWithConstant(_, _, result, _)
  }

  /** Gets the second argument of this comparison test. */
  final Expr getSecondArgument() {
    this = TComparisonOperation(_, _, _, result) or
    this = TEqualsCall(any(MethodCall mc | result = mc.getArgument(0))) or
    this = TCompareToCall(any(MethodCall mc | result = mc.getArgument(0))) or
    this = TStaticEqualsCall(any(MethodCall mc | result = mc.getArgument(1))) or
    this = TCompareCall(any(MethodCall mc | result = mc.getArgument(1))) or
    this = TComparisonOperatorCall(_, _, _, result) or
    this = TCompareWithConstant(_, _, _, result)
  }

  /** Gets an argument of this comparison test. */
  Expr getAnArgument() {
    result = this.getFirstArgument() or
    result = this.getSecondArgument()
  }

  /** Gets a textual representation of this comparison test. */
  final string toString() { result = this.getExpr().toString() }

  /** Gets the location of this comparison test. */
  final Location getLocation() { result = this.getExpr().getLocation() }
}

/** A comparison test using a comparison operator, for example `x == y`. */
class ComparisonOperationComparisonTest extends ComparisonTest, TComparisonOperation { }

/** A comparison test using an `Equals` method call, for example `x.Equals(y)`. */
class EqualsCallComparisonTest extends ComparisonTest, TEqualsCall { }

/** A comparison test using a `CompareTo` method call, for example `x.CompareTo(y)`. */
class CompareToCallComparisonTest extends ComparisonTest, TCompareToCall { }

/**
 * A comparison test using a static `Equals` or `ReferenceEquals` method
 * call, for example `object.Equals(x, y)`.
 */
class StaticEqualsCallComparisonTest extends ComparisonTest, TStaticEqualsCall {
  MethodCall mc;

  StaticEqualsCallComparisonTest() { this = TStaticEqualsCall(mc) }

  /** Holds if this comparison uses `ReferenceEquals`. */
  predicate isReferenceEquals() {
    mc.getTarget() = any(SystemObjectClass c).getReferenceEqualsMethod()
  }
}

/** A comparison test using a `Compare` method call, for example `comparer.Compare(x, y)`. */
class CompareMethodCallComparisonTest extends ComparisonTest, TCompareCall { }

/**
 * A comparison test using a user-defined comparison operator, for example
 * `this == other` on line 3 in
 *
 * ```csharp
 * public class C {
 *   public static bool operator ==(C lhs, C rhs) => true;
 *   public bool Is(C other) => this == other;
 * }
 * ```
 */
class OperatorCallComparisonTest extends ComparisonTest, TComparisonOperatorCall { }

/**
 * A comparison test comparing the result of a comparator invocation with an integer
 * constant. For example, `0 = x.CompareTo(y)` is an equality test between `x` and `y`.
 */
class CompareWithConstantComparisonTest extends ComparisonTest, TCompareWithConstant { }
