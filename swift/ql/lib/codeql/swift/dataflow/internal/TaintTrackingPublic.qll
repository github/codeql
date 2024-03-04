private import swift
private import TaintTrackingPrivate
private import DataFlowPrivate
private import codeql.swift.dataflow.DataFlow

/**
 * Holds if taint propagates from `source` to `sink` in zero or more local
 * (intra-procedural) steps.
 */
pragma[inline]
predicate localTaint(DataFlow::Node source, DataFlow::Node sink) { localTaintStep*(source, sink) }

/**
 * Holds if taint can flow from `e1` to `e2` in zero or more
 * local (intra-procedural) steps.
 */
pragma[inline]
predicate localExprTaint(DataFlowExpr e1, DataFlowExpr e2) {
  localTaint(DataFlow::exprNode(e1), DataFlow::exprNode(e2))
}

predicate localTaintStep = localTaintStepCached/2;

/**
 * Holds if default `TaintTracking::Configuration`s should allow implicit reads
 * of `c` at sinks and inputs to additional taint steps.
 */
bindingset[node]
pragma[inline_late]
predicate defaultImplicitTaintRead(DataFlow::Node node, DataFlow::ContentSet cs) {
  // If a `PostUpdateNode` is specified as a sink, there's (almost) always a store step preceding it.
  // So when the node is a `PostUpdateNode` we allow any sequence of implicit read steps of an appropriate
  // type to make sure we arrive at the sink with an empty access path.
  exists(NominalTypeDecl d, Decl cx |
    node.(DataFlow::PostUpdateNode)
        .getPreUpdateNode()
        .asExpr()
        .getType()
        .getUnderlyingType()
        .getABaseType*() = d.getType() and
    cx.asNominalTypeDecl() = d and
    cs.getAReadContent().(DataFlow::Content::FieldContent).getField() = cx.getAMember()
  )
  or
  // We often expect taint to reach a sink inside `CollectionContent`, for example an array element
  // or pointer contents. It is convenient to have a default implicit read step for these cases rather
  // than implementing this step in a lot of separate `allowImplicitRead`s.
  cs.getAReadContent() instanceof DataFlow::Content::CollectionContent
}
