import csharp
private import codeql.dataflow.DataFlow
private import semmle.code.csharp.dataflow.internal.DataFlowImplSpecific
private import semmle.code.csharp.dataflow.internal.TaintTrackingImplSpecific
private import codeql.dataflowstack.TaintTrackingStack as TTS
private import TTS::TaintTrackingStackMake<Location, CsharpDataFlow, CsharpTaintTracking> as TaintTrackingStackFactory

private module TaintTrackingStackInput<TaintTrackingStackFactory::DataFlow::ConfigSig Config>
  implements TTS::TaintTrackingStackSig<Location, CsharpDataFlow, CsharpTaintTracking, Config>
{
  private module Flow = TaintTracking::Global<Config>;

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

module TaintTrackingStackMake<TaintTrackingStackFactory::DataFlow::ConfigSig Config> {
  import TaintTrackingStackFactory::FlowStack<Config, TaintTrackingStackInput<Config>>
}

module BiStackAnalysisMake<
  TaintTrackingStackFactory::DataFlow::ConfigSig ConfigA,
  TaintTrackingStackFactory::DataFlow::ConfigSig ConfigB>
{
  import TaintTrackingStackFactory::BiStackAnalysis<ConfigA, TaintTrackingStackInput<ConfigA>, ConfigB, TaintTrackingStackInput<ConfigB>>
}