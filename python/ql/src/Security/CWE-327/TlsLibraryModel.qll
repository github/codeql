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

/** The creation of a context. */
abstract class ContextCreation extends DataFlow::CfgNode {
  /** Gets the requested protocol if any. */
  abstract DataFlow::CfgNode getProtocol();
}

/** The creation of a connection from a context. */
abstract class ConnectionCreation extends DataFlow::CfgNode {
  /** Gets the context used to create the connection. */
  abstract DataFlow::CfgNode getContext();
}

/** A context is being restricted on which protocols it can accepts. */
abstract class ProtocolRestriction extends DataFlow::CfgNode {
  /** Gets the context being restricted. */
  abstract DataFlow::CfgNode getContext();

  /** Gets the protocol version being disallowed. */
  abstract ProtocolVersion getRestriction();
}

abstract class TlsLibrary extends string {
  TlsLibrary() { this in ["ssl", "pyOpenSSL"] }

  /** The name of a specific protocol version, known to be insecure. */
  abstract string specific_insecure_version_name(ProtocolVersion version);

  /** The name of an unspecific protocol version, say TLS, known to have insecure instances. */
  abstract string unspecific_version_name();

  /** The module or class holding the version constants. */
  abstract API::Node version_constants();

  /** A dataflow node representing a specific protocol version, known to be insecure. */
  DataFlow::Node insecure_version(ProtocolVersion version) {
    result = version_constants().getMember(specific_insecure_version_name(version)).getAUse()
  }

  /** A dataflow node representing an unspecific protocol version, say TLS, known to have insecure instances. */
  DataFlow::Node unspecific_version() {
    result = version_constants().getMember(unspecific_version_name()).getAUse()
  }

  /** The creation of a context with a deafult protocol. */
  abstract ContextCreation default_context_creation();

  /** The creation of a context with a specific protocol. */
  abstract ContextCreation specific_context_creation();

  /** The creation of a context with a specific protocol version, known to be insecure. */
  ContextCreation insecure_context_creation(ProtocolVersion version) {
    result = specific_context_creation() and
    result.getProtocol() = insecure_version(version)
  }

  /** The creation of a context with an unspecific protocol version, say TLS, known to have insecure instances. */
  DataFlow::CfgNode unspecific_context_creation() {
    result = default_context_creation()
    or
    result = specific_context_creation() and
    result.(ContextCreation).getProtocol() = unspecific_version()
  }

  /** A connection is created in an insecure manner, not from a context. */
  abstract DataFlow::CfgNode insecure_connection_creation(ProtocolVersion version);

  /** A connection is created from a context. */
  abstract ConnectionCreation connection_creation();

  /** A context is being restricted on which protocols it can accepts. */
  abstract ProtocolRestriction protocol_restriction();
}
