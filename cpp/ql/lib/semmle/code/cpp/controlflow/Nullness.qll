/**
 * Provides classes and predicates for working with null values and checks for nullness.
 */

import cpp
import DefinitionsAndUses

/**
 * A C/C++ literal whose value is considered null.
 */
abstract class NullValue extends Expr { }

/**
 * A C/C++ literal whose value is zero.
 */
class Zero extends NullValue {
  Zero() { this.(Literal).getValue() = "0" }
}

/**
 * Holds if `var` is null when `checkExpr` evaluates to a true value.
 */
cached
predicate nullCheckExpr(Expr checkExpr, Variable var) {
  exists(LocalScopeVariable v, AnalysedExpr expr |
    var = v and
    checkExpr = expr
  |
    exists(NotExpr notexpr, AnalysedExpr child |
      expr = notexpr and notexpr.getOperand() = child and validCheckExpr(child, v)
    )
    or
    exists(EQExpr eq, AnalysedExpr child, NullValue zero, int i |
      expr = eq and
      eq.getChild(i) = child and
      validCheckExpr(child, v) and
      eq.getChild(1 - i) = zero
    )
    or
    exists(NEExpr neq, AnalysedExpr child, NullValue zero, int i |
      expr = neq and
      neq.getChild(i) = child and
      nullCheckExpr(child, v) and
      neq.getChild(1 - i) = zero
    )
    or
    exists(LogicalAndExpr op, AnalysedExpr child |
      expr = op and
      op.getRightOperand() = child and
      nullCheckExpr(child, v)
    )
    or
    exists(AssignExpr assign, AnalysedExpr child |
      expr = assign and
      assign.getRValue() = child and
      nullCheckExpr(child, v) and
      not expr.isDef(v)
    )
    or
    exists(FunctionCall fc, AnalysedExpr child |
      expr = fc and
      fc.getTarget().hasGlobalName("__builtin_expect") and
      fc.getArgument(0) = child and
      nullCheckExpr(child, v)
    )
  )
}

/**
 * Holds if `var` is non-null when `checkExpr` evaluates to a true value.
 */
cached
predicate validCheckExpr(Expr checkExpr, Variable var) {
  exists(AnalysedExpr expr, LocalScopeVariable v |
    v = var and
    expr = checkExpr
  |
    expr.isUse(v)
    or
    expr.isDef(v)
    or
    exists(NotExpr notexpr, AnalysedExpr child |
      expr = notexpr and notexpr.getOperand() = child and nullCheckExpr(child, v)
    )
    or
    exists(EQExpr eq, AnalysedExpr child, NullValue zero, int i |
      expr = eq and
      eq.getChild(i) = child and
      nullCheckExpr(child, v) and
      eq.getChild(1 - i) = zero
    )
    or
    exists(NEExpr neq, AnalysedExpr child, NullValue zero, int i |
      expr = neq and
      neq.getChild(i) = child and
      validCheckExpr(child, v) and
      neq.getChild(1 - i) = zero
    )
    or
    exists(LogicalAndExpr op, AnalysedExpr child |
      expr = op and
      op.getRightOperand() = child and
      validCheckExpr(child, v)
    )
    or
    exists(AssignExpr assign, AnalysedExpr child |
      expr = assign and
      assign.getRValue() = child and
      validCheckExpr(child, v) and
      not expr.isDef(v)
    )
    or
    exists(FunctionCall fc, AnalysedExpr child |
      expr = fc and
      fc.getTarget().hasGlobalName("__builtin_expect") and
      fc.getArgument(0) = child and
      validCheckExpr(child, v)
    )
  )
}

/**
 * An expression that has been extended with member predicates that provide
 * information about the role of this expression in nullness checks.
 */
class AnalysedExpr extends Expr {
  /**
   * Holds if `v` is null when this expression evaluates to a true value.
   */
  predicate isNullCheck(LocalScopeVariable v) { nullCheckExpr(this, v) }

  /**
   * Holds if `v` is non-null when this expression evaluates to a true value.
   */
  predicate isValidCheck(LocalScopeVariable v) { validCheckExpr(this, v) }

  /**
   * Gets a successor of `this` in the control flow graph, where that successor
   * is among the nodes to which control may flow when `this` tests `v` to be
   * _null_.
   */
  ControlFlowNode getNullSuccessor(LocalScopeVariable v) {
    this.isNullCheck(v) and result = this.getATrueSuccessor()
    or
    this.isValidCheck(v) and result = this.getAFalseSuccessor()
  }

  /**
   * Gets a successor of `this` in the control flow graph, where that successor
   * is among the nodes to which control may flow when `this` tests `v` to be
   * _not null_.
   */
  ControlFlowNode getNonNullSuccessor(LocalScopeVariable v) {
    this.isNullCheck(v) and result = this.getAFalseSuccessor()
    or
    this.isValidCheck(v) and result = this.getATrueSuccessor()
  }

  /**
   * DEPRECATED: Use `getNonNullSuccessor` instead, which does the same.
   */
  deprecated ControlFlowNode getValidSuccessor(LocalScopeVariable v) {
    this.isValidCheck(v) and result = this.getATrueSuccessor()
    or
    this.isNullCheck(v) and result = this.getAFalseSuccessor()
  }

  /**
   * Holds if this is a `VariableAccess` of `v` nested inside a condition.
   */
  predicate isUse(LocalScopeVariable v) {
    this.inCondition() and
    this = v.getAnAccess()
  }

  /**
   * Holds if this is an `Assignment` to `v` nested inside a condition.
   */
  predicate isDef(LocalScopeVariable v) {
    this.inCondition() and
    this.(Assignment).getLValue() = v.getAnAccess()
  }

  /**
   * Holds if `this` occurs at or below the controlling expression of an `if`,
   * `while`, `?:`, or similar.
   */
  predicate inCondition() {
    this.isCondition() or
    this.getParent().(AnalysedExpr).inCondition()
  }
}

/**
 * Holds if `var` is likely to be null at `node`.
 */
cached
predicate checkedNull(Variable var, ControlFlowNode node) {
  exists(LocalScopeVariable v | v = var |
    exists(AnalysedExpr e | e.getNullSuccessor(v) = node)
    or
    exists(ControlFlowNode pred |
      pred = node.getAPredecessor() and
      not pred.(AnalysedExpr).isDef(v) and
      checkedNull(v, pred)
    )
  )
}

/**
 * Holds if `var` is likely to be non-null at `node`.
 */
cached
predicate checkedValid(Variable var, ControlFlowNode node) {
  exists(LocalScopeVariable v | v = var |
    exists(AnalysedExpr e | e.getNonNullSuccessor(v) = node)
    or
    exists(ControlFlowNode pred |
      pred = node.getAPredecessor() and
      not pred.(AnalysedExpr).isDef(v) and
      checkedValid(v, pred)
    )
  )
}

/**
 * Holds if `val` is a null literal or a call to a function that may return a
 * null literal.
 */
predicate nullValue(Expr val) {
  val instanceof NullValue
  or
  callMayReturnNull(val)
  or
  nullValue(val.(Assignment).getRValue())
}

/**
 * Holds if the evaluation of `n` may have the effect of, directly or
 * indirectly, assigning a null literal to `var`.
 */
predicate nullInit(Variable v, ControlFlowNode n) {
  exists(Initializer init |
    init = n and
    nullValue(init.getExpr()) and
    v.getInitializer() = init
  )
  or
  exists(AssignExpr assign |
    assign = n and
    nullValue(assign.getRValue()) and
    assign.getLValue() = v.getAnAccess()
  )
}

/**
 * Holds if `call` may, directly or indirectly, evaluate to a null literal.
 */
predicate callMayReturnNull(Call call) {
  exists(Options opts |
    if opts.overrideReturnsNull(call)
    then opts.returnsNull(call)
    else mayReturnNull(call.(FunctionCall).getTarget())
  )
}

/**
 * Holds if `f` may, directly or indirectly, return a null literal.
 */
predicate mayReturnNull(Function f) {
  f.hasGlobalOrStdName("malloc")
  or
  f.hasGlobalOrStdName("calloc")
  or
  //  f.hasGlobalName("strchr")
  //  or
  //  f.hasGlobalName("strstr")
  //  or
  exists(ReturnStmt ret |
    nullValue(ret.getExpr()) and
    ret.getEnclosingFunction() = f
  )
  or
  exists(ReturnStmt ret, Expr returned, ControlFlowNode init, LocalScopeVariable v |
    ret.getExpr() = returned and
    nullInit(v, init) and
    definitionUsePair(v, init, returned) and
    not checkedValid(v, returned) and
    ret.getEnclosingFunction() = f
  )
}
