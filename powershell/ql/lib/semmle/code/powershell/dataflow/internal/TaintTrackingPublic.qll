private import powershell
private import TaintTrackingPrivate as Private
private import semmle.code.powershell.Cfg
private import semmle.code.powershell.dataflow.DataFlow

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
predicate localExprTaint(CfgNodes::ExprCfgNode e1, CfgNodes::ExprCfgNode e2) {
  localTaintStep*(DataFlow::exprNode(e1), DataFlow::exprNode(e2))
}

predicate stringInterpolationTaintStep = Private::stringInterpolationTaintStep/2;

predicate operationTaintStep = Private::operationTaintStep/2;

predicate localTaintStep = Private::localTaintStepCached/2;
