private import javascript

class Fetch extends DataFlow::AdditionalFlowStep {
  override predicate step(DataFlow::Node node1, DataFlow::Node node2) {
    exists(DataFlow::MethodCallNode call |
      call.getMethodName() in ["json", "text", "blob", "arrayBuffer"] and
      node1 = call.getReceiver() and
      node2 = call
    )
  }
}
