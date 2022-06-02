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
class Configuration extends DataFlow::Configuration {
  Configuration() { this = "HardcodedCredentials" }

  override predicate isSource(DataFlow::Node source) { source instanceof Source }

  override predicate isSink(DataFlow::Node sink) { sink instanceof Sink }

  override predicate isBarrier(DataFlow::Node node) {
    super.isBarrier(node) or
    node instanceof Sanitizer
  }

  override predicate isAdditionalFlowStep(DataFlow::Node src, DataFlow::Node trg) {
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
