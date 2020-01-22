/**
 * @name Auto boxing or unboxing
 * @description Implicit boxing or unboxing of primitive types, such as 'int' and 'double',
 *              may cause confusion and subtle performance problems.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/implicit-auto-boxing
 * @tags efficiency
 */

import java

/** An expression of primitive type. */
class PrimitiveExpr extends Expr {
  PrimitiveExpr() { this.getType() instanceof PrimitiveType }
}

/** An expression of boxed type. */
class BoxedExpr extends Expr {
  BoxedExpr() { this.getType() instanceof BoxedType }
}

/**
 * Relate expressions and the variables they flow into in one step,
 * either by assignment or parameter passing.
 */
Variable flowTarget(Expr arg) {
  arg = result.getAnAssignedValue()
  or
  exists(Call c, int i | c.getArgument(i) = arg and result = c.getCallee().getParameter(i))
}

/**
 * Holds if `e` is in a syntactic position where it is implicitly unboxed.
 */
predicate unboxed(BoxedExpr e) {
  exists(BinaryExpr bin | e = bin.getAnOperand() |
    if bin instanceof EqualityTest or bin instanceof ComparisonExpr
    then bin.getAnOperand() instanceof PrimitiveExpr
    else bin instanceof PrimitiveExpr
  )
  or
  exists(Assignment assign | assign.getDest() instanceof PrimitiveExpr | assign.getSource() = e)
  or
  flowTarget(e).getType() instanceof PrimitiveType
  or
  exists(ConditionalExpr cond | cond instanceof PrimitiveExpr |
    cond.getTrueExpr() = e or cond.getFalseExpr() = e
  )
}

/**
 * Holds if `e` is in a syntactic position where it is implicitly boxed.
 */
predicate boxed(PrimitiveExpr e) {
  exists(AssignExpr assign | assign.getDest() instanceof BoxedExpr | assign.getSource() = e)
  or
  flowTarget(e).getType() instanceof BoxedType
  or
  exists(ConditionalExpr cond | cond instanceof BoxedExpr |
    cond.getTrueExpr() = e or cond.getFalseExpr() = e
  )
}

/**
 * Holds if `e` is an assignment that unboxes, updates and reboxes `v`.
 */
predicate rebox(Assignment e, Variable v) {
  v.getType() instanceof BoxedType and
  not e instanceof AssignExpr and
  e.getDest() = v.getAnAccess()
}

from Expr e, string conv
where
  boxed(e) and conv = "This expression is implicitly boxed."
  or
  unboxed(e) and conv = "This expression is implicitly unboxed."
  or
  exists(Variable v | rebox(e, v) |
    conv =
      "This expression implicitly unboxes, updates, and reboxes the value of '" + v.getName() + "'."
  )
select e, conv
