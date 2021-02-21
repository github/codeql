import python
import TlsLibraryModel

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

class AllowsTLSv1 extends InsecureContextConfiguration {
  AllowsTLSv1() { this = library + "AllowsTLSv1" }

  override string flag() { result = "TLSv1" }
}

class AllowsTLSv1_1 extends InsecureContextConfiguration {
  AllowsTLSv1_1() { this = library + "AllowsTLSv1_1" }

  override string flag() { result = "TLSv1_1" }
}

predicate unsafe_connection_creation(DataFlow::Node node, ProtocolVersion insecure_version) {
  exists(AllowsTLSv1 c | c.hasFlowTo(node)) and
  insecure_version = "TLSv1"
  or
  exists(AllowsTLSv1_1 c | c.hasFlowTo(node)) and
  insecure_version = "TLSv1_1"
  or
  exists(TlsLibrary l | l.insecure_connection_creation(insecure_version) = node)
}

predicate unsafe_context_creation(DataFlow::Node node, string insecure_version) {
  exists(TlsLibrary l, ContextCreation cc | cc = l.insecure_context_creation(insecure_version) |
    cc = node
  )
}
