/**
 * @name Decoding JWT with hardcoded key
 * @description Decoding JWT Secrect with a Constant value lead to authentication or authorization bypass
 * @kind path-problem
 * @problem.severity error
 * @id go/hardcoded-key
 * @tags security
 *       experimental
 *       external/cwe/cwe-321
 */

import go
import semmle.go.security.JWT

module JwtConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source.asExpr() instanceof StringLit }

  predicate isSink(DataFlow::Node sink) {
    exists(FuncDef fd, DataFlow::Node n, DataFlow::ResultNode rn |
      GolangJwtKeyFunc::flow(n, _) and fd = n.asExpr()
    |
      rn.getRoot() = fd and
      rn.getIndex() = 0 and
      sink = rn
    )
    or
    exists(Function fd, DataFlow::ResultNode rn | GolangJwtKeyFunc::flow(fd.getARead(), _) |
      // sink is result of a method
      sink = rn and
      // the method is belong to a function in which is used as a JWT function key
      rn.getRoot() = fd.getFuncDecl() and
      rn.getIndex() = 0
    )
  }
}

module GolangJwtKeyFuncConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source = any(Function f).getARead()
    or
    source.asExpr() = any(FuncDef fd)
  }

  predicate isSink(DataFlow::Node sink) {
    sink =
      [
        any(GolangJwtParse parseWithClaims).getKeyFuncArg(),
        any(GolangJwtParseWithClaims parseWithClaims).getKeyFuncArg(),
        any(GolangJwtParseFromRequest parseWithClaims).getKeyFuncArg(),
        any(GolangJwtParseFromRequestWithClaims parseWithClaims).getKeyFuncArg(),
        any(GoJoseClaims parseWithClaims).getKeyFuncArg(),
      ]
  }
}

module Jwt = TaintTracking::Global<JwtConfig>;

module GolangJwtKeyFunc = TaintTracking::Global<GolangJwtKeyFuncConfig>;

import Jwt::PathGraph

from Jwt::PathNode source, Jwt::PathNode sink
where Jwt::flowPath(source, sink)
select sink.getNode(), source, sink, "This  $@.", source.getNode(),
  "Constant Key is used as JWT Secret key"
