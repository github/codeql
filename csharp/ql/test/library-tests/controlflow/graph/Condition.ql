import csharp
import ControlFlow

query predicate conditionBlock(BasicBlock cb, BasicBlock controlled, boolean testIsTrue) {
  cb.edgeDominates(controlled, any(ConditionalSuccessor s | testIsTrue = s.getValue()))
}

ControlFlowNode successor(ControlFlowNode node, boolean kind) {
  result = node.getASuccessor(any(BooleanSuccessor s | s.getValue() = kind))
}

query predicate conditionFlow(ControlFlowNode node, ControlFlowNode successor, boolean kind) {
  successor = successor(node, kind)
}
