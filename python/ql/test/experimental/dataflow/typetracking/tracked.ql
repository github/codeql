import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TypeTracker
import TestUtilities.InlineExpectationsTest

DataFlow::Node tracked(TypeTracker t) {
  t.start() and
  result.asCfgNode() = any(NameNode n | n.getId() = "tracked")
  or
  exists(TypeTracker t2 | result = tracked(t2).track(t2, t))
}

class TrackedTest extends InlineExpectationsTest {
  TrackedTest() { this = "TrackedTest" }

  override string getARelevantTag() { result = "tracked" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node e, TypeTracker t |
      e = tracked(t) and
      // Module variables have no sensible location, and hence can't be annotated.
      not e instanceof DataFlow::ModuleVariableNode and
      tag = "tracked" and
      location = e.getLocation() and
      value = t.getAttr() and
      element = e.toString()
    )
  }
}

DataFlow::Node int_type(TypeTracker t) {
  t.start() and
  result.asCfgNode() = any(CallNode c | c.getFunction().(NameNode).getId() = "int")
  or
  exists(TypeTracker t2 | result = int_type(t2).track(t2, t))
}

DataFlow::Node string_type(TypeTracker t) {
  t.start() and
  result.asCfgNode() = any(CallNode c | c.getFunction().(NameNode).getId() = "str")
  or
  exists(TypeTracker t2 | result = string_type(t2).track(t2, t))
}

class TrackedIntTest extends InlineExpectationsTest {
  TrackedIntTest() { this = "TrackedIntTest" }

  override string getARelevantTag() { result = "int" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node e, TypeTracker t |
      e = int_type(t) and
      tag = "int" and
      location = e.getLocation() and
      value = t.getAttr() and
      element = e.toString()
    )
  }
}

class TrackedStringTest extends InlineExpectationsTest {
  TrackedStringTest() { this = "TrackedStringTest" }

  override string getARelevantTag() { result = "str" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node e, TypeTracker t |
      e = string_type(t) and
      tag = "str" and
      location = e.getLocation() and
      value = t.getAttr() and
      element = e.toString()
    )
  }
}
