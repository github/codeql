/**
 * @name Weak known key derivation function output length
 * @description Detects key derivation operations with a known weak output length
 * @id java/quantum/examples/weak-kdf-key-size
 * @kind path-problem
 * @problem.severity error
 * @tags quantum
 *       experimental
 */

import java
import experimental.quantum.Language

module KeySizeConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source = any(Crypto::GenericSourceInstance i).getOutputNode() or
    source = any(Crypto::ArtifactInstance artifact).getOutputNode()
  }

  predicate isSink(DataFlow::Node sink) {
    exists(Crypto::KeyDerivationOperationInstance kdev |
      sink = kdev.getKeySizeConsumer().getConsumer().getInputNode()
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

module KeySizeFlow = TaintTracking::Global<KeySizeConfig>;

import KeySizeFlow::PathGraph

from
  Crypto::KeyDerivationOperationNode op, Literal l, KeySizeFlow::PathNode srcNode,
  KeySizeFlow::PathNode sinkNode
where
  op.getOutputKeySize().asElement() = l and
  l.getValue().toInt() < 256 and
  srcNode.getNode().asExpr() = l and
  sinkNode.getNode() = op.getKeySizeConsumer().getConsumer().getInputNode() and
  KeySizeFlow::flowPath(srcNode, sinkNode)
select sinkNode, srcNode, sinkNode,
  "Key derivation operation configures output key length below 256: $@", l, l.getValue().toString()
