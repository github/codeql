/**
 * @name Insecure nonce/iv (static value or weak random source)
 * @id java/quantum/examples/insecure-iv-or-nonce
 * @description A nonce/iv is generated from a source that is not secure. This can lead to
 *              vulnerabilities such as replay attacks or key recovery. Insecure generation
 *              is any static nonce, or any known insecure source for a nonce/iv if
 *              the value is used for an encryption operation (decryption operations are ignored
 *              as the nonce/iv would be provided alongside the ciphertext).
 * @kind path-problem
 * @problem.severity error
 * @tags quantum
 *       experimental
 */

import experimental.quantum.Language

module NonceSrcFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source = any(Crypto::GenericSourceInstance i).getOutputNode() or
    source = any(Crypto::ArtifactInstance artifact).getOutputNode()
  }

  predicate isSink(DataFlow::Node sink) {
    exists(Crypto::NonceArtifactNode nonce | sink.asExpr() = nonce.asElement())
  }

  predicate isBarrierOut(DataFlow::Node node) {
    node = any(Crypto::FlowAwareElement element).getInputNode()
  }

  predicate isBarrierIn(DataFlow::Node node) {
    node = any(Crypto::FlowAwareElement element).getOutputNode()
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    node1.(AdditionalFlowInputStep).getOutput() = node2
    or
    exists(MethodCall m |
      m.getMethod().hasQualifiedName("java.lang", "String", "getBytes") and
      node1.asExpr() = m.getQualifier() and
      node2.asExpr() = m
    )
  }
}

module NonceSrcFlow = TaintTracking::Global<NonceSrcFlowConfig>;

import NonceSrcFlow::PathGraph

from
  Crypto::NonceArtifactNode nonce, Crypto::NodeBase src, Crypto::NodeBase op, string msg,
  NonceSrcFlow::PathNode srcNode, NonceSrcFlow::PathNode sinkNode
where
  nonce.getSourceNode() = src and
  // NOTE: null nonces should be handled seaparately, often used for default values prior to initialization
  // failure to initialize should, in practice, lead to a NullPointerException, which is a separate concern
  // however there may be APIs where NULL uses a default nonce or action.
  not src.asElement() instanceof NullLiteral and
  (
    // Case 1: Any constant nonce/iv is bad, regardless of how it is used
    src.asElement() instanceof Crypto::GenericConstantSourceInstance and
    op = nonce and // binding op but not using it
    msg = "Nonce or IV uses constant source $@"
    or
    // Case 2: The nonce has a non-random source and there is no known operation for the nonce
    //         assume it is used for encryption
    not src.asElement() instanceof SecureRandomnessInstance and
    not src.asElement() instanceof Crypto::GenericConstantSourceInstance and
    not exists(Crypto::CipherOperationNode o | o.getANonce() = nonce) and
    op = nonce and // binding op, but not using it
    msg =
      "Nonce or IV uses insecure source $@ with no observed nonce usage (assuming could be for encryption)."
    or
    // Case 3: The nonce has a non-random source and is used in an encryption operation
    not src.asElement() instanceof SecureRandomnessInstance and
    not src.asElement() instanceof Crypto::GenericConstantSourceInstance and
    op.(Crypto::CipherOperationNode).getANonce() = nonce and
    (
      op.(Crypto::CipherOperationNode).getKeyOperationSubtype() instanceof Crypto::TEncryptMode
      or
      op.(Crypto::CipherOperationNode).getKeyOperationSubtype() instanceof Crypto::TWrapMode
    ) and
    msg = "Nonce or IV uses insecure source $@ at encryption operation $@"
  ) and
  srcNode.getNode().asExpr() = src.asElement() and
  sinkNode.getNode().asExpr() = nonce.asElement() and
  NonceSrcFlow::flowPath(srcNode, sinkNode)
select sinkNode, srcNode, sinkNode, msg, src, src.toString(), op, op.toString()
