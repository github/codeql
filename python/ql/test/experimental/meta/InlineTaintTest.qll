/**
 * Defines a InlineExpectationsTest for checking whether any arguments in
 * `ensure_tainted` and `ensure_not_tainted` calls are tainted.
 * These allow us to monitor the progressive flow of taint through the program.
 * To test whether taint would be observable at a sink, we can use `ensure_tainted_with_reads` and `ensure_not_tainted_with_reads`.
 * Note that this function should only be called at the end of test functions, as it will
 * allow read steps that could otherwise be observed via use/use-flow at later sinks.
 *
 * Also defines query predicates to ensure that:
 * - if any arguments to `ensure_not_tainted`(`_with_reads`) are tainted, their annotation is marked with `SPURIOUS`.
 * - if any arguments to `ensure_tainted`(`_with_reads`) are not tainted, their annotation is marked with `MISSING`.
 * - there is no possible spurious read step from a reading sink to a later sink.
 *
 * The functionality of this module is tested in `ql/test/experimental/meta/inline-taint-test-demo`.
 */

import python
import semmle.python.dataflow.new.DataFlow
import ProgressiveTaintTrackingTest
import semmle.python.dataflow.new.RemoteFlowSources
import TestUtilities.InlineExpectationsTest
private import semmle.python.dataflow.new.internal.PrintNode
private import semmle.python.dataflow.new.internal.TaintTrackingPrivate as RealTaintTracking

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

DataFlow::Node shouldBeTaintedWithReads() {
  exists(DataFlow::CallCfgNode call |
    call.getFunction().asCfgNode().(NameNode).getId() = "ensure_tainted_with_reads" and
    result in [call.getArg(_), call.getArgByName(_)]
  )
}

DataFlow::Node shouldNotBeTaintedWithReads() {
  exists(DataFlow::CallCfgNode call |
    call.getFunction().asCfgNode().(NameNode).getId() = "ensure_not_tainted_with_reads" and
    result in [call.getArg(_), call.getArgByName(_)]
  )
}

DataFlow::Node nonReadingSink() { result in [shouldBeTainted(), shouldNotBeTainted()] }

DataFlow::Node readingSink() {
  result in [shouldBeTaintedWithReads(), shouldNotBeTaintedWithReads()]
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
      source instanceof RemoteFlowSource
    }

    predicate isSink(DataFlow::Node sink) { sink in [nonReadingSink(), readingSink()] }

    // This should emulate the implicit reads that happen during
    // normal non-testing taint tracking; except that for sinks,
    // we only want implicit reads for the ones we explicitly marked
    // (with `ensure_tainted_with_reads` or `ensure_not_tainted_with_reads`).
    //
    // See `shared/dataflow/codeql/dataflow/TaintTracking.qll` and
    // `AddTaintDefaults::allowImplicitRead`
    predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c) {
      (
        node = readingSink()
        // or
        // TODO: This is what we need to add to the real configurations
        // any(TaintTracking::AdditionalTaintStep a).hasStep(node, _, _)
      ) and
      // For our testing taint tracking, `defaultImplicitTaintRead` is `none`
      RealTaintTracking::defaultImplicitTaintRead(node, c)
    }

    predicate test(DataFlow::Node node) {
      allowImplicitRead(node, _) and
      exists(node.getLocation().getFile().getRelativePath())
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

  query predicate argumentToEnsureNotTaintedWithReadsNotMarkedAsSpurious(
    Location location, string error, string element
  ) {
    error = "ERROR, you should add `SPURIOUS:` to this annotation" and
    location = shouldNotBeTaintedWithReads().getLocation() and
    InlineTaintTest::hasActualResult(location, element, "tainted", _) and
    exists(GoodTestExpectation good, ActualTestResult actualResult |
      good.matchesActualResult(actualResult) and
      actualResult.getLocation() = location and
      actualResult.toString() = element
    )
  }

  query predicate untaintedArgumentToEnsureTaintedWithReadsNotMarkedAsMissing(
    Location location, string error, string element
  ) {
    error = "ERROR, you should add `# $ MISSING: tainted` annotation" and
    exists(DataFlow::Node sink |
      sink = shouldBeTaintedWithReads() and
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

  query predicate spuriousReadStepsPossible(DataFlow::Node readSink, DataFlow::Node sink) {
    readSink = readingSink() and
    sink in [readingSink(), nonReadingSink()] and
    readSink != sink and
    TaintTracking::localTaint(readSink, sink)
  }
}
