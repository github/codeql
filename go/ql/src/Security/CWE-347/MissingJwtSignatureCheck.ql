/**
 * @name Missing JWT signature check
 * @description Failing to check the JSON Web Token (JWT) signature may allow an attacker to forge their own tokens.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id go/missing-jwt-signature-check
 * @tags security
 *       external/cwe/cwe-347
 */

import go
import semmle.go.security.MissingJwtSignatureCheck
import MissingJwtSignatureCheck::Flow::PathGraph

from MissingJwtSignatureCheck::Flow::PathNode source, MissingJwtSignatureCheck::Flow::PathNode sink
where MissingJwtSignatureCheck::Flow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "This JWT is parsed without verification and received from $@.", source.getNode(),
  "this user-controlled source"
