overlay[local?]
module;

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.dataflow.internal.DataFlowImplSpecific
private import semmle.code.java.dataflow.internal.TaintTrackingImplSpecific
private import codeql.dataflowstack.TaintTrackingStack as TTS
private import TTS::TaintTrackingStackMake<Location, JavaDataFlow, JavaTaintTracking> as TaintTrackingStackFactory

private module TaintTrackingStackInput<TaintTrackingStackFactory::DataFlow::ConfigSig Config>
  implements TTS::TaintTrackingStackSig<Location, JavaDataFlow, JavaTaintTracking, Config>
{
  private module Flow = TaintTracking::Global<Config>;

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

module DataFlowStackMake<TaintTrackingStackFactory::DataFlow::ConfigSig Config> {
  import TaintTrackingStackFactory::FlowStack<Config, TaintTrackingStackInput<Config>>
}

module BiStackAnalysisMake<
  TaintTrackingStackFactory::DataFlow::ConfigSig ConfigA,
  TaintTrackingStackFactory::DataFlow::ConfigSig ConfigB>
{
  import TaintTrackingStackFactory::BiStackAnalysis<ConfigA, TaintTrackingStackInput<ConfigA>, ConfigB, TaintTrackingStackInput<ConfigB>>
}