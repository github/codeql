import python
import semmle.python.security.SensitiveActions

query predicate sensitiveNodes(SensitiveNode n, string dsc, string cls) {
  n.describe() = dsc and n.getClassification() = cls
}

query predicate sensitiveActions(SensitiveAction a) { any() }

query predicate methodCallNodes(DataFlow::MethodCallNode n) { any() }
