import csharp
import ControlFlow

query predicate conditionBlock(
  BasicBlocks::ConditionBlock cb, BasicBlock controlled, boolean testIsTrue
) {
  cb.edgeDominates(controlled, any(ConditionalSuccessor s | testIsTrue = s.getValue()))
}

ControlFlowNode successor(ControlFlowNode node, boolean kind) {
  kind = true and result = node.getATrueSuccessor()
  or
  kind = false and result = node.getAFalseSuccessor()
}

query predicate conditionFlow(ControlFlowNode node, ControlFlowNode successor, boolean kind) {
  successor = successor(node, kind)
}
