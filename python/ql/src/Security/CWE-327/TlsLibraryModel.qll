private import python
private import semmle.python.ApiGraphs
import Ssl
import PyOpenSSL

/**
 * A specific protocol version of SSL or TLS.
 */
class ProtocolVersion extends string {
  ProtocolVersion() { this in ["SSLv2", "SSLv3", "TLSv1", "TLSv1_1", "TLSv1_2", "TLSv1_3"] }

  /** Gets a `ProtocolVersion` that is less than this `ProtocolVersion`, if any. */
  predicate lessThan(ProtocolVersion version) {
    this = "SSLv2" and version = "SSLv3"
    or
    this = "TLSv1" and version = ["TLSv1_1", "TLSv1_2", "TLSv1_3"]
    or
    this = ["TLSv1", "TLSv1_1"] and version = ["TLSv1_2", "TLSv1_3"]
    or
    this = ["TLSv1", "TLSv1_1", "TLSv1_2"] and version = "TLSv1_3"
  }

  /** Holds if this protocol version is known to be insecure. */
  predicate isInsecure() { this in ["SSLv2", "SSLv3", "TLSv1", "TLSv1_1"] }
}

/** An unspecific protocol version */
class ProtocolFamily extends string {
  ProtocolFamily() { this in ["SSLv23", "TLS"] }
}

/** The creation of a context. */
abstract class ContextCreation extends DataFlow::Node {
  /** Gets the protocol version or family for this context. */
  abstract string getProtocol();
}

/** The creation of a connection from a context. */
abstract class ConnectionCreation extends DataFlow::Node {
  /** Gets the context used to create the connection. */
  abstract DataFlow::Node getContext();
}

/** A context is being restricted on which protocols it can accepts. */
abstract class ProtocolRestriction extends DataFlow::Node {
  /** Gets the context being restricted. */
  abstract DataFlow::Node getContext();

  /** Gets the protocol version being disallowed. */
  abstract ProtocolVersion getRestriction();
}

/** A context is being relaxed on which protocols it can accepts. */
abstract class ProtocolUnrestriction extends DataFlow::Node {
  /** Gets the context being relaxed. */
  abstract DataFlow::Node getContext();

  /** Gets the protocol version being allowed. */
  abstract ProtocolVersion getUnrestriction();
}

/**
 * A context is being created with a range of allowed protocols.
 * This also serves as unrestricting these protocols.
 */
abstract class UnspecificContextCreation extends ContextCreation, ProtocolUnrestriction {
  TlsLibrary library;
  ProtocolFamily family;

  UnspecificContextCreation() { this.getProtocol() = family }

  override DataFlow::CfgNode getContext() { result = this }

  override ProtocolVersion getUnrestriction() {
    // There is only one family, the two names are aliases in OpenSSL.
    // see https://github.com/openssl/openssl/blob/13888e797c5a3193e91d71e5f5a196a2d68d266f/include/openssl/ssl.h.in#L1953-L1955
    family in ["SSLv23", "TLS"] and
    // see https://docs.python.org/3/library/ssl.html#ssl-contexts
    result in ["SSLv2", "SSLv3", "TLSv1", "TLSv1_1", "TLSv1_2", "TLSv1_3"]
  }
}

/** A model of a SSL/TLS library. */
abstract class TlsLibrary extends string {
  bindingset[this]
  TlsLibrary() { any() }

  /** Gets the name of a specific protocol version. */
  abstract string specific_version_name(ProtocolVersion version);

  /** Gets a name, which is a member of `version_constants`, that can be used to specify the protocol family `family`. */
  abstract string unspecific_version_name(ProtocolFamily family);

  /** Gets an API node representing the module or class holding the version constants. */
  abstract API::Node version_constants();

  /** Gets an API node representing a specific protocol version. */
  API::Node specific_version(ProtocolVersion version) {
    result = this.version_constants().getMember(this.specific_version_name(version))
  }

  /** Gets an API node representing the protocol family `family`. */
  API::Node unspecific_version(ProtocolFamily family) {
    result = this.version_constants().getMember(this.unspecific_version_name(family))
  }

  /** Gets a creation of a context with a default protocol. */
  abstract ContextCreation default_context_creation();

  /** Gets a creation of a context with a specific protocol. */
  abstract ContextCreation specific_context_creation();

  /** Gets a creation of a context with a specific protocol version, known to be insecure. */
  ContextCreation insecure_context_creation(ProtocolVersion version) {
    result in [this.specific_context_creation(), this.default_context_creation()] and
    result.getProtocol() = version and
    version.isInsecure()
  }

  /** Gets a context that was created using `family`, known to have insecure instances. */
  ContextCreation unspecific_context_creation(ProtocolFamily family) {
    result in [this.specific_context_creation(), this.default_context_creation()] and
    result.getProtocol() = family
  }

  /** Gets a dataflow node representing a connection being created in an insecure manner, not from a context. */
  abstract DataFlow::Node insecure_connection_creation(ProtocolVersion version);

  /** Gets a dataflow node representing a connection being created from a context. */
  abstract ConnectionCreation connection_creation();

  /** Gets a dataflow node representing a context being restricted on which protocols it can accepts. */
  abstract ProtocolRestriction protocol_restriction();

  /** Gets a dataflow node representing a context being relaxed on which protocols it can accepts. */
  abstract ProtocolUnrestriction protocol_unrestriction();
}
