import csharp
import ControlFlow

query predicate conditionBlock(
  BasicBlocks::ConditionBlock cb, BasicBlock controlled, boolean testIsTrue
) {
  cb.controls(controlled, any(SuccessorTypes::ConditionalSuccessor s | testIsTrue = s.getValue()))
}

ControlFlow::Node successor(ControlFlow::Node node, boolean kind) {
  kind = true and result = node.getATrueSuccessor()
  or
  kind = false and result = node.getAFalseSuccessor()
}

query predicate conditionFlow(ControlFlow::Node node, ControlFlow::Node successor, boolean kind) {
  successor = successor(node, kind)
}
