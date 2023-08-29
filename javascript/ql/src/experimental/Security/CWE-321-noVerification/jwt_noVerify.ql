/**
 * @name JWT missing secret or public key verification
 * @description The application does not verify the JWT payload with a cryptographic secret or public key.
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.0
 * @precision high
 * @id js/jwt-missing-verification
 * @tags security
 *       external/cwe/cwe-347
 */

import javascript

from DataFlow::Node sink
where
  sink = API::moduleImport("jsonwebtoken").getMember("decode").getParameter(0).asSink()
  or
  sink = API::moduleImport("jwt-decode").getParameter(0).asSink()
  or
  sink = API::moduleImport("jose").getMember("decodeJwt").getParameter(0).asSink()
  or
  exists(API::Node n | n = API::moduleImport("jwt-simple").getMember("decode") |
    n.getParameter(2).asSink().asExpr() = any(BoolLiteral b | b.getBoolValue() = true) and
    sink = n.getParameter(0).asSink()
  )
select sink, "This Token is Decoding in unsafe mode"
