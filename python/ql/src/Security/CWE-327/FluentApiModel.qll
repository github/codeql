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
 * A connection is created from a context allowing an insecure protocol,
 * and that protocol has not been restricted appropriately.
 */
predicate unsafe_connection_creation(
  DataFlow::Node creation, ProtocolVersion insecure_version, DataFlow::Node source, boolean specific
) {
  // Connection created from a context allowing `insecure_version`.
  exists(InsecureContextConfiguration c, ProtocolUnrestriction cc | c.hasFlow(cc, creation) |
    insecure_version = c.getTrackedVersion() and
    source = cc and
    specific = false
  )
  or
  // Connection created from a context specifying `insecure_version`.
  exists(TlsLibrary l, DataFlow::CfgNode cc |
    cc = l.insecure_connection_creation(insecure_version)
  |
    creation = cc and
    source = cc and
    specific = true
  )
}

/** A connection is created insecurely without reference to a context. */
predicate unsafe_context_creation(DataFlow::Node node, string insecure_version, CallNode call) {
  exists(TlsLibrary l, ContextCreation cc | cc = l.insecure_context_creation(insecure_version) |
    cc = node and
    cc.getNode() = call
  )
}
