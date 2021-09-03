/**
 * Provides utility predicates to extend the core SSA functionality.
 */

private import csharp
private import Ssa
private import RangeUtils
private import ConstantUtils

private class ExprNode = ControlFlow::Nodes::ExprNode;

/** An SSA variable. */
class SsaVariable extends Definition {
  /** Gets a read of this SSA variable. */
  ExprNode getAUse() { exists(this.getAReadAtNode(result)) }
}

/** Gets a node that reads `src` via an SSA explicit definition. */
ExprNode getAnExplicitDefinitionRead(ExprNode src) {
  exists(ExplicitDefinition def |
    exists(def.getAReadAtNode(result)) and
    hasChild(def.getElement(), def.getADefinition().getSource(), def.getControlFlowNode(), src)
  )
}

/**
 * Gets an expression that equals `v - delta`.
 */
ExprNode ssaRead(Definition v, int delta) {
  exists(v.getAReadAtNode(result)) and delta = 0
  or
  exists(ExprNode::AddExpr add, int d1, ConstantIntegerExpr c |
    result = add and
    delta = d1 - c.getIntValue()
  |
    add.getLeftOperand() = ssaRead(v, d1) and add.getRightOperand() = c
    or
    add.getRightOperand() = ssaRead(v, d1) and add.getLeftOperand() = c
  )
  or
  exists(ExprNode::SubExpr sub, int d1, ConstantIntegerExpr c |
    result = sub and
    sub.getLeftOperand() = ssaRead(v, d1) and
    sub.getRightOperand() = c and
    delta = d1 + c.getIntValue()
  )
  or
  v.(ExplicitDefinition).getControlFlowNode().(ExprNode::PreIncrExpr) = result and delta = 0
  or
  v.(ExplicitDefinition).getControlFlowNode().(ExprNode::PreDecrExpr) = result and delta = 0
  or
  v.(ExplicitDefinition).getControlFlowNode().(ExprNode::PostIncrExpr) = result and delta = 1 // x++ === ++x - 1
  or
  v.(ExplicitDefinition).getControlFlowNode().(ExprNode::PostDecrExpr) = result and delta = -1 // x-- === --x + 1
  or
  v.(ExplicitDefinition).getControlFlowNode().(ExprNode::Assignment) = result and delta = 0
  or
  result.(ExprNode::AssignExpr).getRValue() = ssaRead(v, delta)
}
