import javascript
import semmle.javascript.dataflow.internal.FlowSteps as FlowSteps

query predicate argumentPassing(DataFlow::Node invk, DataFlow::Node arg, DataFlow::SourceNode parm) {
  exists(Function f | FlowSteps::argumentPassing(invk, arg, f, parm))
}

query predicate basicBlock(DataFlow::Node node, BasicBlock bb) { node.getBasicBlock() = bb }

query predicate enclosingExpr(DataFlow::Node node, Expr enclosingExpr) {
  enclosingExpr = node.getEnclosingExpr()
}

query predicate flowStep(DataFlow::Node pred, DataFlow::Node nd) { nd.getAPredecessor() = pred }

query predicate getImmediatePredecessor(DataFlow::Node pred, DataFlow::Node nd) {
  nd.getImmediatePredecessor() = pred
}

query predicate getIntValue(DataFlow::Node node, int val) { node.getIntValue() = val }

query predicate incomplete(DataFlow::Node dfn, DataFlow::Incompleteness cause) {
  dfn.isIncomplete(cause)
}

query predicate noBasicBlock(DataFlow::Node node) { not exists(node.getBasicBlock()) }

query predicate parameters(DataFlow::ParameterNode param) { any() }

query predicate sources(DataFlow::SourceNode src) { any() }
