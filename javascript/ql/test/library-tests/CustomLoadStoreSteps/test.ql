import javascript

class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "PromiseFlowTestingConfig" }

  override predicate isSource(DataFlow::Node source) {
    source.getEnclosingExpr().getStringValue() = "source"
  }

  override predicate isSink(DataFlow::Node sink) {
    any(DataFlow::InvokeNode call | call.getCalleeName() = "sink").getAnArgument() = sink
  }

  // When the source code states that "foo" is being read, "bar" is additionally being read.
  override predicate isAdditionalLoadStep(DataFlow::Node pred, DataFlow::Node succ, string prop) {
    exists(DataFlow::PropRead read | read = succ |
      read.getBase() = pred and
      read.getPropertyName() = "foo"
    ) and
    prop = "bar"
  }
}

from DataFlow::Node pred, DataFlow::Node succ, Configuration cfg
where cfg.hasFlow(pred, succ)
select pred, succ
