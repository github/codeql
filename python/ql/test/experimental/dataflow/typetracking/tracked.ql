import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TypeTracker
import TestUtilities.InlineExpectationsTest
import semmle.python.ApiGraphs

// -----------------------------------------------------------------------------
// tracked
// -----------------------------------------------------------------------------
private DataFlow::TypeTrackingNode tracked(TypeTracker t) {
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

// -----------------------------------------------------------------------------
// int + str
// -----------------------------------------------------------------------------
private DataFlow::TypeTrackingNode int_type(TypeTracker t) {
  t.start() and
  result.asCfgNode() = any(CallNode c | c.getFunction().(NameNode).getId() = "int")
  or
  exists(TypeTracker t2 | result = int_type(t2).track(t2, t))
}

private DataFlow::TypeTrackingNode string_type(TypeTracker t) {
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
      int_type(t).flowsTo(e) and
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
      string_type(t).flowsTo(e) and
      tag = "str" and
      location = e.getLocation() and
      value = t.getAttr() and
      element = e.toString()
    )
  }
}

// -----------------------------------------------------------------------------
// tracked_self
// -----------------------------------------------------------------------------
private DataFlow::TypeTrackingNode tracked_self(TypeTracker t) {
  t.start() and
  exists(Function f |
    f.isMethod() and
    f.getName() = "track_self" and
    result.(DataFlow::ParameterNode).getParameter() = f.getArg(0)
  )
  or
  exists(TypeTracker t2 | result = tracked_self(t2).track(t2, t))
}

class TrackedSelfTest extends InlineExpectationsTest {
  TrackedSelfTest() { this = "TrackedSelfTest" }

  override string getARelevantTag() { result = "tracked_self" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node e, TypeTracker t |
      tracked_self(t).flowsTo(e) and
      // Module variables have no sensible location, and hence can't be annotated.
      not e instanceof DataFlow::ModuleVariableNode and
      tag = "tracked_self" and
      location = e.getLocation() and
      value = t.getAttr() and
      element = e.toString()
    )
  }
}

// -----------------------------------------------------------------------------
// tracked_foo_bar_baz
// -----------------------------------------------------------------------------
// This modeling follows the same pattern that we currently use in our real library modeling.
/** Gets a reference to `foo` (fictive module). */
private DataFlow::TypeTrackingNode foo(DataFlow::TypeTracker t) {
  t.start() and
  result = API::moduleImport("foo").getAUse()
  or
  exists(DataFlow::TypeTracker t2 | result = foo(t2).track(t2, t))
}

/** Gets a reference to `foo` (fictive module). */
DataFlow::Node foo() { foo(DataFlow::TypeTracker::end()).flowsTo(result) }

/** Gets a reference to `foo.bar` (fictive module). */
private DataFlow::TypeTrackingNode foo_bar(DataFlow::TypeTracker t) {
  t.start() and
  result = API::moduleImport("foo.bar").getAUse()
  or
  t.startInAttr("bar") and
  result = foo()
  or
  exists(DataFlow::TypeTracker t2 | result = foo_bar(t2).track(t2, t))
}

/** Gets a reference to `foo.bar` (fictive module). */
DataFlow::Node foo_bar() { foo_bar(DataFlow::TypeTracker::end()).flowsTo(result) }

/** Gets a reference to `foo.bar.baz` (fictive attribute on `foo.bar` module). */
private DataFlow::TypeTrackingNode foo_bar_baz(DataFlow::TypeTracker t) {
  t.start() and
  result = API::moduleImport("foo.bar.baz").getAUse()
  or
  t.startInAttr("baz") and
  result = foo_bar()
  or
  exists(DataFlow::TypeTracker t2 | result = foo_bar_baz(t2).track(t2, t))
}

/** Gets a reference to `foo.bar.baz` (fictive attribute on `foo.bar` module). */
DataFlow::Node foo_bar_baz() { foo_bar_baz(DataFlow::TypeTracker::end()).flowsTo(result) }

class TrackedFooBarBaz extends InlineExpectationsTest {
  TrackedFooBarBaz() { this = "TrackedFooBarBaz" }

  override string getARelevantTag() { result = "tracked_foo_bar_baz" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node e |
      e = foo_bar_baz() and
      // Module variables have no sensible location, and hence can't be annotated.
      not e instanceof DataFlow::ModuleVariableNode and
      tag = "tracked_foo_bar_baz" and
      location = e.getLocation() and
      value = "" and
      element = e.toString()
    )
  }
}
