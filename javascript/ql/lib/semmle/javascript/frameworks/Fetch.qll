/**
 * Provides an additional flow step that propagates data from the receiver of fetch response methods.
 */

private import javascript

/**
 * An additional flow step that propagates data from the receiver of fetch response methods
 * (like "json", "text", "blob", and "arrayBuffer") to the call result.
 */
class Fetch extends DataFlow::AdditionalFlowStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    exists(DataFlow::MethodCallNode call |
      call.getMethodName() in ["json", "text", "blob", "arrayBuffer"] and
      node1 = call.getReceiver() and
      node2 = call
    )
  }
}
