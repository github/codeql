/**
 * Inline-expectations test for node reachability in the shared CFG facade.
 */

import python
import semmle.python.controlflow.internal.Cfg as Cfg
import utils.test.InlineExpectationsTest

private Cfg::NameNode caseNode(string caseId, string role) {
  role = ["source", "destination"] and
  result.isStore() and
  result.getId() = "reachability_" + caseId + "_" + role
}

module StrictlyReachesTest implements TestSig {
  string getARelevantTag() { result = ["reaches", "not-reaches"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(Cfg::NameNode source, Cfg::NameNode destination |
      source = caseNode(value, "source") and
      destination = caseNode(value, "destination") and
      location = destination.getLocation() and
      element = destination.toString() and
      (
        tag = "reaches" and
        source.strictlyReaches(destination)
        or
        tag = "not-reaches" and
        not source.strictlyReaches(destination)
      )
    )
  }
}

import MakeTest<StrictlyReachesTest>
