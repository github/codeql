/**
 * Provides modeling of SSL/TLS functionality of the `OpenSSL` module from the `pyOpenSSL` PyPI package.
 * See https://www.pyopenssl.org/en/stable/
 */

private import python
private import semmle.python.ApiGraphs
import TlsLibraryModel

class PyOpenSslContextCreation extends ContextCreation, DataFlow::CallCfgNode {
  PyOpenSslContextCreation() {
    this = API::moduleImport("OpenSSL").getMember("SSL").getMember("Context").getACall()
  }

  override ProtocolVersion getProtocol() {
    exists(DataFlow::Node protocolArg, PyOpenSsl pyo |
      protocolArg in [this.getArg(0), this.getArgByName("method")]
    |
      protocolArg = pyo.specific_version(result).getAValueReachableFromSource()
      or
      protocolArg = pyo.unspecific_version().getAValueReachableFromSource() and
      result = any(ProtocolVersion pv)
    )
  }
}

class ConnectionCall extends ConnectionCreation, DataFlow::CallCfgNode {
  ConnectionCall() {
    this = API::moduleImport("OpenSSL").getMember("SSL").getMember("Connection").getACall()
  }

  override DataFlow::CfgNode getContext() {
    result in [this.getArg(0), this.getArgByName("context")]
  }
}

// This cannot be used to unrestrict,
// see https://www.pyopenssl.org/en/stable/api/ssl.html#OpenSSL.SSL.Context.set_options
class SetOptionsCall extends ProtocolRestriction, DataFlow::CallCfgNode {
  SetOptionsCall() { node.getFunction().(AttrNode).getName() = "set_options" }

  override DataFlow::CfgNode getContext() {
    result.getNode() = node.getFunction().(AttrNode).getObject()
  }

  override ProtocolVersion getRestriction() {
    API::moduleImport("OpenSSL")
          .getMember("SSL")
          .getMember("OP_NO_" + result)
          .getAValueReachableFromSource() in [this.getArg(0), this.getArgByName("options")]
  }
}

class PyOpenSsl extends TlsLibrary {
  PyOpenSsl() { this = "pyOpenSSL" }

  override string specific_version_name(ProtocolVersion version) { result = version + "_METHOD" }

  override string unspecific_version_name() {
    // See
    // - https://www.pyopenssl.org/en/23.0.0/api/ssl.html#module-OpenSSL.SSL
    // - https://www.openssl.org/docs/manmaster/man3/DTLS_server_method.html#NOTES
    //
    // PyOpenSSL also allows DTLS
    // see https://www.pyopenssl.org/en/stable/api/ssl.html#OpenSSL.SSL.Context
    // although they are not mentioned here:
    // https://www.pyopenssl.org/en/stable/api/ssl.html#OpenSSL.SSL.TLS_METHOD
    result = ["TLS", "SSLv23"] + "_METHOD"
    or
    result = "TLS_" + ["CLIENT", "SERVER"] + "_METHOD"
  }

  override API::Node version_constants() { result = API::moduleImport("OpenSSL").getMember("SSL") }

  override ContextCreation default_context_creation() { none() }

  override ContextCreation specific_context_creation() {
    result instanceof PyOpenSslContextCreation
  }

  override DataFlow::Node insecure_connection_creation(ProtocolVersion version) { none() }

  override ConnectionCreation connection_creation() { result instanceof ConnectionCall }

  override ProtocolRestriction protocol_restriction() { result instanceof SetOptionsCall }

  override ProtocolUnrestriction protocol_unrestriction() { none() }
}
