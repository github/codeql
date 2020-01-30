/**
 * @name Expression always evaluates to the same value
 * @description An expression that always evaluates to the same value, but which has a non-constant subexpression, indicates a mistake.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id java/evaluation-to-constant
 * @tags maintainability
 *       useless-code
 */

import java

int eval(Expr e) { result = e.(CompileTimeConstantExpr).getIntValue() }

predicate isConstantExp(Expr e) {
  // A literal is constant.
  e instanceof Literal
  or
  e instanceof TypeAccess
  or
  e instanceof ArrayTypeAccess
  or
  e instanceof WildcardTypeAccess
  or
  // A binary expression is constant if both its operands are.
  exists(BinaryExpr b | b = e |
    isConstantExp(b.getLeftOperand()) and
    isConstantExp(b.getRightOperand())
  )
  or
  // A cast expression is constant if its expression is.
  exists(CastExpr c | c = e | isConstantExp(c.getExpr()))
  or
  // Multiplication by 0 is constant.
  exists(MulExpr m | m = e | eval(m.getAnOperand()) = 0)
  or
  // Integer remainder by 1 is constant.
  exists(RemExpr r | r = e |
    r.getLeftOperand().getType() instanceof IntegralType and
    eval(r.getRightOperand()) = 1
  )
  or
  exists(AndBitwiseExpr a | a = e | eval(a.getAnOperand()) = 0)
  or
  exists(AndLogicalExpr a | a = e | a.getAnOperand().(BooleanLiteral).getBooleanValue() = false)
  or
  exists(OrLogicalExpr o | o = e | o.getAnOperand().(BooleanLiteral).getBooleanValue() = true)
}

from Expr e
where
  isConstantExp(e) and
  exists(Expr child | e.getAChildExpr() = child |
    not isConstantExp(child) and
    not child instanceof Annotation
  ) and
  not e instanceof CompileTimeConstantExpr and
  // Exclude explicit zero multiplication.
  not e.(MulExpr).getAnOperand().(IntegerLiteral).getIntValue() = 0 and
  // Exclude expressions that appear to be disabled deliberately (e.g. `false && ...`).
  not e.(AndLogicalExpr).getAnOperand().(BooleanLiteral).getBooleanValue() = false
select e, "Expression always evaluates to the same value."
