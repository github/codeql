import rust
import codeql.rust.dataflow.DataFlow
import codeql.rust.Concepts
import utils.test.InlineFlowTest

/**
 * Configuration for flow from any threat model source to an argument of the function `sink`.
 */
module MyFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ThreatModelSource }

  predicate isSink(DataFlow::Node sink) {
    any(CallExpr call | call.getFunction().(PathExpr).getResolvedPath() = "crate::test::sink")
        .getArgList()
        .getAnArg() = sink.asExpr().getExpr()
  }

  predicate allowImplicitRead(DataFlow::Node node, DataFlow::ContentSet c) {
    // flow out from any content at the sink.
    isSink(node) and
    exists(c)
  }
}

module MyFlowTest = TaintFlowTest<MyFlowConfig>;

import MyFlowTest
