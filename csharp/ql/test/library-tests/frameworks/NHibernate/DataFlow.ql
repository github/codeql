import csharp
import semmle.code.csharp.dataflow.TaintTracking

class MyConfiguration extends TaintTracking::Configuration {
  MyConfiguration() { this = "MyConfiguration" }

  override predicate isSource(DataFlow::Node node) {
    node.asExpr().(StringLiteral).getValue() = "tainted"
  }

  override predicate isSink(DataFlow::Node node) {
    exists(MethodCall mc | mc.getTarget().hasName("Sink") and node.asExpr() = mc.getArgument(0))
  }
}

from MyConfiguration config, DataFlow::Node source, DataFlow::Node sink
where config.hasFlow(source, sink)
select sink, "Data flow from $@.", source, source.toString()
