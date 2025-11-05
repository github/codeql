import csharp
private import codeql.dataflow.DataFlow
private import semmle.code.csharp.dataflow.internal.DataFlowImplSpecific
private import semmle.code.csharp.dataflow.internal.TaintTrackingImplSpecific
private import codeql.dataflowstack.TaintTrackingStack as TTS

module LanguageTaintTrackingStack = TTS::LanguageTaintTracking<Location, CsharpDataFlow, CsharpTaintTracking>;

private module TaintTrackingStackInput<DataFlow::ConfigSig Config>
  implements LanguageTaintTrackingStack::DataFlowGroup<Config>::TaintTrackingStackSig<TaintTracking::Global<Config>>
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

module DataFlowStackMake<DataFlow::ConfigSig Config> {
  import LanguageTaintTrackingStack::FlowStack<TaintTracking::Global<Config>, Config, TaintTrackingStackInput<Config>>
}

module BiStackAnalysisMake<
  DataFlow::ConfigSig ConfigA,
  DataFlow::ConfigSig ConfigB
>{
  import LanguageTaintTrackingStack::BiStackAnalysis<ConfigA, TaintTracking::Global<ConfigA>, TaintTrackingStackInput<ConfigA>, ConfigB, TaintTracking::Global<ConfigB>, TaintTrackingStackInput<ConfigB>>
}