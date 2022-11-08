import cpp
import WindowsCng

predicate stepOpenAlgorithmProvider(DataFlow::Node node1, DataFlow::Node node2) {
  exists(FunctionCall call |
    // BCryptOpenAlgorithmProvider 2nd argument specifies the algorithm to be used
    node1.asExpr() = call.getArgument(1) and
    call.getTarget().hasGlobalName("BCryptOpenAlgorithmProvider") and
    node2.asDefiningArgument() = call.getArgument(0)
  )
}

predicate stepImportGenerateKeyPair(DataFlow::Node node1, DataFlow::Node node2) {
  exists(FunctionCall call |
    node1.asExpr() = call.getArgument(0) and
    exists(string name |
      name in ["BCryptImportKeyPair", "BCryptGenerateKeyPair"] and
      call.getTarget().hasGlobalName(name)
    ) and
    node2.asDefiningArgument() = call.getArgument(1)
  )
}

predicate isWindowsCngAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
  stepOpenAlgorithmProvider(node1, node2)
  or
  stepImportGenerateKeyPair(node1, node2)
}


// CNG-specific DataFlow configuration
class BCryptConfiguration extends DataFlow::Configuration {
  BCryptConfiguration() { this = "BCryptConfiguration" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof BCryptOpenAlgorithmProviderSource
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof BCryptOpenAlgorithmProviderSink }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    isWindowsCngAdditionalTaintStep(node1, node2)
  }
}
