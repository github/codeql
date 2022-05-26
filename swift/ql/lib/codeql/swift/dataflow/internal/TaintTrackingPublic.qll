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
