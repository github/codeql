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
    or
    exists(API::Node n |
      n = API::moduleImport("jose").getMember(["importSPKI", "importPKCS8", "importX509"])
    |
      src = n.getACall().getArgument(0) and
      trg = n.getReturn().getPromised().asSource()
    )
    or
    exists(API::Node n |
      n = API::moduleImport("jose").getMember(["importSPKI", "importPKCS8", "importX509"])
    |
      src = n.getACall().getArgument(0) and
      trg = n.getReturn().getPromised().asSource()
    )
    or
    exists(API::Node n | n = API::moduleImport("jose").getMember("importJWK") |
      src = n.getParameter(0).getMember(["x", "y", "n"]).asSink() and
      trg = n.getReturn().getPromised().asSource()
    )
    or
    exists(DataFlow::CallNode n |
      n = DataFlow::globalVarRef("TextEncoder").getAnInstantiation().getAMemberCall("encode")
    |
      src = n.getArgument(0) and
      trg = n
    )
    or
    exists(DataFlow::CallNode n | n = DataFlow::globalVarRef("Buffer").getAMemberCall("from") |
      src = n.getArgument(0) and
      trg = [n, n.getAChainedMethodCall(["toString", "toJSON"])]
    )
    or
    exists(API::Node n |
      n = API::moduleImport("jose").getMember("base64url").getMember(["decode", "encode"])
    |
      src = n.getACall().getArgument(0) and
      trg = n.getACall()
    )
  }
}
