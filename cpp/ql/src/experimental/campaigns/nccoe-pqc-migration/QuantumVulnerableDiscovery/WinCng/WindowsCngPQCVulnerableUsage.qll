import cpp
import WindowsCng

/**
 * Steps from input variable (argument 1) to output variable (argument 0)
 * for CNG API BCryptOpenAlgorithmProvider.
 * Argument 1 represents LPCWSTR (a string algorithm ID)
 * Argument 0 represents BCRYPT_ALG_HANDLE
 */
predicate stepOpenAlgorithmProvider(DataFlow::Node node1, DataFlow::Node node2) {
  exists(FunctionCall call |
    // BCryptOpenAlgorithmProvider 2nd argument specifies the algorithm to be used
    node1.asExpr() = call.getArgument(1) and
    call.getTarget().hasGlobalName("BCryptOpenAlgorithmProvider") and
    node2.asDefiningArgument() = call.getArgument(0)
  )
}

/**
 * Steps from input variable (argument 0) to output variable (argument 1)
 * for CNG APIs BCryptImportKeyPair and BCryptGenerateKeyPair.
 * Argument 0 represents a BCRYPT_ALG_HANDLE.
 * Argument 1 represents a BCRYPT_KEY_HANDLE.
 */
predicate stepImportGenerateKeyPair(DataFlow::Node node1, DataFlow::Node node2) {
  exists(FunctionCall call |
    node1.asExpr() = call.getArgument(0) and
    exists(string name | call.getTarget().hasGlobalName(name) |
      name = "BCryptImportKeyPair" and node2.asDefiningArgument() = call.getArgument(3)
      or
      name = "BCryptGenerateKeyPair" and node2.asDefiningArgument() = call.getArgument(1)
    )
  )
}

/**
 * Additional DataFlow steps from input variables to output handle variables on CNG apis.
 */
predicate isWindowsCngAdditionalTaintStep(DataFlow::Node node1, DataFlow::Node node2) {
  stepOpenAlgorithmProvider(node1, node2)
  or
  stepImportGenerateKeyPair(node1, node2)
}

/**
 * CNG-specific DataFlow configuration
 */
class BCryptConfiguration extends DataFlow::Configuration {
  BCryptConfiguration() { this = "BCryptConfiguration" }

  /**
   * Uses indirect extensions of BCryptOpenAlgorithmProviderSource
   */
  override predicate isSource(DataFlow::Node source) {
    source instanceof BCryptOpenAlgorithmProviderSource
  }

  /**
   * Uses indirect extensions of BCryptOpenAlgorithmProviderSink
   */
  override predicate isSink(DataFlow::Node sink) { sink instanceof BCryptOpenAlgorithmProviderSink }

  override predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    isWindowsCngAdditionalTaintStep(node1, node2)
  }
}
