/**
 * @name Weak Asymmetric Key Size
 * @id java/quantum/examples/weak-asymmetric-key-gen-size
 * @description An asymmetric key of known size is less than 2048 bits for any non-elliptic curve key operation.
 * @kind path-problem
 * @problem.severity error
 * @tags quantum
 *       experimental
 */

import java
import experimental.quantum.Language

module KeySizeFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source = any(Crypto::GenericSourceInstance i).getOutputNode() or
    source = any(Crypto::ArtifactInstance artifact).getOutputNode()
  }

  predicate isSink(DataFlow::Node sink) {
    exists(Crypto::KeyCreationOperationNode kgen |
      sink = kgen.getKeySizeConsumer().getConsumer().getInputNode()
    )
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

module KeySizeFlow = TaintTracking::Global<KeySizeFlowConfig>;

import KeySizeFlow::PathGraph

from
  Crypto::KeyCreationOperationNode keygen, int keySize, Crypto::AlgorithmNode alg,
  KeySizeFlow::PathNode srcNode, KeySizeFlow::PathNode sinkNode
where
  // ASSUMPTION/NOTE: if the key size is set on a key creation, but the key creation itself is not observed
  // (i.e., the size is initialized but the operation not observed) currently we will not
  // detect the size. A key creation operation currently must be observed.
  keygen.getAKeySizeSource().asElement().(Literal).getValue().toInt() = keySize and
  // NOTE: if algorithm is not known (doesn't bind) we need a separate query
  // Also note the algorithm may also be re-specified at a use of the key
  alg = keygen.getAKnownAlgorithm() and
  not alg instanceof Crypto::EllipticCurveNode and // Elliptic curve sizes are handled separately and are more tied directly to the algorithm
  not alg.(Crypto::KeyAgreementAlgorithmNode).getKeyAgreementType() = Crypto::ECDH() and // ECDH key sizes should be handled with elliptic curves
  alg instanceof Crypto::AsymmetricAlgorithmNode and
  keySize < 2048 and
  srcNode.getNode().asExpr() = keygen.getAKeySizeSource().asElement() and
  sinkNode.getNode() = keygen.getKeySizeConsumer().getConsumer().getInputNode() and
  KeySizeFlow::flowPath(srcNode, sinkNode)
select sinkNode, srcNode, sinkNode,
  "Use of weak asymmetric key size (" + keySize.toString() + " bits) for algorithm $@", alg,
  alg.getAlgorithmName()
