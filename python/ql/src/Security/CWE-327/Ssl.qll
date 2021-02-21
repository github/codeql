import python
import semmle.python.ApiGraphs
import semmle.python.dataflow.new.internal.Attributes as Attributes
import TlsLibraryModel

class SSLContextCreation extends ContextCreation {
  override CallNode node;

  SSLContextCreation() { this = API::moduleImport("ssl").getMember("SSLContext").getACall() }

  override DataFlow::CfgNode getProtocol() {
    result.getNode() in [node.getArg(0), node.getArgByName("protocol")]
  }
}

class WrapSocketCall extends ConnectionCreation {
  override CallNode node;

  WrapSocketCall() { node.getFunction().(AttrNode).getName() = "wrap_socket" }

  override DataFlow::CfgNode getContext() {
    result.getNode() = node.getFunction().(AttrNode).getObject()
  }
}

class OptionsAugOr extends ProtocolRestriction {
  ProtocolVersion restriction;

  OptionsAugOr() {
    exists(AugAssign aa, AttrNode attr |
      aa.getOperation().getOp() instanceof BitOr and
      aa.getTarget() = attr.getNode() and
      attr.getName() = "options" and
      attr.getObject() = node and
      API::moduleImport("ssl").getMember("OP_NO_" + restriction).getAUse().asExpr() in [
          aa.getValue(), aa.getValue().getAChildNode()
        ]
    )
  }

  override DataFlow::CfgNode getContext() { result = this }

  override ProtocolVersion getRestriction() { result = restriction }
}

class ContextSetVersion extends ProtocolRestriction {
  string restriction;

  ContextSetVersion() {
    exists(Attributes::AttrWrite aw |
      aw.getObject().asCfgNode() = node and
      aw.getAttributeName() = "minimum_version" and
      aw.getValue() =
        API::moduleImport("ssl").getMember("TLSVersion").getMember(restriction).getAUse()
    )
  }

  override DataFlow::CfgNode getContext() { result = this }

  override ProtocolVersion getRestriction() { result.lessThan(restriction) }
}

class Ssl extends TlsLibrary {
  Ssl() { this = "ssl" }

  override string specific_insecure_version_name(ProtocolVersion version) {
    version in ["SSLv2", "SSLv3", "TLSv1", "TLSv1_1"] and
    result = "PROTOCOL_" + version
    // result in ["PROTOCOL_SSLv2", "PROTOCOL_SSLv3", "PROTOCOL_TLSv1", "PROTOCOL_TLSv1_1"]
  }

  override string unspecific_version_name() {
    result =
      "PROTOCOL_" +
        [
          "TLS",
          // This can negotiate a TLS 1.3 connection (!)
          // see https://docs.python.org/3/library/ssl.html#ssl-contexts
          "SSLv23"
        ]
  }

  override API::Node version_constants() { result = API::moduleImport("ssl") }

  override DataFlow::CfgNode default_context_creation() {
    result = API::moduleImport("ssl").getMember("create_default_context").getACall() //and
    // see https://docs.python.org/3/library/ssl.html#context-creation
    // version in ["TLSv1", "TLSv1_1"]
  }

  override ContextCreation specific_context_creation() { result instanceof SSLContextCreation }

  override DataFlow::CfgNode insecure_connection_creation(ProtocolVersion version) {
    result = API::moduleImport("ssl").getMember("wrap_socket").getACall() and
    insecure_version(version).asCfgNode() =
      result.asCfgNode().(CallNode).getArgByName("ssl_version")
  }

  override ConnectionCreation connection_creation() { result instanceof WrapSocketCall }

  override ProtocolRestriction protocol_restriction() {
    result instanceof OptionsAugOr
    or
    result instanceof ContextSetVersion
  }
}
