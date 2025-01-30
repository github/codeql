import csharp
private import codeql.dataflow.DataFlow
private import semmle.code.csharp.dataflow.internal.DataFlowImplSpecific
private import codeql.dataflowstack.DataFlowStack as DFS
private import DFS::DataFlowStackMake<Location, CsharpDataFlow> as DataFlowStackFactory

private module DataFlowStackInput<DataFlowStackFactory::DataFlow::ConfigSig Config> implements
  DFS::DataFlowStackSig<Location, CsharpDataFlow, Config>
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

module DataFlowStackMake<DataFlowStackFactory::DataFlow::ConfigSig Config> {
  import DataFlowStackFactory::FlowStack<Config, DataFlowStackInput<Config>>
}

module BiStackAnalysisMake<
  DataFlowStackFactory::DataFlow::ConfigSig ConfigA,
  DataFlowStackFactory::DataFlow::ConfigSig ConfigB>
{
  import DataFlowStackFactory::BiStackAnalysis<ConfigA, DataFlowStackInput<ConfigA>, ConfigB, DataFlowStackInput<ConfigB>>
}
