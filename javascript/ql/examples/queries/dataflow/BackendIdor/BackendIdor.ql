/**
 * @name IDOR through request to backend service
 * @description Finds cases where the 'userId' field in a request to another service
 *              is an arbitrary user-controlled value, indicating lack of authentication.
 * @kind path-problem
 * @tags security
 * @id js/examples/backend-idor
 */

import javascript
import DataFlow
import DataFlow::PathGraph

/**
 * Tracks user-controlled values into a 'userId' property sent to a backend service.
 */
class IdorTaint extends TaintTracking::Configuration {
  IdorTaint() { this = "IdorTaint" }

  override predicate isSource(Node node) { node instanceof RemoteFlowSource }

  override predicate isSink(Node node) { exists(ClientRequest req | node = req.getADataNode()) }

  override predicate isAdditionalTaintStep(Node pred, Node succ) {
    // Step from x -> { userId: x }
    succ.(SourceNode).getAPropertyWrite("userId").getRhs() = pred
  }

  override predicate isSanitizerGuard(TaintTracking::SanitizerGuardNode node) {
    // After a check like `if (userId === session.user.id)`, the userId is considered safe.
    node instanceof EqualityGuard
  }
}

/**
 * Sanitize values that have succesfully been compared to another value.
 */
class EqualityGuard extends TaintTracking::SanitizerGuardNode, ValueNode {
  override EqualityTest astNode;

  override predicate sanitizes(boolean outcome, Expr e) {
    e = astNode.getAnOperand() and
    outcome = astNode.getPolarity()
  }
}

from IdorTaint cfg, PathNode source, PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Unauthenticated user ID from $@.", source.getNode(), "here"
