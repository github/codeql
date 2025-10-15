/**
 * @name Bad MAC order: MAC on an encrypt plaintext
 * @description MAC should be on a cipher, not a raw message
 * @id java/quantum/bad-mac-order-encrypt-plaintext-also-in-mac
 * @kind problem
 * @problem.severity error
 * @tags quantum
 *       experimental
 */

import java
import experimental.quantum.Language

// NOTE: I must look for a common data flow node rather than
// starting from a message source, since the message source
// might not be known.
// TODO: can we approximate a message source better?
module CommonDataFlowNodeConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { exists(source.asParameter()) }

  predicate isSink(DataFlow::Node sink) {
    sink = any(Crypto::FlowAwareElement other).getInputNode()
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

module CommonDataFlowNodeFlow = DataFlow::Global<CommonDataFlowNodeConfig>;

from DataFlow::Node src, DataFlow::Node sink1, DataFlow::Node sink2
where
  CommonDataFlowNodeFlow::flow(src, sink1) and
  CommonDataFlowNodeFlow::flow(src, sink2) and
  exists(Crypto::CipherOperationNode cipherOp |
    cipherOp.getKeyOperationSubtype() = Crypto::TEncryptMode() and
    cipherOp.getAnInputArtifact().asElement() = sink1.asExpr()
  ) and
  exists(Crypto::MacOperationNode macOp | macOp.getAnInputArtifact().asElement() = sink2.asExpr())
select src, "Message used for encryption operation at $@, also used for MAC at $@.", sink1,
  sink1.toString(), sink2, sink2.toString()
