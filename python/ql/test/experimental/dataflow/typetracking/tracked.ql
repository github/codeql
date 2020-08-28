import python
import experimental.dataflow.TypeTracker
import TestUtilities.InlineExpectationsTest

Node tracked(TypeTracker t) {
  t.start() and
  result.asCfgNode() = any(NameNode n | n.getId() = "tracked")
  or
  exists(TypeTracker t2 | result = tracked(t2).track(t2, t))
}

class TrackedTest extends InlineExpectationsTest {
  TrackedTest() { this = "TrackedTest" }

  override string getARelevantTag() { result = "tracked" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Node e, TypeTracker t |
      e = tracked(t) and
      tag = "tracked" and
      location = e.getLocation() and
      value = t.getProp() and
      element = e.toString()
    )
  }
}
