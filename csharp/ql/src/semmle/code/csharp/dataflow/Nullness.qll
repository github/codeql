/**
 * Provides predicates for performing nullness analyses.
 *
 * Nullness analyses are used to identify places in a program where
 * a null pointer exception (`NullReferenceException`) may be thrown.
 * Example:
 *
 * ```
 * void M(string s) {
 *   if (s != null) {
 *     ...
 *   }
 *   ...
 *   var i = s.IndexOf('a'); // s may be null
 *   ...
 * }
 * ```
 */

import csharp
private import semmle.code.csharp.commons.Assertions
private import semmle.code.csharp.commons.ComparisonTest
private import semmle.code.csharp.controlflow.Guards
private import semmle.code.csharp.dataflow.SSA
private import semmle.code.csharp.frameworks.System

/** An expression that may be `null`. */
private class NullExpr extends Expr {
  NullExpr() {
    this instanceof NullLiteral or
    this.(ParenthesizedExpr).getExpr() instanceof NullExpr or
    this.(ConditionalExpr).getThen() instanceof NullExpr or
    this.(ConditionalExpr).getElse() instanceof NullExpr
  }
}

/** An expression that may be non-`null`. */
private class NonNullExpr extends Expr {
  NonNullExpr() {
    not (this instanceof NullLiteral or this instanceof ConditionalExpr or this instanceof ParenthesizedExpr) or
    this.(ParenthesizedExpr).getExpr() instanceof NonNullExpr or
    this.(ConditionalExpr).getThen() instanceof NonNullExpr or
    this.(ConditionalExpr).getElse() instanceof NonNullExpr
  }
}

/** Gets an assignment to the variable `var` that may be `null`. */
private AssignExpr nullSet(LocalScopeVariable var) {
  var.getAnAccess() = result.getLValue() and
  result.getRValue() instanceof NullExpr
}

/** Gets an assignment to the variable `var` that may be non-`null`. */
private Assignment nonNullSet(LocalScopeVariable var) {
  var.getAnAccess() = result.getLValue() and
  result.getRValue() instanceof NonNullExpr
}

/**
 * Gets an expression that will result in a `NullReferenceException` if the
 * variable access `access` is `null`.
 */
private Expr nonNullAccess(LocalScopeVariableAccess access) {
  access.getType() instanceof RefType
  and (
    result.(ArrayAccess).getQualifier() = access or
    exists (MemberAccess ma | result=ma and not ma.isConditional() | access = ma.getQualifier()) or
    exists (MethodCall mc | result=mc and not mc.isConditional() | access = mc.getQualifier()) or
    exists (LockStmt stmt | stmt.getExpr() = access and result = access)
  )
}

/**
 * Gets an expression that accesses the variable `var` such that it will
 * result in a `NullReferenceException` if the variable is `null`.
 */
private Expr nonNullUse(LocalScopeVariable var) {
  result = nonNullAccess(var.getAnAccess())
}

/**
 * Gets a local variable declaration expression that may
 * initialize the variable `var` with `null`.
 */
private LocalVariableDeclExpr initialNull(LocalVariable var) {
  result.getVariable() = var and
  result.getInitializer() instanceof NullExpr
}

/**
 * Gets a local variable declaration expression that may
 * initialize the variable `var` with a non-`null` expression.
 */
private LocalVariableDeclExpr initialNonNull(LocalVariable var) {
  result.getVariable() = var and
  result.getInitializer() instanceof NonNullExpr
}

/**
 * Gets an expression that either asserts that the variable `var`
 * is `null` or that may assign `null` to `var`.
 */
private Expr nullDef(LocalScopeVariable var) {
  nullSet(var) = result or
  initialNull(var) = result or
  exists(MethodCall mc, AssertNullMethod m, Expr arg |
    // E.g. `Assert.IsNull(var)`
    mc = result and
    mc.getTarget() = m and
    mc.getArgument(m.getAssertionIndex()) = arg and
    sameValue(arg, var.getAnAccess())
  ) or
  exists(MethodCall mc, AssertTrueMethod m, Expr arg |
    // E.g. `Assert.IsTrue(var == null)`
    mc = result and
    arg = nullTest(var) and
    arg = mc.getArgument(m.getAssertionIndex()) and
    mc.getTarget() = m
  ) or
  exists(MethodCall mc, AssertFalseMethod m, Expr arg |
    // E.g. `Assert.IsFalse(var != null)`
    mc = result and
    arg = failureIsNullTest(var) and
    arg = mc.getArgument(m.getAssertionIndex()) and
    mc.getTarget() = m
  )
}

/**
 * Gets an expression that either asserts that the variable `var` is
 * non-`null`, dereferences it, or may assign a non-`null` expression to it.
 */
private Expr nonNullDef(LocalScopeVariable var) {
  nonNullSet(var) = result or
  nonNullUse(var) = result or
  initialNonNull(var) = result or
  useAsOutParameter(var) = result or
  nonNullSettingLambda(var) = result or
  exists(MethodCall mc, AssertNonNullMethod m, Expr arg |
    // E.g. `Assert.IsNotNull(arg)`
    mc = result and
    mc.getTarget() = m and
    mc.getArgument(m.getAssertionIndex()) = arg and
    sameValue(arg, var.getAnAccess())
  ) or
  exists(MethodCall mc, AssertTrueMethod m, Expr arg |
    // E.g. `Assert.IsTrue(arg != null)`
    mc = result and
    arg = nonNullTest(var) and
    arg = mc.getArgument(m.getAssertionIndex()) and
    mc.getTarget() = m
  ) or
  exists(MethodCall mc, AssertFalseMethod m, Expr arg |
    // E.g. `Assert.IsFalse(arg == null)`
    mc = result and
    arg = failureIsNonNullTest(var) and
    arg = mc.getArgument(m.getAssertionIndex()) and
    mc.getTarget() = m
  )
}

private Call useAsOutParameter(LocalScopeVariable var) {
  exists(LocalScopeVariableAccess a |
    a = result.getAnArgument() and a = var.getAnAccess() |
    a.isOutArgument() or a.isRefArgument())
}

private AnonymousFunctionExpr nonNullSettingLambda(LocalScopeVariable var) {
  result = nonNullDef(var).getEnclosingCallable()
}

/**
 * Gets a logical 'or' expression in which the expression `e` is a
 * (possibly nested) operand.
 */
private LogicalOrExpr orParent(Expr e) {
  e = result.getAnOperand()
  or
  exists(LogicalOrExpr orexpr | result = orParent(orexpr) and e = orexpr.getAnOperand())
}

/**
 * Gets a logical 'and' expression in which the expression `e` is a
 * (possibly nested) operand.
 */
private LogicalAndExpr andParent(Expr e) {
  e = result.getAnOperand()
  or
  exists(LogicalAndExpr andexpr | result = andParent(andexpr) and e = andexpr.getAnOperand())
}

/**
 * Holds if variable access `access` has the "same value" as expression `expr`:
 *
 * - `access` is equal to `expr`, or
 * - `expr` is an assignment and the `access` is its left-hand side, or
 * - `expr` is an assignment and the `access` has the same value as its right-hand
 *   side.
 */
private predicate sameValue(Expr expr, LocalScopeVariableAccess access) {
  access = expr.stripCasts() or
  access = expr.(AssignExpr).getLValue() or
  sameValue(expr.(AssignExpr).getRValue(), access) or
  sameValue(expr.(ParenthesizedExpr).getExpr(), access)
}

/**
 * Gets an `is` expression in which the left-hand side is an access to the
 * variable `var`.
 */
private Expr instanceOfTest(LocalScopeVariable var) {
  exists(IsExpr e | result = e and
    sameValue(e.getExpr() , var.getAnAccess()))
}

/**
 * Gets an expression performing a `null` check on the variable `var`:
 *
 * - either via a reference equality test with `null`, or
 * - by passing it as an argument to a method that performs the test.
 */
private Expr directNullTest(LocalScopeVariable var) {
  exists(ComparisonTest ct |
    result = ct.getExpr() and
    sameValue(ct.getAnArgument(), var.getAnAccess()) and
    ct.getAnArgument() instanceof NullLiteral |
    ct.(ComparisonOperationComparisonTest).getComparisonKind().isEquality()  or
    ct.(StaticEqualsCallComparisonTest).isReferenceEquals() or
    ct.(OperatorCallComparisonTest).getComparisonKind().isEquality()
  )
  or
  exists(Call call, int i | result = call |
    call.getRuntimeArgument(i) = var.getAnAccess() and
    forex(Callable callable |
      call.getARuntimeTarget() = callable |
      nullTestInCallable(callable.getSourceDeclaration(), i)
    )
  )
  or
  // seems redundant, because all methods that use this method also peel ParenthesizedExpr
  // However, removing this line causes an increase of memory usage
  result.(ParenthesizedExpr).getExpr() = directNullTest(var)
}

/**
 * Holds if callable `c` performs a `null` test on its `i`th argument and
 * returns the result.
 */
private predicate nullTestInCallable(Callable c, int i) {
  exists(Parameter p |
    p = c.getParameter(i) and
    not p.isOverwritten() and
    forex(Expr e | c.canReturn(e) | stripConditionalExpr(e) = nullTest(p))
  )
  or
  nullTestInLibraryMethod(c, i)
}

/**
 * Holds if library method `m` performs a `null` test on its `i`th argument and
 * returns the result.
 */
private predicate nullTestInLibraryMethod(Method m, int i) {
  m.fromLibrary() and
  m.getName().toLowerCase().regexpMatch("(is)?null(orempty|orwhitespace)?") and
  m.getReturnType() instanceof BoolType and
  m.getNumberOfParameters() = 1 and
  i = 0
}

private Expr stripConditionalExpr(Expr e) {
  if e instanceof ConditionalExpr then
    result = stripConditionalExpr(e.(ConditionalExpr).getThen()) or
    result = stripConditionalExpr(e.(ConditionalExpr).getElse())
  else
    result = e
}

/**
 * Gets an expression performing a non-`null` check on the variable `var`:
 *
 * - either via an inequality test with `null`, or
 * - by performing an `is` test, or
 * - by passing it as an argument to a method that performs the test.
 */
private Expr directNonNullTest(LocalScopeVariable var) {
  exists(ComparisonTest ct |
    result = ct.getExpr() and
    sameValue(ct.getAnArgument(), var.getAnAccess()) and
    ct.getAnArgument() instanceof NullLiteral |
    ct.(ComparisonOperationComparisonTest).getComparisonKind().isInequality()  or
    ct.(OperatorCallComparisonTest).getComparisonKind().isInequality()
  )
  or
  instanceOfTest(var) = result
  or
  exists(Call call, int i | result = call |
    call.getRuntimeArgument(i) = var.getAnAccess() and
    exists(call.getARuntimeTarget()) and
    forall(Callable callable |
      call.getARuntimeTarget() = callable |
      nonNullTestInCallable(callable.getSourceDeclaration(), i)
    )
  )
  or
  // seems redundant, because all methods that use this method also peel ParenthesizedExpr
  // However, removing this line causes an increase of memory usage
  result.(ParenthesizedExpr).getExpr() = directNonNullTest(var)
}

/**
 * Holds if callable `c` performs a non-`null` test on its `i`th argument and
 * returns the result.
 */
private predicate nonNullTestInCallable(Callable c, int i) {
  exists(Parameter p |
    p = c.getParameter(i) and
    not p.isOverwritten() and
    forex(Expr e | c.canReturn(e) | stripConditionalExpr(e) = nonNullTest(p))
  )
  or
  nonNullTestInLibraryMethod(c, i)
}

/**
 * Holds if library method `m` performs a non-`null` test on its `i`th argument
 * and returns the result.
 */
private predicate nonNullTestInLibraryMethod(Method m, int i) {
  m.fromLibrary() and
  m.getName().toLowerCase().regexpMatch("(is)?no(t|n)null") and
  m.getReturnType() instanceof BoolType and
  m.getNumberOfParameters() = 1 and
  i = 0
}

/**
 * Gets a `null` test in a _positive_ position for the variable `var`.
 */
private Expr nullTest(LocalScopeVariable var) {
  directNullTest(var) = result
  or
  result.(ParenthesizedExpr).getExpr() = nullTest(var)
  or
  exists(LogicalNotExpr notexpr | result = notexpr and
    notexpr.getAChildExpr() = failureIsNullTest(var))
  or
  result = andParent(nullTest(var))
  or
  exists(LogicalOrExpr orexpr | result = orexpr and
    orexpr.getLeftOperand() = nullTest(var) and
    orexpr.getRightOperand() = nullTest(var))
}

/**
 * Gets a non-`null` test in a _positive_ position for the variable `var`.
 */
private Expr nonNullTest(LocalScopeVariable var) {
  directNonNullTest(var) = result
  or
  result.(ParenthesizedExpr).getExpr() = nonNullTest(var)
  or
  exists(LogicalNotExpr notexpr | result = notexpr and
    notexpr.getAChildExpr() = failureIsNonNullTest(var))
  or
  result = andParent(nonNullTest(var))
  or
  exists(LogicalOrExpr orexpr | result = orexpr and
    orexpr.getLeftOperand() = nonNullTest(var) and
    orexpr.getRightOperand() = nonNullTest(var))
}

/**
 * Gets a non-`null` test in a _negative_ position for the variable `var`.
 */
private Expr failureIsNullTest(LocalScopeVariable var) {
  directNonNullTest(var) = result
  or
  result.(ParenthesizedExpr).getExpr() = failureIsNullTest(var)
  or
  exists(LogicalNotExpr notexpr | result = notexpr and
    notexpr.getAChildExpr() = failureIsNonNullTest(var))
  or
  result = orParent(failureIsNullTest(var))
  or
  exists(LogicalAndExpr andexpr | result = andexpr and
    andexpr.getLeftOperand() = failureIsNullTest(var) and
    andexpr.getRightOperand() = failureIsNullTest(var))
}

/**
 * Gets a `null` test in a _negative_ position for the variable `var`.
 */
private Expr failureIsNonNullTest(LocalScopeVariable var) {
  directNullTest(var) = result
  or
  result.(ParenthesizedExpr).getExpr() = failureIsNonNullTest(var)
  or
  exists(LogicalNotExpr notexpr | result = notexpr and
    notexpr.getAChildExpr() = failureIsNullTest(var))
  or
  result = orParent(directNullTest(var))
  or
  exists(LogicalAndExpr andexpr | result = andexpr and
    andexpr.getLeftOperand() = failureIsNonNullTest(var) and
    andexpr.getRightOperand() = failureIsNonNullTest(var))
}

/**
 * Gets an immediate successor node of the conditional node `cfgnode` where
 * the condition implies that the variable `var` is `null`.
 */
private ControlFlow::Node nullBranchKill(LocalScopeVariable var, ControlFlow::Node cfgnode) {
  (cfgnode.getElement() = nullTest(var) and result = cfgnode.getATrueSuccessor())
  or
  (cfgnode.getElement() = failureIsNullTest(var) and result = cfgnode.getAFalseSuccessor())
}

/**
 * Gets an immediate successor node of the conditional node `cfgnode` where
 * the condition implies that the variable `var` is non-`null`.
 */
private ControlFlow::Node nonNullBranchKill(LocalScopeVariable var, ControlFlow::Node cfgnode) {
  (cfgnode.getElement() = nonNullTest(var) and result = cfgnode.getATrueSuccessor())
  or
  (cfgnode.getElement() = failureIsNonNullTest(var) and result = cfgnode.getAFalseSuccessor())
}

/** Gets a node where the variable `var` may be `null`. */
ControlFlow::Node maybeNullNode(LocalScopeVariable var) {
  result = nullDef(var).getAControlFlowNode().getASuccessor()
  or
  exists(ControlFlow::Node mid |
    mid = maybeNullNode(var) and
    not mid.getElement() = nonNullDef(var) and
    mid.getASuccessor() = result and
    not result = nonNullBranchKill(var, mid)
  )
}

/** Gets a node where the variable `var` may be non-`null`. */
ControlFlow::Node maybeNonNullNode(LocalScopeVariable var) {
  result = nonNullDef(var).getAControlFlowNode().getASuccessor()
  or
  exists(ControlFlow::Node mid |
    mid = maybeNonNullNode(var) and
    not mid.getElement() = nullDef(var) and
    mid.getASuccessor() = result and
    not result = nullBranchKill(var, mid)
  )
}

/**
 * Gets an expression whose evaluation may be guarded by
 * a non-`null` check for the variable `var`.
 */
private Expr nullGuarded(LocalScopeVariable var) {
  exists(LogicalOrExpr guard |
    guard.getLeftOperand() = failureIsNonNullTest(var) and
    result = guard.getRightOperand())
  or
  exists(LogicalAndExpr guard |
    guard.getLeftOperand() = nonNullTest(var) and
    result = guard.getRightOperand())
  or
  exists(ConditionalExpr cond |
    cond.getCondition() = nullTest(var) and
    result = cond.getElse())
  or
  exists(ConditionalExpr cond |
    cond.getCondition() = nonNullTest(var) and
    result = cond.getThen())
  or
  result = any(NullGuardedExpr nge | nge = var.getAnAccess())
  or
  result.getParent() = nullGuarded(var)
}

/**
 * Gets a variable access that must be non-`null` to avoid a
 * `NullReferenceException`.
 */
private predicate dereferenced(LocalScopeVariableAccess access) {
  exists(nonNullAccess(access))
}

/**
 * Gets a dereferenced access to the variable `var` that
 *
 * - does not occur within a `null`-guarded expression, but
 * - occurs within an expression where the variable may be `null`.
 */
LocalScopeVariableAccess unguardedMaybeNullDereference(LocalScopeVariable var) {
  var.getAnAccess() = result and
  maybeNullNode(var).getElement() = result and
  dereferenced(result) and
  not result = nullGuarded(var)
}

/**
 * Gets a dereferenced access to the variable `var` that
 *
 * - does not occur within a `null`-guarded expression, but
 * - occurs within an expression where the variable may be `null`, and
 * - does not occur within an expression where the variable may be non-`null`.
 */
LocalScopeVariableAccess unguardedNullDereference(LocalScopeVariable var) {
  unguardedMaybeNullDereference(var) = result and
  not maybeNonNullNode(var).getElement() = result
}
