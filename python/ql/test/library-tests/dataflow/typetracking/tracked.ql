import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TypeTracking
import utils.test.InlineExpectationsTest
import semmle.python.ApiGraphs
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DP

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
      tracked(t).flowsTo(e) and
      // Module variables have no sensible location, and hence can't be annotated.
      not e instanceof DataFlow::ModuleVariableNode and
      // Global variables on line 0 also cannot be annotated
      not e.getLocation().getStartLine() = 0 and
      // We do not wish to annotate scope entry definitions,
      // as they do not appear in the source code.
      not e instanceof DataFlow::ScopeEntryDefinitionNode and
      // ...same for `SynthCaptureNode`s
      not e instanceof DP::SynthCaptureNode and
      // after starting to track all kinds of content, we generally just want to show
      // annotations after reading the tracked data out again. (we keep the old
      // attribute logic to not rewrite all our tests)
      (
        t.getContent().isNone()
        or
        t.getContent().asSome() instanceof DataFlow::AttributeContent
      ) and
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

module TrackedIntTest implements TestSig {
  string getARelevantTag() { result = "int" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node e, TypeTracker t |
      int_type(t).flowsTo(e) and
      tag = "int" and
      location = e.getLocation() and
      value = t.getAttr() and
      element = e.toString()
    )
  }
}

module TrackedStringTest implements TestSig {
  string getARelevantTag() { result = "str" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
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

module TrackedSelfTest implements TestSig {
  string getARelevantTag() { result = "tracked_self" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
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
  result = API::moduleImport("foo").asSource()
  or
  exists(DataFlow::TypeTracker t2 | result = foo(t2).track(t2, t))
}

/** Gets a reference to `foo` (fictive module). */
DataFlow::Node foo() { foo(DataFlow::TypeTracker::end()).flowsTo(result) }

/** Gets a reference to `foo.bar` (fictive module). */
private DataFlow::TypeTrackingNode foo_bar(DataFlow::TypeTracker t) {
  t.start() and
  result = API::moduleImport("foo").getMember("bar").asSource()
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
  result = API::moduleImport("foo").getMember("bar").getMember("baz").asSource()
  or
  t.startInAttr("baz") and
  result = foo_bar()
  or
  exists(DataFlow::TypeTracker t2 | result = foo_bar_baz(t2).track(t2, t))
}

/** Gets a reference to `foo.bar.baz` (fictive attribute on `foo.bar` module). */
DataFlow::Node foo_bar_baz() { foo_bar_baz(DataFlow::TypeTracker::end()).flowsTo(result) }

module TrackedFooBarBaz implements TestSig {
  string getARelevantTag() { result = "tracked_foo_bar_baz" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
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

import MakeTest<MergeTests5<TrackedTest, TrackedIntTest, TrackedStringTest, TrackedSelfTest, TrackedFooBarBaz>>
