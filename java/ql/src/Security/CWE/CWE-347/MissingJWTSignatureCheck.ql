/**
 * @name Missing JWT signature check
 * @description Failing to check the JWT signature may allow an attacker to forge their own tokens.
 * @kind problem
 * @problem.severity error
 * @precision high
 * @id java/missing-jwt-signature-check
 * @tags security
 *       external/cwe/cwe-347
 */

import java
import semmle.code.java.security.JWTQuery

from JwtParserWithInsecureParseSink sink, JwtParserWithSigningKeyExpr parserExpr
where sink.asExpr() = parserExpr
select sink.getParseMethodAccess(), "A signing key is set $@, but the signature is not verified.",
  parserExpr.getSigningMethodAccess(), "here"
