/**
 * @name Side effect in a Boolean expression
 * @description The evaluation of a Boolean expression shall have no side effects.
 * @kind problem
 * @id cpp/jpl-c/no-boolean-side-effects
 * @problem.severity warning
 * @tags correctness
 *       readability
 *       external/jpl
 */

import cpp

/**
 * A whitelist of functions that should be considered
 * side-effect free.
 */
predicate safeFunctionWhitelist(Function f) {
  exists(string name | name = f.getName() |
    // List functions by name which are not correctly identified
    // as side-effect free. For example, for strlen, one might do:
    // name = "strlen" or
    none()
  )
}

/**
 * Gets a "pointer type" contained in the given type. This
 * traverses typedefs and derived types, including types of
 * struct or union members, returning each "pointer to X"
 * type encountered on that traversal.
 */
PointerType getAPointerType(Type t) {
  result = t or
  result = getAPointerType(t.getUnderlyingType()) or
  result = getAPointerType(t.(DerivedType).getBaseType()) or
  result = getAPointerType(t.(Class).getAMemberVariable().getType())
}

/**
 * A function is "inherently unsafe" for side effects if it
 * writes a global or static variable, or if it calls another
 * inherently unsafe function.
 */
predicate inherentlyUnsafe(Function f) {
  exists(Variable v | v.getAnAssignedValue().getEnclosingFunction() = f |
    v instanceof GlobalVariable or
    v.isStatic()
  )
  or
  exists(FunctionCall c | c.getEnclosingFunction() = f | inherentlyUnsafe(c.getTarget()))
}

/**
 * Find functions that are "safe to call" without causing a side effect.
 * Being safe to call means that any "pointer type" in an argument type
 * actually refers to a "const" object, and, moreover, the function is
 * not inherently unsafe.
 */
predicate safeToCall(Function f) {
  forall(PointerType paramPointerType |
    paramPointerType = getAPointerType(f.getAParameter().getType())
  |
    paramPointerType.getBaseType().isConst()
  ) and
  not inherentlyUnsafe(f)
}

/**
 * A "Boolean expression" is an expression forbidden from having side effects
 * by this rule.
 */
class BooleanExpression extends Expr {
  BooleanExpression() {
    exists(Loop l | l.getControllingExpr() = this) or
    exists(IfStmt i | i.getCondition() = this) or
    exists(ConditionalExpr e | e.getCondition() = this)
  }
}

predicate hasSideEffect(Expr e) {
  e instanceof Assignment
  or
  e instanceof CrementOperation
  or
  e instanceof ExprCall
  or
  exists(Function f | f = e.(FunctionCall).getTarget() and not safeFunctionWhitelist(f) |
    inherentlyUnsafe(f) or not safeToCall(f)
  )
  or
  hasSideEffect(e.getAChild())
}

from BooleanExpression b
where hasSideEffect(b)
select b, "This Boolean expression is not side-effect free."
