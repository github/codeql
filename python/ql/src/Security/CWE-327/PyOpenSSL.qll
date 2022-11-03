/**
 * Provides modeling of SSL/TLS functionality of the `OpenSSL` module from the `pyOpenSSL` PyPI package.
 * See https://www.pyopenssl.org/en/stable/
 */

private import python
private import semmle.python.ApiGraphs
import TlsLibraryModel

class PyOpenSSLContextCreation extends ContextCreation, DataFlow::CallCfgNode {
  PyOpenSSLContextCreation() {
    this = API::moduleImport("OpenSSL").getMember("SSL").getMember("Context").getACall()
  }

  override string getProtocol() {
    exists(DataFlow::Node protocolArg, PyOpenSSL pyo |
      protocolArg in [this.getArg(0), this.getArgByName("method")]
    |
      protocolArg in [
          pyo.specific_version(result).getAUse(), pyo.unspecific_version(result).getAUse()
        ]
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
    API::moduleImport("OpenSSL").getMember("SSL").getMember("OP_NO_" + result).getAUse() in [
        this.getArg(0), this.getArgByName("options")
      ]
  }
}

class UnspecificPyOpenSSLContextCreation extends PyOpenSSLContextCreation, UnspecificContextCreation {
  UnspecificPyOpenSSLContextCreation() { library instanceof PyOpenSSL }
}

class PyOpenSSL extends TlsLibrary {
  PyOpenSSL() { this = "pyOpenSSL" }

  override string specific_version_name(ProtocolVersion version) { result = version + "_METHOD" }

  override string unspecific_version_name(ProtocolFamily family) {
    // `"TLS_METHOD"` is not actually available in pyOpenSSL yet, but should be coming soon..
    result = family + "_METHOD"
  }

  override API::Node version_constants() { result = API::moduleImport("OpenSSL").getMember("SSL") }

  override ContextCreation default_context_creation() { none() }

  override ContextCreation specific_context_creation() {
    result instanceof PyOpenSSLContextCreation
  }

  override DataFlow::Node insecure_connection_creation(ProtocolVersion version) { none() }

  override ConnectionCreation connection_creation() { result instanceof ConnectionCall }

  override ProtocolRestriction protocol_restriction() { result instanceof SetOptionsCall }

  override ProtocolUnrestriction protocol_unrestriction() {
    result instanceof UnspecificPyOpenSSLContextCreation
  }
}
