/**
 * @name Missing JWT signature check
 * @description Failing to check the Json Web Token (JWT) signature may allow an attacker to forge their own tokens.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision high
 * @id java/missing-jwt-signature-check
 * @tags security
 *       external/cwe/cwe-347
 */

import java
import semmle.code.java.security.MissingJWTSignatureCheckQuery
import MissingJwtSignatureCheckFlow::PathGraph

from MissingJwtSignatureCheckFlow::PathNode source, MissingJwtSignatureCheckFlow::PathNode sink
where MissingJwtSignatureCheckFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "This parser sets a $@, but the signature is not verified.",
  source.getNode(), "JWT signing key"
