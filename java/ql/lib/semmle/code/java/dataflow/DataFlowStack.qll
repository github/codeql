import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.internal.DataFlowImplSpecific
private import codeql.dataflowstack.DataFlowStack as DFS
private import DFS::DataFlowStackMake<Location, JavaDataFlow> as DataFlowStackFactory

private module DataFlowStackInput<DataFlowStackFactory::DataFlow::ConfigSig Config> implements
  DFS::DataFlowStackSig<Location, JavaDataFlow, Config>
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

module DataFlowStackMake<DataFlowStackFactory::DataFlow::ConfigSig Config> {
  import DataFlowStackFactory::FlowStack<Config, DataFlowStackInput<Config>>
}

module BiStackAnalysisMake<
  DataFlowStackFactory::DataFlow::ConfigSig ConfigA,
  DataFlowStackFactory::DataFlow::ConfigSig ConfigB>
{
  import DataFlowStackFactory::BiStackAnalysis<ConfigA, DataFlowStackInput<ConfigA>, ConfigB, DataFlowStackInput<ConfigB>>
}
