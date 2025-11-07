overlay[local?]
module;

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.internal.DataFlowImplSpecific
private import codeql.dataflowstack.DataFlowStack as DFS

module LanguageDataFlowStack = DFS::LanguageDataFlow<Location, JavaDataFlow>;

private module FlowStackInput<DataFlow::ConfigSig Config>
  implements LanguageDataFlowStack::DataFlowGroup<Config>::DataFlowStackSig<DataFlow::Global<Config>>
{
  private module Flow = DataFlow::Global<Config>;

  JavaDataFlow::Node getNode(Flow::PathNode n) { result = n.getNode() }

  predicate isSource(Flow::PathNode n) { n.isSource() }

  Flow::PathNode getASuccessor(Flow::PathNode n) { result = n.getASuccessor() }

  JavaDataFlow::DataFlowCallable getARuntimeTarget(JavaDataFlow::DataFlowCall call) {
    result.asCallable() = call.asCall().getCallee()
  }

  JavaDataFlow::Node getAnArgumentNode(JavaDataFlow::DataFlowCall call) {
    result = JavaDataFlow::exprNode(call.asCall().getAnArgument())
  }
}

module DataFlowStackMake<DataFlow::ConfigSig Config> {
  import LanguageDataFlowStack::FlowStack<DataFlow::Global<Config>, Config, FlowStackInput<Config>>
}

module BiStackAnalysisMake<
  DataFlow::ConfigSig ConfigA,
  DataFlow::ConfigSig ConfigB
>{
  import LanguageDataFlowStack::BiStackAnalysis<ConfigA, DataFlow::Global<ConfigA>, FlowStackInput<ConfigA>, ConfigB, DataFlow::Global<ConfigB>, FlowStackInput<ConfigB>>
}