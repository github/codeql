import python
import semmle.python.ApiGraphs
import TlsLibraryModel

class SSLContextCreation extends ContextCreation {
  override CallNode node;

  SSLContextCreation() { this = API::moduleImport("ssl").getMember("SSLContext").getACall() }

  override DataFlow::CfgNode getProtocol() {
    result.getNode() in [node.getArg(0), node.getArgByName("protocol")]
  }
}

class SSLDefaultContextCreation extends ContextCreation {
  SSLDefaultContextCreation() {
    this = API::moduleImport("ssl").getMember("create_default_context").getACall()
  }

  // Allowed insecure versions are "TLSv1" and "TLSv1_1"
  // see https://docs.python.org/3/library/ssl.html#context-creation
  override DataFlow::CfgNode getProtocol() { none() }
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
    exists(AugAssign aa, AttrNode attr, Expr flag |
      aa.getOperation().getOp() instanceof BitOr and
      aa.getTarget() = attr.getNode() and
      attr.getName() = "options" and
      attr.getObject() = node and
      flag = API::moduleImport("ssl").getMember("OP_NO_" + restriction).getAUse().asExpr() and
      (
        aa.getValue() = flag
        or
        impliesValue(aa.getValue(), flag, false, false)
      )
    )
  }

  override DataFlow::CfgNode getContext() { result = this }

  override ProtocolVersion getRestriction() { result = restriction }
}

class OptionsAugAndNot extends ProtocolUnrestriction {
  ProtocolVersion restriction;

  OptionsAugAndNot() {
    exists(AugAssign aa, AttrNode attr, Expr flag, UnaryExpr notFlag |
      aa.getOperation().getOp() instanceof BitAnd and
      aa.getTarget() = attr.getNode() and
      attr.getName() = "options" and
      attr.getObject() = node and
      notFlag.getOp() instanceof Invert and
      notFlag.getOperand() = flag and
      flag = API::moduleImport("ssl").getMember("OP_NO_" + restriction).getAUse().asExpr() and
      (
        aa.getValue() = notFlag
        or
        impliesValue(aa.getValue(), notFlag, true, true)
      )
    )
  }

  override DataFlow::CfgNode getContext() { result = this }

  override ProtocolVersion getUnrestriction() { result = restriction }
}

/** Whether `part` evaluates to `partIsTrue` if `whole` evaluates to `wholeIsTrue`. */
predicate impliesValue(BinaryExpr whole, Expr part, boolean partIsTrue, boolean wholeIsTrue) {
  whole.getOp() instanceof BitAnd and
  (
    wholeIsTrue = true and partIsTrue = true and part in [whole.getLeft(), whole.getRight()]
    or
    wholeIsTrue = true and
    impliesValue([whole.getLeft(), whole.getRight()], part, partIsTrue, wholeIsTrue)
  )
  or
  whole.getOp() instanceof BitOr and
  (
    wholeIsTrue = false and partIsTrue = false and part in [whole.getLeft(), whole.getRight()]
    or
    wholeIsTrue = false and
    impliesValue([whole.getLeft(), whole.getRight()], part, partIsTrue, wholeIsTrue)
  )
}

class ContextSetVersion extends ProtocolRestriction, ProtocolUnrestriction {
  ProtocolVersion restriction;

  ContextSetVersion() {
    exists(DataFlow::AttrWrite aw |
      aw.getObject().asCfgNode() = node and
      aw.getAttributeName() = "minimum_version" and
      aw.getValue() =
        API::moduleImport("ssl").getMember("TLSVersion").getMember(restriction).getAUse()
    )
  }

  override DataFlow::CfgNode getContext() { result = this }

  override ProtocolVersion getRestriction() { result.lessThan(restriction) }

  override ProtocolVersion getUnrestriction() {
    restriction = result or restriction.lessThan(result)
  }
}

class UnspecificSSLContextCreation extends SSLContextCreation, UnspecificContextCreation {
  UnspecificSSLContextCreation() { library = "ssl" }

  override ProtocolVersion getUnrestriction() {
    result = UnspecificContextCreation.super.getUnrestriction() and
    // These are turned off by default
    // see https://docs.python.org/3/library/ssl.html#ssl-contexts
    not result in ["SSLv2", "SSLv3"]
  }
}

class UnspecificSSLDefaultContextCreation extends SSLDefaultContextCreation, ProtocolUnrestriction {
  override DataFlow::CfgNode getContext() { result = this }

  // see https://docs.python.org/3/library/ssl.html#ssl.create_default_context
  override ProtocolVersion getUnrestriction() {
    result in ["TLSv1", "TLSv1_1", "TLSv1_2", "TLSv1_3"]
  }
}

class Ssl extends TlsLibrary {
  Ssl() { this = "ssl" }

  override string specific_version_name(ProtocolVersion version) { result = "PROTOCOL_" + version }

  override string unspecific_version_name(ProtocolFamily family) {
    family = "SSLv23" and result = "PROTOCOL_" + family
    or
    family = "TLS" and result = "PROTOCOL_" + family + ["", "_CLIENT", "_SERVER"]
  }

  override API::Node version_constants() { result = API::moduleImport("ssl") }

  override ContextCreation default_context_creation() {
    result instanceof SSLDefaultContextCreation
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

  override ProtocolUnrestriction protocol_unrestriction() {
    result instanceof OptionsAugAndNot
    or
    result instanceof ContextSetVersion
    or
    result instanceof UnspecificSSLContextCreation
    or
    result instanceof UnspecificSSLDefaultContextCreation
  }
}
