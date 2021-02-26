import python
import TlsLibraryModel

/**
 * Configuration to track flow from the creation of a context to
 * that context being used to create a connection.
 * Flow is broken if the insecure protocol of interest is being restricted.
 */
class InsecureContextConfiguration extends DataFlow::Configuration {
  TlsLibrary library;

  InsecureContextConfiguration() { this = library + ["AllowsTLSv1", "AllowsTLSv1_1"] }

  override predicate isSource(DataFlow::Node source) {
    source = library.unspecific_context_creation()
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = library.connection_creation().getContext()
  }

  abstract string flag();

  override predicate isBarrierOut(DataFlow::Node node) {
    exists(ProtocolRestriction r |
      r = library.protocol_restriction() and
      node = r.getContext() and
      r.getRestriction() = flag()
    )
  }
}

/** Configuration to specifically track the insecure protocol TLS 1.0 */
class AllowsTLSv1 extends InsecureContextConfiguration {
  AllowsTLSv1() { this = library + "AllowsTLSv1" }

  override string flag() { result = "TLSv1" }
}

/** Configuration to specifically track the insecure protocol TLS 1.1 */
class AllowsTLSv1_1 extends InsecureContextConfiguration {
  AllowsTLSv1_1() { this = library + "AllowsTLSv1_1" }

  override string flag() { result = "TLSv1_1" }
}

/**
 * A connection is created from a context allowing an insecure protocol,
 * and that protocol has not been restricted appropriately.
 */
predicate unsafe_connection_creation(
  DataFlow::Node node, ProtocolVersion insecure_version, CallNode call
) {
  // Connection created from a context allowing TLS 1.0.
  exists(AllowsTLSv1 c, ContextCreation cc | c.hasFlow(cc, node) | cc.getNode() = call) and
  insecure_version = "TLSv1"
  or
  // Connection created from a context allowing TLS 1.1.
  exists(AllowsTLSv1_1 c, ContextCreation cc | c.hasFlow(cc, node) | cc.getNode() = call) and
  insecure_version = "TLSv1_1"
  or
  // Connection created from a context for an insecure protocol.
  exists(TlsLibrary l, DataFlow::CfgNode cc |
    cc = l.insecure_connection_creation(insecure_version)
  |
    cc = node and
    cc.getNode() = call
  )
}

/** A connection is created insecurely without reference to a context. */
predicate unsafe_context_creation(DataFlow::Node node, string insecure_version, CallNode call) {
  exists(TlsLibrary l, ContextCreation cc | cc = l.insecure_context_creation(insecure_version) |
    cc = node and
    cc.getNode() = call
  )
}
