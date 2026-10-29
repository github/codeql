private import csharp
private import TaintTrackingPrivate

private predicate localTaintStepPlus(DataFlow::Node source, DataFlow::Node sink) =
  fastTC(localTaintStep/2)(source, sink)

/**
 * Holds if taint propagates from `source` to `sink` in zero or more local
 * (intra-procedural) steps.
 */
pragma[inline]
predicate localTaint(DataFlow::Node source, DataFlow::Node sink) {
  localTaintStepPlus(source, sink) or source = sink
}

/**
 * Holds if taint can flow from `e1` to `e2` in zero or more
 * local (intra-procedural) steps.
 */
pragma[inline]
predicate localExprTaint(Expr e1, Expr e2) {
  localTaint(DataFlow::exprNode(e1), DataFlow::exprNode(e2))
}

/** A member (property or field) that is tainted if its containing object is tainted. */
abstract class TaintedMember extends AssignableMember { }

predicate localTaintStep = localTaintStepImpl/2;
