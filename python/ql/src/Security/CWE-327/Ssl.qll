/**
 * Provides modeling of SSL/TLS functionality of the `ssl` module from the standard library.
 * See https://docs.python.org/3.9/library/ssl.html
 */

private import python
private import semmle.python.ApiGraphs
import TlsLibraryModel

class SslContextCreation extends ContextCreation, DataFlow::CallCfgNode {
  SslContextCreation() { this = API::moduleImport("ssl").getMember("SSLContext").getACall() }

  override ProtocolVersion getProtocol() {
    exists(DataFlow::Node protocolArg, Ssl ssl |
      protocolArg in [this.getArg(0), this.getArgByName("protocol")]
    |
      protocolArg = ssl.specific_version(result).getAValueReachableFromSource()
      or
      protocolArg = ssl.unspecific_version().getAValueReachableFromSource() and
      // see https://docs.python.org/3/library/ssl.html#id7
      result in ["TLSv1", "TLSv1_1", "TLSv1_2", "TLSv1_3"]
    )
    or
    not exists(this.getArg(_)) and
    not exists(this.getArgByName(_)) and
    // see https://docs.python.org/3/library/ssl.html#id7
    result in ["TLSv1", "TLSv1_1", "TLSv1_2", "TLSv1_3"]
  }
}

class SslDefaultContextCreation extends ContextCreation {
  SslDefaultContextCreation() {
    this = API::moduleImport("ssl").getMember("create_default_context").getACall()
  }

  // Allowed insecure versions are "TLSv1" and "TLSv1_1"
  // see https://docs.python.org/3/library/ssl.html#context-creation
  override ProtocolVersion getProtocol() { result in ["TLSv1", "TLSv1_1", "TLSv1_2", "TLSv1_3"] }
}

/** Gets a reference to an `ssl.Context` instance. */
API::Node sslContextInstance() {
  result = API::moduleImport("ssl").getMember(["SSLContext", "create_default_context"]).getReturn()
}

class WrapSocketCall extends ConnectionCreation, DataFlow::MethodCallNode {
  WrapSocketCall() { this = sslContextInstance().getMember("wrap_socket").getACall() }

  override DataFlow::Node getContext() { result = this.getObject() }
}

class OptionsAugOr extends ProtocolRestriction, DataFlow::CfgNode {
  ProtocolVersion restriction;

  OptionsAugOr() {
    exists(AugAssign aa, AttrNode attr, Expr flag |
      aa.getOperation().getOp() instanceof BitOr and
      aa.getTarget() = attr.getNode() and
      attr.getName() = "options" and
      attr.getObject() = node and
      flag =
        API::moduleImport("ssl")
            .getMember("OP_NO_" + restriction)
            .getAValueReachableFromSource()
            .asExpr() and
      (
        aa.getValue() = flag
        or
        impliesBitSet(aa.getValue(), flag, false, false)
      )
    )
  }

  override DataFlow::Node getContext() { result = this }

  override ProtocolVersion getRestriction() { result = restriction }
}

class OptionsAugAndNot extends ProtocolUnrestriction, DataFlow::CfgNode {
  ProtocolVersion restriction;

  OptionsAugAndNot() {
    exists(AugAssign aa, AttrNode attr, Expr flag, UnaryExpr notFlag |
      aa.getOperation().getOp() instanceof BitAnd and
      aa.getTarget() = attr.getNode() and
      attr.getName() = "options" and
      attr.getObject() = node and
      notFlag.getOp() instanceof Invert and
      notFlag.getOperand() = flag and
      flag =
        API::moduleImport("ssl")
            .getMember("OP_NO_" + restriction)
            .getAValueReachableFromSource()
            .asExpr() and
      (
        aa.getValue() = notFlag
        or
        impliesBitSet(aa.getValue(), notFlag, true, true)
      )
    )
  }

  override DataFlow::Node getContext() { result = this }

  override ProtocolVersion getUnrestriction() { result = restriction }
}

/**
 * Holds if
 *   for every bit, _b_:
 *     `wholeHasBitSet` represents that _b_ is set in `whole`
 *     implies
 *     `partHasBitSet` represents that _b_ is set in `part`
 *
 * As an example take `whole` = `part1 & part2`. Then
 * `impliesBitSet(whole, part1, true, true)` holds
 * because for any bit in `whole`, if that bit is set it must also be set in `part1`.
 *
 * Similarly for `whole` = `part1 | part2`. Here
 * `impliesBitSet(whole, part1, false, false)` holds
 * because for any bit in `whole`, if that bit is not set, it cannot be set in `part1`.
 */
predicate impliesBitSet(BinaryExpr whole, Expr part, boolean partHasBitSet, boolean wholeHasBitSet) {
  whole.getOp() instanceof BitAnd and
  (
    wholeHasBitSet = true and partHasBitSet = true and part in [whole.getLeft(), whole.getRight()]
    or
    wholeHasBitSet = true and
    impliesBitSet([whole.getLeft(), whole.getRight()], part, partHasBitSet, wholeHasBitSet)
  )
  or
  whole.getOp() instanceof BitOr and
  (
    wholeHasBitSet = false and partHasBitSet = false and part in [whole.getLeft(), whole.getRight()]
    or
    wholeHasBitSet = false and
    impliesBitSet([whole.getLeft(), whole.getRight()], part, partHasBitSet, wholeHasBitSet)
  )
}

class ContextSetVersion extends ProtocolRestriction, ProtocolUnrestriction, DataFlow::CfgNode {
  ProtocolVersion restriction;

  ContextSetVersion() {
    exists(DataFlow::AttrWrite aw |
      this = aw.getObject() and
      aw.getAttributeName() = "minimum_version" and
      aw.getValue() =
        API::moduleImport("ssl")
            .getMember("TLSVersion")
            .getMember(restriction)
            .getAValueReachableFromSource()
    )
  }

  override DataFlow::Node getContext() { result = this }

  override ProtocolVersion getRestriction() { result.lessThan(restriction) }

  override ProtocolVersion getUnrestriction() {
    restriction = result or restriction.lessThan(result)
  }
}

// class UnspecificSslContextCreation extends SslContextCreation, UnspecificContextCreation {
//   // UnspecificSslContextCreation() { library instanceof Ssl }
//   override ProtocolVersion getProtocol() {
//     result = UnspecificContextCreation.super.getProtocol() and
//     // These are turned off by default since Python 3.6
//     // see https://docs.python.org/3.6/library/ssl.html#ssl.SSLContext
//     not result in ["SSLv2", "SSLv3"]
//   }
// }
// class UnspecificSslDefaultContextCreation extends SslDefaultContextCreation {
//   // override DataFlow::Node getContext() { result = this }
//   // see https://docs.python.org/3/library/ssl.html#ssl.create_default_context
//   override ProtocolVersion getProtocol() { result in ["TLSv1", "TLSv1_1", "TLSv1_2", "TLSv1_3"] }
// }
class Ssl extends TlsLibrary {
  Ssl() { this = "ssl" }

  override string specific_version_name(ProtocolVersion version) { result = "PROTOCOL_" + version }

  override string unspecific_version_name() {
    result = "PROTOCOL_SSLv23"
    or
    result = "PROTOCOL_TLS" + ["", "_CLIENT", "_SERVER"]
  }

  override API::Node version_constants() { result = API::moduleImport("ssl") }

  override ContextCreation default_context_creation() {
    result instanceof SslDefaultContextCreation
  }

  override ContextCreation specific_context_creation() { result instanceof SslContextCreation }

  override DataFlow::CallCfgNode insecure_connection_creation(ProtocolVersion version) {
    result = API::moduleImport("ssl").getMember("wrap_socket").getACall() and
    this.specific_version(version).getAValueReachableFromSource() =
      result.getArgByName("ssl_version") and
    version.isInsecure()
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
  }
}
