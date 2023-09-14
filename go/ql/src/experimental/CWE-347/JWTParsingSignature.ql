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

from CallNode c
where
  c.getTarget() instanceof LestrratParseInsecure
  or
  c.getTarget() instanceof UnafeJwtParserMethod
  or
  c.getTarget() instanceof LestrratParsev1 and
  not exists(LestrratVerify lv |
    c.getCall().getAnArgument() = lv.getACall().asExpr() and
    not c.getCall().getArgument(0) = lv.getACall().asExpr()
  )
select c,
  "This call to Parse to accept JWT token does not check the signature, which may allow an attacker to forget tokens"
