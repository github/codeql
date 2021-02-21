import python
import semmle.python.ApiGraphs
import Ssl
import PyOpenSSL

/**
 * A specific protocol version.
 * We use this to identify a protocol.
 */
class ProtocolVersion extends string {
  ProtocolVersion() { this in ["SSLv2", "SSLv3", "TLSv1", "TLSv1_1", "TLSv1_2", "TLSv1_3"] }

  predicate lessThan(ProtocolVersion version) {
    this = "SSLv2" and version = "SSLv3"
    or
    this = "TLSv1" and version = ["TLSv1_1", "TLSv1_2", "TLSv1_3"]
    or
    this = ["TLSv1", "TLSv1_1"] and version = ["TLSv1_2", "TLSv1_3"]
    or
    this = ["TLSv1", "TLSv1_1", "TLSv1_2"] and version = "TLSv1_3"
  }
}

abstract class ContextCreation extends DataFlow::CfgNode {
  abstract DataFlow::CfgNode getProtocol();
}

abstract class ConnectionCreation extends DataFlow::CfgNode {
  abstract DataFlow::CfgNode getContext();
}

abstract class ProtocolRestriction extends DataFlow::CfgNode {
  abstract DataFlow::CfgNode getContext();

  abstract ProtocolVersion getRestriction();
}

abstract class TlsLibrary extends string {
  TlsLibrary() { this in ["ssl", "pyOpenSSL"] }

  /** The name of a specific protocol version, known to be insecure. */
  abstract string specific_insecure_version_name(ProtocolVersion version);

  /** The name of an unspecific protocol version, say TLS, known to have insecure insatnces. */
  abstract string unspecific_version_name();

  abstract API::Node version_constants();

  DataFlow::Node insecure_version(ProtocolVersion version) {
    result = version_constants().getMember(specific_insecure_version_name(version)).getAUse()
  }

  DataFlow::Node unspecific_version() {
    result = version_constants().getMember(unspecific_version_name()).getAUse()
  }

  abstract DataFlow::CfgNode default_context_creation();

  abstract ContextCreation specific_context_creation();

  ContextCreation insecure_context_creation(ProtocolVersion version) {
    result = specific_context_creation() and
    result.getProtocol() = insecure_version(version)
  }

  DataFlow::CfgNode unspecific_context_creation() {
    result = default_context_creation()
    or
    result = specific_context_creation() and
    result.(ContextCreation).getProtocol() = unspecific_version()
  }

  /** A connection is created in an outright insecure manner. */
  abstract DataFlow::CfgNode insecure_connection_creation(ProtocolVersion version);

  /** A connection is created from a context. */
  abstract ConnectionCreation connection_creation();

  abstract ProtocolRestriction protocol_restriction();
}
