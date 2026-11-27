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

/** Gets the unqualified referent type of an lvalue reference. */
private Type referenceBaseType(Type t) {
  result = t.getUnspecifiedType().(LValueReferenceType).getBaseType().getUnspecifiedType()
}

/** Holds if `e` has an explicit cast in its conversion chain. */
private predicate hasExplicitCast(Expr e) {
  exists(Cast c | c = e.getUnconverted().getConversion*() and not c.isImplicit())
}

/** Holds if a visible, non-virtual function always returns the reference parameter `p`. */
private predicate returnsReferenceParameter(Function f, Parameter p) {
  p.getFunction() = f and
  exists(f.getBlock()) and
  not f.isVirtual() and
  referenceBaseType(f.getType()) = referenceBaseType(p.getType()) and
  exists(ReturnStmt s | s.getEnclosingFunction() = f and reachable(s)) and
  forall(ReturnStmt s | s.getEnclosingFunction() = f and reachable(s) |
    s.getExpr().getUnconverted().(VariableAccess).getTarget() = p and
    not hasExplicitCast(s.getExpr())
  )
}

/** Holds if an assignment returns a helper call that passes through a direct `*this` argument. */
private predicate returnsThisThroughHelper(Operator op, Expr e) {
  exists(FunctionCall call, Parameter p, Expr arg, PointerDereferenceExpr deref, Expr operand |
    call = e.getUnconverted() and
    returnsReferenceParameter(call.getTarget(), p) and
    arg = call.getArgument(p.getIndex()) and
    deref = arg.getUnconverted() and
    operand = deref.getChild(0) and
    operand.getUnconverted() instanceof ThisExpr and
    deref.getType().getUnspecifiedType() = referenceBaseType(p.getType()) and
    referenceBaseType(op.getType()) = referenceBaseType(p.getType()) and
    not hasExplicitCast(e) and
    not hasExplicitCast(arg) and
    not hasExplicitCast(operand)
  )
}

predicate assignOperatorWithWrongResult(Operator op, string msg) {
  op.hasName("operator=") and
  exists(ReturnStmt s |
    s.getEnclosingFunction() = op and
    reachable(s) and
    not (dereferenceThis(s.getExpr()) or returnsThisThroughHelper(op, s.getExpr()))
  ) and
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
