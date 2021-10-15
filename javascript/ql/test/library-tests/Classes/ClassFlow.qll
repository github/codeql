import javascript

class Configuration extends DataFlow::Configuration {
  Configuration() { this = "ClassDataFlowTestingConfig" }

  override predicate isSource(DataFlow::Node source) {
    source.getEnclosingExpr().(StringLiteral).getValue().toLowerCase() = "source"
  }

  override predicate isSink(DataFlow::Node sink) {
    any(DataFlow::CallNode call | call.getCalleeName() = "sink").getAnArgument() = sink
  }
}

query predicate dataflow(DataFlow::Node pred, DataFlow::Node succ) {
  any(Configuration c).hasFlow(pred, succ)
}
