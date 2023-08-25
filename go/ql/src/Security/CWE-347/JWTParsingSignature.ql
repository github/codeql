/**
 * @name JWT Insecure Parsing
 * @description Parsing JWT tokens without checking the signature may result in an authentication bypass
 * @kind problem
 * @problem.severity error
 * @security-severity 8.0
 * @precision medium
 * @id go/jwt-insecure-signing
 * @tags security
 *       external/cwe/cwe-347
 */
import go
import JWT
import DataFlow
from CallNode c, LestrratParse lp
where c.getTarget() instanceof LestrratParseInsecure or c.getTarget() instanceof UnafeJWTParserMethod
 or (c.getTarget() = lp and not exists(LestrratSafeOptions lwk | c.getCall().getAnArgument() = lwk.getACall().asExpr()
 and not(c.getCall().getArgument(0) = lwk.getACall().asExpr())))
select c, "test"


//lestrrat uses WithKeys or Keysets
// from LestrratParse lp, LestrratSafeOptions lwk, CallExpr c
// where c.getTarget() = lp and not (c.getAnArgument() = lwk.getACall().asExpr() 
// and not(c.getArgument(0) = lwk.getACall().asExpr()))
// select c, "test"

