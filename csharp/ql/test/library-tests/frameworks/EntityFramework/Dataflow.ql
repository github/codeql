import csharp
import semmle.code.csharp.dataflow.TaintTracking

class MyConfiguration extends TaintTracking::Configuration {
  MyConfiguration() { this = "EntityFramework dataflow" }

  override predicate isSource(DataFlow::Node node) { node.asExpr().getValue() = "tainted" }

  override predicate isSink(DataFlow::Node node) {
    node.asExpr() = any(MethodCall c | c.getTarget().hasName("Sink")).getAnArgument()
  }
}

from MyConfiguration config, DataFlow::Node source, DataFlow::Node sink
where config.hasFlow(source, sink)
select sink, source
