private import python
private import semmle.python.dataflow.new.DataFlow
import TlsLibraryModel

/**
 * Configuration to determine the state of a context being used to create
 * a connection. The configuration uses a flow state to track the `TlsLibrary`
 * and the insecure `ProtocolVersion`s that are allowed.
 *
 * The state is in terms of whether a specific protocol is allowed. This is
 * either true or false when the context is created and can then be modified
 * later by either restricting or unrestricting the protocol (see the predicate
 * `isAdditionalFlowStep`).
 *
 * The state is represented as a bit vector, where each bit corresponds to a
 * protocol version. The bit is set if the protocol is allowed.
 */
module InsecureContextConfiguration implements DataFlow::StateConfigSig {
  private newtype TFlowState =
    TMkFlowState(TlsLibrary library, int bits) {
      bits in [0 .. max(any(ProtocolVersion v).getBit()) * 2 - 1]
    }

  class FlowState extends TFlowState {
    int getBits() { this = TMkFlowState(_, result) }

    TlsLibrary getLibrary() { this = TMkFlowState(result, _) }

    predicate allowsInsecureVersion(ProtocolVersion v) {
      v.isInsecure() and this.getBits().bitAnd(v.getBit()) != 0
    }

    string toString() {
      result =
        "FlowState(" + this.getLibrary().toString() + ", " +
          concat(ProtocolVersion v | this.allowsInsecureVersion(v) | v, ", ") + ")"
    }
  }

  private predicate relevantState(FlowState state) {
    isSource(_, state)
    or
    exists(FlowState state0 | relevantState(state0) |
      exists(ProtocolRestriction r |
        r = state0.getLibrary().protocol_restriction() and
        state.getBits() = state0.getBits().bitAnd(sum(r.getRestriction().getBit()).bitNot()) and
        state0.getLibrary() = state.getLibrary()
      )
      or
      exists(ProtocolUnrestriction pu |
        pu = state0.getLibrary().protocol_unrestriction() and
        state.getBits() = state0.getBits().bitOr(sum(pu.getUnrestriction().getBit())) and
        state0.getLibrary() = state.getLibrary()
      )
    )
  }

  predicate isSource(DataFlow::Node source, FlowState state) {
    exists(ContextCreation creation | source = creation |
      creation = state.getLibrary().unspecific_context_creation() and
      state.getBits() =
        sum(ProtocolVersion version |
          version = creation.getProtocol() and version.isInsecure()
        |
          version.getBit()
        )
    )
  }

  predicate isSink(DataFlow::Node sink, FlowState state) {
    sink = state.getLibrary().connection_creation().getContext() and
    state.allowsInsecureVersion(_)
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    DataFlow::localFlowStep(node1, node2) and
    relevantState(state1) and
    (
      exists(ProtocolRestriction r |
        r = state1.getLibrary().protocol_restriction() and
        node2 = r.getContext() and
        state2.getBits() = state1.getBits().bitAnd(sum(r.getRestriction().getBit()).bitNot()) and
        state1.getLibrary() = state2.getLibrary()
      )
      or
      exists(ProtocolUnrestriction pu |
        pu = state1.getLibrary().protocol_unrestriction() and
        node2 = pu.getContext() and
        state2.getBits() = state1.getBits().bitOr(sum(pu.getUnrestriction().getBit())) and
        state1.getLibrary() = state2.getLibrary()
      )
    )
  }

  predicate isBarrier(DataFlow::Node node, FlowState state) {
    relevantState(state) and
    (
      exists(ProtocolRestriction r |
        r = state.getLibrary().protocol_restriction() and
        node = r.getContext() and
        state.allowsInsecureVersion(r.getRestriction())
      )
      or
      exists(ProtocolUnrestriction pu |
        pu = state.getLibrary().protocol_unrestriction() and
        node = pu.getContext() and
        not state.allowsInsecureVersion(pu.getUnrestriction())
      )
    )
  }
}

private module InsecureContextFlow = DataFlow::GlobalWithState<InsecureContextConfiguration>;

/**
 * Holds if `conectionCreation` marks the creation of a connection based on the contex
 * found at `contextOrigin` and allowing `insecure_version`.
 *
 * `specific` is true iff the context is configured for a specific protocol version (`ssl.PROTOCOL_TLSv1_2`) rather
 * than for a family of protocols (`ssl.PROTOCOL_TLS`).
 */
predicate unsafe_connection_creation_with_context(
  DataFlow::Node connectionCreation, ProtocolVersion insecure_version, DataFlow::Node contextOrigin,
  boolean specific
) {
  // Connection created from a context allowing `insecure_version`.
  exists(InsecureContextFlow::PathNode src, InsecureContextFlow::PathNode sink |
    InsecureContextFlow::flowPath(src, sink) and
    src.getNode() = contextOrigin and
    sink.getNode() = connectionCreation and
    sink.getState().allowsInsecureVersion(insecure_version) and
    specific = false
  )
  or
  // Connection created from a context specifying `insecure_version`.
  exists(TlsLibrary l |
    connectionCreation = l.insecure_connection_creation(insecure_version) and
    contextOrigin = connectionCreation and
    specific = true
  )
}

/**
 * Holds if `conectionCreation` marks the creation of a connection without reference to a context
 * and allowing `insecure_version`.
 */
predicate unsafe_connection_creation_without_context(
  DataFlow::CallCfgNode connectionCreation, string insecure_version
) {
  exists(TlsLibrary l | connectionCreation = l.insecure_connection_creation(insecure_version))
}

/** Holds if `contextCreation` is creating a context tied to a specific insecure version. */
predicate unsafe_context_creation(DataFlow::CallCfgNode contextCreation, string insecure_version) {
  exists(TlsLibrary l | contextCreation = l.insecure_context_creation(insecure_version))
}
