/**
 * Provides classes and predicates for null guards.
 */

import java
import SSA
private import semmle.code.java.controlflow.internal.GuardsLogic
private import RangeUtils
private import IntegerGuards

/** Gets an expression that is always `null`. */
Expr alwaysNullExpr() {
  result instanceof NullLiteral or
  result.(CastExpr).getExpr() = alwaysNullExpr()
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
InstanceOfExpr instanceofExpr(SsaVariable v, Type type) {
  result.getTypeName().getType() = type and
  result.getExpr() = v.getAUse()
}

/**
 * Gets an expression of the form `v1 == v2` or `v1 != v2`.
 * The predicate is symmetric in `v1` and `v2`.
 */
EqualityTest varEqualityTestExpr(SsaVariable v1, SsaVariable v2, boolean isEqualExpr) {
  result.hasOperands(v1.getAUse(), v2.getAUse()) and
  isEqualExpr = result.polarity()
}

/** Gets an expression that is provably not `null`. */
Expr clearlyNotNullExpr(Expr reason) {
  result instanceof ClassInstanceExpr and reason = result
  or
  result instanceof ArrayCreationExpr and reason = result
  or
  result instanceof TypeLiteral and reason = result
  or
  result instanceof ThisAccess and reason = result
  or
  result instanceof StringLiteral and reason = result
  or
  result instanceof AddExpr and result.getType() instanceof TypeString and reason = result
  or
  exists(Field f |
    result = f.getAnAccess() and
    (f.hasName("TRUE") or f.hasName("FALSE")) and
    f.getDeclaringType().hasQualifiedName("java.lang", "Boolean") and
    reason = result
  )
  or
  result.(CastExpr).getExpr() = clearlyNotNullExpr(reason)
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
  exists(SsaVariable v, boolean branch, RValue rval, Guard guard |
    guard = directNullGuard(v, branch, false) and
    guard.controls(rval.getBasicBlock(), branch) and
    reason = guard and
    rval = v.getAUse() and
    result = rval
  )
  or
  exists(SsaVariable v | clearlyNotNull(v, reason) and result = v.getAUse())
  or
  exists(Method m | m = result.(MethodAccess).getMethod() and reason = result |
    m.getDeclaringType().hasQualifiedName("com.google.common.base", "Strings") and
    m.hasName("nullToEmpty")
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
  (
    m.getDeclaringType().hasQualifiedName("org.apache.commons.collections4", "CollectionUtils") or
    m.getDeclaringType().hasQualifiedName("org.apache.commons.collections", "CollectionUtils")
  ) and
  m.hasName("isNotEmpty") and
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
  exists(EqualityTest eqtest, boolean polarity |
    eqtest = result and
    eqtest.hasOperands(e, any(NullLiteral n)) and
    polarity = eqtest.polarity() and
    (
      branch = true and isnull = polarity
      or
      branch = false and isnull = polarity.booleanNot()
    )
  )
  or
  result.(InstanceOfExpr).getExpr() = e and branch = true and isnull = false
  or
  exists(MethodAccess call |
    call = result and
    call.getAnArgument() = e and
    nullCheckMethod(call.getMethod(), branch, isnull)
  )
  or
  exists(EqualityTest eqtest |
    eqtest = result and
    eqtest.hasOperands(e, clearlyNotNullExpr()) and
    isnull = false and
    branch = eqtest.polarity()
  )
  or
  result = enumConstEquality(e, branch, _) and isnull = false
}

/**
 * Gets an expression that directly tests whether a given expression, `e`, is null or not.
 *
 * If `result` evaluates to `branch`, then `e` is guaranteed to be null if `isnull`
 * is true, and non-null if `isnull` is false.
 */
Expr basicOrCustomNullGuard(Expr e, boolean branch, boolean isnull) {
  result = basicNullGuard(e, branch, isnull)
  or
  exists(MethodAccess call, Method m, int ix |
    call = result and
    call.getArgument(ix) = e and
    call.getMethod().getSourceDeclaration() = m and
    m = customNullGuard(ix, branch, isnull)
  )
}

/**
 * Gets an expression that directly tests whether a given SSA variable is null or not.
 *
 * If `result` evaluates to `branch`, then `v` is guaranteed to be null if `isnull`
 * is true, and non-null if `isnull` is false.
 */
Expr directNullGuard(SsaVariable v, boolean branch, boolean isnull) {
  result = basicOrCustomNullGuard(sameValue(v, _), branch, isnull)
}

/**
 * Gets a `Guard` that tests (possibly indirectly) whether a given SSA variable is null or not.
 *
 * If `result` evaluates to `branch`, then `v` is guaranteed to be null if `isnull`
 * is true, and non-null if `isnull` is false.
 */
Guard nullGuard(SsaVariable v, boolean branch, boolean isnull) {
  result = directNullGuard(v, branch, isnull) or
  exists(boolean branch0 | implies_v3(result, branch, nullGuard(v, branch0, isnull), branch0))
}

/**
 * A return statement that on a return value of `retval` allows the conclusion that the
 * parameter `p` either is null or non-null as specified by `isnull`.
 */
private predicate validReturnInCustomNullGuard(
  ReturnStmt ret, Parameter p, boolean retval, boolean isnull
) {
  exists(Method m |
    ret.getEnclosingCallable() = m and
    p.getCallable() = m and
    m.getReturnType().(PrimitiveType).hasName("boolean")
  ) and
  exists(SsaImplicitInit ssa | ssa.isParameterDefinition(p) |
    nullGuardedReturn(ret, ssa, isnull) and
    (retval = true or retval = false)
    or
    exists(Expr res | res = ret.getResult() | res = nullGuard(ssa, retval, isnull))
  )
}

private predicate nullGuardedReturn(ReturnStmt ret, SsaImplicitInit ssa, boolean isnull) {
  exists(boolean branch |
    nullGuard(ssa, branch, isnull).directlyControls(ret.getBasicBlock(), branch)
  )
}

/**
 * Gets a non-overridable method with a boolean return value that performs a null-check
 * on the `index`th parameter. A return value equal to `retval` allows us to conclude
 * that the argument either is null or non-null as specified by `isnull`.
 */
private Method customNullGuard(int index, boolean retval, boolean isnull) {
  exists(Parameter p |
    result.getReturnType().(PrimitiveType).hasName("boolean") and
    not result.isOverridable() and
    p.getCallable() = result and
    not p.isVarargs() and
    p.getType() instanceof RefType and
    p.getPosition() = index and
    forex(ReturnStmt ret |
      ret.getEnclosingCallable() = result and
      exists(Expr res | res = ret.getResult() |
        not res.(BooleanLiteral).getBooleanValue() = retval.booleanNot()
      )
    |
      validReturnInCustomNullGuard(ret, p, retval, isnull)
    )
  )
}

/**
 * `guard` is a guard expression that suggests that `v` might be null.
 *
 * This is equivalent to `guard = basicNullGuard(sameValue(v, _), _, true)`.
 */
predicate guardSuggestsVarMaybeNull(Expr guard, SsaVariable v) {
  guard = basicNullGuard(sameValue(v, _), _, true)
}
