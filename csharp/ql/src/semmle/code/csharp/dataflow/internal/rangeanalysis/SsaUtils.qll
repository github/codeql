/**
 * Provides utility predicates to extend the core SSA functionality.
 */

private import csharp
private import Ssa
private import ConstantUtils

/**
 * Gets an expression that equals `v - delta`.
 */
Expr ssaRead(Definition v, int delta) {
  result = v.getARead() and delta = 0
  or
  exists(AddExpr add, int d1, ConstantIntegerExpr c |
    result = add and
    delta = d1 - c.getIntValue()
  |
    add.getLeftOperand() = ssaRead(v, d1) and add.getRightOperand() = c
    or
    add.getRightOperand() = ssaRead(v, d1) and add.getLeftOperand() = c
  )
  or
  exists(SubExpr sub, int d1, ConstantIntegerExpr c |
    result = sub and
    sub.getLeftOperand() = ssaRead(v, d1) and
    sub.getRightOperand() = c and
    delta = d1 + c.getIntValue()
  )
  or
  v.(ExplicitDefinition).getADefinition().getExpr().(PreIncrExpr) = result and delta = 0
  or
  v.(ExplicitDefinition).getADefinition().getExpr().(PreDecrExpr) = result and delta = 0
  or
  v.(ExplicitDefinition).getADefinition().getExpr().(PostIncrExpr) = result and delta = 1 // x++ === ++x - 1
  or
  v.(ExplicitDefinition).getADefinition().getExpr().(PostDecrExpr) = result and delta = -1 // x-- === --x + 1
  or
  v.(ExplicitDefinition).getADefinition().getExpr().(Assignment) = result and delta = 0
  or
  result.(AssignExpr).getRValue() = ssaRead(v, delta)
}
