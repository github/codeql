import python
import TlsLibraryModel

/**
 * Configuration to track flow from the creation of a context to
 * that context being used to create a connection.
 * Flow is broken if the insecure protocol of interest is being restricted.
 */
class InsecureContextConfiguration extends DataFlow::Configuration {
  TlsLibrary library;
  ProtocolVersion tracked_version;

  InsecureContextConfiguration() {
    this = library + "Allows" + tracked_version and
    tracked_version.isInsecure()
  }

  ProtocolVersion getTrackedVersion() { result = tracked_version }

  override predicate isSource(DataFlow::Node source) {
    // source = library.unspecific_context_creation()
    exists(ProtocolUnrestriction pu |
      pu = library.protocol_unrestriction() and
      pu.getUnrestriction() = tracked_version
    |
      source = pu.getContext()
    )
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = library.connection_creation().getContext()
  }

  override predicate isBarrierOut(DataFlow::Node node) {
    exists(ProtocolRestriction r |
      r = library.protocol_restriction() and
      node = r.getContext() and
      r.getRestriction() = tracked_version
    )
  }

  override predicate isBarrierIn(DataFlow::Node node) { this.isSource(node) }
}

/**
 * Holds if `conectionCreation` marks the creation of a connetion based on the contex
 * found at `contextOrigin` and allowing `insecure_version`.
 * `specific` is true iff the context if configured for a specific protocol version rather
 * than for a family of protocols.
 */
predicate unsafe_connection_creation_with_context(
  DataFlow::Node connectionCreation, ProtocolVersion insecure_version, DataFlow::Node contextOrigin,
  boolean specific
) {
  // Connection created from a context allowing `insecure_version`.
  exists(InsecureContextConfiguration c, ProtocolUnrestriction co |
    c.hasFlow(co, connectionCreation)
  |
    insecure_version = c.getTrackedVersion() and
    contextOrigin = co and
    specific = false
  )
  or
  // Connection created from a context specifying `insecure_version`.
  exists(TlsLibrary l, DataFlow::CfgNode cc |
    cc = l.insecure_connection_creation(insecure_version)
  |
    connectionCreation = cc and
    contextOrigin = cc and
    specific = true
  )
}

/**
 * Holds if `conectionCreation` marks the creation of a connetion witout reference to a context
 * and allowing `insecure_version`.
 * `specific` is true iff the context if configured for a specific protocol version rather
 * than for a family of protocols.
 */
predicate unsafe_connection_creation_without_context(
  DataFlow::CallCfgNode connectionCreation, string insecure_version
) {
  exists(TlsLibrary l | connectionCreation = l.insecure_connection_creation(insecure_version))
}

/** Holds if `contextCreation` is creating a context ties to a specific insecure version. */
predicate unsafe_context_creation(DataFlow::CallCfgNode contextCreation, string insecure_version) {
  exists(TlsLibrary l, ContextCreation cc | cc = l.insecure_context_creation(insecure_version) |
    contextCreation = cc
  )
}
