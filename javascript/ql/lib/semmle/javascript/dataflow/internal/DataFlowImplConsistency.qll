private import javascript
private import codeql.dataflow.internal.DataFlowImplConsistency
private import sharedlib.DataFlowArg
private import semmle.javascript.dataflow.internal.DataFlowPrivate
private import semmle.javascript.dataflow.internal.DataFlowNode

private module ConsistencyConfig implements InputSig<Location, JSDataFlow> {
  private predicate isAmbientNode(DataFlow::Node node) {
    exists(AstNode n | n.isAmbient() |
      node = TValueNode(n) or
      node = TThisNode(n) or
      node = TReflectiveParametersNode(n) or
      node = TPropNode(n) or
      node = TFunctionSelfReferenceNode(n) or
      node = TExceptionalFunctionReturnNode(n) or
      node = TExprPostUpdateNode(n) or
      node = TExceptionalInvocationReturnNode(n) or
      node = TDestructuredModuleImportNode(n)
    )
  }

  predicate missingLocationExclude(DataFlow::Node n) {
    n instanceof FlowSummaryNode
    or
    n instanceof FlowSummaryIntermediateAwaitStoreNode
    or
    n instanceof FlowSummaryDynamicParameterArrayNode
    or
    n instanceof FlowSummaryDefaultExceptionalReturn
    or
    n instanceof GenericSynthesizedNode
    or
    n = DataFlow::globalAccessPathRootPseudoNode()
  }

  predicate uniqueNodeLocationExclude(DataFlow::Node n) { missingLocationExclude(n) }

  predicate uniqueEnclosingCallableExclude(DataFlow::Node n) { isAmbientNode(n) }

  predicate uniqueCallEnclosingCallableExclude(DataFlowCall call) {
    isAmbientNode(call.asOrdinaryCall()) or
    isAmbientNode(call.asAccessorCall())
  }

  predicate argHasPostUpdateExclude(ArgumentNode node) {
    // Side-effects directly on these can't propagate back to the caller, and for longer access paths it's too imprecise
    node instanceof TStaticArgumentArrayNode or
    node instanceof TDynamicArgumentArrayNode
  }

  predicate reverseReadExclude(DataFlow::Node node) {
    node instanceof FlowSummaryDynamicParameterArrayNode
  }
}

module Consistency = MakeConsistency<Location, JSDataFlow, JSTaintFlow, ConsistencyConfig>;
