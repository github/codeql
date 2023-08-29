/**
 * @name Usage of Constant Secret key for decoding JWT
 * @description Hardcoded Secrets leakage can lead to authentication or authorization bypass
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id javascript/jwt-hardcodedkey
 * @tags security
 *       experimental
 *       external/cwe/CWE-321
 */

import javascript
import DataFlow::PathGraph
import DataFlow

class JWTDecodeConfig extends TaintTracking::Configuration {
  JWTDecodeConfig() { this = "JWTConfig" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof StringLiteral or source.asExpr() instanceof TemplateLiteral
  }

  override predicate isSink(DataFlow::Node sink) {
    // any() or
    sink = API::moduleImport("jsonwebtoken").getMember(["sign", "verify"]).getParameter(1).asSink() or
    sink = API::moduleImport("jose").getMember("jwtVerify").getParameter(1).asSink() or
    sink = API::moduleImport("jwt-simple").getMember("decode").getParameter(1).asSink() or
    sink = API::moduleImport("next-auth").getParameter(0).getMember("secret").asSink() or
    sink = API::moduleImport("koa-jwt").getParameter(0).getMember("secret").asSink() or
    sink =
      API::moduleImport("express-jwt")
          .getMember("expressjwt")
          .getParameter(0)
          .getMember("secret")
          .asSink() or
    sink =
      API::moduleImport("passport-jwt")
          .getMember("Strategy")
          .getParameter(0)
          .getMember("secretOrKey")
          .asSink()
  }

  override predicate isAdditionalTaintStep(DataFlow::Node pred, DataFlow::Node succ) {
    exists(DataFlow::CallNode n, DataFlow::NewNode nn |
      n.getCalleeName() = "encode" and
      nn.flowsTo(n.getReceiver()) and
      nn.getCalleeName() = "TextEncoder"
    |
      pred = n.getArgument(0) and
      succ = n
    )
    or
    exists(API::Node n | n = API::moduleImport("jose").getMember("importSPKI") |
      pred = n.getACall().getArgument(0) and
      succ = n.getReturn().getPromised().asSource()
    )
    or
    exists(API::Node n | n = API::moduleImport("jose").getMember("base64url").getMember("decode") |
      pred = n.getACall().getArgument(0) and
      succ = n.getACall()
    )
    or
    exists(DataFlow::CallNode n | n = DataFlow::globalVarRef("Buffer").getAMemberCall("from") |
      pred = n.getArgument(0) and
      succ = [n, n.getAChainedMethodCall(["toString", "toJSON"])]
    )
  }
}

from JWTDecodeConfig cfg, DataFlow::PathNode source, DataFlow::PathNode sink
where cfg.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "this $@. is used as a secret key", source.getNode(),
  "Constant"
