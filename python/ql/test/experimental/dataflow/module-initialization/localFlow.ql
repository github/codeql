// This query should be more focused yet.
import python
import semmle.python.dataflow.new.DataFlow

pragma[inline]
predicate inCodebase(DataFlow::Node node) { exists(node.getLocation().getFile().getRelativePath()) }

pragma[inline]
predicate isTopLevel(DataFlow::Node node) { node.getScope() instanceof Module }

predicate inFocus(DataFlow::Node node) {
  isTopLevel(node) and
  inCodebase(node)
}

from DataFlow::Node nodeFrom, DataFlow::Node nodeTo
where
  inFocus(nodeFrom) and
  inFocus(nodeTo) and
  DataFlow::localFlowStep(nodeFrom, nodeTo)
select nodeFrom, nodeTo
