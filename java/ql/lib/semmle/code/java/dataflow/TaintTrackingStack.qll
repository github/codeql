overlay[local?]
module;

import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.dataflow.internal.DataFlowImplSpecific
private import semmle.code.java.dataflow.internal.TaintTrackingImplSpecific
private import codeql.dataflowstack.FlowStack as FlowStack

module LanguageFlowStack = FlowStack::LanguageDataFlow<Location, JavaDataFlow>;

private module FlowStackInput<DataFlow::ConfigSig Config>
  implements LanguageFlowStack::DataFlowConfigContext<Config>::FlowInstance
{
  private module Flow = TaintTracking::Global<Config>;
  class PathNode = Flow::PathNode;

  JavaDataFlow::Node getNode(PathNode n) { result = n.getNode() }

  predicate isSource(PathNode n) { n.isSource() }

  PathNode getASuccessor(PathNode n) { result = n.getASuccessor() }

  JavaDataFlow::DataFlowCallable getARuntimeTarget(JavaDataFlow::DataFlowCall call) {
    result.asCallable() = call.asCall().getCallee()
  }

  JavaDataFlow::Node getAnArgumentNode(JavaDataFlow::DataFlowCall call) {
    result = JavaDataFlow::exprNode(call.asCall().getAnArgument())
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