/**
 * @name Reuse of cryptographic nonce
 * @description Reuse of nonce in cryptographic operations can lead to vulnerabilities.
 * @id java/quantum/examples/reused-nonce
 * @kind path-problem
 * @problem.severity error
 * @tags quantum
 *       experimental
 */

import java
import ArtifactReuse

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
  Crypto::NonceArtifactNode nonce1, Crypto::NonceArtifactNode nonce2, Crypto::NodeBase src,
  NonceSrcFlow::PathNode srcNode, NonceSrcFlow::PathNode sinkNode
where
  isArtifactReuse(nonce1, nonce2) and
  // NOTE: in general we may not know a source, but see possible reuse,
  // we are not detecting these cases here (only where the source is the same).
  src = nonce1.getSourceNode() and
  src = nonce2.getSourceNode() and
  // Null literals are typically used for initialization, and if two 'nulls'
  // are reused, it is likely an uninitialization path that would result in a NullPointerException.
  not src.asElement() instanceof NullLiteral and
  // if the nonce is used in an encryption and decryption, ignore that reuse
  not exists(Crypto::CipherOperationNode op1, Crypto::CipherOperationNode op2 |
    op1 != op2 and
    op1.getANonce() = nonce1 and
    op2.getANonce() = nonce2 and
    (
      (
        op1.getKeyOperationSubtype() instanceof Crypto::TEncryptMode or
        op1.getKeyOperationSubtype() instanceof Crypto::TWrapMode
      ) and
      (
        op2.getKeyOperationSubtype() instanceof Crypto::TDecryptMode or
        op2.getKeyOperationSubtype() instanceof Crypto::TUnwrapMode
      )
      or
      (
        op2.getKeyOperationSubtype() instanceof Crypto::TEncryptMode or
        op2.getKeyOperationSubtype() instanceof Crypto::TWrapMode
      ) and
      (
        op1.getKeyOperationSubtype() instanceof Crypto::TDecryptMode or
        op1.getKeyOperationSubtype() instanceof Crypto::TUnwrapMode
      )
    )
  ) and
  srcNode.getNode().asExpr() = src.asElement() and
  sinkNode.getNode().asExpr() = nonce1.asElement() and
  NonceSrcFlow::flowPath(srcNode, sinkNode)
select sinkNode, srcNode, sinkNode, "Nonce source is reused, see alternate sink $@", nonce2,
  nonce2.toString()
