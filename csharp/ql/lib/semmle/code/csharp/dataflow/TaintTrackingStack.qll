import csharp
private import codeql.dataflow.DataFlow
private import semmle.code.csharp.dataflow.internal.DataFlowImplSpecific
private import semmle.code.csharp.dataflow.internal.TaintTrackingImplSpecific
private import codeql.dataflowstack.FlowStack as FlowStack

module LanguageFlowStack = FlowStack::LanguageDataFlow<Location, CsharpDataFlow>;

private module FlowStackInput<DataFlow::ConfigSig Config>
  implements LanguageFlowStack::DataFlowConfigContext<Config>::FlowInstance
{
  private module Flow = TaintTracking::Global<Config>;
  class PathNode = Flow::PathNode;

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
  import LanguageFlowStack::FlowStack<Config, FlowStackInput<Config>>
}

module BiStackAnalysisMake<
  DataFlow::ConfigSig ConfigA,
  DataFlow::ConfigSig ConfigB
>{
  import LanguageFlowStack::BiStackAnalysis<ConfigA, FlowStackInput<ConfigA>, ConfigB, FlowStackInput<ConfigB>>
}