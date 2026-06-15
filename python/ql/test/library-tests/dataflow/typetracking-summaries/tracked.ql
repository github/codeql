import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TypeTracking
import utils.test.InlineExpectationsTest
import semmle.python.ApiGraphs
import TestSummaries

// -----------------------------------------------------------------------------
// tracked
// -----------------------------------------------------------------------------
private DataFlow::TypeTrackingNode tracked(TypeTracker t) {
  t.start() and
  result.asCfgNode() = any(NameNode n | n.getId() = "tracked")
  or
  exists(TypeTracker t2 | result = tracked(t2).track(t2, t))
}

module TrackedTest implements TestSig {
  string getARelevantTag() { result = "tracked" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node e, TypeTracker t |
      exists(e.getLocation().getFile().getRelativePath()) and
      e.getLocation().getStartLine() > 0 and
      tracked(t).flowsTo(e) and
      // Module variables have no sensible location, and hence can't be annotated.
      not e instanceof DataFlow::ModuleVariableNode and
      tag = "tracked" and
      location = e.getLocation() and
      value = t.getAttr() and
      element = e.toString()
    )
  }
}

import MakeTest<TrackedTest>
