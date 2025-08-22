/**
 * Provides creation, verification and decoding JSON Web Tokens (JWT).
 */

private import ruby
private import codeql.ruby.ApiGraphs
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.Concepts

/**
 * Provides creation, verification and decoding JSON Web Tokens (JWT).
 */
module Jwt {
  /** A call to `JWT.encode`, considered as a JWT encoding. */
  private class JwtEncode extends JwtEncoding::Range, DataFlow::CallNode {
    JwtEncode() { this = API::getTopLevelMember("JWT").getAMethodCall("encode") }

    override DataFlow::Node getPayload() { result = this.getArgument(0) }

    override DataFlow::Node getAlgorithm() { result = this.getArgument(2) }

    override DataFlow::Node getKey() { result = this.getArgument(1) }

    override predicate signsPayload() {
      not (
        this.getKey().getConstantValue().isStringlikeValue("") or
        this.getKey().(DataFlow::ExprNode).getConstantValue().isNil()
      )
    }
  }

  /** A call to `JWT.decode`, considered as a JWT decoding. */
  private class JwtDecode extends JwtDecoding::Range, DataFlow::CallNode {
    JwtDecode() { this = API::getTopLevelMember("JWT").getAMethodCall("decode") }

    override DataFlow::Node getPayload() { result = this.getArgument(0) }

    override DataFlow::Node getAlgorithm() {
      result = this.getArgument(3).(DataFlow::PairNode).getValue() or
      result =
        this.getArgument(3)
            .(DataFlow::HashLiteralNode)
            .getElementFromKey(any(Ast::ConstantValue cv | cv.isStringlikeValue("algorithm"))) or
      result = this.getArgument(2)
    }

    override DataFlow::Node getKey() { result = this.getArgument(1) }

    override DataFlow::Node getOptions() { result = this.getArgument(3) }

    override predicate verifiesSignature() {
      not this.getArgument(2).getConstantValue().isBoolean(false) and
      not this.getAlgorithm().getConstantValue().isStringlikeValue("none")
      or
      this.getNumberOfArguments() < 3
    }
  }
}
