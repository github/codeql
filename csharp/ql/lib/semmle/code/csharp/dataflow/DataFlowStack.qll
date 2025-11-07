import csharp
private import codeql.dataflow.DataFlow
private import semmle.code.csharp.dataflow.internal.DataFlowImplSpecific
private import codeql.dataflowstack.DataFlowStack as DFS

module LanguageDataFlowStack = DFS::LanguageDataFlow<Location, CsharpDataFlow>;

private module FlowStackInput<DataFlow::ConfigSig Config>
  implements LanguageDataFlowStack::DataFlowGroup<Config>::DataFlowStackSig<DataFlow::Global<Config>>
{
  private module Flow = DataFlow::Global<Config>;

  CsharpDataFlow::Node getNode(Flow::PathNode n) { result = n.getNode() }

  predicate isSource(Flow::PathNode n) { n.isSource() }

  Flow::PathNode getASuccessor(Flow::PathNode n) { result = n.getASuccessor() }

  CsharpDataFlow::DataFlowCallable getARuntimeTarget(CsharpDataFlow::DataFlowCall call) {
    result = call.getARuntimeTarget()
  }

  CsharpDataFlow::Node getAnArgumentNode(CsharpDataFlow::DataFlowCall call) {
    result = call.getArgument(_)
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