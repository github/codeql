/**
 * Provides a data flow configuration for reasoning about hardcoded
 * credentials.
 * Note, for performance reasons: only import this file if
 * `HardcodedCredentials::Configuration` is needed, otherwise
 * `HardcodedCredentialsCustomizations` should be imported instead.
 */

import javascript
import HardcodedCredentialsCustomizations::HardcodedCredentials

/**
 * A data flow tracking configuration for hardcoded credentials.
 */
module HardcodedCredentialsConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof Source }

  predicate isSink(DataFlow::Node node) { node instanceof Sink }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate isAdditionalFlowStep(DataFlow::Node src, DataFlow::Node trg) {
    exists(Base64::Encode encode | src = encode.getInput() and trg = encode.getOutput())
    or
    trg.(StringOps::ConcatenationRoot).getALeaf() = src and
    not exists(src.(StringOps::ConcatenationLeaf).getStringValue()) // to avoid e.g. the ":" in `user + ":" + pass` being flagged as a constant credential.
    or
    exists(DataFlow::MethodCallNode bufferFrom |
      bufferFrom = DataFlow::globalVarRef("Buffer").getAMethodCall("from") and
      trg = bufferFrom and
      src = bufferFrom.getArgument(0)
    )
  }
}

/**
 * Data flow for reasoning about hardcoded credentials.
 */
module HardcodedCredentials = DataFlow::Global<HardcodedCredentialsConfig>;

/**
 * DEPRECATED. Use the `HardcodedCredentials` module instead.
 */
deprecated class Configuration extends DataFlow::Configuration {
  Configuration() { this = "HardcodedCredentials" }

  override predicate isSource(DataFlow::Node source) {
    HardcodedCredentialsConfig::isSource(source)
  }

  override predicate isSink(DataFlow::Node sink) { HardcodedCredentialsConfig::isSink(sink) }

  override predicate isBarrier(DataFlow::Node node) {
    super.isBarrier(node) or
    HardcodedCredentialsConfig::isBarrier(node)
  }

  override predicate isAdditionalFlowStep(DataFlow::Node src, DataFlow::Node trg) {
    HardcodedCredentialsConfig::isAdditionalFlowStep(src, trg)
  }
}
