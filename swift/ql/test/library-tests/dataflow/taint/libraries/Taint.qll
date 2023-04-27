import swift
import codeql.swift.dataflow.TaintTracking
import codeql.swift.dataflow.DataFlow

module TestConfiguration implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) {
    src.asExpr().(CallExpr).getStaticTarget().getName().matches("source%")
  }

  predicate isSink(DataFlow::Node sink) {
    exists(CallExpr sinkCall |
      sinkCall.getStaticTarget().getName().matches("sink%") and
      sinkCall.getAnArgument().getExpr() = sink.asExpr()
    )
  }
}

module TestFlow = TaintTracking::Global<TestConfiguration>;
