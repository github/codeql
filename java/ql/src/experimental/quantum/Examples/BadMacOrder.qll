import java
import experimental.quantum.Language
import codeql.util.Option

/**
 * Holds when the src node is the output artifact of a decrypt operation
 * that flows to the input artifact of a mac operation.
 */
predicate isDecryptToMacFlow(ArtifactFlow::PathNode src, ArtifactFlow::PathNode sink) {
  ArtifactFlow::flowPath(src, sink) and
  exists(Crypto::CipherOperationNode cipherOp |
    cipherOp.getKeyOperationSubtype() = Crypto::TDecryptMode() and
    cipherOp.getAnOutputArtifact().asElement() = src.getNode().asExpr()
  ) and
  exists(Crypto::MacOperationNode macOp |
    macOp.getAnInputArtifact().asElement() = sink.getNode().asExpr()
  )
}

predicate isDecryptToMacNode(Crypto::ArtifactNode node) {
  exists(ArtifactFlow::PathNode src, ArtifactFlow::PathNode sink |
    isDecryptToMacFlow(src, sink) and
    node.asElement() = src.getNode().asExpr()
  )
}

/**
 * Holds when the src node is used as plaintext input to both
 * an encryption operation and a mac operation, via the
 * argument represented by InterimArg.
 */
predicate isPlaintextInEncryptionAndMac(
  PlaintextUseAsMacAndCipherInputFlow::PathNode src,
  PlaintextUseAsMacAndCipherInputFlow::PathNode sink, InterimArg arg
) {
  PlaintextUseAsMacAndCipherInputFlow::flowPath(src, sink) and
  arg = sink.getState().asSome()
}

module ArgToSinkConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { exists(Call c | c.getAnArgument() = source.asExpr()) }

  predicate isSink(DataFlow::Node sink) { targetSinks(sink) }

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

module ArgToSinkFlow = TaintTracking::Global<ArgToSinkConfig>;

/**
 * Target sinks for this query are either encryption operations or mac operation message inputs
 */
predicate targetSinks(DataFlow::Node n) {
  exists(Crypto::CipherOperationNode cipherOp |
    cipherOp.getKeyOperationSubtype() = Crypto::TEncryptMode() and
    cipherOp.getAnInputArtifact().asElement() = n.asExpr()
  )
  or
  exists(Crypto::MacOperationNode macOp | macOp.getAnInputArtifact().asElement() = n.asExpr())
}

/**
 * An argument of a target sink or a parent call whose parameter flows to a target sink
 */
class InterimArg extends DataFlow::Node {
  DataFlow::Node targetSink;

  InterimArg() {
    targetSinks(targetSink) and
    (
      this = targetSink
      or
      ArgToSinkFlow::flow(this, targetSink) and
      this.getEnclosingCallable().calls+(targetSink.getEnclosingCallable())
    )
  }

  DataFlow::Node getTargetSink() { result = targetSink }
}

/**
 * A wrapper class to represent a target argument dataflow node.
 */
class TargetArg extends DataFlow::Node {
  TargetArg() { targetSinks(this) }

  predicate isCipher() {
    exists(Crypto::CipherOperationNode cipherOp |
      cipherOp.getKeyOperationSubtype() = Crypto::TEncryptMode() and
      cipherOp.getAnInputArtifact().asElement() = this.asExpr()
    )
  }

  predicate isMac() {
    exists(Crypto::MacOperationNode macOp | macOp.getAnInputArtifact().asElement() = this.asExpr())
  }
}

module PlaintextUseAsMacAndCipherInputConfig implements DataFlow::StateConfigSig {
  class FlowState = Option<TargetArg>::Option;

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
    sink instanceof TargetArg and
    (
      sink.(TargetArg).isMac() and state.asSome().isCipher()
      or
      sink.(TargetArg).isCipher() and state.asSome().isMac()
    )
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
    (exists(state1.asSome()) or state1.isNone()) and
    targetSinks(node1) and
    node1 instanceof TargetArg and
    //use-use flow, either flow directly from the node1 use
    //or find a parent call in the call in the call stack
    //and continue flow from that parameter
    node2.(InterimArg).getTargetSink() = node1 and
    state2.asSome() = node1
  }
}

module PlaintextUseAsMacAndCipherInputFlow =
  TaintTracking::GlobalWithState<PlaintextUseAsMacAndCipherInputConfig>;
