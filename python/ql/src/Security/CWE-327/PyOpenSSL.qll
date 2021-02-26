import python
import semmle.python.ApiGraphs
import TlsLibraryModel

class PyOpenSSLContextCreation extends ContextCreation {
  override CallNode node;

  PyOpenSSLContextCreation() {
    this = API::moduleImport("OpenSSL").getMember("SSL").getMember("Context").getACall()
  }

  override DataFlow::CfgNode getProtocol() {
    result.getNode() in [node.getArg(0), node.getArgByName("method")]
  }
}

class ConnectionCall extends ConnectionCreation {
  override CallNode node;

  ConnectionCall() {
    this = API::moduleImport("OpenSSL").getMember("SSL").getMember("Connection").getACall()
  }

  override DataFlow::CfgNode getContext() {
    result.getNode() in [node.getArg(0), node.getArgByName("context")]
  }
}

class SetOptionsCall extends ProtocolRestriction {
  override CallNode node;

  SetOptionsCall() { node.getFunction().(AttrNode).getName() = "set_options" }

  override DataFlow::CfgNode getContext() {
    result.getNode() = node.getFunction().(AttrNode).getObject()
  }

  override ProtocolVersion getRestriction() {
    API::moduleImport("OpenSSL").getMember("SSL").getMember("OP_NO_" + result).getAUse().asCfgNode() in [
        node.getArg(0), node.getArgByName("options")
      ]
  }
}

class PyOpenSSL extends TlsLibrary {
  PyOpenSSL() { this = "pyOpenSSL" }

  override string specific_insecure_version_name(ProtocolVersion version) {
    version in ["SSLv2", "SSLv3", "TLSv1", "TLSv1_1"] and
    result = version + "_METHOD"
  }

  override string unspecific_version_name() {
    result in [
        "TLS_METHOD", // This is not actually available in pyOpenSSL yet
        "SSLv23_METHOD" // This is what can negotiate TLS 1.3 (indeed, I know, I did test that..)
      ]
  }

  override API::Node version_constants() { result = API::moduleImport("OpenSSL").getMember("SSL") }

  override ContextCreation default_context_creation() { none() }

  override ContextCreation specific_context_creation() {
    result instanceof PyOpenSSLContextCreation
  }

  override DataFlow::CfgNode insecure_connection_creation(ProtocolVersion version) { none() }

  override ConnectionCreation connection_creation() { result instanceof ConnectionCall }

  override ProtocolRestriction protocol_restriction() { result instanceof SetOptionsCall }
}
