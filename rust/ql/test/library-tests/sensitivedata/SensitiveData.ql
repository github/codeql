import rust
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.TaintTracking
import codeql.rust.security.SensitiveData
import utils.test.InlineExpectationsTest

/**
 * Configuration for flow from any sensitive data source to an argument of the function `sink`.
 */
module SensitiveDataConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof SensitiveData }

  predicate isSink(DataFlow::Node sink) {
    any(CallExpr call | call.getFunction().(PathExpr).getResolvedPath() = "crate::test::sink")
        .getArgList()
        .getAnArg() = sink.asExpr().getExpr()
  }
}

module SensitiveDataFlow = TaintTracking::Global<SensitiveDataConfig>;

module SensitiveDataTest implements TestSig {
  string getARelevantTag() { result = "sensitive" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node source, DataFlow::Node sink |
      SensitiveDataFlow::flow(source, sink) and
      location = sink.getLocation() and
      element = sink.toString() and
      tag = "sensitive" and
      value = source.(SensitiveData).getClassification()
    )
  }
}

import MakeTest<SensitiveDataTest>
