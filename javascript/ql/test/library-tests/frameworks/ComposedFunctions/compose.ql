import javascript

class ExampleConfiguration extends TaintTracking::Configuration {
  ExampleConfiguration() { this = "ExampleConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().(CallExpr).getCalleeName() = "SOURCE"
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(CallExpr callExpr |
      callExpr.getCalleeName() = "SINK" and
      DataFlow::valueNode(callExpr.getArgument(0)) = sink
    )
  }
}

from ExampleConfiguration cfg, DataFlow::Node source, DataFlow::Node sink
where cfg.hasFlow(source, sink)
select sink
