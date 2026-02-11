/**
 * Defines a InlineExpectationsTest for checking whether any arguments in
 * `ensure_tainted` and `ensure_not_tainted` calls are tainted.
 *
 * Also defines query predicates to ensure that:
 * - if any arguments to `ensure_not_tainted` are tainted, their annotation is marked with `SPURIOUS`.
 * - if any arguments to `ensure_tainted` are not tainted, their annotation is marked with `MISSING`.
 *
 * The functionality of this module is tested in `ql/test/experimental/meta/inline-taint-test-demo`.
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.RemoteFlowSources
import utils.test.InlineExpectationsTest
private import semmle.python.dataflow.new.internal.PrintNode
private import semmle.python.Concepts

DataFlow::Node shouldBeTainted() {
  exists(DataFlow::CallCfgNode call |
    call.getFunction().asCfgNode().(NameNode).getId() = "ensure_tainted" and
    result in [call.getArg(_), call.getArgByName(_)]
  )
}

DataFlow::Node shouldNotBeTainted() {
  exists(DataFlow::CallCfgNode call |
    call.getFunction().asCfgNode().(NameNode).getId() = "ensure_not_tainted" and
    result in [call.getArg(_), call.getArgByName(_)]
  )
}

// this module allows the configuration to be imported in other `.ql` files without the
// top level query predicates of this file coming into scope.
module Conf {
  module TestTaintTrackingConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) {
      source.asCfgNode().(NameNode).getId() in [
          "TAINTED_STRING", "TAINTED_BYTES", "TAINTED_LIST", "TAINTED_DICT"
        ]
      or
      // User defined sources
      exists(CallNode call |
        call.getFunction().(NameNode).getId() = "taint" and
        source.(DataFlow::CfgNode).getNode() = call.getAnArg()
      )
      or
      source instanceof ThreatModelSource
    }

    predicate isSink(DataFlow::Node sink) {
      sink = shouldBeTainted()
      or
      sink = shouldNotBeTainted()
    }
  }
}

import Conf

module MakeInlineTaintTest<DataFlow::ConfigSig Config> {
  private module Flow = TaintTracking::Global<Config>;

  private module InlineTaintTest implements TestSig {
    string getARelevantTag() { result = "tainted" }

    predicate hasActualResult(Location location, string element, string tag, string value) {
      exists(location.getFile().getRelativePath()) and
      exists(DataFlow::Node sink |
        Flow::flowTo(sink) and
        location = sink.getLocation() and
        element = prettyExpr(sink.asExpr()) and
        value = "" and
        tag = "tainted"
      )
    }
  }

  import MakeTest<InlineTaintTest>

  query predicate argumentToEnsureNotTaintedNotMarkedAsSpurious(
    Location location, string error, string element
  ) {
    error = "ERROR, you should add `SPURIOUS:` to this annotation" and
    location = shouldNotBeTainted().getLocation() and
    InlineTaintTest::hasActualResult(location, element, "tainted", _) and
    exists(GoodTestExpectation good, ActualTestResult actualResult |
      good.matchesActualResult(actualResult) and
      actualResult.getLocation() = location and
      actualResult.toString() = element
    )
  }

  query predicate untaintedArgumentToEnsureTaintedNotMarkedAsMissing(
    Location location, string error, string element
  ) {
    error = "ERROR, you should add `# $ MISSING: tainted` annotation" and
    exists(DataFlow::Node sink |
      sink = shouldBeTainted() and
      element = prettyExpr(sink.asExpr()) and
      not Flow::flowTo(sink) and
      location = sink.getLocation() and
      not exists(FalseNegativeTestExpectation missingResult |
        missingResult.getTag() = "tainted" and
        missingResult.getLocation().getFile() = location.getFile() and
        missingResult.getLocation().getStartLine() = location.getStartLine()
      )
    )
  }
}
