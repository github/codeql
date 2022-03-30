/**
 * @name Overloaded assignment does not return 'this'
 * @description An assignment operator should return a reference to *this. Both the standard library types and the built-in types behave in this manner.
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/assignment-does-not-return-this
 * @tags reliability
 *       readability
 *       language-features
 *       external/jsf
 */

import cpp

/*
 * Applies to all assignment operators, not just the copy assignment operator.
 */

predicate callOnThis(FunctionCall fc) {
  // `this->f(...)`
  fc.getQualifier() instanceof ThisExpr
  or
  // `(*this).f(...)`
  fc.getQualifier().(PointerDereferenceExpr).getChild(0) instanceof ThisExpr
}

predicate pointerThis(Expr e) {
  e instanceof ThisExpr
  or
  // `f(...)`
  // (includes `this = ...`, where `=` is overloaded so a `FunctionCall`)
  exists(FunctionCall fc | fc = e and callOnThis(fc) | returnsPointerThis(fc.getTarget()))
  or
  // `this = ...` (where `=` is not overloaded, so an `AssignExpr`)
  pointerThis(e.(AssignExpr).getLValue())
}

predicate dereferenceThis(Expr e) {
  pointerThis(e.(PointerDereferenceExpr).getChild(0))
  or
  // `f(...)`
  // (includes `*this = ...`, where `=` is overloaded so a `FunctionCall`)
  exists(FunctionCall fc | fc = e and callOnThis(fc) | returnsDereferenceThis(fc.getTarget()))
  or
  // `*this = ...` (where `=` is not overloaded, so an `AssignExpr`)
  dereferenceThis(e.(AssignExpr).getLValue())
  or
  // `e ? ... : ... `
  exists(ConditionalExpr cond |
    cond = e and
    dereferenceThis(cond.getThen()) and
    dereferenceThis(cond.getElse())
  )
  or
  // `..., ... `
  dereferenceThis(e.(CommaExpr).getRightOperand())
}

/**
 * Holds if all `return` statements in `f` return `this`, possibly indirectly.
 * This includes functions whose body is not in the database.
 */
predicate returnsPointerThis(Function f) {
  forall(ReturnStmt s | s.getEnclosingFunction() = f and reachable(s) |
    // `return this`
    pointerThis(s.getExpr())
  )
}

/**
 * Holds if all `return` statements in `f` return a reference to `*this`,
 * possibly indirectly. This includes functions whose body is not in the
 * database.
 */
predicate returnsDereferenceThis(Function f) {
  forall(ReturnStmt s | s.getEnclosingFunction() = f and reachable(s) |
    // `return *this`
    dereferenceThis(s.getExpr())
  )
}

predicate assignOperatorWithWrongType(Operator op, string msg) {
  op.hasName("operator=") and
  exists(op.getBlock()) and
  exists(Class c |
    c = op.getDeclaringType() and
    op.getUnspecifiedType() = c and
    msg =
      "Assignment operator in class " + c.getName() + " should have return type " + c.getName() +
        "&. Otherwise a copy is created at each call."
  )
}

predicate assignOperatorWithWrongResult(Operator op, string msg) {
  op.hasName("operator=") and
  not returnsDereferenceThis(op) and
  exists(op.getBlock()) and
  not op.getType() instanceof VoidType and
  not assignOperatorWithWrongType(op, _) and
  msg =
    "Assignment operator in class " + op.getDeclaringType().getName() +
      " does not return a reference to *this."
}

from Operator op, string msg
where
  (
    assignOperatorWithWrongType(op, msg) or
    assignOperatorWithWrongResult(op, msg)
  ) and
  // exclude code in templates which may be incomplete
  not op.isFromUninstantiatedTemplate(_)
select op, msg
