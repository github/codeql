private import rust
import ControlFlowGraphImplSpecific::CfgImpl
import Completion

class CallTree extends StandardPostOrderTree instanceof Call {
  override ControlFlowTree getChildNode(int i) { result = super.getArg(i) }
}

class BinaryOpTree extends StandardPostOrderTree instanceof BinaryOp {
  override ControlFlowTree getChildNode(int i) {
    i = 0 and result = super.getLhs()
    or
    i = 1 and result = super.getRhs()
  }
}

class IfTree extends PostOrderTree instanceof If {
  override predicate first(AstNode node) { first(super.getCondition(), node) }

  override predicate propagatesAbnormal(AstNode child) { none() }

  override predicate succ(AstNode pred, AstNode succ, Completion c) {
    // Edges from the condition to each branch
    last(super.getCondition(), pred, c) and
    (
      first(super.getThen(), succ) and c.(BooleanCompletion).getValue() = true
      or
      first(super.getElse(), succ) and c.(BooleanCompletion).getValue() = false
    )
    or
    // An edge from the then branch to the last node
    last(super.getThen(), pred, c) and
    succ = this and
    completionIsSimple(c)
    or
    // An edge from the else branch to the last node
    last(super.getElse(), pred, c) and
    succ = this and
    completionIsSimple(c)
  }
}

class LetTree extends StandardPostOrderTree instanceof Let {
  override ControlFlowTree getChildNode(int i) { i = 0 and result = super.getExpr() }
}

class LiteralTree extends LeafTree instanceof Literal { }
