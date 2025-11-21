import java
import experimental.quantum.Language
import codeql.util.Option

/**
 * Holds when the src node is the output artifact of a decrypt operation
 * that flows to the input artifact of a mac operation.
 */
predicate isDecryptToMacFlow(ArtifactFlow::PathNode src, ArtifactFlow::PathNode sink) {
  // Simply flow from decrypt output to a mac input
  ArtifactFlow::flowPath(src, sink) and
  exists(Crypto::CipherOperationNode cipherOp |
    cipherOp.getKeyOperationSubtype() = Crypto::TDecryptMode() and
    cipherOp.getAnOutputArtifact().asElement() = src.getNode().asExpr()
  ) and
  exists(Crypto::MacOperationNode macOp |
    macOp.getAnInputArtifact().asElement() = sink.getNode().asExpr()
  )
}

/**
 * Experimental interface for graph generation, supply the
 * node to determine if a issue exists, and if so
 * the graph can add a property on the node.
 */
predicate isDecryptToMacNode(Crypto::ArtifactNode node) {
  exists(ArtifactFlow::PathNode src |
    isDecryptToMacFlow(src, _) and
    node.asElement() = src.getNode().asExpr()
  )
}

predicate isDecryptThenMacFlow(DecryptThenMacFlow::PathNode src, DecryptThenMacFlow::PathNode sink) {
  DecryptThenMacFlow::flowPath(src, sink)
}

/**
 * Holds when the src node is used as plaintext input to both
 * an encryption operation and a mac operation, via the
 * argument represented by InterimArg.
 */
predicate isPlaintextInEncryptionAndMac(
  PlaintextUseAsMacAndCipherInputFlow::PathNode src,
  PlaintextUseAsMacAndCipherInputFlow::PathNode sink, EncryptOrMacCallArg arg
) {
  PlaintextUseAsMacAndCipherInputFlow::flowPath(src, sink) and
  arg = sink.getState().asSome() and
  // the above pathing adds flow steps that may not have consideration for the calling context
  // TODO: this is something we want to look into to improving, but for now
  // we can filter bad flows with one additional flow check, that the source goes to both
  // src and sink through a generic flow
  // note that the flow path above ensures src gets to the interim arg, so we just need to
  // verify the source to sink.
  // TODO: having to copy the generic data flow config into a use-use variant
  // should we fix this at the language level to allow use use more intuitively?
  // Seems to be a common issue.
  GenericDataSourceFlowUseUseFlow::flow(src.getNode(), sink.getNode())
}

/**
 * A copy of GenericDataSourceFlow but with use-use flows enabled by removing the barrier out
 */
module GenericDataSourceFlowUseUseConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source = any(Crypto::GenericSourceInstance i).getOutputNode()
  }

  predicate isSink(DataFlow::Node sink) {
    sink = any(Crypto::FlowAwareElement other).getInputNode()
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

module GenericDataSourceFlowUseUseFlow = TaintTracking::Global<GenericDataSourceFlowUseUseConfig>;

module WrapperArgFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    // Start from a parameter and not a call to avoid flow going out of
    // the call. We want to flow down a call, so start from a parameter
    // and barrier flows through returns
    exists(Method m | m.getParameter(_) = source.asParameter())
  }

  predicate isSink(DataFlow::Node sink) {
    exists(Crypto::CipherOperationNode cipherOp |
      cipherOp.getAnInputArtifact().asElement() = sink.asExpr()
    )
    or
    exists(Crypto::MacOperationNode macOp | macOp.getAnInputArtifact().asElement() = sink.asExpr())
  }

  predicate isBarrierIn(DataFlow::Node node) {
    node = any(Crypto::FlowAwareElement element).getOutputNode()
  }

  predicate isBarrierOut(DataFlow::Node node) {
    // stop all flow out of a call return
    // TODO: this might be too strict and remove taint flow, need to reassess
    node.asExpr() instanceof Call or
    node = any(Crypto::FlowAwareElement element).getInputNode()
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

module WrapperArgFlow = TaintTracking::Global<WrapperArgFlowConfig>;

predicate encryptWrapperArg(DataFlow::Node n, DataFlow::Node sink) {
  exists(Crypto::CipherOperationNode cipherOp |
    cipherOp.getKeyOperationSubtype() = Crypto::TEncryptMode() and
    cipherOp.getAnInputArtifact().asElement() = sink.asExpr()
  ) and
  (
    exists(Parameter p, DataFlow::Node src |
      p = src.asParameter() and
      WrapperArgFlow::flow(src, sink) and
      n.asExpr() = p.getAnArgument()
    )
    or
    n = sink // the call the target operation is considered a wrapper arg to itself
  )
}

predicate decryptWrapperArg(DataFlow::Node n, DataFlow::Node sink) {
  exists(Crypto::CipherOperationNode cipherOp |
    cipherOp.getKeyOperationSubtype() = Crypto::TDecryptMode() and
    cipherOp.getAnInputArtifact().asElement() = sink.asExpr()
  ) and
  (
    exists(Parameter p, DataFlow::Node src |
      p = src.asParameter() and
      WrapperArgFlow::flow(src, sink) and
      n.asExpr() = p.getAnArgument()
    )
    or
    n = sink // the call the target operation is considered a wrapper arg to itself
  )
}

predicate macWrapperArg(DataFlow::Node n, DataFlow::Node sink) {
  exists(Crypto::MacOperationNode macOp | macOp.getAnInputArtifact().asElement() = sink.asExpr()) and
  (
    exists(Parameter p, DataFlow::Node src |
      p = src.asParameter() and
      WrapperArgFlow::flow(src, sink) and
      n.asExpr() = p.getAnArgument()
    )
    or
    n = sink // the call the target operation is considered a wrapper arg to itself
  )
}

module ArgToEncryptOrMacConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { exists(Call c | c.getAnArgument() = source.asExpr()) }

  predicate isSink(DataFlow::Node sink) { encryptOrMacSink(sink) }

  // Don't go in to a known out node, this will prevent the plaintext
  // from tracing out of cipher operations for example, we just want to trace
  // the plaintext to uses.
  // NOTE: we are not using a barrier out on input nodes, because
  // that would remove 'use-use' flows, which we need
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

module ArgToEncryptOrMacFlow = TaintTracking::Global<ArgToEncryptOrMacConfig>;

/**
 * Target sinks for this query are either encryption operations or mac operation message inputs
 */
predicate encryptOrMacSink(DataFlow::Node n) {
  exists(Crypto::CipherOperationNode cipherOp |
    cipherOp.getKeyOperationSubtype() = Crypto::TEncryptMode() and
    cipherOp.getAnInputArtifact().asElement() = n.asExpr()
  )
  or
  exists(Crypto::MacOperationNode macOp | macOp.getAnInputArtifact().asElement() = n.asExpr())
}

/**
 * Target sinks for decryption operations
 */
predicate decryptSink(DataFlow::Node n) {
  exists(Crypto::CipherOperationNode cipherOp |
    cipherOp.getKeyOperationSubtype() = Crypto::TDecryptMode() and
    cipherOp.getAnInputArtifact().asElement() = n.asExpr()
  )
}

class EncryptOrMacCallArg extends DataFlow::Node {
  boolean isEncryption;

  EncryptOrMacCallArg() {
    exists(Crypto::CipherOperationNode cipherOp |
      cipherOp.getKeyOperationSubtype() = Crypto::TEncryptMode() and
      cipherOp.getAnInputArtifact().asElement() = this.asExpr()
    ) and
    isEncryption = true
    or
    exists(Crypto::MacOperationNode macOp | macOp.getAnInputArtifact().asElement() = this.asExpr()) and
    isEncryption = false
  }

  predicate isEncryption() { isEncryption = true }

  predicate isMac() { isEncryption = false }
}

module PlaintextUseAsMacAndCipherInputConfig implements DataFlow::StateConfigSig {
  class FlowState = Option<EncryptOrMacCallArg>::Option;

  // TODO: can we approximate a message source better?
  predicate isSource(DataFlow::Node source, FlowState state) {
    // TODO: can we find the 'closest' parameter to the sinks?
    // i.e., use a generic source if we have it, but also isolate the
    // lowest level in the flow to the closest parameter node in the call graph?
    exists(Crypto::GenericSourceNode other |
      other.asElement() = CryptoInput::dfn_to_element(source)
    ) and
    state.isNone()
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    sink.(EncryptOrMacCallArg).isMac() and state.asSome().isEncryption()
    or
    sink.(EncryptOrMacCallArg).isEncryption() and state.asSome().isMac()
  }

  predicate isBarrierOut(DataFlow::Node node, FlowState state) {
    // Stop at the first sink for now
    isSink(node, state)
  }

  // Don't go in to a known out node, this will prevent the plaintext
  // from tracing out of cipher operations for example, we just want to trace
  // the plaintext to uses.
  // NOTE: we are not using a barrier out on input nodes, because
  // that would remove 'use-use' flows, which we need
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

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    // TODO: should we consider isSome cases?
    state1.isNone() and
    (
      encryptWrapperArg(node2, node1)
      or
      macWrapperArg(node2, node1)
    ) and
    state2.asSome() = node1
  }
}

module PlaintextUseAsMacAndCipherInputFlow =
  TaintTracking::GlobalWithState<PlaintextUseAsMacAndCipherInputConfig>;

module DecryptThenMacConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(Crypto::CipherOperationNode cipherOp |
      cipherOp.getKeyOperationSubtype() = Crypto::TDecryptMode() and
      cipherOp.getAnInputArtifact().asElement() = source.asExpr()
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(Crypto::MacOperationNode macOp | macOp.getAnInputArtifact().asElement() = sink.asExpr())
  }

  // Don't go in to a known out node, prevents
  // from tracing out of an operation
  // NOTE: we are not using a barrier out on input nodes, because
  // that would remove 'use-use' flows, which we need
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
    or
    decryptWrapperArg(node2, node1)
  }
}

module DecryptThenMacFlow = TaintTracking::Global<DecryptThenMacConfig>;
