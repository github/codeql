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

/** Holds if `e` has an explicit cast anywhere in its conversion chain. */
private predicate hasExplicitCast(Expr e) {
  exists(Cast c | c = e.getUnconverted().getConversion*() and not c.isImplicit())
}

predicate callOnThis(FunctionCall fc, boolean allowCasts) {
  allowCasts = [true, false] and
  (allowCasts = true or not hasExplicitCast(fc.getQualifier())) and
  (
    // `this->f(...)`
    fc.getQualifier() instanceof ThisExpr
    or
    // `(*this).f(...)`
    fc.getQualifier().(PointerDereferenceExpr).getChild(0) instanceof ThisExpr and
    (
      allowCasts = true or
      not hasExplicitCast(fc.getQualifier().(PointerDereferenceExpr).getChild(0))
    )
  )
}

predicate pointerThis(Expr e, boolean allowCasts) {
  allowCasts = [true, false] and
  (allowCasts = true or not hasExplicitCast(e)) and
  (
    e instanceof ThisExpr
    or
    // `f(...)`
    // (includes `this = ...`, where `=` is overloaded so a `FunctionCall`)
    exists(FunctionCall fc | fc = e and callOnThis(fc, allowCasts) |
      returnsPointerThis(fc.getTarget(), allowCasts)
    )
    or
    // `this = ...` (where `=` is not overloaded, so an `AssignExpr`)
    pointerThis(e.(AssignExpr).getLValue(), allowCasts)
  )
}

/**
 * Holds if the function containing `p` returns a reference to `p` on every
 * reachable return. Require a visible, non-virtual definition and matching
 * reference base types to exclude copies and user-defined conversions.
 */
private predicate returnsReferenceParameter(Parameter p) {
  exists(Function f |
    f = p.getFunction() and
    exists(f.getBlock()) and
    not f.isVirtual() and
    f.getType().getUnspecifiedType().(ReferenceType).getBaseType().getUnspecifiedType() =
      p.getType().getUnspecifiedType().(ReferenceType).getBaseType().getUnspecifiedType() and
    exists(ReturnStmt s | s.getEnclosingFunction() = f and reachable(s)) and
    forall(ReturnStmt s | s.getEnclosingFunction() = f and reachable(s) |
      s.getExpr().getUnconverted().(VariableAccess).getTarget() = p and
      not hasExplicitCast(s.getExpr())
    )
  )
}

// Preserve the existing treatment of casts outside helper arguments. Within a
// helper argument, check conversions at every step that supplies the result.
predicate dereferenceThis(Expr e, boolean allowCasts) {
  allowCasts = [true, false] and
  (allowCasts = true or not hasExplicitCast(e)) and
  (
    pointerThis(e.(PointerDereferenceExpr).getChild(0), allowCasts)
    or
    // `f(...)`
    // (includes `*this = ...`, where `=` is overloaded so a `FunctionCall`)
    exists(FunctionCall fc | fc = e and callOnThis(fc, allowCasts) |
      returnsDereferenceThis(fc.getTarget(), allowCasts)
    )
    or
    // `helper(*this, ...)`, where every return directly returns the corresponding parameter.
    exists(FunctionCall fc, Parameter p, Expr arg |
      fc = e and
      not hasExplicitCast(fc) and
      fc.getTarget() = p.getFunction() and
      returnsReferenceParameter(p) and
      arg = fc.getArgument(p.getIndex()) and
      arg.getUnconverted().getType().getUnspecifiedType() =
        p.getType().getUnspecifiedType().(ReferenceType).getBaseType().getUnspecifiedType() and
      dereferenceThis(arg, false)
    )
    or
    // `*this = ...` (where `=` is not overloaded, so an `AssignExpr`)
    dereferenceThis(e.(AssignExpr).getLValue(), allowCasts)
    or
    // `e ? ... : ... `
    exists(ConditionalExpr cond |
      cond = e and
      dereferenceThis(cond.getThen(), allowCasts) and
      dereferenceThis(cond.getElse(), allowCasts)
    )
    or
    // `..., ... `
    dereferenceThis(e.(CommaExpr).getRightOperand(), allowCasts)
  )
}

/**
 * Holds if all `return` statements in `f` return `this`, possibly indirectly.
 * This includes functions whose body is not in the database.
 */
predicate returnsPointerThis(Function f, boolean allowCasts) {
  allowCasts = [true, false] and
  forall(ReturnStmt s | s.getEnclosingFunction() = f and reachable(s) |
    // `return this`
    pointerThis(s.getExpr(), allowCasts)
  )
}

/**
 * Holds if all `return` statements in `f` return a reference to `*this`,
 * possibly indirectly. This includes functions whose body is not in the
 * database.
 */
predicate returnsDereferenceThis(Function f, boolean allowCasts) {
  allowCasts = [true, false] and
  forall(ReturnStmt s | s.getEnclosingFunction() = f and reachable(s) |
    // `return *this`
    dereferenceThis(s.getExpr(), allowCasts)
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
  not returnsDereferenceThis(op, true) and
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
