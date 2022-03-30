private import python
private import semmle.python.dataflow.new.DataFlow
import TlsLibraryModel

/**
 * Configuration to determine the state of a context being used to create
 * a connection. There is one configuration for each pair of `TlsLibrary` and `ProtocolVersion`,
 * such that a single configuration only tracks contexts where a specific `ProtocolVersion` is allowed.
 *
 * The state is in terms of whether a specific protocol is allowed. This is
 * either true or false when the context is created and can then be modified
 * later by either restricting or unrestricting the protocol (see the predicates
 * `isRestriction` and `isUnrestriction`).
 *
 * Since we are interested in the final state, we want the flow to start from
 * the last unrestriction, so we disallow flow into unrestrictions. We also
 * model the creation as an unrestriction of everything it allows, to account
 * for the common case where the creation plays the role of "last unrestriction".
 *
 * Since we really want "the last unrestriction, not nullified by a restriction",
 * we also disallow flow into restrictions.
 */
class InsecureContextConfiguration extends DataFlow::Configuration {
  TlsLibrary library;
  ProtocolVersion tracked_version;

  InsecureContextConfiguration() {
    this = library + "Allows" + tracked_version and
    tracked_version.isInsecure()
  }

  ProtocolVersion getTrackedVersion() { result = tracked_version }

  override predicate isSource(DataFlow::Node source) { this.isUnrestriction(source) }

  override predicate isSink(DataFlow::Node sink) {
    sink = library.connection_creation().getContext()
  }

  override predicate isBarrierIn(DataFlow::Node node) {
    this.isRestriction(node)
    or
    this.isUnrestriction(node)
  }

  private predicate isRestriction(DataFlow::Node node) {
    exists(ProtocolRestriction r |
      r = library.protocol_restriction() and
      r.getRestriction() = tracked_version
    |
      node = r.getContext()
    )
  }

  private predicate isUnrestriction(DataFlow::Node node) {
    exists(ProtocolUnrestriction pu |
      pu = library.protocol_unrestriction() and
      pu.getUnrestriction() = tracked_version
    |
      node = pu.getContext()
    )
  }
}

/**
 * Holds if `conectionCreation` marks the creation of a connetion based on the contex
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
  exists(InsecureContextConfiguration c | c.hasFlow(contextOrigin, connectionCreation) |
    insecure_version = c.getTrackedVersion() and
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
 * Holds if `conectionCreation` marks the creation of a connetion witout reference to a context
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
