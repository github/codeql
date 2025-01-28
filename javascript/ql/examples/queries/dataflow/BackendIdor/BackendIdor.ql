/**
 * @name IDOR through request to backend service
 * @description Finds cases where the 'userId' field in a request to another service
 *              is an arbitrary user-controlled value, indicating lack of authentication.
 * @kind path-problem
 * @problem.severity error
 * @tags security
 * @id js/examples/backend-idor
 */

import javascript

/**
 * A taint-tracking configuration that tracks user-controlled values into a 'userId' property sent to a backend service.
 */
module IdorTaintConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node node) { exists(ClientRequest req | node = req.getADataNode()) }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    // Step from x -> { userId: x }
    node2.(DataFlow::SourceNode).getAPropertyWrite("userId").getRhs() = node1
  }

  predicate isBarrier(DataFlow::Node node) {
    // After a check like `if (userId === session.user.id)`, the userId is considered safe.
    node = DataFlow::MakeBarrierGuard<EqualityGuard>::getABarrierNode()
  }
}

/**
 * A sanitizer for values that have successfully been compared to another value.
 */
class EqualityGuard extends DataFlow::ValueNode {
  override EqualityTest astNode;

  predicate blocksExpr(boolean outcome, Expr e) {
    e = astNode.getAnOperand() and
    outcome = astNode.getPolarity()
  }
}

module IdorTaintFlow = TaintTracking::Global<IdorTaintConfig>;

import IdorTaintFlow::PathGraph

from IdorTaintFlow::PathNode source, IdorTaintFlow::PathNode sink
where IdorTaintFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Unauthenticated user ID from $@.", source.getNode(), "here"
