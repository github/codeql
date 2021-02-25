import javascript
private import semmle.javascript.dataflow.internal.StepSummary

class Config extends DataFlow::Configuration {
  Config() { this = "Config" }

  override predicate isSource(DataFlow::Node source) {
    source.(DataFlow::CallNode).getCalleeName() = "source"
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(DataFlow::CallNode call | call.getCalleeName() = "sink" | call.getAnArgument() = sink)
  }
}

query predicate dataFlow(DataFlow::Node pred, DataFlow::Node succ) {
  any(Config c).hasFlow(pred, succ)
}
