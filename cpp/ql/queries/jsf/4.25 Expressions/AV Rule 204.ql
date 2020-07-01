/**
 * @name AV Rule 204
 * @description A single operation with side-effects shall only be used by itself,
 *              to the right of an assignment, in a condition, as the only argument
 *              with side-effects in a function call, as a loop condition, as a switch
 *              condition, or as a part of a chained operation.
 * @kind problem
 * @id cpp/jsf/av-rule-204
 * @problem.severity warning
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

// whether the main operation of e is pure (not considering its operands)
predicate isPureOperation(Expr e) {
  e instanceof Operation and
  not e instanceof Assignment and
  not e instanceof CrementOperation
}

// f is the smallest expression containing e composed entirely of
// pure operators such that e is the only non-constant subexpression
// e.g., in x = g(y) + 1, if e is g(y), then f is g(y) + 1
predicate stripOffConstants(Expr e, Expr f) {
  not isPureOperation(e.getParent()) and f = e
  or
  exists(Operation p |
    p = e.getParent() and
    isPureOperation(p) and
    (
      if forall(Expr g | g = p.getAChild() and e != g | g.isConstant())
      then stripOffConstants(p, f)
      else f = e
    )
  )
}

// whether e occurs by itself as a statement
predicate occursByItself(Expr e) {
  exists(ExprStmt s | e = s.getExpr()) or
  exists(ForStmt s | s.getUpdate() = e)
}

// whether e is the source of an assignment or an initializer
predicate isOnRightOfAssignment(Expr e) {
  exists(Assignment a | a.getRValue() = e) or
  exists(Initializer i | i.getExpr() = e)
}

// whether e is a loop condition, an if condition, or a switch expression
predicate isControllingExpr(Expr e) { exists(ControlStructure c | c.getControllingExpr() = e) }

// whether e is the only impure argument expression of a function call
predicate isSoleNonConstFunArg(Expr e) {
  exists(FunctionCall fc |
    fc.getAnArgument() = e and
    forall(Expr g | g = fc.getAnArgument() and g != e | g.isPure())
  )
}

// whether e occurs as part of a chain of qualifiers
predicate isPartOfChain(Expr e) { qualifies(e, _) or qualifies(_, e) }

// whether q qualifies e
predicate qualifies(Expr q, Expr e) {
  q = e.(Call).getQualifier() or q = e.(VariableAccess).getQualifier()
}

predicate impureExprInDisallowedContext(Expr e) {
  exists(Expr f |
    e.fromSource() and
    not e.isPure() and
    stripOffConstants(e, f) and
    not occursByItself(f) and
    not isOnRightOfAssignment(f) and
    not isControllingExpr(f) and
    not isSoleNonConstFunArg(f) and
    not isPartOfChain(f)
  )
}

from Expr e
where
  impureExprInDisallowedContext(e) and
  not e.isCompilerGenerated() and
  // A few cases that are always ok
  not e instanceof Conversion and
  not exists(@ctorinit ci | e = mkElement(ci)) and
  not exists(@dtordestruct dd | e = mkElement(dd)) and
  // Avoid flagging nested expressions
  not impureExprInDisallowedContext(e.getParent+())
select e.findRootCause(),
  "AV Rule 204: A single operation with side-effects shall only be used in certain contexts."
