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

/**
 * Holds if taint propagates from `nodeFrom` to `nodeTo` in exactly one local
 * (intra-procedural) step.
 */
predicate localTaintStep(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
  // Ordinary data flow
  DataFlow::localFlowStep(nodeFrom, nodeTo)
  or
  localAdditionalTaintStep(nodeFrom, nodeTo)
}
