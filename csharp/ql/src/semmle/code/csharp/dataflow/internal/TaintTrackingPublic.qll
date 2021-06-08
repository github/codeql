private import csharp
private import TaintTrackingPrivate

/**
 * Holds if taint propagates from `source` to `sink` in zero or more local
 * (intra-procedural) steps.
 */
predicate localTaint(DataFlow::Node source, DataFlow::Node sink) { localTaintStep*(source, sink) }

/**
 * Holds if taint can flow from `e1` to `e2` in zero or more
 * local (intra-procedural) steps.
 */
predicate localExprTaint(Expr e1, Expr e2) {
  localTaint(DataFlow::exprNode(e1), DataFlow::exprNode(e2))
}

/** A member (property or field) that is tainted if its containing object is tainted. */
abstract class TaintedMember extends AssignableMember { }

predicate localTaintStep = localTaintStepImpl/2;
