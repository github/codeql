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

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    exists(Base64::Encode encode | node1 = encode.getInput() and node2 = encode.getOutput())
    or
    node2.(StringOps::ConcatenationRoot).getALeaf() = node1 and
    not exists(node1.(StringOps::ConcatenationLeaf).getStringValue()) // to avoid e.g. the ":" in `user + ":" + pass` being flagged as a constant credential.
    or
    exists(DataFlow::MethodCallNode bufferFrom |
      bufferFrom = DataFlow::globalVarRef("Buffer").getAMethodCall("from") and
      node2 = bufferFrom and
      node1 = bufferFrom.getArgument(0)
    )
    or
    exists(API::Node n |
      n = API::moduleImport("jose").getMember(["importSPKI", "importPKCS8", "importX509"])
    |
      node1 = n.getACall().getArgument(0) and
      node2 = n.getReturn().getPromised().asSource()
    )
    or
    exists(API::Node n |
      n = API::moduleImport("jose").getMember(["importSPKI", "importPKCS8", "importX509"])
    |
      node1 = n.getACall().getArgument(0) and
      node2 = n.getReturn().getPromised().asSource()
    )
    or
    exists(API::Node n | n = API::moduleImport("jose").getMember("importJWK") |
      node1 = n.getParameter(0).getMember(["x", "y", "n"]).asSink() and
      node2 = n.getReturn().getPromised().asSource()
    )
    or
    exists(DataFlow::CallNode n |
      n = DataFlow::globalVarRef("TextEncoder").getAnInstantiation().getAMemberCall("encode")
    |
      node1 = n.getArgument(0) and
      node2 = n
    )
    or
    exists(DataFlow::CallNode n | n = DataFlow::globalVarRef("Buffer").getAMemberCall("from") |
      node1 = n.getArgument(0) and
      node2 = [n, n.getAChainedMethodCall(["toString", "toJSON"])]
    )
    or
    exists(API::Node n |
      n = API::moduleImport("jose").getMember("base64url").getMember(["decode", "encode"])
    |
      node1 = n.getACall().getArgument(0) and
      node2 = n.getACall()
    )
  }

  predicate observeDiffInformedIncrementalMode() { any() }
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
