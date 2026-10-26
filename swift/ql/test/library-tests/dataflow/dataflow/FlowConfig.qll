/**
 * @kind path-problem
 */

import swift
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.ExternalFlow
import codeql.swift.frameworks.Frameworks

module TestConfiguration implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) {
    src.asExpr().(CallExpr).getStaticTarget().getName().matches("source%")
  }

  predicate isSink(DataFlow::Node sink) {
    exists(CallExpr sinkCall |
      sinkCall.getStaticTarget().getName() = ["sink(arg:)", "sink(opt:)", "sink(str:)"] and
      sinkCall.getAnArgument().getExpr() = sink.asExpr()
    )
  }
}

private class TestSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        // model to allow data flow through `signum()` as though it were an identity function, for the benefit of testing flow through optional chaining (`x?.`).
        ";Int;true;signum();;;Argument[-1];ReturnValue;value",
        // test Tuple content in MAD
        ";;false;tupleShiftLeft2(_:);;;Argument[0].TupleElement[1];ReturnValue.TupleElement[0];value",
        // test Enum content in MAD
        ";;false;mkMyEnum2(_:);;;Argument[0];ReturnValue.EnumElement[mySingle:0];value",
        ";;false;mkOptional2(_:);;;Argument[0];ReturnValue.OptionalSome;value"
      ]
  }
}

module TestFlow = DataFlow::Global<TestConfiguration>;
