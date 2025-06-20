/**
 * Provides classes and predicates for null guards.
 */

import java
import SSA
private import semmle.code.java.controlflow.Guards
private import semmle.code.java.frameworks.apache.Collections
private import IntegerGuards

/** Gets an expression that is always `null`. */
Expr alwaysNullExpr() {
  result instanceof NullLiteral or
  result.(CastingExpr).getExpr() = alwaysNullExpr()
}

/** Gets an equality test between an expression `e` and an enum constant `c`. */
Expr enumConstEquality(Expr e, boolean polarity, EnumConstant c) {
  exists(EqualityTest eqtest |
    eqtest = result and
    eqtest.hasOperands(e, c.getAnAccess()) and
    polarity = eqtest.polarity()
  )
}

/** Gets an instanceof expression of `v` with type `type` */
InstanceOfExpr instanceofExpr(SsaVariable v, RefType type) {
  result.getCheckedType() = type and
  result.getExpr() = v.getAUse()
}

/**
 * Gets an expression of the form `v1 == v2` or `v1 != v2`.
 * The predicate is symmetric in `v1` and `v2`.
 *
 * Note this includes Kotlin's `==` and `!=` operators, which are value-equality tests.
 */
EqualityTest varEqualityTestExpr(SsaVariable v1, SsaVariable v2, boolean isEqualExpr) {
  result.hasOperands(v1.getAUse(), v2.getAUse()) and
  isEqualExpr = result.polarity()
}

/** Gets an expression that is provably not `null`. */
Expr baseNotNullExpr() {
  result instanceof ClassInstanceExpr
  or
  result instanceof ArrayCreationExpr
  or
  result instanceof TypeLiteral
  or
  result instanceof ThisAccess
  or
  result instanceof StringLiteral
  or
  result instanceof AddExpr and result.getType() instanceof TypeString
  or
  exists(Field f |
    result = f.getAnAccess() and
    (f.hasName("TRUE") or f.hasName("FALSE")) and
    f.getDeclaringType().hasQualifiedName("java.lang", "Boolean")
  )
  or
  result = any(EnumConstant c).getAnAccess()
  or
  result instanceof ImplicitNotNullExpr
  or
  result instanceof ImplicitCoercionToUnitExpr
  or
  result
      .(MethodCall)
      .getMethod()
      .hasQualifiedName("com.google.common.base", "Strings", "nullToEmpty")
}

/** Gets an expression that is provably not `null`. */
Expr clearlyNotNullExpr(Expr reason) {
  result = baseNotNullExpr() and reason = result
  or
  result.(CastExpr).getExpr() = clearlyNotNullExpr(reason)
  or
  result.(ImplicitCastExpr).getExpr() = clearlyNotNullExpr(reason)
  or
  result.(AssignExpr).getSource() = clearlyNotNullExpr(reason)
  or
  exists(ConditionalExpr c, Expr r1, Expr r2 |
    c = result and
    c.getTrueExpr() = clearlyNotNullExpr(r1) and
    c.getFalseExpr() = clearlyNotNullExpr(r2) and
    (reason = r1 or reason = r2)
  )
  or
  exists(SsaVariable v, boolean branch, VarRead rval, Guard guard |
    guard = directNullGuard(v, branch, false) and
    guard.controls(rval.getBasicBlock(), branch) and
    reason = guard and
    rval = v.getAUse() and
    result = rval and
    not result = baseNotNullExpr()
  )
  or
  exists(SsaVariable v |
    clearlyNotNull(v, reason) and
    result = v.getAUse() and
    not result = baseNotNullExpr()
  )
}

/** Holds if `v` is an SSA variable that is provably not `null`. */
predicate clearlyNotNull(SsaVariable v, Expr reason) {
  exists(Expr src |
    src = v.(SsaExplicitUpdate).getDefiningExpr().(VariableAssign).getSource() and
    src = clearlyNotNullExpr(reason)
  )
  or
  exists(CatchClause cc, LocalVariableDeclExpr decl |
    decl = cc.getVariable() and
    decl = v.(SsaExplicitUpdate).getDefiningExpr() and
    reason = decl
  )
  or
  exists(SsaVariable captured |
    v.(SsaImplicitInit).captures(captured) and
    clearlyNotNull(captured, reason)
  )
  or
  exists(Field f |
    v.getSourceVariable().getVariable() = f and
    f.isFinal() and
    f.getInitializer() = clearlyNotNullExpr(reason)
  )
}

/** Gets an expression that is provably not `null`. */
Expr clearlyNotNullExpr() { result = clearlyNotNullExpr(_) }

/** Holds if `v` is an SSA variable that is provably not `null`. */
predicate clearlyNotNull(SsaVariable v) { clearlyNotNull(v, _) }

/**
 * Holds if the evaluation of a call to `m` resulting in the value `branch`
 * implies that the argument to the call is guaranteed to be null if `isnull`
 * is true, and non-null if `isnull` is false.
 */
predicate nullCheckMethod(Method m, boolean branch, boolean isnull) {
  exists(boolean polarity |
    m.getDeclaringType().hasQualifiedName("java.util", "Objects") and
    (
      m.hasName("isNull") and polarity = true
      or
      m.hasName("nonNull") and polarity = false
    ) and
    (
      branch = true and isnull = polarity
      or
      branch = false and isnull = polarity.booleanNot()
    )
  )
  or
  m instanceof EqualsMethod and branch = true and isnull = false
  or
  m.getDeclaringType().hasQualifiedName("org.apache.commons.lang3", "StringUtils") and
  m.hasName("isBlank") and
  branch = false and
  isnull = false
  or
  m instanceof MethodApacheCollectionsIsEmpty and
  branch = false and
  isnull = false
  or
  m instanceof MethodApacheCollectionsIsNotEmpty and
  branch = true and
  isnull = false
  or
  m.getDeclaringType().hasQualifiedName("com.google.common.base", "Strings") and
  m.hasName("isNullOrEmpty") and
  branch = false and
  isnull = false
}

/**
 * Gets an expression that directly tests whether a given expression, `e`, is null or not.
 *
 * If `result` evaluates to `branch`, then `e` is guaranteed to be null if `isnull`
 * is true, and non-null if `isnull` is false.
 */
Expr basicNullGuard(Expr e, boolean branch, boolean isnull) {
  Guards_v3::nullGuard(result, any(GuardValue v | v.asBooleanValue() = branch), e, isnull)
}

/**
 * DEPRECATED: Use `basicNullGuard` instead.
 *
 * Gets an expression that directly tests whether a given expression, `e`, is null or not.
 *
 * If `result` evaluates to `branch`, then `e` is guaranteed to be null if `isnull`
 * is true, and non-null if `isnull` is false.
 */
deprecated Expr basicOrCustomNullGuard(Expr e, boolean branch, boolean isnull) {
  result = basicNullGuard(e, branch, isnull)
}

/**
 * Gets an expression that directly tests whether a given SSA variable is null or not.
 *
 * If `result` evaluates to `branch`, then `v` is guaranteed to be null if `isnull`
 * is true, and non-null if `isnull` is false.
 */
Expr directNullGuard(SsaVariable v, boolean branch, boolean isnull) {
  result = basicNullGuard(sameValue(v, _), branch, isnull)
}

/**
 * DEPRECATED: Use `nullGuardControls`/`nullGuardControlsBranchEdge` instead.
 *
 * Gets a `Guard` that tests (possibly indirectly) whether a given SSA variable is null or not.
 *
 * If `result` evaluates to `branch`, then `v` is guaranteed to be null if `isnull`
 * is true, and non-null if `isnull` is false.
 */
deprecated Guard nullGuard(SsaVariable v, boolean branch, boolean isnull) {
  result = directNullGuard(v, branch, isnull)
}

/**
 * Holds if there exists a null check on `v`, such that taking the branch edge
 * from `bb1` to `bb2` implies that `v` is guaranteed to be null if `isnull` is
 * true, and non-null if `isnull` is false.
 */
predicate nullGuardControlsBranchEdge(SsaVariable v, boolean isnull, BasicBlock bb1, BasicBlock bb2) {
  exists(GuardValue gv |
    Guards_v3::ssaControlsBranchEdge(v, bb1, bb2, gv) and
    gv.isNullness(isnull)
  )
}

/**
 * Holds if there exists a null check on `v` that controls `bb`, such that in
 * `bb` `v` is guaranteed to be null if `isnull` is true, and non-null if
 * `isnull` is false.
 */
predicate nullGuardControls(SsaVariable v, boolean isnull, BasicBlock bb) {
  exists(GuardValue gv |
    Guards_v3::ssaControls(v, bb, gv) and
    gv.isNullness(isnull)
  )
}

/**
 * Holds if `guard` is a guard expression that suggests that `e` might be null.
 */
predicate guardSuggestsExprMaybeNull(Expr guard, Expr e) {
  guard.(EqualityTest).hasOperands(e, any(NullLiteral n))
  or
  exists(MethodCall call |
    call = guard and
    call.getAnArgument() = e and
    nullCheckMethod(call.getMethod(), _, true)
  )
}

/**
 * Holds if `guard` is a guard expression that suggests that `v` might be null.
 */
predicate guardSuggestsVarMaybeNull(Expr guard, SsaVariable v) {
  guardSuggestsExprMaybeNull(guard, sameValue(v, _))
}
