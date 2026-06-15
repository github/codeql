/**
 * @name Weak known key derivation function iteration count
 * @description Detects key derivation operations with a known weak iteration count.
 * @id java/quantum/examples/weak-kdf-iteration-count
 * @kind path-problem
 * @problem.severity error
 * @tags quantum
 *       experimental
 */

import java
import experimental.quantum.Language

module IterationCountConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source = any(Crypto::GenericSourceInstance i).getOutputNode() or
    source = any(Crypto::ArtifactInstance artifact).getOutputNode()
  }

  predicate isSink(DataFlow::Node sink) {
    exists(Crypto::KeyDerivationOperationInstance kdev |
      sink = kdev.getIterationCountConsumer().getConsumer().getInputNode()
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

module IterationCountFlow = TaintTracking::Global<IterationCountConfig>;

import IterationCountFlow::PathGraph

from
  Crypto::KeyDerivationOperationNode op, Literal l, IterationCountFlow::PathNode srcNode,
  IterationCountFlow::PathNode sinkNode
where
  op.getIterationCount().asElement() = l and
  l.getValue().toInt() < 100000 and
  srcNode.getNode().asExpr() = l and
  sinkNode.getNode() = op.getIterationCountConsumer().getConsumer().getInputNode() and
  IterationCountFlow::flowPath(srcNode, sinkNode)
select sinkNode, srcNode, sinkNode,
  "Key derivation operation configures iteration count below 100k: $@", l, l.getValue().toString()
