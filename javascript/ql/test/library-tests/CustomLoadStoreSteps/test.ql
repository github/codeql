import javascript

// Note: this test has not been ported to ConfigSig, because isAdditionalLoadStep has no equivalent there
deprecated class Configuration extends TaintTracking::Configuration {
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

  // calling .copy("foo", "bar") actually moves a property from "foo" to "bar".
  override predicate isAdditionalLoadStoreStep(
    DataFlow::Node pred, DataFlow::Node succ, string loadProp, string storeProp
  ) {
    exists(DataFlow::MethodCallNode call |
      call.getMethodName() = "copy" and call = succ and pred = call.getReceiver()
    |
      call.getArgument(0).mayHaveStringValue(loadProp) and
      call.getArgument(1).mayHaveStringValue(storeProp)
    )
  }
}

deprecated query predicate flow(DataFlow::Node source, DataFlow::Node sink) {
  any(Configuration cfg).hasFlow(source, sink)
}
