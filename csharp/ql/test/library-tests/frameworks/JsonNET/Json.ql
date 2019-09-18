import csharp
import semmle.code.csharp.dataflow.TaintTracking

class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "Json.NET test" }

  override predicate isSource(DataFlow::Node src) {
    src.asExpr().(StringLiteral).getValue() = "tainted"
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodCall c | c.getArgument(0) = sink.asExpr() and c.getTarget().getName() = "Sink")
  }
}

from Configuration c, DataFlow::Node source, DataFlow::Node sink
where c.hasFlow(source, sink)
select source, sink
