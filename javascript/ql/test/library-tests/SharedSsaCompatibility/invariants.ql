import javascript
import semmle.javascript.dataflow.internal.DataFlowNode
import semmle.javascript.dataflow.internal.DataFlowPrivate as DataFlowPrivate
import semmle.javascript.dataflow.internal.DataFlowImplConsistency as DataFlowImplConsistency
import semmle.javascript.dataflow.internal.sharedlib.Ssa as Ssa2
import Ssa2::Consistency
import Ssa2::DfConsistency

query predicate localFlowIsLocal = DataFlowImplConsistency::Consistency::localFlowIsLocal/3;

query predicate nonUniqueSsaDefinition(SsaDefinition definition, int nodes) {
  nodes = count(DataFlow::ssaDefinitionNode(definition)) and
  nodes != 1
}

query predicate nonUniqueSsaVariable(DataFlow::SsaDefinitionNode node, int variables) {
  variables = count(node.getSsaVariable()) and
  variables != 1
}

query predicate missingSsaNodeMetadata(DataFlow::Node node) {
  (
    node instanceof TSsaDefNode or
    node instanceof TSsaUseNode or
    node instanceof TSsaSynthReadNode
  ) and
  not (
    exists(node.toString()) and
    (exists(node.getBasicBlock()) or node instanceof TSsaUseNode) and
    exists(node.getContainer()) and
    exists(node.getLocation()) and
    exists(node.getFile())
  )
}

query predicate orphanSsaDefinitionNode(DataFlow::Node node) {
  node instanceof TSsaDefNode and
  not node instanceof DataFlow::SsaDefinitionNode
}

query predicate ssaDefinitionHasAstNode(DataFlow::SsaDefinitionNode node, AstNode ast) {
  ast = node.getAstNode()
}

query predicate unmappedWriteDefSourceNode(Ssa2::WriteDefSourceNode node, int mapped) {
  mapped = count(DataFlowPrivate::getNodeFromSsa2(node)) and
  mapped != 1
}

query predicate nonUniqueSharedSsaNodeMapping(Ssa2::Node node, int mapped) {
  mapped = count(DataFlowPrivate::getNodeFromSsa2(node)) and
  mapped > 1
}

query predicate sharedReadContainerMismatch(Ssa2::ExprNode read) {
  TSsaUseNode(read.getExpr()).(DataFlow::Node).getContainer() !=
    DataFlowPrivate::getNodeFromSsa2(read).(DataFlow::Node).getContainer()
}

query predicate postUpdateMustFlow(DataFlow::PostUpdateNode update, DataFlow::Node node) {
  node.getImmediatePredecessor() = update
}
