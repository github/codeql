import cpp
import semmle.code.cpp.ir.dataflow.DataFlow

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr().(FunctionCall).getTarget().getName() = "source"
  }

  predicate isSink(DataFlow::Node sink) {
    exists(FunctionCall call |
      call.getTarget().getName() = "sink" and
      sink.asExpr() = call.getAnArgument()
    )
  }
}

module TestFlow = DataFlow::Global<TestConfig>;

from DataFlow::Node sink, DataFlow::Node source
where TestFlow::flow(source, sink)
select sink, source
